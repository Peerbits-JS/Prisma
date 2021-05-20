using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbUtilizadores")]
    public partial class TbUtilizadores
    {
        public TbUtilizadores()
        {
            AspNetUsers = new HashSet<AspNetUsers>();
            TbUtilizadoresEmpresa = new HashSet<TbUtilizadoresEmpresa>();
        }

        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Column("IDUltimaEmpresaAberta")]
        public long? IdultimaEmpresaAberta { get; set; }
        [StringLength(50)]
        public string LocalCarga { get; set; }
        [StringLength(255)]
        public string RuaCarga { get; set; }
        [StringLength(100)]
        public string NumPoliciaCarga { get; set; }
        [Column("IDCodigoPostalCarga")]
        public long? IdcodigoPostalCarga { get; set; }
        [Column("IDDistritoCarga")]
        public long? IddistritoCarga { get; set; }
        [Column("IDConcelhoCarga")]
        public long? IdconcelhoCarga { get; set; }
        [StringLength(250)]
        public string DescricaoCodigoPostalCarga { get; set; }
        [StringLength(250)]
        public string DescricaoDistritoCarga { get; set; }
        [StringLength(250)]
        public string DescricaoConcelhoCarga { get; set; }
        [Required]
        [StringLength(256)]
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
        [Column("IDUltimaLojaAberta")]
        public long? IdultimaLojaAberta { get; set; }
        public bool? Touch { get; set; }
        [StringLength(255)]
        public string Foto { get; set; }
        public string FotoCaminho { get; set; }
        [Column("IDSistemaTiposServicos")]
        public long? IdsistemaTiposServicos { get; set; }
        public bool? ResetPassword { get; set; }
        [Column("ServidorSMTP")]
        [StringLength(50)]
        public string ServidorSmtp { get; set; }
        [Column("PortaSMTP")]
        public int? PortaSmtp { get; set; }
        [Column("SSLSMTP")]
        public bool? Sslsmtp { get; set; }
        [Column("EmailSMTP")]
        [StringLength(50)]
        public string EmailSmtp { get; set; }
        [Column("UtilizadorSMTP")]
        [StringLength(50)]
        public string UtilizadorSmtp { get; set; }
        [Column("PasswordSMTP")]
        [StringLength(50)]
        public string PasswordSmtp { get; set; }
        [StringLength(50)]
        public string AliasEmail { get; set; }
        public string AssinaturaEmail { get; set; }
        public bool? AcessoRestrito { get; set; }
        [StringLength(20)]
        public string Contacto { get; set; }
        [Column("CC")]
        [StringLength(1024)]
        public string Cc { get; set; }
        [Column("BCC")]
        [StringLength(1024)]
        public string Bcc { get; set; }
        public double? LimiteMaxDesconto { get; set; }
        public long? TotalDocVenda { get; set; }
        public bool? VendaAbaixoCustoMedio { get; set; }
        public bool? PodeAlterarCaixa { get; set; }

        [ForeignKey(nameof(IdultimaEmpresaAberta))]
        [InverseProperty(nameof(TbEmpresas.TbUtilizadores))]
        public virtual TbEmpresas IdultimaEmpresaAbertaNavigation { get; set; }
        [InverseProperty("IdutilizadorNavigation")]
        public virtual ICollection<AspNetUsers> AspNetUsers { get; set; }
        [InverseProperty("IdutilizadorNavigation")]
        public virtual ICollection<TbUtilizadoresEmpresa> TbUtilizadoresEmpresa { get; set; }
    }
}
