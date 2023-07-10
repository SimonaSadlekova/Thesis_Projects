using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SerialCommTrek1000
{
    class AvailableCOMPort : INotifyPropertyChanged
    {
        private string comPort;
        private string description;

        //property containing port number, e.g. COM4
        public string COMPort
        {
            get { return comPort; }
            set
            {
                comPort = value;
                NotifyPropertyChanged("COMPort");
            }
        }

        public string Description
        {
            get { return description; }
            set
            {
                description = value;
                NotifyPropertyChanged("Description");
            }
        }

        public AvailableCOMPort(string comPort, string description)
        {
            this.comPort = comPort;
            this.description = description;
        }

        public event PropertyChangedEventHandler PropertyChanged;       //event which calls every subscribed method
        private void NotifyPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
