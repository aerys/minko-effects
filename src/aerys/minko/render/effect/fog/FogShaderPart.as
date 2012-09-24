package aerys.minko.render.effect.fog
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.ShaderPart;
	
	public final class FogShaderPart extends ShaderPart
	{
		public function FogShaderPart(main : Shader)
		{
			super(main);
		}
		
		public function getFogFactor(start		: Object	= null,
									 distance	: Object	= null) : SFloat
		{
			start ||= float(0.);
			distance ||= cameraZFar;
			
			var viewPos		: SFloat	= localToView(interpolate(vertexXYZ));
			var fogFactor	: SFloat	= subtract(viewPos.z, start);
			
			return saturate(fogFactor.divide(distance));
		}
	}
}