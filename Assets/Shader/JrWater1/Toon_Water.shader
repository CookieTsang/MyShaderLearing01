//水的深度
Shader "Learning/Toon_Water"
{
    Properties {
    _WaterColor1("WaterColor1",Color) = (1,1,1,1)
    _WaterColor2("WaterColor2",Color) = (1,1,1,1)
    _FoamTex("FoamTex",2D) = "white"{}
    _WaterSpeed("WaterSpeed",Float)=1
    _FoamNoise("FoamNoise",Range(0,8))=1
    _FoamRange("FoamRange",Range(0,5))=1
    _FoamColor("FoamColor",Color)=(1,1,1,1)
    _DistortTex("DistortNormalTex",2D) = "white"{}
    _Distort("Distort",Range(0.0,1.5))=0

    _SpecularColor("Specular Color",Color) = (1,1,1,1)
    _SpecularIntensity("Specular Intensity",Float) = 0.6
    _Smoothness("Smoothness",Float) = 10
    _CausticsTex("CausticsTex",2D)="white"{}

    _NormalTex("NormalTex",2D) = "white"{}
    _NormalIntensity("NormalIntensity",Range(0,5))=1
    _ReflectionTex("ReflectionTex",Cube) = "white"{}
    [PowerSlider(3)]_NormalIntensity("NormalIntensity",Range(0,1)) = 0.5
    }
    
    SubShader
    {
        Tags
        {

            "RenderPipeline"="UniversalPipeline"

            "RenderType"="Transparent"

            "Queue"="Transparent"
        }
        //Blend One One
        ZWrite Off
        Pass
        {
            Name "Unlit"
          
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // Pragmas
            #pragma target 2.0
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float4 _WaterColor1;
            float4 _WaterColor2;
            float4 _FoamTex_ST;
            float _WaterSpeed;
            float _FoamNoise;
            float _FoamRange;
            float4 _FoamColor;
            half4 _DistortTex_ST;
            float _Distort;
            float4 _SpecularColor;
            float _SpecularIntensity;
            float _Smoothness;
            float4 _NormalTex_ST;
            float _NormalIntensity;
            float4 _CausticsTex_ST;
            CBUFFER_END

            
            TEXTURE2D(_CameraDepthTexture);SAMPLER(sampler_CameraDepthTexture);
            TEXTURE2D(_CameraOpaqueTexture);SAMPLER(sampler_CameraOpaqueTexture);
            TEXTURE2D(_FoamTex);SAMPLER(sampler_FoamTex);
            TEXTURE2D(_DistortTex);SAMPLER(sampler_DistortTex);
            TEXTURE2D(_NormalTex);SAMPLER(sampler_NormalTex);
            TEXTURE2D(_CausticsTex);SAMPLER(sampler_CausticsTex);
            TEXTURECUBE(_ReflectionTex);SAMPLER(sampler_ReflectionTex);

            //struct appdata
            //顶点着色器的输入
            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS:NORMAL;
            };
            //struct v2f
            //片元着色器的输入
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                float3 positionVS : TEXCOORD2;
                float3 positionWS:TEXCOORD3;
                float3 normalWS:TEXCOORD4;
                float4 normalUV : TEXCOORD5;
            };
            //v2f vert(Attributes v)
            //顶点着色器
            Varyings vert(Attributes v)
            {
                Varyings o = (Varyings)0;
                o.positionWS = TransformObjectToWorld(v.positionOS);
                o.positionVS = TransformWorldToView(o.positionWS);
                o.positionCS = TransformWViewToHClip(o.positionVS);
                o.uv.zw += o.positionWS.xz *_FoamTex_ST.xy + _Time.y * _WaterSpeed;
                o.uv.xy = TRANSFORM_TEX(v.uv,_DistortTex)+_Time.y * _WaterSpeed;
                o.normalUV.xy = TRANSFORM_TEX(v.uv,_NormalTex) + _Time.y * _WaterSpeed;
                o.normalUV.zw = TRANSFORM_TEX(v.uv,_NormalTex) + _Time.y * _WaterSpeed * half2(-1,1);
                o.normalWS = TransformObjectToWorldNormal(v.normalOS);
                o.screenPos = ComputeScreenPos(o.positionCS);
                return o;
            }
            //fixed4 frag(v2f i) : SV_TARGET
            //片元着色器
            half4 frag(Varyings i) : SV_TARGET
            {
                half4 normalTex1 = SAMPLE_TEXTURE2D(_NormalTex,sampler_NormalTex,i.normalUV.xy);
                half4 normalTex2 = SAMPLE_TEXTURE2D(_NormalTex,sampler_NormalTex,i.normalUV.zw);
                half4 normalTex = normalTex1 * normalTex2;
                //1、水的深度
                //获取屏幕空间下的 UV 坐标
                float2 screenUV = i.positionCS.xy / _ScreenParams.xy;
                half depthTex = SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture,screenUV).x;
                float2 distortUV = screenUV * _Distort + normalTex.xy;
                half4 depthDistortTex = SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture,distortUV);
                //深度图转化到观察空间下
                float depthScene = LinearEyeDepth(depthTex,_ZBufferParams);
                float4 depthWater = depthScene + i.positionVS.z;
                half depthDistortScene = LinearEyeDepth(depthDistortTex.x,_ZBufferParams);
                float4 depthVS = 1;
                depthVS.xy = i.positionVS.xy * depthDistortScene / -i.positionVS.z;
                depthVS.z = depthDistortScene;
                float4 depthWS = mul(unity_CameraToWorld,depthVS);
                float4 depthOS = mul(unity_WorldToObject,depthWS);
                float2 uv1 = depthOS.xz * _CausticsTex_ST.xy + depthWS.y *0.1+ _Time.y * _WaterSpeed;
                float2 uv2 = depthOS.xz * _CausticsTex_ST.xy + depthWS.y *0.1+ _Time.y * _WaterSpeed * float2(-1.1,1.3);
                half4 causticsTex1 = SAMPLE_TEXTURE2D(_CausticsTex,sampler_CausticsTex,uv1);
                half4 causticsTex2 = SAMPLE_TEXTURE2D(_CausticsTex,sampler_CausticsTex,uv2);
                half4 causticsTex = min(causticsTex1,causticsTex2);
                //获取水面模型顶点在观察空间下的Z值（可以在顶点着色器中，对其直接进行转化得到顶点观察空间下的坐标）
                half4 waterColor = lerp(_WaterColor1,_WaterColor2,depthWater);
                
                half4 foamRange = depthWater * _FoamRange;
                //2、水的高光

                half4 N = normalize(normalTex);
                Light light = GetMainLight();
                half3 L = light.direction;
                half3 V = normalize(_WorldSpaceCameraPos.xyz - i.positionWS.xyz);
                half3 H = normalize(L + V);
                half4 specular = _SpecularColor * _SpecularIntensity * pow(max(0,dot(N,H)),_Smoothness);
                //3、水的反射
                 N = lerp(half4(i.normalWS,1),normalize(normalTex),_NormalIntensity);
                 V = normalize(_WorldSpaceCameraPos.xyz - i.positionWS.xyz);
                half3 reflectionUV = reflect(-V,N.xyz);
                half4 reflectionTex = SAMPLE_TEXTURECUBE(_ReflectionTex,sampler_ReflectionTex,reflectionUV);
                half fresnel = 1 - saturate(dot(i.normalWS,V));
                half4 reflection = reflectionTex * fresnel;
                //4、水的焦散

                //5、水下的扭曲
                half4 distortTex = SAMPLE_TEXTURE2D(_DistortTex,sampler_DistortTex,i.uv.xy);
                
                half4 cameraOpaqueTex = SAMPLE_TEXTURE2D(_CameraOpaqueTexture,sampler_CameraOpaqueTexture,distortUV);
                //6、水面泡沫
                half4 foamTex = SAMPLE_TEXTURE2D(_FoamTex,sampler_FoamTex,i.uv.zw);
                foamTex = pow(foamTex,_FoamNoise);
                half4 foamMask = step(foamRange,foamTex);
                half4 foamColor = foamMask * _FoamColor;

                half4 col = (foamColor + waterColor) * cameraOpaqueTex + (specular * reflection) + causticsTex;
                col = (foamColor + waterColor) * cameraOpaqueTex + (specular * reflection);
                return col;
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
