package aerys.minko.scene.data.lightScattering
{
	import aerys.minko.type.data.DataProvider;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;

	public final class LightScatteringData extends DataProvider
	{
		private static const DATA_DESCRIPTOR	: Object	=
		{
			scatteringSourcePosition	: "position",
			scatteringSourceColor		: "color",
			scatteringSourceDecay		: "decay",
			scatteringSourceExposure	: "exposure",
			scatteringSourceWeight		: "weight",
			scatteringSourceDensity		: "density"
		}
		
		protected var _position	: Vector4	= new Vector4(0., 0., 0., 1.);
		protected var _color	: int		= 0;
		protected var _decay	: Number	= 0.;
		protected var _exposure	: Number	= 0.;
		protected var _weight	: Number	= 0.;
		protected var _density	: Number	= 0.;
		
		public function get position() : Vector4
		{
			return _position;
		}

		public function get color() : int
		{
			return _color;
		}
		public function set color(value : int) : void
		{
			_color = value;
			changed.execute(this, "color");
		}
		
		public function get decay() : Number
		{
			return _decay;
		}
		public function set decay(value : Number) : void
		{
			_decay = value;
			changed.execute(this, "decay");
		}
		
		public function get exposure() : Number
		{
			return _exposure;
		}
		public function set exposure(value : Number) : void
		{
			_exposure = value;
			changed.execute(this, "exposure");
		}
		
		public function get weight() : Number
		{
			return _weight;
		}
		public function set weight(value : Number) : void
		{
			_weight = value;
			changed.execute(this, "weight");
		}
		
		public function get density() : Number
		{
			return _density;
		}
		public function set density(value : Number) : void
		{
			_density = value;
			changed.execute(this, "density");
		}
		
		public function LightScatteringData()
		{
			super();
			
			reset();
		}
		
		public function reset() : void
		{
			position.set(0., 0., 0., 1.);
			color = 0xffffff;
			decay = 1.;
		    exposure = .0034;
			weight = 2.;
			density = 1.;
		}
	}
}
