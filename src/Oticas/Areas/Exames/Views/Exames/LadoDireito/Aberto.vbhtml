@Modeltype Oticas.HistoricoExames

@Scripts.Render("~/bundles/f3m/jsExamesHistorico")

<div id="historicocliente" class="lateral-direita">
    <!-- TITTLE -->
    <div class="text-center lado-direito-titulo">
        <strong>@Traducao.EstruturaExames.Historico <strong class="numberOfExames">(@Model.ListOfExamesDatas.Count)</strong></strong>
    </div>

    <!-- HISTORY -->
    @Html.Partial("LadoDireito/DatasExames/DatasExames", Model.ListOfExamesDatas)

    @Code
        Dim strClassDisabled As String = " disabled "
        If Model.ListOfExamesDatas.Count > 1 Then
            strClassDisabled = String.Empty
        End If

        @<div class="mt-3">
            <button id="btnVerConsulta" class="btn btn-sm f3m-btn-outline btn-block @strClassDisabled">Ver consulta</button>
        </div>
    End Code


    <!-- EXPAND / COLLAPASE BUTTONS -->
    <div id="expandAndCollpase" class="text-center control-foles mt-3">
        <div class="btn-group btn-group-toggle" role="group">
            <a id="expandAccordions" class="btn btn-line f3m-btn-xs">@Traducao.EstruturaAplicacaoTermosBase.ExpandirTodos</a>
            <a id="collapseAccordions" class="btn btn-line f3m-btn-xs">@Traducao.EstruturaAplicacaoTermosBase.ColapsarTodos</a>
        </div>
    </div>

    <!-- ACCORDIONS -->
    <div id="accordions" class="f3m-grupo-card-collapse">
        @*TODO MAF*@
        @Code
            Dim ViewName As String = String.Empty

            Select Case Model.CodigoTemplate
                Case "CONS"
                    ViewName = "Consulta"

                Case "DIAG"
                    ViewName = "Diagnostico"

                Case Else
                    ViewName = "Consulta"
            End Select

        End Code

        @Html.Partial("LadoDireito/Accordions/Accordions" & ViewName, Model)
    </div>
</div>

