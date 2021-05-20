using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbDocumentosVendasLinhasGraduacoes
    {
        public long Id { get; set; }
        public long? IdtipoOlho { get; set; }
        public long? IdtipoGraduacao { get; set; }
        public double? PotenciaEsferica { get; set; }
        public double? PotenciaCilindrica { get; set; }
        public double? PotenciaPrismatica { get; set; }
        public string BasePrismatica { get; set; }
        public double? Adicao { get; set; }
        public int? Eixo { get; set; }
        public string RaioCurvatura { get; set; }
        public string DetalheRaio { get; set; }
        public double? Dnp { get; set; }
        public double? Altura { get; set; }
        public string AcuidadeVisual { get; set; }
        public string AnguloPantoscopico { get; set; }
        public string DistanciaVertex { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long? Idservico { get; set; }

        public TbServicos IdservicoNavigation { get; set; }
        public TbSistemaTiposGraduacoes IdtipoGraduacaoNavigation { get; set; }
        public TbSistemaTiposOlhos IdtipoOlhoNavigation { get; set; }
    }
}
