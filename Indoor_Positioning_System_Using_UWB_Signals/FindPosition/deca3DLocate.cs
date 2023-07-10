using SerialCommTrek1000;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
	public class deca3DLocate
	{
		/// <summary>
		/// This class calls method FindLocation from the trilateration class to get solution.
		/// If the trilateration was unsuccessful, it calls the weightedTrilateration function, which finds 
		/// an approximate solution. If this method also fails, then the radius of each of the spheres increases 
		/// to ensure that the intersection is found.
		/// Returns the selected trilateration mode and solution(s).
		/// </summary>

		public static FindLocationResult Solution(AnchorPositions anchors, AnchorsDistances distances, double maxzero, int CmErrorAdded)
		{			
			Point3D solution = default, o1 = default, o2 = default, ptemp;
			Vector solutionCompare1, solutionCompare2;
			double rtemp;
			double gdoprateCompare1, gdoprateCompare2, best3derror, Combination;
			double ovr_r1, ovr_r2, ovr_r3, ovr_r4;
			int overlookCount, combinationCounter;
			int trilaterationErrcounter;
			bool Success, Concentric;
			TrilaterationResult newTrilaterationMode = default;
			FindLocationResult location, foundPoint = default;

			trilaterationErrcounter = 0;

			combinationCounter = 1; 

			double bestgdoprate = 1; /* put the worst gdoprate init */
			gdoprateCompare1 = 1; gdoprateCompare2 = 1;
			double newX = 0; double newY = 0; double newZ = 0;
			solutionCompare1 = new Vector(newX, newY, newZ);		

			do
			{
				Success = false;
				Concentric = false;
				overlookCount = 0;
				ovr_r1 = distances.Anchor0TagDistance; ovr_r2 = distances.Anchor1TagDistance; ovr_r3 = distances.Anchor2TagDistance; ovr_r4 = distances.Anchor3TagDistance;

				do
				{
					distances.Anchor0TagDistance = ovr_r1; distances.Anchor1TagDistance = ovr_r2; distances.Anchor2TagDistance = ovr_r3; distances.Anchor3TagDistance = ovr_r4;
					AnchorsDistances Distances = new AnchorsDistances(distances.Anchor0TagDistance, distances.Anchor1TagDistance, distances.Anchor2TagDistance);
					location = trilateration.FindLocation(anchors, Distances, maxzero);

						switch (location.Result)
						{
						case TrilaterationResult.ThreeSpheres: // 3 spheres are used to get the result
							newTrilaterationMode = TrilaterationResult.ThreeSpheres;
							Success = true;
							break;

						case TrilaterationResult.FourSpheres: // 4 spheres are used to get the result
							newTrilaterationMode = TrilaterationResult.FourSpheres;
							Success = true;
							break;

						case TrilaterationResult.ErrorConcentric:
							Concentric = true;
							break;

						default: // any other return value goes here
                            foundPoint = WeightedTrilateration.weightedTrilateration(anchors, Distances); // weighted trilateration method is called
                            if (foundPoint.Result == TrilaterationResult.ErrorNoSolution)
                            {
                                ovr_r1 += 0.10;
								ovr_r2 += 0.10;
								ovr_r3 += 0.10;
								ovr_r4 += 0.10;
								overlookCount++;
                            }
                            else
                            {
                                newTrilaterationMode = TrilaterationResult.WeightedTrilateration;
                                Success = true;
                            }
                            break;
						}
				}

				//qDebug() << "while(!success)" << overlook_count << concentric << "result" << result;

				while (!Success && (overlookCount <= CmErrorAdded) && !Concentric);

				if (Success)
				{
					System.Diagnostics.Debug.WriteLine($"Location {ovr_r1} {ovr_r2} {ovr_r3} {ovr_r4} +err = {overlookCount}");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"No Location {ovr_r1} {ovr_r2} {ovr_r3} {ovr_r4} +err = {overlookCount}");
				}

				if (Success)
				{
					switch (newTrilaterationMode)
					{
						case TrilaterationResult.ThreeSpheres:
							o1 = location.Intersection0;
							o2 = location.Intersection1;
							//NoSolutionCount = overlookCount;

							combinationCounter = 0;
							break;

						case TrilaterationResult.FourSpheres:
							/* calculate the new GDOPrate */
							gdoprateCompare1 = GDOPrate.gdoprate(solution, anchors);
							/* compare and swap with the better result */
							if (gdoprateCompare1 <= gdoprateCompare2)
							{
								o1 = location.Intersection0;
								o2 = location.Intersection1;
								solution = location.RESULT;
								best3derror = Math.Sqrt((Vector.Normalize(Vector.Difference(solution, anchors.P1)) - distances.Anchor0TagDistance) * (Vector.Normalize(Vector.Difference(solution, anchors.P1)) - distances.Anchor0TagDistance) +
									(Vector.Normalize(Vector.Difference(solution, anchors.P2)) - distances.Anchor1TagDistance) * (Vector.Normalize(Vector.Difference(solution, anchors.P2)) - distances.Anchor1TagDistance) +
									(Vector.Normalize(Vector.Difference(solution, anchors.P3)) - distances.Anchor2TagDistance) * (Vector.Normalize(Vector.Difference(solution, anchors.P3)) - distances.Anchor2TagDistance) +
									(Vector.Normalize(Vector.Difference(solution, (Point3D)anchors.P4)) - distances.Anchor3TagDistance) * (Vector.Normalize(Vector.Difference(solution, (Point3D)anchors.P4)) - distances.Anchor3TagDistance));

								bestgdoprate = gdoprateCompare1;

								/* save the previous result */
								solutionCompare2 = solutionCompare1;
								gdoprateCompare2 = gdoprateCompare1;

								combinationCounter = 0;
								Combination = 5 - combinationCounter;

								/* check all 4 combinations of spheres */
								ptemp = anchors.P1; anchors.P1 = anchors.P2; anchors.P2 = anchors.P3; anchors.P3 = (Point3D)anchors.P4; anchors.P4 = ptemp;
								rtemp = distances.Anchor0TagDistance; distances.Anchor0TagDistance = distances.Anchor1TagDistance; distances.Anchor1TagDistance = distances.Anchor2TagDistance; distances.Anchor2TagDistance = distances.Anchor3TagDistance; distances.Anchor3TagDistance = rtemp;
								combinationCounter--;

							}
							break;

						case TrilaterationResult.WeightedTrilateration:
							solution = foundPoint.RESULT;

							combinationCounter = 0;
							break;

						default:
							break;
					}
				}
				else
				{
					trilaterationErrcounter = 4;
					combinationCounter = 0;
				}			
			}
			while (combinationCounter > 0);

			// if it gives error for all 4 sphere combinations then no valid result is given
			// otherwise return the trilateration mode used with solution(s)
			if (trilaterationErrcounter >= 4)
            {
				return new FindLocationResult(TrilaterationResult.ErrorTrilateration);
            }
			else if (newTrilaterationMode == TrilaterationResult.ThreeSpheres)
			{
				return new FindLocationResult(newTrilaterationMode, o1, o2);
            }
			else 
			{
				return new FindLocationResult(newTrilaterationMode, solution);
            }
		}
	}
}
