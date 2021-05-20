Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports Newtonsoft.Json

Public Class DocumentosStockContagem
    Inherits ClsF3MModelo

    Sub New()
        Filtro = New DocumentosStockContagemFiltro()
        Artigos = New List(Of DocumentosStockContagemArtigos)
    End Sub

    Public Property CodigoSerie As String
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTiposDocumento", MapearDescricaoChaveEstrangeira:="DescricaoTipoDocumento")>
    Public Property IDTipoDocumento As Long?
    <Display(Name:="TiposDocumento", ResourceType:=GetType(Traducao.EstruturaTiposDocumento))>
    Public Property DescricaoTipoDocumento As String
    Public Property CodigoTipoDocumento As String
    Public Property CodigoDescricaoTipoDocumento As String
    Public Property IDSistemaTipoDocumento As Long?
    Public Property IDModulo As Long?
    Public Property IDTiposDocumentoSeries As Long?
    Public Property DescricaoTiposDocumentoSeries As String
    Public Property NumeroInterno As Long
    Public Property NumeroDocumento As Long
    Public Property Documento As String
    Public Property DataDocumento As Date = Date.Now()
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbArmazens", MapearDescricaoChaveEstrangeira:="DescricaoArmazem")>
    Public Property IDArmazem As Long?
    <Display(Name:="Armazens", ResourceType:=GetType(Traducao.EstruturaArtigos))>
    Public Property DescricaoArmazem As String
    Public Property IDLocalizacao As Long?
    Public Property DescricaoLocalizacao As String
    Public Property Filtro As DocumentosStockContagemFiltro
    Public Property Observacoes As String
    Public Property Artigos As List(Of DocumentosStockContagemArtigos)
    Public Property FaltamContar As Double
    Public Property Contados As Double
    Public Property Diferencas As Double
    Public Property DataControleInterno As Date

    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbEstados", MapearDescricaoChaveEstrangeira:="DescricaoEstado")>
    Public Property IDEstado As Long?
    Public Property CodigoEstado As String
    Public Property CodigoTipoEstado As String
    <Display(Name:="Estado", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DescricaoEstado As String

    Public Property GravouViaEfetivar As Boolean = False

    Public Function EstaEfetivo() As Boolean
        Return CodigoTipoEstado = TiposEstados.Efetivo
    End Function

    Public Function EstaComoRascunho()
        Return CodigoTipoEstado = TiposEstados.Rascunho
    End Function


    Public Shared Function Criar(documento As tbDocumentosStockContagem) As DocumentosStockContagem
        Dim documentoStockContagem = New DocumentosStockContagem()

        With documentoStockContagem
            .ID = documento.ID
            .IDTipoDocumento = documento.IDTipoDocumento
            .DescricaoTipoDocumento = documento.tbTiposDocumento.Descricao
            .CodigoTipoDocumento = documento.tbTiposDocumento.Codigo
            .CodigoDescricaoTipoDocumento = documento.tbTiposDocumento?.Codigo & " - " & documento.tbTiposDocumento?.Descricao
            .IDModulo = documento.tbTiposDocumento?.IDModulo
            .IDSistemaTipoDocumento = documento.tbTiposDocumento?.IDSistemaTiposDocumento
            .IDTiposDocumentoSeries = documento.IDTiposDocumentoSeries
            .DescricaoTiposDocumentoSeries = documento.tbTiposDocumentoSeries?.CodigoSerie
            .NumeroDocumento = documento.NumeroDocumento
            .DataDocumento = documento.DataDocumento
            .IDArmazem = documento.IDArmazem
            .Documento = documento.Documento
            .DescricaoSplitterLadoDireito = .Documento
            .DescricaoArmazem = documento.tbArmazens?.Descricao
            .IDLocalizacao = documento.IDLocalizacao
            .DescricaoLocalizacao = documento.tbArmazensLocalizacoes?.Descricao
            .IDEstado = documento.IDEstado
            .CodigoEstado = documento.tbEstados?.Codigo
            .CodigoTipoEstado = documento.tbEstados?.tbSistemaTiposEstados?.Codigo
            .DescricaoEstado = documento.tbEstados?.Descricao
            .Filtro = JsonConvert.DeserializeObject(Of DocumentosStockContagemFiltro)(documento.Filtro)
            .Observacoes = documento.Observacoes
            '.Artigos = documento.tbDocumentosStockContagemLinhas?.Select(Function(linha) DocumentosStockContagemArtigos.Criar(linha)).ToList()
            .UtilizadorCriacao = documento.UtilizadorCriacao
            .UtilizadorAlteracao = documento.UtilizadorAlteracao
            .CodigoSerie = documento.tbTiposDocumentoSeries?.CodigoSerie
            .Contados = documento.Contados
            .DataAlteracao = documento.DataAlteracao
            .DataCriacao = documento.DataCriacao
            .DataDocumento = documento.DataDocumento
            .FaltamContar = documento.FaltamContar
            .Documento = documento.Documento
        End With

        Return documentoStockContagem
    End Function

    Private Function ConcatenaDocumento() As String
        Return CodigoTipoDocumento & Operadores.EspacoEmBranco & DescricaoTiposDocumentoSeries & Operadores.Slash
        If NumeroDocumento <> 0 Then Documento = Documento & NumeroDocumento
    End Function

    Public Function EEditavel() As Boolean
        Return Not (ID <> 0 AndAlso Artigos.Count)
    End Function

    Public Function AttrButtons() As String
        Return If(Not EEditavel() AndAlso EstaEfetivo(), " disabled", String.Empty)
    End Function

    Public Function AttrButtonEfetivar() As String
        Return If(ID <> 0 AndAlso EstaComoRascunho(), String.Empty, " disabled")
    End Function

    Public Function AttrTemAcessoAnexos() As String
        Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, Menus.DocumentosStockContagemAnexos)

        Return If(boolTemAcessoAnexos, String.Empty, " disabled ")
    End Function

    Public Function MapeiaParaModelo() As tbDocumentosStockContagem
        Return New tbDocumentosStockContagem With {
            .ID = ID,
            .Documento = Documento,
            .NumeroDocumento = NumeroDocumento,
            .DataDocumento = DataDocumento,
            .IDTipoDocumento = IDTipoDocumento,
            .IDArmazem = IDArmazem,
            .IDEstado = IDEstado,
            .IDTiposDocumentoSeries = IDTiposDocumentoSeries,
            .IDLoja = IDLoja,
            .IDLocalizacao = IDLocalizacao,
            .NumeroInterno = NumeroInterno,
            .DataControloInterno = .DataDocumento.Add(Date.Now.TimeOfDay),
            .Filtro = JsonConvert.SerializeObject(Filtro),
            .Observacoes = Observacoes,
            .FaltamContar = FaltamContar,
            .Contados = Contados,
            .Diferencas = Diferencas,
            .UtilizadorCriacao = UtilizadorCriacao,
            .TaxaConversao = ClsF3MSessao.RetornaParametros().MoedaReferencia.TaxaConversao,
            .IDMoeda = ClsF3MSessao.RetornaParametros().MoedaReferencia.ID,
            .DataCriacao = DataCriacao,
            .DataAlteracao = DataAlteracao,
            .tbDocumentosStockContagemLinhas = Artigos.Where(Function(artigo) artigo.IDArtigo IsNot Nothing).Select(Function(artigo) artigo.MapeiaParaModelo()).ToList(),
            .UtilizadorAlteracao = UtilizadorAlteracao
        }
    End Function
End Class