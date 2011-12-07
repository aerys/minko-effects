package aerys.minko.render.effect.normalMapping
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SValue;
	
	public class NormalMappingShader extends BasicShader
	{
		private static const NORMAL_MAPPING	: NormalMappingShaderPart	= new NormalMappingShaderPart();
		
		override protected function getOutputColor(kills : Vector.<SValue>) : SValue
		{
			var diffuse 		: SValue 	= super.getOutputColor(kills);
			var illumination	: SValue	= NORMAL_MAPPING.getIllumination(cameraLocalDirection,
																			 float4(1., 1., 1., 1.),
																			 0.8,
																			 64);
			
			return float4(multiply(diffuse.rgb, illumination), diffuse.a);
		}
	}
}