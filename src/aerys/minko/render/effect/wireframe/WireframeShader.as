package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.part.DiffuseShaderPart;

	public class WireframeShader extends BasicShader
	{
		private var _wireframe	: WireframeShaderPart		= null;
		private var _diffuse	: DiffuseShaderPart			= null;
		
		public function WireframeShader(renderTarget 	: RenderTarget 	= null,
										priority		: Number		= 0.)
		{
			super(renderTarget, priority);
			
			_wireframe = new WireframeShaderPart(this);
			_diffuse = new DiffuseShaderPart(this);
		}
		
		override protected function getPixelColor() : SFloat
		{
			return _wireframe.applyWireframe(_diffuse.getDiffuseColor(false));
		}
	}
}