package aerys.minko.render.effect.chromakey
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	import aerys.minko.type.enum.Blending;
	
	public class ChromaKeyShader extends Shader
	{
		private var _postProcessing	: PostProcessingShaderPart	= null;
		private var _chromaKey		: ChromaKeyShaderPart		= null;
		
		public function ChromaKeyShader(renderTarget	: RenderTarget	= null,
										priority		: Number		= 0.0)
		{
			super(renderTarget, priority);
			
			_postProcessing = new PostProcessingShaderPart(this);
			_chromaKey = new ChromaKeyShaderPart(this);
		}
		
		override protected function initializeSettings(settings:ShaderSettings):void
		{
			super.initializeSettings(settings);
			
			settings.blending = Blending.ALPHA;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat
		{
			return _chromaKey.chromaKey(
				_postProcessing.backBufferPixel,
				sceneBindings.getParameter('chromaKeyColor', 		3),
				sceneBindings.getParameter('chromaKeyTolerance', 	1),
				sceneBindings.getParameter('chromaKeyRamp', 		1),
				sceneBindings.getParameter('chromaKeyGamma', 		1)
			);
		}
	}
}