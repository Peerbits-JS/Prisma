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

Partial Public Class tbMapasVistas
    Public Property ID As Long
    Public Property Ordem As Nullable(Of Integer)
    Public Property Entidade As String
    Public Property Descricao As String
    Public Property NomeMapa As String
    Public Property Caminho As String
    Public Property Certificado As Nullable(Of Boolean)
    Public Property IDModulo As Nullable(Of Long)
    Public Property IDSistemaTipoDoc As Nullable(Of Long)
    Public Property IDSistemaTipoDocFiscal As Nullable(Of Long)
    Public Property IDLoja As Nullable(Of Long)
    Public Property SQLQuery As String
    Public Property Tabela As String
    Public Property Geral As Boolean
    Public Property Listagem As Boolean
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property MapaXML As String
    Public Property MapaBin As Byte()
    Public Property PorDefeito As Nullable(Of Boolean)
    Public Property SubReport As Boolean
    Public Property TipoReport As Nullable(Of Integer)
    Public Property PedirPassword As Boolean

    Public Overridable Property tbLojas As tbLojas
    Public Overridable Property tbSistemaModulos As tbSistemaModulos
    Public Overridable Property tbSistemaTiposDocumento As tbSistemaTiposDocumento
    Public Overridable Property tbSistemaTiposDocumentoFiscal As tbSistemaTiposDocumentoFiscal
    Public Overridable Property tbTiposConsultas As ICollection(Of tbTiposConsultas) = New HashSet(Of tbTiposConsultas)
    Public Overridable Property tbTiposConsultas1 As ICollection(Of tbTiposConsultas) = New HashSet(Of tbTiposConsultas)
    Public Overridable Property tbTiposDocumentoSeries As ICollection(Of tbTiposDocumentoSeries) = New HashSet(Of tbTiposDocumentoSeries)

End Class