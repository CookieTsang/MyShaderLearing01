#ifndef __GerstnerWave__
#define __GerstnerWave__
void GerstnerWave_float(
    float4 waveDir, float4 waveParam, float3 p, out float3 delta_pos, out float3 delta_normalWS
) {
    // waveParam : steepness, waveLength, speed, amplify
    float steepness = waveParam.x;
    float wavelength = waveParam.y;
    float speed = waveParam.z;
    float amplify = waveParam.w;
    float2 d = normalize(waveDir.xz);

    float w = 2 * 3.1415 / wavelength;
    float f = w * (dot(d, p.xz) - _Time.y * speed);
    float sinf = sin(f);
    float cosf = cos(f);

    steepness = clamp(steepness, 0, 1 / (w * amplify));

    delta_normalWS = float3(
        -amplify * w * d.x * cosf,
        -steepness * amplify * w * sinf,
        -amplify * w * d.y * cosf
        );

    delta_pos = float3(
        steepness * amplify * d.x * cosf,
        amplify * sinf,
        steepness * amplify * d.y * cosf
        );
}
#endif