﻿Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposFornecimentosController
        Inherits TiposFornecimentosController(Of Oticas.BD.Dinamica.Aplicacao, tbTiposFornecimentos, TiposFornecimentos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposFornecimentos())
        End Sub
#End Region

    End Class
End Namespace