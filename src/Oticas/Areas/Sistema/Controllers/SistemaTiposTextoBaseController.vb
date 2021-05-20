﻿Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposTextoBaseController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposTextoBase, SistemaTiposTextoBase)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposTextoBase)
        End Sub
#End Region

    End Class
End Namespace