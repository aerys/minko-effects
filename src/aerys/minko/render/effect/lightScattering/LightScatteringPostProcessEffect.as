package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.Effect;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.data.lightScattering.LightScatteringProvider;
	
	import flash.utils.Dictionary;

	public class LightScatteringPostProcessEffect extends Effect
	{
		private static const MAX_SAMPLES	: Number 		= 44.;
		
		private var _occlusionMap	: TextureResource		= null;
		private var _renderTarget 	: RenderTarget			= null;
		
		public function LightScatteringPostProcessEffect(occludedSource	: TextureResource,
														 renderTarget	: RenderTarget	= null,
														 renderQuality	: int			= LightScatteringProperties.LOW_QUALITY,
														 numSamples		: Number		= MAX_SAMPLES)
		{
			super(getPasses(renderQuality, numSamples));
			
			_occlusionMap = occludedSource;
			_renderTarget = renderTarget;
		}
		
		private function getPasses(renderQuality	: int,
								   numSamples		: Number) : Array
		{
			
			if (renderQuality != LightScatteringProperties.MANUAL_QUALITY)
				numSamples = renderQuality * MAX_SAMPLES;
			
			var numPasses	: uint 	= Math.ceil(numSamples / MAX_SAMPLES);
			var passes 		: Array = [];
			
			for (var i : uint = 0; i < numPasses; ++i)
			{
				passes[i] = new LightScatteringPostProcessShader(
					numSamples,
					numPasses,
					i,
					_occlusionMap
				);
			}
			
			return passes;
		}
	}
}