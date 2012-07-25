package aerys.minko.scene.node.mesh.geometry
{
	import aerys.minko.ns.minko_stream;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.geometry.stream.VertexStreamList;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	import aerys.minko.render.geometry.Geometry;
	
	public final class WireframeGeometry extends Geometry
	{
		use namespace minko_stream;
		
		public static const VERTEX_FORMAT	: VertexFormat	= new VertexFormat(
			VertexComponent.create(["w1", "w2", "w3"], VertexComponentType.FLOAT_3)
		);
		
		public function WireframeGeometry(source : Geometry)
		{
			super();
			
			initialize(source);
		}
		
		private function initialize(source : Geometry) : void
		{
			var numStreams	: int	= source.numVertexStreams;
			
			indexStream = source.indexStream.clone();
			
			for (var k : int = 0; k < numStreams; ++k)
			{
				var list			: VertexStreamList	= new VertexStreamList();
				var originalStream	: IVertexStream		= source.getVertexStream(k);
				var packedStream	: VertexStream		= VertexStream.extractSubStream(
					originalStream,
					StreamUsage.READ,
					originalStream.format
				);
				
				var vertexStream	: VertexStream		= originalStream.getStreamByComponent(VertexComponent.XYZ);
				var vertexOffset	: int 				= packedStream.format.getOffsetForComponent(VertexComponent.XYZ);
				var vertexLength	: int 				= packedStream.format.size;
				
				var vertices		: Vector.<Number>	= packedStream._data;
				var newVertices		: Vector.<Number>	= new Vector.<Number>();
				var numVertices		: int				= 0;
				var indices			: Vector.<uint>		= indexStream._data;
				var numTriangles	: int				= indexStream.length / 3;

				var weights			: Vector.<Number>	= new Vector.<Number>(3 * numVertices, 0);
				
				for (var i : int = 0; i < numTriangles; ++i)
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
					
					weights.push(
						0., 0., d0,
						0., d1, 0.,
						d2, 0., 0.
					);
					numVertices += 3;
				}
//				packedStream.invalidate();
				
				list.pushVertexStream(
					new VertexStream(StreamUsage.STATIC, packedStream.format, newVertices)
				);
				
				list.pushVertexStream(
					new VertexStream(StreamUsage.STATIC, VERTEX_FORMAT, weights)
				);
				
				setVertexStream(list, k);
			}
			
		}
	}
}