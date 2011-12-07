package aerys.minko.scene.node.light
{
	import aerys.minko.scene.action.GlobalDirectionalLightAction;
	import aerys.minko.scene.data.GlobalDirectionalLightData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.node.AbstractScene;
	import aerys.minko.type.Factory;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	public class GlobalDirectionalLight extends AbstractScene
	{
		protected static const GLOBAL_DIRLIGHT_DATA	: Factory	= Factory.getFactory(GlobalDirectionalLightData);
		
		private var _direction	: Vector4;		
		
		public function get direction()		: Vector4	{ return _direction; }
		
		public function GlobalDirectionalLight(direction : Vector4 	= null)
		{
			_direction = direction || new Vector4(0., 0., -1.);
			super();
			actions.push(new GlobalDirectionalLightAction());
		}
		
		public function getGlobalDirectionnalLightData(transformData	: TransformData) : GlobalDirectionalLightData
		{
			var gdld	: GlobalDirectionalLightData 	= GLOBAL_DIRLIGHT_DATA.create(true) as GlobalDirectionalLightData;
			
			// compute world space direction
			var worldMatrix		: Matrix4x4	= transformData.world;
			var worldDirection	: Vector4	= worldMatrix.deltaTransformVector(_direction).normalize();
			
			gdld.reset();
			gdld.direction		= worldDirection;
			
			return gdld;
		}
	}
}