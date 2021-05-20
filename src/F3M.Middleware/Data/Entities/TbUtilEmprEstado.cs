using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbUtilEmprEstado")]
    public partial class TbUtilEmprEstado
    {
        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Column("IDUtilizadorEmpresa")]
        public long IdutilizadorEmpresa { get; set; }
        [Required]
        public string ChaveOpcao { get; set; }
        [Required]
        public string ValorControlo { get; set; }
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

        [ForeignKey(nameof(IdutilizadorEmpresa))]
        [InverseProperty(nameof(TbUtilizadoresEmpresa.TbUtilEmprEstado))]
        public virtual TbUtilizadoresEmpresa IdutilizadorEmpresaNavigation { get; set; }
    }
}