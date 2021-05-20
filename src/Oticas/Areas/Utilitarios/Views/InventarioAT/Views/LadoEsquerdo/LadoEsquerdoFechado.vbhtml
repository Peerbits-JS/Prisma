@Modeltype Oticas.InventarioAT

<div class="txt-resumo">
    @Traducao.EstruturaDocumentosStockContagem.Data&nbsp;
    <span class="badge badge-pill badge-secondary CLSF3MLadoEsqFilterDate">@Model.Filter.FilterDate.ToShortDateString()</span>

    @Traducao.EstruturaUtilitarios.Armazens&nbsp;
    <span class="badge badge-pill badge-secondary CLSF3MLadoEsqWareHouses">@Model.Filter.Warehouses.Count</span>
</div>