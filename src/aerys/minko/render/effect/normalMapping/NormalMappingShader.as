package aerys.minko.render.effect.normalMapping
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SValue;
	
	public class NormalMappingShader extends BasicShader
	{
		private var _normalMappingPart	: NormalMappingShaderPart	= null;
		
		public function NormalMappingShader()
		{
			super();
			
			_normalMappingPart = new NormalMappingShaderPart(main);
		}
		
		override protected function getOutputColor() : SValue
		{
			var diffuse 		: SValue 	= super.getOutputColor();
			var illumination	: SValue	= _normalMappingPart.getIllumination(cameraLocalDirection,
																			 float4(1., 1., 1., 1.),
																			 0.8,
																			 64);
			
			return float4(multiply(diffuse.rgb, illumination), diffuse.a);
		}
	}
}