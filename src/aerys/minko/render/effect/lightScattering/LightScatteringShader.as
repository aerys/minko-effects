package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.render.shader.part.DiffuseShaderPart;
	import aerys.minko.render.shader.part.animation.VertexAnimationShaderPart;
	
	public class LightScatteringShader extends BasicShader
	{
		private var _animation			: VertexAnimationShaderPart	= null;
		private var _diffuse			: DiffuseShaderPart			= null;

		private var _occlusionMap		: RenderTarget				= null;
		
		public function LightScatteringShader(occlusionMap	: RenderTarget)
		{
			super();
			
			_occlusionMap = occlusionMap;
			
			_animation = new VertexAnimationShaderPart(this);
			_diffuse = new DiffuseShaderPart(this);
		}
		
		override protected function initializeSettings(settings:ShaderSettings):void
		{
			super.initializeSettings(settings);
			
			settings.renderTarget = _occlusionMap;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return _animation.getAnimatedVertexPosition();
		}

		override protected function getPixelColor() : SFloat
		{
			var isLightSource	: Boolean	= meshBindings.getProperty(
				LightScatteringProperties.IS_LIGHT_SOURCE, false
			);
			
			/*var isSky			: Boolean	= meshBindings.getProperty(
				LightScattering.IS_SKY, false
			);*/
			
			var isTransparent	: Boolean	= meshBindings.getProperty(
				LightScatteringProperties.IS_TRANSPARENT, false
			);
			
			if (isLightSource)
				return sceneBindings.getParameter(LightScatteringProperties.SOURCE_COLOR, 4);
			/*else if (isSky)
				return sceneBindings.getParameter(LightScattering.SKY_COLOR, 4);*/
			else
			{	
				var diffuse : SFloat = _diffuse.getDiffuseColor();
				
				if (isTransparent)
					return diffuse.rgba;
				else
					return float4(0., 0., 0., diffuse.a);
			}
		}
	}
}