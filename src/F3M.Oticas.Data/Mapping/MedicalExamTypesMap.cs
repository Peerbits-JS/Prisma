using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class MedicalExamTypesMap : IEntityTypeConfiguration<TbTiposConsultas>
    {
        public void Configure(EntityTypeBuilder<TbTiposConsultas> entity)
        {
            entity.ToTable("tbTiposConsultas");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(10);

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            entity.Property(e => e.IdmapaVista1).HasColumnName("IDMapaVista1");

            entity.Property(e => e.IdmapaVista2).HasColumnName("IDMapaVista2");

            entity.Property(e => e.Idtemplate).HasColumnName("IDTemplate");

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.HasOne(d => d.IdlojaNavigation)
                .WithMany(p => p.TbTiposConsultas)
                .HasForeignKey(d => d.Idloja)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbTiposConsultas_tbLojas");

            entity.HasOne(d => d.IdmapaVista1Navigation)
                .WithMany(p => p.TbTiposConsultasIdmapaVista1Navigation)
                .HasForeignKey(d => d.IdmapaVista1)
                .HasConstraintName("FK_tbTiposConsultas_tbMapasVistas1");

            entity.HasOne(d => d.IdmapaVista2Navigation)
                .WithMany(p => p.TbTiposConsultasIdmapaVista2Navigation)
                .HasForeignKey(d => d.IdmapaVista2)
                .HasConstraintName("FK_tbTiposConsultas_tbMapasVistas2");

            entity.HasOne(d => d.IdtemplateNavigation)
                .WithMany(p => p.TbTiposConsultas)
                .HasForeignKey(d => d.Idtemplate)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbTiposConsultas_tbTemplates");
        }
    }
}