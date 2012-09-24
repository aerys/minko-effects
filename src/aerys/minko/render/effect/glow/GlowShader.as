package aerys.minko.render.effect.glow
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;

	public final class GlowShader extends Shader
	{
		private var _color	: Vector4	= null;
		private var _blur	: Number	= 0.;
		
		public function GlowShader(blur		: Number	= 0.165,
								   red		: Number	= 1.,
								   green	: Number	= 1.,
								   blue		: Number	= 1.,
								   alpha	: Number	= 1.)
		{
			_blur = blur;
			_color = new Vector4(red, green, blue, alpha);
		}
		
		override protected function initializeSettings(settings : ShaderSettings) : void
		{
			settings.triangleCulling = TriangleCulling.FRONT;
			settings.blending = Blending.ALPHA;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			var pos	: SFloat	= localToView(vertexXYZ);
			
			pos.scaleBy(float3(1. + _blur, 1. + _blur, 1.));
			
			return pos.multiply4x4(projectionMatrix);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var normal 	: SFloat	= interpolate(vertexNormal);
			var angle 	: SFloat 	= negate(normal.dotProduct3(worldToLocal(cameraPosition)));
			
			return multiply(_color, power(subtract(0.8, angle), 12.0));
		}
	}
}