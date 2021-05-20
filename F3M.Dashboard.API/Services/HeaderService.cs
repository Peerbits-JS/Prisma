using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using F3M.Middleware.Constants;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services
{
    public class HeaderService : IHeaderService
    {
        readonly IUnitOfWorkCore _unitOfWorkCore;
        readonly IClsDadosAcesso _clsDadosAcesso;

        public HeaderService(IUnitOfWorkCore unitOfWorkCore, IClsDadosAcesso clsDadosAcesso)
        {
            _unitOfWorkCore = unitOfWorkCore;
            _clsDadosAcesso = clsDadosAcesso;
        }

        public async Task<MenusDTO> GetMenu(long idMenu)
        {
            string query = @"select TbMenus.ID as Id, TbMenus.Descricao as Description, TbMenus.Icon, TbMenus.Accao as Action
                        from TbMenus
                        Where ID = @ID";

            Dictionary<string, object> parameters = new()
            {
                { "@ID", idMenu },
            };

            var result = await _unitOfWorkCore.ExecQueryAsync<MenusDTO>(query, parameters);

            return result.FirstOrDefault();
        }

        public async Task<bool> GetFavouriteMenu(long idMenu)
        {
            string query = @"select TbMenusFavoritos.IDMenu
                            from TbMenusFavoritos
                            where TbMenusFavoritos.IDUtilizador = @IDUtilizador and TbMenusFavoritos.IDMenu = @ID";

            Dictionary<string, object> parameters = new()
            {
                { "@ID", idMenu },
                { "@IDUtilizador", _clsDadosAcesso.IDUtilizador },
            };

            var result = await _unitOfWorkCore.ExecQueryAsync<FavouriteMenuDTO>(query, parameters);

            return result.Any();
        }

        public async Task<bool> GetHomePageMenu(long idMenu)
        {
            string query = @"select tbUtilizadoresEmpresa.IDHomePage
                        from tbUtilizadoresEmpresa
                        where tbUtilizadoresEmpresa.IDUtilizador = @IDUtilizador and tbUtilizadoresEmpresa.IDEmpresa = @IDEmpresa and tbUtilizadoresEmpresa.IDHomePage = @ID";

            Dictionary<string, object> parameters = new()
            {
                { "@ID", idMenu },
                { "@IDUtilizador", _clsDadosAcesso.IDUtilizador },
                { "@IDEmpresa", _clsDadosAcesso.IDEmpresa },

            };

            var result = await _unitOfWorkCore.ExecQueryAsync<HomepageMenuDTO>(query, parameters);

            return result.Any();
        }
    }
}

