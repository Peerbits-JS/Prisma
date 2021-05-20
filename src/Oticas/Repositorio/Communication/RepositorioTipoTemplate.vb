Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity

Namespace Repositorio.Communication
    Public Class RepositorioTipoTemplate
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbComunicacao, TiposComunicacao)


#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbComunicacao)) As IQueryable(Of TiposComunicacao)
            Return query.Select(Function(e) New TiposComunicacao With {
                                .ID = e.ID, .Descricao = e.Descricao}).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function


        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposComunicacao)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

#End Region
    End Class


End Namespace

