package aerys.minko.scene.node.light
{
	import aerys.minko.scene.action.GlobalDirectionnalLightAction;
	import aerys.minko.scene.data.GlobalDirectionnalLightData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.node.AbstractScene;
	import aerys.minko.type.Factory;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	public class GlobalDirectionnalLight extends AbstractScene
	{
		protected static const GLOBAL_DIRLIGHT_DATA	: Factory	= Factory.getFactory(GlobalDirectionnalLightData);
		
		private var _direction	: Vector4;		
		
		public function get direction()		: Vector4	{ return _direction; }
		
		public function GlobalDirectionnalLight(direction : Vector4 	= null)
		{
			_direction = direction || new Vector4(0., 0., -1.);
			super();
			actions.push(new GlobalDirectionnalLightAction());
		}
		
		public function getGlobalDirectionnalLightData(transformData	: TransformData) : GlobalDirectionnalLightData
		{
			var gdld	: GlobalDirectionnalLightData 	= GLOBAL_DIRLIGHT_DATA.create(true) as GlobalDirectionnalLightData;
			
			// compute world space direction
			var worldMatrix		: Matrix4x4	= transformData.world;
			var worldDirection	: Vector4	= worldMatrix.deltaTransformVector(_direction).normalize();
			
			gdld.reset();
			gdld.direction		= worldDirection;
			
			return gdld;
		}
	}
}