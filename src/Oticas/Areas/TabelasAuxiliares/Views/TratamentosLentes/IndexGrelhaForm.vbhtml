@Imports F3M.Modelos.Utilitarios
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    Dim grid As Fluent.GridBuilder(Of TratamentosLentes)

    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        If Model.OrigemF4.Equals("artigos") Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.$artigos.ajax.TratamentosEnviaParams"
        End If

        If Model.OrigemF4.Equals("catalogoslentes") Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.$catalogolentes.ajax.EnviaParamsIDModelo"
        End If

        If Model.OrigemF4.Equals("catalogoslentesservicossubstituicao") Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.$docsservicossubstituicaocatalogolentes.ajax.EnviaParamsIDModelo"
        End If

        grid = Html.F3M().Grelha(Of TratamentosLentes)(Model)

    Else
        grid = Html.F3M().GrelhaFormulario(Of TratamentosLentes)(Model)
    End If

    With grid
        If Not (Me.Context.Request.QueryString("IDDrillDown") IsNot Nothing AndAlso Me.Context.Request.QueryString("IDDrillDown") <> 0) Then
            .DataSource(Function(ds) ds.Ajax.Filter(Function(ft) ft.Add(Function(model) model.Ativo).IsEqualTo(True)))
        End If
        .Render()
    End With
End Code