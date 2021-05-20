using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class TaxAuthorityProductMap : IEntityTypeConfiguration<TaxAuthorityComunicationProduct>
    {
        public void Configure(EntityTypeBuilder<TaxAuthorityComunicationProduct> builder)
        {
            builder.ToTable("tbComunicacaoAutoridadeTributariaLinhas");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.IsActive)
                .HasColumnName("Ativo")
                .IsRequired()
                .HasDefaultValueSql("((1))");

            builder.Property(e => e.Category)
                .HasColumnName("Categoria")
                .HasMaxLength(20)
                .IsUnicode(false);

            builder.Property(e => e.ProductCode)
                .HasColumnName("CodigoArtigo")
                .IsRequired()
                .HasMaxLength(255);

            builder.Property(e => e.BarCode)
                .HasColumnName("CodigoDeBarras")
                .HasMaxLength(50);

            builder.Property(e => e.UnitCode)
                .HasColumnName("CodigoUnidade")
                .IsRequired()
                .HasMaxLength(255)
                .IsUnicode(false);

            builder.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            builder.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            builder.Property(e => e.ProductDescription)
                .HasColumnName("DescricaoArtigo")
                .IsRequired()
                .HasMaxLength(255);

            builder.Property(e => e.UnitDescription)
                .HasColumnName("DescricaoUnidade")
                .IsRequired()
                .HasMaxLength(255)
                .IsUnicode(false);

            builder.Property(x => x.StockQuantity)
                .HasColumnName("QuantidadeEmStock");

            builder.Property(x => x.StockValue)
                .HasColumnName("ValorEmStock");

            builder.Property(x => x.Order)
                .HasColumnName("Ordem");

            builder.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            builder.Property(e => e.ProductId)
                .HasColumnName("IDArtigo");

            builder.Property(e => e.TaxAuthorityComunicationId)
                .HasColumnName("IDComunicacaoAutoridadeTributaria");

            builder.Property(e => e.UnitId)
                .HasColumnName("IDUnidade");

            builder.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime");

            builder.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            builder.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            builder.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");

            builder.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20);

            builder.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20);

            builder.HasOne(d => d.Product)
                .WithMany(p => p.TaxAuthorityComunicationProducts)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbComunicacaoAutoridadeTributariaLinhas_tbArtigos");

            builder.HasOne(d => d.TaxAuthorityComunication)
                .WithMany(p => p.TaxAuthorityComunicationProducts)
                .HasForeignKey(d => d.TaxAuthorityComunicationId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_tbComunicacaoAutoridadeTributariaLinhas_tbComunicacaoAutoridadeTributaria");

            builder.HasOne(d => d.Unit)
                .WithMany(p => p.TbComunicacaoAutoridadeTributariaLinhas)
                .HasForeignKey(d => d.UnitId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbComunicacaoAutoridadeTributariaLinhas_tbUnidades");
        }
    }
}
