using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class ReceiptDocumentLineMap : IEntityTypeConfiguration<ReceiptDocumentLine>
    {
        public void Configure(EntityTypeBuilder<ReceiptDocumentLine> entity)
        {
            entity.ToTable("tbRecibosLinhas");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.PrintFiscalZipCode).HasColumnName("CodigoPostalFiscal").HasMaxLength(50);

            entity.Property(e => e.FiscalTaxPayer).HasColumnName("ContribuinteFiscal").HasMaxLength(25);

            entity.Property(e => e.OriginDocumentDate).HasColumnName("DataDocOrigem").HasColumnType("datetime");

            entity.Property(e => e.DocumentDate).HasColumnName("DataDocumento").HasColumnType("datetime");

            entity.Property(e => e.DueDate).HasColumnName("DataVencimento").HasColumnType("datetime");

            entity.Property(e => e.FiscalZipCodeDescription).HasColumnName("DescricaoCodigoPostalFiscal").HasMaxLength(50);

            entity.Property(e => e.FiscalCountyDescription).HasColumnName("DescricaoConcelhoFiscal").HasMaxLength(50);

            entity.Property(e => e.FiscalDistrictDescription).HasColumnName("DescricaoDistritoFiscal").HasMaxLength(50);

            entity.Property(e => e.Document).HasColumnName("Documento").HasMaxLength(255);

            entity.Property(e => e.OriginDocument).HasColumnName("DocumentoOrigem").HasMaxLength(255);

            entity.Property(e => e.FiscalZipCodeId).HasColumnName("IDCodigoPostalFiscal");

            entity.Property(e => e.FiscalCountyId).HasColumnName("IDConcelhoFiscal");

            entity.Property(e => e.FiscalDistrictId).HasColumnName("IDDistritoFiscal");

            entity.Property(e => e.SaleDocumentId).HasColumnName("IDDocumentoVenda");

            entity.Property(e => e.EntityId).HasColumnName("IDEntidade");

            entity.Property(e => e.CurrencyId).HasColumnName("IDMoeda");

            entity.Property(e => e.ReceiptDocumentId).HasColumnName("IDRecibo");

            entity.Property(e => e.DocumentTypeId).HasColumnName("IDTipoDocumento");

            entity.Property(e => e.DocumentTypeSeriesId).HasColumnName("IDTiposDocumentoSeries");

            entity.Property(e => e.FiscalAddress).HasColumnName("MoradaFiscal").HasMaxLength(100);

            entity.Property(e => e.FiscalName).HasColumnName("NomeFiscal").HasMaxLength(200);

            entity.Property(e => e.CountryFiscalAcronym).HasColumnName("SiglaPaisFiscal").HasMaxLength(15);

            entity.Property(e => e.AmmountPaid).HasColumnName("ValorPago");

            entity.Property(e => e.ConversionRate).HasColumnName("TaxaConversao");

            entity.Property(e => e.Order).HasColumnName("Ordem");

            entity.Property(e => e.DocumentNumber).HasColumnName("NumeroDocumento");

            entity.Property(e => e.VatValue).HasColumnName("ValorIVA");

            entity.Property(e => e.TotalCurrencyDocument).HasColumnName("TotalMoedaDocumento");

            entity.Property(e => e.TotalReferenceCurrency).HasColumnName("TotalMoedaReferencia");

            entity.Property(e => e.IsDownPayment).HasColumnName("Adiantamento");

            entity.Property(e => e.IncidenceValue).HasColumnName("ValorIncidencia");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.HasOne(d => d.IdcodigoPostalFiscalNavigation)
                .WithMany(p => p.TbRecibosLinhas)
                .HasForeignKey(d => d.FiscalZipCodeId)
                .HasConstraintName("FK_tbRecibosLinhas_tbCodigosPostais");

            entity.HasOne(d => d.IdconcelhoFiscalNavigation)
                .WithMany(p => p.TbRecibosLinhas)
                .HasForeignKey(d => d.FiscalCountyId)
                .HasConstraintName("FK_tbRecibosLinhas_tbConcelhos");

            entity.HasOne(d => d.IddistritoFiscalNavigation)
                .WithMany(p => p.TbRecibosLinhas)
                .HasForeignKey(d => d.FiscalDistrictId)
                .HasConstraintName("FK_tbRecibosLinhas_tbDistritos");

            entity.HasOne(d => d.SaleDocument)
                .WithMany(p => p.Receipts)
                .HasForeignKey(d => d.SaleDocumentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbRecibosLinhas_tbDocumentosVendas");

            entity.HasOne(d => d.IdentidadeNavigation)
                .WithMany(p => p.TbRecibosLinhas)
                .HasForeignKey(d => d.EntityId)
                .HasConstraintName("FK_tbRecibosLinhas_tbClientes");

            entity.HasOne(d => d.IdmoedaNavigation)
                .WithMany(p => p.TbRecibosLinhas)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbRecibosLinhas_tbMoedas");

            entity.HasOne(d => d.ReceiptDocument)
                .WithMany(p => p.Lines)
                .HasForeignKey(d => d.ReceiptDocumentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbRecibosLinhas_tbRecibos");

            entity.HasOne(d => d.IdtipoDocumentoNavigation)
                .WithMany(p => p.TbRecibosLinhas)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbRecibosLinhas_tbTiposDocumento");

            entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
                .WithMany(p => p.TbRecibosLinhas)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbRecibosLinhas_tbTiposDocumentoSeries");

        }
    }
}