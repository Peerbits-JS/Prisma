@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Imports Producao.Modelos.Constantes
@Imports  Newtonsoft.Json
@ModelType Oticas.InventarioAT

@Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
@Scripts.Render("~/bundles/f3m/jsInventarioAT")

@Html.Partial("Hiddens/Hiddens", Model)

@Code
    Dim ModelSerialized As String = JsonConvert.SerializeObject(Model.Products, Formatting.None, New JsonSerializerSettings() With {.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore})
End Code

@Html.Partial("Views/LadoEsquerdo/LadoEsquerdo", Model)

<div class="@(ClassesCSS.FormPrincLEsqAberto) @(If(Model.AcaoFormulario <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty))" id="FormularioPrincipalOpcoes">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            @Html.Partial("Views/Container/Container", Model)
        </div>
    </div>
</div>

@Html.Partial("Views/BarraBotoes/BarraBotoes", Model)

@* elemento temporário para preenchimento da hansontable *@
<div id="tempHdsnDS">
    <script>InventarioATGrelhaConstroiHT(@Html.Raw(ModelSerialized));</script>
</div>