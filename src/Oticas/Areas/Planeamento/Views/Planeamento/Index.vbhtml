@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Calendario
@Imports F3M.Modelos.Componentes

@Code
    Layout = URLs.SharedLayoutTabelas
    Dim urlHomepageTitulo As String = "~/F3M/Views/Partials/F3MMenuFavoritoHomepageTitulo.vbhtml"
    Dim Model As New F3MAreaSideBars
    With Model
        .URLLadoEsquerdo = "~/Areas/Planeamento/Views/Planeamento/BarraEsq.vbhtml" 'obrigatório, define conteúdo da barra esq'
        .URLLadoDireito = "" 'obrigatório, define conteúdo da barra dir'
        .URLAreaGeral = "~/Areas/Planeamento/Views/Planeamento/AreaGeral.vbhtml" 'obrigatório, define conteúdo da área geral'
        .TamanhoBarraEsq = "330px" 'obrigatório, largura das barras'
        .AreaGeralClasses = "junto-barra-esquerda f3m-agenda"  'obrigatório, coloca margins para as barras estarem devidamente ajustadas com os limites da area geral/central'
        .LateralEsqEstado = False 'obrigatório, faz com que a barra esquerda esteja expandida quando a secção é aberta'
        .LateralDirEstado = False 'obrigatório, faz com que a barra direita esteja expandida quando a secção é aberta'
        .URLLadoEsquerdoFechado = "~/Areas/Planeamento/Views/Planeamento/BarraEsqFechada.vbhtml" 'obrigatório, coloca conteúdo na barra esquerda quando esta está fechada'
        .URLLadoDireitoFechado = "" 'obrigatório, coloca conteúdo na barra direita quando esta está fechada'
        .LateralEsqAbertaIcon = "f3icon-filtro"  'nao obrigatorio'
        .LateralEsqAbertaIconTitulo = " FILTRAR POR"  'nao obrigatorio'
        .LateralDirAbertaIcon = "f3icon-filtro"  'nao obrigatorio'
        .LateralDirAbertaIconTitulo = "F3M"  'nao obrigatorio'
        .LateralEsqFechadaIcon = "f3icon-filtro"  'nao obrigatorio'
        .LateralEsqPrimeiroTxtResumo = "Lojas "  'nao obrigatorio'
        .LateralEsqPrimeiroBadge = "2"  'nao obrigatorio'
        .LateralEsqSegundoTxtResumo = "Médicos "  'nao obrigatorio'
        .LateralEsqSegundoBadge = "2"  'nao obrigatorio'
        '.LateralEsqTerceiroTxtResumo = "Especialidades "  'nao obrigatorio'
        '.LateralEsqTerceiroBadge = "2"  'nao obrigatorio'
        .LateralDirFechadaIcon = "f3icon-filtro"  'nao obrigatorio'
        .LateralDirPrimeiroTxtResumo = "F3M"  'nao obrigatorio'
        .LateralDirPrimeiroBadge = "1"  'nao obrigatorio'
        .LateralDirSegundoTxtResumo = "F3M"  'nao obrigatorio'
        .LateralDirSegundoBadge = "2"  'nao obrigatorio'
        '.LateralDirTerceiroTxtResumo = "F3M"  'nao obrigatorio'
        '.LateralDirTerceiroBadge = "3" 'nao obrigatorio'
    End With
End Code

<div id="dvPlaneamento">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            @Html.Partial(urlHomepageTitulo)
        </div>
        <div class="float-right f3m-top__right">
            @Code
                Html.F3M().Botao("btnReset", Mvc.BotoesGrelha.Refrescar & Mvc.BotoesGrelha.BtsCRUD, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar, "refresh")
            End Code
        </div>
    </div>
    @Html.Partial("~/F3M/Views/Partials/F3MAreaSideBars.vbhtml", Model)
    </div>

    @Scripts.Render("~/bundles/f3m/timezones")
    @Scripts.Render("~/bundles/f3m/jsScheduler")
    @Scripts.Render("~/bundles/f3m/jsPlaneamento")

    <!-- TODO -->
    <script>
        $(document).ready(function () {
            ComboBoxAbrePopup();
        });
    </script>