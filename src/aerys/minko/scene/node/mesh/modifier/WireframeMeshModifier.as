package aerys.minko.scene.node.mesh.modifier
{
	import aerys.minko.ns.minko_stream;
	import aerys.minko.scene.node.mesh.IMesh;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.type.stream.IVertexStream;
	import aerys.minko.type.stream.VertexStream;
	import aerys.minko.type.stream.VertexStreamList;
	import aerys.minko.type.stream.format.VertexComponent;
	import aerys.minko.type.stream.format.VertexComponentType;
	import aerys.minko.type.stream.format.VertexFormat;
	import aerys.minko.type.stream.iterator.VertexIterator;
	
	import flash.geom.Vector3D;
	
	public class WireframeMeshModifier extends AbstractMeshModifier
	{
		use namespace minko_stream;
		
		public static const VERTEX_FORMAT	: VertexFormat	= new VertexFormat(VertexComponent.create(["w1", "w2", "w3"], VertexComponentType.FLOAT_3));
		
		protected var _version : uint = 0;
		
		override public function get version() : uint	{ return super.version + _version; }
		
		public function WireframeMeshModifier(target : IMesh)
		{
			super(target);
			
			addVerticeWeights(target);
		}
		
		private function addVerticeWeights(target : IMesh) : void
		{
			var originalStream	: IVertexStream	= target.vertexStream;
			var packedStream	: VertexStream	= VertexStream.extractSubStream(originalStream, originalStream.format);
			
			_indexStream		= target.indexStream.clone();
			_vertexStreamList	= new VertexStreamList();
			
			var format			: VertexFormat		= VERTEX_FORMAT;
			
			var vertexStream	: VertexStream		= target.vertexStream.getSubStreamByComponent(VertexComponent.XYZ);
			var vertexOffset	: int 				= packedStream.format.getOffsetForComponent(VertexComponent.XYZ);
			var vertexLength	: int 				= packedStream.format.dwordsPerVertex;
			
			var vertices		: Vector.<Number>	= packedStream._data;
			var newVertices		: Vector.<Number>	= new Vector.<Number>();
			var numVertices		: int				= 0;
			var indices			: Vector.<uint>		= _indexStream._data;
			var numTriangles	: int				= _indexStream.length / 3;
			
			var weights			: Vector.<Number>	= new Vector.<Number>(3 * numVertices, 0);
			
			var i				: int				= 0;
			
			for (i = 0; i < numTriangles; ++i)
			{				
				var i0	: int 		= indices[int(3 * i)];
				var i1	: int 		= indices[int(3 * i + 1)];
				var i2	: int 		= indices[int(3 * i + 2)];
				
				var ii0	: int 		= vertexOffset + vertexLength * i0;
				var ii1	: int		= vertexOffset + vertexLength * i1;
				var ii2	: int 		= vertexOffset + vertexLength * i2;
				
				var x0	: Number 	= vertices[ii0];
				var y0	: Number 	= vertices[int(ii0 + 1)];
				var z0	: Number 	= vertices[int(ii0 + 2)];
				
				var x1	: Number 	= vertices[ii1];
				var y1	: Number 	= vertices[int(ii1 + 1)];
				var z1	: Number 	= vertices[int(ii1 + 2)];
				
				var x2	: Number 	= vertices[ii2];
				var y2	: Number 	= vertices[int(ii2 + 1)];
				var z2	: Number 	= vertices[int(ii2 + 2)];
				
				var v01	: Vector4 	= new Vector4(x0 - x1, y0 - y1, z0 - z1);
				var v02	: Vector4	= new Vector4(x2 - x1, y2 - y1, z2 - z1);
				var d0 	: Number	= (v01.crossProduct(v02)).length / v02.length;				
				
				var v11	: Vector4 	= new Vector4(x1 - x0, y1 - y0, z1 - z0);
				var v12	: Vector4	= new Vector4(x2 - x0, y2 - y0, z2 - z0);
				var d1 	: Number	= (v11.crossProduct(v12)).length / v12.length;
				
				var v21	: Vector4 	= new Vector4(x2 - x1, y2 - y1, z2 - z1);
				var v22	: Vector4	= new Vector4(x1 - x0, y1 - y0, z1 - z0);
				var d2 	: Number	= (v21.crossProduct(v22)).length / v22.length;
				
				var j	: int 		= 0;
					
				for (j = 0; j < vertexLength; j++)
					newVertices.push(vertices[int(ii0 + j)]);
				for (j = 0; j < vertexLength; j++)
					newVertices.push(vertices[int(ii1 + j)]);
				for (j = 0; j < vertexLength; j++)
					newVertices.push(vertices[int(ii2 + j)]);
					
				indices[int(3 * i)] = numVertices;
				indices[int(3 * i + 1)] = numVertices + 1;
				indices[int(3 * i + 2)] = numVertices + 2;
					
				weights.push(0., 0., d0,
							 0., d1, 0.,
							 d2, 0., 0.);
				numVertices += 3;
			}
			packedStream.invalidate();
			
			_vertexStreamList.pushVertexStream(new VertexStream(newVertices, packedStream.format, packedStream.isDynamic));
			_vertexStreamList.pushVertexStream(new VertexStream(weights, format, vertexStream.isDynamic));
		}
	}
}