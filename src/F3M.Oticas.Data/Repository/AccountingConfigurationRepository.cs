using F3M.Oticas.Component.Models;
using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Repository
{
    public class AccountingConfigurationRepository : OticasBaseRepository<AccountingConfiguration>, IAccountingConfigurationRepository
    {
        public AccountingConfigurationRepository(OticasContext context)
            : base(context)
        {
        }

        public override async Task<AccountingConfiguration> CreateAsync(AccountingConfiguration entity)
        {
            try
            {
                await EntitySet.AddAsync(entity);
                return entity;
            }
            catch (Exception ex)
            {
                throw new Exception($"Erro ao criar {typeof(AccountingConfiguration).Name}", ex);
            }
        }
        public override async Task<AccountingConfiguration> FindAsync(long id)
            => await EntitySet.Include(x => x.Lines).FirstAsync(x => x.Id == id);

        public async Task<string> GetMinYear()
            => await EntitySet.MinAsync(x => x.Year);

        public async Task<string> GetMaxYear()
            => await EntitySet.MaxAsync(x => x.Year);

        public async Task<List<KeyValueModel>> GetYears()
        {

            var minYear = await EntitySet.MinAsync(x => x.Year);
            var maxYear = await EntitySet.MaxAsync(x => x.Year);
            var resultado = new List<KeyValueModel>();

            if (minYear is null)
            {
                resultado.Add(new KeyValueModel { ID = DateTime.Now.Year - 1, Description = (DateTime.Now.Year - 1).ToString() });
                resultado.Add(new KeyValueModel { ID = DateTime.Now.Year, Description = DateTime.Now.Year.ToString() });
                resultado.Add(new KeyValueModel { ID = DateTime.Now.Year + 1, Description = (DateTime.Now.Year + 1).ToString() });

                return resultado;
            }


            var index = int.Parse(minYear);

            for (int i = index - 1; i <= (DateTime.Now.Year + 1); i++)
            {
                resultado.Add(new KeyValueModel { ID = i, Description = i.ToString() });
            }

            return resultado;
        }

        public string GetAlternative(AccountingConfiguration model)
        {
            var maxAlternative = EntitySet.Where(x => x.Year == model.Year && x.ModuleCode == model.ModuleCode && x.TypeCode == model.TypeCode).Max(x => x.AlternativeCode);

            return maxAlternative != null ? (int.Parse(maxAlternative) + 1).ToString() : "1";
        }

        public bool AlreadyExists(AccountingConfiguration model)
            => EntitySet.Any(x => x.Year == model.Year && x.TypeCode == model.TypeCode);

        public async Task<List<AccountingConfiguration>> GetToPresetAlternativeAsync(AccountingConfiguration model)
            => await EntitySet.Where(x => x.Year == model.Year && x.TypeCode == model.TypeCode && x.Id != model.Id).ToListAsync();

        public List<AccountingConfiguration> GetConfigurations(AccountingExportFilterDto filter)
        {
            bool funcWhereModulesCode(AccountingConfiguration accountingConfiguration) {
                if (filter.ModulesCode == null) {
                    return true;
                }
                return filter.ModulesCode.Contains(accountingConfiguration.ModuleCode);
            }

            bool funcWhereDocumentTypes(AccountingConfiguration accountingConfiguration)
            {
                if (filter.DocumentTypesCode == null)
                {
                    return true;
                }
                return filter.DocumentTypesCode.Contains(accountingConfiguration.TypeCode);
            }

            return  EntitySet
                .Include(entity => entity.Lines)
                 .Where(entity => entity.Year == filter.EndDate.Value.Year.ToString())
                 .Where(funcWhereModulesCode)
                 .Where(funcWhereDocumentTypes)
                 .ToList();
        }
    }
}