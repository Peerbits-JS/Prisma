using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbPrecosLentes
    {
        public long Id { get; set; }
        public long Idmodelo { get; set; }
        public long? IdtratamentoLente { get; set; }
        public bool? GamaStock { get; set; }
        public string DiamDe { get; set; }
        public string DiamAte { get; set; }
        public double? PotEsfDe { get; set; }
        public double? PotEsfAte { get; set; }
        public double? PotCilDe { get; set; }
        public double? PotCilAte { get; set; }
        public string Raio { get; set; }
        public double? PrecoVenda { get; set; }
        public double? PrecoCusto { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbModelos IdmodeloNavigation { get; set; }
        public TbTratamentosLentes IdtratamentoLenteNavigation { get; set; }
    }
}
