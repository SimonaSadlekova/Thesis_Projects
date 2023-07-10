using SerialCommTrek1000;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
    public class WeightedTrilateration
    {
        /// <summary>
        /// If the spheres do not intersect at one point, 
        /// but create an area that is bounded by 3 points (intersections), 
        /// we use the method of weighted trilateration. 
        /// </summary>

        public static FindLocationResult weightedTrilateration(AnchorPositions anchors, AnchorsDistances distances)
        {
            FindPoints Points;
            Point3D P, p1, p2, p3, solution = default;
            Vector D, xaxis;
            double w, d1, d2, d3, theta, d, Smallest = default, Medium, Biggest = default;


            Points = FindPoints.findpoints(anchors, distances);
            if (Points.Result == TrilaterationResult.ErrorNoSolution)
            {
                return new FindLocationResult(TrilaterationResult.ErrorNoSolution);
            }
            else
            {
                p1 = Points.Point1;
                p2 = Points.Point2;
                p3 = Points.Point3;
            }

            //calculate the center of gravity of the triangle  
            P = Vector.CentrePoint(p1, p2, p3);

            //axis x
            xaxis = new Vector(1, 0, 0);

            double r1 = distances.Anchor0TagDistance;
            double r2 = distances.Anchor1TagDistance;
            double r3 = distances.Anchor2TagDistance;

            double r4 = distances.Anchor3TagDistance;

            //compare the radii of the spheres and find out which 2 are the smallest
            if ((r1 < r2 && r1 < r3) && (r2 < r3))
            {
                Smallest = r1;
                Medium = r2;
                Biggest = r3;
            }
            if ((r1 < r2 && r1 < r3) && (r3 < r2))
            {
                Smallest = r1;
                Medium = r3;
                Biggest = r2;
            }
            if ((r2 < r1 && r2 < r3) && (r1 < r3))
            {
                Smallest = r2;
                Medium = r1;
                Biggest = r3;
            }

            if ((r2 < r1 && r2 < r3) && (r3 < r1))
            {
                Smallest = r2;
                Medium = r3;
                Biggest = r1;
            }
            if ((r3 < r1 && r3 < r2) && (r1 < r2))
            {
                Smallest = r3;
                Medium = r1;
                Biggest = r2;
            }
            if ((r3 < r1 && r3 < r2) && (r2 < r1))
            {
                Smallest = r3;
                Medium = r2;
                Biggest = r1;
            }

            //calculate the respective pair weights
            w = Smallest / Biggest;

            //P moves to the point closest to the center of gravity point
            d1 = Vector.Distance(P, Points.Point1);
            d2 = Vector.Distance(P, Points.Point2);
            d3 = Vector.Distance(P, Points.Point3);

            if ((d1 < d2) && (d1 < d3))
            {
                solution = Points.Point1;
            }
            else if ((d2 < d1) && (d2 < d3))
            {
                solution = Points.Point2; ;
            }
            else if ((d3 < d1) && (d3 < d2))
            {
                solution = Points.Point3;
            }

            D = Vector.Difference(P, solution);
            d = Vector.Distance(P, solution);

            //calculate the position of the searched point (theta is the angle between the line D and the x-axis)
            theta = Math.Acos((Vector.DotProduct(D, xaxis))/((Vector.Normalize(D))*Vector.Normalize(xaxis)));
            double x = P.X + (1 - w) * d * Math.Cos(theta);
            double y = P.Y + (1 - w) * d * Math.Cos(theta);
            double z = P.Z + (1 - w) * d * Math.Cos(theta);
            solution = new Point3D(x, y, z);

            return new FindLocationResult(TrilaterationResult.WeightedTrilateration, solution);
        }
    }

}
