package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.effect.IPostProcessingEffect;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	
	import flash.utils.Dictionary;

	public class LightScatteringPostProcessEffect implements IPostProcessingEffect
	{
		private static const MAX_SAMPLES	: Number 				= 44.;
		
		private var _passes					: Vector.<IEffectPass>	= null;;
		
		private var _occludedSource			: TextureResource		= null;
		private var _renderTarget 			: AbstractRenderTarget	= null;
		
		private var _nb_passes				: Number				= 0.;
		private var _nb_samples				: Number				= 0.;
		
		public function LightScatteringPostProcessEffect(occludedSource	: TextureResource,
														 renderTarget	: AbstractRenderTarget	= null,
														 renderQuality	: int					= LightScatteringStyle.LOW_QUALITY,
														 nb_samples		: Number				= MAX_SAMPLES)
		{
			_occludedSource = occludedSource;
			_renderTarget = renderTarget;
		
			if (renderQuality == LightScatteringStyle.MANUAL_QUALITY)
				_nb_samples = nb_samples;
			else
				_nb_samples = renderQuality * MAX_SAMPLES;
			
			nb_samples = _nb_samples;
			_nb_passes = 1.;
			
			while (_nb_samples > MAX_SAMPLES)
			{
				++_nb_passes;
				_nb_samples = nb_samples / _nb_passes;
			}
		}
		
		public function getPasses(styleStack	: StyleData, 
								  transform		: TransformData, 
								  worldData		: Dictionary) : Vector.<IEffectPass>
		{
			if (!_passes)
			{
				_passes		= new Vector.<IEffectPass>();
				for (var i : Number = 0.; i < _nb_passes; ++i)
				{
					_passes[i] = new LightScatteringPostProcessPass(
						_nb_samples,
						_nb_passes,
						i,
						_occludedSource,
						_renderTarget,
						-i - 1 - 100,
						worldData[LightScatteringData].exposure,
						worldData[LightScatteringData].decay,
						worldData[LightScatteringData].weight,
						worldData[LightScatteringData].density,
						worldData[LightScatteringData].position
					);								
				}
			}
			
			return _passes;	
		}
	}
}