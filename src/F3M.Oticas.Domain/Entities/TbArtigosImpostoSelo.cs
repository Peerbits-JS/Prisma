using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosImpostoSelo
    {
        public long Id { get; set; }
        public double? Percentagem { get; set; }
        public double? Valor { get; set; }
        public double? LimiteMinimo { get; set; }
        public double? LimiteMaximo { get; set; }
    }
}
