@Imports F3M.Modelos.Constantes
@Modeltype Oticas.HistoricoExames

@Code
    If Not Model.IDExameSelecionado Is Nothing Then
        Dim _GraduacaoAtual As List(Of HistoricoExamesAccordionsInfo) = Model.ExamesAccordions.ListOfExamesAccordionsInfo
        Dim _NameGridView As String = "LadoDireito/Accordions/GridHistorico"

        '---- Grids title
        Dim strTituloOculosLonge As String = _GraduacaoAtual.Where(Function(w) w.IDElemento = "CT_GA_OC_LG_MAIN_CAPTION").FirstOrDefault().Label
        Dim strTituloOculosPerto As String = _GraduacaoAtual.Where(Function(w) w.IDElemento = "CT_GA_OC_PT_MAIN_CAPTION").FirstOrDefault().Label
        Dim strTituloLentesContacto As String = _GraduacaoAtual.Where(Function(w) w.IDElemento = "CT_GA_LC__LC_MAIN_CAPTION").FirstOrDefault().Label

        '---- Observacoes
        Dim strTituloObservacoes As String = _GraduacaoAtual.Where(Function(w) w.ModelPropertyName = "CT_GA_OBS").FirstOrDefault.Label
        Dim strObservacoes As String = _GraduacaoAtual.Where(Function(w) w.ModelPropertyName = "CT_GA_OBS").FirstOrDefault.ValorID
End Code

@Html.Partial(_NameGridView, New HistoricoExamesGrids With {.GridCode = "CT_GA_OC", .Title = strTituloOculosLonge, .HeadersCode = "CT_GA_OC", .RowsCode = "CT_GA_OC_LG", .ModelAccordion = _GraduacaoAtual})
@Html.Partial(_NameGridView, New HistoricoExamesGrids With {.GridCode = "CT_GA_OC", .Title = strTituloOculosPerto, .HeadersCode = "CT_GA_OC", .RowsCode = "CT_GA_OC_PT", .ModelAccordion = _GraduacaoAtual})
@Html.Partial(_NameGridView, New HistoricoExamesGrids With {.GridCode = "CT_GA_LC", .Title = strTituloLentesContacto, .HeadersCode = "CT_GA_LC", .RowsCode = "CT_GA_LC_LC", .ModelAccordion = _GraduacaoAtual})

<div Class="mt-15">
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