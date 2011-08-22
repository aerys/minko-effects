package aerys.minko.render.effect.normalMapping
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.shader.ActionScriptShaderPart;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.scene.data.LocalData;
	import aerys.minko.scene.data.StyleStack;
	
	import flash.utils.Dictionary;
	
	public final class NormalMappingShaderPart extends ActionScriptShaderPart
	{
		private function getTangentSpaceLightVector(lightDirection : Object) : SValue
		{
			var vertexBitangent	: SValue	= cross(vertexNormal, vertexTangent);
			
			return float3(
				dotProduct3(lightDirection, vertexTangent),
				dotProduct3(lightDirection, vertexBitangent),
				dotProduct3(lightDirection, vertexNormal)
			);
		}
		
		private function getHalfVector(lightDirection : Object) : SValue
		{
			var vertexPos 		: SValue 	= normalize(vertexPosition);
			var halfVector		: SValue 	= normalize(add(vertexPos, lightDirection));
			var vertexBitangent	: SValue	= cross(vertexNormal, vertexTangent);

			return float3(
				dotProduct3(halfVector, vertexTangent),
				dotProduct3(halfVector, vertexBitangent),
				dotProduct3(halfVector, vertexNormal)
			);
		}
		
		public function getIllumination(direction 	: Object,
										color		: Object,
										specular	: Object,
										shininess	: Object) : SValue
		{
			var lightVec	: SValue	= interpolate(getTangentSpaceLightVector(direction));
			
			var uv			: SValue	= interpolate(vertexUV);
			var normal		: SValue 	= sampleTexture(NormalMappingStyle.NORMAL_MAP, uv);
			
			normal = subtract(normal.multiply(2.), 1.);
			normal.normalize();
			
			var lamberFactor	: SValue	= saturate(lightVec.dotProduct3(normal));
			var illumination	: SValue	= multiply(color, lamberFactor);
			
			var ref				: SValue	= getReflectedVector(lightVec, normal);
			var halfVector		: SValue	= interpolate(getHalfVector(direction));
			
			shininess = power(max(dotProduct3(ref, halfVector), 0.0), shininess);
			
			illumination.increment(shininess.multiply(specular));
			
			return illumination;
		}
	}
}