@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas

@*<link href="~/Content/handsontable/handsontable.full.min.css" rel="stylesheet" />
<script src="~/Scripts/de.min.js"></script>
<script src="~/Scripts/numeral.min.js"></script>
<script src="~/Scripts/handsontable.full.min.js"></script>*@
@Code
    Layout = URLs.SharedLayoutFuncionalidades

    @Scripts.Render("~/bundles/f3m/jsFormularioArtigosDimensoes")
    @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresDimensoesLinhas")

    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = "Visivel",
        .TemplateCabecalhoColuna = Mvc.Componentes.F3MCheckBox,
        .EEditavel = False,
        .LarguraColuna = 125})

    listaCol.Add(New ClsF3MCampo With {.Id = "Associado",
        .TemplateCabecalhoColuna = Mvc.Componentes.F3MCheckBox,
        .EEditavel = False,
        .LarguraColuna = 125})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 125})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 250})
    
    listaCol.Add(New ClsF3MCampo With {.Id = "Virtual",
        .LarguraColuna = 125})

    Dim gl As New ClsMvcKendoGrid With {
        .FuncaoJavascriptGridDataBound = "DimensoesDataBoundGrelha",
        .FuncaoJavascriptGridDataBinding = "DimensoesDataBindingGrelha",
        .FuncaoJavascriptGridEdit = "DimensoesEditaGrelha",
        .FuncaoJavascriptEnviaParams = "DimensoesLinhasEnviaParametros",
        .Altura = 350,
        .TamanhoDaPagina = 1000,
        .PermitirFiltrarNaGrelha = True,
        .Campos = listaCol}

    gl.GrelhaHTML = Html.F3M().Grelha(Of Oticas.ArtigosDimensoesLinhas)(gl).AutoBind(False).ToHtmlString()
End Code
<div class="f3m-window">
    <div class="row mb-3">
        <div class="col-4">
            <div class="dropdown ArtigosDimensoesLinhas">
                @Code
                    Html.F3M().DropDownList(New ClsF3MCampo With {
                        .Id = "ddlDimensoes",
                        .TemOptionLabel = False,
                        .FuncaoJSChange = "DimensoesLinhasDDLDimensoesChange",
                        .FuncaoJSDataBound = "DimensoesLinhasDDLDimensoesChange",
                        .FuncaoJSEnviaParams = "DimensoesLinhasDDLDimensoesEnviaParams",
                        .Controlador = "../TabelasAuxiliares/Dimensoes"}).Render()
                End Code
            </div>
        </div>
    </div>

    @Html.Partial(gl.PartialViewInterna, gl)
</div>