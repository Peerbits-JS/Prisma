using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbClientesAnexos
    {
        public long Id { get; set; }
        public long Idcliente { get; set; }
        public long? IdtipoAnexo { get; set; }
        public string Descricao { get; set; }
        public string FicheiroOriginal { get; set; }
        public string Ficheiro { get; set; }
        public string FicheiroThumbnail { get; set; }
        public string Caminho { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbClientes IdclienteNavigation { get; set; }
        public TbSistemaTiposAnexos IdtipoAnexoNavigation { get; set; }
    }
}
