@Imports F3M.Modelos.Utilitarios
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    Dim grid As Fluent.GridBuilder(Of ModelosArtigos)

    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        If Model.OrigemF4.Equals("artigos") Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.$artigos.ajax.IDModeloEnviaParams"
        End If

        If Model.OrigemF4.Equals("tratamentoslentes") Then
            @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresTratamentosLentes")
            Model.FuncaoJavascriptEnviaParams = "TratamentosLentesModeloEnviaParams"
        End If

        If Model.OrigemF4.Equals("suplementoslentes") Then
            @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresSuplementosLentes")
            Model.FuncaoJavascriptEnviaParams = "SuplementosLentesModeloEnviaParams"
        End If

        If Model.OrigemF4.Equals("coreslentes") Then
            @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresCoresLentes")
            Model.FuncaoJavascriptEnviaParams = "CoresLentesModeloEnviaParams"
        End If

        If Model.OrigemF4.Equals("catalogoslentes") Then
            @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresCatalogoLentes")
            Model.FuncaoJavascriptEnviaParams = "CatologoLentesModeloEnviaParams"
        End If

        If Model.OrigemF4.Equals("catalogoslentesservicossubstituicao") Then
            @Scripts.Render("~/bundles/f3m/jsCatalogoLentesSubstituicaoArtigos")
            Model.FuncaoJavascriptEnviaParams = "CatologoLentesModeloEnviaParams"
        End If

        grid = Html.F3M().Grelha(Of ModelosArtigos)(Model)

    Else
        grid = Html.F3M().GrelhaFormulario(Of ModelosArtigos)(Model)
    End If

    With grid
        If Not (Me.Context.Request.QueryString("IDDrillDown") IsNot Nothing AndAlso Me.Context.Request.QueryString("IDDrillDown") <> 0) Then
            .DataSource(Function(ds) ds.Ajax.Filter(Function(ft) ft.Add(Function(model) model.Ativo).IsEqualTo(True)))
        End If

        .Render()
    End With
End Code