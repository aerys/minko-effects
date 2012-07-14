package aerys.minko.render.effect.hdr
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	
	public class CloneShader extends Shader
	{
		private var _postProcessing	: PostProcessingShaderPart	= null;
		
		private var _source			: ITextureResource			= null;
		
		public function CloneShader(source			: ITextureResource	= null,
									renderTarget	: RenderTarget		= null,
									priority		: Number			= 0.0)
		{
			super(renderTarget, priority);
		
			_source = source;
			
			_postProcessing = new PostProcessingShaderPart(this);
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat
		{
			return _source
				? sampleTexture(getTexture(_source), interpolate(vertexUV))
				: _postProcessing.backBufferPixel;
		}
	}
}