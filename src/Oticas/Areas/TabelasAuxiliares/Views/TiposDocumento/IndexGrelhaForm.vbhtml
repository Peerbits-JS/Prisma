@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        If Model.OrigemF4.Equals(GetType(DocumentosVendasServicos).Name.ToLower) Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.DocumentoTiposDocEnviaParams"

        ElseIf Model.OrigemF4.Equals(GetType(DocumentosVendasServicosSubstituicao).Name.ToLower) Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.DocsServicosSubstituicaoTiposDocEnviaParams"

        Else
            @Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/TiposDocumento/IndexGrelhaFormCab.vbhtml", Model)
        End If

        Html.F3M().Grelha(Of TiposDocumento)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of TiposDocumento)(Model).Render()
    End If
End Code