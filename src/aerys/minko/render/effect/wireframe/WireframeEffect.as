package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.TriangleCulling;
	
	import flash.utils.Dictionary;

	
	/*
	 * Implementation of the Single-Pass Wireframe rendering technique from 
	 * J. Andreas Bærentzen, Steen Lund Nielsen, Mikkel Gjøl, and Bent D. Larsen.
	 * 
	 * References:
	 *     - original article: http://cgg-journal.com/2008-2/06/index.html
	 *     - minimole implementation: https://github.com/lidev/minimole-core/tree/master/com/li/minimole/materials
	 */
	public class WireframeEffect extends SinglePassRenderingEffect
	{
		private static const WIREFRAME_SHADER	: WireframeShader	= new WireframeShader();
		
		
		public function WireframeEffect(priority		: Number		= 0,
										renderTarget	: AbstractRenderTarget	= null)
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
			
			if (uint(surfaceColor & 0xff000000) < 0xff000000)
			{
				state.depthTest	= DepthTest.ALWAYS;
				state.blending =  Blending.ADDITIVE;
			}
			
			return true;
		}
	}
}