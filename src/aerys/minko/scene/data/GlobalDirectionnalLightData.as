package aerys.minko.scene.data
{
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	public class GlobalDirectionnalLightData implements IWorldData
	{
		public static const DIRECTION	: String 	= "direction";
		
		private var _direction	: Vector4	= new Vector4(0., 0., -1.);	
		
		public function get direction() : Vector4 { return _direction;	}
		
		public function set direction(value : Vector4) : void { _direction = value; }
		
		public function GlobalDirectionnalLightData()
		{
		}
		
		public function setDataProvider(styleData		: StyleData, 
										transformData	: TransformData,
										worldData		: Dictionary) : void
		{
		}
		
		public function invalidate():void
		{
		}
		
		public function reset():void
		{
			_direction.set(0., 0., -1.);	
		}
	}
}