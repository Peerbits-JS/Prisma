Imports System.Runtime.Serialization
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports System.ComponentModel.DataAnnotations

Public Class ParametrosContexto
    Inherits F3M.ParametrosContexto

    <DataMember>
    Public Overridable Property ParametrosCamposContexto As List(Of ParametrosCamposContexto)
End Class
