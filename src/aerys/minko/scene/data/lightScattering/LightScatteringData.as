package aerys.minko.scene.data.lightScattering
{
	import aerys.minko.scene.data.IWorldData;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	public final class LightScatteringData implements IWorldData
	{
		public static const POSITION	: String 	= "position";
		public static const COLOR		: String 	= "color";
		public static const DECAY		: String 	= "decay";
		public static const EXPOSURE	: String 	= "exposure";
		public static const WEIGHT		: String 	= "weight";
		public static const DENSITY		: String 	= "density";
		
		protected var _position			: Vector4	= new Vector4(0., 0., 0., 1.);
		protected var _color			: int		= 0;
		protected var _decay			: Number	= 0.;
		protected var _exposure			: Number	= 0.;
		protected var _weight			: Number	= 0.;
		protected var _density			: Number	= 0.;
		
		public function get position() : Vector4
		{
			return _position;
		}
		
		public function get color() : int
		{
			return _color;
		}
		
		public function get decay() : Number
		{
			return _decay;
		}
		
		public function get exposure() : Number
		{
			return _exposure;
		}

		public function get weight() : Number
		{
			return _weight;
		}

		public function get density() : Number
		{
			return _density;
		}

		public function set position(value : Vector4) : void
		{
			_position = value;
		}
		
		public function set color(value : int) : void
		{
			_color = value;
		}
		
		public function set decay(value : Number) : void
		{
			_decay = value;
		}
		
		public function set exposure(value : Number) : void
		{
			_exposure = value;
		}
		
		public function set weight(value : Number) : void
		{
			_weight = value;
		}
		
		public function set density(value : Number) : void
		{
			_density = value;
		}
		
		public function setDataProvider(styleStack		: StyleData, 
								 		transformData	: TransformData,
										worldData		: Dictionary) : void
		{
		}
			
		public function invalidate() : void
		{
		}
		
		public function reset() : void
		{
			_position.set(0., 0., 0., 1.);
			_color = 0xffffff;
			_decay = 1.;
		    _exposure = .0034;
			_weight = 2.;
			_density = 1.;
		}
	}
}