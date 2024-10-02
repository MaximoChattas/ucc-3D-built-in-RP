Shader "Unlit/Surface_Basic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        float4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        // Surface Shader
        void surf(Input i, inout SurfaceOutputStandard o)
        {
            fixed4 col = tex2D(_MainTex, i.uv_MainTex); // Obtiene RGBA en coordenada uv del vertex
            col *= _Color;
            o.Albedo = col;
            
        }

        ENDCG
    }
}
