package aerys.minko.render.effect.hdr
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	
	public class HDRShader extends Shader
	{
		private var _original		: ITextureResource;
		private var _half			: ITextureResource;
		private var _quarter		: ITextureResource;
		
		private var _postProcessing	: PostProcessingShaderPart;
		
		public function HDRShader(original		: ITextureResource,
								  half			: ITextureResource,
								  quarter		: ITextureResource,
								  renderTarget	: RenderTarget	= null,
								  priority		: Number		= 0.0)
		{
			super(renderTarget, priority);
			
			_original = original;
			_half = half;
			_quarter = quarter;
			
			_postProcessing = new PostProcessingShaderPart(this);
		}
		
		override protected function getVertexPosition():SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor():SFloat
		{
			var uv		: SFloat	= interpolate(vertexUV);
			var color	: SFloat	= _postProcessing.backBufferPixel;
			
			color.incrementBy(sampleTexture(
				getTexture(_original, SamplerFiltering.LINEAR, SamplerMipMapping.LINEAR, SamplerWrapping.CLAMP),
				uv
			));
			color.incrementBy(sampleTexture(
				getTexture(_half, SamplerFiltering.LINEAR, SamplerMipMapping.LINEAR, SamplerWrapping.CLAMP),
				uv
			));
			color.incrementBy(sampleTexture(
				getTexture(_quarter, SamplerFiltering.LINEAR, SamplerMipMapping.LINEAR, SamplerWrapping.CLAMP),
				uv
			));
			
			return color;
		}
	}
}