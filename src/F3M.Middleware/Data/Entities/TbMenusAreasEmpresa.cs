using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbMenusAreasEmpresa")]
    public partial class TbMenusAreasEmpresa
    {
        public TbMenusAreasEmpresa()
        {
            InverseIdpaiAreaEmpresaNavigation = new HashSet<TbMenusAreasEmpresa>();
            TbPerfisAcessosAreasEmpresa = new HashSet<TbPerfisAcessosAreasEmpresa>();
        }

        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Column("IDMenuPai")]
        public long IdmenuPai { get; set; }
        [Column("IDEmpresa")]
        public long Idempresa { get; set; }
        [Required]
        [StringLength(50)]
        public string Descricao { get; set; }
        [Required]
        [StringLength(20)]
        public string DescricaoAbreviada { get; set; }
        [Required]
        [StringLength(255)]
        public string Tabela { get; set; }
        public long Ordem { get; set; }
        [StringLength(1000)]
        public string Icon { get; set; }
        [Column("btnContextoConsultar")]
        public bool? BtnContextoConsultar { get; set; }
        [Column("btnContextoAdicionar")]
        public bool? BtnContextoAdicionar { get; set; }
        [Column("btnContextoAlterar")]
        public bool? BtnContextoAlterar { get; set; }
        [Column("btnContextoRemover")]
        public bool? BtnContextoRemover { get; set; }
        [Column("btnContextoImprimir")]
        public bool? BtnContextoImprimir { get; set; }
        [Column("btnContextoExportar")]
        public bool? BtnContextoExportar { get; set; }
        [Column("btnContextoF4")]
        public bool? BtnContextoF4 { get; set; }
        public bool Activo { get; set; }
        public bool Sistema { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime DataCriacao { get; set; }
        [Required]
        [StringLength(256)]
        public string UtilizadorCriacao { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? DataAlteracao { get; set; }
        [StringLength(256)]
        public string UtilizadorAlteracao { get; set; }
        [Column("F3MMarcador")]
        public byte[] F3mmarcador { get; set; }
        [Column("btnContextoImportar")]
        public bool? BtnContextoImportar { get; set; }
        [Column("btnContextoDuplicar")]
        public bool? BtnContextoDuplicar { get; set; }
        [Column("IDPaiAreaEmpresa")]
        public long? IdpaiAreaEmpresa { get; set; }
        [StringLength(50)]
        public string CampoDescricao { get; set; }
        [StringLength(50)]
        public string CampoRelacaoPai { get; set; }

        [ForeignKey(nameof(Idempresa))]
        [InverseProperty(nameof(TbEmpresas.TbMenusAreasEmpresa))]
        public virtual TbEmpresas IdempresaNavigation { get; set; }
        [ForeignKey(nameof(IdmenuPai))]
        [InverseProperty(nameof(TbMenus.TbMenusAreasEmpresa))]
        public virtual TbMenus IdmenuPaiNavigation { get; set; }
        [ForeignKey(nameof(IdpaiAreaEmpresa))]
        [InverseProperty(nameof(TbMenusAreasEmpresa.InverseIdpaiAreaEmpresaNavigation))]
        public virtual TbMenusAreasEmpresa IdpaiAreaEmpresaNavigation { get; set; }
        [InverseProperty(nameof(TbMenusAreasEmpresa.IdpaiAreaEmpresaNavigation))]
        public virtual ICollection<TbMenusAreasEmpresa> InverseIdpaiAreaEmpresaNavigation { get; set; }
        [InverseProperty("IdmenusAreasEmpresaNavigation")]
        public virtual ICollection<TbPerfisAcessosAreasEmpresa> TbPerfisAcessosAreasEmpresa { get; set; }
    }
}