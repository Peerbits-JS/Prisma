using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class SystemEntityTypeMap : IEntityTypeConfiguration<SystemEntityType>
    {
        public void Configure(EntityTypeBuilder<SystemEntityType> entity)
        {
            entity.ToTable("tbSistemaTiposEntidade");

            entity.Property(e => e.Id).HasColumnName("ID").ValueGeneratedNever();

            entity.Property(e => e.Code).HasColumnName("Codigo").IsRequired().HasMaxLength(25);

            entity.Property(e => e.Entity).HasColumnName("Entidade").IsRequired().HasMaxLength(50);

            entity.Property(e => e.Type).HasColumnName("Tipo").IsRequired().HasMaxLength(50);

            entity.Property(e => e.TypeAux).HasColumnName("TipoAux").HasMaxLength(50);

            entity.Property(e => e.IsDefault).HasColumnName("PorDefeito");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();
        }
    }
}