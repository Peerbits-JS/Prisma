using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class CurrentAccountStockProductMap : IEntityTypeConfiguration<CurrentAccountStockProduct>
    {
        public void Configure(EntityTypeBuilder<CurrentAccountStockProduct> builder)
        {
            builder.ToTable("tbCCStockArtigos");

            builder.HasIndex(e => e.ProductId);

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.Description)
                .HasColumnName("Descricao");

            builder.Property(e => e.IsActive)
              .IsRequired()
              .HasColumnName("Ativo")
              .HasDefaultValueSql("((1))");

            builder.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            builder.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            builder.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            builder.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20);

            builder.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20);

            builder.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");


            builder.Property(e => e.InternalControlDate)
                .HasColumnName("DataControloInterno")
                .HasColumnType("datetime");

            builder.Property(e => e.DocumentDate)
                .HasColumnName("DataDocumento")
                .HasColumnType("datetime");

            builder.Property(e => e.Quantity)
                .HasColumnName("Quantidade");


            builder.Property(e => e.StockQuantity)
                .HasColumnName("QuantidadeStock");


            builder.Property(e => e.LastStockQuantity)
                .HasColumnName("QtdStockAnterior");

            builder.Property(e => e.CurrentStockQuantity)
                .HasColumnName("QtdStockAtual");

            builder.Property(e => e.RateConversion)
                .HasColumnName("TaxaConversao");

            builder.Property(e => e.UnitPrice)
                .HasColumnName("PrecoUnitario");

            builder.Property(e => e.EffectiveUnitPrice)
                .HasColumnName("PrecoUnitarioEfetivo");

            builder.Property(e => e.UnitPriceInReferenceCurrency)
                .HasColumnName("PrecoUnitarioMoedaRef");

            builder.Property(e => e.EffectiveUnitPriceInReferenceCurrency)
                .HasColumnName("PrecoUnitarioEfetivoMoedaRef");

            builder.Property(e => e.NeedToRecalculate)
                .HasColumnName("Recalcular");

            builder.Property(e => e.AffectedStockQuantity)
                .HasColumnName("QtdAfetacaoStock");

            
            builder.Property(e => e.LastAdditionalCostsInReferenceCurrency)
                .HasColumnName("UltCustosAdicionaisMoedaRef");

            builder.Property(e => e.LastComercialDiscountInReferenceCurrency)
                .HasColumnName("UltDescComerciaisMoedaRef");

            builder.Property(e => e.PrintInitialOriginDocument)
                .HasColumnName("DocumentoOrigemInicial")
                .HasMaxLength(255);

            builder.Property(e => e.StockQuantityReservation)
                .HasColumnName("QtdStockReserva");

            builder.Property(e => e.WarehouseId)
                .HasColumnName("IDArmazem");

            builder.Property(e => e.WarehouseLocationId)
                .HasColumnName("IDArmazemLocalizacao");

            builder.Property(e => e.ProductId)
                .HasColumnName("IDArtigo");


            builder.Property(e => e.ProductBatchId)
                .HasColumnName("IDArtigoLote");

            builder.Property(e => e.ProductSerialNumberId)
                .HasColumnName("IDArtigoNumeroSerie");



            builder.Property(e => e.DocumentId).HasColumnName("IDDocumento");

            builder.Property(e => e.OriginDocumentId)
                .HasColumnName("IDDocumentoOrigem");

            builder.Property(e => e.InitialOriginDocumentId)
                .HasColumnName("IDDocumentoOrigemInicial");

            builder.Property(e => e.EntityId)
                .HasColumnName("IDEntidade");

            builder.Property(e => e.DocumentLineId)
                .HasColumnName("IDLinhaDocumento");

            builder.Property(e => e.OriginDocumentLineId)
                .HasColumnName("IDLinhaDocumentoOrigem");

            builder.Property(e => e.InitialDocumentLineOrigin)
                .HasColumnName("IDLinhaDocumentoOrigemInicial");

            builder.Property(e => e.StoreId)
                .HasColumnName("IDLoja");

            builder.Property(e => e.CurrencyId)
                .HasColumnName("IDMoeda");

            builder.Property(e => e.DocumentTypeId)
                .HasColumnName("IDTipoDocumento");

            builder.Property(e => e.OriginDocumentTypeId)
                .HasColumnName("IDTipoDocumentoOrigem");

            builder.Property(e => e.InitialOriginDocumentTypeId)
                .HasColumnName("IDTipoDocumentoOrigemInicial");

            builder.Property(e => e.EntityTypeId)
                .HasColumnName("IDTipoEntidade");

            builder.Property(e => e.DocumentTypeSeriesId)
                .HasColumnName("IDTiposDocumentoSeries");

            builder.Property(e => e.OriginDocumentTypeSeriesId).HasColumnName("IDTiposDocumentoSeriesOrigem");

            builder.Property(e => e.Natureza).HasMaxLength(2);

            builder.Property(e => e.DocumentNumber)
                .HasColumnName("NumeroDocumento")
                .HasMaxLength(100);

            builder.Property(e => e.LastUpcInReferenceCurrency).HasColumnName("PCMAnteriorMoedaRef");

            builder.Property(e => e.CurrentUpcInReferenceCurrency).HasColumnName("PCMAtualMoedaRef");

            builder.Property(e => e.PvInReferenceCurrency).HasColumnName("PVMoedaRef");

            builder.Property(e => e.UpcInReferenceCurrency).HasColumnName("UPCMoedaRef");

            builder.Property(e => e.UpPurchaseReferenceCurrency).HasColumnName("UPCompraMoedaRef");

            builder.Property(e => e.YourDocumentNumber)
                .HasColumnName("VossoNumeroDocumento")
                .HasMaxLength(256);

            builder.Property(e => e.YourOriginDocumentNumber)
                .HasColumnName("VossoNumeroDocumentoOrigem")
                .HasMaxLength(256);

            builder.Property(e => e.OriginDocumentNumber)
                .HasColumnName("NumeroDocumentoOrigem");

            builder.HasOne(d => d.Warehouse)
                .WithMany(p => p.TbCcstockArtigos)
                .HasForeignKey(d => d.WarehouseId)
                .HasConstraintName("FK_tbCCStockArtigos_IDArmazem");

            builder.HasOne(d => d.WarehouseLocation)
                .WithMany(p => p.TbCcstockArtigos)
                .HasForeignKey(d => d.WarehouseLocationId)
                .HasConstraintName("FK_tbCCStockArtigos_IDArmazemLocalizacao");

            builder.HasOne(d => d.Product)
                .WithMany(p => p.CurrentAccounts)
                .HasForeignKey(d => d.ProductId)
                .HasConstraintName("FK_tbCCStockArtigos_IDArtigo");

            builder.HasOne(d => d.ProductBatch)
                .WithMany(p => p.TbCcstockArtigos)
                .HasForeignKey(d => d.ProductBatchId)
                .HasConstraintName("FK_tbCCStockArtigos_IDArtigoLote");

            builder.HasOne(d => d.ProductSerialNumber)
                .WithMany(p => p.TbCcstockArtigos)
                .HasForeignKey(d => d.ProductSerialNumberId)
                .HasConstraintName("FK_tbCCStockArtigos_IDArtigoNumeroSerie");

            builder.HasOne(d => d.Currency)
                .WithMany(p => p.TbCcstockArtigos)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbCCStockArtigos_IDMoeda");

            builder.HasOne(d => d.DocumentType)
                .WithMany(p => p.TbCcstockArtigosIdtipoDocumentoNavigation)
                .HasForeignKey(d => d.DocumentTypeId)
                .HasConstraintName("FK_tbCCStockArtigos_IDTipoDocumento");

            builder.HasOne(d => d.OriginDocumentType)
                .WithMany(p => p.TbCcstockArtigosIdtipoDocumentoOrigemNavigation)
                .HasForeignKey(d => d.OriginDocumentTypeId)
                .HasConstraintName("FK_tbCCStockArtigos_IDTipoDocumentoOrigem");

            builder.HasOne(d => d.InitialOriginDocumentType)
                .WithMany(p => p.TbCcstockArtigosIdtipoDocumentoOrigemInicialNavigation)
                .HasForeignKey(d => d.InitialOriginDocumentTypeId)
                .HasConstraintName("FK_tbCCStockArtigos_tbTiposDocumentoOrigemInicial");

            builder.HasOne(d => d.EntityType)
                .WithMany(p => p.CurrentAccountStockProduct)
                .HasForeignKey(d => d.EntityTypeId)
                .HasConstraintName("FK_tbCCStockArtigos_IDTipoEntidade");

            builder.HasOne(d => d.DocumentTypeSeries)
                .WithMany(p => p.TbCcstockArtigosIdtiposDocumentoSeriesNavigation)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .HasConstraintName("FK_tbCCStockArtigos_tbTiposDocumentoSeries");

            builder.HasOne(d => d.OriginDocumentTypeSeries)
                .WithMany(p => p.TbCcstockArtigosIdtiposDocumentoSeriesOrigemNavigation)
                .HasForeignKey(d => d.OriginDocumentTypeSeriesId)
                .HasConstraintName("FK_tbCCStockArtigos_tbTiposDocumentoSeriesOrigem");
        }
    }
}
