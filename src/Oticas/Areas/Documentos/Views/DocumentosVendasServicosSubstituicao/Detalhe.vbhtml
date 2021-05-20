@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Imports Producao.Modelos.Constantes
@Imports  Newtonsoft.Json
@ModelType Oticas.DocumentosVendasServicosSubstituicao

@Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
@Scripts.Render("~/bundles/f3m/jsDocsServicosSubstituicao")

@Html.Partial("Hiddens/Hiddens", Model)

<div class="@(ClassesCSS.FormPrincLDir)" id="FormularioPrincipalOpcoes">
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

@* elemento temporário para preenchimento da hansontable *@
<div id="tempHdsnDS">
    <script>
        $docsservicossubstituicaograds.ajax.SetGrads(@Html.Raw(Json.Encode(Model.Servico.DocumentosVendasLinhasGraduacoes)))
        $docsservicossubstituicaoartigos.ajax.Hdsn(@Html.Raw(Json.Encode(Model.Servico.Artigos)));
    </script>
</div>

@*DocsStocksContagemGrelhaConstroiHT*@