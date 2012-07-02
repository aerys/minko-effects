package aerys.minko.render.effect.blur
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.Shader;
	
	public class BlurEffect extends Effect
	{
		public function BlurEffect(numPasses : uint = 1)
		{
			super();
			
			setPasses(initializePasses(numPasses));
		}
		
		private function initializePasses(numPasses : uint) : Vector.<Shader>
		{
			var passes 	: Vector.<Shader>	= new <Shader>[];
			var target1	: RenderTarget		= new RenderTarget(1024, 1024, new TextureResource(1024, 1024));
			var target2	: RenderTarget		= new RenderTarget(1024, 1024, new TextureResource(1024, 1024));
			
			for (var i : uint = 0; i < numPasses; ++i)
			{
				var target : RenderTarget 		= i % 2 == 0 ? target1 : target2;
				var source : ITextureResource 	= i % 2 == 0 ? target2.textureResource : target1.textureResource;
				
				passes.push(new BlurShader(
					i == numPasses - 1 ? null : target,
					numPasses,
					i == 0 ? null : source
				));
			}
			
			return passes;
		}
	}
}