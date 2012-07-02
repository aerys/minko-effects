package aerys.minko.render.effect.dof
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.blur.BlurShader;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.type.enum.SamplerFiltering;
	
	public class DepthOfFieldShader extends BlurShader
	{
		public function DepthOfFieldShader(renderTarget	: RenderTarget		= null,
										   priority		: Number			= 0.0,
										   blurSource	: ITextureResource	= null)
		{
			super(renderTarget, priority, blurSource);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var uv			: SFloat	= interpolate(vertexUV);
			var bluredColor : SFloat 	= super.getPixelColor();
			var color		: SFloat	= sampleTexture(blurSourceTexture, uv)
			var depthMap	: SFloat	= sceneBindings.getTextureParameter(
				'depthMap',
				SamplerFiltering.NEAREST
			);
			var depth		: SFloat	= unpack(sampleTexture(depthMap, uv));
			
			return float4(mix(color.rgb, bluredColor.rgb, depth), color.a);
		}
	}
}