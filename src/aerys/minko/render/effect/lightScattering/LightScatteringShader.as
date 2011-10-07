package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringShader extends ActionScriptShader
	{
		private var _lightColor			: SValue	= null;
		private var _backgroundColor	: SValue	= null;
		
		public function LightScatteringShader(lightColor		: int,
											  backgroundColor	: int)
		{
			_lightColor = float4(((lightColor >> 16) & 0xff) / 255.,
								 ((lightColor >> 8) & 0xff) / 255.,
								 (lightColor & 0xff) / 255.,
								 1.);
			
			_backgroundColor = float4(((backgroundColor >> 16) & 0xff) / 255.,
									  ((backgroundColor >> 8) & 0xff) / 255.,
									  (backgroundColor & 0xff) / 255.,
									  1.);
		}
		
		override protected function getOutputPosition() : SValue
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor() : SValue
		{		
			if (getStyleConstant(LightScatteringStyle.IS_LIGHT_SOURCE, false))
				return _lightColor;
			else if (getStyleConstant(LightScatteringStyle.IS_SKY, false))
				return _backgroundColor;
			else
				return float4(0., 0., 0., 1.);
		}
		
		override public function getDataHash(styleData 		: StyleData,
											 transformData	: TransformData,
						 					 world 			: Dictionary) : String
		{
			var hash : String	= "occluding";
			
			if (styleData.get(LightScatteringStyle.IS_LIGHT_SOURCE, false))
				hash += "_lightSource";
			if (styleData.get(LightScatteringStyle.IS_SKY, false))
				hash += "_sky";
			
			return hash;
		}
		
		override public function fillRenderState(state			: RendererState, 
												 styleData  	: StyleData, 
												 transformData	: TransformData, 
												 worldData		: Dictionary) : void
		{			
			super.fillRenderState(state, styleData, transformData, worldData);
		}
	}
}