using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class ProductMap : IEntityTypeConfiguration<Product>
    {
        public void Configure(EntityTypeBuilder<Product> builder)
        {
            builder.ToTable("tbArtigos");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.Code)
                .IsRequired()
                .HasColumnName("Codigo")
                .HasMaxLength(20);

            builder.HasIndex(e => e.Code)
                .HasName("IX_tbArtigosCodigo")
                .IsUnique();

            builder.HasIndex(e => e.IsActive)
                .HasName("IX_tbArtigosAtivo");

            builder.Property(e => e.IsActive)
               .IsRequired()
               .HasColumnName("Ativo")
               .HasDefaultValueSql("((1))");

            builder.Property(e => e.FamilyId)
                .HasColumnName("IDFamilia");

            builder.Property(e => e.SubFamilyId)
                .HasColumnName("IDSubFamilia");

            builder.Property(e => e.ProductTypeId)
                .HasColumnName("IDTipoArtigo");

            builder.Property(e => e.CompositionId)
                .HasColumnName("IDComposicao");

            builder.Property(e => e.CompositionTypeId)
                .HasColumnName("IDTipoComposicao");

            builder.Property(e => e.ProductGroupId)
                .HasColumnName("IDGrupoArtigo");

            builder.Property(e => e.BrandId)
                .HasColumnName("IDMarca");

            builder.Property(e => e.BarCode)
                .HasColumnName("CodigoBarras")
                .HasMaxLength(50);

            builder.Property(e => e.Qrcode)
                .HasColumnName("QRCode")
                .HasMaxLength(50);

            builder.Property(e => e.Description)
                .HasColumnName("Descricao")
                .IsRequired()
                .HasMaxLength(200);

            builder.Property(e => e.ShortDescription)
                .HasColumnName("DescricaoAbreviada")
                .HasMaxLength(20);

            builder.Property(x => x.Observation)
                .HasColumnName("Observacoes");

            builder.Property(x => x.CanManageLot)
                .HasColumnName("GereLotes");

            builder.Property(x => x.CanManageStock)
                .HasColumnName("GereStock");

            builder.Property(x => x.CanManageSerialNumber)
                .HasColumnName("GereNumeroSerie");

            builder.Property(x => x.HasVariableDescription)
                .HasColumnName("DescricaoVariavel");

            builder.Property(e => e.OrderLotPresentId)
                .HasColumnName("IDOrdemLoteApresentar");

            builder.Property(e => e.UnitId)
                .HasColumnName("IDUnidade");

            builder.Property(e => e.SalesUnitId)
                .HasColumnName("IDUnidadeVenda");

            builder.Property(e => e.PurchaseUnitId)
                .HasColumnName("IDUnidadeCompra");

            builder.Property(e => e.VariableAccounting)
                .HasColumnName("VariavelContabilidade")
                .HasMaxLength(20);

            builder.Property(e => e.StationId)
                .HasColumnName("IDEstacao");

            builder.Property(e => e.StatisticalCode)
                .HasColumnName("CodigoEstatistico")
                .HasMaxLength(25);

            builder.Property(x => x.MaximumLimit)
                .HasColumnName("LimiteMax");

            builder.Property(x => x.MinimumLimit)
                .HasColumnName("LimiteMin");

            builder.Property(x => x.Reposition)
                .HasColumnName("Reposicao");

            builder.Property(e => e.OrderLotMovementEntryId)
                .HasColumnName("IDOrdemLoteMovEntrada");

            builder.Property(e => e.OrderLotOutputMovementId)
                .HasColumnName("IDOrdemLoteMovSaida");

            builder.Property(e => e.TaxId)
                .HasColumnName("IDTaxa");

            builder.Property(x => x.DeductivePercentage)
                .HasColumnName("DedutivelPercentagem");

            builder.Property(x => x.IncidencePercentage)
                .HasColumnName("IncidenciaPercentagem");

            builder.Property(x => x.LastCostPrice)
                .HasColumnName("UltimoPrecoCusto");

            builder.Property(x => x.AveragePrice)
                .HasColumnName("Medio");

            builder.Property(x => x.DefaultPrice)
                .HasColumnName("Padrao");

            builder.Property(x => x.LatestAdditionalCosts)
                .HasColumnName("UltimosCustosAdicionais");

            builder.Property(x => x.LatestCommercialDiscounts)
                .HasColumnName("UltimosDescontosComerciais");

            builder.Property(x => x.LastPurchasePrice)
                .HasColumnName("UltimoPrecoCompra");

            builder.Property(e => e.TotalQuantityVSUPC)
                .HasColumnName("TotalQuantidadeVSUPC");

            builder.Property(e => e.TotalQuantityVSPCM)
                .HasColumnName("TotalQuantidadeVSPCM");

            builder.Property(e => e.TotalQuantityDefaultVSPC)
                .HasColumnName("TotalQuantidadeVSPCPadrao");

            builder.Property(e => e.CompoundTransformationMethodCostId)
                .HasColumnName("IDCompostoTransformacaoMetodoCusto");

            builder.Property(e => e.TaxStampId)
                .HasColumnName("IDImpostoSelo");

            builder.Property(e => e.FTOFPercentageFactor)
                .HasColumnName("FatorFTOFPercentagem");

            builder.Property(e => e.Picture)
                .HasColumnName("Foto")
                .HasMaxLength(255);

            builder.Property(x => x.PicturePath)
                .HasColumnName("FotoCaminho");

            builder.Property(e => e.SecondUnitStockId)
                .HasColumnName("IDUnidadeStock2");

            builder.Property(e => e.TypePriceId)
                .HasColumnName("IDTipoPreco")
                .HasDefaultValueSql("((1))");

            builder.Property(e => e.TaxAuthorityCode)
                .HasColumnName("CodigoAT")
                .HasMaxLength(20);

            builder.Property(e => e.SupplierReference)
                .HasColumnName("ReferenciaFornecedor")
                .HasMaxLength(50);

            builder.Property(e => e.SupplierBarCode)
                .HasColumnName("CodigoBarrasFornecedor")
                .HasMaxLength(50);

            builder.Property(e => e.ClassificationSystemId)
                .HasColumnName("IDSistemaClassificacao");

            builder.Property(e => e.UpcDocumentTypeId)
                .HasColumnName("IDTipoDocumentoUPC");

            builder.Property(e => e.UpcDocumentId)
                .HasColumnName("IDDocumentoUPC");

            builder.Property(e => e.UpcDateControl)
                .HasColumnName("DataControloUPC")
                .HasColumnType("datetime");

            builder.Property(e => e.CanRecalculateUpc)
                .HasColumnName("RecalculaUPC");

            builder.HasIndex(e => e.BarCode)
                .HasName("IX_tbArtigosCodigoBarras");

            builder.HasIndex(e => e.Description)
                .HasName("IX_tbArtigosDescricao");

            builder.HasIndex(e => new { e.Code, e.Description })
                .HasName("IX_tbArtigosCodigoDescricao");

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

            builder.Property(e => e.IsInventory)
               .HasColumnName("Inventariado")
               .HasDefaultValueSql("((1))");

            builder.HasOne(d => d.Composition)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.CompositionId)
                .HasConstraintName("FK_tbArtigos_tbComposicoes");

            builder.HasOne(d => d.CompoundTransformationMethodCost)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.CompoundTransformationMethodCostId)
                .HasConstraintName("FK_tbArtigos_tbSistemaCompostoTransformacaoMetodoCusto");

            builder.HasOne(d => d.Station)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.StationId)
                .HasConstraintName("FK_tbArtigos_tbEstacoes");

            builder.HasOne(d => d.Family)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.FamilyId)
                .HasConstraintName("FK_tbArtigos_tbFamilias");

            builder.HasOne(d => d.ProductGroup)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.ProductGroupId)
                .HasConstraintName("FK_tbArtigos_tbGruposArtigo");

            builder.HasOne(d => d.TaxStamp)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.TaxStampId)
                .HasConstraintName("FK_tbArtigos_tbImpostoSelo");

            builder.HasOne(d => d.Brand)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.BrandId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigos_tbMarcas");

            builder.HasOne(d => d.OrderLotPresent)
                .WithMany(p => p.TbArtigosIdordemLoteApresentarNavigation)
                .HasForeignKey(d => d.OrderLotPresentId)
                .HasConstraintName("FK_tbArtigos_tbSistemaOrdemLotes");

            builder.HasOne(d => d.OrderLotMovementEntry)
                .WithMany(p => p.TbArtigosIdordemLoteMovEntradaNavigation)
                .HasForeignKey(d => d.OrderLotMovementEntryId)
                .HasConstraintName("FK_tbArtigos_tbSistemaOrdemLotes1");

            builder.HasOne(d => d.OrderLotOutputMovement)
                .WithMany(p => p.TbArtigosIdordemLoteMovSaidaNavigation)
                .HasForeignKey(d => d.OrderLotOutputMovementId)
                .HasConstraintName("FK_tbArtigos_tbSistemaOrdemLotes2");

            builder.HasOne(d => d.ClassificationSystem)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.ClassificationSystemId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigos_tbSistemaClassificacoesTiposArtigos");

            builder.HasOne(d => d.SubFamily)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.SubFamilyId)
                .HasConstraintName("FK_tbArtigos_tbSubFamilias");

            builder.HasOne(d => d.Tax)
                .WithMany(p => p.Product)
                .HasForeignKey(d => d.TaxId)
                .HasConstraintName("FK_tbArtigos_tbIVA");

            builder.HasOne(d => d.ProductType)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.ProductTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigos_tbTiposArtigos");

            builder.HasOne(d => d.CompositionType)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.CompositionTypeId)
                .HasConstraintName("FK_tbArtigos_tbSistemaTiposComposicoes");

            builder.HasOne(d => d.UpcDocumentType)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.UpcDocumentTypeId)
                .HasConstraintName("FK_tbArtigos_IDTipoDocumento");

            builder.HasOne(d => d.TypePrice)
                .WithMany(p => p.TbArtigos)
                .HasForeignKey(d => d.TypePriceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigos_tbSistemaTiposPrecos");

            builder.HasOne(d => d.Unit)
                .WithMany(p => p.TbArtigosIdunidadeNavigation)
                .HasForeignKey(d => d.UnitId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigos_tbUnidades");

            builder.HasOne(d => d.PurchaseUnit)
                .WithMany(p => p.TbArtigosIdunidadeCompraNavigation)
                .HasForeignKey(d => d.PurchaseUnitId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigos_tbUnidades_Compra");

            builder.HasOne(d => d.SecondUnitStock)
                .WithMany(p => p.TbArtigosIdunidadeStock2Navigation)
                .HasForeignKey(d => d.SecondUnitStockId)
                .HasConstraintName("FK_tbArtigos_tbUnidadesStock2");

            builder.HasOne(d => d.SalesUnit)
                .WithMany(p => p.TbArtigosIdunidadeVendaNavigation)
                .HasForeignKey(d => d.SalesUnitId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigos_tbUnidades_Venda");
        }
    }
}
