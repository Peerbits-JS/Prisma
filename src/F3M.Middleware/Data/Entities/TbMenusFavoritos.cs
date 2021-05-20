using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbMenusFavoritos")]
    public partial class TbMenusFavoritos
    {
        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Column("IDMenu")]
        public long Idmenu { get; set; }
        [Column("IDUtilizador")]
        public long Idutilizador { get; set; }
        public long Ordem { get; set; }
        [StringLength(50)]
        public string Descricao { get; set; }
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

        [ForeignKey(nameof(Idmenu))]
        [InverseProperty(nameof(TbMenus.TbMenusFavoritos))]
        public virtual TbMenus IdmenuNavigation { get; set; }
    }
}
