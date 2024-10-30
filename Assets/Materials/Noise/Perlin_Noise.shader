Shader "Custom/Perlin_Noise"
{
    Properties
    {
        _CellSize ("Cell Size", Range(0.1, 5)) = 1
        _Amplitude ("Noise Amplitude", Float) = 0.5
        _Offset ("Noise Offset", Float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        #include "PerlinNoise.cginc" 

        float _CellSize;
        float _Amplitude;
        float _Offset;

        struct Input
        {
             float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 value = IN.worldPos.xz / _CellSize; //Dividir el espacio del objeto en celdas de Perlin Noise
            // Obtener el Perlin Noise en 2D y ajustarlo al rango 0-1
            float noise =  perlinNoise2D(value) * _Amplitude + _Offset; //calcular el perlin noise

            o.Albedo = noise;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}