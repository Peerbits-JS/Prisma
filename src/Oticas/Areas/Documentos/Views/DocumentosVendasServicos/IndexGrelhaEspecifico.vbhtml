@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoGrid

@Code
    Layout = URLs.SharedLayoutTabelas
    Dim botaoHtml As String = Mvc.BotoesGrelha.BotaoHTMLVisivel
End Code

@Scripts.Render("~/bundles/f3m/jsServicosImportacao")

<div id="importacao">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            <div id="tituloimportacao" class="f3m-top__title">@OticasTraducao.EstruturaServicos.ImportarSubservico</div>
        </div>
        <div class="float-right f3m-top__right f3mgrelhabts">
            @Html.Raw(String.Format(botaoHtml, Mvc.BotoesGrelha.Refrescar, "", Traducao.EstruturaAplicacaoTermosBase.TOOLTIPRefrescar, "refresh"))
            @Html.Raw(String.Format(botaoHtml, Mvc.BotoesGrelha.Selecionar, "", Traducao.EstruturaAplicacaoTermosBase.TOOLTIPConfirmar, "check-square"))
        </div>
    </div>
    @Code
        Dim listaCol = New List(Of ClsF3MCampo)

        With listaCol
            .Add(New ClsF3MCampo With {.Id = CamposGenericos.Ativo, .EVisivel = False})
            .Add(New ClsF3MCampo With {.Id = "DataDocumento", .LarguraColuna = 150, .EVisivel = True, .TipoEditor = Mvc.Componentes.F3MData, .Formato = "{dd:MM}"})
            .Add(New ClsF3MCampo With {.Id = "Documento", .LarguraColuna = 200, .EVisivel = True, .TipoEditor = Mvc.Componentes.F3MTexto})
            .Add(New ClsF3MCampo With {.Id = "Descricao", .LarguraColuna = 200, .EVisivel = True, .Label = OticasTraducao.EstruturaServicos.Subservico, .TipoEditor = Mvc.Componentes.F3MTexto})
            .Add(New ClsF3MCampo With {.Id = "IDMedicoTecnico", .LarguraColuna = 300, .EVisivel = True, .TipoEditor = Mvc.Componentes.F3MTexto})
            .Add(New ClsF3MCampo With {.Id = "DataReceita", .LarguraColuna = 200, .EVisivel = True, .TipoEditor = Mvc.Componentes.F3MData, .Formato = "{dd:MM}"})
        End With

        With Model
            .Tipo = GetType(Oticas.DocumentosVendasServicos)
            .Paginacao = False
            .CamposOrdenar = New Dictionary(Of String, String) From {{"DataDocumento", "desc"}}
            .Campos = listaCol
            .AccaoCustomizavelLeitura = "ImportaSubServicos"
            .FuncaoJavascriptEnviaParams = "ServicosImportarEnviaParametros"
            .FuncaoJavascriptGridEdit = "GrelhaFormEdit"
            .FuncaoJavascriptGridChange = "GrelhaFormChange"
        End With

        Dim grid As Fluent.GridBuilder(Of Oticas.DocumentosVendasServicos) = Html.F3M().GrelhaFormulario(Of Oticas.DocumentosVendasServicos)(Model)
        grid.Render()
    End Code
</div>