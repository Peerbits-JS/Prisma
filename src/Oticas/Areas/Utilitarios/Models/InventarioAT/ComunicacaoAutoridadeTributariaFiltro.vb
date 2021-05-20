Imports System.ComponentModel.DataAnnotations

Public Class ComunicacaoAutoridadeTributariaFiltro
    Sub New()
        Warehouses = New List(Of ComunicacaoAutoridadeTributariaArmazem)
        FilterDate = New Date(Now.AddYears(-1).Year, 12, 31)
    End Sub

    <Required>
    Property FilterDate As Date

    Property Warehouses As List(Of ComunicacaoAutoridadeTributariaArmazem)
End Class

