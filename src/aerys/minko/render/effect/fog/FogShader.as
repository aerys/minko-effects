package aerys.minko.render.effect.fog
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	public class FogShader extends BasicShader
	{
		private var _fogPart	: FogShaderPart	= null;
		
		public function FogShader()
		{
			_fogPart = new FogShaderPart(this);
		}
		
		override protected function getPixelColor() : SFloat
		{
			return mix(
				super.getPixelColor(),
				sceneBindings.getParameter(Fog.COLOR, 4),
				_fogPart.getFogFactor()
			);
		}
	}
}