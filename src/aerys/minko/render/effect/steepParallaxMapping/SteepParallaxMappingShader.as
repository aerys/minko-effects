package aerys.minko.render.effect.steepParallaxMapping
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.DiffuseShaderPart;
	import aerys.minko.render.shader.part.animation.VertexAnimationShaderPart;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	import aerys.minko.type.stream.format.VertexComponent;

	public class SteepParallaxMappingShader extends Shader
	{
		private static const NSTEPS		 		: uint		= 20;
		private static const BUMPSCALE_DEFAULT	: Number	= .03;
		
		private var _vertexAnimationPart	: VertexAnimationShaderPart;
		private var _diffuseShaderPart		: DiffuseShaderPart;

		private var _lightDir				: SFloat = null;
		private var _cameraPosition			: SFloat = null;
		
		public function SteepParallaxMappingShader()
		{
			super();
			
			_vertexAnimationPart = new VertexAnimationShaderPart(this);
			_diffuseShaderPart	 = new DiffuseShaderPart(this);
		}
		
		override protected function getVertexPosition() : SFloat
		{
			var vertexBitangent	: SFloat = crossProduct(vertexNormal, vertexTangent);
			var lightDir		: SFloat = sceneBindings.getParameter('globalDirectionalLightDirection', 4);
			
			lightDir = normalize(deltaWorldToLocal(lightDir));
			
			_lightDir = float3(
				dotProduct3(lightDir, vertexTangent),
				dotProduct3(lightDir, vertexBitangent),
				dotProduct3(lightDir, vertexNormal)
			);
			
			return localToScreen(_vertexAnimationPart.getAnimatedVertexPosition());
		}
		
		override protected function getPixelColor() : SFloat
		{
			// Retrieve textures & constants
			var wrapping			: uint	 = meshBindings.getConstant('steepParallaxMappingWrapping', SamplerWrapping.REPEAT);
			
			var bumpTexture			: SFloat = meshBindings.getTextureParameter('steepParallaxMappingBumpMap', 
																				SamplerFiltering.LINEAR,
																				SamplerMipMapping.LINEAR,
																				wrapping);
			
			var normalTexture		: SFloat = meshBindings.getTextureParameter('steepParallaxMappingNormalMap',
																				SamplerFiltering.LINEAR,
																				SamplerMipMapping.LINEAR,
																				wrapping);
			
			var bumpScale			: SFloat = meshBindings.propertyExists('steepParallaxMappingBumpScale') ?
											   meshBindings.getParameter('steepParallaxMappingBumpScale', 1) :
											   float(BUMPSCALE_DEFAULT);
											  
			var specular			: SFloat = sceneBindings.getParameter('steepParallaxMappingLightSpecular', 1);
			var shininess			: SFloat = sceneBindings.getParameter('steepParallaxMappingLightShininess', 1);

			// Compute lighting
			var vertexPosition		: SFloat = getVertexAttribute(VertexComponent.XYZ);
			var cameraLocalPosition : SFloat = worldToLocal(cameraPosition);
			
			var tangentSpaceEye		: SFloat = normalize(subtract(cameraLocalPosition, interpolate(vertexPosition)));
			 tangentSpaceEye = float3(
				dotProduct3(tangentSpaceEye, interpolate(vertexTangent)),
				dotProduct3(tangentSpaceEye, crossProduct(interpolate(vertexNormal), interpolate(vertexTangent))),
				dotProduct3(tangentSpaceEye, interpolate(vertexNormal))
			);
			
			var uv					: SFloat = float(0.);
			var delta				: SFloat = multiply(tangentSpaceEye.xy, divide(bumpScale, multiply(tangentSpaceEye.z, NSTEPS)));
			var tmpUV				: SFloat = interpolate(vertexUV);
			var height				: Number = 1.;
			var resultNotFound		: SFloat = float(1.);
			
			for (var i : int = 0; i < NSTEPS; i++) 
			{				
				if (i == NSTEPS - 1)
					height = 0;
				
				var bump		: SFloat = sampleTexture(bumpTexture, tmpUV);							
				var resultUV	: SFloat = multiply(tmpUV, greaterEqual(bump, height), resultNotFound);
				
				resultNotFound = multiply(resultNotFound, lessThan(bump, height));
				
				uv.incrementBy(resultUV);
				tmpUV.decrementBy(delta);
				height -= 1. / NSTEPS;
			}
			
			var tangentSpaceLight	: SFloat = normalize(interpolate(_lightDir));
			var normal				: SFloat = sampleTexture(normalTexture, uv);
			
			normal = normalize(subtract(multiply(normal, 2.), 1.));
			
			var ref					: SFloat = reflect(negate(tangentSpaceLight), normal);
			var lambert				: SFloat = saturate(dotProduct3(tangentSpaceLight, normal));
			var spec				: SFloat = multiply(specular, lambert, power(dotProduct3(ref, normalize(tangentSpaceEye)), shininess));
			var illumination 		: SFloat = multiply(_diffuseShaderPart.getDiffuse(), lambert);
			
			return add(illumination, spec);
		}
	}
}
