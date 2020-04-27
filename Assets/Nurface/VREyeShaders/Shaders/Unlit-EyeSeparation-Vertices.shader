// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "EyeSeparation/Unlit_EyeSeparation" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "black" {}
	_TargetEye("Target eye (-1 - left, 1 - right, 0 - both)", Range(-1.0,1.0)) = -1.0
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;				
				UNITY_FOG_COORDS(1)
				UNITY_VERTEX_OUTPUT_STEREO
			};

			sampler2D _MainTex;			
			float4 _MainTex_ST;
			fixed _EyeFloatFlag;
			fixed _TargetEye;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				
				//Collapsing vertices if eyes mismatch
				o.vertex = lerp(UnityObjectToClipPos(v.vertex),float4(0,0,0,0), saturate(abs(_TargetEye - _EyeFloatFlag) - 1));
				
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{				
				fixed4 col = tex2D(_MainTex, i.texcoord);								
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}
}

}
