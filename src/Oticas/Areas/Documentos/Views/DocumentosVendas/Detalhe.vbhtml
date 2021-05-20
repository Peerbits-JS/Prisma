@Imports F3M.Modelos.Utilitarios
@Imports F3M.Modelos.Genericos
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.DocumentosVendas

@Html.Partial(URLs.DocumentosComum & "VarsGlobaisDocumentos.vbhtml", Model)
@Html.Partial("Hiddens/Hiddens", Model)

@Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
@Scripts.Render("~/bundles/f3m/jsDocumentosComum")
@Scripts.Render("~/bundles/f3m/jsBaseObservacoes")
@Scripts.Render("~/bundles/f3m/jsDocVendas")

@Code
    'preenche flag se UtilizaConfigDescontos
    Using rpIVA As New Oticas.Repositorio.TabelasAuxiliares.RepositorioIVA
        Model.UtilizaConfigDescontos = rpIVA.UtilizaConfigDescontos
    End Using

    F3M.Repositorio.Comum.RepositorioDocumentos.DefineCamposADesenhar(Model)
    Html.F3M().Hidden("LimiteMaxDesconto", ClsF3MSessao.ListaPropriedadeStorage(Of Double?)("LimiteMaxDesconto"))
End Code

@*VIEW*@
<div class="@(ClassesCSS.FormPrincLDir) @(If(Model.AcaoFormulario <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty))" id="FormularioPrincipalOpcoes">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            @*CABECALHO*@
            @Html.Partial("Views/Cabecalho/Cabecalho", Model)
            @*CONTAINER*@
            @Html.Partial("Views/Container/Container", Model)
        </div>
    </div>
</div>

@*LADO DIREITO*@
@Html.Partial("Views/LadoDireito/LadoDireito", Model)

@*BARRA DE BOTOES*@
@Html.Partial("Views/BarraBotoes/BarraBotoes", Model)

@* ELEMENTO TEMP PARA PREENCHIMENTO DA HANDSONTABLE *@
<div id="tempHdsnDS">
    <script>
        DocumentosCleanBoundIDBAndBuildHT(@Html.Raw(Json.Encode(LZString.RetornaModeloComp(Model.DocumentosVendasLinhas))))
    </script>
</div>