using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbLentesOftalmicas
    {
        public TbLentesOftalmicas()
        {
            TbLentesOftalmicasSuplementos = new HashSet<TbLentesOftalmicasSuplementos>();
        }

        public long Id { get; set; }
        public long Idartigo { get; set; }
        public long? Idmodelo { get; set; }
        public long? IdtratamentoLente { get; set; }
        public long? IdcorLente { get; set; }
        public string Diametro { get; set; }
        public double? PotenciaEsferica { get; set; }
        public double? PotenciaCilindrica { get; set; }
        public double? PotenciaPrismatica { get; set; }
        public double? Adicao { get; set; }
        public string CodigosSuplementos { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
        public TbCoresLentes IdcorLenteNavigation { get; set; }
        public TbModelos IdmodeloNavigation { get; set; }
        public TbTratamentosLentes IdtratamentoLenteNavigation { get; set; }
        public ICollection<TbLentesOftalmicasSuplementos> TbLentesOftalmicasSuplementos { get; set; }
    }
}
