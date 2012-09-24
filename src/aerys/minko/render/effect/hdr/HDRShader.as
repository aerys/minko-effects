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
		private var _resources		: Vector.<ITextureResource>;
		
		private var _postProcessing	: PostProcessingShaderPart;
		
		public function HDRShader(resources		: Vector.<ITextureResource>,
								  renderTarget	: RenderTarget	= null,
								  priority		: Number		= 0.0)
		{
			super(renderTarget, priority);
			
			_resources = resources;
			
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
			var hdr		: SFloat	= float3(0, 0, 0);
		
			for each (var ressource : ITextureResource in _resources)
			{
				var texture : SFloat = getTexture(
					ressource,
					SamplerFiltering.LINEAR,
					SamplerMipMapping.LINEAR,
					SamplerWrapping.CLAMP
				);
				
				hdr.incrementBy(sampleTexture(texture, uv));
			}
			
			return float4(add(color.xyz, hdr.xyz), color.a);
		}
	}
}