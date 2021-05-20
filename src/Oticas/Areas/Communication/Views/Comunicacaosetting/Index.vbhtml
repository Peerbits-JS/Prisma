@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Calendario
@Imports F3M.Modelos.Componentes
@Imports Oticas.Areas.Communication.Models
@ModelType ComunHistoryCommnModels

@Scripts.Render("~/bundles/f3m/jsFormularios")
@Scripts.Render("~/bundles/f3m/jsFormularioCommunsetting")
@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")

@Code
    Layout = URLs.SharedLayoutTabelas
    Dim AreaSideBars As New F3MAreaSideBars
    With AreaSideBars
        .URLLadoEsquerdo = "~/Areas/Communication/Views/Comunicacaosetting/BarraEsq.vbhtml" 'obrigatório, define conteúdo da barra esq'
        .URLLadoDireito = "" 'obrigatório, define conteúdo da barra dir'
        .URLAreaGeral = "~/Areas/Communication/Views/Comunicacaosetting/AreaGeral.vbhtml" 'obrigatório, define conteúdo da área geral'
        .TamanhoBarraEsq = "240px" 'obrigatório, largura das barras'
        .AreaGeralClasses = "junto-barra-esquerda com-scroll"  'obrigatório, coloca margins para as barras estarem devidamente ajustadas com os limites da area geral/central'
        .LateralEsqEstado = True 'obrigatório, faz com que a barra esquerda esteja expandida quando a secção é aberta'
        .LateralDirEstado = False 'obrigatório, faz com que a barra direita esteja expandida quando a secção é aberta'
        .URLLadoEsquerdoFechado = "~/Areas/Communication/Views/Comunicacaosetting/BarraEsqFechada.vbhtml" 'obrigatório, coloca conteúdo na barra esquerda quando esta está fechada'
        .URLLadoDireitoFechado = "" 'obrigatório, coloca conteúdo na barra direita quando esta está fechada'
        .LateralEsqAbertaIcon = ""  'nao obrigatorio'
        .LateralEsqAbertaIconTitulo = ""  'nao obrigatorio'
        '.LateralEsqFechadaIcon = ""  'nao obrigatorio'
        '.LateralEsqPrimeiroTxtResumo = " "  'nao obrigatorio'
        '.LateralEsqPrimeiroBadge = ""  'nao obrigatorio'
        '.LateralEsqSegundoTxtResumo = ""  'nao obrigatorio'
        '.LateralEsqSegundoBadge = ""  'nao obrigatorio'
        '.LateralEsqTerceiroTxtResumo = "Especialidades "  'nao obrigatorio'
        '.LateralEsqTerceiroBadge = "2"  'nao obrigatorio'
        .Modelo = Model
    End With
End Code

<div id="comunicacao-setting">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            @Html.Partial(URLs.PartialMenuFavoritoHomepageTitulo)
        </div>
        <div class="float-right f3m-top__right">
            @Code
                'historic
                Html.F3M().Botao("btnReset", Mvc.BotoesGrelha.Refrescar & Mvc.BotoesGrelha.BtsCRUD, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar, "refresh")
                'edit
                Html.F3M().Botao("btnRemove", Mvc.BotoesGrelha.GuardarFecha & Mvc.BotoesGrelha.BtsCRUD, Traducao.EstruturaAplicacaoTermosBase.Remover, "trash-o")
                Html.F3M().Botao("btnCopy", Mvc.BotoesGrelha.Adicionar & Mvc.BotoesGrelha.BtsCRUD, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPDuplicar, "copy")
                'historic || edit
                Html.F3M().Botao("btnAdd", Mvc.BotoesGrelha.Adicionar & Mvc.BotoesGrelha.BtsCRUD, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAdicionar, "add")
                '
                Html.F3M().Botao("btnEdit", Mvc.BotoesGrelha.GuardarFecha & Mvc.BotoesGrelha.BtsCRUD, "Editar", "edit") 'TODO resources

                'add || edit
            End Code
            <div id="SMSModoEdita" class="bts-modo-edita float-left">
                @Code
                    Html.F3M().Botao("btnCancel", Mvc.BotoesGrelha.Cancelar & Mvc.BotoesGrelha.BtsCRUD, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPCancelar, "times-square")
                    Html.F3M().Botao("btnSave", Mvc.BotoesGrelha.GuardarFecha & Mvc.BotoesGrelha.BtsCRUD, "Gravar", "floppy-o") 'TODO resources
                End Code
            </div>
        </div>
    </div>

    @Html.Partial("~/F3M/Views/Partials/F3MAreaSideBars.vbhtml", AreaSideBars)
</div>