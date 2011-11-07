package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.effect.animation.AnimationShaderPart;
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.resource.Texture3DResource;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.Components;
	import aerys.minko.render.shader.node.operation.builtin.Multiply3x4;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.animation.AnimationMethod;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.CompareMode;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	
	/*
	 * Implementation of the Single-Pass Wireframe rendering technique from 
	 * J. Andreas Bærentzen, Steen Lund Nielsen, Mikkel Gjøl, and Bent D. Larsen.
	 * 
	 * References:
	 *     - original article: http://cgg-journal.com/2008-2/06/index.html
	 *     - minimole implementation: https://github.com/lidev/minimole-core/tree/master/com/li/minimole/materials
	 */
	public class WireframeEffect extends SinglePassEffect implements IRenderingEffect
	{
		private static const WIREFRAME_SHADER	: WireframeShader	= new WireframeShader();
		
		
		public function WireframeEffect(priority		: Number		= 0,
										renderTarget	: RenderTarget	= null)
		{			
			super(WIREFRAME_SHADER, priority, renderTarget);
		}
		
		override public function fillRenderState(state		: RendererState, 
												 style		: StyleData, 
												 transform	: TransformData, 
												 world		: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, transform, world);
			
			state.triangleCulling = TriangleCulling.DISABLED;
			
			var surfaceColor	: uint	= style.get(WireframeStyle.SURFACE_COLOR, 0x00000000) as uint;
			
			if (surfaceColor & 0xff000000 < 0xff000000)
			{
				state.depthTest	= CompareMode.ALWAYS;
				state.blending =  style.get(BasicStyle.BLENDING, Blending.ADDITIVE) as uint;
			}
			return true;
		}
	}
}