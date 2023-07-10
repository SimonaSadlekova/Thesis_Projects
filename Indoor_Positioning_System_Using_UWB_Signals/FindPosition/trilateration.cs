using SerialCommTrek1000;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{

	public class trilateration
    {
		/// <summary>
		/// This class provides trilateration.
		/// There are two trilateration modes: ThreeSpheres (for using 3 anchors) and Fourspheres (for using 4 anchors). 
		/// For ThreeSpheres there are two solutions (intersection0 and intersection1) and for FourSpheres there is only one solution.
		/// If the trilateration fails, it returns an error.
		/// </summary>

		public static FindLocationResult FindLocation(AnchorPositions anchors, AnchorsDistances distances, double maxzero)
		{
			Vector ex, ey, ez, t1, t2, t3;
			Point3D T2, intersection0, intersection1, solution;
			double h, i, j, x, y, z, t, mu;
			Sphereline result;

			// If any two spheres are concentric, it returns error
			ex = Vector.Difference(anchors.P3, anchors.P1);
			h = Vector.Normalize(ex);

			if (h <= maxzero)
			{
				return new FindLocationResult(TrilaterationResult.ErrorConcentric);
			}

			ex = Vector.Difference(anchors.P3, anchors.P2);
			h = Vector.Normalize(ex);

			if (h <= maxzero)
			{
				return new FindLocationResult(TrilaterationResult.ErrorConcentric);
			}

			ex = Vector.Difference(anchors.P2, anchors.P1);
			h = Vector.Normalize(ex);

			if (h <= maxzero)
			{
				return new FindLocationResult(TrilaterationResult.ErrorConcentric);
			}

			ex = Vector.Division(ex, h); // unit vector ex with respect to p1 (new coordinate system)
			t1 = Vector.Difference(anchors.P3, anchors.P1); // vector p13
			i = Vector.DotProduct(ex, t1); // the scalar of t1 on the ex direction
			t2 = Vector.Multiply(ex, i); // colinear vector to p13 with the length of i

			ey = Vector.Subtraction(t1, t2); // vector t21 perpendicular to t1
			t = Vector.Normalize(ey); // scalar t21
			if (t > maxzero)
			{
				ey = Vector.Division(ey, t); // unit vector ey with respect to p1 (new coordinate system)
				j = Vector.DotProduct(ey, t1); // scalar t1 on the ey direction
			}
			else
			{
				j = 0.0;
			}

			// If 2 intersections are lying on one common line, then p1, p2 and p3 are colinear with more than one solution
			if (Math.Abs(j) <= maxzero)
			{
				/* Is point p1 + (r1 along the axis) the intersection? */
				T2 = Vector.Sum(anchors.P1, Vector.Multiply(ex, distances.Anchor0TagDistance));
				if (Math.Abs(Vector.Normalize(Vector.CountDown(anchors.P2, t2)) - distances.Anchor1TagDistance) <= maxzero &&
					Math.Abs(Vector.Normalize(Vector.CountDown(anchors.P3, t2)) - distances.Anchor2TagDistance) <= maxzero)
				{
					/* Yes, T2 is the only intersection point. */
						intersection0 = T2;
						intersection1 = T2;

					return new FindLocationResult(TrilaterationResult.ThreeSpheres, intersection0, intersection1);
				}

				/* Is point p1 - (r1 along the axis) the intersection? */
				T2 = Vector.Sum(anchors.P1, Vector.Multiply(ex, -distances.Anchor0TagDistance));
				if (Math.Abs(Vector.Normalize(Vector.CountDown(anchors.P2, t2)) - distances.Anchor1TagDistance) <= maxzero &&
					Math.Abs(Vector.Normalize(Vector.CountDown(anchors.P3, t2)) - distances.Anchor2TagDistance) <= maxzero)
				{
					/* Yes, T2 is the only intersection point. */
						intersection0 = T2;
						intersection1 = T2;

					return new FindLocationResult(TrilaterationResult.ThreeSpheres, intersection0, intersection1);
				}

				return new FindLocationResult(TrilaterationResult.ErrorColinear2Solutions);

			}

			ez = Vector.CrossProduct(ex, ey); // unit vector ez with respect to p1 (new coordinate system)

			x = (((distances.Anchor0TagDistance * distances.Anchor0TagDistance) - (distances.Anchor1TagDistance * distances.Anchor1TagDistance)) / (2 * h)) + (h / 2);
			y = (((distances.Anchor0TagDistance * distances.Anchor0TagDistance) - (distances.Anchor2TagDistance * distances.Anchor2TagDistance) + (i * i)) / (2 * j)) + (j / 2) - ((x * i) / j);
			z = (distances.Anchor0TagDistance * distances.Anchor0TagDistance) - (x * x) - (y * y);

			if (z < -maxzero)
			{
				/* The solution is invalid, square root of negative number */
				return new FindLocationResult(TrilaterationResult.ErrorSqrtNegNum);
			}
			else if (z > 0.0)
			{
				z = Math.Sqrt(z);
			}
			else
			{
				z = 0.0;
			}

			T2 = Vector.Sum(anchors.P1, Vector.Multiply(ex, x));
			T2 = Vector.Sum(T2, Vector.Multiply(ey, y));

				intersection0 = Vector.Sum(T2, Vector.Multiply(ez, z));
				intersection1 = Vector.Sum(T2, Vector.Multiply(ez, -z));

			/*********** END OF FINDING TWO POINTS FROM THE FIRST THREE SPHERES **********/
			/********* INTERSECTION0 AND INTERSECTION1 ARE SOLUTIONS, OTHERWISE RETURN ERROR *********/

			/************* FINDING ONE SOLUTION BY INTRODUCING ONE MORE SPHERE ***********/

			if (anchors.P4 != null) // if we have 4 anchors
			{
				// Check for concentricness of sphere 4 to sphere 1, 2 and 3.
				/* If it is concentric to one of them, then sphere 4 cannot be used
					to determine the best solution and return trilateration mode ThreeSpheres*/
				ex = Vector.Difference((Point3D)anchors.P4, anchors.P1);
				h = Vector.Normalize(ex);

				if (h <= maxzero)
				{
					return new FindLocationResult(TrilaterationResult.ThreeSpheres, intersection0, intersection1);
				}

				ex = Vector.Difference((Point3D)anchors.P4, anchors.P2);
				h = Vector.Normalize(ex);

				if (h <= maxzero)
				{
					return new FindLocationResult(TrilaterationResult.ThreeSpheres, intersection0, intersection1);
				}

				ex = Vector.Difference((Point3D)anchors.P4, anchors.P3);
				h = Vector.Normalize(ex);

				if (h <= maxzero)
				{
					return new FindLocationResult(TrilaterationResult.ThreeSpheres, intersection0, intersection1);
				}
				// if sphere 4 is not concentric to any sphere, then best solution can be obtained				
				t3 = Vector.Difference(intersection0, (Point3D)anchors.P4);
				i = Vector.Normalize(t3); /* find i as the distance of result1 to p4 */
				t3 = Vector.Difference(intersection1, (Point3D)anchors.P4);
				h = Vector.Normalize(t3); /* find h as the distance of result2 to p4 */

				/* pick the intersection0 as the nearest point to the center of sphere 4 */
				if (i > h)
				{
					solution = intersection0;
					intersection0 = intersection1;
					intersection1 = solution;
				}

				int count4 = 0;
				double rr4 = distances.Anchor3TagDistance;			
				result = new Sphereline(1, 1);

				/* intersection intersection0-intersection1 vector with sphere 4 */
				while (result.MU1 != 0 && result.MU2 != 0 && count4 < 10)
				{
					result = Sphereline.Intersection(intersection0, intersection1, (Point3D)anchors.P4, rr4);
					rr4 += 0.1;
					count4++;
				}

				if (result.MU1 != 0 && result.MU2 != 0)
				{
					/* No intersection between sphere 4 and the line with the gradient of intersection0-intersection! */
					solution = intersection0;
					// intersection0 is the closer solution to sphere 4
				}
				else
				{
					if (result.MU1 < 0 && result.MU2 < 0)
					/* if both mu1 and mu2 are less than 0, intersection0-intersection1 line segment is outside sphere 4 with no intersection */
					{
						if (Math.Abs(result.MU1) <= Math.Abs(result.MU2))
						{
							mu = result.MU1;
						}
						else
						{
							mu = result.MU2;
						}
						ex = Vector.Difference(intersection1, intersection0);
						h = Vector.Normalize(ex);
						ex = Vector.Division(ex, h);
						/* 50-50 error correction for mu */
						mu = 0.5 * mu;
						/* t2 points to the intersection */
						t2 = Vector.Multiply(ex, mu * h);
						T2 = Vector.Sum(intersection0, t2);
						/* solution je t2 */
						solution = T2;
					}
					else if ((result.MU1 < 0 && result.MU2 > 1) || (result.MU2 < 0 && result.MU1 > 1))
					/* if mu1 is less than zero and mu2 is greater than 1, or the other way around intersection0-intersection1 line segment is inside sphere 4 with no intersection */
					{
						if (result.MU1 > result.MU2)
						{
							mu = result.MU1;
						}
						else
						{
							mu = result.MU2;
						}
						ex = Vector.Difference(intersection1, intersection0);
						h = Vector.Normalize(ex);
						ex = Vector.Division(ex, h);

						t2 = Vector.Multiply(ex, mu * h);
						T2 = Vector.Sum(intersection0, t2);

						/* vector t2-result2 with 50-50 error correction on the length of t3 */
						t3 = Vector.Multiply(Vector.Difference(intersection1, T2), 0.5);

						/* solution = t2 + t3 */
						solution = Vector.Sum(T2, t3);
					}

					else if (((result.MU1 > 0 && result.MU1 < 1) && (result.MU2 < 0 || result.MU2 > 1)) || ((result.MU2 > 0 && result.MU2 < 1) && (result.MU1 < 0 || result.MU1 > 1)))
					/* if one mu is between 0 to 1 and the other is not, intersection0-intersection1 line segment intersects sphere 4 at one point */
					{
						if (result.MU1 >= 0 && result.MU1 <= 1)
						{
							mu = result.MU1;
						}
						else
						{
							mu = result.MU2;
						}
						/* add or subtract with 0.5*mu to distribute error equally onto every sphere */
						if (mu <= 0.5)
						{
							mu -= 0.5 * mu;
						}
						else
						{
							mu -= 0.5 * (1 - mu);
						}
						ex = Vector.Difference(intersection1, intersection0);
						h = Vector.Normalize(ex);
						ex = Vector.Division(ex, h);

						t2 = Vector.Multiply(ex, mu * h);
						T2 = Vector.Sum(intersection0, t2);
						/* solution is t2 */
						solution = T2;
					}
					else if (result.MU1 == result.MU2)
					/* if both mu1 and mu2 are between 0 and 1, and mu1 = mu2 intersection0-intersection1 line segment is tangential to sphere 4 at one point */
					{
						mu = result.MU1;

						/* add or subtract with 0.5*mu to distribute error equally onto every sphere */
						if (mu <= 0.25)
						{
							mu -= 0.5 * mu;
						}
						else if (mu <= 0.5)
						{
							mu -= 0.5 * (0.5 - mu);
						}
						else if (mu <= 0.75)
						{
							mu -= 0.5 * (mu - 0.5);
						}
						else
						{
							mu -= 0.5 * (1 - mu);
						}
						ex = Vector.Difference(intersection1, intersection0);
						h = Vector.Normalize(ex);
						ex = Vector.Division(ex, h);

						t2 = Vector.Multiply(ex, mu * h);
						T2 = Vector.Sum(intersection0, t2);
						/* solution = t2 */
						solution = T2;
					}
					else
					{
						/* if both mu1 and mu2 are between 0 and 1 intersection0-intersection1 line segment intersects sphere 4 at two points */
						mu = result.MU1 + result.MU2;

						ex = Vector.Difference(intersection1, intersection0);
						h = Vector.Normalize(ex);
						ex = Vector.Division(ex, h);

						/* 50-50 error correction for mu */
						mu = 0.5 * mu;

						t2 = Vector.Multiply(ex, mu * h);
						T2 = Vector.Sum(intersection0, t2);
						/* solution = t2 */
						solution = T2;
					}
				}
				return new FindLocationResult(TrilaterationResult.FourSpheres, solution);
			}
			else
			{
				return new FindLocationResult(TrilaterationResult.ThreeSpheres, intersection0, intersection1);
			}
		}
    }
}

