package aerys.minko.scene.node.lightScattering
{
	import aerys.minko.scene.data.lightScattering.LightScatteringProvider;
	import aerys.minko.scene.node.AbstractSceneNode;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.Factory;

	public class LightScatteringSource extends AbstractSceneNode
	{
		private var _data	: LightScatteringProvider	= new LightScatteringProvider();
		
		public function LightScatteringSource(color		: int		= 0xffffff,
											  decay		: Number	= 1.,
											  exposure	: Number 	= .0034,
											  weight	: Number	= 2.,
											  density	: Number	= 1.)
		{
			super();
			
			_data.color = color;
			_data.decay = decay;
			_data.exposure = exposure;
			_data.weight = weight;
			_data.density = density;
			
			added.add(addedHandler);
			removed.add(removedHandler);
		}
		
		private function addedHandler(child : ISceneNode, ancestor : Group) : void
		{
			var scene : Scene = child.scene;
			
			if (scene)
				scene.bindings.addProvider(_data);
		}
		
		private function removedHandler(child : ISceneNode, ancestor : Group) : void
		{
			var scene : Scene = ancestor.scene;
			
			if (scene)
				scene.bindings.removeProvider(_data);
		}
	}
}