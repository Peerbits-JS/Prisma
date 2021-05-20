using Dapper;
using F3M.Middleware.Constants;
using F3M.Middleware.Data.Utils;
using F3M.Middleware.Dto;
using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Middleware.Data.Repository
{
    public class RepositorioPerfisAcessos
    {
        private readonly IClsDadosAcesso _clsDadosAcesso;

        public RepositorioPerfisAcessos(IClsDadosAcesso clsDadosAcesso)
        {
            _clsDadosAcesso = clsDadosAcesso;
        }

        public async Task<PerfisAcessosDto> GetTemAcessoAsync(long idMenu, long inIDPerfil)
        {
            var query = @"select PA.Consultar from tbPerfisAcessos PA 
                        where PA.idmenus = @IDMenu AND PA.IDPerfis = @IDPerfil";

            Dictionary<string, object> @params = new Dictionary<string, object>
            {
                { "@IDMenu", idMenu },
                { "@IDPerfil", inIDPerfil }
            };

            DatabaseUtils db = new(_clsDadosAcesso);

            using SqlConnection conexao = new SqlConnection(db.GetConexaoBD(true));
            var result = await conexao.QueryAsync<PerfisAcessosDto>(query, @params);

            return result.FirstOrDefault();
        }
    }
}
