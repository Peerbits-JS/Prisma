using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbParametrizacaoConsentimentosCamposEntidade
    {
        public long Id { get; set; }
        public int IdsistemaFuncionalidadesConsentimento { get; set; }
        public long? IdparametrizacaoConsentimento { get; set; }
        public string Tabela { get; set; }
        public string NomeCampoChave { get; set; }
        public string NomeCampo { get; set; }
        public string DescricaoCampo { get; set; }
        public string TipoCampo { get; set; }
        public string TamanhoMaximoCampo { get; set; }
        public string ExpressaoLista { get; set; }
        public bool ForeignKey { get; set; }
        public string TabelaLeftJoin { get; set; }
        public string CampoLeftJoin { get; set; }
        public string ExpressaoLeftJoin { get; set; }
        public string AliasLeftJoin { get; set; }
        public long NumeroLinhaPosicionado { get; set; }
        public long OrdemPosicionado { get; set; }
        public double? PercentagemOcupaLinha { get; set; }
        public string CondicaoVisibilidade { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbParametrizacaoConsentimentos IdparametrizacaoConsentimentoNavigation { get; set; }
        public TbSistemaFuncionalidadesConsentimento IdsistemaFuncionalidadesConsentimentoNavigation { get; set; }
    }
}
