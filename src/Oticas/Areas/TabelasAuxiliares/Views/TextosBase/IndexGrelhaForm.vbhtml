@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        With Model
            .FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

            If .OrigemF4 = "communicationsms" Then
                .FuncaoJavascriptEnviaParams = "window.parent.$communication.ajax.CommunicationSmsEnviaParams"
            End If

            If .OrigemF4 = "comunicacaosetting" Then
                .FuncaoJavascriptEnviaParams = "window.parent.$communicationrecipts.ajax.CommunicationSmsEnviaParams"
            End If
        End With

        Html.F3M().Grelha(Of TextosBase)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of TextosBase)(Model).Render()
    End If
End Code