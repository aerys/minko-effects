package aerys.minko.render.effect.glow
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	
	public class GlowEffect extends Effect
	{
		public function GlowEffect(blur		: Number	= 0.165,
								   red		: Number	= 1.,
								   green	: Number	= 1.,
								   blue		: Number	= 1.,
								   alpha	: Number	= 1.)
		{
			super(
				new GlowShader(blur, red, green, blue, alpha),
				new BasicShader()
			);
		}
	}
}