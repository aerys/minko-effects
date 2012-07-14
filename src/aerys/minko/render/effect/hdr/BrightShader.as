package aerys.minko.render.effect.hdr
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	
	public class BrightShader extends CloneShader
	{
		public function BrightShader(source			: ITextureResource	= null,
									 renderTarget	: RenderTarget		= null,
									 priority		: Number			= 0.0)
		{
			super(source, renderTarget, priority); 
		}
		
		override protected function getPixelColor() : SFloat
		{
			var rgb				: SFloat	= super.getPixelColor();
			var rgbToLuminance 	: SFloat 	= float3(0.2126, 0.7152, 0.0722);
			var luminance		: SFloat	= dotProduct3(rgb, rgbToLuminance);
			
			luminance.scaleBy(sceneBindings.getParameter('hdrLuminance', 1));
			
			rgb.scaleBy(float4(luminance.xxx, 1));
			
			return rgb;
		}
	}
}