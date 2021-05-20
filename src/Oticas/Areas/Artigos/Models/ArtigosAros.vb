Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports Traducao.Traducao

Public Class ArtigosAros
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
    Public Property CodigoCor As String

    <DataMember>
    <Required>
    Public Property Tamanho As String

    <DataMember>
    Public Property Hastes As String

    <DataMember>
    Public Property CorGenerica As String

    <DataMember>
    Public Property CorLente As String

    <DataMember>
    Public Property TipoLente As String

    <DataMember>
    Public Property AcaoCRUD As Short?
End Class
