﻿// 頂点を膨らませるShader

//頂点を膨らませるShader
Shader "Custom/CommonShaders/Mountain" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Height("Height", Float) = 0.0
		_Amount("Amount", Int) = 0
		_Emission("Emission", Color) = (0,0,0)
		_EmissionPower("EmissionPower", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Cull Off

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard vertex:vert fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		struct appdata_custom {
                float4 vertex   : POSITION;
                float3 normal   : NORMAL;
                float4 texcoord : TEXCOORD0;
				uint vid : SV_VertexID;
		};


		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Height;
		int _Amount;
		fixed3 _Emission;
		float _EmissionPower;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
			o.Emission = _Emission * _EmissionPower;
		}

		void vert(inout appdata_custom v)
        {
            float4 worldPos= mul( unity_ObjectToWorld, v.vertex );
			float dist = abs(distance(float3(0,0,0),worldPos.xyz));
			if(v.vid % _Amount == 0){
				v.vertex.xyz += v.normal * _Height;
			}

        }
		ENDCG
	}
	FallBack "Diffuse"
}
