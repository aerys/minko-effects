package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.parts.animation.AnimationShaderPart;
	import aerys.minko.render.shader.parts.diffuse.DiffuseShaderPart;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.animation.AnimationMethod;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	public class WireframeShader extends ActionScriptShader
	{
		private var _diffusePart	: DiffuseShaderPart		= null;
		private var _animationPart	: AnimationShaderPart	= null;
		private var _wireframePart	: WireframeShaderPart	= null;
		
		private var _weight			: SValue 	= null;
		
		public function WireframeShader()
		{
			_diffusePart = new DiffuseShaderPart(this);
			_animationPart = new AnimationShaderPart(this);
			_wireframePart = new WireframeShaderPart(this);
		}
		
		override protected function getOutputPosition() : SValue
		{
			var coeff			: Number	= getStyleConstant(WireframeStyle.WIRE_THICKNESS, 20.) as Number

			coeff = 2000 - coeff * 50;
				
			_weight = _wireframePart.getVertexWeight(coeff);
			
			var animationMethod	: uint		= uint(getStyleConstant(AnimationStyle.METHOD, AnimationMethod.DISABLED));
			var maxInfluences	: uint		= uint(getStyleConstant(AnimationStyle.MAX_INFLUENCES, 0));
			var numBones		: uint		= uint(getStyleConstant(AnimationStyle.NUM_BONES, 0));
			var vertexPosition	: SValue	= _animationPart.getVertexPosition(animationMethod, maxInfluences, numBones);
			
			return multiply4x4(vertexPosition, localToScreenMatrix);
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
		
		override protected function getOutputColor() : SValue
		{			
			var wireColor		: uint	= getStyleConstant(WireframeStyle.WIRE_COLOR, 0) as uint;
			var surfaceColor	: uint	= getStyleConstant(WireframeStyle.SURFACE_COLOR, 0x00000000) as uint;
			
			var diffuse 		: SValue = styleIsSet(WireframeStyle.WIRE_COLOR)
										   ? rgba(wireColor)
										   : null;
			
			if (diffuse == null)
			{
				var diffuseStyle : Object = styleIsSet(BasicStyle.DIFFUSE)
											? getStyleConstant(BasicStyle.DIFFUSE)
											: null;
				
				diffuse = _diffusePart.getDiffuseColor(diffuseStyle);
			}
			
			// the interpolated weight is a vector of dimension 3 containing
			// values representing the distance of the fragment to each side
			// of the triangle
			var wireFactor		: SValue	= _wireframePart.getWireFactor(interpolate(_weight));
			
			// the final color of the pixel is l * line_color + (1 - l) * surface_color
			diffuse = mix(rgba(surfaceColor), diffuse, wireFactor);
			
//			kill(multiply(diffuse.a.lessThan(.05), -1));
			
			return diffuse;
		}
		
		override public function getDataHash(style		: StyleData,
											 transform	: TransformData,
											 world		: Dictionary) : String
		{
			var hash 			: String	= super.getDataHash(style, transform, world);
			
			var wireColor		: uint	= getStyleConstant(WireframeStyle.WIRE_COLOR, 0) as uint;
			var surfaceColor	: uint	= getStyleConstant(WireframeStyle.SURFACE_COLOR, 0) as uint;
			
			hash += _diffusePart.getDataHash(style, transform, world);
			hash += _animationPart.getDataHash(style, transform, world);
			
			hash += "_wireColor=" + (styleIsSet(WireframeStyle.WIRE_COLOR) ? "diffuse" : wireColor);
			hash += "_surfaceColor=" + surfaceColor;
			hash += "_wireThicknessCoeff=" + getStyleConstant(WireframeStyle.WIRE_THICKNESS, 1000.);
			
			return hash;
		}
	}
}