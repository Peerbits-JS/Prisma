@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Imports Producao.Modelos.Constantes
@Imports  Newtonsoft.Json
@ModelType Oticas.DocumentosStockContagem

@Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
@Scripts.Render("~/bundles/f3m/jsDocsStockContagem")

@Html.Partial("Hiddens/Hiddens", Model)

@Code
    Dim AcaoForm As Int16 = Model.AcaoFormulario
    Dim ModelSerialized As String = JsonConvert.SerializeObject(Model.Artigos, Formatting.None, New JsonSerializerSettings() With {.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore})
End Code

@Html.Partial("Views/LadoEsquerdo/LadoEsquerdo", Model)

<div class="@(ClassesCSS.FormPrincLEsqAbertoLDir) @(If(AcaoForm <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty)) com-mais-largura" id="FormularioPrincipalOpcoes">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div id="containerCabecalho" class="row desContainer">
                @Html.Partial("Views/Cabecalho/Cabecalho", Model)
            </div>
            @Html.Partial("Views/Container/Container", Model)
        </div>
    </div>
</div>

@Html.Partial("Views/LadoDireito/LadoDireito", Model)

@Html.Partial("Views/BarraBotoes/BarraBotoes", Model)

@* elemento temporário para preenchimento da hansontable *@
<div id="tempHdsnDS">
    <script>
        DocsStocksContagemGrelhaConstroiHT(@Html.Raw(ModelSerialized))
    </script>
</div>

@*DocsStocksContagemGrelhaConstroiHT*@