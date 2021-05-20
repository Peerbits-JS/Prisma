using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class UnitProductMap : IEntityTypeConfiguration<TbArtigosUnidades>
    {
        public void Configure(EntityTypeBuilder<TbArtigosUnidades> entity)
        {
            entity.ToTable("tbArtigosUnidades");

            entity.HasIndex(e => new { e.Idunidade, e.IdunidadeConversao, e.Idartigo })
                .HasName("IX_tbArtigosUnidades")
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            entity.Property(e => e.Idunidade).HasColumnName("IDUnidade");

            entity.Property(e => e.IdunidadeConversao).HasColumnName("IDUnidadeConversao");

            entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(20);

            entity.HasOne(d => d.IdartigoNavigation)
                .WithMany(p => p.Units)
                .HasForeignKey(d => d.Idartigo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigosUnidades_tbArtigos");

            entity.HasOne(d => d.IdunidadeNavigation)
                .WithMany(p => p.TbArtigosUnidadesIdunidadeNavigation)
                .HasForeignKey(d => d.Idunidade)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigosUnidades_tbUnidades");

            entity.HasOne(d => d.IdunidadeConversaoNavigation)
                .WithMany(p => p.TbArtigosUnidadesIdunidadeConversaoNavigation)
                .HasForeignKey(d => d.IdunidadeConversao)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigosUnidades_tbUnidades_Conversao");
        }
    }
}
