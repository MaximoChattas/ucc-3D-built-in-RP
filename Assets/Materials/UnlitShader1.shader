Shader "Unlit/UnlitShader1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorMultiplier ("Color Multiplier", int) = 0
        _Alpha ("Transparency", float) = 1.0
        _Specular ("Specular", Range(0.0, 1.0)) = 0.5
        _Position ("Texture Position", Vector) = (0, 0, 0, 1)
        _Color ("Tint", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            // Obtains data from mesh (además: normal, color)
            // Aplica a todos los vertices
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };


            // Vertex information
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; // Space View Position
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _ColorMultiplier;

            // Receives information from mesh
            // Parameter: vertex
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // Position in camera
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); // UV coordinates regarding the applied texture
                UNITY_TRANSFER_FOG(o,o.vertex); // Distance between the object and fog around it
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                // Apply color and multiplier
                col *= _Color * _ColorMultiplier;
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col * _Color * _ColorMultiplier;
            }
            ENDCG
        }
    }
}
