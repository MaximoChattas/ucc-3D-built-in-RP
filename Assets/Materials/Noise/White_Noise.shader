Shader "Custom/White_Noise"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #include "WhiteNoise.cginc" // Referencia al archivo .cginc

        struct Input
        {
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 noise = rand3dTo3d(IN.worldPos);

            o.Albedo = noise;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
