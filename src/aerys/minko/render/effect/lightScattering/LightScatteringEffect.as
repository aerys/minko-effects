package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.Style;
	import aerys.minko.render.effect.basic.BasicEffect;
	import aerys.minko.render.resource.Texture3DResource;
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.data.ViewportData;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringEffect implements IRenderingEffect
	{
		private var _passes				: Vector.<IEffectPass>	= null;
		
		private var _occludedTarget		: RenderTarget			= null;
		private var _backgroundColor	: int					= 0;
		
		public function get occludedResource() : Texture3DResource
		{
			return _occludedTarget.textureResource;
		}
		
		public function get occludedTarget() : RenderTarget
		{
			return _occludedTarget;
		}
		
		public function LightScatteringEffect(backgroundColor	: int	= 0x000000,
									  		  textureSize		: int   = 1024)
		{
			_backgroundColor = backgroundColor
			_occludedTarget = new RenderTarget(RenderTarget.TEXTURE, textureSize, textureSize, backgroundColor);
		}

		public function getPasses(styleStack	: StyleData, 
								  transform		: TransformData, 
								  worldData		: Dictionary) : Vector.<IEffectPass>
		{
			if (!_passes)
			{
				var finalTarget	: RenderTarget	= worldData[ViewportData].backBufferRenderTarget;
				
				_passes		= new Vector.<IEffectPass>();
				_passes[0]	= new LightScatteringPass(1 + 100, _occludedTarget, worldData[LightScatteringData].color, _backgroundColor);
				_passes[1]  = new BasicEffect(2 + 100, finalTarget);
			}

			return _passes;	
		}
	}
}