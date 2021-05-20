using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbPerfis")]
    [Index(nameof(Descricao), Name = "IX_tbPerfis", IsUnique = true)]
    public partial class TbPerfis
    {
        public TbPerfis()
        {
            TbPerfisAcessos = new HashSet<TbPerfisAcessos>();
            TbPerfisAcessosAreas = new HashSet<TbPerfisAcessosAreas>();
            TbPerfisAcessosAreasEmpresa = new HashSet<TbPerfisAcessosAreasEmpresa>();
            TbUtilizadoresEmpresa = new HashSet<TbUtilizadoresEmpresa>();
        }

        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Descricao { get; set; }
        [Required]
        [StringLength(20)]
        public string DescricaoAbreviada { get; set; }
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

        [InverseProperty("IdperfisNavigation")]
        public virtual ICollection<TbPerfisAcessos> TbPerfisAcessos { get; set; }
        [InverseProperty("IdperfisNavigation")]
        public virtual ICollection<TbPerfisAcessosAreas> TbPerfisAcessosAreas { get; set; }
        [InverseProperty("IdperfisNavigation")]
        public virtual ICollection<TbPerfisAcessosAreasEmpresa> TbPerfisAcessosAreasEmpresa { get; set; }
        [InverseProperty("IdperfilNavigation")]
        public virtual ICollection<TbUtilizadoresEmpresa> TbUtilizadoresEmpresa { get; set; }
    }
}
