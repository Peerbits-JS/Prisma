using F3M.Dashboard.API.Data.Entities.Base;
using System;

namespace F3M.Dashboard.API.Data.Entities.Prisma
{
    public class tbLojas  :EntityBase
    {
        #region "ctor"
        public tbLojas()
        {

        }
        #endregion

        #region "properties"
        public long IDEmpresa { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long IDLojaSede { get; set; }
        public string DescricaoLojaSede { get; set; }
        public bool SedeGrupo { get; set; }

        public string EnderecoIP { get; set; }
        public string Cor { get; set; }
        public DateTime? Abertura { get; set; }
        public DateTime? Fecho { get; set; }
        #endregion
    }
}
