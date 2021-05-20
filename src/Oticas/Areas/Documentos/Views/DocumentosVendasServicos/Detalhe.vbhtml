@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports  Newtonsoft.Json
@Imports F3M.Modelos.Modulos
@Modeltype Oticas.DocumentosVendasServicos

@Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
@Scripts.Render("~/bundles/f3m/jsDocumentosComum")
@Scripts.Render("~/bundles/f3m/jsFormularioDocumentosServicos")

@Code
    'MAIN
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}
    Const URLDocumentosComum As String = "~/Areas/Documentos/Views/DocumentosVendasServicos/Views/"

    'ESTADO POR DEFEITO
    Dim IDEstadoInicialDefeito As Long = ViewBag.IDEstadoInicial
    Dim DescEstadoInicialDefeito As String = ViewBag.DescricaoEstadoInicialDefeito
    If AcaoForm <> AcoesFormulario.Adicionar Then
        IDEstadoInicialDefeito = Model.IDEstado
        DescEstadoInicialDefeito = Model.DescricaoEstado
    End If

    ' HIDDEN FIELDS - APENAS PARA DOC VENDAS E SERVICOS
    Html.F3M().Hidden("IDDocumentoVenda", Model.ID)
    Html.F3M().Hidden("SimboloMoedaRefEmpresa", ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)
    Html.F3M().Hidden("SimboloMoedaRefCliente", Model.Simbolo)
    Html.F3M().Hidden("hdsfIDCliente", Model.IDEntidade, atrHTML)
    Html.F3M().Hidden("TipoDeLente", String.Empty) 'LC || LO
    Html.F3M().Hidden("LimiteMaxDesconto", ClsF3MSessao.ListaPropriedadeStorage(Of Double?)("LimiteMaxDesconto"))

    'HIDDEN FIELD  - PARA CONTROLO SE UTILIZA A CONFIGURACAO DE DESCONTOS
    Html.F3M().Hidden("UtilizaConfigDescontos", Model.UtilizaConfigDescontos)

    Html.F3M().Hidden("GraduacoesAlteradas", "[]", atrHTML)

    Html.F3M().Hidden("NewUserOnFeature", Model.isNewUserOnFeature)

    Dim ModelSerialized As String = JsonConvert.SerializeObject(Model, Formatting.None, New JsonSerializerSettings() With {.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore})
End Code

<div class="@(ClassesCSS.FormPrincLDir) @(If(AcaoForm <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty))" id="FormularioPrincipalOpcoes">
    <div class="FormularioAjudaScroll mais-larga-servicos">
        <div class="container-fluid">
            <div id="containerCabecalho" class="row desContainer">
                @Html.Partial(URLs.DocumentosComum & "Cabecalho.vbhtml", Model)

                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Idade",
                                .Label = Traducao.EstruturaDocumentos.Idade,
                                .TipoEditor = Mvc.Componentes.F3MTexto,
                                .Modelo = Model,
                                .EEditavel = False,
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS1}})
                End Code
            </div>
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <ul class="nav nav-pills f3m-tabs__ul" role="tablist" id="tabsSevicos">
                    @* TABS *@
                    @Html.Partial(URLDocumentosComum & "Tabs.vbhtml")
                </ul>
                <div class="tab-content">
                    @* HISTORICO *@
                    @Html.Action(URLs.HistComumIndex, Modelos.Constantes.Menus.Historicos, New With {.Area = Modelos.Constantes.Menus.Historicos, .inModelo = Model})

                    @if AcaoForm <> AcoesFormulario.Adicionar AndAlso ModulosSessao.Existe(ClsF3MSessao.RetornaChaveSessao(), ModulosLicenciamento.Prisma.Oficina) Then
                        @Html.Partial(URLDocumentosComum & "Fases/Card.vbhtml", Model)
                    End If

                    @* SERVICOS *@
                    @Html.Partial(URLDocumentosComum & "Servicos.vbhtml", New With {.Modelo = Model})

                    @* ARTIGOS *@
                    @Html.Partial(URLDocumentosComum & "Artigos.vbhtml", New With {.Modelo = Model})

                    @* COMPARTICIPACAO *@
                    @Html.Partial(URLDocumentosComum & "Comparticipacao.vbhtml")

                    @* OBSERVACOES *@
                    @Html.Partial(URLDocumentosComum & "Observacoes.vbhtml", Model)
                </div>
            </div>
        </div>
    </div>
    @Html.Partial(URLDocumentosComum & "NewFeatureModal/Modal.vbhtml")
</div>

@* ESTADOS E TOTAIS *@
@Html.Partial(URLs.EstadosComum & "LadoDireito.vbhtml", New With {
                                                                   .URLTotaisFechados = URLDocumentosComum & "TotaisFechados.vbhtml",
                                                                   .URLTotaisAbertos = URLDocumentosComum & "TotaisAbertos.vbhtml",
                                                                   .AbrevFuncionalidade = TiposEntidadeEstados.Servicos,
                                                                   .IDEstadoInicialDefeito = IDEstadoInicialDefeito,
                                                                   .DescricaoEstadoInicialDefeito = DescEstadoInicialDefeito,
                                                                   .FlagAdicionaEstado = False,
                                                                   .Modelo = Model})

@* BARRA DE BOTOES LADO DIREITO *@
@Html.Partial(URLDocumentosComum & "BarraBotoes.vbhtml")


@* elemento temporário para preenchimento da hansontable *@
<div id="tempHdsnDS">
    <script>
        ServicosDataBoundModelo(@Html.Raw(ModelSerialized))
    </script>
</div>