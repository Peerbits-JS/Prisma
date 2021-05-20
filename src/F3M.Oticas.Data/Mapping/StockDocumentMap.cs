using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class StockDocumentMap : IEntityTypeConfiguration<StockDocument>
    {
        public void Configure(EntityTypeBuilder<StockDocument> builder)
        {
            builder.ToTable("tbDocumentosStock");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.DocumentTypeId)
                .HasColumnName("IDTipoDocumento");

            builder.Property(e => e.DocumentNumber)
                .HasColumnName("NumeroDocumento");

            builder.Property(e => e.DocumentDate)
                .HasColumnName("DataDocumento")
                .HasColumnType("datetime");

            builder.Property(e => e.Notes)
                .HasColumnName("Observacoes");

            builder.Property(e => e.CurrencyId)
                .HasColumnName("IDMoeda");

            builder.Property(e => e.ConversionRate)
                .HasColumnName("TaxaConversao");

            builder.Property(x => x.TotalCurrencyDocument)
                .HasColumnName("TotalMoedaDocumento");

            builder.Property(x => x.TotalReferenceCurrency)
                .HasColumnName("TotalMoedaReferencia");

            builder.Property(e => e.LoadPlace)
                .HasColumnName("LocalCarga")
                .HasMaxLength(50);

            builder.Property(e => e.LoadDate)
                .HasColumnName("DataCarga")
                .HasColumnType("datetime");

            builder.Property(e => e.LoadTime)
                .HasColumnName("HoraCarga")
                .HasColumnType("datetime");

            builder.Property(e => e.LoadAddress)
                .HasColumnName("MoradaCarga")
                .HasMaxLength(100);

            builder.Property(e => e.LoadZipCodeId)
                .HasColumnName("IDCodigoPostalCarga");

            builder.Property(e => e.LoadCountyId)
                .HasColumnName("IDConcelhoCarga");

            builder.Property(e => e.LoadDistrictId)
                .HasColumnName("IDDistritoCarga");


            builder.Property(e => e.DownloadPlace)
                .HasColumnName("LocalDescarga")
                .HasMaxLength(50);

            builder.Property(e => e.DownloadDate)
                .HasColumnName("DataDescarga")
                .HasColumnType("datetime");

            builder.Property(e => e.DownloadTime)
                .HasColumnName("HoraDescarga")
                .HasColumnType("datetime");

            builder.Property(e => e.DownloadAdrress)
                .HasColumnName("MoradaDescarga")
                .HasMaxLength(100);

            builder.Property(e => e.DownloadZipCodeId)
                .HasColumnName("IDCodigoPostalDescarga");

            builder.Property(e => e.DownloadCountyId)
                .HasColumnName("IDConcelhoDescarga");

            builder.Property(e => e.DownloadDistrictId)
                .HasColumnName("IDDistritoDescarga");

            builder.Property(e => e.ReceiverName)
                .HasColumnName("NomeDestinatario")
                .HasMaxLength(100);

            builder.Property(e => e.ReceiverAddress)
                .HasColumnName("MoradaDestinatario")
                .HasMaxLength(100);

            builder.Property(e => e.ReceiverZipCodeId)
                .HasColumnName("IDCodigoPostalDestinatario");

            builder.Property(e => e.ReceiverCountyId)
                .HasColumnName("IDConcelhoDestinatario");

            builder.Property(e => e.ReceiverDistrictId)
                .HasColumnName("IDDistritoDestinatario");

            builder.Property(e => e.ManualDocumentSerie)
                .HasColumnName("SerieDocManual")
                .HasMaxLength(6);

            builder.Property(e => e.ManualDocumentNumber)
                .HasColumnName("NumeroDocManual")
                .HasMaxLength(10);

            builder.Property(x => x.NumberOfLines)
                .HasColumnName("NumeroLinhas");

            builder.Property(e => e.Station)
                .HasColumnName("Posto")
                .HasMaxLength(512);

            builder.Property(e => e.StateId)
                .HasColumnName("IDEstado");

            builder.Property(e => e.StateUser)
                .HasColumnName("UtilizadorEstado")
                .HasMaxLength(20);

            builder.Property(e => e.StateTime)
                .HasColumnName("DataHoraEstado")
                .HasColumnType("datetime");

            builder.Property(e => e.Signature)
                .HasColumnName("Assinatura")
                .HasMaxLength(255);

            builder.Property(x => x.PrivateKeyVersion)
                .HasColumnName("VersaoChavePrivada");

            builder.Property(e => e.FiscalName)
                .HasColumnName("NomeFiscal")
                .HasMaxLength(200);

            builder.Property(e => e.FiscalAddress)
                .HasColumnName("MoradaFiscal")
                .HasMaxLength(100);

            builder.Property(e => e.FiscalZipCodeId)
                .HasColumnName("IDCodigoPostalFiscal");

            builder.Property(e => e.FiscalCountyId)
                .HasColumnName("IDConcelhoFiscal");

            builder.Property(e => e.FiscalDistrictId)
                .HasColumnName("IDDistritoFiscal");

            builder.Property(e => e.CountryFiscalAcronym)
                .HasColumnName("SiglaPaisFiscal")
                .HasMaxLength(15);

            builder.Property(e => e.StoreId)
                .HasColumnName("IDLoja");

            builder.Property(e => e.HeadStoreId)
                .HasColumnName("IDLojaSede");

            builder.Property(x => x.IsPrinted)
                .HasColumnName("Impresso");

            builder.Property(x => x.TaxValue)
                .HasColumnName("ValorImposto");

            builder.Property(x => x.DiscountPercentage)
                .HasColumnName("PercentagemDesconto");

            builder.Property(x => x.DiscountValue)
                .HasColumnName("ValorDesconto");

            builder.Property(x => x.ChargesValue)
                .HasColumnName("ValorPortes");

            builder.Property(e => e.VatRateChargesId)
                .HasColumnName("IDTaxaIvaPortes");

            builder.Property(x => x.PrintVatRateCharges)
                .HasColumnName("TaxaIvaPortes");

            builder.Property(e => e.ReasonForExemptionFromVat)
                .HasColumnName("MotivoIsencaoIva")
                .HasMaxLength(255);

            builder.Property(e => e.ReasonForExemptionFromCharges)
                .HasColumnName("MotivoIsencaoPortes")
                .HasMaxLength(255);

            builder.Property(e => e.FiscalSpaceChargesId)
                .HasColumnName("IDEspacoFiscalPortes");

            builder.Property(e => e.PrintFiscalSpaceCharges)
                .HasColumnName("EspacoFiscalPortes")
                .HasMaxLength(50);

            builder.Property(e => e.VatSchemeChargesId)
                .HasColumnName("IDRegimeIvaPortes");

            builder.Property(e => e.PrintVatSchemeCharges)
                .HasColumnName("RegimeIvaPortes")
                .HasMaxLength(50);

            builder.Property(x => x.AddicionalCosts)
                .HasColumnName("CustosAdicionais");

            builder.Property(e => e.ShippingWayId)
                .HasColumnName("IDFormaExpedicao");

            builder.Property(e => e.DocumentTypeSeriesId)
                .HasColumnName("IDTiposDocumentoSeries");

            builder.Property(x => x.InternalNumber)
                .HasColumnName("NumeroInterno");

            builder.Property(e => e.EntityId)
                .HasColumnName("IDEntidade")
                .HasDefaultValueSql("((1))");

            builder.Property(e => e.EntityTypeId)
                .HasColumnName("IDTipoEntidade")
                .HasDefaultValueSql("((3))");

            builder.Property(e => e.PaymentTypeId)
                .HasColumnName("IDCondicaoPagamento")
                .HasDefaultValueSql("((13))");

            builder.Property(e => e.OperationCodeId)
                .HasColumnName("IDLocalOperacao")
                .HasDefaultValueSql("((1))");

            builder.Property(e => e.ATCode)
                .HasColumnName("CodigoAT")
                .HasMaxLength(200);

            builder.Property(e => e.LoadCountryId)
                .HasColumnName("IDPaisCarga");

            builder.Property(e => e.DownloadCountryId)
                .HasColumnName("IDPaisDescarga");

            builder.Property(e => e.Registry)
                .HasColumnName("Matricula")
                .HasMaxLength(50);

            builder.Property(e => e.FiscalCountryId)
                .HasColumnName("IDPaisFiscal");

            builder.Property(e => e.PrintFiscalZipCode)
                .HasColumnName("CodigoPostalFiscal")
                .HasMaxLength(10);


            builder.Property(e => e.FiscalZipCodeDescription)
                .HasColumnName("DescricaoCodigoPostalFiscal")
                .HasMaxLength(50);

            builder.Property(e => e.FiscalCountyDescription)
                .HasColumnName("DescricaoConcelhoFiscal")
                .HasMaxLength(50);

            builder.Property(e => e.FiscalDistrictDescription)
                .HasColumnName("DescricaoDistritoFiscal")
                .HasMaxLength(50);

            builder.Property(e => e.FiscalSpaceId)
                .HasColumnName("IDEspacoFiscal");

            builder.Property(e => e.VatSchemeId)
                .HasColumnName("IDRegimeIva");

            builder.Property(e => e.FiscalType)
                .HasColumnName("TipoFiscal")
                .HasMaxLength(20);

            builder.Property(e => e.Document)
                .HasColumnName("Documento")
                .HasMaxLength(255);

            builder.Property(e => e.ATInternalCode)
                       .HasColumnName("CodigoATInterno")
                       .HasMaxLength(200);

            builder.Property(e => e.TypeStateCode)
                .HasColumnName("CodigoTipoEstado")
                .HasMaxLength(20);

            builder.Property(e => e.DocumentOriginCode)
                .HasColumnName("CodigoDocOrigem")
                .HasMaxLength(255);

            builder.Property(e => e.PrintLoadDistrict)
                .HasColumnName("DistritoCarga")
                .HasMaxLength(255);

            builder.Property(e => e.PrintLoadZipCode)
                .HasColumnName("CodigoPostalCarga")
                .HasMaxLength(20);

            builder.Property(e => e.LoadCountryAcronym)
                .HasColumnName("SiglaPaisCarga")
                .HasMaxLength(6);

            builder.Property(e => e.PrintDownloadCounty)
                .HasColumnName("ConcelhoDescarga")
                .HasMaxLength(255);

            builder.Property(e => e.DownloadZipCode)
                .HasColumnName("CodigoPostalDescarga")
                .HasMaxLength(20);

            builder.Property(e => e.DownloadCountryAcronym)
                .HasColumnName("SiglaPaisDescarga")
                .HasMaxLength(6);

            builder.Property(e => e.EntityCode)
                .HasColumnName("CodigoEntidade")
                .HasMaxLength(20);

            builder.Property(e => e.CurrencyCode)
                .HasColumnName("CodigoMoeda")
                .HasMaxLength(20);

            builder.Property(e => e.ATDocumentMessage)
                .HasColumnName("MensagemDocAT")
                .HasMaxLength(1000);

            builder.Property(e => e.SystemUnitPricesTypeId)
                .HasColumnName("IDSisTiposDocPU");

            builder.Property(x => x.IsManualDocument)
                .HasColumnName("DocManual");

            builder.Property(e => e.IsReplenishmentDocument)
                .HasColumnName("DocReposicao");

            builder.Property(e => e.InternalControlDate)
                .HasColumnName("DataControloInterno")
                .HasColumnType("datetime");

            builder.Property(e => e.SubTotal)
                .HasColumnName("SubTotal");

            builder.Property(e => e.LinesDiscounts)
                .HasColumnName("DescontosLinha");

            builder.Property(e => e.VatTotal)
                .HasColumnName("TotalIVA");

            builder.Property(e => e.DueDate)
                .HasColumnName("DataVencimento")
                .HasColumnType("datetime");

            builder.Property(e => e.ExternalDocumentNumber)
                .HasColumnName("VossoNumeroDocumento")
                .HasMaxLength(256);

            builder.Property(e => e.IsSatisfied)
                .HasColumnName("Satisfeito");

            builder.Property(e => e.IsSecondDocumentPath)
                .HasColumnName("SegundaVia");

            builder.Property(e => e.LastPrintDate)
                .HasColumnName("DataUltimaImpressao")
                .HasColumnType("datetime");

            builder.Property(e => e.NumberOfPrints)
                .HasColumnName("NumeroImpressoes");

            builder.Property(e => e.StoreLastPrintId)
                .HasColumnName("IDLojaUltimaImpressao");

            builder.Property(e => e.DeliveryDate)
                .HasColumnName("DataEntrega")
                .HasColumnType("datetime");

            builder.Property(e => e.StateReason)
                .HasColumnName("RazaoEstado");


            builder.HasOne(d => d.LoadZipCode)
                .WithMany(p => p.TbDocumentosStockIdcodigoPostalCargaNavigation)
                .HasForeignKey(d => d.LoadZipCodeId)
                .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Carga");

            builder.HasOne(d => d.DowloadZipCode)
                .WithMany(p => p.TbDocumentosStockIdcodigoPostalDescargaNavigation)
                .HasForeignKey(d => d.DownloadZipCodeId)
                .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Descarga");

            builder.HasOne(d => d.ReceiverZipCode)
                .WithMany(p => p.TbDocumentosStockIdcodigoPostalDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverZipCodeId)
                .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Destinatario");

            builder.HasOne(d => d.FiscalZipCode)
                .WithMany(p => p.TbDocumentosStockIdcodigoPostalFiscalNavigation)
                .HasForeignKey(d => d.FiscalZipCodeId)
                .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Fiscal");

            builder.HasOne(d => d.LoadCounty)
                .WithMany(p => p.TbDocumentosStockIdconcelhoCargaNavigation)
                .HasForeignKey(d => d.LoadCountyId)
                .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Carga");

            builder.HasOne(d => d.DownloadCounty)
                .WithMany(p => p.TbDocumentosStockIdconcelhoDescargaNavigation)
                .HasForeignKey(d => d.DownloadCountyId)
                .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Descarga");

            builder.HasOne(d => d.ReceiverCounty)
                .WithMany(p => p.TbDocumentosStockIdconcelhoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverCountyId)
                .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Destinatario");


            builder.HasOne(d => d.FiscalCounty)
                .WithMany(p => p.TbDocumentosStockIdconcelhoFiscalNavigation)
                .HasForeignKey(d => d.FiscalCountyId)
                .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Fiscal");

            builder.HasOne(d => d.PaymentType)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.PaymentTypeId)
                .HasConstraintName("FK_tbDocumentosStock_tbCondicoesPagamento");

            builder.HasOne(d => d.LoadDistrict)
                .WithMany(p => p.TbDocumentosStockIddistritoCargaNavigation)
                .HasForeignKey(d => d.LoadDistrictId)
                .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Carga");

            builder.HasOne(d => d.DownloadDistrict)
                .WithMany(p => p.TbDocumentosStockIddistritoDescargaNavigation)
                .HasForeignKey(d => d.DownloadDistrictId)
                .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Descarga");

            builder.HasOne(d => d.ReceiverDistrict)
                .WithMany(p => p.TbDocumentosStockIddistritoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverDistrictId)
                .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Destinatario");

            builder.HasOne(d => d.FiscalDistrict)
                .WithMany(p => p.TbDocumentosStockIddistritoFiscalNavigation)
                .HasForeignKey(d => d.FiscalDistrictId)
                .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Fiscal");

            builder.HasOne(d => d.Entity)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.EntityId)
                .HasConstraintName("FK_tbDocumentosStock_tbClientes");

            builder.HasOne(d => d.FiscalSpace)
                .WithMany(p => p.TbDocumentosStockIdespacoFiscalNavigation)
                .HasForeignKey(d => d.FiscalSpaceId)
                .HasConstraintName("FK_tbDocumentosStock_tbSistemaEspacoFiscal1");


            builder.HasOne(d => d.FiscalSpaceCharges)
                .WithMany(p => p.TbDocumentosStockIdespacoFiscalPortesNavigation)
                .HasForeignKey(d => d.FiscalSpaceChargesId)
                .HasConstraintName("FK_tbDocumentosStock_tbSistemaEspacoFiscal");


            builder.HasOne(d => d.State)
                .WithMany(p => p.StockDocument)
                .HasForeignKey(d => d.StateId)
                .HasConstraintName("FK_tbDocumentosStock_tbEstados");

            builder.HasOne(d => d.ShippingWay)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.ShippingWayId)
                .HasConstraintName("FK_tbDocumentosStock_tbFormasExpedicao");

            builder.HasOne(d => d.OperationCode)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.OperationCodeId)
                .HasConstraintName("FK_tbDocumentosStock_tbSistemaRegioesIVA");

            builder.HasOne(d => d.Store)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.StoreId)
                .HasConstraintName("FK_tbDocumentosStock_tbLojas");

            builder.HasOne(d => d.Currency)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbDocumentosStock_tbMoedas");

            builder.HasOne(d => d.LoadCountry)
                .WithMany(p => p.LoadCountryStockDocuments)
                .HasForeignKey(d => d.LoadCountryId)
                .HasConstraintName("FK_tbDocumentosStock_tbPaises");

            builder.HasOne(d => d.DownloadCountry)
                .WithMany(p => p.DownLoadCountryStockDocuments)
                .HasForeignKey(d => d.DownloadCountryId)
                .HasConstraintName("FK_tbDocumentosStock_tbPaises_Descarga");

            builder.HasOne(d => d.FiscalCountry)
                .WithMany(p => p.FiscalCountryStockDocuments)
                .HasForeignKey(d => d.FiscalCountryId)
                .HasConstraintName("FK_tbDocumentosStock_tbPaises_Fiscal");

            builder.HasOne(d => d.VatScheme)
                .WithMany(p => p.TbDocumentosStockIdregimeIvaNavigation)
                .HasForeignKey(d => d.VatSchemeId)
                .HasConstraintName("FK_tbDocumentosStock_tbSistemaRegimeIVA1");

            builder.HasOne(d => d.VatSchemeCharges)
                .WithMany(p => p.TbDocumentosStockIdregimeIvaPortesNavigation)
                .HasForeignKey(d => d.VatSchemeChargesId)
                .HasConstraintName("FK_tbDocumentosStock_tbSistemaRegimeIVA");

            builder.HasOne(d => d.SystemUnitPricesType)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.SystemUnitPricesTypeId)
                .HasConstraintName("FK_tbDocumentosStock_tbSistemaTiposDocumentoPrecoUnitario");

            builder.HasOne(d => d.VatRateCharges)
                .WithMany(p => p.StockDocument)
                .HasForeignKey(d => d.VatRateChargesId)
                .HasConstraintName("FK_tbDocumentosStock_tbIVA_Portes");

            builder.HasOne(d => d.DocumentType)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosStock_tbTiposDocumento");

            builder.HasOne(d => d.EntityType)
                .WithMany(p => p.StockDocument)
                .HasForeignKey(d => d.EntityTypeId)
                .HasConstraintName("FK_tbDocumentosStock_tbSistemaTiposEntidade");

            builder.HasOne(d => d.DocumentTypeSeries)
                .WithMany(p => p.TbDocumentosStock)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosStock_tbTiposDocumentoSeries");

            builder.Property(e => e.IsActive)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            builder.Property(e => e.SystemUnitPricesTypeCode)
                .HasColumnName("CodigoSisTiposDocPU")
                .HasMaxLength(6);

            builder.Property(e => e.PrintLoadCounty)
                .HasColumnName("ConcelhoCarga")
                .HasMaxLength(255);

            builder.Property(e => e.FiscalTaxPayer)
                .HasColumnName("ContribuinteFiscal")
                .HasMaxLength(25);

            builder.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");

            builder.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            builder.Property(e => e.IsActive)
               .IsRequired()
               .HasColumnName("Ativo")
               .HasDefaultValueSql("((1))");

            builder.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            builder.Property(e => e.SignatureDate)
                .HasColumnName("DataAssinatura")
                .HasColumnType("datetime");

            builder.Property(e => e.PrintDownloadDistrict)
                .HasColumnName("DistritoDescarga")
                .HasMaxLength(255);

            builder.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            builder.Property(e => e.StateReason)
                .HasColumnName("RazaoEstado")
                .HasMaxLength(50);

            builder.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");

            builder.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");
        }
    }
}
