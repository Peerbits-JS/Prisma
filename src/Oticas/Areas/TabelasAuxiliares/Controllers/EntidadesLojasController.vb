﻿Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class EntidadesLojasController
        Inherits EntidadesLojasController(Of Oticas.BD.Dinamica.Aplicacao, tbEntidadesLojas, EntidadesLojas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioEntidadesLojas())
        End Sub
#End Region

    End Class
End Namespace
