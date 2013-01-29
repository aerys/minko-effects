package aerys.minko.render.effect.glow
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.material.basic.BasicShader;
	
	public class GlowEffect extends Effect
	{
		public function GlowEffect(blur				: Number	= 0.65,
								   color			: uint		= 0xffffffff)
		{
			super(
				new GlowShader(null, -Number.MAX_VALUE, blur, color),
				new BasicShader()
			);
		}
	}
}