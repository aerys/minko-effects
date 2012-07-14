package aerys.minko.render.effect.hdr
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.Shader;
	
	public class HDREffect extends Effect
	{
		public function HDREffect()
		{
			super();
			
			initialize();
		}
		
		private function initialize() : void
		{
			var passes 					: Vector.<Shader>	= new <Shader>[];
			var originalBrightedTarget	: RenderTarget		= new RenderTarget(
				256, 256, new TextureResource(256, 256)
			);
			var halfBrightedTarget		: RenderTarget		= new RenderTarget(
				128, 128, new TextureResource(128, 128)
			);
			var quarterBrightedTarget	: RenderTarget		= new RenderTarget(
				64, 64, new TextureResource(64, 64)
			);
			
			passes.push(
				new BrightShader(null, originalBrightedTarget, 4),
				new CloneShader(originalBrightedTarget.textureResource, halfBrightedTarget, 3),
				new CloneShader(halfBrightedTarget.textureResource, quarterBrightedTarget, 2),
				new HDRShader(
					originalBrightedTarget.textureResource,
					halfBrightedTarget.textureResource,
					quarterBrightedTarget.textureResource
				)
			);
			
			setPasses(passes);
		}
	}
}