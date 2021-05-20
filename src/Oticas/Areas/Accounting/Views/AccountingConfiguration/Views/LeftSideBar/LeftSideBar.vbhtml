@ModelType Oticas.AccountingConfiguration

<div class="f3m-aside lado-esq-info-larger">
    <div class="lado-esq-info com-mais-largura" id="area-opcoes">
        <div class="lado-info-content ">
            @Html.Partial("Views/LeftSideBar/LeftSideBarOpened", Model)
        </div>
    </div>
    <div class="menu-peq-sombra"></div>
    <a class="btnmove-esq transparent" id="btnopcoes">
        <span class="fm f3icon-angle-left"></span><span class="fm f3icon-angle-left"></span><span class="fm f3icon-angle-left"></span>
    </a>
    <div class="menu-peq-sombra sem-sombra"></div>
    <div id="abrevopcoes" class="f3m-aside__closed f3m-aside__closed--esq">
        @Html.Partial("Views/LeftSideBar/LeftSideBarClosed", Model)
    </div>
</div>