@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Componentes

@Code
    Dim AreaSideBars As New F3MAreaSideBars
    With AreaSideBars
        .URLLadoEsquerdo = String.Empty
        .URLLadoDireito = "~/Areas/TabelasAuxiliares/Views/CatalogosLentes/BarraDir.vbhtml"
        .URLAreaGeral = "~/Areas/TabelasAuxiliares/Views/CatalogosLentes/AreaGeral.vbhtml"
        .TamanhoBarraDir = "300px"
        .AreaGeralClasses = "junto-barra-direita com-scroll com-padding-top"
        .URLLadoDireitoFechado = "~/Areas/TabelasAuxiliares/Views/CatalogosLentes/BarraDirFechada.vbhtml"
        .LateralDirAbertaIcon = ""
        .LateralDirAbertaIconTitulo = ""
        .Modelo = Model
        .LateralDirEstado = True
    End With
End Code

<div id="catalogos-lentes-matriz-precos">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            <div class="float-left f3m-top__title">
                <span id="tituloModulo">@Traducao.EstruturaArtigos.MatrizPrecos</span>
            </div>
        </div>
        <div class="float-right f3m-top__right">
            <div class="bts-modo-edita float-left">
                <a id="btnCancelarAlteracoes" class="f3mlink grelha-bts disabled" title="Cancelar">
                    <span class="fm f3icon-times-square"></span>
                </a>
                <a id="btnGuardarAlteracoes" class="f3mlink grelha-bts disabled" title="Gravar alterações">
                    <span class="fm f3icon-floppy-o"></span>
                </a>
            </div>
            <a id="btnApagar" class="f3mlink grelha-bts disabled" title="Apagar">
                <span class="fm f3icon-trash-o"></span>
            </a>
        </div>
    </div>

    @Html.Partial("~/F3M/Views/Partials/F3MAreaSideBars.vbhtml", AreaSideBars)
</div>
