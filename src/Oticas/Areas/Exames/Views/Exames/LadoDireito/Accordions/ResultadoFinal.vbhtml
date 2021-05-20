@Imports F3M.Modelos.Constantes
@Modeltype Oticas.HistoricoExames

@Code
    If Not Model.IDExameSelecionado Is Nothing Then
        Dim _ResultadoFinal As List(Of HistoricoExamesAccordionsInfo) = Model.ExamesAccordions.ListOfExamesAccordionsInfo


        '---- Observacoes
        Dim strTituloObservacoes As String = _ResultadoFinal.Where(Function(w) w.ModelPropertyName = "CT_RF_OBS").FirstOrDefault.Label
        Dim strObservacoes As String = _ResultadoFinal.Where(Function(w) w.ModelPropertyName = "CT_RF_OBS").FirstOrDefault.ValorID
End Code

@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_RF_RF_RF", .ModelAccordion = _ResultadoFinal})

@Code
    @<div class="mt-15">
        <strong> @strTituloObservacoes</strong>
        @If Not String.IsNullOrEmpty(strObservacoes) Then
            @<div class="pre-line">@strObservacoes</div>
        Else
            @<div>---</div>
        End If
    </div>

    Else
        @<div>---</div>
    End If
End Code