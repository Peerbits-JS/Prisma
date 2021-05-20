Imports System.Data.SqlClient
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Excepcoes

Namespace BD.Dinamica
    Public Class Aplicacao
        Inherits F3MEntities

#Region "Propriedades"
        ''' <summary>
        ''' Ativar a opção de carregar as tabelas associadas, caso esteja a true.
        ''' </summary>
        ''' <remarks></remarks>
        Private _isLazyModeEnable As String
        Public Property isLazyModeEnable() As String
            Get
                Return _isLazyModeEnable
            End Get
            Set(ByVal value As String)
                _isLazyModeEnable = value
            End Set
        End Property

        ''' <summary>
        ''' Tempo para expirar a execução de uma query na BD. Caso seja 0 (por defeito) não existe um tempo definido
        ''' </summary>
        ''' <remarks></remarks>
        Private _cmdTimeOut As Long
        Public Property cmdTimeOut() As Long
            Get
                Return _cmdTimeOut
            End Get
            Set(ByVal value As Long)
                _cmdTimeOut = value
            End Set
        End Property

#End Region

        ''' <summary>
        ''' Criar dinamicamente a ligação a base de dados.
        ''' </summary>
        ''' <remarks></remarks>
        Public Sub New()
            Try
                Database.Connection.ConnectionString = ClsBaseDados.RetornaConnectionString(Me)
                Database.CommandTimeout = cmdTimeOut
                If Not IsNothing(isLazyModeEnable) Then Configuration().LazyLoadingEnabled = isLazyModeEnable
            Catch ex As Exception
                ClsExcepcoes.PreservaStackTraceExcepcao(ex)
            End Try
        End Sub

        Protected Overrides Sub Dispose(disposing As Boolean)
            MyBase.Dispose(disposing)
            Try
                GC.SuppressFinalize(Me)
            Catch ex As Exception
                ClsExcepcoes.PreservaStackTraceExcepcao(ex)
            End Try
        End Sub

        Public Function ExecutaQueryeDevolveIQueryable(Of T)(ByVal strQuery As String) As IQueryable(Of T)
            Dim sqlParam As New SqlParameter() With {
                .ParameterName = "query",
                .Value = strQuery}
            Dim lista As List(Of T) = Me.Database.SqlQuery(Of T)("EXEC [dbo].[sp_F3M_DaResultadoPesquisa] @query", sqlParam).ToList
            Return lista.AsQueryable
        End Function

    End Class
End Namespace