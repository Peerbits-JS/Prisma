@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype Oticas.LadoDireito
@Code
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario

    Html.F3M().Hidden("CodigoTemplate", Model.HistoricoExames.CodigoTemplate)
End Code

<!-- START LADO DIREITO -->
<div class="f3m-aside f3m-aside--lg @ClassesCSS.ComBts">
    <div class="f3m-aside__closed f3m-aside__closed--dir @Operadores.EspacoEmBranco">
        <!--CLOSE -->
        <a class="btnmove-dir" id="btnsomatorio">
            <span class="fm f3icon-angle-left"></span><span class="fm f3icon-angle-left"></span><span class="fm f3icon-angle-left"></span>
        </a>
        <div class="soma-resumo">
            @Html.Partial(Model.URLPartialViewFechada, Model.HistoricoExames)
        </div>
    </div>
    <!-- OPEN -->
    <div class="lado-dir-info lado-dir-close" id="area-somatorio">
        <div class="lado-info-content">
            @Html.Partial(Model.URLPartialViewAberta, Model.HistoricoExames)
        </div>
    </div>
</div>
<!-- END LADO DIREITO -->