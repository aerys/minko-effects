package aerys.minko.render.effect.glow
{
	import aerys.minko.render.effect.IEffect;
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.effect.basic.BasicEffect;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	
	import flash.utils.Dictionary;
	
	public class GlowEffect implements IEffect
	{
		private var _passes	: Vector.<IEffectPass>	= new Vector.<IEffectPass>();
		
		public function GlowEffect(blur		: Number	= 0.165,
								   red		: Number	= 1.,
								   green	: Number	= 1.,
								   blue		: Number	= 1.,
								   alpha	: Number	= 1.)
		{
			initialize(blur, red, green, blue, alpha);
		}
		
		private function initialize(blur	: Number	= 0.165,
									red		: Number	= 1.,
									green	: Number	= 1.,
									blue	: Number	= 1.,
									alpha	: Number	= 1.) : void
		{
			_passes[0] = new GlowPass(blur, red, green, blue, alpha);
			_passes[1] = new BasicEffect();
		}
		
		public function getPasses(styleData		: StyleData,
								  transformData	: TransformData,
								  worldData		: Dictionary) : Vector.<IEffectPass>
		{
			return _passes;
		}
	}
}