package aerys.minko.render.effect.blur
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.Effect;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.Shader;

	/**
	 * The BlurEffect is a multi-pass linear gaussian blur post-processing effect.
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public class BlurEffect extends Effect
	{
		/**
		 * 
		 * @param quality
		 * @param numPasses
		 * 
		 */
		public function BlurEffect(quality : uint, numPasses : uint = 1)
		{
			super();
			
			setPasses(getBlurPasses(quality, numPasses));
		}
		
		public static function getBlurPasses(quality 		: uint,
											 numPasses 		: uint,
											 blurSource		: ITextureResource	= null,
											 blurTarget		: RenderTarget		= null,
											 priorityOffset	: Number			= 0.,
											 passes			: Vector.<Shader>	= null) : Vector.<Shader>
		{
			passes = passes != null ? passes : new <Shader>[];
			
			var target1	: RenderTarget		= new RenderTarget(
				quality, quality, new TextureResource(quality, quality)
			);
			var target2	: RenderTarget		= new RenderTarget(
				quality, quality, new TextureResource(quality, quality)
			);
			
			for (var i : uint = 0; i < numPasses; ++i)
			{
				var passTarget : RenderTarget 		= i % 2 == 0 ? target1 : target2;
				var passSource : ITextureResource 	= i % 2 == 0 ? target2.textureResource : target1.textureResource;
				
				passes.push(new BlurShader(
					i % 2 == 0 ? BlurShader.DIRECTION_HORIZONTAL : BlurShader.DIRECTION_VERTICAL,
					i == 0 ? blurSource : passSource,
					i == numPasses - 1 ? blurTarget : passTarget,
					priorityOffset - (i / numPasses)
				));
			}
			
			return passes;
		}
	}
}