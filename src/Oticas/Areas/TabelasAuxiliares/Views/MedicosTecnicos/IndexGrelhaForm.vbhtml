@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        @Scripts.Render("~/bundles/f3m/jsMedicosTecnicosIndexGrelha")
        Dim funcEnviaParametros As String = "MedicosTecnicosIndexGrelhaEnviaParametros"

        Select Case Model.OrigemF4.ToLower()
            Case "consultas"
                funcEnviaParametros = String.Empty

            Case "planeamento", "agendamento"
                funcEnviaParametros = "window.parent.$kendoScheduler.ajax.MedicoTecnicoEnviaParams"
        End Select

        With Model
            .FuncaoJavascriptEnviaParams = funcEnviaParametros
            .FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"
        End With

        Html.F3M().Grelha(Of MedicosTecnicos)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of MedicosTecnicos)(Model).Render()
    End If
End Code