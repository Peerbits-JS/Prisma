Imports System.Runtime.Serialization
Imports F3M.Modelos.Constantes

Public Class LadoDireito
    <DataMember>
    Public Property AcaoFormulario As AcoesFormulario

    <DataMember>
    Public Property URLPartialViewFechada As String

    <DataMember>
    Public Property URLPartialViewAberta As String

    <DataMember>
    Public Property HistoricoExames As HistoricoExames
End Class