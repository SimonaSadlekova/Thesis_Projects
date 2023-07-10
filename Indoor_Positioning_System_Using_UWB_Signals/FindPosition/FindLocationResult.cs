using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{

	/// <summary>
	/// The class contains properties that are returned
	/// </summary>

	public enum TrilaterationResult
	{
		ErrorConcentric,  //The spheres are concentric
		ErrorColinear2Solutions, //The spheres are collinear - more than one solution
		ErrorSqrtNegNum, //The solution is invalid, the square root of a negative number
		ErrorNoSolution, //2 spheres do not intersect inside the third
		ThreeSpheres, //3 spheres are used to get the result
		FourSpheres, //4 spheres are used to get the result	
		WeightedTrilateration, //weighted trilateration method was used to get the result
		ErrorTrilateration //If it gives error for all 4 sphere combinations
	}

	public class FindLocationResult
    {
        public TrilaterationResult Result { get; set; }
        public Point3D Intersection0 { get; set; }
        public Point3D Intersection1 { get; set; }
		public Point3D RESULT { get; set; }
		public Point3D POINT { get; set; }

		public FindLocationResult(Point3D point)
		{
			this.POINT = point;
		}
		public FindLocationResult(TrilaterationResult result, Point3D int0, Point3D int1)
        {
            this.Result = result;
            this.Intersection0 = int0;
            this.Intersection1 = int1;
        }

		public FindLocationResult(TrilaterationResult result, Point3D Result)
		{
			this.Result = result;
			this.RESULT = Result;
		}

		public FindLocationResult(TrilaterationResult result)
		{
			this.Result = result;
		}

    }
}
