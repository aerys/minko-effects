package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.Effect;
	import aerys.minko.render.resource.texture.TextureResource;
	
	public final class LightScatteringEffect extends Effect
	{
		private var _renderingEffect	: Effect		= null;
		private var _occlusionMap		: RenderTarget	= null;
		private var _backgroundColor	: int			= 0;
		
		public function get occlusionMap() : RenderTarget
		{
			return _occlusionMap;
		}
		
		public function LightScatteringEffect(renderingEffect	: Effect,
											  backgroundColor	: int	= 0x000000,
									  		  textureSize		: int   = 1024)
		{
			_renderingEffect = renderingEffect;
			_occlusionMap = new RenderTarget(
				textureSize,
				textureSize,
				new TextureResource(textureSize, textureSize),
				0,
				backgroundColor
			);
			
			var passes : Array	= [new LightScatteringShader(_occlusionMap)];
			var numRenderingPasses : uint = _renderingEffect.numPasses;
			
			for (var i : uint; i < numRenderingPasses; ++i)
				passes.push(_renderingEffect.getPass(i));
			
			_renderingEffect.passesChanged.add(renderingEffectPassesChangedHandler);
			
			super(passes);
		}
		
		private function renderingEffectPassesChangedHandler(effect	: Effect) : void
		{
			throw new Error();
		}
	}
}