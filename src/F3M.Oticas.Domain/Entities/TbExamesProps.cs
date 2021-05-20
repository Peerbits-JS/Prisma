using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbExamesProps
    {
        public TbExamesProps()
        {
            InverseIdpaiNavigation = new HashSet<TbExamesProps>();
        }

        public long Id { get; set; }
        public long Idexame { get; set; }
        public long? Idpai { get; set; }
        public string TipoComponente { get; set; }
        public int? Ordem { get; set; }
        public string Label { get; set; }
        public int? StartRow { get; set; }
        public int? EndRow { get; set; }
        public int? StartCol { get; set; }
        public int? EndCol { get; set; }
        public string AtributosHtml { get; set; }
        public string ModelPropertyName { get; set; }
        public string ModelPropertyType { get; set; }
        public bool? Eobrigatorio { get; set; }
        public bool? Eeditavel { get; set; }
        public string ValorPorDefeito { get; set; }
        public string Controlador { get; set; }
        public string ControladorAcaoExtra { get; set; }
        public string TabelaBd { get; set; }
        public string CampoTexto { get; set; }
        public string FuncaoJsenviaParametros { get; set; }
        public string FuncaoJschange { get; set; }
        public string ValorId { get; set; }
        public string ValorDescricao { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public string ViewClassesCss { get; set; }
        public int? NumCasasDecimais { get; set; }
        public bool? EeditavelEdicao { get; set; }
        public string Idelemento { get; set; }
        public string FuncaoJsonClick { get; set; }
        public bool? DesenhaBotaoLimpar { get; set; }
        public bool? Ecabecalho { get; set; }
        public double? ValorMinimo { get; set; }
        public double? ValorMaximo { get; set; }
        public double? Steps { get; set; }
        public bool? Evisivel { get; set; }
        public string ComponentTag { get; set; }

        public TbExames IdexameNavigation { get; set; }
        public TbExamesProps IdpaiNavigation { get; set; }
        public ICollection<TbExamesProps> InverseIdpaiNavigation { get; set; }
    }
}
