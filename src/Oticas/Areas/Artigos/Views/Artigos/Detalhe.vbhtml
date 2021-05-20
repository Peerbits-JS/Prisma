@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@ModelType Oticas.Artigos

@Scripts.Render("~/bundles/f3m/jsFormularioArtigos")

@Code
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    ViewBag.VistaParcial = True

    Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, Menus.FornecedoresAnexos)
    Dim URLArtigosComum As String = "~/F3M/Areas/ArtigosComum/Views/ArtigosPart/"

    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    Html.F3M().Hidden("UnidadePorDefeito", ViewBag.UnidadePorDefeito)
    Html.F3M().Hidden("IDLenteOftalmica", ViewBag.IDLenteOftalmica)
    Html.F3M().Hidden("IDTipoPreco", 1, atrHTML)

    Dim hdfIDTipoArtigo As String = String.Empty
    Dim hdfCodigoTipoArtigo As String = String.Empty
    Dim hdfIDMarca As String = String.Empty
    Dim IDDuplica As String = String.Empty

    If AcaoForm <> AcoesFormulario.Adicionar Then
        hdfIDTipoArtigo = Model.IDTipoArtigo
        hdfCodigoTipoArtigo = Model.CodigoSistemaTipoArtigo
    Else
        IDDuplica = If(Model.IDDuplica IsNot Nothing, String.Empty, Model.IDDuplica)
    End If

    'Verifica se desenha campos de preços na tab preços
    Dim CamposNaoDesenhar As New List(Of String)
    If Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, "014.004.031") Then
        CamposNaoDesenhar = New List(Of String)({"UPCPercentagem", "Padrao", "Medio", "UltimoPrecoCusto", "UltimoPrecoCompra", "UltimosCustosAdicionais", "UltimosDescontosComerciais"})
    End If


    Html.F3M().Hidden("hdfIDTipoArtigo", Model.IDTipoArtigo)
    Html.F3M().Hidden("hdfCodigoTipoArtigo", "LO")
    Html.F3M().Hidden("hdfIDMarca", Model.IDMarca)
    Html.F3M().Hidden("IDDuplica", IDDuplica)
    Html.F3M().Hidden("ParametroArtigoCodigo", ClsF3MSessao.RetornaParametros.Lojas.ParametroArtigoCodigo)
End Code

<div class="@(ClassesCSS.FormPrinc) @(If(AcaoForm <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty)) sembotao">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            @Html.Partial(URLArtigosComum & "Cabecalho.vbhtml", Model)
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <ul class="nav nav-pills f3m-tabs__ul clsAreaFixed" role="tablist">
                    @Html.Partial(URLArtigosComum & "Tabs.vbhtml", New With {.TabFornecedores = True})
                </ul>
                <div class="tab-content">
                    @Html.Action(URLs.HistComumIndex, Menus.Historicos, New With {.Area = Menus.Historicos, .inModelo = Model})

                    @Html.Partial(URLArtigosComum & "Identificacao.vbhtml", New With {
                     .URLAros = "~/Areas/Artigos/Views/ArtigosAros/Index.vbhtml",
                     .URLOculosSol = "~/Areas/Artigos/Views/ArtigosOculosSol/Index.vbhtml",
                     .URLLentesContato = "~/Areas/Artigos/Views/ArtigosLentesContato/Index.vbhtml",
                     .URLLentesOftalmicas = "~/Areas/Artigos/Views/ArtigosLentesOftalmicas/Index.vbhtml",
                     .enableMarcaEmEdicao = False,
                     .Modelo = Model})

                    @Html.Partial("~/Areas/Artigos/Views/Artigos/Definicao.vbhtml", Model)

                    @Html.Partial("~/Areas/Artigos/Views/ArtigosFornecedores/Index.vbhtml", Model)

                    @Html.Partial(URLArtigosComum & "Stocks.vbhtml", Model)

                    @Html.Partial(URLArtigosComum & "Lotes.vbhtml", Model)

                    @Html.Partial(URLArtigosComum & "Precos.vbhtml", New With {.Modelo = Model, .CamposNaoDesenhar = CamposNaoDesenhar})

                    @Html.Partial(URLArtigosComum & "Unidades.vbhtml", Model)

                    @Html.Partial(URLArtigosComum & "Idiomas.vbhtml", Model)

                    @Html.Partial(URLArtigosComum & "Observacoes.vbhtml", Model)
                </div>
            </div>
        </div>
    </div>
</div>
<div class="f3m-lateral-botoes @(If(AcaoForm = AcoesFormulario.Adicionar, CssClasses.Hidden, String.Empty))">
    <ul>
        <li><div class="spriteLayout anexos AsideIconsPosition"><a class="anexContainer btn main-btn @(If(boolTemAcessoAnexos, String.Empty, CssClasses.Hidden))" title="Anexos"><span class="badge badge-anexos hidden"></span><span class="fm f3icon-paperclip"></span></a></div></li>
    </ul>
</div>