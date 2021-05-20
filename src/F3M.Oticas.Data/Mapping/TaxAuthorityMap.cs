using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class TaxAuthorityMap : IEntityTypeConfiguration<TaxAuthorityComunication>
    {
        public void Configure(EntityTypeBuilder<TaxAuthorityComunication> builder)
        {
            builder.ToTable("tbComunicacaoAutoridadeTributaria");

            builder.Property(e => e.Id)
                .HasColumnName("ID");

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

            builder.Property(e => e.Filter)
                .HasColumnName("Filtro")
                .IsRequired()
                .HasColumnType("text");

            builder.Property(e => e.Observations)
                .HasColumnName("Observacoes")
                .HasColumnType("text");

            builder.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20);

            builder.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20);

            builder.Property(e => e.IsActive)
                .HasColumnName("Ativo")
                .IsRequired()
                .HasDefaultValueSql("((1))");
        }
    }
}
