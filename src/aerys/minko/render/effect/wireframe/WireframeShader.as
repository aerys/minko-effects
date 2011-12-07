package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.effect.animation.AnimationShaderPart;
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.effect.diffuse.DiffuseShaderPart;
	import aerys.minko.render.resource.texture.FlatTextureResource;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.Components;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.animation.AnimationMethod;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	public class WireframeShader extends ActionScriptShader
	{
		private static const ANIMATION	: AnimationShaderPart	= new AnimationShaderPart();
		private static const DIFFUSE	: DiffuseShaderPart		= new DiffuseShaderPart();
		private static const WIREFRAME	: WireframeShaderPart	= new WireframeShaderPart();
		
		private var _weight						: SValue 	= null;
		
		override protected function getOutputPosition() : SValue
		{
			var coeff			: Number	= getStyleConstant(WireframeStyle.WIRE_THICKNESS, 20.) as Number

			coeff = 2000 - coeff * 50;
				
			_weight = WIREFRAME.getVertexWeight(coeff);
			
			var animationMethod	: uint		= uint(getStyleConstant(AnimationStyle.METHOD, AnimationMethod.DISABLED));
			var maxInfluences	: uint		= uint(getStyleConstant(AnimationStyle.MAX_INFLUENCES, 0));
			var numBones		: uint		= uint(getStyleConstant(AnimationStyle.NUM_BONES, 0));
			var vertexPosition	: SValue	= ANIMATION.getVertexPosition(animationMethod, maxInfluences, numBones);
			
			return multiply4x4(vertexPosition, localToScreenMatrix);
		}
		
		private function vector4FromARGB(argb : uint) : Vector4
		{
			return new Vector4((uint(argb & 0x00ff0000) >> 16) / 0xff,
				(uint(argb & 0x0000ff00) >> 8) / 0xff,
				(uint(argb & 0x000000ff) / 0xff),
				(uint(argb & 0xff000000) >> 24) / 0xff)
		}
		
		override protected function getOutputColor(kills : Vector.<SValue>) : SValue
		{			
			var wireColor		: uint	= getStyleConstant(WireframeStyle.WIRE_COLOR, 0) as uint;
			var surfaceColor	: uint	= getStyleConstant(WireframeStyle.SURFACE_COLOR, 0x00000000) as uint;
			
			var diffuse 		: SValue = styleIsSet(WireframeStyle.WIRE_COLOR) ? null : float4(vector4FromARGB(wireColor));
			
			if (!diffuse)
			{
				var diffuseStyle : Object = styleIsSet(BasicStyle.DIFFUSE) ? getStyleConstant(BasicStyle.DIFFUSE) : null;
				DIFFUSE.getDiffuseColor(diffuseStyle);
			}
			
			// the interpolated weight is a vector of dimension 3 containing
			// values representing the distance of the fragment to each side
			// of the triangle
			var wireFactor		: SValue	= WIREFRAME.getWireFactor(interpolate(_weight));
			
			// the final color of the pixel is l * line_color + (1 - l) * surface_color
			return mix(vector4FromARGB(surfaceColor), diffuse, wireFactor);
		}
		
		override public function getDataHash(style		: StyleData,
											 transform	: TransformData,
											 world		: Dictionary) : String
		{
			var hash 			: String	= "wireframe";
			
			var wireColor		: uint	= getStyleConstant(WireframeStyle.WIRE_COLOR, 0) as uint;
			var surfaceColor	: uint	= getStyleConstant(WireframeStyle.SURFACE_COLOR, 0) as uint;
			
			hash += "_wireColor=" + (styleIsSet(WireframeStyle.WIRE_COLOR) ? "diffuse" : wireColor);
			hash += "_surfaceColor=" + surfaceColor;
			hash += "_wireThicknessCoeff=" + getStyleConstant(WireframeStyle.WIRE_THICKNESS, 1000.);
			
			hash += super.getDataHash(style, transform, world);
			
			hash += DIFFUSE.getDataHash(style, transform, world);
			hash += ANIMATION.getDataHash(style, transform, world);				
			
			return hash;
		}
	}
}