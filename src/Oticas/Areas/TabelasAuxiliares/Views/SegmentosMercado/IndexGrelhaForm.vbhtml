@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        Html.F3M().Grelha(Of SegmentosMercado)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of SegmentosMercado)(Model).Render()
    End If
End Code