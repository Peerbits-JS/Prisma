'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated from a template.
'
'     Manual changes to this file may cause unexpected behavior in your application.
'     Manual changes to this file will be overwritten if the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Imports System
Imports System.Collections.Generic

Partial Public Class tbDocumentosVendasLinhasGraduacoes
    Public Property ID As Long
    Public Property IDTipoOlho As Nullable(Of Long)
    Public Property IDTipoGraduacao As Nullable(Of Long)
    Public Property PotenciaEsferica As Nullable(Of Double)
    Public Property PotenciaCilindrica As Nullable(Of Double)
    Public Property PotenciaPrismatica As Nullable(Of Double)
    Public Property BasePrismatica As String
    Public Property Adicao As Nullable(Of Double)
    Public Property Eixo As Nullable(Of Integer)
    Public Property RaioCurvatura As String
    Public Property DetalheRaio As String
    Public Property DNP As Nullable(Of Double)
    Public Property Altura As Nullable(Of Double)
    Public Property AcuidadeVisual As String
    Public Property AnguloPantoscopico As String
    Public Property DistanciaVertex As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property IDServico As Nullable(Of Long)

    Public Overridable Property tbServicos As tbServicos
    Public Overridable Property tbSistemaTiposGraduacoes As tbSistemaTiposGraduacoes
    Public Overridable Property tbSistemaTiposOlhos As tbSistemaTiposOlhos

End Class