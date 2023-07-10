using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO.Ports;
using System.Linq;
using System.Management;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Threading;

namespace SerialCommTrek1000
{
    class CommTREK1000
    {
        SerialPort port;            //serial port object
        ObservableCollection<AvailableCOMPort> availableCOMPorts;
        public event EventHandler<SerialDataReceived> SerialDataReceived;


        public ObservableCollection<AvailableCOMPort> AvailableCOMPorts { get => availableCOMPorts; }
        public bool IsOpen
        {
            get
            {
                return port.IsOpen;
            }
        }

        //initialize communication with TREK1000
        public CommTREK1000()
        {
            port = new SerialPort();
            availableCOMPorts = new ObservableCollection<AvailableCOMPort>();

            port.DataReceived += Port_DataReceived;


            RefreshAvailableCOMPorts();

        }

        private void Port_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            int bytesAvailable = port.BytesToRead;

            if (bytesAvailable > 0)
            {
                byte[] rxData = new byte[bytesAvailable];
                port.Read(rxData, 0, bytesAvailable);
                OnDataReceived(rxData);
            }
        }

        void OnDataReceived(byte[] rxData)
        {
            SerialDataReceived?.Invoke(null, new SerialDataReceived(rxData));
        }

        public int RefreshAvailableCOMPorts()
        {
            ManagementClass processClass = new ManagementClass("Win32_PnPEntity");
            ManagementObjectCollection portsManagement = processClass.GetInstances();

            string[] ports = SerialPort.GetPortNames();
            Dispatcher.CurrentDispatcher.BeginInvoke((Action)delegate
            {
                availableCOMPorts.Clear();
            });

            for (int i = 0; i < ports.Count(); i++)
            {
                var availableComPort = new AvailableCOMPort(ports[i], GetFullDescription(portsManagement, ports[i]));
                Dispatcher.CurrentDispatcher.BeginInvoke((Action)delegate
                {
                    availableCOMPorts.Add(availableComPort);
                });
            }
            return ports.Count();
        }

        public Task<int> RefreshAvailableCOMPortsAsync()
        {
            return Task.Run<int>(() =>
            {
                return RefreshAvailableCOMPorts();
            });

        }


        string GetFullDescription(ManagementObjectCollection Ports, string COMPortName)
        {
            foreach (ManagementObject property in Ports)
            {
                if (property.GetPropertyValue("Name") != null)
                    if (property.GetPropertyValue("Name").ToString().Contains(COMPortName))
                    {
                        return property.GetPropertyValue("Name").ToString();
                    }
            }
            return "";
        }


        public bool Close()
        {
            if (port.IsOpen)
            {

                port.Close();
                return true;
            }
            return false;
        }

        public bool Open(int index, int speed)
        {
            if (index < availableCOMPorts.Count() && index >= 0)
            {
                return Open(availableCOMPorts[index].COMPort, speed);
            }
            return false;
        }

        public bool Open(string comPort, int speed)
        {
            if (port.IsOpen)
            {
                port.Close();
            }

            port.PortName = comPort;
            port.BaudRate = speed;
            port.DataBits = 8;
            port.Parity = Parity.None;
            port.StopBits = StopBits.One;
            try
            {
                port.Open();
            }
            catch (Exception ex)
            {
                return false;
            }
            return true;
        }

        public void Send(string str)
        {
            if (port.IsOpen)
            {
                port.Write(str);
            }
        }
        public void Send(byte[] data)
        {
            if (port.IsOpen)
            {
                port.Write(data, 0, data.Length);
            }
        }

    }
}
