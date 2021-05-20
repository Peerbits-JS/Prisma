using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class ProductWarehouseLocationMap : IEntityTypeConfiguration<TbArtigosArmazensLocalizacoes>
    {
        public void Configure(EntityTypeBuilder<TbArtigosArmazensLocalizacoes> entity)
        {
            entity.ToTable("tbArtigosArmazensLocalizacoes");

            entity.Property(e => e.Id)
                .HasColumnName("ID");

            entity.Property(e => e.WareHouseId)
                .HasColumnName("IDArmazem");

            entity.Property(e => e.WarehouseLocationId)
                .HasColumnName("IDArmazemLocalizacao");

            entity.Property(e => e.ProductId)
                .HasColumnName("IDArtigo");

            entity.Property(e => e.IsDefault)
                .HasColumnName("PorDefeito");

            entity.Property(e => e.Order)
                .HasColumnName("Ordem");

            entity.Property(e => e.IsActive)
              .IsRequired()
              .HasColumnName("Ativo")
              .HasDefaultValueSql("((1))");

            entity.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            entity.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20);

            entity.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20);

            entity.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");

            entity.HasOne(d => d.Warehouse)
                .WithMany(p => p.TbArtigosArmazensLocalizacoes)
                .HasForeignKey(d => d.WareHouseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigosArmazensLocalizacoes_tbArmazens");

            entity.HasOne(d => d.WarehouseLocation)
                .WithMany(p => p.TbArtigosArmazensLocalizacoes)
                .HasForeignKey(d => d.WarehouseLocationId)
                .HasConstraintName("FK_tbArtigosArmazensLocalizacoes_tbArmazensLocalizacoes");

            entity.HasOne(d => d.Product)
                .WithMany(p => p.WarehouseLocations)
                .HasForeignKey(d => d.ProductId)
                .HasConstraintName("FK_tbArtigosArmazensLocalizacoes_tbArtigos");
        }
    }
}
