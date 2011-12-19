package aerys.minko.render.effect.fog
{
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.ActionScriptShaderPart;
	import aerys.minko.render.shader.SValue;

	public final class FogShaderPart extends ActionScriptShaderPart
	{
		public function FogShaderPart(main : ActionScriptShader)
		{
			super(main);
		}
		
		public function getFogFactor(start		: Object	= null,
									 distance	: Object	= null) : SValue
		{
			start ||= float(0.);
			distance ||= cameraFarClipping;
			
			var depth		: SValue	= multiply4x4(interpolate(vertexPosition), localToViewMatrix).z;
			var fogFactor	: SValue	= subtract(depth, start);
			
			return saturate(fogFactor.divide(distance));
		}
	}
}