package aerys.minko.render.effect.fog
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	
	import flash.utils.Dictionary;
	
	public class FogShader extends BasicShader
	{
		private static const FOG	: FogShaderPart	= new FogShaderPart();
		
		override protected function getOutputColor() : SValue
		{
			var fogColor 	: SValue	= getStyleParameter(4, FogStyle.COLOR);
			var fogFactor	: SValue	= FOG.getFogFactor();
			
			return mix(getOutputColor(), fogColor, fogFactor);
		}
		
		override public function getDataHash(styleData		: StyleData,
											 transformData	: TransformData,
											 worldData		: Dictionary) : String
		{
			return super.getDataHash(styleData, transformData, worldData)
				   + FOG.getDataHash(styleData, transformData, worldData);
		}
	}
}