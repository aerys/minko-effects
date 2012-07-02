package aerys.minko.render.effect.chromakey
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.ShaderPart;
	
	public class ChromaKeyShaderPart extends ShaderPart
	{
		public function ChromaKeyShaderPart(main : Shader)
		{
			super(main);
		}
		
		public function chromaKey(color		: SFloat,
								  keyColor	: SFloat,
								  tolerance	: SFloat,
								  ramp		: SFloat,
								  gamma		: SFloat) : SFloat
		{
			var diff 	: SFloat 	= length(subtract(color.rgb, keyColor));
			var alpha	: SFloat	= add(
				greaterEqual(diff, tolerance),
				multiply(
					lessThan(diff, add(tolerance, ramp)),
					power(divide(subtract(diff, tolerance), ramp), gamma)
				)
			);
			
			return float4(color.rgb, alpha);
		}
	}
}