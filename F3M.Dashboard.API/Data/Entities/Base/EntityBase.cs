using System;

namespace F3M.Dashboard.API.Data.Entities.Base
{
    public class EntityBase
    {
        public long ID { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3MMarcador { get; set; }
    }
}
