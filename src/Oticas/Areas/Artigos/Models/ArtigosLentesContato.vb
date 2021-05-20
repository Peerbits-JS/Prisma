Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports Traducao.Traducao

Public Class ArtigosLentesContato
    Inherits ClsF3MModelo

    <DataMember>
    Public Property IDArtigo As Nullable(Of Long)

    <DataMember>
    <Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbModelos", MapearDescricaoChaveEstrangeira:="DescricaoModelos")>
    Public Property IDModelo As Nullable(Of Long)
    <DataMember>
    Public Property DescricaoModelo As String

    <DataMember>
    <Required>
    Public Property Raio As String

    <DataMember>
    <Required>
    Public Property Diametro As String

    <DataMember>
    <Required>
    Public Property PotenciaEsferica As Nullable(Of Double)

    <DataMember>
    <Required>
    Public Property PotenciaCilindrica As Nullable(Of Double)

    <DataMember>
    <Required>
    Public Property Eixo As Nullable(Of Integer)

    <DataMember>
    <Required>
    Public Property Adicao As Nullable(Of Double)

    <DataMember>
    Public Property Raio2 As String

    <DataMember>
    Public Property AcaoCRUD As Short?

    <DataMember>
    Public Property IDTipoLente As String

    <DataMember>
    Public Property IndiceRefracao As Double?

    <DataMember>
    Public Property Fotocromatica As Boolean
End Class
