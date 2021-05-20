Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos

Public Class RecibosLinhasTaxas
    Inherits ClsF3MModelo

    <DataMember>
    Public Property IDReciboLinha As Nullable(Of Long)

    <DataMember>
    Public Property TipoTaxa As String

    <DataMember>
    Public Property TaxaIva As Nullable(Of Double)

    <DataMember>
    Public Property ValorIva As Nullable(Of Double)

    <DataMember>
    Public Property ValorIncidencia As Nullable(Of Double)

    <DataMember>
    Public Property MotivoIsencaoIva As String
End Class
