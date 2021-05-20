Imports System.Runtime.Serialization
Imports F3M.Modelos.Base

Public Class ExamesCustomizacao
    Inherits ClsF3MModelo

    <DataMember>
    Public Property ExamesCustomizacaoComponents As List(Of Components)
End Class