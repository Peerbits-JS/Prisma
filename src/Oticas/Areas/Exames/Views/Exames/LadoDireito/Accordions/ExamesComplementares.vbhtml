@Imports F3M.Modelos.Constantes
@Modeltype Oticas.HistoricoExames

@Code
    If Not Model.IDExameSelecionado Is Nothing Then
        Dim _ExamesComplementares As List(Of HistoricoExamesAccordionsInfo) = Model.ExamesAccordions.ListOfExamesAccordionsInfo

        '---- Biomicroscopia
        Dim strTituloBiomicroscopia As String = _ExamesComplementares.Where(Function(w) w.ModelPropertyName = "CT_EC_BC").FirstOrDefault.Label
        Dim stBiomicroscopia As String = _ExamesComplementares.Where(Function(w) w.ModelPropertyName = "CT_EC_BC").FirstOrDefault.ValorID

        '---- Oftalmoscopia
        Dim strTituloOftalmoscopia As String = _ExamesComplementares.Where(Function(w) w.ModelPropertyName = "CT_EC_OF").FirstOrDefault.Label
        Dim strOftalmoscopia As String = _ExamesComplementares.Where(Function(w) w.ModelPropertyName = "CT_EC_OF").FirstOrDefault.ValorID

        '---- Observacoes
        Dim strTituloObservacoes As String = _ExamesComplementares.Where(Function(w) w.ModelPropertyName = "CT_EC_OBS").FirstOrDefault.Label
        Dim strObservacoes As String = _ExamesComplementares.Where(Function(w) w.ModelPropertyName = "CT_EC_OBS").FirstOrDefault.ValorID
End Code

@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_EC_AR_AR", .ModelAccordion = _ExamesComplementares})
@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_EC_QR_QR", .ModelAccordion = _ExamesComplementares})
@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_EC_PIO_PIO", .ModelAccordion = _ExamesComplementares, .EmptyLastColsExtra = 2})
@Html.Partial("LadoDireito/Accordions/GridHistorico", New HistoricoExamesGrids With {.GridCode = "CT_EC_RT_RT", .ModelAccordion = _ExamesComplementares})

<div Class="mt-15">
    <strong> @strTituloBiomicroscopia</strong>
    @If Not String.IsNullOrEmpty(stBiomicroscopia) Then
        @<div class="pre-line">@stBiomicroscopia</div>
    Else
        @<div>---</div>
    End If
</div>

<div Class="mt-15">
    <strong> @strTituloOftalmoscopia</strong>
    @If Not String.IsNullOrEmpty(strOftalmoscopia) Then
        @<div  class="pre-line">@strOftalmoscopia</div>
    Else
        @<div>---</div>
    End If
</div>

<div Class="mt-15">
    <strong> @strTituloObservacoes</strong>
    @If Not String.IsNullOrEmpty(strObservacoes) Then
        @<div  class="pre-line">@strObservacoes</div>
    Else
        @<div>---</div>
    End If
</div>

@Code
    Else
        @<div>---</div>
    End If
End Code