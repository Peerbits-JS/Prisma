Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports Traducao.Traducao

Public Class ArtigosLentesOftalmicasSuplementos
    Inherits ClsF3MModelo

    <DataMember>
    Public Property IDLenteOftalmica As Nullable(Of Long)

    <DataMember>
    Public Property IDSuplementoLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoSuplementoLente As String

    <DataMember>
    Public Property Checked As Nullable(Of Boolean)

    <DataMember>
    Public Property AcaoCRUD As Short?
End Class
