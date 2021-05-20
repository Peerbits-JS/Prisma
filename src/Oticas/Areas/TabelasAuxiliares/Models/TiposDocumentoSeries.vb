Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Autenticacao

Public Class TiposDocumentoSeries
    Inherits F3M.TiposDocumentoSeries

    <DataMember>
    Public Overridable Property TiposDocumentoSeriesPermissoes As List(Of F3M.PerfisAcessosAreasEmpresa)

    <DataMember>
    Public Property CodigoDescricao As String

#Region "ESPECIFICOS DO PRISMA"
    <DataMember>
    Public Overrides Property TemCabecalhoEspecifico As Boolean = ClsF3MSessao.VerificaSessaoObjeto().Licenciamento.ExisteModulo(ModulosLicenciamento.Prisma.MultiEmpresa)

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbLojas", MapearDescricaoChaveEstrangeira:="DescricaoLoja")>
    Public Overrides Property IDLoja As Nullable(Of Long)

    <DataMember>
    <Display(Name:=CamposGenericos.Loja, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoLoja As String
#End Region
End Class
