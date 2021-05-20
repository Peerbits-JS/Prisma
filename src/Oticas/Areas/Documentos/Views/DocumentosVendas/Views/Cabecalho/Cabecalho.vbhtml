@Imports F3M.Modelos.Genericos
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.DocumentosVendas

<div id="containerCabecalho" class="row desContainer">
    @* CABECALHO*@
    @Html.Partial(URLs.DocumentosComum & "Cabecalho.vbhtml", Model)

    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataVencimento",
                    .Label = Traducao.EstruturaAplicacaoTermosBase.DataVencimento,
                    .TipoEditor = Mvc.Componentes.F3MData,
                    .ValorPorDefeito = DateTime.Now.ToString(FormatoData.DataHora),
                    .Modelo = Model,
                    .EVisivel = Model.GeraPendente,
                    .EObrigatorio = Model.GeraPendente,
                    .AtributosHtml = New With {.class = "textbox-titulo"},
                    .ViewClassesCSS = {ClassesCSS.XS2}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataEntrega",
                    .Label = Traducao.EstruturaAplicacaoTermosBase.DataEntrega,
                    .TipoEditor = Mvc.Componentes.F3MData,
                    .EVisivel = If(Not String.IsNullOrEmpty(Model.CodigoSistemaTiposDocumento) AndAlso (Model.CodigoSistemaTiposDocumento.Equals(TiposSistemaTiposDocumento.ComprasEncomenda) Or Model.CodigoSistemaTiposDocumento.Equals(TiposSistemaTiposDocumento.VendasEncomenda)), True, False),
                    .Modelo = Model,
                    .FuncaoJSChange = "DocumentoDataEntregaChange",
                    .ValorPorDefeito = DateTime.Now.ToString(FormatoData.DataHora),
                    .AtributosHtml = New With {.class = "textbox-titulo"},
                    .ViewClassesCSS = {ClassesCSS.XS2}})
    End Code
</div>