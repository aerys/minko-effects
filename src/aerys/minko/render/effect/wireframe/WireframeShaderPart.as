package aerys.minko.render.effect.wireframe
{
	import aerys.minko.render.shader.ActionScriptShaderPart;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.Components;
	import aerys.minko.render.shader.node.leaf.Attribute;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.stream.format.VertexComponent;
	import aerys.minko.type.stream.format.VertexComponentType;
	
	import flash.utils.Dictionary;

	public class WireframeShaderPart extends ActionScriptShaderPart
	{
		private const LINE_THICKNESS_COEFF	: Number	= 1000.;
		
		/**
		 * The weight of the current vertex for the wireframe effect. 
		 * @return 
		 * 
		 */
		public function getVertexWeight(wireThickness : Number) : SValue
		{
			var cameraDistance 	: SValue	= length(cameraPosition.subtract(vertexWorldPosition));
				
			var scale 			: SValue 	= length(multiply3x4(float3(1., 0., 0.), localToWorldMatrix));
			
			var w 				: SValue	= new SValue(new Attribute(VertexComponent.create(["w1", "w2", "w3"], VertexComponentType.FLOAT_3)));
			
			// original weight is the distance from the vertex to the opposite
			// side of the triangle, due to the abscence of geometry shader, this
			// is done in the WireframeMeshModifer.
			// It is then modified by its distance to the
			// camera and the scale of the mesh.
			return w.multiply(wireThickness)
				    .divide(cameraDistance)
				    .multiply(scale);;
		}
		
		public function getWireFactor(interpolatedVertexWeights : SValue) : SValue
		{
			// only the shortest distance is used to compute the color of the fragment
			var d 					: SValue 	= min(extract(interpolatedVertexWeights, Components.R),
													  extract(interpolatedVertexWeights, Components.G),
													  extract(interpolatedVertexWeights, Components.B));
			
			// e is strictly negative and closer to 0 the closer the fragment
			// is to a side of the triangle
			var e 					: SValue 	= multiply(-2., d.pow(6));
			
			// the result is between 1 (when e = 0, i.e. when the fragment is on a 
			// triangle edge and rapidly approaches 0 when e decreases (when
			// the fragment gets further from an edge)			
			return power(2., e);
		}
	}
}