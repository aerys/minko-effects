package aerys.minko.render.effect.lightScattering
{
	public class LightScatteringProperties
	{
		public static const SOURCE_POSITION	: String	= "scatteringSourcePosition";
		public static const SOURCE_COLOR	: String	= "scatteringSourceColor";
		public static const SOURCE_DECAY	: String	= "scatteringSourceDecay";
		public static const SOURCE_EXPOSURE	: String	= "scatteringSourceExposure";
		public static const SOURCE_WEIGHT	: String	= "scatteringSourceWeight";
		public static const SOURCE_DENSITY	: String	= "scatteringSourceDensity";
		
		public static const IS_LIGHT_SOURCE	: String	= "scatteringIsLightSource";
		public static const IS_SKY			: String	= "scatteringIsSky";
		public static const IS_TRANSPARENT	: String	= "scatteringIsTransparent";
		
		public static const OCCLUSION_MAP	: String	= "scatteringOcclusionMap";
		
		public static const	LOW_QUALITY		: int		= 1;
		public static const	MEDIUM_QUALITY	: int		= 2;
		public static const	HIGH_QUALITY	: int		= 3;
		public static const	MANUAL_QUALITY	: int		= 0;
	}
}