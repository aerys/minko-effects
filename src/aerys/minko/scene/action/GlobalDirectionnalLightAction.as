package aerys.minko.scene.action
{
	import aerys.minko.render.renderer.IRenderer;
	import aerys.minko.scene.data.GlobalDirectionnalLightData;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.light.GlobalDirectionnalLight;
	import aerys.minko.scene.visitor.ISceneVisitor;
	
	public class GlobalDirectionnalLightAction implements IAction
	{		
		public function get type() : uint
		{
			return ActionType.UPDATE_WORLD_DATA;
		}
		
		public function run(scene:IScene, visitor:ISceneVisitor, renderer:IRenderer):Boolean
		{
			var light	: GlobalDirectionnalLight		= GlobalDirectionnalLight(scene);
			var data 	: GlobalDirectionnalLightData	= light.getGlobalDirectionnalLightData(visitor.transformData);
			
			visitor.worldData[GlobalDirectionnalLightData] = data;
			
			return true;
		}
	}
}