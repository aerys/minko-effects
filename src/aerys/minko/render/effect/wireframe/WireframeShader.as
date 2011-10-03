package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.effect.animation.AnimationShaderPart;
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.resource.Texture3DResource;
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
		private static const WIREFRAME	: WireframeShaderPart	= new WireframeShaderPart();
		
		private var _weight						: SValue 	= null;
		
		override protected function getOutputPosition() : SValue
		{
			_weight = (WIREFRAME.vertexWeight);
			
			var animationMethod	: uint		= getStyleConstant(AnimationStyle.METHOD, AnimationMethod.DISABLED)
				as uint;
			var maxInfluences	: uint		= getStyleConstant(AnimationStyle.MAX_INFLUENCES, 0)
				as uint;
			var numBones		: uint		= getStyleConstant(AnimationStyle.NUM_BONES, 0)
				as uint;
			var vertexPosition	: SValue	= ANIMATION.getVertexPosition(animationMethod, maxInfluences, numBones);
			
			return multiply4x4(vertexPosition, localToScreenMatrix);
		}
		
		override protected function getOutputColor() : SValue
		{			
			var wireColor		: Vector4	= getStyleConstant(WireframeStyle.WIRE_COLOR, new Vector4(NaN, NaN, NaN)) as Vector4;
			var surfaceColor	: Vector4	= getStyleConstant(WireframeStyle.SURFACE_COLOR, new Vector4(0., 0., 0., 0.)) as Vector4;
			
			var diffuse 		: SValue	= isNaN(wireColor.x) ? super.getOutputColor() : float4(wireColor);
			
			// the interpolated weight is a vector of dimension 3 containing
			// values representing the distance of the fragment to each side
			// of the triangle
			var wireFactor		: SValue	= WIREFRAME.getWireFactor(interpolate(_weight));
			
			// the final color of the pixel is l * line_color + (1 - l) * surface_color
			return mix(surfaceColor, diffuse, wireFactor);
		}
		
		override public function getDataHash(style		: StyleData,
											 transform	: TransformData,
											 world		: Dictionary) : String
		{
			var hash 			: String	= "wireframe";
			
			var wireColor		: Vector4	= getStyleConstant(WireframeStyle.WIRE_COLOR, new Vector4(NaN, NaN, NaN)) as Vector4;
			var surfaceColor	: Vector4	= getStyleConstant(WireframeStyle.SURFACE_COLOR, new Vector4(0., 0., 0., 0.)) as Vector4;
			
			hash += "_wireColor=" + (isNaN(wireColor.x) ? "diffuse" : wireColor);
			hash += "_surfaceColor=" + surfaceColor;
			
			hash += super.getDataHash(style, transform, world);
			
			
			var diffuseStyle 	: Object 	= style.isSet(BasicStyle.DIFFUSE)
				? style.get(BasicStyle.DIFFUSE)
				: null;
			
			if (diffuseStyle == null)
				hash += '_colorFromVertex';
			else if (diffuseStyle is uint || diffuseStyle is Vector4)
				hash += '_colorFromConstant';
			else if (diffuseStyle is Texture3DResource)
				hash += '_colorFromTexture';
			else
				throw new Error('Invalid BasicStyle.DIFFUSE value');
			
			hash += ANIMATION.getDataHash(style, transform, world);				
			
			return hash;
		}
	}
}