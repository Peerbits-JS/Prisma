using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposDocumentoColunasAutomaticas
    {
        public TbSistemaTiposDocumentoColunasAutomaticas()
        {
            InverseIdpaiNavigation = new HashSet<TbSistemaTiposDocumentoColunasAutomaticas>();
        }

        public long Id { get; set; }
        public long IdsistemaTipoDocumento { get; set; }
        public string Coluna { get; set; }
        public string ChaveColunaTraducao { get; set; }
        public long? Idpai { get; set; }
        public string ControladorExtra { get; set; }
        public string Controlador { get; set; }
        public string CampoTexto { get; set; }
        public string EnviaParametros { get; set; }
        public string Validador { get; set; }
        public long? IdtipoEditor { get; set; }
        public double? Width { get; set; }
        public double? Maximo { get; set; }
        public double? Minimo { get; set; }
        public double? TamMaximo { get; set; }
        public byte? CasasDecimais { get; set; }
        public bool Editavel { get; set; }
        public bool Obrigatoria { get; set; }
        public bool NaoPermiteNegativos { get; set; }
        public bool ElementoUnico { get; set; }
        public bool Visivel { get; set; }
        public string CamposPreencher { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaTiposDocumentoColunasAutomaticas IdpaiNavigation { get; set; }
        public TbSistemaTiposDocumento IdsistemaTipoDocumentoNavigation { get; set; }
        public TbTiposDados IdtipoEditorNavigation { get; set; }
        public ICollection<TbSistemaTiposDocumentoColunasAutomaticas> InverseIdpaiNavigation { get; set; }
    }
}
