@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosVendas

<div>
    <span class="soma-resumo-valor" id="TotalResumo">@(FormatNumber(Model.TotalMoedaDocumento, Model.CasasDecimaisTotais) & " " & Model.Simbolo)</span>
    <span id="TextoTotalResumo">@(Traducao.EstruturaAplicacaoTermosBase.Totais)</span>
</div>