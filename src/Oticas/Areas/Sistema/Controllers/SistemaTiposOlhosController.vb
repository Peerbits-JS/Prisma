Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposOlhosController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposOlhos, SistemaTiposOlhos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposOlhos)
        End Sub
#End Region

#Region "LEITURA"
#End Region
    End Class
End Namespace