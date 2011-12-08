package aerys.minko.render.effect.vertexNormal
{
	import aerys.minko.render.shader.parts.animation.AnimationShaderPart;
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.animation.AnimationMethod;
	
	import flash.utils.Dictionary;
	
	public class VertexNormalShader extends ActionScriptShader
	{
		private static const ANIMATION : AnimationShaderPart = new AnimationShaderPart();
		
		private var _vertexNormal	: SValue	= null;
		
		override protected function getOutputPosition() : SValue
		{
			var animationMethod		: uint		= uint(getStyleConstant(AnimationStyle.METHOD, AnimationMethod.DISABLED));
			var maxInfluences		: uint		= uint(getStyleConstant(AnimationStyle.MAX_INFLUENCES, 0));
			var numBones			: uint		= uint(getStyleConstant(AnimationStyle.NUM_BONES, 0));
			var vertexPosition		: SValue	= ANIMATION.getVertexPosition(animationMethod, maxInfluences, numBones);
			
			_vertexNormal	= ANIMATION.getVertexNormal(animationMethod, maxInfluences, numBones);
			
			return multiply4x4(vertexPosition, localToScreenMatrix);
		}
		
		override protected function getOutputColor(kills : Vector.<SValue>) : SValue
		{
			return divide(add(1., interpolate(_vertexNormal)), 2.);
		}
		
		override public function getDataHash(styleData		: StyleData,
											 transformData	: TransformData,
											 worldData		: Dictionary) : String
		{
			return "vertexNormalColor" + ANIMATION.getDataHash(styleData, transformData, worldData);
		}
	}
}