Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Public Class Unidades
    Inherits F3M.Unidades

    <DataMember>
    <Display(Name:="PorDefeito", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property PorDefeito As Boolean
End Class
