package aerys.minko.render.effect.dof
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.blur.BlurShader;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.Shader;
	
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
		
		public function DepthOfFieldEffect(quality : uint, numPasses : uint = 1)
		{
			super();
			
			initialize(quality, numPasses);
		}
		
		private function initialize(quality : uint, numPasses : uint) : void
		{
			if (quality == DepthOfFieldQuality.LOW)
				_targetSize = 512;
			else if (quality == DepthOfFieldQuality.NORMAL)
				_targetSize = 1024;
			else if (quality == DepthOfFieldQuality.HIGH)
				_targetSize = 2048;
			
			_depthMap = new RenderTarget(
				_targetSize,
				_targetSize,
				new TextureResource(_targetSize, _targetSize),
				0,
				0xffffffff
			);
			
			_depthPass = new DepthShader(_depthMap, 1);
			
			setPasses(initializePasses(numPasses));
		}
		
		private function initializePasses(numPasses : uint) : Vector.<Shader>
		{
			var passes 	: Vector.<Shader>	= new <Shader>[];
			var target1	: RenderTarget		= new RenderTarget(
				_targetSize, _targetSize, new TextureResource(_targetSize, _targetSize)
			);
			var target2	: RenderTarget		= new RenderTarget(
				_targetSize, _targetSize, new TextureResource(_targetSize, _targetSize)
			);
			
			for (var i : uint = 0; i < numPasses; ++i)
			{
				var target : RenderTarget 		= i % 2 == 0 ? target1 : target2;
				var source : ITextureResource 	= i % 2 == 0 ? target2.textureResource : target1.textureResource;
				
				passes.push(new BlurShader(
					i % 2 ? BlurShader.DIRECTION_HORIZONTAL : BlurShader.DIRECTION_VERTICAL,
					target,
					numPasses - i,
					i == 0 ? null : source
				));
			}
			
			/*var target : RenderTarget = new RenderTarget(
				64, 64, new TextureResource(64, 64)
			);;
			
			passes.push(new TextureResampleShader(null, target, 1));*/
			
			passes.push(new DepthOfFieldShader(
				_depthMap.textureResource,
				target.textureResource,
				null,
				0
			));
			
			return passes;
		}
	}
}