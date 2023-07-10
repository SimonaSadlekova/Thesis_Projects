using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SerialCommTrek1000
{
    public class SerialDataReceived : EventArgs      
    {
        byte[] data;

        public byte[] Data { get => data; }

        public SerialDataReceived(byte[] data)
        {
            this.data = data;
        }

        public void Trek1000_DataReceived(AnchorsDistances anchorsDistances)
        {
            TextBox textBoxOutput = new TextBox("text");
            textBoxOutput.Text += $"{DateTime.Now:dd:mm:ss:ffffff}: Distance between Anchor0 and Tag: {anchorsDistances.Anchor0TagDistance} mm,  Distance between Anchor1 and Tag: {anchorsDistances.Anchor1TagDistance} mm,  Distance between Anchor2 and Tag: {anchorsDistances.Anchor2TagDistance} mm,  Distance between Anchor3 and Tag: {anchorsDistances.Anchor3TagDistance} mm" + Environment.NewLine;
        }
    }
}
