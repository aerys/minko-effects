package aerys.minko.render.effect.normalMapping
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.shader.ActionScriptShader;
	
	public class NormalMappingEffect extends SinglePassEffect implements IRenderingEffect
	{
		private static const SHADER	: ActionScriptShader	= new NormalMappingShader();
		
		public function NormalMappingEffect(priority 		: Number 		= 0,
											renderTarget	: RenderTarget	= null)
		{
			super(SHADER, priority, renderTarget);
		}
	}
}