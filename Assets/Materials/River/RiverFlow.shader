Shader "Custom/RiverFlow"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Direction ("Direction", Vector) = (0,0,0,0)

        _DepthColor ("Depth Color", Color) = (1,1,1,1)
        _DepthTex ("Depth Albedo (RGB)", 2D) = "white" {}
        _DepthDirection ("Depth Direction", Vector) = (0,0,0,0)
        _DepthDistance("Depth Distance", Float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "ForceNoShadowCasting"="True"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha
        #pragma target 4.0

        sampler2D _CameraDepthTexture; // Textura de profundidad de la escena de la camara, Unity lo asigna automaticamente
        sampler2D _MainTex;
        sampler2D _DepthTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float2 _Direction;
        fixed4 _DepthColor;
        float2 _DepthDirection;
        float _DepthDistance;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_DepthTex;
            float4 screenPos; // posicion del pixel en la pantalla
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 color = tex2D (_MainTex, IN.uv_MainTex + _Direction * _Time.y) * _Color;

            // Proyeccion de pixel (3D) sobre la pantalla (2D)
            float4 projectCoord = UNITY_PROJ_COORD(IN.screenPos);

            // Distancia del pixel a la camara, determina la profundidad
            float sceneDepth = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, projectCoord);

            // Valor inverso a la profundidad: a medida que el objeto esta mas lejos de la camara, el valor 2 aumenta
            // Al invertir la expresión:
            // Los fragmentos que estan mas cerca de la camara resultan en un valor menor para depthFactor (tiende a 0)
            // Los fragmentos que estan mas lejos de la camara resultan en un valor mayor para depthFactor (tiende a 1)
            float depthFactor = 1 - ( ( LinearEyeDepth(sceneDepth) - IN.screenPos.w ) / _DepthDistance);

            fixed4 colorDepth = depthFactor - tex2D (_DepthTex, IN.uv_DepthTex + _DepthDirection * _Time.y) * _DepthColor;

            depthFactor = saturate(depthFactor - colorDepth);

            fixed4 finalColor = lerp(color, colorDepth, depthFactor);

            o.Albedo = finalColor.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}