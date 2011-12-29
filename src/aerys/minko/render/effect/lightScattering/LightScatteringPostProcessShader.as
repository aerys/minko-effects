package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.Minko;
	import aerys.minko.render.effect.Style;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.resource.texture.FlatTextureResource;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.leaf.Sampler;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.scene.data.CameraData;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.log.DebugLevel;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringPostProcessShader extends ActionScriptShader
	{
		private var _num_samples	: Number			= 0.;

		private var _exposure 		: Number			= 0.;
		private var _decay			: Number			= 0.;
		private var _weight			: Number			= 0.;
		private var _density		: Number			= 0.;
		private var _lightPos		: SValue			= null;
		private var _nb_passes		: Number			= 0.;
		private var _cur_passe		: Number			= 0.;

		private var _occludedSource	: FlatTextureResource	= null;
		private var _occludedId		: int				= 0;
		
		public function LightScatteringPostProcessShader(num_samples		: Number,
									   				   	 nb_passes			: Number,
									   				     cur_passe			: Number,
									   				   	 occludedSource		: FlatTextureResource,
									   				   	 exposure			: Number,
									   				   	 decay				: Number,
									   				   	 weight				: Number,
									   				   	 density			: Number,
													     lightPos			: Vector4)
		{
			_exposure = exposure;
			_decay = decay;
			_weight = weight;
			_density = density;
			_lightPos = float4(lightPos.x, lightPos.y, lightPos.z, 1.);
		
			_nb_passes = nb_passes;
			_cur_passe = cur_passe;
			_num_samples = num_samples;
			
			_occludedSource = occludedSource;
			_occludedId	= Style.getStyleId('Occluded Intermediate Texture');
		}
		
		override protected function getOutputPosition() : SValue
		{
			return vertexPosition;
		}
		
		override protected function getOutputColor() : SValue
		{
			var lightPosition			: SValue	= getWorldParameter(4, LightScatteringData, LightScatteringData.POSITION);
			var lighDirection 			: SValue 	= normalize(subtract(lightPosition, cameraPosition));
			var textureVertexPos		: SValue	= saturate(interpolate(vertexUV));
			var textureLightPos			: SValue	= multiply4x4(lightPosition, getTransformParameter(16, TransformData.LOCAL_TO_UV));		
			var vertexToLightDelta		: SValue	= subtract(divide(textureLightPos.xy, textureLightPos.w), textureVertexPos);
			
			var dotProductResult		: SValue	= dotProduct3(lighDirection, normalize(cameraDirection));
			var colorMultiplier 		: SValue 	= subtract(dotProductResult, 0.5);
			
			var initialColor			: SValue	= sampleTexture(_occludedId, textureVertexPos, Sampler.FILTER_LINEAR, Sampler.MIPMAP_LINEAR, Sampler.WRAPPING_CLAMP);
			var illumDecay				: Number	= 1.;

			var sampleColor 			: SValue	= null;
			
			vertexToLightDelta = multiply(vertexToLightDelta, _density / _num_samples);
			textureVertexPos = add(textureVertexPos, multiply(divide(vertexToLightDelta, _nb_passes), _cur_passe));

			for (var i : int = 0; i < _num_samples; ++i)
			{
				textureVertexPos = add(textureVertexPos, vertexToLightDelta);
				sampleColor = sampleTexture(_occludedId, textureVertexPos, Sampler.FILTER_LINEAR, Sampler.MIPMAP_LINEAR, Sampler.WRAPPING_CLAMP);
				sampleColor = multiply(sampleColor, _weight * illumDecay);

				initialColor = add(initialColor, sampleColor);

				illumDecay *= _decay;
			}
			
			return float4(multiply(initialColor.rgb, _exposure, colorMultiplier), 1.);
		}

		override public function fillRenderState(state		: RendererState, 
												 style		: StyleData, 
												 transform	: TransformData, 
												 worldData	: Dictionary) : void
		{
			style.set(_occludedId, _occludedSource);
			
			super.fillRenderState(state, style, transform, worldData);
		}
	}
}