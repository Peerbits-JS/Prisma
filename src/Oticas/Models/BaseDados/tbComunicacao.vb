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

Partial Public Class tbComunicacao
    Public Property ID As Long
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property IDSistemaComunicacao As Nullable(Of Long)
    Public Property Utilizador As String
    Public Property Chave As String
    Public Property Remetente As String
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbSistemaComunicacao As tbSistemaComunicacao
    Public Overridable Property tbComunicacaoSmsTemplates As ICollection(Of tbComunicacaoSmsTemplates) = New HashSet(Of tbComunicacaoSmsTemplates)
    Public Overridable Property tbMensagemregistro As ICollection(Of tbMensagemregistro) = New HashSet(Of tbMensagemregistro)

End Class