package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.render.effect.Style;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.render.target.TextureRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.data.ViewportData;
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringEffect implements IRenderingEffect
	{
		private var _passes				: Vector.<IEffectPass>	= null;
		
		private var _occludedTarget		: TextureRenderTarget	= null;
		private var _backgroundColor	: int					= 0;
		
		public function get occludedResource() : TextureResource
		{
			return TextureResource(_occludedTarget.textureResource);
		}
		
		public function get occludedTarget() : AbstractRenderTarget
		{
			return _occludedTarget;
		}
		
		public function LightScatteringEffect(backgroundColor	: int	= 0x000000,
									  		  textureSize		: int   = 1024)
		{
			_backgroundColor = backgroundColor
			_occludedTarget = new TextureRenderTarget(textureSize, textureSize, backgroundColor);
		}

		public function getPasses(styleStack	: StyleData, 
								  transform		: TransformData, 
								  worldData		: Dictionary) : Vector.<IEffectPass>
		{
			if (!_passes)
			{
				var finalTarget	: AbstractRenderTarget	= worldData[ViewportData].backBufferRenderTarget;
				
				_passes		= new Vector.<IEffectPass>();
				_passes[0]	= new LightScatteringPass(2, _occludedTarget, worldData[LightScatteringData].color, _backgroundColor);
				_passes[1]  = new SinglePassRenderingEffect(new BasicShader(), 0, finalTarget);
			}

			return _passes;	
		}
	}
}