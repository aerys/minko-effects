package aerys.minko.render.effect.greyBox
{
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.SinglePassEffect;

	public class GreyBoxEffect extends SinglePassEffect implements IRenderingEffect
	{
		private static const SHADER	: GreyBoxShader	= new GreyBoxShader();
		
		public function GreyBoxEffect()
		{
			super(SHADER);
		}
	}
}