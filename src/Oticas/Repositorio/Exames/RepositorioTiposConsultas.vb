Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio

Namespace Repositorio.Exames
    Public Class RepositorioTiposConsultas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbTiposConsultas, Oticas.TiposConsultas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbTiposConsultas)) As IQueryable(Of Oticas.TiposConsultas)
            Return inQuery.Select(Function(e) New Oticas.TiposConsultas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao,
                .IDLoja = e.IDLoja, .DescricaoLoja = e.tbLojas.Descricao, .IDTemplate = e.IDTemplate, .DescricaoTemplate = e.tbTemplates.Descricao,
                .IDMapaVista1 = e.IDMapaVista1, .DescricaoMapaVista1 = e.tbMapasVistas.Descricao, .IDMapaVista2 = e.IDMapaVista2, .DescricaoMapaVista2 = e.tbMapasVistas1.Descricao,
                .CodigoTemplate = e.tbTemplates.Codigo,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposConsultas)) As IQueryable(Of Oticas.TiposConsultas)
            Return query.Select(Function(e) New Oticas.TiposConsultas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .IDTemplate = e.IDTemplate, .DescricaoTemplate = e.tbTemplates.Descricao,
                .IDMapaVista1 = e.IDMapaVista1, .DescricaoMapaVista1 = e.tbMapasVistas.Descricao,
                .IDMapaVista2 = e.IDMapaVista2, .DescricaoMapaVista2 = e.tbMapasVistas1.Descricao,
                .CodigoTemplate = e.tbTemplates.Codigo
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function
#End Region
    End Class
End Namespace