using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class EntityMap : IEntityTypeConfiguration<TbEntidades>
    {
        public void Configure(EntityTypeBuilder<TbEntidades> entity)
        {
            entity.ToTable("tbEntidades");

            entity.HasIndex(e => e.Codigo)
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Abreviatura).HasMaxLength(50);

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(10);

            entity.Property(e => e.Contabilidade).HasMaxLength(20);

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(100);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Foto).HasMaxLength(255);

            entity.Property(e => e.FotoCaminho).HasMaxLength(4000);

            entity.Property(e => e.IdclienteEntidade).HasColumnName("IDClienteEntidade");

            entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            entity.Property(e => e.IdtipoDescricao).HasColumnName("IDTipoDescricao");

            entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            entity.Property(e => e.Ncontribuinte)
                .HasColumnName("NContribuinte")
                .HasMaxLength(25);

            entity.Property(e => e.Observacoes).HasMaxLength(4000);

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.HasOne(d => d.IdclienteEntidadeNavigation)
                .WithMany(p => p.TbEntidades)
                .HasForeignKey(d => d.IdclienteEntidade)
                .HasConstraintName("FK_tbEntidades_tbClientes");

            entity.HasOne(d => d.IdlojaNavigation)
                .WithMany(p => p.TbEntidades)
                .HasForeignKey(d => d.Idloja)
                .HasConstraintName("FK_tbEntidades_tbLojas");

            entity.HasOne(d => d.IdtipoDescricaoNavigation)
                .WithMany(p => p.TbEntidades)
                .HasForeignKey(d => d.IdtipoDescricao)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbEntidades_tbSistemaEntidadeDescricao");

            entity.HasOne(d => d.IdtipoEntidadeNavigation)
                .WithMany(p => p.TbEntidades)
                .HasForeignKey(d => d.IdtipoEntidade)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbEntidades_tbSistemaEntidadeComparticipacao");
        }
    }
}
