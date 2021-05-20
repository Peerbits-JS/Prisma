@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Imports F3M.Modelos.Constantes
@Code
    Model.CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Codigo, "asc"}}

    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"
        Html.F3M().Grelha(Of ContasBancarias)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of ContasBancarias)(Model).Render()
    End If
End Code