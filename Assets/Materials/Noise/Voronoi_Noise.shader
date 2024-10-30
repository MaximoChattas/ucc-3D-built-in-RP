Shader "Custom/Voronoi_Noise"
{
    Properties
    {
        _CellSize ("Cell Size", Range(0, 2)) = 1
        _BorderColor ("Border Color", Color) = (0, 0, 0, 1)
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

        #include "VoronoiNoise.cginc" // Referencia al archivo .cginc
        float _CellSize;
        float3 _BorderColor;

        struct Input
        {
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 cell = IN.worldPos.xy / _CellSize;

            float3 voronoi = voronoiNoiseWithEdge2D(cell);

            // noise.x: distancia entre el punto actual y el centro de la celda mas cercana.
            // noise.y: un valor aleatorio único para cada celda utilizado para darle un color.
            // noise.z: la distancia al borde de la celda más cercana (para dibujar los bordes entre las celdas).

            float3 cellColor = rand1dTo3d(voronoi.y);

            float isBorder = step(voronoi.z, 0.05);
            float3 color = lerp(cellColor, _BorderColor, isBorder);

            o.Albedo = color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
