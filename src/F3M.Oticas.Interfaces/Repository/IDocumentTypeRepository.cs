using F3M.Oticas.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IDocumentTypeRepository
    {
        Task<IEnumerable<TbTiposDocumento>> GetTypesByModule(AccountingConfigurationModule filter);
        IEnumerable<TbTiposDocumento> GetTypesByModulesIds(long[] modulesIds, Expression<Func<TbTiposDocumento, bool>> expression = null);
    }
}