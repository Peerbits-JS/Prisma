@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Oticas.DTO
@Imports F3M.Oticas.Translate
@Imports F3M.Modelos.Grelhas
@Imports F3M.Oticas.Translate
@Modeltype AccountingExportDto

<div role="tabpanel" class="f3m-tabs clsF3MTabs">
    @*SPAN DO TEXTO SEM LINHAS*@
    <span class="texto-sem-linhas clsF3MTextoSemLinhas">Não existem documentos que satisfaçam as condições definidas.</span>
    @*GRELHAS COM INFO*@
    <div class="clsF3MGrids hidden">
        <div class="tabs-com-botoes">
            <div class="bts-modo-edita">
                <a id="btnGM" class="btn btn-line btn-sm f3m-btn-xs ClsF3MDados" title="Dados">@AccountingExportResources.GenerateMovements</a>
                <a id="btnEF" class="btn btn-line  btn-sm f3m-btn-xs ClsF3MDados" title="Dados">@AccountingExportResources.ExportFile</a>
            </div>
            <a id="btnReset" class="f3mlink grelha-bts " title="Dados"><span class="fm f3icon-refresh"></span></a>
        </div>
        <ul class="nav nav-pills f3m-tabs__ul" role="tablist">
            <li role="presentation" class="nav-item">
                <a href="#tabDocuments" class="nav-link active" role="tab" data-toggle="tab" aria-expanded="false">Documentos</a>
            </li>
            <li role="presentation" class="nav-item">
                <a href="#tabMovementsDetail" class="nav-link"role="tab" data-toggle="tab" aria-expanded="false">Detalhe de movimentos</a>
            </li>
        </ul>
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane fade show active" id="tabDocuments">
                <div id="documentsGrid" class="F3MGrelha F3MCliente grelha-form-pag"></div>
            </div>
            <div role="tabpanel" class="tab-pane fade" id="tabMovementsDetail">
                <div id="movementsDetailGrid" class="F3MGrelha F3MCliente grelha-form-pag"></div>
            </div>
        </div>
    </div>
</div>