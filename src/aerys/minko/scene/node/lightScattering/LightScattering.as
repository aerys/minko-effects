package aerys.minko.scene.node.lightScattering
{
	import aerys.minko.scene.action.lightScattering.LightScatteringAction;
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.node.AbstractScene;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.type.Factory;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Vector4;

	public class LightScattering extends AbstractScene
	{
		protected static const LIGHT_SCATTERING_DATA	: Factory	= Factory.getFactory(LightScatteringData);
		
		private var _decay								: Number	= 0.;
		private var _weight								: Number	= 0.;
		private var _exposure 							: Number	= 0.;
		private var _density							: Number	= 0.;
		private var _color								: int		= 0;

		public function get decay()		: Number	{ return _decay; }
		public function get weight()	: Number	{ return _weight; }
		public function get exposure()	: Number	{ return _exposure; }
		public function get density()	: Number	{ return _density; }
		public function get color() 	: int		{ return _color; }
		
		public function LightScattering(color		: int		= 0xffffff,
										decay		: Number	= 1.,
										exposure	: Number 	= .0034,
										weight		: Number	= 2.,
										density		: Number	= 1.)
		{
			_color = color;
			_decay = decay;
			_exposure = exposure;
			_weight = weight;
			_density = density;
			actions.push(new LightScatteringAction());
		}
		
		public function getLightScatteringData(transformData	: TransformData) : LightScatteringData
		{
			var lsd		: LightScatteringData 	= LIGHT_SCATTERING_DATA.create(true) as LightScatteringData;
			
			transformData.world.transformVector(ConstVector4.ZERO, lsd.position);
			lsd.color = _color;
			lsd.density = _density;
			lsd.exposure = _exposure;
			lsd.weight = _weight;
			lsd.decay = _decay;

			return lsd;
		}
	}
}