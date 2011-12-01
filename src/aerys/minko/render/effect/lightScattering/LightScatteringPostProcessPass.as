package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.resource.TextureResource;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.data.ViewportData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.CompareMode;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringPostProcessPass implements IEffectPass
	{
		private var _lightScatteringPostProcessShader	: LightScatteringPostProcessShader	= null;
		
		private var _priority 							: Number							= 0;
		private var _renderTarget						: RenderTarget						= null;
		
		public function LightScatteringPostProcessPass(num_samples			: Number,
													   nb_passes			: Number,
													   cur_passe			: Number,
													   occludedSource		: TextureResource,
													   renderTarget			: RenderTarget,
													   priority				: Number,
													   exposure				: Number,
													   decay				: Number,
													   weight				: Number,
													   density				: Number,
													   lightPos				: Vector4)
		{
			_lightScatteringPostProcessShader = new LightScatteringPostProcessShader(num_samples,
																					 nb_passes,
																					 cur_passe,
																					 occludedSource,
																					 exposure,
																					 decay,
																					 weight,
																					 density,
																					 lightPos);
			_priority = priority;
			_renderTarget = renderTarget;
		}
		
		public function fillRenderState(state 			: RendererState,
										styleData 		: StyleData,
										transformData 	: TransformData,
										worldData 		: Dictionary) : Boolean
		{
			state.depthTest			= CompareMode.ALWAYS;
			state.blending			= Blending.ADDITIVE;
			state.triangleCulling	= TriangleCulling.DISABLED;
			state.priority			= _priority;
			state.rectangle			= null;
			state.renderTarget 		= _renderTarget || worldData[ViewportData].backBufferRenderTarget;
			
			_lightScatteringPostProcessShader.fillRenderState(state, styleData, transformData, worldData);
			
			return true;
		}
	}
}