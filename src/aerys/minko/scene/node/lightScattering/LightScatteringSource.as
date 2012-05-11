package aerys.minko.scene.node.lightScattering
{
	import aerys.minko.scene.data.lightScattering.LightScatteringData;
	import aerys.minko.scene.node.AbstractSceneNode;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.Factory;

	public class LightScatteringSource extends AbstractSceneNode
	{
		private var _data	: LightScatteringData	= new LightScatteringData();
		
		public function LightScatteringSource(color		: int		= 0xffffff,
											  decay		: Number	= 1.,
											  exposure	: Number 	= .0034,
											  weight	: Number	= 2.,
											  density	: Number	= 1.)
		{
			_data.color = color;
			_data.decay = decay;
			_data.exposure = exposure;
			_data.weight = weight;
			_data.density = density;
		}
		
		override protected function addedToSceneHandler(child:ISceneNode, scene:Scene):void
		{
			super.addedToSceneHandler(child, scene);
			
			scene.bindings.add(_data);
		}
		
		override protected function removedFromSceneHandler(child:ISceneNode, scene:Scene):void
		{
			super.removedFromSceneHandler(child, scene);
			
			scene.bindings.remove(_data);
		}
	}
}