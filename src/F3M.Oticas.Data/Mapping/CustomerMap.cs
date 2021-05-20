using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class CustomerMap : IEntityTypeConfiguration<TbClientes>
    {
        public void Configure(EntityTypeBuilder<TbClientes> entity)
        {
            entity.ToTable("tbClientes");

            entity.HasIndex(e => e.Codigo)
                .HasName("IX_tbClientesCodigo")
                .IsUnique();

            entity.Property(e => e.Id)
                .HasColumnName("ID")
                .ValueGeneratedOnAdd();

            entity.Property(e => e.Abreviatura).HasMaxLength(50);

            entity.Property(e => e.Apelido).HasMaxLength(50);

            entity.Property(e => e.CartaoCidadao).HasMaxLength(25);

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(20);

            entity.Property(e => e.Contabilidade).HasMaxLength(20);

            entity.Property(e => e.DataNascimento).HasColumnType("date");

            entity.Property(e => e.DataValidade).HasColumnType("date");

            entity.Property(e => e.Foto).HasMaxLength(255);

            entity.Property(e => e.IdcondicaoPagamento).HasColumnName("IDCondicaoPagamento");

            entity.Property(e => e.IdemissaoFatura).HasColumnName("IDEmissaoFatura");

            entity.Property(e => e.IdemissaoPackingList).HasColumnName("IDEmissaoPackingList");

            entity.Property(e => e.Identidade1).HasColumnName("IDEntidade1");

            entity.Property(e => e.Identidade2).HasColumnName("IDEntidade2");

            entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.IdformaExpedicao).HasColumnName("IDFormaExpedicao");

            entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            entity.Property(e => e.IdlocalOperacao).HasColumnName("IDLocalOperacao");

            entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            entity.Property(e => e.Idpais).HasColumnName("IDPais");

            entity.Property(e => e.IdprecoSugerido).HasColumnName("IDPrecoSugerido");

            entity.Property(e => e.Idprofissao).HasColumnName("IDProfissao");

            entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            entity.Property(e => e.IdsegmentoMercado).HasColumnName("IDSegmentoMercado");

            entity.Property(e => e.IdsetorAtividade).HasColumnName("IDSetorAtividade");

            entity.Property(e => e.Idsexo).HasColumnName("IDSexo");

            entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            entity.Property(e => e.IdtipoPessoa).HasColumnName("IDTipoPessoa");

            entity.Property(e => e.Idvendedor).HasColumnName("IDVendedor");

            entity.Property(e => e.Ncontribuinte)
                .IsRequired()
                .HasColumnName("NContribuinte")
                .HasMaxLength(25);

            entity.Property(e => e.Nib)
                .HasColumnName("NIB")
                .HasMaxLength(30);

            entity.Property(e => e.NmaximoDiasAtraso).HasColumnName("NMaximoDiasAtraso");

            entity.Property(e => e.Nome)
                .IsRequired()
                .HasMaxLength(200);

            entity.Property(e => e.NumeroBeneficiario1).HasMaxLength(50);

            entity.Property(e => e.NumeroBeneficiario2).HasMaxLength(50);

            entity.Property(e => e.Parentesco1).HasMaxLength(50);

            entity.Property(e => e.Parentesco2).HasMaxLength(50);

            entity.Property(e => e.TituloAcademico).HasMaxLength(50);

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


            entity.HasOne(d => d.IdNavigation)
                .WithOne(p => p.InverseIdNavigation)
                .HasForeignKey<TbClientes>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbClientes");

            entity.HasOne(d => d.IdcondicaoPagamentoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdcondicaoPagamento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbCondicoesPagamento");

            entity.HasOne(d => d.IdemissaoFaturaNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdemissaoFatura)
                .HasConstraintName("FK_tbClientes_tbSistemaEmissaoFatura");

            entity.HasOne(d => d.IdemissaoPackingListNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdemissaoPackingList)
                .HasConstraintName("FK_tbClientes_tbSistemaEmissaoPackingList");

            entity.HasOne(d => d.Identidade1Navigation)
                .WithMany(p => p.TbClientesIdentidade1Navigation)
                .HasForeignKey(d => d.Identidade1)
                .HasConstraintName("FK_tbClientes_tbEntidades1");

            entity.HasOne(d => d.Identidade2Navigation)
                .WithMany(p => p.TbClientesIdentidade2Navigation)
                .HasForeignKey(d => d.Identidade2)
                .HasConstraintName("FK_tbClientes_tbEntidades2");

            entity.HasOne(d => d.IdespacoFiscalNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdespacoFiscal)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.IdformaExpedicaoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdformaExpedicao)
                .HasConstraintName("FK_tbClientes_tbFormasExpedicao");

            entity.HasOne(d => d.IdformaPagamentoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdformaPagamento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbFormasPagamento");

            entity.HasOne(d => d.IdidiomaNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.Ididioma)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbIdiomas");

            entity.HasOne(d => d.IdlocalOperacaoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdlocalOperacao)
                .HasConstraintName("FK_tbClientes_tbSistemaRegioesIVA");

            entity.HasOne(d => d.IdlojaNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.Idloja)
                .HasConstraintName("FK_tbClientes_tbLojas");

            entity.HasOne(d => d.IdmedicoTecnicoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdmedicoTecnico)
                .HasConstraintName("FK_tbClientes_tbMedicosTecnicos");

            entity.HasOne(d => d.IdmoedaNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.Idmoeda)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbMoedas");

            entity.HasOne(d => d.IdpaisNavigation)
                .WithMany(p => p.Customers)
                .HasForeignKey(d => d.Idpais)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbPaises");

            entity.HasOne(d => d.IdprecoSugeridoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdprecoSugerido)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbSistemaCodigosPrecos");

            entity.HasOne(d => d.IdprofissaoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.Idprofissao)
                .HasConstraintName("FK_tbClientes_tbProfissoes");

            entity.HasOne(d => d.IdregimeIvaNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdregimeIva)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbSistemaRegimeIVA");

            entity.HasOne(d => d.IdsegmentoMercadoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdsegmentoMercado)
                .HasConstraintName("FK_tbClientes_tbSegmentosMercado");

            entity.HasOne(d => d.IdsetorAtividadeNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdsetorAtividade)
                .HasConstraintName("FK_tbClientes_tbSetoresAtividade");

            entity.HasOne(d => d.IdsexoNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.Idsexo)
                .HasConstraintName("FK_tbClientes_tbSistemaSexo");

            entity.HasOne(d => d.IdtipoEntidadeNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdtipoEntidade)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbClientes_tbSistemaTiposEntidade");

            entity.HasOne(d => d.IdtipoPessoaNavigation)
                .WithMany(p => p.TbClientes)
                .HasForeignKey(d => d.IdtipoPessoa)
                .HasConstraintName("FK_tbClientes_tbSistemaTiposPessoa");
        }
    }
}
