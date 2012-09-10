package aerys.minko.scene.node.mesh.geometry
{
	import aerys.minko.ns.minko_stream;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.geometry.stream.VertexStreamList;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public final class WireframeGeometry extends Geometry
	{
		use namespace minko_stream;
		
		public static const VERTEX_FORMAT	: VertexFormat	= new VertexFormat(
			VertexComponent.create(['w1', 'w2', 'w3'], VertexComponentType.FLOAT_3)
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
				
				var xyzStream		: VertexStream		= originalStream.getStreamByComponent(VertexComponent.XYZ);
				var xyzOffset		: uint 				= packedStream.format.getBytesOffsetForComponent(VertexComponent.XYZ);
				var xyzVertexSize	: uint 				= packedStream.format.numBytesPerVertex;
				
				var xyzData			: ByteArray			= packedStream.lock();
				var newVertices		: ByteArray			= new ByteArray();
				var numVertices		: int				= 0;
				var indices			: ByteArray			= indexStream.lock();
				var numTriangles	: int				= indexStream.length / 3;

				var weights			: ByteArray			= new ByteArray();
				
				newVertices.endian = Endian.LITTLE_ENDIAN;
				weights.endian = Endian.LITTLE_ENDIAN;
				
				for (var i : int = 0; i < numTriangles; ++i)
				{
					var i0	: int 		= indices.readUnsignedShort();
					var i1	: int 		= indices.readUnsignedShort();
					var i2	: int 		= indices.readUnsignedShort();
					
					var ii0	: int 		= xyzOffset + xyzVertexSize * i0;
					var ii1	: int		= xyzOffset + xyzVertexSize * i1;
					var ii2	: int 		= xyzOffset + xyzVertexSize * i2;

					xyzData.position = ii0;
					var x0	: Number 	= xyzData.readFloat();
					var y0	: Number 	= xyzData.readFloat();
					var z0	: Number 	= xyzData.readFloat();
					
					xyzData.position = ii1;
					var x1	: Number 	= xyzData.readFloat();
					var y1	: Number 	= xyzData.readFloat();
					var z1	: Number 	= xyzData.readFloat();
					
					xyzData.position = ii2;
					var x2	: Number 	= xyzData.readFloat();
					var y2	: Number 	= xyzData.readFloat();
					var z2	: Number 	= xyzData.readFloat();
					
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
					
					newVertices.writeBytes(xyzData, ii0, xyzVertexSize);
					newVertices.writeBytes(xyzData, ii1, xyzVertexSize);
					newVertices.writeBytes(xyzData, ii2, xyzVertexSize);
					
					indices.position -= 6;
					indices.writeShort(numVertices);
					indices.writeShort(numVertices + 1);
					indices.writeShort(numVertices + 2);

					weights.writeFloat(0.);
					weights.writeFloat(0.);
					weights.writeFloat(d0);
					weights.writeFloat(0.);
					weights.writeFloat(d1);
					weights.writeFloat(0.);
					weights.writeFloat(d2);
					weights.writeFloat(0.);
					weights.writeFloat(0.);
					
					numVertices += 3;
				}
				
				packedStream.unlock(false);
				indexStream.unlock(true);
				
				newVertices.position = 0;
				list.pushVertexStream(
					new VertexStream(StreamUsage.STATIC, packedStream.format, newVertices)
				);
				
				weights.position = 0;
				list.pushVertexStream(
					new VertexStream(StreamUsage.STATIC, VERTEX_FORMAT, weights)
				);
				
				setVertexStream(list, k);
			}
			
		}
	}
}