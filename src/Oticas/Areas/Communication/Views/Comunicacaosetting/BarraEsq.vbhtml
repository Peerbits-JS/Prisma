<div id="" class="menu-lateral">
    <div role="tabpanel" class="">
        <div class="tab-content">
            <!--NAVEGAÇÂO-->
            <div role="tabpanel" class="tab-pane active" id="navega">
                <div id="procura" class="pesquisa has-feedback has-feedback-left hidden">
                    <input type="text" id="procuratermo" autocomplete="off" class="form-control" placeholder="@Traducao.EstruturaAplicacaoTermosBase.PesquisarMenu" />
                    <span class="fm f3icon-search2 form-control-feedback" aria-hidden="true"></span>
                    @Code
                        @<div class="collapse-all">
                            <span id="collapseAll" class="k-state-focused" style="display:none;"><span class="fm f3icon-contract-vrt-2"></span>@Traducao.EstruturaAplicacaoTermosBase.Colapsar</span>
                            <span id="expandAll" class="k-state-focused"><span class="fm f3icon-expand-vrt-2"></span>@Traducao.EstruturaAplicacaoTermosBase.Expandir</span>
                        </div>
                    End Code
                </div>
                <button id="btnHistoric" class="btn btn-line btn-block active">Histórico de envios</button>
                <ul id="menu" class="menu-navega list-unstyled mt-3">
                    <li>
                        <div id="arvoremenu"></div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
