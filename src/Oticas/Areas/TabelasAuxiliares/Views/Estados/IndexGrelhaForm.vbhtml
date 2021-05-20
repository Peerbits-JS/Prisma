@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        Html.F3M().Grelha(Of Estados)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of Estados)(Model).Render()
    End If
End Code