package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.render.shader.part.DiffuseShaderPart;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;

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
		
		override protected function initializeSettings(settings : ShaderSettings) : void
		{
			super.initializeSettings(settings);
			
			settings.depthWriteEnabled = false;
			settings.triangleCulling = TriangleCulling.NONE;
			settings.blending = Blending.ADDITIVE;
		}
		
		override protected function getPixelColor() : SFloat
		{
			return _wireframe.applyWireframe(_diffuse.getDiffuseColor(false));
		}
	}
}