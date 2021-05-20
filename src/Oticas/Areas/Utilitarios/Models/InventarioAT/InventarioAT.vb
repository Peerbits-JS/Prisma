Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Public Class InventarioAT
    Inherits ClsF3MModeloLinhas

    Sub New()
        Filter = New ComunicacaoAutoridadeTributariaFiltro
        Products = New List(Of ComunicacaoAutoridadeTributariaArtigos)
        Warehouses = New List(Of Long)
    End Sub

    <Display(Name:="CriadoEm", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property CreatedAt As Date

    <Display(Name:="UltimoDownload", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property UpdatedAt As Nullable(Of Date)

    <Display(Name:="Utilizador", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property CreatedBy As String

    Public Property UpdatedBy As String

    Public Property Observations As String

    Public Property Filter As ComunicacaoAutoridadeTributariaFiltro

    Public Property Products As IList(Of ComunicacaoAutoridadeTributariaArtigos)

    Public Property Warehouses As IList(Of Long)

    Public Property Download As String

    <Display(Name:="Data", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property DateFilter As Date

    <Display(Name:="Armazens", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property WareHousesFilterName As String

    Public Function IsEnabled() As Boolean
        Return ID = 0
    End Function

End Class
