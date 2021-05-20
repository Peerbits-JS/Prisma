'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated from a template.
'
'     Manual changes to this file may cause unexpected behavior in your application.
'     Manual changes to this file will be overwritten if the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Imports System
Imports System.Collections.Generic

Partial Public Class tbFornecedores
    Public Property ID As Long
    Public Property IDLoja As Nullable(Of Long)
    Public Property Codigo As String
    Public Property Nome As String
    Public Property Foto As String
    Public Property FotoCaminho As String
    Public Property DataValidade As Nullable(Of Date)
    Public Property DataNascimento As Nullable(Of Date)
    Public Property IDTipoEntidade As Long
    Public Property Apelido As String
    Public Property Abreviatura As String
    Public Property CartaoCidadao As String
    Public Property TituloAcademico As String
    Public Property IDProfissao As Nullable(Of Long)
    Public Property IDMoeda As Long
    Public Property IDFormaPagamento As Long
    Public Property IDCondicaoPagamento As Long
    Public Property IDTipoPessoa As Nullable(Of Long)
    Public Property IDEspacoFiscal As Long
    Public Property IDRegimeIva As Long
    Public Property IDLocalOperacao As Nullable(Of Long)
    Public Property IDPais As Nullable(Of Long)
    Public Property IDIdioma As Nullable(Of Long)
    Public Property IDSexo As Nullable(Of Long)
    Public Property Contabilidade As String
    Public Property CodIQ As String
    Public Property NIB As String
    Public Property IDFornecimento As Long
    Public Property RegimeEspecial As Boolean
    Public Property EfetuaRetencao As Boolean
    Public Property IvaCaixa As Boolean
    Public Property Observacoes As String
    Public Property Avisos As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property Desconto1 As Double
    Public Property Desconto2 As Double
    Public Property NContribuinte As String
    Public Property Saldo As Nullable(Of Double)
    Public Property Esquecido As Nullable(Of Boolean)
    Public Property CodigoCliente As String

    Public Overridable Property tbArtigosFornecedores As ICollection(Of tbArtigosFornecedores) = New HashSet(Of tbArtigosFornecedores)
    Public Overridable Property tbCondicoesPagamento As tbCondicoesPagamento
    Public Overridable Property tbDocumentosCompras As ICollection(Of tbDocumentosCompras) = New HashSet(Of tbDocumentosCompras)
    Public Overridable Property tbFormasPagamento As tbFormasPagamento
    Public Overridable Property tbIdiomas As tbIdiomas
    Public Overridable Property tbLojas As tbLojas
    Public Overridable Property tbMoedas As tbMoedas
    Public Overridable Property tbPaises As tbPaises
    Public Overridable Property tbProfissoes As tbProfissoes
    Public Overridable Property tbSistemaEspacoFiscal As tbSistemaEspacoFiscal
    Public Overridable Property tbSistemaRegimeIVA As tbSistemaRegimeIVA
    Public Overridable Property tbSistemaRegioesIVA As tbSistemaRegioesIVA
    Public Overridable Property tbSistemaSexo As tbSistemaSexo
    Public Overridable Property tbSistemaTiposEntidade As tbSistemaTiposEntidade
    Public Overridable Property tbSistemaTiposPessoa As tbSistemaTiposPessoa
    Public Overridable Property tbFornecedoresAnexos As ICollection(Of tbFornecedoresAnexos) = New HashSet(Of tbFornecedoresAnexos)
    Public Overridable Property tbFornecedoresContatos As ICollection(Of tbFornecedoresContatos) = New HashSet(Of tbFornecedoresContatos)
    Public Overridable Property tbFornecedoresMoradas As ICollection(Of tbFornecedoresMoradas) = New HashSet(Of tbFornecedoresMoradas)
    Public Overridable Property tbFornecedoresTiposFornecimento As ICollection(Of tbFornecedoresTiposFornecimento) = New HashSet(Of tbFornecedoresTiposFornecimento)
    Public Overridable Property tbPagamentosCompras As ICollection(Of tbPagamentosCompras) = New HashSet(Of tbPagamentosCompras)
    Public Overridable Property tbPagamentosComprasLinhas As ICollection(Of tbPagamentosComprasLinhas) = New HashSet(Of tbPagamentosComprasLinhas)

End Class