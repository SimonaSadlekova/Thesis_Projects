using SerialCommTrek1000;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
    public class GetLocation
    {
        /// <summary>
        /// The GetLocation class calls Solution from the deca_3dlocate class to get the most accurate position.
        /// Then, if the distance from the 4th anchor was provided, the 4th anchor is used and 
        /// it finds the best result by finding the closest distance to the measured distance received from the 4th anchor.
        /// </summary>

        public static FindLocationResult getLocation(AnchorPositions anchors, AnchorsDistances distances, double maxzero, int CmErrorAdded)
        {
            Point3D bestSolution = default;
            FindLocationResult result;
            TrilaterationResult newTrilaterationMode;

            Vector t3;
            double dist1, dist2;

            // Odhady vzdialeností kotiev od tagu
            double r1 = distances.Anchor0TagDistance;
            double r2 = distances.Anchor1TagDistance;
            double r3 = distances.Anchor2TagDistance;

            double r4 = distances.Anchor3TagDistance;

            /* get the best location using 3 or 4 spheres */
            result = deca3DLocate.Solution(anchors, distances, maxzero, CmErrorAdded);
            newTrilaterationMode = result.Result;
          
                if (result.Result == TrilaterationResult.FourSpheres) //if have 4 ranging results, then use 4th anchor to pick solution closest to it
                {
                    double diff1, diff2;

                    /* find dist1 as the distance of o1 to known_best_location */
                    t3 = Vector.Difference(result.Intersection0, (Point3D)anchors.P4);
                    dist1 = Vector.Normalize(t3);

                    t3 = Vector.Difference(result.Intersection1, (Point3D)anchors.P4);
                    dist2 = Vector.Normalize(t3);

                    /* find the distance closest to received range measurement from 4th anchor */
                    diff1 = Math.Abs(r4 - dist1);
                    diff2 = Math.Abs(r4 - dist2);

                    /* pick the closest match to the 4th anchor range */
                    if (diff1 < diff2)
                    {
                        bestSolution = result.Intersection0;
                    }
                    else
                    {
                        bestSolution = result.Intersection1;
                    }
                }

                else if (result.Result == TrilaterationResult.ThreeSpheres)
                {
                    //assume tag is below the anchors (1, 2, and 3)
                    if (result.Intersection0.Z < anchors.P1.Z)
                    {
                        bestSolution = result.Intersection0;
                    }
                    else
                    {
                        bestSolution = result.Intersection1;
                    }
                }  
                else
                {
                    bestSolution = result.RESULT;
                }
                
            return new FindLocationResult(newTrilaterationMode, bestSolution);
        }
    }
}
