using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbMapasVistas
    {
        public TbMapasVistas()
        {
            TbTiposConsultasIdmapaVista1Navigation = new HashSet<TbTiposConsultas>();
            TbTiposConsultasIdmapaVista2Navigation = new HashSet<TbTiposConsultas>();
            TbTiposDocumentoSeries = new HashSet<TbTiposDocumentoSeries>();
        }

        public long Id { get; set; }
        public int? Ordem { get; set; }
        public string Entidade { get; set; }
        public string Descricao { get; set; }
        public string NomeMapa { get; set; }
        public string Caminho { get; set; }
        public bool? Certificado { get; set; }
        public long? Idmodulo { get; set; }
        public long? IdsistemaTipoDoc { get; set; }
        public long? IdsistemaTipoDocFiscal { get; set; }
        public long? Idloja { get; set; }
        public string Sqlquery { get; set; }
        public string Tabela { get; set; }
        public bool Geral { get; set; }
        public bool Listagem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public string MapaXml { get; set; }
        public byte[] MapaBin { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public TbSistemaModulos IdmoduloNavigation { get; set; }
        public TbSistemaTiposDocumentoFiscal IdsistemaTipoDocFiscalNavigation { get; set; }
        public TbSistemaTiposDocumento IdsistemaTipoDocNavigation { get; set; }
        public ICollection<TbTiposConsultas> TbTiposConsultasIdmapaVista1Navigation { get; set; }
        public ICollection<TbTiposConsultas> TbTiposConsultasIdmapaVista2Navigation { get; set; }
        public ICollection<TbTiposDocumentoSeries> TbTiposDocumentoSeries { get; set; }
    }
}
