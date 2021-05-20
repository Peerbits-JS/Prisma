@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        Html.F3M().Grelha(Of Oticas.Templates)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of Oticas.Templates)(Model).Render()
    End If
End Code