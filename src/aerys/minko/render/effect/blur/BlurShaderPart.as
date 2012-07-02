package aerys.minko.render.effect.blur
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.ShaderPart;
	
	public class BlurShaderPart extends ShaderPart
	{
		private static const OFFSETS	: Vector.<Number>	= new <Number>[0.0, 1.3846153846, 3.2307692308];
		private static const WEIGHTS	: Vector.<Number>	= new <Number>[0.2270270270, 0.3162162162, 0.0702702703];
		
		public function BlurShaderPart(main : Shader)
		{
			super(main);
		}
		
		public function gaussianBlur(texture	: SFloat,
									 outputSize	: SFloat) : SFloat
		{
			var fragmentCoord : SFloat = multiply(
				interpolate(vertexUV.xy),
				outputSize
			);
			
			var color : SFloat = multiply(
				sampleTexture(texture, divide(fragmentCoord, outputSize)),
				WEIGHTS[0]
			);
			
			for (var i : uint = 1; i < 3; ++i)
			{
				color.incrementBy(multiply(
					WEIGHTS[i],
					sampleTexture(texture, divide(add(fragmentCoord, float2(0, OFFSETS[i])), outputSize))
				));
				
				color.incrementBy(multiply(
					WEIGHTS[i],
					sampleTexture(texture, divide(subtract(fragmentCoord, float2(0, OFFSETS[i])), outputSize))
				));
			}
			
			return color;
		}
	}
}