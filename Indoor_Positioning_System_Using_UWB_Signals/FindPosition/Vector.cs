using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
    public class Vector
    {
		public double X { get; set; }
		public double Y { get; set; }
		public double Z { get; set; }

		public Vector(double x, double y, double z)
		{
			this.X = x;
			this.Y = y;
			this.Z = z;
		}

		//Methods
		// Returns the sum of two vectors.
		public static Vector Addition(Vector a, Vector b)
		{
			double newX = a.X + b.X;
			double newY = a.Y + b.Y;
			double newZ = a.Z + b.Z;
			Vector v = new Vector(newX, newY, newZ);
			return v;
		}

		public static Point3D Sum(Point3D a, Vector b)
        {
			double newX = a.X + b.X;
			double newY = a.Y + b.Y;
			double newZ = a.Z + b.Z;
			Point3D v = new Point3D(newX, newY, newZ);
			return v;
		}
		// Returns the position of the centre of area
		public static Point3D CentrePoint(Point3D a, Point3D b, Point3D c)
        {
			double newX = (a.X + b.X + c.X)/3;
			double newY = (a.Y + b.Y + c.Y)/3;
			double newZ = (a.Z + b.Z + c.Z)/3;
			Point3D v = new Point3D(newX, newY, newZ);
			return v;
        }

		// Returns the difference of two vectors, (Vector a - Vector b).
		public static Vector Subtraction(Vector a, Vector b)
		{
			double newX = a.X - b.X;
			double newY = a.Y - b.Y;
			double newZ = a.Z - b.Z;
			Vector v = new Vector(newX, newY, newZ);
			return v;
		}

		// Returns directed line segment 
		public static Vector Difference(Point3D a, Point3D b)
        {
			double newX = a.X - b.X;
			double newY = a.Y - b.Y;
			double newZ = a.Z - b.Z;
			Vector v = new Vector(newX, newY, newZ);
			return v;
		}

		public static Vector CountDown(Point3D a, Vector b)
        {
			double newX = a.X - b.X;
			double newY = a.Y - b.Y;
			double newZ = a.Z - b.Z;
			Vector v = new Vector(newX, newY, newZ);
			return v;
		}

		// Multiplies vector by a number.
		public static Vector Multiply(Vector c, double n)
		{
			double newX = c.X * n;
			double newY = c.Y * n;
			double newZ = c.Z * n;
			Vector v = new Vector(newX, newY, newZ);
			return v;
		}

		// Divides vector by a number.
		public static Vector Division(Vector c, double n)
		{
			double newX = c.X / n;
			double newY = c.Y / n;
			double newZ = c.Z / n;
			Vector v = new Vector(newX, newY, newZ);
			return v;
		}

		public static Point3D Dividing(Point3D c, double n)
		{
			double newX = c.X / n;
			double newY = c.Y / n;
			double newZ = c.Z / n;
			Point3D v = new Point3D(newX, newY, newZ);
			return v;
		}

		// Returns the distance of 2 vectors.
		public static double Distance(Point3D a, Point3D b)
		{
			double newX = a.X - b.X;
			double newY = a.Y - b.Y;
			double newZ = a.Z - b.Z;
			double sql = newX * newX + newY * newY + newZ * newZ;
			double len = Math.Sqrt(sql);
			return len;
		}

		// Normalizes a vector. A normalized vector maintains its direction but its magnitude becomes 1. 
		// The resulting vector is often called a unit vector.
		public static double Normalize(Vector c)
		{
			double v = Math.Sqrt(c.X * c.X + c.Y * c.Y + c.Z * c.Z);
			return v;
		}

		// Returns the dot product of two vectors.
		public static double DotProduct(Vector a, Vector b)
		{
			double dot = a.X * b.X + a.Y * b.Y + a.Z * b.Z;
			return dot;
		}

		// Returns the cross product of two vectors.
		public static Vector CrossProduct(Vector a, Vector b)
		{
			double newX = a.Y * b.Z - a.Z * b.Y;
			double newY = a.Z * b.X - a.X * b.Z;
			double newZ = a.X * b.Y - a.Y * b.X;
			Vector v = new Vector(newX, newY, newZ);
			return v;
		}
	}
}
