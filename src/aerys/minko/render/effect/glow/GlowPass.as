package aerys.minko.render.effect.glow
{
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	
	import flash.utils.Dictionary;
	
	public class GlowPass implements IEffectPass
	{
		private var _shader	: GlowShader	= null;
		
		public function GlowPass(blur	: Number	= 0.165,
								 red	: Number	= 1.,
								 green	: Number	= 1.,
								 blue	: Number	= 1.,
								 alpha	: Number	= 1.)
		{
			_shader = new GlowShader(blur, red, green, blue, alpha);
		}
		
		public function fillRenderState(state			: RendererState,
										styleData		: StyleData, 
										transformData	: TransformData, 
										worldData		: Dictionary) : Boolean
		{
			_shader.fillRenderState(state, styleData, transformData, worldData);
			
			state.triangleCulling = TriangleCulling.FRONT;
			state.blending = Blending.ALPHA;
			
			return true;
		}
	}
}