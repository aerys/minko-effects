package aerys.minko.render.effect.steepParallaxMapping
{
	import aerys.minko.render.effect.animation.AnimationShaderPart;
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.resource.TextureResource;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.Components;
	import aerys.minko.render.shader.node.leaf.Sampler;
	import aerys.minko.scene.data.GlobalDirectionnalLightData;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.animation.AnimationMethod;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	public class SteepParallaxMappingShader extends ActionScriptShader
	{
		private static const ANIMATION	: AnimationShaderPart	= new AnimationShaderPart();
		
		private static const NSTEPS		 		: uint		= 20;
		private static const BUMPSCALE_DEFAULT	: Number 	= .03;

		private var _lightDir				: SValue	= null;
		private var _cameraPosition			: SValue 	= null;
		
		override protected function getOutputPosition() : SValue
		{
			var vertexBitangent	: SValue	= cross(vertexNormal, vertexTangent);
			
			var lightDir		: SValue	= getWorldParameter(4, GlobalDirectionnalLightData, GlobalDirectionnalLightData.DIRECTION);
			lightDir = normalize(multiply3x4(copy(lightDir), worldToLocalMatrix));
			
			_lightDir = float3(
				dotProduct3(lightDir, vertexTangent),
				dotProduct3(lightDir, vertexBitangent),
				dotProduct3(lightDir, vertexNormal)
			);
			
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
			var samplerWrapping	: uint		= getStyleConstant(SteepParallaxMappingStyle.SAMPLER_WRAPPING, Sampler.WRAPPING_REPEAT) as uint;
			
			var tangentSpaceEye	: SValue	= normalize(cameraLocalPosition.subtract(interpolate(vertexPosition)));
			
			 tangentSpaceEye = float3(
				dotProduct3(tangentSpaceEye, interpolate(vertexTangent)),
				dotProduct3(tangentSpaceEye, cross(interpolate(vertexNormal), interpolate(vertexTangent))),
				dotProduct3(tangentSpaceEye, interpolate(vertexNormal))
			);
			
			var uv				: SValue	= float(0.);						
			
			var bumpScale		: Number	= getStyleConstant(SteepParallaxMappingStyle.BUMP_SCALE, BUMPSCALE_DEFAULT) as Number;
			var delta			: SValue	= multiply(float2(extract(tangentSpaceEye, Components.X),
													   		  extract(tangentSpaceEye, Components.Y)),
													   divide(bumpScale,
															  multiply(extract(tangentSpaceEye, Components.Z), NSTEPS)));
			
			var tmpUV			: SValue	= interpolate(vertexUV);
			
			var height			: Number	= 1.;
			var resultNotFound	: SValue	= float(1.);
			
			for (var i : int = 0; i < NSTEPS; i++) 
			{				
				if (i == NSTEPS - 1)
					height = 0;
				
				var bump 	: SValue	= sampleTexture(SteepParallaxMappingStyle.BUMP_MAP, tmpUV,
												 	 	Sampler.FILTER_LINEAR,
														Sampler.MIPMAP_LINEAR,
														samplerWrapping);							
				var resultUV : SValue = multiply(tmpUV, ifGreaterEqual(bump, height), resultNotFound);
				
				resultNotFound = resultNotFound.multiply(ifLessThan(bump, height));
				
				uv.incrementBy(resultUV);
				
				tmpUV = tmpUV.subtract(delta);
				
				height -= 1. / NSTEPS;
			}
			
			var diffuse				: SValue	= sampleTexture(BasicStyle.DIFFUSE, uv,
																Sampler.FILTER_LINEAR,
																Sampler.MIPMAP_LINEAR,
																samplerWrapping);
			
			var tangentSpaceLight	: SValue	= normalize(interpolate(_lightDir));
			var normal				: SValue 	= sampleTexture(SteepParallaxMappingStyle.NORMAL_MAP, uv,
																Sampler.FILTER_LINEAR,
																Sampler.MIPMAP_LINEAR,
																samplerWrapping);
			
			normal = normalize(subtract(normal.multiply(2.), 1.));
			
			var specular			: SValue	= float(getStyleConstant(SteepParallaxMappingStyle.LIGHT_SPECULAR, 0.));
			var shininess			: SValue	= float(getStyleConstant(SteepParallaxMappingStyle.LIGHT_SHININESS, 0.));
			
			var ref					: SValue	= getReflectedVector(negate(tangentSpaceLight), normal);
			var lambert				: SValue	= saturate(tangentSpaceLight.dotProduct3(normal));
			var spec				: SValue	= power(dotProduct3(ref, normalize(tangentSpaceEye)), shininess)
													.multiply(specular)
				                                  	.multiply(lambert);
			
			var illumination 		: SValue 	= multiply(diffuse, lambert);
			
			return illumination.add(spec);
		}
		
		override public function getDataHash(style		: StyleData,
											 transform	: TransformData,
											 world		: Dictionary) : String
		{
			var hash 			: String	= "steep_parallax_mapping";
			
			hash += "_bumpScale=" + getStyleConstant(SteepParallaxMappingStyle.BUMP_SCALE, BUMPSCALE_DEFAULT);
			hash += "_lightShininess=" + getStyleConstant(SteepParallaxMappingStyle.LIGHT_SHININESS, 0.);
			hash += "_lightSpecular=" + getStyleConstant(SteepParallaxMappingStyle.LIGHT_SPECULAR, 0.);
			hash += "_wrapping=" + getStyleConstant(SteepParallaxMappingStyle.SAMPLER_WRAPPING, Sampler.WRAPPING_REPEAT);
			
			var diffuseStyle 	: Object 	= style.isSet(BasicStyle.DIFFUSE)
				? style.get(BasicStyle.DIFFUSE)
				: null;
			
			if (diffuseStyle == null)
				hash += '_colorFromVertex';
			else if (diffuseStyle is uint || diffuseStyle is Vector4)
				hash += '_colorFromConstant';
			else if (diffuseStyle is TextureResource)
				hash += '_colorFromTexture';
			else
				throw new Error('Invalid BasicStyle.DIFFUSE value');
			
			hash += ANIMATION.getDataHash(style, transform, world);				
			
			return hash;
		}
	}
}