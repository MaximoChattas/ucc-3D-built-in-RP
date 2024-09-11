Shader "Unlit/Straight_Cut_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorTL ("Tint Top Left", Color) = (1, 1, 1, 1)
        _ColorTR ("Tint Top Right", Color) = (1, 1, 1, 1)
        _ColorBL ("Tint Bottom Left", Color) = (1, 1, 1, 1)
        _ColorBR ("Tint Bottom Right", Color) = (1, 1, 1, 1)
        _ColorChangeY ("Color Change Pos", float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members color)
#pragma exclude_renderers d3d11
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
                float4 color : TEXCOORD1;
                float3 objPosition : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _ColorTL;
            float4 _ColorTR;
            float4 _ColorBL;
            float4 _ColorBR;
            float _ColorChangeY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.objPosition = v.vertex.xyz;

                // apply color depending on position
                if (o.objPosition.x < 0) 
                {
                    if(o.objPosition.y < 0)
                    {
                        o.color = _ColorTL;
                    }
                    else
                    {
                        o.color = _ColorBL;
                    }
                }
                else
                {
                    if(o.objPosition.y < 0)
                    {
                        o.color = _ColorTR;
                    }
                    else
                    {
                        o.color = _ColorBR;
                    }
                    
                }

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                col *= i.color

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
