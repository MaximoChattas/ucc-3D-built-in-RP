Shader "Unlit/Half_Color_Side"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color1 ("Tint Top", Color) = (1, 1, 1, 1)
        _Color2 ("Tint Bottom", Color) = (1, 1, 1, 1)
        _ColorChangeY ("Color Change Pos", float) = 0.5
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

            struct appdata // Mesh data (position, vertex, normals, coordinates)
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f // Vertex 2 Fragment
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color1;
            float4 _Color2;
            float _ColorChangeY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                // apply color depending on position
                if(i.uv.y <= _ColorChangeY)
                {
                    col *= _Color1;
                }
                else
                {
                    col *= _Color2;
                }


                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
