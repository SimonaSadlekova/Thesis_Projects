using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
	public class GDOPrate
	{
		/// <summary>
		/// Calculate the GDOP (Geometric Dilution of Precision) rate between 0-1. 
		/// Lower GDOP rate means better precision of intersection.
		/// </summary>
		/// <param name="tag"></param>
		/// <param name="anchors"></param>
		/// <returns>Geometric Dilution of Precisio</returns>
		public static double gdoprate(Point3D tag, AnchorPositions anchors)
		{
			Vector ex, t1, t2, t3;
			double h, gdop1, gdop2, gdop3, result, dotproduct1, dotproduct2, dotproduct3;

			ex = Vector.Difference(anchors.P1, tag);
			h = Vector.Normalize(ex);
			t1 = Vector.Division(ex, h);

			ex = Vector.Difference(anchors.P2, tag);
			h = Vector.Normalize(ex);
			t2 = Vector.Division(ex, h);

			ex = Vector.Difference(anchors.P3, tag);
			h = Vector.Normalize(ex);
			t3 = Vector.Division(ex, h);

			dotproduct1 = Vector.DotProduct(t1, t2);
			gdop1 = Math.Abs(dotproduct1);
			dotproduct2 = Vector.DotProduct(t2, t3);
			gdop2 = Math.Abs(dotproduct2);
			dotproduct3 = Vector.DotProduct(t3, t1);
			gdop3 = Math.Abs(dotproduct3);

			if (gdop1 < gdop2)
			{
				result = gdop2;
			}
			else
			{
				result = gdop1;
			}
			if (result < gdop3)
			{
				result = gdop3;
			}

			return result;
		}
	}
}
