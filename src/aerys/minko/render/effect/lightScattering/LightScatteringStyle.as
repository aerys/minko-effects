package aerys.minko.render.effect.lightScattering
{
	import aerys.minko.render.effect.Style;

	public class LightScatteringStyle
	{
		public static const IS_LIGHT_SOURCE	: int 	= Style.getStyleId("godrays light source");
		public static const IS_SKY			: int 	= Style.getStyleId("godrays sky");
		public static const	LOW_QUALITY		: int	= 1;
		public static const	MEDIUM_QUALITY	: int	= 2;
		public static const	HIGH_QUALITY	: int	= 3;
		public static const	MANUAL_QUALITY	: int	= 0;
	}
}