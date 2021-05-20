@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        If Model.OrigemF4.Equals("iva") Then
            @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresIVA")
    Model.FuncaoJavascriptEnviaParams = "IVAEnviaParametrosIVARegiao"
End If

Html.F3M().Grelha(Of IVA)(Model).Render()
Else
Html.F3M().GrelhaFormulario(Of IVA)(Model).Render()
End If
End Code