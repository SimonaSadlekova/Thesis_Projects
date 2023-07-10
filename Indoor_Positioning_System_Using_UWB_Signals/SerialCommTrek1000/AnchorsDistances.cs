using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SerialCommTrek1000
{
    public class AnchorsDistances
    {
        public double Anchor0TagDistance { get; set; }
        public double Anchor1TagDistance { get; set; }
        public double Anchor2TagDistance { get; set; }
        public double Anchor3TagDistance { get; set; }

        public AnchorsDistances(double anchor0TagDistance1, double anchor1TagDistance, double anchor2TagDistance)
        {
            this.Anchor0TagDistance = anchor0TagDistance1;
            this.Anchor1TagDistance = anchor1TagDistance;
            this.Anchor2TagDistance = anchor2TagDistance;
        }

        public AnchorsDistances(double anchor0TagDistance1, double anchor1TagDistance, double anchor2TagDistance, double anchor3TagDistance)
        {
            this.Anchor0TagDistance = anchor0TagDistance1;
            this.Anchor1TagDistance = anchor1TagDistance;
            this.Anchor2TagDistance = anchor2TagDistance;
            this.Anchor3TagDistance = anchor3TagDistance;
        }

        public AnchorsDistances GetDistances(byte[] data)
        {
            double anchor0TagDistance;
            double anchor1TagDistance;
            double anchor2TagDistance;
            double anchor3TagDistance;
            int mask;
            int ALLanchorTagDistances;
            double SerialNumberATDistances;
            double TimeATDistance;

            string s = Encoding.ASCII.GetString(data);
            var messageParts = s.Split(' ');

            if (int.TryParse(messageParts[1], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out mask))
            {
                Console.WriteLine("This measurement contains {0} valid distances between the anchors and the tag", mask);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part valid distances between the anchors and the tags");
            }

            if (double.TryParse(messageParts[2], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out anchor0TagDistance))
            {
                Console.WriteLine("Distance between Anchor0 and Tag is {0} mm", anchor0TagDistance);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part distacne between Anchor0 and Tag");
            }

            if (double.TryParse(messageParts[3], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out anchor1TagDistance))
            {
                Console.WriteLine("Distance between Anchor1 and Tag is {0} mm", anchor1TagDistance);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part distacne between Anchor1 and Tag");
            }

            if (double.TryParse(messageParts[4], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out anchor2TagDistance))
            {
                Console.WriteLine("Distance between Anchor2 and Tag is {0} mm", anchor2TagDistance);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part distacne between Anchor2 and Tag");
            }

            if (double.TryParse(messageParts[5], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out anchor3TagDistance))
            {
                Console.WriteLine("Distance between Anchor3 and Tag is {0} mm", anchor3TagDistance);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part distacne between Anchor3 and Tag");
            }

            if (int.TryParse(messageParts[6], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out ALLanchorTagDistances))
            {
                Console.WriteLine("The number of all distances the tag has received: {0}", ALLanchorTagDistances);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part all received distances");
            }

            if (double.TryParse(messageParts[7], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out SerialNumberATDistances))
            {
                Console.WriteLine("The serial number of the last received distance information is {0}", SerialNumberATDistances);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part serial number of the last distance information");
            }

            if (double.TryParse(messageParts[8], System.Globalization.NumberStyles.HexNumber, new System.Globalization.CultureInfo("en-US"), out TimeATDistance))
            {
                Console.WriteLine("Time of the last received distance is {0}", TimeATDistance);
            }
            else
            {
                Console.WriteLine("Error: Cannot convert part Time of the last received distance");
            }

            return new AnchorsDistances(anchor0TagDistance, anchor1TagDistance, anchor2TagDistance);
        }
    }
}
