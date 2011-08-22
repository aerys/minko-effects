package aerys.minko.render.effect.fog
{
	import aerys.minko.render.shader.ActionScriptShaderPart;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.fog.Fog;

	public final class FogShaderPart extends ActionScriptShaderPart
	{
		public function getFogColor(start		: Object,
									distance	: Object,
									color		: Object) : SValue
		{
			return new SValue(new Fog(getNode(start), getNode(distance), getNode(color)));
		}
	}
}