using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbParametrosLoja
    {
        public long Id { get; set; }
        public long? IdmoedaDefeito { get; set; }
        public string Morada { get; set; }
        public string Foto { get; set; }
        public string FotoCaminho { get; set; }
        public string DesignacaoComercial { get; set; }
        public string CodigoPostal { get; set; }
        public string Localidade { get; set; }
        public string Concelho { get; set; }
        public string Distrito { get; set; }
        public long? Idpais { get; set; }
        public string Telefone { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public string WebSite { get; set; }
        public string Nif { get; set; }
        public string ConservatoriaRegistoComercial { get; set; }
        public string NumeroRegistoComercial { get; set; }
        public string CapitalSocial { get; set; }
        public byte? CasasDecimaisPercentagem { get; set; }
        public long? Idloja { get; set; }
        public long? IdidiomaBase { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public TbMoedas IdmoedaDefeitoNavigation { get; set; }
        public TbSistemaSiglasPaises IdpaisNavigation { get; set; }
    }
}
