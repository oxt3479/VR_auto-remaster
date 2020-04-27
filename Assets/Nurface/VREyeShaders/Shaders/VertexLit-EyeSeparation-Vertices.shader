Shader "EyeSeparation/VertexLit_EyeSeparation" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}	
	_TargetEye("Target eye (left:-1,right:1,both:0)", Range(-1.0,1.0)) = 1.0
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 200
	
	Pass {  
		Cull Back
        Lighting On
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;	
				float3 normal : NORMAL; 
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				fixed3 color : COLOR;
				UNITY_FOG_COORDS(1)
				UNITY_VERTEX_OUTPUT_STEREO
			};

			sampler2D _MainTex;			
			float4 _MainTex_ST;
			fixed4 _Color;
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
				o.color = ShadeVertexLights(v.vertex, v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{				
				fixed4 col = tex2D(_MainTex, i.texcoord) * _Color;
				col.rgb = col.rgb  * i.color * 2;
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}
}

}
