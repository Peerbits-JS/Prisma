Imports System.Runtime.Serialization
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports System.ComponentModel.DataAnnotations

Public Class ParametrosCamposContexto
    Inherits F3M.ParametrosCamposContexto

    <DataMember>
    Public Property Condicionantes As List(Of Condicionantes)
End Class
