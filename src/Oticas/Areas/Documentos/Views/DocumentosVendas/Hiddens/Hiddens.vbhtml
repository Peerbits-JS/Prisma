@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosVendas

@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    ' HIDDEN FIELDS - APENAS PARA DOC VENDAS E SERVICOS
    Html.F3M().Hidden("IDDocumentoVenda", Model.ID)
    Html.F3M().Hidden("SimboloMoedaRefEmpresa", ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)
    Html.F3M().Hidden("SimboloMoedaRefCliente", Model.Simbolo)
    Html.F3M().Hidden("hdsfIDCliente", Model.IDEntidade, atrHTML)
    Html.F3M().Hidden("TipoDeLente", String.Empty) 'LC || LO

    Html.F3M().Hidden("EspacoFiscal", Model.DescricaoEspacoFiscal, atrHTML)
    Html.F3M().Hidden("RegimeIva", Model.DescricaoRegimeIva, atrHTML)
    Html.F3M().Hidden("DescricaoLocalOperacao", Model.DescricaoLocalOperacao, atrHTML)
    Html.F3M().Hidden("SiglaPaisFiscal", Model.SiglaPaisFiscal, atrHTML)


    Html.F3M().Hidden("EImpFromServicosToFT2", Model.flgImpFromServicosToFT2.ToString.ToLower())
    Html.F3M().Hidden("EImpFromServicosToDV.", Model.flgImpFromServicosToDV.ToString.ToLower())
    Html.F3M().Hidden("EImpFromVendasToNC", Model.flgImpFromVendasToNC.ToString.ToLower())

    Html.F3M().Hidden("IDDocumentoVendaServico", Model.IDDocumentoVendaServico)

    Html.F3M().Hidden("F3MMarcadorDocOrigem", Model.F3MMarcadorDocOrigem, atrHTML)
    Html.F3M().Hidden("IdDocOrigem", Model.IdDocOrigem, atrHTML)

    'HIDDEN FIELD  - PARA CONTROLO SE UTILIZA A CONFIGURACAO DE DESCONTOS
    Html.F3M().Hidden("UtilizaConfigDescontos", Model.UtilizaConfigDescontos)
    Html.F3M().Hidden("OrigemEntidade2", Model.OrigemEntidade2, atrHTML)
End Code