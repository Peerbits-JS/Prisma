using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class VatMap : IEntityTypeConfiguration<Vat>
    {
        public void Configure(EntityTypeBuilder<Vat> entity)
        {
            entity.ToTable("tbIVA");

            entity.HasIndex(e => e.Code).HasName("IX_tbIVA").IsUnique();

            entity.HasIndex(e => e.Id).HasName("IX_tbIVA_1");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Code).HasColumnName("Codigo").IsRequired().HasMaxLength(6);

            entity.Property(e => e.Description).HasColumnName("Descricao").IsRequired().HasMaxLength(50);

            entity.Property(e => e.SystemVatCodeId).HasColumnName("IDCodigoIva");

            entity.Property(e => e.IdtipoIva).HasColumnName("IDTipoIva");

            entity.Property(e => e.Mencao).HasMaxLength(255);

            entity.Property(e => e.Tax).HasColumnType("decimal(5, 2)");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.HasOne(d => d.SystemVatCode)
                .WithMany(p => p.Vat)
                .HasForeignKey(d => d.SystemVatCodeId)
                .HasConstraintName("FK_tbIVA_tbSistemaCodigosIVA");

            entity.HasOne(d => d.SystemVatType)
                .WithMany(p => p.Vat)
                .HasForeignKey(d => d.IdtipoIva)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbIVA_tbSistemaTiposIVA");
        }
    }
}
