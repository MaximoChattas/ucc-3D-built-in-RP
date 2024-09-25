Shader "Unlit/Color_By_Perspective"
{
    Properties
    {
        _ColorX ("Color X", Color) = (1, 1, 1, 1)
        _ColorY ("Color Y", Color) = (1, 1, 1, 1)
        _ColorZ ("Color Z", Color) = (1, 1, 1, 1)
        _YLimit ("Y Limit transparent", float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" } // Para enviarlo a renderizar como transparente
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha // Agregar el blend permite color y transparencia

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                //float2 uv : TEXCOORD0;
                float4 normal : NORMAL; // normal del vertice
            };

            struct v2f
            {
                //float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                float yPos : TEXCOORD1;
            };

            // sampler2D _MainTex;
            // float4 _MainTex_ST;
            float4 _ColorX;
            float4 _ColorY;
            float4 _ColorZ;
            float _YLimit;

            v2f vert (appdata v)
            {
                v2f o; // variable tipo v2f, que sera trabajada en el frag
                o.vertex = UnityObjectToClipPos(v.vertex); // transforma posicion del vertex al Clip Space (con respecto a la camara)
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex); // toma la coordenada UV que le corresponde al vertice en la textura

                // Direccion de las normales segun la camara, matriz inversa transpuesta
                o.normalDir = mul(UNITY_MATRIX_IT_MV, v.normal);

                // Posicion del objeto respecto al mundo
                o.yPos = mul(unity_ObjectToWorld, o.vertex).y;

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 up = float3(0, 1, 0);
                float3 right = float3(1 ,0, 0);

                // Se calculan valores entre -1 y 1 que determina la orientación de la normal respecto a estas direcciones
                float upOrientation = dot(up, i.normalDir);
                float rightOrientation = dot(right, i.normalDir);
                fixed4 col = (0,0,0,0);

                col = _ColorX * rightOrientation + _ColorY * upOrientation;
                col.a = saturate(i.yPos); // Changes transparency gradually


                // sample the texture
                //fixed4 col = (1, 1, 1, 1);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
