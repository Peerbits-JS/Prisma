using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Repository
{
    public class DocumentTypeRepository : OticasBaseRepository<TbTiposDocumento>, IDocumentTypeRepository
    {
        public DocumentTypeRepository(OticasContext context)
              : base(context)
        {
        }

        public async Task<IEnumerable<TbTiposDocumento>> GetTypesByModule(AccountingConfigurationModule filter)
        {
            return await EntitySet.Where(x => x.Idmodulo == filter.Id).ToListAsync();
        }

        public IEnumerable<TbTiposDocumento> GetTypesByModulesIds(long [] modulesIds, Expression<Func<TbTiposDocumento, bool>> expression = null)
        {
            if (expression is null) expression = x => true;

            return EntitySet.
                Where(entity => modulesIds != null ? modulesIds.Contains(entity.Idmodulo) : true).
                Where(expression.Compile())
                .AsEnumerable();
        }
    }
}