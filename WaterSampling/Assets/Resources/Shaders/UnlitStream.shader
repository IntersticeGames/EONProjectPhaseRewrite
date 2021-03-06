﻿Shader "Unlit/UnlitStream"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 8
		_Speed("Speed", Float) = 8
		_AlphaMult("Alpha Multiplier", Range(0.0, 1.0)) = 1
		_Color ("Main Color", COLOR)=(1,1,1,1)
    }
    SubShader
    {
        Tags 
		{
			"Queue" = "Geometry"
		}
        

        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

                return o;
            }

			sampler2D _MainTex;
			float _Cutoff;
			float _Speed;
			float _AlphaMult;
			float4 _Color;

            float4 frag (v2f i) : SV_Target
            {
               // Pan
				float yuv = i.uv.y + _Time.x * _Speed;
				yuv = yuv - (floor(yuv));
				float2 distuv = float2(i.uv.x, yuv);
				float4 color = tex2D(_MainTex, distuv);


				//Cutoff
				color.a = step(0.0, i.uv.y - _Cutoff);

				color.a *= ((color.r + color.g + color.b) / 3) * (_AlphaMult * 3);
				color *= _Color;
                return color;
            }
            ENDCG
        }
    }
}
