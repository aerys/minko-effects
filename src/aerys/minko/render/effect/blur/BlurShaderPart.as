package aerys.minko.render.effect.blur
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.ShaderPart;
	
	public class BlurShaderPart extends ShaderPart
	{
		private static const OFFSETS	: Vector.<Number>	= new <Number>[0.0, 1.3846153846, 3.2307692308];
		private static const WEIGHTS	: Vector.<Number>	= new <Number>[0.2270270270, 0.3162162162, 0.0702702703];
		
		/**
		 * Efficient Gaussian blur with linear sampling using a 3x3 kernel.
		 * http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
		 *  
		 * @param main
		 * 
		 */
		public function BlurShaderPart(main : Shader)
		{
			super(main);
		}
		
		public function linearGaussianBlurX(texture		: SFloat,
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
					sampleTexture(texture, divide(add(fragmentCoord, float2(OFFSETS[i], 0)), outputSize))
				));
				
				color.incrementBy(multiply(
					WEIGHTS[i],
					sampleTexture(texture, divide(subtract(fragmentCoord, float2(OFFSETS[i], 0)), outputSize))
				));
			}
			
			return color;
		}
		
		public function linearGaussianBlurY(texture		: SFloat,
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