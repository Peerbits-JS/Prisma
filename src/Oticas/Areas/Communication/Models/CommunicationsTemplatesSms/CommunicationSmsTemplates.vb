Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Namespace Areas.Communication.Models
    Public Class CommunicationSmsTemplates
        Inherits ClsF3MModelo

        <Required, StringLength(50)>
        Public Property Nome As String

        <Required>
        Public Property IDSistemaEnvio As Long?

        Public Property DescricaoSistemaEnvio As String

        <Required>
        Public Property IDParametrizacaoConsentimentosPerguntas As Long?

        Public Property DescricaoParametrizacaoConsentimentosPerguntas As String

        Public Property Grupo As New CommunicationSmsTemplatesGrupos

        Public Property Recipts As New Recipts
    End Class
End Namespace
