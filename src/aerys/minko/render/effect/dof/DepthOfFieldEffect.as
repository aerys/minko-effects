package aerys.minko.render.effect.dof
{
	import aerys.minko.render.DataBindingsProxy;
	import aerys.minko.render.Effect;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.blur.BlurEffect;
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
		private var _numBlurPasses	: uint;
		private var _targetSize		: uint;
		private var _depthMap		: RenderTarget;
		private var _depthPass		: Shader;
		
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
			_numBlurPasses = numBlurPasses;
			
			_depthMap = new RenderTarget(
				_targetSize,
				_targetSize,
				new TextureResource(_targetSize, _targetSize),
				0,
				0xffffffff
			);
			
			_depthPass = new DepthShader(_depthMap, 100);
			
//			setPasses(initializePasses(numBlurPasses));
		}
		
		override protected function initializePasses(meshBindings	: DataBindingsProxy,
													 sceneBindings	: DataBindingsProxy) : Vector.<Shader>
		{
			var pesshes 		: Vector.<Shader> 		= super.initializePasses(
				meshBindings, sceneBindings
			);
			var bluredTarget	: RenderTarget		= new RenderTarget(
				_targetSize, _targetSize, new TextureResource(_targetSize, _targetSize)
			);
			var passes 			: Vector.<Shader>	= BlurEffect.getBlurPasses(
				_targetSize, _numBlurPasses, 1, null, bluredTarget, 2
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