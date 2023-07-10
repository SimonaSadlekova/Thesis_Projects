using SerialCommTrek1000;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
    /// <summary>
    /// Find the three points that create the area where the tag is located.
    /// </summary>

    public class FindPoints
    {
        public Point3D Point1 { get; set; }
        public Point3D Point2 { get; set; }
        public Point3D Point3 { get; set; }
        public TrilaterationResult Result { get; set; }

        public FindPoints(Point3D point1, Point3D point2, Point3D point3)
        {
            this.Point1 = point1;
            this.Point2 = point2;
            this.Point3 = point3;
        }

        public FindPoints(TrilaterationResult result)
        {
            this.Result = result;
        }

        public static FindPoints findpoints(AnchorPositions anchors, AnchorsDistances distances)
        {
            double d1, d2, d3, h1, h2, h3, rp1, rp2, rp3, theta, distance1, distance2;
            Point3D C1, C2, C3, P1, P2, P3, P4, P5, P6;
            Vector n1, n2, n3, t1, t2, t3, b1, b2, b3, xaxis;
            Point3D point1 = default;
            Point3D point2 = default;
            Point3D point3 = default;

            //Distance between the centers of 2 spheres
            d1 = Vector.Distance(anchors.P1, anchors.P2);
            d2 = Vector.Distance(anchors.P1, anchors.P3);
            d3 = Vector.Distance(anchors.P2, anchors.P3);

            double r1 = distances.Anchor0TagDistance;
            double r2 = distances.Anchor1TagDistance;
            double r3 = distances.Anchor2TagDistance;

            double r4 = distances.Anchor3TagDistance;

            xaxis = new Vector(1, 0, 0);

            h1 = (1 / 2) + (((r1 * r1) - (r2 * r2)) / (2 * d1 * d1));
            h2 = (1 / 2) + (((r1 * r1) - (r3 * r3)) / (2 * d2 * d2));
            h3 = (1 / 2) + (((r2 * r2) - (r3 * r3)) / (2 * d3 * d3));

            //The center of the intersection circle
            C1 = Vector.Sum(anchors.P1, Vector.Multiply(Vector.Difference(anchors.P2, anchors.P1), h1));
            C2 = Vector.Sum(anchors.P1, Vector.Multiply(Vector.Difference(anchors.P3, anchors.P1), h2));
            C3 = Vector.Sum(anchors.P2, Vector.Multiply(Vector.Difference(anchors.P3, anchors.P2), h3));

            //The radius of the intersection circle
            rp1 = (Math.Sqrt((4 * r1 * r1 * d1 * d1) - Math.Pow(((r1 * r1) + (d1 * d1) - (r2 * r2)),2)));
            rp2 = (Math.Sqrt((4 * r1 * r1 * d2 * d2) - Math.Pow(((r1 * r1) + (d2 * d2) - (r3 * r3)), 2)));
            rp3 = (Math.Sqrt((4 * r2 * r2 * d3 * d3) - Math.Pow(((r2 * r2) + (d3 * d3) - (r3 * r3)), 2)));

            //The intersection circle lies in a plane perpendicular to the dividing axis. The normal of this plane is:
            n1 = Vector.Division(Vector.Difference(anchors.P2, anchors.P1), d1);
            n2 = Vector.Division(Vector.Difference(anchors.P3, anchors.P1), d2);
            n3 = Vector.Division(Vector.Difference(anchors.P3, anchors.P2), d3);

            //Tangent in a plane perpendicular to the dividing axis and the normal
            t1 = Vector.CrossProduct(xaxis, n1);
            t2 = Vector.CrossProduct(xaxis, n2);
            t3 = Vector.CrossProduct(xaxis, n3);

            //Tangent to t and normal
            b1 = Vector.CrossProduct(t1, n1);
            b2 = Vector.CrossProduct(t2, n2);
            b3 = Vector.CrossProduct(t3, n3);

            theta = Math.Acos(((r1*r1) + (r2*r2) - (d1*d1))/(2*r1*r2));

            //We will find all intersections
            P1 = Vector.Sum(C1, (Vector.Multiply(Vector.Addition(Vector.Multiply(t1, Math.Cos(theta)), Vector.Multiply(b1, Math.Sin(theta))), rp1)));
            P2 = Vector.Sum(C1, (Vector.Multiply(Vector.Subtraction(Vector.Multiply(t1, Math.Cos(theta)), Vector.Multiply(b1, Math.Sin(theta))), rp1)));
            P3 = Vector.Sum(C2, (Vector.Multiply(Vector.Addition(Vector.Multiply(t2, Math.Cos(theta)), Vector.Multiply(b2, Math.Sin(theta))), rp2)));
            P4 = Vector.Sum(C2, (Vector.Multiply(Vector.Subtraction(Vector.Multiply(t2, Math.Cos(theta)), Vector.Multiply(b2, Math.Sin(theta))), rp2)));
            P5 = Vector.Sum(C3, (Vector.Multiply(Vector.Addition(Vector.Multiply(t3, Math.Cos(theta)), Vector.Multiply(b3, Math.Sin(theta))), rp3)));
            P6 = Vector.Sum(C3, (Vector.Multiply(Vector.Subtraction(Vector.Multiply(t3, Math.Cos(theta)), Vector.Multiply(b3, Math.Sin(theta))), rp3)));

            distance1 = Vector.Distance(anchors.P3, P1);
            distance2 = Vector.Distance(anchors.P3, P2);

            //If the distance of the center of the 3rd sphere from the intersection of P1 is less than the radius of the 3rd sphere, 
            //then P1 lies inside the sphere 3 and is the point we are looking for
            if (distance1 < r3)
            {
                point1 = P1;
            }
            else if (distance2 < r3)
            {
                point1 = P2;
            }
            else
            {
                return new FindPoints(TrilaterationResult.ErrorNoSolution);
            }

            distance1 = Vector.Distance(point1, P3);
            distance2 = Vector.Distance(point1, P4);

            //Select the intersections that lie closest to P1
            if (distance1 < distance2)
            {
                point2 = P3;
            }
            else
            {
                point2 = P4;
            }

            distance1 = Vector.Distance(point1, P5);
            distance2 = Vector.Distance(point1, P6);

            if (distance1 < distance2)
            {
                point3 = P5;
            }
            else
            {
                point3 = P6;
            }

            return new FindPoints(point1, point2, point3);
        }

    }
}
