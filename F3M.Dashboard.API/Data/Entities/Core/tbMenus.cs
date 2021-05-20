using F3M.Dashboard.API.Data.Entities.Base;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Dashboard.API.Data.Entities.Core
{
    [Table("tbMenus")]
    public partial class TbMenus : EntityBase
    {
        public TbMenus()
        {
            InverseIdpaiNavigation = new HashSet<TbMenus>();
            TbMenusFavoritos = new HashSet<TbMenusFavoritos>();
            TbUtilizadoresEmpresa = new HashSet<TbUtilizadoresEmpresa>();
        }

        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Column("IDPai")]
        public long? Idpai { get; set; }
        [Required]
        [StringLength(50)]
        public string Descricao { get; set; }
        [Required]
        [StringLength(20)]
        public string DescricaoAbreviada { get; set; }
        [Required]
        [StringLength(255)]
        public string ToolTip { get; set; }
        public long Ordem { get; set; }
        [StringLength(1000)]
        public string Icon { get; set; }
        [Required]
        [StringLength(1000)]
        public string Accao { get; set; }
        [Column("IDTiposOpcoesMenu")]
        public long IdtiposOpcoesMenu { get; set; }
        [Column("IDModulo")]
        public long Idmodulo { get; set; }
        [Column("btnContextoAdicionar")]
        public bool? BtnContextoAdicionar { get; set; }
        [Column("btnContextoAlterar")]
        public bool? BtnContextoAlterar { get; set; }
        [Column("btnContextoConsultar")]
        public bool? BtnContextoConsultar { get; set; }
        [Column("btnContextoRemover")]
        public bool? BtnContextoRemover { get; set; }
        [Column("btnContextoExportar")]
        public bool? BtnContextoExportar { get; set; }
        [Column("btnContextoImprimir")]
        public bool? BtnContextoImprimir { get; set; }
        [Column("btnContextoF4")]
        public bool? BtnContextoF4 { get; set; }
        public bool Ativo { get; set; }
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
        public int? OpenType { get; set; }
        [Column("btnContextoSms")]
        public bool? BtnContextoSms { get; set; }

        [ForeignKey(nameof(Idpai))]
        [InverseProperty(nameof(TbMenus.InverseIdpaiNavigation))]
        public virtual TbMenus IdpaiNavigation { get; set; }
        [InverseProperty(nameof(TbMenus.IdpaiNavigation))]
        public virtual ICollection<TbMenus> InverseIdpaiNavigation { get; set; }
        [InverseProperty("IdmenuNavigation")]
        public virtual ICollection<TbMenusFavoritos> TbMenusFavoritos { get; set; }
        [InverseProperty("IdhomePageNavigation")]
        public virtual ICollection<TbUtilizadoresEmpresa> TbUtilizadoresEmpresa { get; set; }

    }
}
