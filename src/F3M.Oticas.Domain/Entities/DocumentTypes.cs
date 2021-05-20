using F3M.Core.Domain.Entity;
using System;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Entities
{
    public class DocumentTypes : EntityBase
    {
        public DocumentTypes()
        {
        }

        public string Code { get; set; }
        public string Description { get; set; }
        public long ModuleId { get; set; }
        public TbSistemaModulos Module { get; set; }
        public long? FiscalDocumentTypesId { get; set; }
        public TbSistemaTiposDocumentoFiscal FiscalDocumentTypes { get; set; }
    }
}
