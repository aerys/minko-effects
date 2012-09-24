package aerys.minko.render.effect.dof
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	
	public class DepthOfFieldShader extends Shader
	{
		private var _depthMap		: ITextureResource			= null;
		private var _blurMap		: ITextureResource			= null;
		
		private var _postProcessing	: PostProcessingShaderPart	= null;
		
		public function DepthOfFieldShader(depthMap		: ITextureResource,
										   blurMap		: ITextureResource,
										   renderTarget	: RenderTarget		= null,
										   priority		: Number			= 0.0)
		{
			super(renderTarget, priority);
			
			_depthMap = depthMap;
			_blurMap = blurMap;
			
			_postProcessing = new PostProcessingShaderPart(this);
		}
		
		override protected function getVertexPosition():SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat
		{
			var uv			: SFloat	= interpolate(vertexUV);
			var bluredColor : SFloat 	= sampleTexture(getTexture(_blurMap), uv);
			var color		: SFloat	= _postProcessing.backBufferPixel;
			var depthMap	: SFloat	= getTexture(_depthMap);
			var depth		: SFloat	= unpack(sampleTexture(depthMap, uv));
			
			return float4(mix(color.rgb, bluredColor.rgb, depth), color.a);
		}
	}
}