using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class CountryMap : IEntityTypeConfiguration<Country>
    {
        public void Configure(EntityTypeBuilder<Country> builder)
        {
            builder.ToTable("tbPaises");

            builder.HasIndex(e => e.AcronymId)
                .HasName("IX_tbPaisesSigla");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.IsActive)
                .IsRequired()
                .HasColumnName("Ativo")
                .HasDefaultValueSql("((1))");

            builder.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            builder.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            builder.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            builder.Property(e => e.Description)
                .HasColumnName("Descricao");

            builder.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20);

            builder.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20);

            builder.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");

            builder.Property(e => e.AcronymId)
                .HasColumnName("IDSigla");

            builder.Property(e => e.AccountingVariable)
                .HasColumnName("VariavelContabilidade")
                .HasMaxLength(20);

            builder.HasOne(d => d.Acronym)
                .WithMany(p => p.TbPaises)
                .HasForeignKey(d => d.AcronymId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbPaises_IDSigla");
        }
    }
}
