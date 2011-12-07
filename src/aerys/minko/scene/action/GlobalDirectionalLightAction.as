package aerys.minko.scene.action
{
	import aerys.minko.render.renderer.IRenderer;
	import aerys.minko.scene.data.GlobalDirectionalLightData;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.light.GlobalDirectionalLight;
	import aerys.minko.scene.visitor.ISceneVisitor;
	
	public class GlobalDirectionalLightAction implements IAction
	{		
		public function get type() : uint
		{
			return ActionType.UPDATE_WORLD_DATA;
		}
		
		public function run(scene:IScene, visitor:ISceneVisitor, renderer:IRenderer):Boolean
		{
			var light	: GlobalDirectionalLight		= GlobalDirectionalLight(scene);
			var data 	: GlobalDirectionalLightData	= light.getGlobalDirectionnalLightData(visitor.transformData);
			
			visitor.worldData[GlobalDirectionalLightData] = data;
			
			return true;
		}
	}
}