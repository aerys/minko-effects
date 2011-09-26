package aerys.minko.render.effect.vertexNormal
{
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.SinglePassEffect;

	public class VertexNormalEffect extends SinglePassEffect implements IRenderingEffect
	{
		private static const VERTEX_NORMAL_SHADER	: VertexNormalShader	= new VertexNormalShader();
		
		public function VertexNormalEffect()
		{
			super(VERTEX_NORMAL_SHADER);
		}
	}
}