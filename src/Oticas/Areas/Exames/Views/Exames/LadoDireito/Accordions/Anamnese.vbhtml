@Imports F3M.Modelos.Constantes
@Modeltype Oticas.HistoricoExames

@Code
    If Not Model.IDExameSelecionado Is Nothing Then
        Dim _Anamenese As List(Of HistoricoExamesAccordionsInfo) = Model.ExamesAccordions.ListOfExamesAccordionsInfo

        'MOTIVOS DA CONSULTA
        Dim strMotivosTitulo As String = _Anamenese.Where(Function(w) w.IDElemento = "CT_AN_MC").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().Label
        Dim lstChkMotivos As New List(Of String) From {"CT_AN_MC_RT", "CT_AN_MC_RV", "CT_AN_MC_DVL", "CT_AN_MC_DVP", "CT_AN_MC_ELC"}
        Dim lstMotivos As String() = _Anamenese.Where(Function(w) lstChkMotivos.Contains(w.ModelPropertyName) AndAlso w.ValorID = "True").Select(Function(s) s.Label).ToArray()
        Dim strObsMotivos As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_MC_OUT").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().ValorID

        'DORES DE CABECA
        Dim strDoresCabecaTitulo As String = _Anamenese.Where(Function(w) w.IDElemento = "CT_AN_DC").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().Label
        Dim lstChkDoresCabeca As New List(Of String) From {"CT_AN_DC_LM", "CT_AN_DC_VP", "CT_AN_DC_FT", "CT_AN_DC_OC", "CT_AN_DC_TMP", "CT_AN_DC_SP"}
        Dim lstDoresCabeca As String() = _Anamenese.Where(Function(w) lstChkDoresCabeca.Contains(w.ModelPropertyName) AndAlso w.ValorID = "True").Select(Function(s) s.Label).ToArray()
        Dim strObsDoresCabeca As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_DC_OUT").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().ValorID

        'SAUDE GERAL
        Dim strSaudeGeralTitulo As String = _Anamenese.Where(Function(w) w.IDElemento = "CT_AN_SG").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().Label
        Dim lstChkSaudeGeral As New List(Of String) From {"CT_AN_SG_DB", "CT_AN_SG_HA", "CT_AN_SG_CO", "CT_AN_SG_AC", "CT_AN_SG_CT", "CT_AN_SG_HO", "CT_AN_SG_GC", "CT_AN_SG_MA"}
        Dim lstSaudeGeral As String() = _Anamenese.Where(Function(w) lstChkSaudeGeral.Contains(w.ModelPropertyName) AndAlso w.ValorID = "True").Select(Function(s) s.Label).ToArray()
        Dim strObsSaudeGeral As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_SG_OUT").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().ValorID

        'HISTORIA CLINICA
        Dim strHistClinicaTitulo As String = _Anamenese.Where(Function(w) w.IDElemento = "CT_AN_HC").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().Label
        Dim strHistClinicaAntFamTitulo As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_HC_AF").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().Label
        Dim strHistClinicaAntFam As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_HC_AF").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().ValorID

        Dim strHistClinicaMedTitulo As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_HC_MD").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().Label
        Dim strHistClinicaMed As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_HC_MD").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().ValorID

        Dim strHistClinicaOutroTitulo As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_HC_OUT").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().Label
        Dim strHistClinicaOutro As String = _Anamenese.Where(Function(w) w.ModelPropertyName = "CT_AN_HC_OUT").DefaultIfEmpty(New HistoricoExamesAccordionsInfo).FirstOrDefault().ValorID

        '<!-- DESENHA ANAMENESE -->
        @<div>
            <div class="@ClassesCSS.XS6">
                <!-- MOTIVOS -->
                <div class="row mb-15">
                    <strong class="accordion-sub-tittle">@strMotivosTitulo</strong>
                    @Code
                        If lstMotivos.Count = 0 AndAlso String.IsNullOrEmpty(strObsMotivos) Then
                            @<div>---</div>

                        Else
                            'DESENHA CHECKBOXS
                            For Each item In lstMotivos
                                @<div>@item</div>
                            Next

                            'DESENHA OBSERVACOES
                            @<div class="pre-line">@strObsMotivos</div>
                        End If
                    End Code
                </div>
                <!-- DORES DE CABECA -->
                <div class="row mb-15">
                    <strong class="accordion-sub-tittle">@strDoresCabecaTitulo</strong>
                    @Code
                        If lstDoresCabeca.Count = 0 AndAlso String.IsNullOrEmpty(strObsDoresCabeca) Then
                            @<div>---</div>

                        Else
                            'DESENHA CHECKBOXS
                            For Each item As String In lstDoresCabeca
                                @<div>@item</div>
                            Next

                            'DESENHA OBSERVACOES
                            @<div class="pre-line">@strObsDoresCabeca</div>
                        End If
                    End Code
                </div>
                <!-- SAUDE GERAL -->
                <div class="row mb-15">
                    <strong class="accordion-sub-tittle">@strSaudeGeralTitulo</strong>
                    @Code
                        If lstSaudeGeral.Count = 0 AndAlso String.IsNullOrEmpty(strObsSaudeGeral) Then
                            @<div>---</div>

                        Else
                            'DESENHA CHECKBOXS
                            For Each item As String In lstSaudeGeral
                                @<div>@item</div>
                            Next

                            'DESENHA OBSERVACOES
                            @<div class="pre-line">@strObsSaudeGeral</div>
                        End If
                    End Code
                </div>
            </div>
            <!-- MEDICACAO -->
            <div class="@ClassesCSS.XS6">
                <div>
                    <strong class="accordion-sub-tittle">@strHistClinicaTitulo</strong>
                </div>
                <div class="mb-15">
                    <strong>@strHistClinicaAntFamTitulo</strong>

                    @If Not String.IsNullOrEmpty(strHistClinicaAntFam) Then
                        @<div class="pre-line">@strHistClinicaAntFam</div>
                    Else
                        @<div>---</div>
                    End If
                </div>

                <div class="mb-15">
                    <strong>@strHistClinicaMedTitulo</strong>

                    @If Not String.IsNullOrEmpty(strHistClinicaMed) Then
                        @<div  class="pre-line">@strHistClinicaMed</div>
                    Else
                        @<div>---</div>
                    End If
                </div>

                <div class="mb-15">
                    <strong>@strHistClinicaOutroTitulo</strong>

                    @If Not String.IsNullOrEmpty(strHistClinicaOutro) Then
                        @<div  class="pre-line">@strHistClinicaOutro</div>
                    Else
                        @<div>---</div>
                    End If
                </div>
            </div>
        </div>
End Code

@Code
    Else
        @<div>---</div>
    End If
End Code