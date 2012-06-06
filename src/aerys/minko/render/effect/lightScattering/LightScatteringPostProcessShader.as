package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringPostProcessShader extends Shader
	{
		private var _postProcessing	: PostProcessingShaderPart	= null;
		
		private var _numSamples		: Number					= 0.;
		private var _nbPasses		: Number					= 0.;
		private var _curPass		: Number					= 0.;
		private var _occludedSource	: TextureResource			= null;
		
		public function LightScatteringPostProcessShader(numSamples		: Number,
									   				   	 nbPasses		: Number,
									   				     curPass		: Number,
									   				   	 occlusionMap	: TextureResource)
		{
			_nbPasses = nbPasses;
			_curPass = curPass;
			_numSamples = numSamples;
			_occludedSource = occlusionMap;
			
			_postProcessing = new PostProcessingShaderPart(this);
		}
		
		override protected function initializeSettings(settings:ShaderSettings):void
		{
			super.initializeSettings(settings);
			
			settings.depthTest			= DepthTest.ALWAYS;
			settings.blending			= Blending.ADDITIVE;
			settings.triangleCulling	= TriangleCulling.NONE;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		private function localToUV(value : SFloat) : SFloat
		{
			return divide(add(localToScreen(value), 1), 2);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var lightPosition		: SFloat	= sceneBindings.getParameter(LightScatteringProperties.SOURCE_POSITION, 4);
			var lighDirection 		: SFloat 	= normalize(subtract(lightPosition, cameraPosition));
			var textureVertexPos	: SFloat	= saturate(interpolate(vertexUV));
			var textureLightPos		: SFloat	= localToUV(lightPosition);		
			var vertexToLightDelta	: SFloat	= subtract(divide(textureLightPos.xy, textureLightPos.w), textureVertexPos);
			
			var cameraDirection		: SFloat	= normalize(this.cameraDirection);
			var dotProductResult	: SFloat	= dotProduct3(lighDirection, normalize(cameraDirection));
			var colorMultiplier 	: SFloat 	= subtract(dotProductResult, 0.5);
			
			var occlusionMap		: SFloat	= getTexture(
				_occludedSource,
				SamplerFiltering.LINEAR,
				SamplerMipMapping.LINEAR,
				SamplerWrapping.CLAMP
			);
			var initialColor		: SFloat	= sampleTexture(occlusionMap, textureVertexPos);
			var illumDecay			: SFloat	= float(1.);
			var sampleColor 		: SFloat	= null;
			
			// light scattering source values
			var sourceCensity		: SFloat	= sceneBindings.getParameter(LightScatteringProperties.SOURCE_DENSITY, 1);
			var sourceWeight		: SFloat	= sceneBindings.getParameter(LightScatteringProperties.SOURCE_WEIGHT, 1);
			var sourceDecay			: SFloat	= sceneBindings.getParameter(LightScatteringProperties.SOURCE_DECAY, 1);
			var sourceExposure		: SFloat	= sceneBindings.getParameter(LightScatteringProperties.SOURCE_EXPOSURE, 1);
			
			vertexToLightDelta = multiply(vertexToLightDelta, divide(sourceCensity, _numSamples));
			textureVertexPos = add(textureVertexPos, multiply(divide(vertexToLightDelta, _nbPasses), _curPass));

			for (var i : int = 0; i < _numSamples; ++i)
			{
				textureVertexPos = add(textureVertexPos, vertexToLightDelta);
				sampleColor		 = sampleTexture(occlusionMap, textureVertexPos);
				sampleColor		 = multiply(sampleColor, sourceWeight, illumDecay);
				initialColor	 = add(initialColor, sampleColor);

				illumDecay.scaleBy(sourceDecay);
			}
			
			return float4(
				multiply(initialColor.rgb, sourceExposure, colorMultiplier),
				1.
			);
		}
	}
}