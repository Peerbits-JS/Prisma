@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@ModelType Oticas.Fornecedores
@Code
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    ViewBag.VistaParcial = True

    Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, Menus.FornecedoresAnexos)
    Dim podeVerPrecoCusto As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "VerPrecoCusto", True)

    Dim URLFornecedoresComum As String = "~/F3M/Areas/FornecedoresComum/Views/FornecedoresPart/"
End Code
<!-- MAF 13-04-2016 -> A class combts é para mostrar a barra do lado direito! -->
<div class="@(ClassesCSS.FormPrinc) @(If(AcaoForm <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty))">
    <div class="FormularioAjudaScroll mais-larga">
        <div class="container-fluid">
            @Html.Partial(URLFornecedoresComum & "Cabecalho.vbhtml", Model)
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <!--Nav tabs-->
                <ul class="nav nav-pills f3m-tabs__ul clsAreaFixed" role="tablist">
                    @Html.Partial(URLFornecedoresComum & "Tabs.vbhtml")
                </ul>
                <div class="tab-content">
                    @Html.Action(URLs.HistComumIndex, Menus.Historicos, New With {.Area = Menus.Historicos, .inModelo = Model})

                    @Html.Partial(URLFornecedoresComum & "DadosPessoais.vbhtml", New With {
                    .Modelo = Model})

                    @Html.Partial(URLFornecedoresComum & "Moradas.vbhtml", New With {
                    .URL = "~/Areas/Fornecedores/Views/FornecedoresMoradas/Index.vbhtml",
                    .URL2 = "~/Areas/Fornecedores/Views/FornecedoresContatos/Index.vbhtml"})

                    @Html.Partial(URLFornecedoresComum & "DefinicoesComerciais.vbhtml", Model)

                    @Html.Partial(URLFornecedoresComum & "DefinicoesFiscais.vbhtml", Model)

                    @Html.Partial(URLFornecedoresComum & "Fornecimentos.vbhtml", Model)

                    @Html.Partial(URLFornecedoresComum & "Observacoes.vbhtml", Model)
                </div>
            </div>
        </div>
    </div>
</div>
<div class="f3m-lateral-botoes @(If(AcaoForm = AcoesFormulario.Adicionar, CssClasses.Hidden, String.Empty))">
    <ul>
        <li>
            <div class="spriteLayout anexos AsideIconsPosition">
                <a class="anexContainer btn main-btn @(If(boolTemAcessoAnexos, String.Empty, CssClasses.Hidden))" title="Anexos">
                    <span class="badge badge-anexos hidden"></span>
                    <span class="fm f3icon-paperclip"></span>
                </a>
            </div>
        </li>
        @Code
            If podeVerPrecoCusto Then
                @<li>
                    <div Class="spriteLayout AsideIconsPosition">
                        <a id="contacorrente" class="btn main-btn InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.ContaCorrente">CC</a>
                    </div>
                </li>
            End If
        End Code
    </ul>
</div>