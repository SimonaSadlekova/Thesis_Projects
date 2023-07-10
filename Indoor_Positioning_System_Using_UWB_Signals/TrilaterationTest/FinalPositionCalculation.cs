using System;
using System.Windows.Media.Media3D;
using FindPosition;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SerialCommTrek1000;

namespace TrilaterationTest
{
    [TestClass]
    public class FinalPositionCalculation
    {

        /* To try testing the function of the library in case when the spheres intersect in the area using original algorithm, 
         * lines 74-76 and 82-87 have to be commented out in the method Solution of the deca_3DLocate class */

        [TestMethod]
        /* Testing the function of the library for the case when the spheres intersect at one point */
        public void getLocation()
        {
            Point3D bestSolution = new Point3D(4.93198, 8.98348, -0.237652);

            Point3D newP1 = new Point3D(2.597, 6.882, 1.5);
            Point3D newP2 = new Point3D(0.593, 0.615, 1.5);
            Point3D newP3 = new Point3D(5.381, 4.183, 1.5);
            Point3D? newP4 = null;

            AnchorPositions anchors = new AnchorPositions(newP1, newP2, newP3, newP4);
            AnchorsDistances distances = new AnchorsDistances(3.588, 9.591, 5.125);
            FindLocationResult Position = new FindLocationResult(TrilaterationResult.ThreeSpheres, bestSolution);
            FindLocationResult newPosition = GetLocation.getLocation(anchors, distances, 0.001, 10);

            /* To be sure, a tolerance is added to the result because the results do not match all decimal places. */
            Assert.AreEqual(Position.RESULT.X, newPosition.RESULT.X, 0.01);
            Assert.AreEqual(Position.RESULT.Y, newPosition.RESULT.Y, 0.01);
            Assert.AreEqual(Position.RESULT.Z, newPosition.RESULT.Z, 0.1);
        }

        [TestMethod]
        /* Testing the function of the library in case when the spheres intersect in the area using the weighted trilateration method */
        public void weightedTrilaterationTest()
        {
            Point3D bestSolution = new Point3D(2, 1, 1.5);

            Point3D newP1 = new Point3D(0, 0, 1.5);
            Point3D newP2 = new Point3D(2, 0, 1.5);
            Point3D newP3 = new Point3D(0, 1, 1.5);
            Point3D? newP4 = null;

            AnchorPositions anchors = new AnchorPositions(newP1, newP2, newP3, newP4);
            AnchorsDistances distances = new AnchorsDistances(2.236, 1, 2);
            FindLocationResult Position = new FindLocationResult(TrilaterationResult.ThreeSpheres, bestSolution);
            FindLocationResult newPosition = GetLocation.getLocation(anchors, distances, 0.001, 10);

            Assert.AreEqual(Position.RESULT.X, newPosition.RESULT.X, 0.2);
            Assert.AreEqual(Position.RESULT.Y, newPosition.RESULT.Y, 0.2);
            Assert.AreEqual(Position.RESULT.Z, newPosition.RESULT.Z, 0.2);

            AnchorsDistances newDistances = new AnchorsDistances(2.736, 1, 2);

            FindLocationResult PositionA = GetLocation.getLocation(anchors, newDistances, 0.001, 10);

            Assert.AreEqual(Position.RESULT.X, PositionA.RESULT.X, 1);
            Assert.AreEqual(Position.RESULT.Y, PositionA.RESULT.Y, 1);
            Assert.AreEqual(Position.RESULT.Z, PositionA.RESULT.Z, 1.6);
        }
    }
}
