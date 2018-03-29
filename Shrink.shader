// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/CommonShaders/Shrink" {
    Properties {
        _ShrinkPosition("Shrink Position", Vector) = (0, 0, 0, 0)
        _Color ("Text Color", Color) = (1,1,1,1)
    }
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard vertex:vert
		#pragma target 3.0
		
        struct Input {
            float3 worldPos;
        };
        float4 _ShrinkPosition;
        uniform fixed4 _Color;
        
        void surf (Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = _Color;
        }	
		
		void vert(inout appdata_full v)
        {
            float4 worldPos= mul( unity_ObjectToWorld, v.vertex );
            //float dist = distance( _Position, worldPos);
            float dist = abs(worldPos.xyz);
            // abs(1 - exp(-dist * 0.3)は dist = 0の時0 最終的に1に収束する
            float4 zeroBasedPos = worldPos - _ShrinkPosition;
            zeroBasedPos.yz = zeroBasedPos.yz * abs(1 - exp(-dist * 0.3));
            v.vertex = zeroBasedPos + _ShrinkPosition;
        }
        
		
		ENDCG
    }
	FallBack "Diffuse"
}
