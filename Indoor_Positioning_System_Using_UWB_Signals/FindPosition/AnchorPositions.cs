using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace FindPosition
{
    /// <summary>
    /// This class contains the setting of anchor positions
    /// </summary>

    public class AnchorPositions
    {        
        public Point3D P1 { get; set; }
        public Point3D P2 { get; set; }
        public Point3D P3 { get; set; } //Three anchors always necessary

        public Nullable<Point3D> P4 { get; set; } //Fourth anchor is optional

        public AnchorPositions(Point3D p1, Point3D p2, Point3D p3, Point3D? p4)
        {
            this.P1 = p1;
            this.P2 = p2;
            this.P3 = p3;
            this.P4 = p4;
        }

        public AnchorPositions(Point3D p1, Point3D p2, Point3D p3, Point3D p4)
        {
            this.P1 = p1;
            this.P2 = p2;
            this.P3 = p3;
            this.P4 = p4;
        }
    }
}
