Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Autenticacao
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class EstadosController
        Inherits EstadosController(Of Oticas.BD.Dinamica.Aplicacao, tbEstados, Estados)

        ReadOnly _repositorioEstados As RepositorioEstados

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioEstados())

            _repositorioEstados = repositorio
        End Sub
#End Region

#Region "GET"
        <F3MAcesso>
        Public Overrides Function Edita(Optional ID As Long = 0) As ActionResult
            Dim actionResult As ActionResult = MyBase.Edita(ID)

            Dim model As Estados = DirectCast(actionResult, PartialViewResult).Model

            With model
                .AtivaPredefNovosDocs = _repositorioEstados.AtivaPredefinicaoNovosDocs(.IDTipoEstado)
                .TemDocumentos = _repositorioEstados.TemDocumentos(ID)
            End With

            Return actionResult
        End Function
#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function ValidaEstadosIniciais(IDEntidade As Int32, EstadoInicial As Boolean) As JsonResult
            Using rep As New RepositorioEstados
                Return Json(rep.ValidaEstadosIniciais(IDEntidade, EstadoInicial), JsonRequestBehavior.AllowGet)
            End Using
        End Function

        Public Function ValidaEstadosIniciaisEdicao(ID As Long, IDEntidade As Int32, EstadoInicial As Boolean) As JsonResult
            Using rep As New RepositorioEstados
                Return Json(rep.ValidaEstadosIniciaisEdicao(ID, IDEntidade, EstadoInicial), JsonRequestBehavior.AllowGet)
            End Using
        End Function
#End Region

    End Class
End Namespace
