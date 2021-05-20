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

Partial Public Class tbRecibos
    Public Property ID As Long
    Public Property IDTipoDocumento As Long
    Public Property IDTiposDocumentoSeries As Long
    Public Property IDPagamentoVenda As Nullable(Of Long)
    Public Property NumeroDocumento As Nullable(Of Long)
    Public Property DataDocumento As Date
    Public Property DataAssinatura As Nullable(Of Date)
    Public Property DataVencimento As Nullable(Of Date)
    Public Property Documento As String
    Public Property IDEntidade As Nullable(Of Long)
    Public Property IDTipoEntidade As Nullable(Of Long)
    Public Property NomeFiscal As String
    Public Property MoradaFiscal As String
    Public Property IDCodigoPostalFiscal As Nullable(Of Long)
    Public Property IDConcelhoFiscal As Nullable(Of Long)
    Public Property IDDistritoFiscal As Nullable(Of Long)
    Public Property IDPaisFiscal As Nullable(Of Long)
    Public Property CodigoPostalFiscal As String
    Public Property DescricaoCodigoPostalFiscal As String
    Public Property DescricaoConcelhoFiscal As String
    Public Property DescricaoDistritoFiscal As String
    Public Property ContribuinteFiscal As String
    Public Property SiglaPaisFiscal As String
    Public Property TotalMoedaDocumento As Nullable(Of Double)
    Public Property IDMoeda As Nullable(Of Long)
    Public Property TaxaConversao As Nullable(Of Double)
    Public Property TotalMoedaReferencia As Nullable(Of Double)
    Public Property ValorImposto As Nullable(Of Double)
    Public Property IDLoja As Nullable(Of Long)
    Public Property IDLocalOperacao As Nullable(Of Long)
    Public Property IDEstado As Nullable(Of Long)
    Public Property UtilizadorEstado As String
    Public Property DataHoraEstado As Nullable(Of Date)
    Public Property Observacoes As String
    Public Property TipoFiscal As String
    Public Property CodigoTipoEstado As String
    Public Property CodigoEntidade As String
    Public Property CodigoDocOrigem As String
    Public Property CodigoMoeda As String
    Public Property MensagemDocAT As String
    Public Property ValorExtenso As String
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property CodigoPostalLoja As String
    Public Property LocalidadeLoja As String
    Public Property SiglaLoja As String
    Public Property NIFLoja As String
    Public Property DesignacaoComercialLoja As String
    Public Property MoradaLoja As String
    Public Property SegundaVia As Nullable(Of Boolean)
    Public Property DataUltimaImpressao As Nullable(Of Date)
    Public Property NumeroImpressoes As Nullable(Of Integer)
    Public Property IDLojaUltimaImpressao As Nullable(Of Long)
    Public Property TelefoneLoja As String
    Public Property FaxLoja As String
    Public Property EmailLoja As String
    Public Property ConservatoriaRegistoComerciaLoja As String
    Public Property NumeroRegistoComercialLoja As String
    Public Property CapitalSocialLoja As String
    Public Property TotalDifCambialMoedaReferencia As Nullable(Of Double)
    Public Property ATCUD As String
    Public Property ATQRCode As Byte()
    Public Property ATQRCodeTexto As String

    Public Overridable Property tbClientes As tbClientes
    Public Overridable Property tbCodigosPostais As tbCodigosPostais
    Public Overridable Property tbConcelhos As tbConcelhos
    Public Overridable Property tbDistritos As tbDistritos
    Public Overridable Property tbEstados As tbEstados
    Public Overridable Property tbLojas As tbLojas
    Public Overridable Property tbMoedas As tbMoedas
    Public Overridable Property tbPagamentosVendas As tbPagamentosVendas
    Public Overridable Property tbPaises As tbPaises
    Public Overridable Property tbSistemaRegioesIVA As tbSistemaRegioesIVA
    Public Overridable Property tbSistemaTiposEntidade As tbSistemaTiposEntidade
    Public Overridable Property tbTiposDocumento As tbTiposDocumento
    Public Overridable Property tbTiposDocumentoSeries As tbTiposDocumentoSeries
    Public Overridable Property tbRecibosFormasPagamento As ICollection(Of tbRecibosFormasPagamento) = New HashSet(Of tbRecibosFormasPagamento)
    Public Overridable Property tbRecibosLinhas As ICollection(Of tbRecibosLinhas) = New HashSet(Of tbRecibosLinhas)

End Class
