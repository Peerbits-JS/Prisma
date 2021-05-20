Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposDocumentoPrecoUnitarioController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposDocumentoPrecoUnitario, SistemaTiposDocumentoPrecoUnitario)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposDocumentoPrecoUnitario)
        End Sub
#End Region

    End Class
End Namespace