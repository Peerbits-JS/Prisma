Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio

Namespace Repositorio.Exames
    Public Class RepositorioTemplates
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbTemplates, Oticas.Templates)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbTemplates)) As IQueryable(Of Oticas.Templates)
            Return inQuery.Select(Function(e) New Oticas.Templates With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao,
                .IDLoja = e.IDLoja, .DescricaoLoja = e.tbLojas.Descricao,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTemplates)) As IQueryable(Of Oticas.Templates)
            Return query.Select(Function(e) New Oticas.Templates With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function
#End Region
    End Class
End Namespace