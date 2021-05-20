using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class ProviderPaymentDocumentMap : IEntityTypeConfiguration<ProviderPaymentDocument>
    {
        public void Configure(EntityTypeBuilder<ProviderPaymentDocument> entity)
        {
            entity.ToTable("tbPagamentosCompras");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Signature).HasColumnName("Assinatura").HasMaxLength(255);

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.ATCode).HasColumnName("CodigoAT").HasMaxLength(200);

            entity.Property(e => e.ATInternalCode).HasColumnName("CodigoATInterno").HasMaxLength(200);

            entity.Property(e => e.DocumentOriginCode).HasColumnName("CodigoDocOrigem").HasMaxLength(255);

            entity.Property(e => e.EntityCode).HasColumnName("CodigoEntidade").HasMaxLength(20);

            entity.Property(e => e.CurrencyCode).HasColumnName("CodigoMoeda").HasMaxLength(20);

            entity.Property(e => e.PrintLoadZipCode).HasColumnName("CodigoPostalCarga").HasMaxLength(20);

            entity.Property(e => e.DownloadZipCode).HasColumnName("CodigoPostalDescarga").HasMaxLength(20);

            entity.Property(e => e.PrintFiscalZipCode).HasColumnName("CodigoPostalFiscal").HasMaxLength(10);

            entity.Property(e => e.StoreZipCode).HasColumnName("CodigoPostalLoja").HasMaxLength(8);

            entity.Property(e => e.SystemUnitPricesTypeCode).HasColumnName("CodigoSisTiposDocPU").HasMaxLength(6);

            entity.Property(e => e.TypeStateCode).HasColumnName("CodigoTipoEstado").HasMaxLength(20);

            entity.Property(e => e.PrintLoadCounty).HasColumnName("ConcelhoCarga").HasMaxLength(255);

            entity.Property(e => e.PrintDownloadCounty).HasColumnName("ConcelhoDescarga").HasMaxLength(255);

            entity.Property(e => e.FiscalTaxPayer).HasColumnName("ContribuinteFiscal").HasMaxLength(25);

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.SignatureDate).HasColumnName("DataAssinatura").HasColumnType("datetime");

            entity.Property(e => e.LoadDate).HasColumnName("DataCarga").HasColumnType("datetime");

            entity.Property(e => e.InternalControlDate).HasColumnName("DataControloInterno").HasColumnType("datetime");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DownloadDate).HasColumnName("DataDescarga").HasColumnType("datetime");

            entity.Property(e => e.DocumentDate).HasColumnName("DataDocumento").HasColumnType("datetime");

            entity.Property(e => e.StateTime).HasColumnName("DataHoraEstado").HasColumnType("datetime");

            entity.Property(e => e.LastPrintDate).HasColumnName("DataUltimaImpressao").HasColumnType("datetime");

            entity.Property(e => e.DueDate).HasColumnName("DataVencimento").HasColumnType("datetime");

            entity.Property(e => e.FiscalZipCodeDescription).HasColumnName("DescricaoCodigoPostalFiscal").HasMaxLength(50);

            entity.Property(e => e.FiscalCountyDescription).HasColumnName("DescricaoConcelhoFiscal").HasMaxLength(50);

            entity.Property(e => e.FiscalDistrictDescription).HasColumnName("DescricaoDistritoFiscal").HasMaxLength(50);

            entity.Property(e => e.StoreBusinessName).HasColumnName("DesignacaoComercialLoja").HasMaxLength(160);

            entity.Property(e => e.PrintLoadDistrict).HasColumnName("DistritoCarga").HasMaxLength(255);

            entity.Property(e => e.PrintDownloadDistrict).HasColumnName("DistritoDescarga").HasMaxLength(255);

            entity.Property(e => e.Document).HasColumnName("Documento").HasMaxLength(50);

            entity.Property(e => e.PrintFiscalSpaceCharges).HasColumnName("EspacoFiscalPortes").HasMaxLength(50);

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.Property(e => e.LoadTime).HasColumnName("HoraCarga").HasColumnType("datetime");

            entity.Property(e => e.DownloadTime).HasColumnName("HoraDescarga").HasColumnType("datetime");

            entity.Property(e => e.LoadZipCodeId).HasColumnName("IDCodigoPostalCarga");

            entity.Property(e => e.DownloadZipCodeId).HasColumnName("IDCodigoPostalDescarga");

            entity.Property(e => e.ReceiverZipCodeId).HasColumnName("IDCodigoPostalDestinatario");

            entity.Property(e => e.FiscalZipCodeId).HasColumnName("IDCodigoPostalFiscal");

            entity.Property(e => e.LoadCountyId).HasColumnName("IDConcelhoCarga");

            entity.Property(e => e.DownloadCountyId).HasColumnName("IDConcelhoDescarga");

            entity.Property(e => e.ReceiverCountyId).HasColumnName("IDConcelhoDestinatario");

            entity.Property(e => e.FiscalCountyId).HasColumnName("IDConcelhoFiscal");

            entity.Property(e => e.PaymentTypeId).HasColumnName("IDCondicaoPagamento");

            entity.Property(e => e.LoadDistrictId).HasColumnName("IDDistritoCarga");

            entity.Property(e => e.DownloadDistrictId).HasColumnName("IDDistritoDescarga");

            entity.Property(e => e.ReceiverDistrictId).HasColumnName("IDDistritoDestinatario");

            entity.Property(e => e.FiscalDistrictId).HasColumnName("IDDistritoFiscal");

            entity.Property(e => e.EntityId).HasColumnName("IDEntidade");

            entity.Property(e => e.FiscalSpaceId).HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.FiscalSpaceChargesId).HasColumnName("IDEspacoFiscalPortes");

            entity.Property(e => e.StateId).HasColumnName("IDEstado");

            entity.Property(e => e.ShippingWayId).HasColumnName("IDFormaExpedicao");

            entity.Property(e => e.OperationCodeId).HasColumnName("IDLocalOperacao");

            entity.Property(e => e.StoreId).HasColumnName("IDLoja");

            entity.Property(e => e.StoreLastPrintId).HasColumnName("IDLojaUltimaImpressao");

            entity.Property(e => e.CurrencyId).HasColumnName("IDMoeda");

            entity.Property(e => e.LoadCountryId).HasColumnName("IDPaisCarga");

            entity.Property(e => e.DownloadCountryId).HasColumnName("IDPaisDescarga");

            entity.Property(e => e.FiscalCountryId).HasColumnName("IDPaisFiscal");

            entity.Property(e => e.VatSchemeId).HasColumnName("IDRegimeIva");

            entity.Property(e => e.VatSchemeChargesId).HasColumnName("IDRegimeIvaPortes");

            entity.Property(e => e.SystemUnitPricesTypeId).HasColumnName("IDSisTiposDocPU");

            entity.Property(e => e.VatRateChargesId).HasColumnName("IDTaxaIvaPortes");

            entity.Property(e => e.DocumentTypeId).HasColumnName("IDTipoDocumento");

            entity.Property(e => e.EntityTypeId).HasColumnName("IDTipoEntidade");

            entity.Property(e => e.DocumentTypeSeriesId).HasColumnName("IDTiposDocumentoSeries");

            entity.Property(e => e.LoadPlace).HasColumnName("LocalCarga").HasMaxLength(50);

            entity.Property(e => e.DownloadPlace).HasColumnName("LocalDescarga").HasMaxLength(50);

            entity.Property(e => e.StoreCounty).HasColumnName("LocalidadeLoja").HasMaxLength(50);

            entity.Property(e => e.Registry).HasColumnName("Matricula").HasMaxLength(255);

            entity.Property(e => e.ATDocumentMessage).HasColumnName("MensagemDocAT").HasMaxLength(1000);

            entity.Property(e => e.LoadAddress).HasColumnName("MoradaCarga").HasMaxLength(100);

            entity.Property(e => e.DownloadAdrress).HasColumnName("MoradaDescarga").HasMaxLength(100);

            entity.Property(e => e.ReceiverAddress).HasColumnName("MoradaDestinatario").HasMaxLength(100);

            entity.Property(e => e.FiscalAddress).HasColumnName("MoradaFiscal").HasMaxLength(100);

            entity.Property(e => e.StoreAddress).HasColumnName("MoradaLoja").HasMaxLength(100);

            entity.Property(e => e.ReasonForExemptionFromVat).HasColumnName("MotivoIsencaoIva").HasMaxLength(255);

            entity.Property(e => e.ReasonForExemptionFromCharges).HasColumnName("MotivoIsencaoPortes").HasMaxLength(255);

            entity.Property(e => e.StoreTaxPayer).HasColumnName("NIFLoja").HasMaxLength(9);

            entity.Property(e => e.ReceiverName).HasColumnName("NomeDestinatario").HasMaxLength(100);

            entity.Property(e => e.FiscalName).HasColumnName("NomeFiscal").HasMaxLength(200);

            entity.Property(e => e.ManualDocumentNumber).HasColumnName("NumeroDocManual").HasMaxLength(50);

            entity.Property(e => e.Station).HasColumnName("Posto").HasMaxLength(512);

            entity.Property(e => e.PrintVatSchemeCharges).HasColumnName("RegimeIvaPortes").HasMaxLength(50);

            entity.Property(e => e.ManualDocumentSerie).HasColumnName("SerieDocManual").HasMaxLength(50);

            entity.Property(e => e.StoreAcronym).HasColumnName("SiglaLoja").HasMaxLength(3);

            entity.Property(e => e.LoadCountryAcronym).HasColumnName("SiglaPaisCarga").HasMaxLength(6);

            entity.Property(e => e.DownloadCountryAcronym).HasColumnName("SiglaPaisDescarga").HasMaxLength(6);

            entity.Property(e => e.CountryFiscalAcronym).HasColumnName("SiglaPaisFiscal").HasMaxLength(15);

            entity.Property(e => e.FiscalType).HasColumnName("TipoFiscal").HasMaxLength(20);

            entity.Property(e => e.VatTotal).HasColumnName("TotalIva");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.StateUser).HasColumnName("UtilizadorEstado").HasMaxLength(20);

            entity.Property(e => e.ExternalDocumentNumber).HasColumnName("VossoNumeroDocumento").HasMaxLength(256);

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.Notes).HasColumnName("Observacoes");

            entity.Property(e => e.ChargesValue).HasColumnName("ValorPortes");

            entity.Property(e => e.AddicionalCosts).HasColumnName("CustosAdicionais");

            entity.Property(e => e.ConversionRate).HasColumnName("TaxaConversao");

            entity.Property(e => e.DiscountPercentage).HasColumnName("PercentagemDesconto");

            entity.Property(e => e.DiscountValue).HasColumnName("ValorDesconto");

            entity.Property(e => e.DocumentNumber).HasColumnName("NumeroDocumento").HasMaxLength(50);

            entity.Property(e => e.InternalNumber).HasColumnName("NumeroInterno");

            entity.Property(e => e.IsManualDocument).HasColumnName("DocManual");

            entity.Property(e => e.IsPrinted).HasColumnName("Impresso");

            entity.Property(e => e.IsReplenishmentDocument).HasColumnName("DocReposicao");

            entity.Property(e => e.IsSecondDocumentPath).HasColumnName("SegundaVia");

            entity.Property(e => e.LinesDiscounts).HasColumnName("DescontosLinha");

            entity.Property(e => e.NumberOfLines).HasColumnName("NumeroLinhas");

            entity.Property(e => e.NumberOfPrints).HasColumnName("NumeroImpressoes");

            entity.Property(e => e.PrintVatRateCharges).HasColumnName("TaxaIvaPortes");

            entity.Property(e => e.PrivateKeyVersion).HasColumnName("VersaoChavePrivada");

            entity.Property(e => e.TaxValue).HasColumnName("ValorImposto");

            entity.Property(e => e.TotalCurrencyDocument).HasColumnName("TotalMoedaDocumento");

            entity.Property(e => e.TotalReferenceCurrency).HasColumnName("TotalMoedaReferencia");

            entity.Property(e => e.TotalAllDocuments).HasColumnName("TotalDocumentos");

            entity.Property(e => e.TotalAllDocumentsDiscount).HasColumnName("TotalDescontos");

            entity.Property(e => e.TotalCurrency).HasColumnName("TotalMoeda");

            entity.HasOne(d => d.LoadZipCode)
                .WithMany(p => p.TbPagamentosComprasIdcodigoPostalCargaNavigation)
                .HasForeignKey(d => d.LoadZipCodeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbCodigosPostais_Carga");

            entity.HasOne(d => d.DowloadZipCode)
                .WithMany(p => p.TbPagamentosComprasIdcodigoPostalDescargaNavigation)
                .HasForeignKey(d => d.DownloadZipCodeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbCodigosPostais_Descarga");

            entity.HasOne(d => d.ReceiverZipCode)
                .WithMany(p => p.TbPagamentosComprasIdcodigoPostalDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverZipCodeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbCodigosPostais_Destinatario");

            entity.HasOne(d => d.FiscalZipCode)
                .WithMany(p => p.TbPagamentosComprasIdcodigoPostalFiscalNavigation)
                .HasForeignKey(d => d.FiscalZipCodeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbCodigosPostais_Fiscal");

            entity.HasOne(d => d.LoadCounty)
                .WithMany(p => p.TbPagamentosComprasIdconcelhoCargaNavigation)
                .HasForeignKey(d => d.LoadCountyId)
                .HasConstraintName("FK_tbPagamentosCompras_tbConcelhos_Carga");

            entity.HasOne(d => d.DownloadCounty)
                .WithMany(p => p.TbPagamentosComprasIdconcelhoDescargaNavigation)
                .HasForeignKey(d => d.DownloadCountyId)
                .HasConstraintName("FK_tbPagamentosCompras_tbConcelhos_Descarga");

            entity.HasOne(d => d.ReceiverCounty)
                .WithMany(p => p.TbPagamentosComprasIdconcelhoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverCountyId)
                .HasConstraintName("FK_tbPagamentosCompras_tbConcelhos_Destinatario");

            entity.HasOne(d => d.FiscalCounty)
                .WithMany(p => p.TbPagamentosComprasIdconcelhoFiscalNavigation)
                .HasForeignKey(d => d.FiscalCountyId)
                .HasConstraintName("FK_tbPagamentosCompras_tbConcelhos_Fiscal");

            entity.HasOne(d => d.PaymentType)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.PaymentTypeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbCondicoesPagamento");

            entity.HasOne(d => d.LoadDistrict)
                .WithMany(p => p.TbPagamentosComprasIddistritoCargaNavigation)
                .HasForeignKey(d => d.LoadDistrictId)
                .HasConstraintName("FK_tbPagamentosCompras_tbDistritos_Carga");

            entity.HasOne(d => d.DownloadDistrict)
                .WithMany(p => p.TbPagamentosComprasIddistritoDescargaNavigation)
                .HasForeignKey(d => d.DownloadDistrictId)
                .HasConstraintName("FK_tbPagamentosCompras_tbDistritos_Descarga");

            entity.HasOne(d => d.ReceiverDistrict)
                .WithMany(p => p.TbPagamentosComprasIddistritoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverDistrictId)
                .HasConstraintName("FK_tbPagamentosCompras_tbDistritos_Destinatario");

            entity.HasOne(d => d.FiscalDistrict)
                .WithMany(p => p.TbPagamentosComprasIddistritoFiscalNavigation)
                .HasForeignKey(d => d.FiscalDistrictId)
                .HasConstraintName("FK_tbPagamentosCompras_tbDistritos_Fiscal");

            entity.HasOne(d => d.Entity)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.EntityId)
                .HasConstraintName("FK_tbPagamentosCompras_tbFornecedores");

            entity.HasOne(d => d.FiscalSpace)
                .WithMany(p => p.TbPagamentosComprasIdespacoFiscalNavigation)
                .HasForeignKey(d => d.FiscalSpaceId)
                .HasConstraintName("FK_tbPagamentosCompras_tbSistemaEspacoFiscal1");

            entity.HasOne(d => d.FiscalSpaceCharges)
                .WithMany(p => p.TbPagamentosComprasIdespacoFiscalPortesNavigation)
                .HasForeignKey(d => d.FiscalSpaceChargesId)
                .HasConstraintName("FK_tbPagamentosCompras_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.State)
                .WithMany(p => p.ProviderPaymentDocument)
                .HasForeignKey(d => d.StateId)
                .HasConstraintName("FK_tbPagamentosCompras_tbEstados");

            entity.HasOne(d => d.ShippingWay)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.ShippingWayId)
                .HasConstraintName("FK_tbPagamentosCompras_tbFormasExpedicao");

            entity.HasOne(d => d.OperationCode)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.OperationCodeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbSistemaRegioesIVA");

            entity.HasOne(d => d.Store)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.StoreId)
                .HasConstraintName("FK_tbPagamentosCompras_tbLojas");

            entity.HasOne(d => d.Currency)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbPagamentosCompras_tbMoedas");

            entity.HasOne(d => d.LoadCountry)
                .WithMany(p => p.LoadSalesPayments)
                .HasForeignKey(d => d.LoadCountryId)
                .HasConstraintName("FK_tbPagamentosCompras_tbPaises");

            entity.HasOne(d => d.DownloadCountry)
                .WithMany(p => p.DownLoadSalesPayments)
                .HasForeignKey(d => d.DownloadCountryId)
                .HasConstraintName("FK_tbPagamentosCompras_tbPaises_Descarga");

            entity.HasOne(d => d.FiscalCountry)
                .WithMany(p => p.FiscalCountrySalesPayments)
                .HasForeignKey(d => d.FiscalCountryId)
                .HasConstraintName("FK_tbPagamentosCompras_tbPaises_Fiscal");

            entity.HasOne(d => d.VatScheme)
                .WithMany(p => p.TbPagamentosComprasIdregimeIvaNavigation)
                .HasForeignKey(d => d.VatSchemeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbSistemaRegimeIVA1");

            entity.HasOne(d => d.VatSchemeCharges)
                .WithMany(p => p.TbPagamentosComprasIdregimeIvaPortesNavigation)
                .HasForeignKey(d => d.VatSchemeChargesId)
                .HasConstraintName("FK_tbPagamentosCompras_tbSistemaRegimeIVA");

            entity.HasOne(d => d.SystemUnitPricesType)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.SystemUnitPricesTypeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbSistemaTiposDocumentoPrecoUnitario");

            entity.HasOne(d => d.VatRateCharges)
                .WithMany(p => p.ProviderPaymentDocument)
                .HasForeignKey(d => d.VatRateChargesId)
                .HasConstraintName("FK_tbPagamentosCompras_tbIVA_Portes");

            entity.HasOne(d => d.DocumentType)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPagamentosCompras_tbTiposDocumento");

            entity.HasOne(d => d.EntityType)
                .WithMany(p => p.ProviderPaymentDocument)
                .HasForeignKey(d => d.EntityTypeId)
                .HasConstraintName("FK_tbPagamentosCompras_tbSistemaTiposEntidade");

            entity.HasOne(d => d.DocumentTypeSeries)
                .WithMany(p => p.TbPagamentosCompras)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPagamentosCompras_tbTiposDocumentoSeries");
        }
    }
}