@ModelType Oticas.InventarioAT

<div class="f3m-aside">
    <div class="lado-esq-info com-mais-largura" id="area-opcoes">
        <div class="lado-info-content ">
            @Html.Partial("Views/LadoEsquerdo/LadoEsquerdoAberto", Model)
        </div>
    </div>
    <a class="btnmove-esq transparent" id="btnopcoes">
        <span class="fm f3icon-angle-left"></span><span class="fm f3icon-angle-left"></span><span class="fm f3icon-angle-left"></span>
    </a>
    <div class="menu-peq-sombra sem-sombra"></div>
    <div id="abrevopcoes" class="f3m-aside__closed f3m-aside__closed--esq">
        @Html.Partial("Views/LadoEsquerdo/LadoEsquerdoFechado", Model)
    </div>
</div>