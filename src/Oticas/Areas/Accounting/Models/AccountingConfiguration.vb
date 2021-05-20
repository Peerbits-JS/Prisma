Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Oticas.DTO

Public Class AccountingConfiguration
    Inherits ClsF3MModelo

    Sub New()
        Entities = New List(Of AccountingConfigurationEntityDto)
        DocumentTypes = New List(Of AccountingConfigurationDocumentTypeDto)
    End Sub

    <Display(Name:="Ano", ResourceType:=GetType(Traducao.EstruturaContabilidadeConfiguracao))>
    Public Property Year As String
    <Display(Name:="Modulo", ResourceType:=GetType(Traducao.EstruturaContabilidadeConfiguracao))>
    Public Property ModuleDescription As String
    Public Property ModuleCode As String
    Public Property [Module] As Long?
    Public Property TypeCode As String
    <Display(Name:="Tipo", ResourceType:=GetType(Traducao.EstruturaContabilidadeConfiguracao))>
    Public Property TypeDescription As String
    Public Property Type As Long?
    <Display(Name:="Alternativa", ResourceType:=GetType(Traducao.EstruturaContabilidadeConfiguracao))>
    Public Property AlternativeCode As String
    <Display(Name:="Alternativa", ResourceType:=GetType(Traducao.EstruturaContabilidadeConfiguracao))>
    Public Property AlternativeDescription As String
    Public Property IsPreset As Boolean?
    Public Property JournalCode As String
    Public Property DocumentCode As String
    Public Property IdTable As Long?
    Public Property TableDescription As String
    Public Property ReflectsIVAClassByFinancialAccount As Boolean?
    Public Property ReflectsCostCenterByFinancialAccount As Boolean?
    <Display(Name:="CriadoEm", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property CreatedAt As Date
    <Display(Name:="UltimoDownload", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property UpdatedAt As Nullable(Of Date)
    <Display(Name:="Utilizador", ResourceType:=GetType(Traducao.EstruturaUtilitarios))>
    Public Property CreatedBy As String
    Public Property UpdatedBy As String
    Public Property F3MMarker As Byte()
    Public Property Entities As ICollection(Of AccountingConfigurationEntityDto)
    Public Property DocumentTypes As ICollection(Of AccountingConfigurationDocumentTypeDto)
    Public Property IsCopyMode As Boolean = False

    Public Function GetBadgeYear() As String
        Return If(ID = 0 AndAlso Not IsCopyMode, "-", Year)
    End Function

    Public Function GetBadgeModule() As String
        Return If(ID = 0 AndAlso Not IsCopyMode, "-", ModuleDescription)
    End Function

    Public Function GetBadgeType() As String
        Return If(ID = 0 AndAlso Not IsCopyMode, "-", TypeDescription)
    End Function

    Public Function GetLabelAternativeCode() As String
        Return If(ID = 0 AndAlso Not IsCopyMode, "-", TypeCode & " - " & TypeDescription)
    End Function
End Class