using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Data.Repository
{
    public class AccountingConfigurationEntityRepository : OticasBaseRepository<AccountingConfigurationDetail>, IAccountingConfigurationEntityRepository
    {
        public AccountingConfigurationEntityRepository(OticasContext context) : base(context)
        {
        }

        public IEnumerable<AccountingConfigurationEntityDto> GetToAccountingConfigurationAsync(AccountingConfigurationTypesDto model)
        {
            return GetToAccountingConfigurationByTableName(model.Table);
        }

        public IEnumerable<AccountingConfigurationEntityDto> GetToAccountingConfigurationByTableName(string tableName)
        {
            switch (tableName)
            {
                case "tbArtigos":
                case "Artigos":
                    return _dbContext.Product.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Code, EntityDescription = e.Description, HasGoodsCostInPurchase = false });

                case "tbArmazens":
                case "Armazens":
                    return _dbContext.Warehouse.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Codigo, EntityDescription = e.Descricao, HasGoodsCostInPurchase = false });

                case "tbClientes":
                case "Clientes":
                    return _dbContext.Customer.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Codigo, EntityDescription = e.Nome, HasGoodsCostInPurchase = false });

                case "tbEntidades":
                case "Entidades":
                    return _dbContext.Entity.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Codigo, EntityDescription = e.Descricao, HasGoodsCostInPurchase = false });

                case "tbFormasPagamento":
                case "FormasPagamento":
                    return _dbContext.PaymentType.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Codigo, EntityDescription = e.Descricao, HasGoodsCostInPurchase = false });

                case "tbFornecedores":
                case "Fornecedores":
                    return _dbContext.Provider.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Codigo, EntityDescription = e.Nome, HasGoodsCostInPurchase = false });

                case "tbLojas":
                case "Lojas":
                    return _dbContext.Store.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Codigo, EntityDescription = e.Descricao, HasGoodsCostInPurchase = false });

                case "tbPaises":
                case "Paises":
                    return _dbContext.Country.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Acronym.Sigla, EntityDescription = e.Description, HasGoodsCostInPurchase = false });

                case "tbIva":
                case "TaxasIva":
                    return _dbContext.Vat.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Code, EntityDescription = e.Description, HasGoodsCostInPurchase = false });

                case "tbTiposArtigos":
                case "TiposArtigo":
                    return _dbContext.ProductType.Select(e => new AccountingConfigurationEntityDto { EntityId = e.Id, EntityCode = e.Codigo, EntityDescription = e.Descricao, HasGoodsCostInPurchase = true });
                default:
                    return null;
            }
        }

        public IEnumerable<AccountingConfigurationDetail> GetAccountingConfigurationEntities(AccountingExportFilterDto filter)
            => EntitySet.Include(x => x.AccountingConfiguration)
            .Where(x => x.AccountingConfiguration.Year == filter.EndDate.Value.Year.ToString()) 
            .Where(x => x.AccountingConfiguration.ModuleDescription.ToLower() == "tabelas").ToList();
    }
}