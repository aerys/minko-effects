package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.material.basic.BasicMaterial;
	
	public class WireframeMaterial extends BasicMaterial
	{
		private static const DEFAULT_EFFECT	: Effect	= new Effect(new WireframeShader());
		
		public function get wireframeColor() : uint
		{
			return getProperty(WireframeProperties.COLOR);
		}
		public function set wireframeColor(value : uint) : void
		{
			setProperty(WireframeProperties.COLOR, value);
		}
		
		public function get wireframeThickness() : Number
		{
			return getProperty(WireframeProperties.THICKNESS);
		}
		public function set wireframeThickness(value : Number) : void
		{
			setProperty(WireframeProperties.THICKNESS, value);
		}
		
		public function WireframeMaterial(properties	: Object	= null,
										  effect 		: Effect 	= null,
										  name 			: String	= 'WireframeMaterial')
		{
			super(properties, effect || DEFAULT_EFFECT, name);
		}
	}
}