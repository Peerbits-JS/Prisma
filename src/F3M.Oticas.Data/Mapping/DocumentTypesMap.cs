using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class DocumentTypesMap : IEntityTypeConfiguration<DocumentTypes>
    {
        public void Configure(EntityTypeBuilder<DocumentTypes> builder)
        {
            builder.ToTable("tbTiposDocumento");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.Code)
                .IsRequired()
                .HasColumnName("Codigo")
                .HasMaxLength(6);

            builder.Property(e => e.Description)
                .IsRequired()
                .HasColumnName("Descricao")
                .HasMaxLength(50);

            builder.Property(e => e.ModuleId)
                .HasColumnName("IDModulo");

            builder.Property(e => e.FiscalDocumentTypesId)
                .HasColumnName("IDSistemaTiposDocumentoFiscal");

        }
    }
}
