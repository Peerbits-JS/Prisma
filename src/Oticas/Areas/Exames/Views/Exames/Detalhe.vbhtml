@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype Oticas.Exames

@Scripts.Render("~/bundles/f3m/jsExames")
@Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
@Scripts.Render("~/bundles/f3m/jsTabComponent")
@Html.Partial(URLs.PartialTopo)

@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "ExamesAnexos")
    Dim UrlComponentesEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MDesenhaComponentes.vbhtml"
    Dim F3MBarLoading As String = String.Concat(URLs.F3MFrontEndComponentes, "BarLoading.vbhtml")
    Html.F3M().Hidden(CamposGenericos.AcaoFormulario, Model.AcaoFormulario, atrHTML)
    Html.F3M().Hidden("IDAgendamento", Model.IDAgendamento, atrHTML)
    Html.F3M().Hidden("IDMedicoTecnico", Model.IDMedicoTecnico, atrHTML)
    Html.F3M().Hidden("IDTemplate", Model.IDTemplate, atrHTML)
End Code

<!-- FORMULARIO -->
<div class="@ClassesCSS.FormPrincLDir @ClassesCSS.ComBts f3m-aside-dir--open-lg" id="FormularioPrincipalOpcoes">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <!-- CABECALHO -->
            @Html.Partial("Cabecalho/Cabecalho", Model)

            <!-- LOADING BAR -->
            @*@Html.Partial(F3MBarLoading)*@

            <div id="main-content" class="tabs-exames">
                <!-- CONTENT -->
                @Html.Partial("Content/MainContent", Model)
            </div>
        </div>
    </div>
</div>

<!-- BARRA DE HISTORICO -->
@Html.Partial("LadoDireito/LadoDireito", New LadoDireito With {
                .AcaoFormulario = AcaoForm,
                .URLPartialViewAberta = "LadoDireito/Aberto",
                .URLPartialViewFechada = "LadoDireito/Fechado",
                .HistoricoExames = Model.HistoricoExames})


<!-- BARRA BOTOES DE ACOES -->
<div class="f3m-lateral-botoes">
    <ul>
        <!-- BOTAO DE ANEXOS -->
        @Code
            If AcaoForm <> AcoesFormulario.Adicionar AndAlso boolTemAcessoAnexos Then
                @<li>
                    <div class="spriteLayout AsideIconsPosition anexos">
                        <a id="btnAnexos" class="anexContainer btn main-btn" title="@(Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAnexos)">
                            <span class="badge badge-anexos hidden"></span><span class="fm f3icon-paperclip"></span>
                        </a>
                    </div>
                </li>
            End If
        End Code
        <!-- BOTAO DE AGENDAR NOVA CONSULTA -->
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="btnNovaConsultaLadoDireito" class="anexContainer btn main-btn" title="@Traducao.EstruturaExames.AgendarNovaConsulta">
                    <span Class="fm f3icon-calendar-plus-o"></span>
                </a>
            </div>
        </li>
    </ul>
</div>