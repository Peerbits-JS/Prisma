using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class ProviderPaymentDocumentLineMap : IEntityTypeConfiguration<ProviderPaymentDocumentLine>
    {
        public void Configure(EntityTypeBuilder<ProviderPaymentDocumentLine> entity)
        {
            entity.ToTable("tbPagamentosComprasLinhas");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.DocumentDate).HasColumnName("DataDocumento").HasColumnType("datetime");

            entity.Property(e => e.DueDate).HasColumnName("DataVencimento").HasColumnType("datetime");

            entity.Property(e => e.EntityName).HasColumnName("DescricaoEntidade").HasMaxLength(200);

            entity.Property(e => e.Document).HasColumnName("Documento").HasMaxLength(255);

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.Property(e => e.PurchaseDocumentId).HasColumnName("IDDocumentoCompra");

            entity.Property(e => e.EntityId).HasColumnName("IDEntidade");

            entity.Property(e => e.StoreId).HasColumnName("IDLoja");

            entity.Property(e => e.CurrencyId).HasColumnName("IDMoeda");

            entity.Property(e => e.ProviderPaymentDocumentId).HasColumnName("IDPagamentoCompra");

            entity.Property(e => e.SystemNatureId).HasColumnName("IDSistemaNaturezas");

            entity.Property(e => e.DocumentTypeId).HasColumnName("IDTipoDocumento");

            entity.Property(e => e.EntityTypeId).HasColumnName("IDTipoEntidade");

            entity.Property(e => e.DocumentTypeSeriesId).HasColumnName("IDTiposDocumentoSeries");

            entity.Property(e => e.ConversionRate).HasColumnName("TaxaConversao");

            entity.Property(e => e.DiscountPercentage).HasColumnName("PercentagemDesconto");

            entity.Property(e => e.DiscountValue).HasColumnName("ValorDesconto");

            entity.Property(e => e.DocumentNumber).HasColumnName("NumeroDocumento");

            entity.Property(e => e.Order).HasColumnName("Ordem");

            entity.Property(e => e.PaidAmount).HasColumnName("ValorPago");

            entity.Property(e => e.PendingAmount).HasColumnName("ValorPendente");

            entity.Property(e => e.TotalCurrency).HasColumnName("TotalMoeda");

            entity.Property(e => e.TotalCurrencyDocument).HasColumnName("TotalMoedaDocumento");

            entity.Property(e => e.TotalReferenceCurrency).HasColumnName("TotalMoedaReferencia");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.HasOne(d => d.PurchaseDocument)
                .WithMany(p => p.PurchasePayments)
                .HasForeignKey(d => d.PurchaseDocumentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbDocumentosCompras");

            entity.HasOne(d => d.Entity)
                .WithMany(p => p.TbPagamentosComprasLinhas)
                .HasForeignKey(d => d.EntityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbClientes");

            entity.HasOne(d => d.Store)
                .WithMany(p => p.TbPagamentosComprasLinhas)
                .HasForeignKey(d => d.StoreId)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbLojas");

            entity.HasOne(d => d.Currency)
                .WithMany(p => p.TbPagamentosComprasLinhas)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbMoedas");

            entity.HasOne(d => d.ProviderPaymentDocument)
                .WithMany(p => p.Lines)
                .HasForeignKey(d => d.ProviderPaymentDocumentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbPagamentosCompras");

            entity.HasOne(d => d.IdsistemaNaturezasNavigation)
                .WithMany(p => p.TbPagamentosComprasLinhas)
                .HasForeignKey(d => d.SystemNatureId)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbSistemaNaturezas");

            entity.HasOne(d => d.DocumentType)
                .WithMany(p => p.TbPagamentosComprasLinhas)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbTiposDocumento");

            entity.HasOne(d => d.DocumentTypeSeries)
                .WithMany(p => p.TbPagamentosComprasLinhas)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPagamentosComprasLinhas_tbTiposDocumentoSeries");
        }
    }
}