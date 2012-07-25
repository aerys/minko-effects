package aerys.minko.render.effect.hdr
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.Effect;
	import aerys.minko.render.effect.blur.BlurEffect;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.Shader;
	
	public class HDREffect extends Effect
	{
		private static const MIN_QUALITY	: uint	= 128;
		
		public function HDREffect(quality 					: uint 	= 512,
								  numBlurPassesPerSample	: uint	= 2)
		{
			super();
			
			initialize(quality, numBlurPassesPerSample);
		}
		
		private function initialize(quality : uint, numBlurPassesPerSample : uint) : void
		{
			var passes 		: Vector.<Shader>			= new <Shader>[];
			var ressources 	: Vector.<ITextureResource> = new <ITextureResource>[];
			var target		: RenderTarget				= new RenderTarget(
				quality, quality, new TextureResource(quality, quality)
			);
			var priority	: uint						= 10;
			
			passes.push(new BrightShader(null, target, priority));
			
			while (quality >= MIN_QUALITY)
			{
				var source 	: ITextureResource 	= target.textureResource;
				
				target = new RenderTarget(
					quality, quality, new TextureResource(quality, quality)
				);
				ressources.push(target.textureResource);
				
				BlurEffect.getBlurPasses(
					quality, numBlurPassesPerSample, source, target, --priority, passes
				);
				quality >>= 1;
			}
			
			passes.push(new HDRShader(ressources));
			
			setPasses(passes);
		}
	}
}