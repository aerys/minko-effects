package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.render.shader.part.DiffuseShaderPart;
	import aerys.minko.render.shader.part.animation.VertexAnimationShaderPart;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	public class WireframeShader extends BasicShader
	{
		private var _diffusePart	: DiffuseShaderPart			= null;
		private var _animationPart	: VertexAnimationShaderPart	= null;
		private var _wireframePart	: WireframeShaderPart		= null;
		
		private var _weight			: SFloat 	= null;
		
		public function WireframeShader()
		{
			_diffusePart = new DiffuseShaderPart(this);
			_animationPart = new VertexAnimationShaderPart(this);
			_wireframePart = new WireframeShaderPart(this);
		}
		
		override protected function initializeSettings(settings : ShaderSettings) : void
		{
			super.initializeSettings(settings);
			
			settings.depthWriteEnabled = false;
			settings.triangleCulling = TriangleCulling.NONE;
			settings.blending = Blending.ADDITIVE;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			var coeff	: Number	= meshBindings.getConstant(Wireframe.WIRE_THICKNESS, 20.);

			coeff = 2000 - coeff * 50;
				
			_weight = _wireframePart.getVertexWeight(coeff);
			
			return super.getVertexPosition();
		}
		
		private function vector4FromARGB(argb : uint) : Vector4
		{
			return new Vector4(
				(uint(argb & 0x00ff0000) >> 16) / 0xff,
				(uint(argb & 0x0000ff00) >> 8) / 0xff,
				(uint(argb & 0x000000ff) / 0xff),
				(uint(argb & 0xff000000) >> 24) / 0xff
			);
		}
		
		override protected function getPixelColor() : SFloat
		{			
			var wireColor : uint	= meshBindings.getConstant(
				Wireframe.WIRE_COLOR, 0x000000ff
			);
			var surfaceColor : uint	= meshBindings.getConstant(
				Wireframe.SURFACE_COLOR, 0x00000000
			);
			
			var diffuse	: SFloat = meshBindings.propertyExists(Wireframe.WIRE_COLOR)
				? rgba(wireColor)
				: null;
			
			if (diffuse == null)
				diffuse = _diffusePart.getDiffuse();
			
			// the interpolated weight is a vector of dimension 3 containing
			// values representing the distance of the fragment to each side
			// of the triangle
			var wireFactor		: SFloat	= _wireframePart.getWireFactor(interpolate(_weight));
			
			// the final color of the pixel is l * line_color + (1 - l) * surface_color
			diffuse = mix(rgba(surfaceColor), diffuse, wireFactor);
			
//			kill(multiply(diffuse.a.lessThan(.05), -1));
			
			return diffuse;
		}
	}
}