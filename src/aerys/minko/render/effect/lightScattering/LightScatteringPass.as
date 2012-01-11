package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.shader.IShader;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.DepthTest;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringPass implements IEffectPass
	{
		private var _lightScatteringShader	: IShader				= null;
		
		private var _priority 				: Number				= 0;
		private var _renderTarget			: AbstractRenderTarget	= null;
		private var _blending				: uint					= 0;
		
		public function get blending() : uint
		{
			return _blending;
		}
		
		public function set blending(value : uint) : void
		{
			_blending = value;
		}
		
		public function LightScatteringPass(priority		: Number,
											renderTarget	: AbstractRenderTarget,
											lightColor		: int,
											backgroundColor	: int)
		{
			_lightScatteringShader = new LightScatteringShader(lightColor, backgroundColor);
			_priority = priority;
			_renderTarget = renderTarget;
		}
		
		public function fillRenderState(state 			: RendererState,
										styleData	 	: StyleData,
										transformData	: TransformData,
										worldData 		: Dictionary) : Boolean
		{
			state.depthTest = DepthTest.LESS;
			state.priority = _priority;
			state.renderTarget = _renderTarget;
			state.blending = _blending;
			
			if (_blending != Blending.NORMAL)
				state.priority -= 0.5;
			
			_lightScatteringShader.fillRenderState(state, styleData, transformData, worldData);
			
			return true;
		}
	}
}