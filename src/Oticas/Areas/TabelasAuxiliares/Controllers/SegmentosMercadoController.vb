﻿Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class SegmentosMercadoController
        Inherits SegmentosMercadoController(Of Oticas.BD.Dinamica.Aplicacao, tbSegmentosMercado, SegmentosMercado)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSegmentosMercado())
        End Sub
#End Region

    End Class
End Namespace
