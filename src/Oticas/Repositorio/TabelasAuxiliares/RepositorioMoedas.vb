Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.TabelasAuxiliaresComum

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioMoedas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbMoedas, Moedas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        'LISTA TUDO MAPEADO
        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbMoedas)) As IQueryable(Of Moedas)
            Using repM As New RepositorioMoeda(Of tbMoedas, Moedas, tbParametrosEmpresa)
                Return repM.MapeiaLista(inQuery)
            End Using
        End Function

        'LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Moedas)
            Using repM As New RepositorioMoeda(Of tbMoedas, Moedas, tbParametrosEmpresa)
                Return repM.ListaTudoMOD(BDContexto, inFiltro, True)
            End Using
        End Function

        'LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Moedas)
            Using repM As New RepositorioMoeda(Of tbMoedas, Moedas, tbParametrosEmpresa)
                Return repM.ListaTudoMOD(BDContexto, inFiltro, True, True)
            End Using
        End Function

        'GET MOEDA
        Public Function RetornaMoeda(inMoedaID As Long) As Moedas
            Using repM As New RepositorioMoeda(Of tbMoedas, Moedas, tbParametrosEmpresa)
                Return repM.GetMoeda(BDContexto, inMoedaID)
            End Using
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace