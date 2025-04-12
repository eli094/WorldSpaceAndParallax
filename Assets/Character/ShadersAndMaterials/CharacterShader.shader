// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CharacterShader"
{
	Properties
	{
		_Speed("Speed", Range( 0 , 5)) = 0
		_Scale("Scale", Range( 0 , 5)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_ObjectSpeed("ObjectSpeed", Range( 0 , 5)) = 0
		_ObjectScale("ObjectScale", Range( 0 , 5)) = 0
		_Texture1("Texture 1", 2D) = "white" {}
		_Height("Height", Range( 0 , 5)) = 0
		_ObjectHeight("ObjectHeight", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Texture0;
		uniform float _Speed;
		uniform float _Height;
		uniform float _Scale;
		uniform sampler2D _Texture1;
		uniform float _ObjectSpeed;
		uniform float _ObjectHeight;
		uniform float _ObjectScale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime21 = _Time.y * _Speed;
			float2 temp_cast_0 = (mulTime21).xx;
			float2 uv_TexCoord22 = i.uv_texcoord + temp_cast_0;
			float2 Offset23 = ( ( _Height - 1 ) * i.viewDir.xy * _Scale ) + uv_TexCoord22;
			float mulTime30 = _Time.y * _ObjectSpeed;
			float2 temp_cast_1 = (mulTime30).xx;
			float2 uv_TexCoord31 = i.uv_texcoord + temp_cast_1;
			float2 Offset32 = ( ( _ObjectHeight - 1 ) * i.viewDir.xy * _ObjectScale ) + uv_TexCoord31;
			o.Albedo = ( tex2D( _Texture0, Offset23 ) + tex2D( _Texture1, Offset32 ) ).rgb;
			float4 color38 = IsGammaSpace() ? float4(1,0,0.8504324,0) : float4(1,0,0.692865,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV39 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode39 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV39, 5.0 ) );
			o.Emission = ( color38 * fresnelNode39 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
230.4;73.6;798;473.4;-146.9127;-752.1317;1.767479;True;False
Node;AmplifyShaderEditor.RangedFloatNode;29;-881.9141,1009.631;Inherit;False;Property;_ObjectSpeed;ObjectSpeed;3;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-774.1051,22.0071;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;-502.2139,25.18427;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;30;-560.2053,1013.329;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;25;-34.78025,543.0828;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;24;-184.0412,412.1821;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-221.1913,284.2303;Inherit;False;Property;_Height;Height;6;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;34;-227.8402,1537.627;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-325.3946,970.8048;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-462.2396,1284.571;Inherit;False;Property;_ObjectHeight;ObjectHeight;7;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-382.5858,1418.432;Inherit;False;Property;_ObjectScale;ObjectScale;4;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-324.571,-22.22513;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;36;-58.25224,743.829;Inherit;True;Property;_Texture1;Texture 1;5;0;Create;True;0;0;0;False;0;False;bf74524c77babf949bc22f456b43de32;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;27;120.5878,-100.9979;Inherit;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;0;False;0;False;35698da4ab58f7741b31fe232317c756;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ParallaxMappingNode;32;29.59478,967.1071;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;23;230.2495,143.5377;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;35;368.5135,879.8;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;39;878.8379,1288.514;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;889.03,1076.359;Inherit;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;1,0,0.8504324,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;520.0306,45.06536;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;35698da4ab58f7741b31fe232317c756;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;28;903.0992,532.2411;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;1196.502,1057.972;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1509.89,126.9666;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CharacterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;20;0
WireConnection;30;0;29;0
WireConnection;31;1;30;0
WireConnection;22;1;21;0
WireConnection;32;0;31;0
WireConnection;32;1;42;0
WireConnection;32;2;33;0
WireConnection;32;3;34;0
WireConnection;23;0;22;0
WireConnection;23;1;41;0
WireConnection;23;2;24;0
WireConnection;23;3;25;0
WireConnection;35;0;36;0
WireConnection;35;1;32;0
WireConnection;26;0;27;0
WireConnection;26;1;23;0
WireConnection;28;0;26;0
WireConnection;28;1;35;0
WireConnection;37;0;38;0
WireConnection;37;1;39;0
WireConnection;0;0;28;0
WireConnection;0;2;37;0
ASEEND*/
//CHKSM=5F45153381F29C0C4F7EA989A050F86079423C9D