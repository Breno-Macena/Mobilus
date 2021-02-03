using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Covid19.Model
{
    public class Consulta
    {
        public int Id { get; set; }
        public int MaxMortes { get; set; }
        public DateTime DataConsulta { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
