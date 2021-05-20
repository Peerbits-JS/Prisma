using F3M.Core.Domain.Entity;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class Country : EntityBase
    {
        public Country()
        {
            Warehouse = new HashSet<TbArmazens>();
            BankAddresses = new HashSet<TbBancosMoradas>();
            Customers = new HashSet<TbClientes>();
            CustomerAddresses = new HashSet<TbClientesMoradas>();
            BankAccountAddresses = new HashSet<TbContasBancariasMoradas>();
            LoadPurchaseDocuments = new HashSet<PurchaseDocument>();
            DownloadPurchaseDocuments = new HashSet<PurchaseDocument>();
            FiscalCountryPurchaseDocuments = new HashSet<PurchaseDocument>();
            LoadCountryStockDocuments = new HashSet<StockDocument>();
            DownLoadCountryStockDocuments = new HashSet<StockDocument>();
            FiscalCountryStockDocuments = new HashSet<StockDocument>();
            LoadCountrySalesDocuments = new HashSet<SaleDocument>();
            DownLoadCountrySalesDocuments = new HashSet<SaleDocument>();
            FiscalCountrySalesDocuments = new HashSet<SaleDocument>();
            EntityAddresses = new HashSet<TbEntidadesMoradas>();
            Providers = new HashSet<TbFornecedores>();
            ProviderAddresses = new HashSet<TbFornecedoresMoradas>();
            MedicalTechinicianAddresses = new HashSet<TbMedicosTecnicosMoradas>();
            LoadSalesPayments = new HashSet<ProviderPaymentDocument>();
            DownLoadSalesPayments = new HashSet<ProviderPaymentDocument>();
            FiscalCountrySalesPayments = new HashSet<ProviderPaymentDocument>();
            CompanyParameters = new HashSet<TbParametrosEmpresa>();
            ReceiptDocument = new HashSet<ReceiptDocument>();
        }

        public string Description { get; set; }

        public string AccountingVariable { get; set; }

        public long AcronymId { get; set; }

        public TbSistemaSiglasPaises Acronym { get; set; }
        public ICollection<TbArmazens> Warehouse { get; set; }
        public ICollection<TbBancosMoradas> BankAddresses { get; set; }
        public ICollection<TbClientes> Customers { get; set; }
        public ICollection<TbClientesMoradas> CustomerAddresses { get; set; }
        public ICollection<TbContasBancariasMoradas> BankAccountAddresses { get; set; }
        public ICollection<PurchaseDocument> LoadPurchaseDocuments { get; set; }
        public ICollection<PurchaseDocument> DownloadPurchaseDocuments { get; set; }
        public ICollection<PurchaseDocument> FiscalCountryPurchaseDocuments { get; set; }
        public ICollection<StockDocument> LoadCountryStockDocuments { get; set; }
        public ICollection<StockDocument> DownLoadCountryStockDocuments { get; set; }
        public ICollection<StockDocument> FiscalCountryStockDocuments { get; set; }
        public ICollection<SaleDocument> LoadCountrySalesDocuments { get; set; }
        public ICollection<SaleDocument> DownLoadCountrySalesDocuments { get; set; }
        public ICollection<SaleDocument> FiscalCountrySalesDocuments { get; set; }
        public ICollection<TbEntidadesMoradas> EntityAddresses { get; set; }
        public ICollection<TbFornecedores> Providers { get; set; }
        public ICollection<TbFornecedoresMoradas> ProviderAddresses { get; set; }
        public ICollection<TbMedicosTecnicosMoradas> MedicalTechinicianAddresses { get; set; }
        public ICollection<ProviderPaymentDocument> LoadSalesPayments { get; set; }
        public ICollection<ProviderPaymentDocument> DownLoadSalesPayments { get; set; }
        public ICollection<ProviderPaymentDocument> FiscalCountrySalesPayments { get; set; }
        public ICollection<TbParametrosEmpresa> CompanyParameters { get; set; }
        public ICollection<ReceiptDocument> ReceiptDocument { get; set; }
    }
}
