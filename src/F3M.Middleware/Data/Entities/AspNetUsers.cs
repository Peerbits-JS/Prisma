using Microsoft.EntityFrameworkCore;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Index(nameof(UserName), Name = "IX_AspNetUsers", IsUnique = true)]
    public partial class AspNetUsers
    {
        [Key]
        [Column("ID")]
        [StringLength(128)]
        public string Id { get; set; }
        [StringLength(256)]
        public string Email { get; set; }
        public bool EmailConfirmed { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public string PhoneNumber { get; set; }
        public bool PhoneNumberConfirmed { get; set; }
        public bool TwoFactorEnabled { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? LockoutEndDateUtc { get; set; }
        public bool LockoutEnabled { get; set; }
        public int AccessFailedCount { get; set; }
        [Required]
        [StringLength(256)]
        public string UserName { get; set; }
        [Column("IDUtilizador")]
        public long? Idutilizador { get; set; }

        [ForeignKey(nameof(Idutilizador))]
        [InverseProperty(nameof(TbUtilizadores.AspNetUsers))]
        public virtual TbUtilizadores IdutilizadorNavigation { get; set; }
    }
}
