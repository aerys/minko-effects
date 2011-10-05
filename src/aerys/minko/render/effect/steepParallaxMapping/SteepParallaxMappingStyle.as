package aerys.minko.render.effect.steepParallaxMapping
{
	import aerys.minko.render.effect.Style;
	
	public final class SteepParallaxMappingStyle
	{
		public static const NORMAL_MAP			: int	= Style.getStyleId("spm normal map");
		public static const BUMP_MAP			: int	= Style.getStyleId("spm bump map");
		public static const BUMP_SCALE			: int	= Style.getStyleId("spm bump scale");
		public static const LIGHT_SHININESS		: int	= Style.getStyleId("spm light shininess");
		public static const LIGHT_SPECULAR		: int	= Style.getStyleId("spm light specular");
		public static const SAMPLER_WRAPPING	: int	= Style.getStyleId("spm texture sampler wrapping");
	}
}