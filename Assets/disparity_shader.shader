Shader "Unlit/disparity_shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ExtrTex ("Extrusion Video", 2D) = "gray" {}
        _Baseline ("Basline", float) = 20
    }
    SubShader
    {
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
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };       


            sampler2D _MainTex;
            sampler2D _ExtrTex;
            float4 _MainTex_ST;
            float4 _ExtrTex_ST;        
            float _Baseline;   

            v2f vert (appdata v)
            {
                v2f o;
                //float h = tex2Dlod(_ExtrTex, float4(v.uv, 0, 0));
                //v.vertex.xyz += v.normal * 10*h;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                float h = (tex2D(_ExtrTex, i.uv) - .5) / _Baseline;
                //i.vertex.xyz *= float3(1,h,1);
                // sample the texture
                fixed4 col = tex2D(_MainTex, float2(i.uv.x+h, i.uv.y));
                // apply fog
                return col;
            }
            ENDCG
        }
    }
}
