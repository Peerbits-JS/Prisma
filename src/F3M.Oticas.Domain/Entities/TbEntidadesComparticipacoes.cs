using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbEntidadesComparticipacoes
    {
        public long Id { get; set; }
        public long Identidade { get; set; }
        public long IdtipoArtigo { get; set; }
        public long? IdtipoLente { get; set; }
        public double? PotenciaEsfericaDe { get; set; }
        public double? PotenciaEsfericaAte { get; set; }
        public double? PotenciaCilindricaDe { get; set; }
        public double? PotenciaCilindricaAte { get; set; }
        public double? PotenciaPrismaticaDe { get; set; }
        public double? PotenciaPrismaticaAte { get; set; }
        public double? ValorMaximo { get; set; }
        public double? Percentagem { get; set; }
        public double? Quantidade { get; set; }
        public double? Duracao { get; set; }
        public int Ordem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbEntidades IdentidadeNavigation { get; set; }
        public TbTiposArtigos IdtipoArtigoNavigation { get; set; }
        public TbSistemaTiposLentes IdtipoLenteNavigation { get; set; }
    }
}
