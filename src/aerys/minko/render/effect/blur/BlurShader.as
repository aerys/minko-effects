package aerys.minko.render.effect.blur
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	
	public class BlurShader extends Shader
	{
		private var _postProcessing	: PostProcessingShaderPart	= null;
		private var _blur			: BlurShaderPart			= null;
		
		private var _blurSource		: ITextureResource			= null;
		
		protected function get blurSourceTexture() : SFloat
		{
			var source : SFloat	= _postProcessing.backBufferTexture;
			
			if (_blurSource != null)
			{
				source = getTexture(
					_blurSource,
					SamplerFiltering.LINEAR,
					SamplerMipMapping.DISABLE,
					SamplerWrapping.CLAMP
				);
			}
			
			return source;
		}
		
		public function BlurShader(renderTarget	: RenderTarget 		= null,
								   priority		: Number			= 0.0,
								   blurSource	: ITextureResource	= null)
		{
			super(renderTarget, priority);
			
			_postProcessing = new PostProcessingShaderPart(this);
			_blur = new BlurShaderPart(this);
			
			_blurSource = blurSource;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat
		{
			return _blur.gaussianBlur(
				blurSourceTexture,
				float2(viewportWidth, viewportHeight)
			);
		}
	}
}