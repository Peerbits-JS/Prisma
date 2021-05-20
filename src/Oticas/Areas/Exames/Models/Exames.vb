Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes

Public Class Exames
    Inherits ClsF3MModelo

#Region "EXAMES"
    <DataMember>
    Public Property IDAgendamento As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Numero", ResourceType:=GetType(Traducao.EstruturaExames))>
    Public Property Numero As Long

    <Required>
    <DataMember>
    <Display(Name:="Data", ResourceType:=GetType(Traducao.EstruturaExames))>
    Public Property DataExame As DateTime = DateAndTime.Now()

    <DataMember>
    <Display(Name:="Hora", ResourceType:=GetType(Traducao.EstruturaExames))>
    Public Property HoraExame As DateTime

    <Required>
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbClientes", MapearDescricaoChaveEstrangeira:="DescricaoCliente")>
    Public Property IDCliente As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Nome", ResourceType:=GetType(Traducao.EstruturaExames))>
    Public Property DescricaoCliente As String

    <Required>
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMedicosTecnicos", MapearDescricaoChaveEstrangeira:="DescricaoMedicoTecnico")>
    Public Property IDMedicoTecnico As Nullable(Of Long)

    <DataMember>
    <Display(Name:="MedicoTecnico", ResourceType:=GetType(Traducao.EstruturaExames))>
    Public Property DescricaoMedicoTecnico As String

    <Required>
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbEspecialidades", MapearDescricaoChaveEstrangeira:="DescricaoEspecialidade")>
    Public Property IDEspecialidade As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Especialidade", ResourceType:=GetType(Traducao.EstruturaExames))>
    Public Property DescricaoEspecialidade As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbLojas", MapearDescricaoChaveEstrangeira:="DescricaoLoja")>
    Public Overrides Property IDLoja As Nullable(Of Long)

    <DataMember>
    <Display(Name:=CamposGenericos.Loja, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoLoja As String

    <Required>
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTemplates", MapearDescricaoChaveEstrangeira:="DescricaoTemplate")>
    Public Property IDTemplate As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTemplate As String

    <Required>
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTiposConsultas", MapearDescricaoChaveEstrangeira:="DescricaoTipoConsulta")>
    Public Property IDTipoConsulta As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTipoConsulta As String

    <DataMember>
    Public Property Tipo As String

    <DataMember>
    Public Property Foto As String

    <DataMember>
    Public Property FotoCaminho As String

    <DataMember>
    Public Property VerConsulta As String

    <DataMember>
    Public Property ExamesCustomizacaoComponents As List(Of Components)
#End Region

#Region "IMPORTACAO"
    <DataMember>
    Public Property Hora As String

    <DataMember>
    Public Property LOD_OBS As String

    <DataMember>
    Public Property LOD_ADD As String

    <DataMember>
    Public Property LOD_AX As String

    <DataMember>
    Public Property LOD_CIL As String

    <DataMember>
    Public Property LOD_DIAM As String

    <DataMember>
    Public Property LOD_ESF As String

    <DataMember>
    Public Property LOD_PRISM As String

    <DataMember>
    Public Property LOD_RAIO As String

    <DataMember>
    Public Property LOE_ADD As String

    <DataMember>
    Public Property LOE_AX As String

    <DataMember>
    Public Property LOE_CIL As String

    <DataMember>
    Public Property LOE_DIAM As String

    <DataMember>
    Public Property LOE_ESF As String

    <DataMember>
    Public Property LOE_PRISM As String

    <DataMember>
    Public Property LOE_RAIO As String
#End Region

#Region "HISTORICO"
    <DataMember>
    Public Property HistoricoExames As New HistoricoExames
#End Region

#Region "FOTOS"
    <DataMember>
    Public Property ExamesFotos As New List(Of FotosGrid)
#End Region
End Class

Public Class FotosGrid
    <DataMember>
    Public Property ID As Long

    <DataMember>
    Public Property AcaoFormulario As Short

    <DataMember>
    Public Property Foto As String

    <DataMember>
    Public Property FotoCaminho As String

    <DataMember>
    Public Property FotoCaminhoCompleto As String

    <DataMember>
    Public Property FotoAnterior As String

    <DataMember>
    Public Property FotoCaminhoAnterior As String

    <DataMember>
    Public Property FotoCaminhoAnteriorCompleto As String
End Class

Public Class ExamesCustomModel
    <DataMember>
    Public Property ExamesFotos As New List(Of FotosGrid)

    <DataMember>
    Public Property ExamesModel As Dictionary(Of String, String)
End Class