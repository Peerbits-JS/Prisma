using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class ProviderMap : IEntityTypeConfiguration<TbFornecedores>
    {
        public void Configure(EntityTypeBuilder<TbFornecedores> entity)
        {
            entity.ToTable("tbFornecedores");

            entity.HasIndex(e => e.Codigo)
                .HasName("IX_tbFornecedoresCodigo")
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Abreviatura).HasMaxLength(50);

            entity.Property(e => e.Apelido).HasMaxLength(50);

            entity.Property(e => e.CartaoCidadao).HasMaxLength(25);

            entity.Property(e => e.CodIq)
                .HasColumnName("CodIQ")
                .HasMaxLength(10);

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(20);

            entity.Property(e => e.Contabilidade).HasMaxLength(20);

            entity.Property(e => e.DataNascimento).HasColumnType("date");

            entity.Property(e => e.DataValidade).HasColumnType("date");

            entity.Property(e => e.Foto).HasMaxLength(255);

            entity.Property(e => e.IdcondicaoPagamento).HasColumnName("IDCondicaoPagamento");

            entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            entity.Property(e => e.Idfornecimento).HasColumnName("IDFornecimento");

            entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            entity.Property(e => e.IdlocalOperacao).HasColumnName("IDLocalOperacao");

            entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            entity.Property(e => e.Idpais).HasColumnName("IDPais");

            entity.Property(e => e.Idprofissao).HasColumnName("IDProfissao");

            entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            entity.Property(e => e.Idsexo).HasColumnName("IDSexo");

            entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            entity.Property(e => e.IdtipoPessoa).HasColumnName("IDTipoPessoa");

            entity.Property(e => e.Ncontribuinte)
                .HasColumnName("NContribuinte")
                .HasMaxLength(25);

            entity.Property(e => e.Nib)
                .HasColumnName("NIB")
                .HasMaxLength(30);

            entity.Property(e => e.Nome)
                .IsRequired()
                .HasMaxLength(200);

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

            entity.HasOne(d => d.IdcondicaoPagamentoNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.IdcondicaoPagamento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbFornecedores_tbCondicoesPagamento");

            entity.HasOne(d => d.IdespacoFiscalNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.IdespacoFiscal)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbFornecedores_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.IdformaPagamentoNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.IdformaPagamento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbFornecedores_tbFormasPagamento");

            entity.HasOne(d => d.IdidiomaNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.Ididioma)
                .HasConstraintName("FK_tbFornecedores_tbIdiomas");

            entity.HasOne(d => d.IdlocalOperacaoNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.IdlocalOperacao)
                .HasConstraintName("FK_tbFornecedores_tbSistemaRegioesIVA");

            entity.HasOne(d => d.IdlojaNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.Idloja)
                .HasConstraintName("FK_tbFornecedores_tbLojas");

            entity.HasOne(d => d.IdmoedaNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.Idmoeda)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbFornecedores_tbMoedas");

            entity.HasOne(d => d.IdpaisNavigation)
                .WithMany(p => p.Providers)
                .HasForeignKey(d => d.Idpais)
                .HasConstraintName("FK_tbFornecedores_tbPaises");

            entity.HasOne(d => d.IdprofissaoNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.Idprofissao)
                .HasConstraintName("FK_tbFornecedores_tbProfissoes");

            entity.HasOne(d => d.IdregimeIvaNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.IdregimeIva)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbFornecedores_tbSistemaRegimeIVA");

            entity.HasOne(d => d.IdsexoNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.Idsexo)
                .HasConstraintName("FK_tbFornecedores_tbSistemaSexo");

            entity.HasOne(d => d.IdtipoEntidadeNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.IdtipoEntidade)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbFornecedores_tbSistemaTiposEntidade");

            entity.HasOne(d => d.IdtipoPessoaNavigation)
                .WithMany(p => p.TbFornecedores)
                .HasForeignKey(d => d.IdtipoPessoa)
                .HasConstraintName("FK_tbFornecedores_tbSistemaTiposPessoa");
        }
    }
}
