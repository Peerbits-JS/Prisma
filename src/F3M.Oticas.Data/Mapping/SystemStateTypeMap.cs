using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class SystemStateTypesMap : IEntityTypeConfiguration<SystemStateType>
    {
        public void Configure(EntityTypeBuilder<SystemStateType> entity)
        {
            entity.ToTable("tbSistemaTiposEstados");

            entity.Property(e => e.Id).HasColumnName("ID").ValueGeneratedNever();

            entity.Property(e => e.Code).HasColumnName("Codigo").IsRequired().HasMaxLength(6);

            entity.Property(e => e.Color).HasColumnName("Cor").HasMaxLength(50);

            entity.Property(e => e.Description).HasColumnName("Descricao").IsRequired().HasMaxLength(50);

            entity.Property(e => e.EntityStateId).HasColumnName("IDEntidadeEstado");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.HasOne(d => d.SystemEntityStates)
                .WithMany(p => p.SystemStateType)
                .HasForeignKey(d => d.EntityStateId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbSistemaTiposEstados_tbSistemaEntidadesEstados");
        }
    }
}