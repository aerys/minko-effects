package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
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
		private var _wireframePart	: WireframeShaderPart		= null;
		
		private var _weight			: SFloat 					= null;
		
		public function WireframeShader(renderTarget 	: RenderTarget 	= null,
										priority		: Number		= 0.)
		{
			super(renderTarget, priority);
			
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
			_weight = _wireframePart.getVertexWeight();
			
			return super.getVertexPosition();
		}
		
		override protected function getPixelColor() : SFloat
		{			
			var wireColor 		: uint		= meshBindings.getConstant(
				Wireframe.WIRE_COLOR, 0x000000ff
			);
			var surfaceColor 	: uint		= meshBindings.getConstant(
				Wireframe.SURFACE_COLOR, 0x00000000
			);
			
			var diffuseColor	: SFloat 	= meshBindings.propertyExists(Wireframe.WIRE_COLOR)
				? rgba(wireColor)
				: diffuse.getDiffuseColor();
			
			// the interpolated weight is a vector of dimension 3 containing
			// values representing the distance of the fragment to each side
			// of the triangle
			var wireFactor		: SFloat	= _wireframePart.getWireFactor(interpolate(_weight));
			
			// the final color of the pixel is l * line_color + (1 - l) * surface_color
			diffuseColor = mix(rgba(surfaceColor), diffuseColor, wireFactor);
			
			kill(multiply(lessThan(diffuseColor.a, .001), -1));
			
			return diffuseColor;
		}
	}
}