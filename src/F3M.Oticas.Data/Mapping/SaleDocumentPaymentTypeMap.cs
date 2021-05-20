using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class SaleDocumentPaymentTypeMap : IEntityTypeConfiguration<SaleDocumentPaymentType>
    {
        public void Configure(EntityTypeBuilder<SaleDocumentPaymentType> entity)
        {

            entity.ToTable("tbDocumentosVendasFormasPagamento");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.PaymentTypeCode).HasMaxLength(6);

            entity.Property(e => e.SaleDocumentId).HasColumnName("IDDocumentoVenda");

            entity.Property(e => e.PaymentTypeId).HasColumnName("IDFormaPagamento");

            entity.Property(e => e.StoreId).HasColumnName("IDLoja");

            entity.Property(e => e.CurrencyId).HasColumnName("IDMoeda");

            entity.Property(e => e.ConversionRate).HasColumnName("TaxaConversao");

            entity.Property(e => e.PaymentTypeCode).HasColumnName("CodigoFormaPagamento");

            entity.Property(e => e.TotalCurrency).HasColumnName("TotalMoeda");

            entity.Property(e => e.TotalReferenceCurrency).HasColumnName("TotalMoedaReferencia");

            entity.Property(e => e.Value).HasColumnName("Valor");

            entity.Property(e => e.ValueDelivered).HasColumnName("ValorEntregue");

            entity.Property(e => e.Order).HasColumnName("Ordem");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.HasOne(d => d.SalesDocument)
                .WithMany(p => p.PaymentsTypes)
                .HasForeignKey(d => d.SaleDocumentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosVendasFormasPagamento_tbDocumentosVendas");

            entity.HasOne(d => d.PaymentType)
                .WithMany(p => p.TbDocumentosVendasFormasPagamento)
                .HasForeignKey(d => d.PaymentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosVendasFormasPagamento_tbFormasPagamento");

            entity.HasOne(d => d.Store)
                .WithMany(p => p.TbDocumentosVendasFormasPagamento)
                .HasForeignKey(d => d.StoreId)
                .HasConstraintName("FK_tbDocumentosVendasFormasPagamento_tbLojas");
        }
    }
}
