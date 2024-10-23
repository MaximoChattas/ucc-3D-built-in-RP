Shader "Custom/Rotation"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Rotation ("Rotation Degrees", Range(0,359)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float _Rotation;

        struct Input
        {
            float2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        // Funcion que recibe coordinadas uv y angulo
        // Y devuelve coordenadas uv rotadas
        float2 RotateUV(float2 uv, float angle)
        {
            // Para rotar un vector de 2 dimensiones hace falta una matriz de rotación de espacio bidimensional
            // [cos, -sen]
            // [sen, cos]

            float rad = radians(angle);
            float cosAngle = cos(rad);
            float sinAngle = sin(rad);

            // Matriz de rotacion de plano (espacio bidimensional)
            float2x2 rotationMatrix = float2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

            // Coordinadas uv rotadas
            return mul(rotationMatrix, uv);

        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 rotatedUV = RotateUV(IN.uv_MainTex, _Rotation);

            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, rotatedUV);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
