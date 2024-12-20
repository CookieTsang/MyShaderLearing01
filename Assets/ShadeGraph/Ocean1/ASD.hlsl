#ifndef __ASD__
#define __ASD__
void getFlowNormal_float(float2 uv, UnityTexture2D flowTex, UnityTexture2D normalTex, float4 normalTex_ST,float speed,out float3 flowNormal) 
// 参数：  
// - float2 uv: 纹理坐标  
// - UnityTexture2D flowTex: 流动纹理  
// - UnityTexture2D normalTex: 法线纹理  
// - float4 normalTex_ST: 用于法线纹理的平移和缩放参数  
// - float speed: 流动速度  
// 输出参数：  
// - out float3 flowNormal: 计算得到的流动法线  
{
    uv *= normalTex_ST.xy;// 根据法线纹理的缩放和偏移参数调整 uv 坐标 
    float4 v_flowTex = SAMPLE_TEXTURE2D(flowTex.tex, flowTex.samplerstate, uv) * 2.0 - 1.0; // 从流动纹理中采样，得到一个范围在 [-1, 1] 的值，并将其存储在 v_flowTex 中 
    float2 flow_dir = v_flowTex.xy;  // uv 扰动方向向量
    float noise = v_flowTex.a;

    float phase = _Time.x * speed;
    float phase0 = frac(phase + noise);
    float phase1 = frac(phase + 0.5 + noise);  // +0.5 使两个相位的波峰波谷交错出现

    float2 uv_jump = float2(0.25, 0.1);
    float2 phase0_jump = (phase - phase0) * uv_jump;
    float2 phase1_jump = (phase - phase1) * uv_jump;

    float2 uv_st = uv * normalTex_ST.xy + normalTex_ST.zw;

    float2 uv0 = uv_st - phase0 * flow_dir + phase0_jump;
    float2 uv1 = uv_st - phase1 * flow_dir + phase1_jump;

    float4 tex0 = SAMPLE_TEXTURE2D(normalTex.tex, normalTex.samplerstate, uv0);
    float4 tex1 = SAMPLE_TEXTURE2D(normalTex.tex, normalTex.samplerstate, uv1);

    float flowLerp = abs(1 - 2 * phase0);
    flowNormal = lerp(tex0, tex1, flowLerp);
}
//void getFlowNormal_float(float2 uv, UnityTexture2D flowTex, UnityTexture2D normalTex, float4 normalTex_ST,
//    float speed,
//    out float3 flowNormal) {
//    uv *= normalTex_ST.xy;
//    float4 v_flowTex = SAMPLE_TEXTURE2D(flowTex.tex, flowTex.samplerstate, uv) * 2.0 - 1.0;
//    float2 flow_dir = v_flowTex.xy;  // uv 扰动方向向量
//
//    float phase0 = frac(_Time.x * speed);
//    float phase1 = frac(_Time.x * speed + 0.5);  // +0.5 使两个相位的波峰波谷交错出现
//
//    float2 uv_st = uv * normalTex_ST.xy + normalTex_ST.zw;
//
//    float4 tex0 = SAMPLE_TEXTURE2D(normalTex.tex, normalTex.samplerstate, uv_st - phase0 * flow_dir);
//    float4 tex1 = SAMPLE_TEXTURE2D(normalTex.tex, normalTex.samplerstate, uv_st - phase1 * flow_dir);
//
//    float flowLerp = abs(1 - 2 * phase0);
//    flowNormal = lerp(tex0, tex1, flowLerp);
//}
#endif