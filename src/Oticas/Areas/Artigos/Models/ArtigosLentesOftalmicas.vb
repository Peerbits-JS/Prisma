Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports Traducao.Traducao

Public Class ArtigosLentesOftalmicas
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
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTratamentosLentes", MapearDescricaoChaveEstrangeira:="DescricaoTratamentoLente")>
    Public Property IDTratamentoLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTratamentoLente As String

    <DataMember>
    <Required>
    <StringLength(5)>
    Public Property Diametro As String

    <DataMember>
    <Required>
    Public Property PotenciaEsferica As Double

    <DataMember>
    Public Property PotenciaCilindrica As Double

    <DataMember>
    Public Property PotenciaPrismatica As Double

    <DataMember>
    Public Property Adicao As Double

    <DataMember>
    Public Property AcaoCRUD As Short?

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbModelos", MapearDescricaoChaveEstrangeira:="DescricaoModelos")>
    Public Property IDCorLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoCorLente As String

    <DataMember>
    Public Property CodigoCorLente As String

    <DataMember>
    Public Property ArtigosLentesOftalmicasSuplementos As List(Of ArtigosLentesOftalmicasSuplementos)

    <DataMember>
    Public Property IdMateriaLente As String

    <DataMember>
    Public Property IDTipoLente As String

    <DataMember>
    Public Property CodigosSuplementos As String

    <DataMember>
    Public Property IndiceRefracao As Double?

    <DataMember>
    Public Property Fotocromatica As Boolean
End Class
