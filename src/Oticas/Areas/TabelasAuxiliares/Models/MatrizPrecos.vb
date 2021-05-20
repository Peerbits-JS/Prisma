Imports System.Runtime.Serialization

Public Class MatrizPrecos

    <DataMember>
    Public Property IDModelo As Long

    <DataMember>
    Public Property IDTratamento As Long?

    <DataMember>
    Public Property DiametroDe As Double

    <DataMember>
    Public Property DiametroAte As Double

    <DataMember>
    Public Property Raio As Double?

    <DataMember>
    Public Property LinhasMatrizPrecos As List(Of PrecosLentes)

End Class
