using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class StockDocumentLineMap : IEntityTypeConfiguration<StockDocumentLine>
    {
        public void Configure(EntityTypeBuilder<StockDocumentLine> entity)
        {
            entity.ToTable("tbDocumentosStockLinhas");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.ArtigoNumSerie).HasMaxLength(20);

            entity.Property(e => e.CodigoArtigo).HasMaxLength(255);

            entity.Property(e => e.CodigoBarrasArtigo).HasMaxLength(255);

            entity.Property(e => e.CodigoLote).HasMaxLength(50);

            entity.Property(e => e.CodigoMotivoIsencaoIva).HasMaxLength(6);

            entity.Property(e => e.CodigoRegiaoIva).HasMaxLength(20);

            entity.Property(e => e.CodigoTaxaIva).HasMaxLength(6);

            entity.Property(e => e.CodigoTipoIva).HasMaxLength(20);

            entity.Property(e => e.CodigoTipoPreco).HasMaxLength(6);

            entity.Property(e => e.CodigoUnidade).HasMaxLength(20);

            entity.Property(e => e.DataDocOrigem).HasColumnType("datetime");

            entity.Property(e => e.DataEntrega).HasColumnType("datetime");

            entity.Property(e => e.DataFabricoLote).HasColumnType("datetime");

            entity.Property(e => e.DataValidadeLote).HasColumnType("datetime");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(200);

            entity.Property(e => e.DescricaoLote).HasMaxLength(100);

            entity.Property(e => e.DocumentoOrigem).HasMaxLength(255);

            entity.Property(e => e.DocumentoOrigemInicial).HasMaxLength(255);

            entity.Property(e => e.EspacoFiscal).HasMaxLength(50);

            entity.Property(e => e.Idarmazem).HasColumnName("IDArmazem");

            entity.Property(e => e.IdarmazemDestino).HasColumnName("IDArmazemDestino");

            entity.Property(e => e.IdarmazemLocalizacao).HasColumnName("IDArmazemLocalizacao");

            entity.Property(e => e.IdarmazemLocalizacaoDestino).HasColumnName("IDArmazemLocalizacaoDestino");

            entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            entity.Property(e => e.IdartigoNumSerie).HasColumnName("IDArtigoNumSerie");

            entity.Property(e => e.IdartigoPa).HasColumnName("IDArtigoPA");

            entity.Property(e => e.IdartigoPara).HasColumnName("IDArtigoPara");

            entity.Property(e => e.IdcodigoIva).HasColumnName("IDCodigoIva");

            entity.Property(e => e.IddocumentoOrigem).HasColumnName("IDDocumentoOrigem");

            entity.Property(e => e.IddocumentoOrigemInicial).HasColumnName("IDDocumentoOrigemInicial");

            entity.Property(e => e.IddocumentoStock).HasColumnName("IDDocumentoStock");

            entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.IdlinhaDocumentoOrigem).HasColumnName("IDLinhaDocumentoOrigem");

            entity.Property(e => e.IdlinhaDocumentoOrigemInicial).HasColumnName("IDLinhaDocumentoOrigemInicial");

            entity.Property(e => e.IdlinhaDocumentoStock).HasColumnName("IDLinhaDocumentoStock");

            entity.Property(e => e.IdlinhaDocumentoStockInicial).HasColumnName("IDLinhaDocumentoStockInicial");

            entity.Property(e => e.Idlote).HasColumnName("IDLote");

            entity.Property(e => e.Idofartigo).HasColumnName("IDOFArtigo");

            entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            entity.Property(e => e.IdtaxaIva).HasColumnName("IDTaxaIva");

            entity.Property(e => e.IdtipoDocumentoOrigem).HasColumnName("IDTipoDocumentoOrigem");

            entity.Property(e => e.IdtipoDocumentoOrigemInicial).HasColumnName("IDTipoDocumentoOrigemInicial");

            entity.Property(e => e.IdtipoIva).HasColumnName("IDTipoIva");

            entity.Property(e => e.IdtipoPreco).HasColumnName("IDTipoPreco");

            entity.Property(e => e.IdtiposDocumentoSeriesOrigem).HasColumnName("IDTiposDocumentoSeriesOrigem");

            entity.Property(e => e.Idunidade).HasColumnName("IDUnidade");

            entity.Property(e => e.IdunidadeStock).HasColumnName("IDUnidadeStock");

            entity.Property(e => e.IdunidadeStock2).HasColumnName("IDUnidadeStock2");

            entity.Property(e => e.MotivoIsencaoIva).HasMaxLength(255);

            entity.Property(e => e.OperacaoConv2UnidStk).HasMaxLength(50);

            entity.Property(e => e.OperacaoConvUnidStk).HasMaxLength(50);

            entity.Property(e => e.PcmanteriorMoedaRef).HasColumnName("PCMAnteriorMoedaRef");

            entity.Property(e => e.PcmanteriorMoedaRefOrigem).HasColumnName("PCMAnteriorMoedaRefOrigem");

            entity.Property(e => e.PcmatualMoedaRef).HasColumnName("PCMAtualMoedaRef");

            entity.Property(e => e.PvmoedaRef).HasColumnName("PVMoedaRef");

            entity.Property(e => e.RegimeIva).HasMaxLength(50);

            entity.Property(e => e.SiglaPais).HasMaxLength(15);

            entity.Property(e => e.UpcmoedaRef).HasColumnName("UPCMoedaRef");

            entity.Property(e => e.UpcompraMoedaRef).HasColumnName("UPCompraMoedaRef");

            entity.Property(e => e.VossoNumeroDocumentoOrigem).HasMaxLength(256);

            //new
            entity.Property(e => e.VatValue).HasColumnName("ValorIVA");

            entity.Property(e => e.TotalPrice).HasColumnName("PrecoTotal");

            entity.Property(e => e.IncidenceValue).HasColumnName("ValorIncidencia");

            entity.Property(e => e.EffectiveDiscountValueWithoutVat).HasColumnName("ValorDescontoEfetivoSemIva");

            //new
            entity.Property(e => e.CreatedAt)
             .HasColumnName("DataCriacao")
             .HasColumnType("datetime")
             .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem)
                .HasColumnName("Sistema");

            entity.Property(e => e.IsActive)
                .HasColumnName("Ativo")
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.HasOne(d => d.IdarmazemNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdarmazemNavigation)
                .HasForeignKey(d => d.Idarmazem)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbArmazens");

            entity.HasOne(d => d.IdarmazemDestinoNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdarmazemDestinoNavigation)
                .HasForeignKey(d => d.IdarmazemDestino)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbArmazens_Destino");

            entity.HasOne(d => d.IdarmazemLocalizacaoNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdarmazemLocalizacaoNavigation)
                .HasForeignKey(d => d.IdarmazemLocalizacao)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbArmazensLocalizacoes");

            entity.HasOne(d => d.IdarmazemLocalizacaoDestinoNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdarmazemLocalizacaoDestinoNavigation)
                .HasForeignKey(d => d.IdarmazemLocalizacaoDestino)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbArmazensLocalizacoes_Destino");

            entity.HasOne(d => d.IdartigoNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdartigoNavigation)
                .HasForeignKey(d => d.Idartigo)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbArtigos");

            entity.HasOne(d => d.IdartigoNumSerieNavigation)
                .WithMany(p => p.TbDocumentosStockLinhas)
                .HasForeignKey(d => d.IdartigoNumSerie)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbArtigosNumerosSeries");

            entity.HasOne(d => d.IdcodigoIvaNavigation)
                .WithMany(p => p.StockDocumentLine)
                .HasForeignKey(d => d.IdcodigoIva)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbSistemaCodigosIVA");

            entity.HasOne(d => d.IddocumentoStockNavigation)
                .WithMany(p => p.Lines)
                .HasForeignKey(d => d.IddocumentoStock)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbDocumentosStock");

            entity.HasOne(d => d.IdespacoFiscalNavigation)
                .WithMany(p => p.TbDocumentosStockLinhas)
                .HasForeignKey(d => d.IdespacoFiscal)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.IdlinhaDocumentoStockNavigation)
                .WithMany(p => p.InverseIdlinhaDocumentoStockNavigation)
                .HasForeignKey(d => d.IdlinhaDocumentoStock)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbDocumentosStockLinhas");

            entity.HasOne(d => d.IdlinhaDocumentoStockInicialNavigation)
                .WithMany(p => p.InverseIdlinhaDocumentoStockInicialNavigation)
                .HasForeignKey(d => d.IdlinhaDocumentoStockInicial)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbDocumentosStockLinhasInicial");

            entity.HasOne(d => d.IdloteNavigation)
                .WithMany(p => p.TbDocumentosStockLinhas)
                .HasForeignKey(d => d.Idlote)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbArtigosLotes");

            entity.HasOne(d => d.IdregimeIvaNavigation)
                .WithMany(p => p.TbDocumentosStockLinhas)
                .HasForeignKey(d => d.IdregimeIva)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbSistemaRegimeIVA");

            entity.HasOne(d => d.IdtaxaIvaNavigation)
                .WithMany(p => p.StockDocumentLine)
                .HasForeignKey(d => d.IdtaxaIva)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbIVA");

            entity.HasOne(d => d.IdtipoDocumentoOrigemNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdtipoDocumentoOrigemNavigation)
                .HasForeignKey(d => d.IdtipoDocumentoOrigem)
                .HasConstraintName("FK_tbDocumentosStockLinhas_IDTipoDocumentoOrigem");

            entity.HasOne(d => d.IdtipoDocumentoOrigemInicialNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdtipoDocumentoOrigemInicialNavigation)
                .HasForeignKey(d => d.IdtipoDocumentoOrigemInicial)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbTiposDocumentoOrigemInicial");

            entity.HasOne(d => d.SystemVatType)
                .WithMany(p => p.StockDocumentLine)
                .HasForeignKey(d => d.IdtipoIva)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbSistemaTiposIVA");

            entity.HasOne(d => d.IdtipoPrecoNavigation)
                .WithMany(p => p.TbDocumentosStockLinhas)
                .HasForeignKey(d => d.IdtipoPreco)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbSistemaTiposPrecos");

            entity.HasOne(d => d.IdtiposDocumentoSeriesOrigemNavigation)
                .WithMany(p => p.TbDocumentosStockLinhas)
                .HasForeignKey(d => d.IdtiposDocumentoSeriesOrigem)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbTiposDocumentoSeriesOrigem");

            entity.HasOne(d => d.IdunidadeNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdunidadeNavigation)
                .HasForeignKey(d => d.Idunidade)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbUnidades");

            entity.HasOne(d => d.IdunidadeStockNavigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdunidadeStockNavigation)
                .HasForeignKey(d => d.IdunidadeStock)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbUnidades2");

            entity.HasOne(d => d.IdunidadeStock2Navigation)
                .WithMany(p => p.TbDocumentosStockLinhasIdunidadeStock2Navigation)
                .HasForeignKey(d => d.IdunidadeStock2)
                .HasConstraintName("FK_tbDocumentosStockLinhas_tbUnidades3");
        }
    }
}
