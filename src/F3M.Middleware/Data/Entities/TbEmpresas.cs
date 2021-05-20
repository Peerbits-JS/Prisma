using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbEmpresas")]
    [Index(nameof(Codigo), Name = "IX_tbEmpresas", IsUnique = true)]
    public partial class TbEmpresas
    {
        public TbEmpresas()
        {
            TbMenusAreasEmpresa = new HashSet<TbMenusAreasEmpresa>();
            TbUtilizadores = new HashSet<TbUtilizadores>();
            TbUtilizadoresEmpresa = new HashSet<TbUtilizadoresEmpresa>();
        }

        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [StringLength(8)]
        public string Codigo { get; set; }
        public string Nome { get; set; }
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
        public bool? EmpresaDemonstracao { get; set; }

        [InverseProperty("IdempresaNavigation")]
        public virtual ICollection<TbMenusAreasEmpresa> TbMenusAreasEmpresa { get; set; }
        [InverseProperty("IdultimaEmpresaAbertaNavigation")]
        public virtual ICollection<TbUtilizadores> TbUtilizadores { get; set; }
        [InverseProperty("IdempresaNavigation")]
        public virtual ICollection<TbUtilizadoresEmpresa> TbUtilizadoresEmpresa { get; set; }
    }
}
