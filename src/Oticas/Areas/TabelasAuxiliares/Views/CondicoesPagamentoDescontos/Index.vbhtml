@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 200,
        .EVisivel = False})
    
    listaCol.Add(New ClsF3MCampo With {.Id = "AteXDiasAposEmissao",
        .TipoEditor = Mvc.Componentes.F3MNumeroInt,
        .CasasDecimais = 0,
        .ValorMinimo = 0,
        .ValorMaximo = 999,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Desconto",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem,
        .ValorMinimo = 0,
        .ValorMaximo = 100,
        .LarguraColuna = 300})

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptEnviaParams = "CondicoesPagamentoEnviaParametros",
        .FuncaoJavascriptGridEdit = "CondicoesPagamentoEditaGrelha",
        .FuncaoJavascriptGridDataBound = "CondicoesPagamentoDataBound",
        .Altura = 200,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Descontos,
        .GravaNoCliente = True,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of CondicoesPagamentoDescontos)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDCondicaoPagamento' });
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code