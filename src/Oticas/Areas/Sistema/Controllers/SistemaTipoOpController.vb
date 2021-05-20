Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTipoOpController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTipoOp, SistemaTipoOp)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTipoOp)
        End Sub
#End Region

    End Class
End Namespace