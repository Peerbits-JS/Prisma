Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaEmissaoPackingListController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEmissaoPackingList, SistemaEmissaoPackingList)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaEmissaoPackingList)
        End Sub
#End Region

    End Class
End Namespace