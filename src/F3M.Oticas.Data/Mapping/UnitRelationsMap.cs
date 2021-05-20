using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class UnitRelationsMap : IEntityTypeConfiguration<TbUnidadesRelacoes>
    {
        public void Configure(EntityTypeBuilder<TbUnidadesRelacoes> entity)
        {
            entity.ToTable("tbUnidadesRelacoes");

            entity.HasIndex(e => new { e.Idunidade, e.IdunidadeConversao })
                .HasName("IX_tbUnidadesRelacoes")
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

            entity.Property(e => e.Idunidade).HasColumnName("IDUnidade");

            entity.Property(e => e.IdunidadeConversao).HasColumnName("IDUnidadeConversao");

            entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256);

            entity.HasOne(d => d.IdunidadeNavigation)
                .WithMany(p => p.TbUnidadesRelacoesIdunidadeNavigation)
                .HasForeignKey(d => d.Idunidade)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbUnidadesRelacoes_tbUnidades");

            entity.HasOne(d => d.IdunidadeConversaoNavigation)
                .WithMany(p => p.TbUnidadesRelacoesIdunidadeConversaoNavigation)
                .HasForeignKey(d => d.IdunidadeConversao)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbUnidadesRelacoes_tbUnidades_Conversao");
        }
    }
}
