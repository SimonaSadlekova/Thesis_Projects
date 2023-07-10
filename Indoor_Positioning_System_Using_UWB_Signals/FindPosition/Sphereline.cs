using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
    public class Sphereline
	{
		/// <summary>
		/// Intersecting a sphere sc with radius of r, with a line p1-p2. 
		/// Return parameters mu1 and mu2.
		/// </summary>

		//Properties			
		public double MU1 { get; set; }
		public double MU2 { get; set; }

		//Constructors
		public Sphereline(double mu1, double mu2)
		{
			this.MU1 = mu1;
			this.MU1 = mu2;
		}

		public static Sphereline Intersection(Point3D p1, Point3D p2, Point3D sc, double r)
		{
			double a, b, c;
			double bb4ac;
			Vector dp;
			double mu1, mu2;		

			dp = Vector.Difference(p2, p1);
			a = dp.X * dp.X + dp.Y * dp.Y + dp.Z * dp.Z;

			b = 2 * (dp.X * (p1.X - sc.X) + dp.Y * (p1.Y - sc.Y) + dp.Z * (p1.Z - sc.Z));

			c = sc.X * sc.X + sc.Y * sc.Y + sc.Z * sc.Z;
			c += p1.X * p1.X + p1.Y * p1.Y + p1.Z * p1.Z;
			c -= 2 * (sc.X * p1.X + sc.Y * p1.Y + sc.Z * p1.Z);
			c -= r * r;

			bb4ac = b * b - 4 * a * c;

			if (Math.Abs(a) == 0 || bb4ac < 0)
			{
				mu1 = 0;
				mu2 = 0;
				return new Sphereline(mu1, mu2);
			}
			else
			{
				mu1 = (-b + Math.Sqrt(bb4ac)) / (2 * a);
				mu2 = (-b - Math.Sqrt(bb4ac)) / (2 * a);
				return new Sphereline(mu1, mu2);
			}
		}
	}
}
