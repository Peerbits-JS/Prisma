@Imports F3M.Modelos.Constantes
@Modeltype Oticas.HistoricoExames

@Code
    If Not Model.IDExameSelecionado Is Nothing Then
        Dim _TestesSubjetivos As List(Of HistoricoExamesAccordionsInfo) = Model.ExamesAccordions.ListOfExamesAccordionsInfo

        '---- Observacoes
        Dim strTituloObservacoes As String = _TestesSubjetivos.Where(Function(w) w.ModelPropertyName = "CT_TS_OBS").FirstOrDefault.Label
        Dim strObservacoes As String = _TestesSubjetivos.Where(Function(w) w.ModelPropertyName = "CT_TS_OBS").FirstOrDefault.ValorID
End Code

@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_TS_ML_ML", .ModelAccordion = _TestesSubjetivos})
@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_TS_BL_BL", .ModelAccordion = _TestesSubjetivos})
@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_TS_CCM_CCM", .ModelAccordion = _TestesSubjetivos, .EmptyLastColsExtra = 2})


<div class="mt-15">
    <strong> @strTituloObservacoes</strong>
    @If Not String.IsNullOrEmpty(strObservacoes) Then
        @<div class="pre-line">@strObservacoes</div>
    Else
        @<div>---</div>
    End If
</div>

@Code
    Else
        @<div>---</div>
    End If
End Code