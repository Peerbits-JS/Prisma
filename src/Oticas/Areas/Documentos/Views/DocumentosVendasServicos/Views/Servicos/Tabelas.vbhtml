@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Modulos
@Code
    Const URLDocumentosComum As String = "~/Areas/Documentos/Views/DocumentosVendasServicos/Views/"

    Dim botaoHtml As String = Mvc.BotoesGrelha.BotaoHTMLVisivel
    Dim clsCSSAcoes As String = Mvc.BotoesGrelha.BtsAcoes
    Dim Touch As Boolean = ClsF3MSessao.RetornaTouch()
    Dim AcaoForm As AcoesFormulario = Model.Modelo.AcaoFormulario
    Dim simbMoedaAux As String = " " & Model.Modelo.Simbolo

    If Touch Then
        @Scripts.Render("~/bundles/f3m/jsServicosTouch")
    End If

    Html.F3M().Hidden("strMaisDefinicoes", Traducao.EstruturaDocumentos.MaisDefinicoes)

    Dim estaEfetivo As Boolean = Model.Modelo.CodigoTipoEstado = TiposEstados.Efetivo
End Code

<!--Lentes contacto-->

<div id="divHdsnLentes" class="clearfix serv-soma">
    @* L O A D I N G *@
    <div class="grelha-loading-servicos">
        <div id="progressoGrelha_Lentes"></div>
    </div>
    <div class="serv-lentes float-left">
        <div class="@(ConstHT.ClassesHT.Container)" data-id-bar-loading="progressoGrelha_Lentes" style="height:100px">
            <div id="hdsnLentes"></div>
        </div>
    </div>
    <div class="text-right serv-soma-valor">
        <span>@Traducao.EstruturaDocumentos.Total</span><br />
        <span id="totalLentes" class="serv-total">0</span><span class="Currency serv-total">@(simbMoedaAux)</span><br /><br />
        <span>@Traducao.EstruturaDocumentos.TotalComparticipacao</span><br />
        <span id="totalCompLentes" class="serv-total">0</span><span class="Currency serv-total">@(simbMoedaAux)</span>
    </div>
</div>
<!--Oculos-->
<div id="divHdsnLongePerto" class="clearfix serv-soma">
    <div id="containerLonge" class="float-left serv-ht-container">
        @* L O A D I N G *@
        <div class="grelha-loading-servicos">
            <div id="progressoGrelha_Longe"></div>
        </div>
        <div class="serv-oculos float-left">
            <div class="@(ConstHT.ClassesHT.Container)" data-id-bar-loading="progressoGrelha_Longe">
                <div id="hdsnLonge"></div>
            </div>
        </div>
        <div class="text-right serv-soma-valor">
            <span><strong id="lblLonge">@Traducao.EstruturaDocumentos.Longe</strong></span><br /><br />
            <span>@Traducao.EstruturaDocumentos.Total</span><br />
            <span id="totalLonge" class="serv-total">0</span><span class="Currency serv-total">@(simbMoedaAux)></span><br /><br />
            <span>@Traducao.EstruturaDocumentos.TotalComparticipacao</span><br />
            <span id="totalCompLonge" class="serv-total">0</span><span class="Currency serv-total">@(simbMoedaAux)</span>
        </div>
    </div>
    <div id="containerPerto" class="float-left serv-ht-container">
        @* L O A D I N G *@
        <div class="grelha-loading-servicos">
            <div id="progressoGrelha_Perto"></div>
        </div>
        <div class="serv-oculos float-left">
            <div class="@(ConstHT.ClassesHT.Container)" data-id-bar-loading="progressoGrelha_Perto">
                <div id="hdsnPerto"></div>
            </div>
        </div>
        <div class="text-right serv-soma-valor">
            <span><strong id="lblPerto">@Traducao.EstruturaDocumentos.Perto</strong></span><br /><br />
            <span>@Traducao.EstruturaDocumentos.Total</span><br />
            <span id="totalPerto" class="serv-total">0</span><span class="Currency serv-total">@(simbMoedaAux)</span><br /><br />
            <span>@Traducao.EstruturaDocumentos.TotalComparticipacao</span><br />
            <span id="totalCompPerto" class="serv-total">0</span><span class="Currency serv-total">@(simbMoedaAux)</span>
        </div>
    </div>
</div>