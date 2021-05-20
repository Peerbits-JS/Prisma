using F3M.Core.Domain.Entity;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosArmazensLocalizacoes : EntityBase
    {
        public long? ProductId { get; set; }
        public long WareHouseId { get; set; }
        public bool? IsDefault { get; set; }
        public long Order { get; set; }
        public long? WarehouseLocationId { get; set; }

        public TbArmazensLocalizacoes WarehouseLocation { get; set; }
        public TbArmazens Warehouse { get; set; }
        public Product Product { get; set; }
    }
}
