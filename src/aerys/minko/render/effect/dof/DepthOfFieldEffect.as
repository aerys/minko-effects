package aerys.minko.render.effect.dof
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.blur.BlurEffect;
	import aerys.minko.render.effect.blur.BlurShader;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.Shader;
	
	/**
	 * The DeptOfFieldEffect is a post-processing effect using a set of gaussian blur
	 * passes to blur the rendering according to the depth of each pixel.
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public class DepthOfFieldEffect extends Effect
	{
		private var _targetSize	: uint			= 256;
		private var _depthMap	: RenderTarget	= null;
		private var _depthPass	: Shader		= null;
		
		public function get depthPass() : Shader
		{
			return _depthPass;
		}
		
		public function get depthMap() : ITextureResource
		{
			return _depthMap.textureResource;
		}
		
		public function DepthOfFieldEffect(blurQuality : uint, numBlurPasses : uint = 1)
		{
			super();
			
			initialize(blurQuality, numBlurPasses);
		}
		
		private function initialize(blurQuality : uint, numBlurPasses : uint) : void
		{
			_targetSize = blurQuality;
			
			_depthMap = new RenderTarget(
				_targetSize,
				_targetSize,
				new TextureResource(_targetSize, _targetSize),
				0,
				0xffffffff
			);
			
			_depthPass = new DepthShader(_depthMap, 1);
			
			setPasses(initializePasses(numBlurPasses));
		}
		
		private function initializePasses(numBlurPasses : uint) : Vector.<Shader>
		{
			var bluredTarget	: RenderTarget		= new RenderTarget(
				_targetSize, _targetSize, new TextureResource(_targetSize, _targetSize)
			);
			var passes 			: Vector.<Shader>	= BlurEffect.getBlurPasses(
				_targetSize, numBlurPasses, null, bluredTarget, 2
			);
			
			passes.push(new DepthOfFieldShader(
				_depthMap.textureResource,
				bluredTarget.textureResource,
				null,
				0
			));
			
			return passes;
		}
	}
}