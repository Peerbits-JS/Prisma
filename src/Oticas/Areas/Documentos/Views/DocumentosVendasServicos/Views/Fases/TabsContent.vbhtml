@Modeltype Oticas.DocumentosVendasServicos

@Code
    @For index As Integer = 0 To Model.ServicoFases.Count - 1
        Dim sv As Oticas.ServicosFases = Model.ServicoFases(index)
        Dim tabId As String = "tabServicosFases_" & sv.IDServico & sv.IDTipoServico

        @<div role="tabpanel" class="tab-pane fade" id="@tabId">
            @Html.Partial("Views/Fases/Table", sv)
        </div>
    Next
End Code