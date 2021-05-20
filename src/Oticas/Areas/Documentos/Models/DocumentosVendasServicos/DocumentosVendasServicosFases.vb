Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Base

Public Class DocumentosVendasServicosFases
    Inherits ClsF3MModeloLinhas

    <DataMember>
    Public Property IsChecked As Boolean = False

    <DataMember>
    Public Property IDTipoFase As Long

    <DataMember>
    Public Property IDServico As Long

    <DataMember>
    Public Property IDTipoServico As Long?

    <DataMember>
    Public Property Data As String

    <DataMember>
    Public Property UtilizadorEstado As String

    <DataMember, StringLength(100)>
    Public Property Observacoes As String

    <DataMember>
    Public Property DescricaoTiposFases As String
End Class