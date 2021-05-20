using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbParametrosContexto
    {
        public TbParametrosContexto()
        {
            InverseIdpaiNavigation = new HashSet<TbParametrosContexto>();
            TbParametrosCamposContexto = new HashSet<TbParametrosCamposContexto>();
        }

        public long Id { get; set; }
        public long? Idpai { get; set; }
        public string Codigo { get; set; }
        public string CodigoPai { get; set; }
        public string Descricao { get; set; }
        public string Accao { get; set; }
        public bool? MostraConteudo { get; set; }
        public long? IdparametrosEmpresa { get; set; }
        public long? Idloja { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public TbParametrosContexto IdpaiNavigation { get; set; }
        public TbParametrosEmpresa IdparametrosEmpresaNavigation { get; set; }
        public ICollection<TbParametrosContexto> InverseIdpaiNavigation { get; set; }
        public ICollection<TbParametrosCamposContexto> TbParametrosCamposContexto { get; set; }
    }
}
