Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposDocumentoComunicacaoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposDocumentoComunicacao, SistemaTiposDocumentoComunicacao)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposDocumentoComunicacao)
        End Sub
#End Region

    End Class
End Namespace