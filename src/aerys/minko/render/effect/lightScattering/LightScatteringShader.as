package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.resource.texture.FlatTextureResource;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.parts.animation.AnimationShaderPart;
	import aerys.minko.render.shader.parts.diffuse.DiffuseShaderPart;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	public class LightScatteringShader extends ActionScriptShader
	{
		private var _animationShaderPart	: AnimationShaderPart	= null;
		private var _diffuseShaderPart		: DiffuseShaderPart		= null;

		private var _lightColor				: SValue				= null;
		private var _backgroundColor		: SValue				= null;
		
		public function LightScatteringShader(lightColor		: int,
											  backgroundColor	: int)
		{
			_lightColor = float4(((lightColor >> 16) & 0xff) / 255.,
								 ((lightColor >> 8) & 0xff) / 255.,
								 (lightColor & 0xff) / 255.,
								 1.);
			
			_backgroundColor = float4(((backgroundColor >> 16) & 0xff) / 255.,
									  ((backgroundColor >> 8) & 0xff) / 255.,
									  (backgroundColor & 0xff) / 255.,
									  1.);
			
			_animationShaderPart = new AnimationShaderPart(this);
			_diffuseShaderPart = new DiffuseShaderPart(this);
		}
		
		override protected function getOutputPosition() : SValue
		{
			return vertexClipspacePosition;
		}

		override protected function getOutputColor() : SValue
		{
			if (getStyleConstant(LightScatteringStyle.IS_LIGHT_SOURCE, false))
				return _lightColor;
			else if (getStyleConstant(LightScatteringStyle.IS_SKY, false))
				return _backgroundColor;
			else
			{	
				var diffuse 		: SValue	= null;
				var diffuseStyle	: Object 	= getStyleConstant(BasicStyle.DIFFUSE);
				
				if (styleIsSet(BasicStyle.DIFFUSE))
				{
					if (diffuseStyle is uint || diffuseStyle is Vector4)
						diffuse = getStyleParameter(4, BasicStyle.DIFFUSE);
					else if (diffuseStyle is FlatTextureResource)
						diffuse = sampleTexture(BasicStyle.DIFFUSE, interpolate(vertexUV));
					else
						throw new Error('Invalid BasicStyle.DIFFUSE value.');
				}
				else
					diffuse = float4(interpolate(vertexRGBColor).rgb, 1.);
				
				if (getStyleConstant(LightScatteringStyle.HAS_COLOR, false))
				{
					var color 	: int 		= getStyleConstant(LightScatteringStyle.HAS_COLOR, false) as int;
					
					return float4(((color >> 16) & 0xff) / 255.,
						((color >> 8) & 0xff) / 255.,
						(color & 0xff) / 255.,
						diffuse.a);
				}
				else
					return float4(0., 0., 0., diffuse.a);
			}
		}
		
		override public function getDataHash(styleData 		: StyleData,
											 transformData	: TransformData,
											 world 			: Dictionary) : String
		{
			var hash : String	= "occluding";
			
			if (styleData.get(LightScatteringStyle.IS_LIGHT_SOURCE, false))
				hash += "_lightSource";
			if (styleData.get(LightScatteringStyle.IS_SKY, false))
				hash += "_sky";
			if (styleData.get(LightScatteringStyle.HAS_COLOR, false))
				hash += "_color";
			
			var diffuseStyle 	: Object 	= styleData.isSet(BasicStyle.DIFFUSE)
				? styleData.get(BasicStyle.DIFFUSE)
				: null;
			
			hash += "basic";
			if (diffuseStyle == null)
				hash += '_colorFromVertex';
			else if (diffuseStyle is uint || diffuseStyle is Vector4)
				hash += '_colorFromConstant';
			else if (diffuseStyle is FlatTextureResource)
				hash += '_colorFromTexture';
			else
				throw new Error('Invalid BasicStyle.DIFFUSE value');
			
			return hash;
		}
		
//		override protected function getOutputColor() : SValue
//		{		
//			if (getStyleConstant(LightScatteringStyle.IS_LIGHT_SOURCE, false))
//				return _lightColor;
//			else if (getStyleConstant(LightScatteringStyle.IS_SKY, false))
//				return _backgroundColor;
//			else
//			{
//				var diffuseStyle : Object = styleIsSet(BasicStyle.DIFFUSE) ? 
//					getStyleConstant(BasicStyle.DIFFUSE) : null;
//				
//				var diffuse : SValue = _diffuseShaderPart.getDiffuseColor(diffuseStyle);
//				
//				if (getStyleConstant(LightScatteringStyle.HAS_COLOR, false))
//				{
//					var color 	: int 		= getStyleConstant(LightScatteringStyle.HAS_COLOR, false) as int;
//					
//					return float4(((color >> 16) & 0xff) / 255.,
//								  ((color >> 8) & 0xff) / 255.,
//								  (color & 0xff) / 255.,
//								  diffuse.a);
//				}
//				else
//					return float4(0., 0., 0., diffuse.a);
//			}
////				return float4(0., 0., 0., 1.);
//		}
//		
//		override public function getDataHash(styleData 		: StyleData,
//											 transformData	: TransformData,
//						 					 worldData		: Dictionary) : String
//		{			
//			var hash : String	= "occluding";
//			
//			if (styleData.get(LightScatteringStyle.IS_LIGHT_SOURCE, false))
//				hash += "_lightSource";
//			if (styleData.get(LightScatteringStyle.IS_SKY, false))
//				hash += "_sky";
//			if (styleData.get(LightScatteringStyle.HAS_COLOR, false))
//				hash += "_color";
//			
//			var diffuseStyle 	: Object 	= styleData.isSet(BasicStyle.DIFFUSE)
//				? styleData.get(BasicStyle.DIFFUSE)
//				: null;
//			
//			hash += _diffuseShaderPart.getDataHash(styleData, transformData, worldData);
//			hash += _animationShaderPart.getDataHash(styleData, transformData, worldData);
//			
//			return hash;
//		
//		}
		
		override public function fillRenderState(state			: RendererState, 
												 styleData  	: StyleData, 
												 transformData	: TransformData, 
												 worldData		: Dictionary) : void
		{			
			super.fillRenderState(state, styleData, transformData, worldData);
		}
	}
}