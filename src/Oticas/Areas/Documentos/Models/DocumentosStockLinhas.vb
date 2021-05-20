Imports System.Runtime.Serialization

Public Class DocumentosStockLinhas
    Inherits F3M.DocumentosStockLinhas

    'GRELHAS LINHAS
    <DataMember>
    Public Overridable Property DocumentosStockLinhasDimensoes As List(Of Oticas.DocumentosStockLinhasDimensoes)

    <DataMember>
    Public Overridable Property DocLinDimRemover As List(Of Oticas.DocumentosStockLinhasDimensoes)
End Class