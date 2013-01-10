package aerys.minko.render.effect.glow
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;

	public final class GlowShader extends Shader
	{
		private var _color			: Vector4;
		private var _blur			: Number;
		
		public function GlowShader(renderTarget	: RenderTarget	= null,
								   priority		: Number		= .0,
								   blur			: Number		= 0.65,
								   color		: uint			= 0xffffffff)
		{
			super(renderTarget, priority);
			
			_blur			= blur;
			_color			= new Vector4(
				Number((color >> 24) & 0xff)	/ 255.0,
				Number((color >> 16) & 0xff)	/ 255.0,
				Number((color >> 8) & 0xff)		/ 255.0,
				Number(color & 0xff)			/ 255.0
			);
		}

		override protected function initializeSettings(settings : ShaderSettings) : void
		{
			super.initializeSettings(settings);
			
			settings.depthWriteEnabled	= false;
			settings.triangleCulling	= TriangleCulling.FRONT;
			settings.blending			= Blending.ADDITIVE;
		}

		override protected function getVertexPosition() : SFloat
		{
			var pos		: SFloat	= localToView(vertexXYZ);
			pos						= add(pos, multiply(vertexNormal, float3(_blur, _blur, 0.)));
			
			return multiply4x4(pos, projectionMatrix);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var normal 	: SFloat	= interpolate(vertexNormal);
			var angle 	: SFloat 	= negate(dotProduct3(normal, cameraDirection));
			var color	: SFloat	= float4(_color.x, _color.y, _color.z, _color.w);
			var power	: SFloat	= power(subtract(0.8, angle), 12.0);
			color					= multiply(color, power.xxxx);
			
			return color;
		}
	}
}