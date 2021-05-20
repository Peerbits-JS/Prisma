Imports System.Runtime.Serialization

Public Class DocumentosComprasLinhas
    Inherits F3M.DocumentosComprasLinhas

    <DataMember>
    Public Overridable Property DocumentosComprasLinhasDimensoes As List(Of Oticas.DocumentosComprasLinhasDimensoes)

    <DataMember>
    Public Overridable Property DocLinDimRemover As List(Of Oticas.DocumentosComprasLinhasDimensoes)

End Class