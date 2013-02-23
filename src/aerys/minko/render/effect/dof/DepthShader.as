package aerys.minko.render.effect.dof
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.Blending;
	
	public final class DepthShader extends BasicShader
	{
		private static const EPSILON	: Number	= 0.001;
		
		private var _depth	: SFloat	= null;
		
		public function DepthShader(target 		: RenderTarget 	= null,
									priority 	: Number 		= 0.0)
		{
			super(target, priority);
		}
		
		override protected function initializeSettings(settings:ShaderSettings):void
		{
			super.initializeSettings(settings);
			
			settings.blending = Blending.OPAQUE;
		}
		
		override protected function getVertexPosition():SFloat
		{
			var position : SFloat = localToView(vertexXYZ);
			
			_depth = subtract(
				divide(position.z, subtract(cameraZFar, cameraZNear)),
				EPSILON
			);
			
			return super.getVertexPosition();
		}
		
		override protected function getPixelColor():SFloat
		{
			var depth : SFloat = interpolate(_depth);
			
			return pack(depth);
		}
	}
}