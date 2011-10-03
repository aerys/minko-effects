package aerys.minko.render.effect.steepParallaxMapping
{
	import aerys.minko.render.effect.animation.AnimationShaderPart;
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.resource.Texture3DResource;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.Components;
	import aerys.minko.render.shader.node.leaf.Sampler;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.animation.AnimationMethod;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	public class SteepParallaxMappingShader extends ActionScriptShader
	{
		private static const ANIMATION	: AnimationShaderPart	= new AnimationShaderPart();
		
		private static const NSTEPS		 	: uint		= 20;
		private static const BUMPSCALE 		: Number	= .05;
		
		private var _eyeDir					: SValue	= null;
		private var _lightDir				: SValue	= null;
		//private var _lightEyeSum			: SValue	= null;
		//private var _halfVector				: SValue	= null;
		
		override protected function getOutputPosition() : SValue
		{
			var vertexBitangent	: SValue	= cross(vertexNormal, vertexTangent);
			
			var eyeDir			: SValue	= normalize(cameraLocalPosition.subtract(vertexPosition));
			
			_eyeDir = float3(
				dotProduct3(eyeDir, vertexTangent),
				dotProduct3(eyeDir, vertexBitangent),
				dotProduct3(eyeDir, vertexNormal)
			);
			
			var worldLightDir 	: SValue 	= subtract(getStyleParameter(3, SteepParallaxMappingStyle.LIGHT_DIR), vertexPosition);
			
			/*_lightDir = float3(
				dotProduct3(eyeDir, vertexTangent),
				dotProduct3(eyeDir, vertexBitangent),
				dotProduct3(eyeDir, vertexNormal)
			);*/
			_lightDir = float3(
				dotProduct3(worldLightDir, vertexTangent),
				dotProduct3(worldLightDir, vertexBitangent),
				dotProduct3(worldLightDir, vertexNormal)
			);
			var halfVector		: SValue 	= normalize(add(worldLightDir, copy(cameraDirection)));
			/*
			_lightEyeSum = halfVector;
			
			_halfVector = float3(
				dotProduct3(halfVector, vertexTangent),
				dotProduct3(halfVector, vertexBitangent),
				dotProduct3(halfVector, vertexNormal)
			);*/
			
			var animationMethod	: uint		= getStyleConstant(AnimationStyle.METHOD, AnimationMethod.DISABLED)
				as uint;
			var maxInfluences	: uint		= getStyleConstant(AnimationStyle.MAX_INFLUENCES, 0)
				as uint;
			var numBones		: uint		= getStyleConstant(AnimationStyle.NUM_BONES, 0)
				as uint;
			var vertexPosition	: SValue	= ANIMATION.getVertexPosition(animationMethod, maxInfluences, numBones);
			
			return multiply4x4(vertexPosition, localToScreenMatrix);
		}
		
		override protected function getOutputColor() : SValue
		{
			var tangentSpaceEye	: SValue	= interpolate(_eyeDir);
			
			var uv				: SValue	= float(0.);						
			
			var delta			: SValue	= multiply(float2(extract(tangentSpaceEye, Components.X),
				extract(tangentSpaceEye, Components.Y)),
				divide(BUMPSCALE,
					multiply(extract(tangentSpaceEye, Components.Z), NSTEPS)));
			
			var tmpUV			: SValue	= interpolate(vertexUV);
			
			var height			: Number	= 1.;
			var resultNotFound	: SValue	= float(1.);
			
			for (var i : int = 0; i < NSTEPS; i++) 
			{
				height -= 1. / NSTEPS;
				
				if (i == NSTEPS - 1)
					height = 0;
				
				var bump : SValue = sampleTexture(SteepParallaxMappingStyle.BUMP_MAP, tmpUV,
					Sampler.FILTER_LINEAR,
					Sampler.MIPMAP_LINEAR,
					Sampler.WRAPPING_CLAMP);							
				var resultUV : SValue = multiply(tmpUV, ifGreaterEqual(bump, height), resultNotFound);
				
				resultNotFound = resultNotFound.multiply(ifLessThan(bump, height));
				
				uv.incrementBy(resultUV);
				
				tmpUV = tmpUV.subtract(delta);
			}
			
			var diffuse				: SValue	= sampleTexture(BasicStyle.DIFFUSE, uv,
				Sampler.FILTER_LINEAR,
				Sampler.MIPMAP_LINEAR,
				Sampler.WRAPPING_CLAMP);
			
			var tangentSpaceLight	: SValue	= normalize(interpolate(_lightDir));
			var normal				: SValue 	= sampleTexture(SteepParallaxMappingStyle.NORMAL_MAP, uv,
				Sampler.FILTER_LINEAR,
				Sampler.MIPMAP_LINEAR,
				Sampler.WRAPPING_CLAMP);
			
			normal = normalize(subtract(normal.multiply(2.), 1.));
			
			var specular			: SValue	= float(getStyleConstant(SteepParallaxMappingStyle.LIGHT_SPECULAR, 0.));
			var shininess			: SValue	= float(getStyleConstant(SteepParallaxMappingStyle.LIGHT_SHININESS, 0.));
			
			var ref					: SValue	= getReflectedVector(negate(tangentSpaceLight), normal);
			var lamberFactor		: SValue	= saturate(tangentSpaceLight.dotProduct3(normal));
			var spec				: SValue	= power(dotProduct3(ref, normalize(tangentSpaceEye)), shininess).multiply(specular)
				                                  .multiply(lamberFactor);
			
			var illumination 		: SValue 	= multiply(diffuse, lamberFactor);
			
			return illumination.add(spec);
		}
		
		override public function getDataHash(style		: StyleData,
											 transform	: TransformData,
											 world		: Dictionary) : String
		{
			var hash 			: String	= "steep_parallax_mapping";
			
			hash += "_lightDirection=" + getStyleConstant(SteepParallaxMappingStyle.LIGHT_DIR);
			hash += "_lightShininess=" + getStyleConstant(SteepParallaxMappingStyle.LIGHT_SHININESS, 0.);
			hash += "_lightSpecular=" + getStyleConstant(SteepParallaxMappingStyle.LIGHT_SPECULAR, 0.);
			
			var diffuseStyle 	: Object 	= style.isSet(BasicStyle.DIFFUSE)
				? style.get(BasicStyle.DIFFUSE)
				: null;
			
			if (diffuseStyle == null)
				hash += '_colorFromVertex';
			else if (diffuseStyle is uint || diffuseStyle is Vector4)
				hash += '_colorFromConstant';
			else if (diffuseStyle is Texture3DResource)
				hash += '_colorFromTexture';
			else
				throw new Error('Invalid BasicStyle.DIFFUSE value');
			
			hash += ANIMATION.getDataHash(style, transform, world);				
			
			return hash;
		}
	}
}