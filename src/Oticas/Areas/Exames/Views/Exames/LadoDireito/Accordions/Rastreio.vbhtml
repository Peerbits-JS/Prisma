@Imports F3M.Modelos.Constantes
@Modeltype Oticas.HistoricoExames

@Code
    If Not Model.IDExameSelecionado Is Nothing Then
        Dim _GraduacaoAtual As List(Of HistoricoExamesAccordionsInfo) = Model.ExamesAccordions.ListOfExamesAccordionsInfo
        Dim _NameGridView As String = "LadoDireito/Accordions/GridHistorico"

        '---- Grids title
        Dim strTituloOculosLonge As String = _GraduacaoAtual.Where(Function(w) w.IDElemento = "DG_RT_OC_LG_MAIN_CAPTION").FirstOrDefault().Label
        Dim strTituloOculosPerto As String = _GraduacaoAtual.Where(Function(w) w.IDElemento = "DG_RT_OC_PT_MAIN_CAPTION").FirstOrDefault().Label

        '---- Observacoes
        Dim strTituloObservacoes As String = _GraduacaoAtual.Where(Function(w) w.ModelPropertyName = "DG_RT_OBS").FirstOrDefault.Label
        Dim strObservacoes As String = _GraduacaoAtual.Where(Function(w) w.ModelPropertyName = "DG_RT_OBS").FirstOrDefault.ValorID
End Code

@Html.Partial(_NameGridView, New HistoricoExamesGrids With {.GridCode = "DG_RT_OC", .Title = strTituloOculosLonge, .HeadersCode = "DG_RT_OC", .RowsCode = "DG_RT_OC_LG", .ModelAccordion = _GraduacaoAtual})
@Html.Partial(_NameGridView, New HistoricoExamesGrids With {.GridCode = "DG_RT_OC", .Title = strTituloOculosPerto, .HeadersCode = "DG_RT_OC", .RowsCode = "DG_RT_OC_PT", .ModelAccordion = _GraduacaoAtual})

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