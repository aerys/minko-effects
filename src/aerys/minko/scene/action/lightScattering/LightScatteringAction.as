package aerys.minko.scene.action.lightScattering
{
	import aerys.minko.render.renderer.IRenderer;
	import aerys.minko.render.shader.node.operation.builtin.Multiply4x4;
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	import aerys.minko.scene.data.WorldDataList;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.group.Group;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.scene.node.lightScattering.LightScattering;
	import aerys.minko.scene.visitor.ISceneVisitor;
	import aerys.minko.type.math.Vector4;
	
	import flashx.textLayout.tlf_internal;
	import aerys.minko.scene.action.ActionType;
	import aerys.minko.scene.action.IAction;

	public class LightScatteringAction implements IAction
	{
		public function get type() : uint
		{
			return ActionType.UPDATE_WORLD_DATA;
		}
		
		public function run(scene : IScene, visitor : ISceneVisitor, renderer : IRenderer) : Boolean
		{
			var light	: LightScattering		= LightScattering(scene);
			var data 	: LightScatteringData	= light.getLightScatteringData(visitor.transformData);

			visitor.worldData[LightScatteringData] = data;

			return true;
		}
	}
}