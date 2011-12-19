package aerys.minko.render.effect.fog
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	
	import flash.utils.Dictionary;
	
	public class FogShader extends BasicShader
	{
		private var _fogPart	: FogShaderPart	= null;
		
		public function FogShader()
		{
			_fogPart = new FogShaderPart(this);
		}
		
		override protected function getOutputColor() : SValue
		{
			var fogColor 	: SValue	= getStyleParameter(4, FogStyle.COLOR);
			var fogFactor	: SValue	= _fogPart.getFogFactor();
			
			return mix(super.getOutputColor(), fogColor, fogFactor);
		}
		
		override public function getDataHash(styleData		: StyleData,
											 transformData	: TransformData,
											 worldData		: Dictionary) : String
		{
			return super.getDataHash(styleData, transformData, worldData)
				   + _fogPart.getDataHash(styleData, transformData, worldData);
		}
	}
}