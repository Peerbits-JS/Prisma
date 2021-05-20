@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType Oticas.PagamentosVendas

@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")

@Code
    Layout = URLs.SharedLayoutFuncionalidades
    Dim F3MBarLoading As String = URLs.F3MFrontEndComponentes & "BarLoading.vbhtml"

    Dim Opcao As String = ViewBag.Opcao
    If Opcao = "recebimentos" Then
        @Scripts.Render("~/bundles/f3m/jsRecebimentos")
    Else
        @Scripts.Render("~/bundles/f3m/jsPagamentos")
    End If

    Dim Moeda As Moedas = ViewBag.Moeda
    Dim SimboloMoeda As String = Moeda.Simbolo

    Dim Titulo As String = Traducao.EstruturaAplicacaoTermosBase.Recebimentos
    Dim OpcaoE_Imprimir As String = Traducao.EstruturaAplicacaoTermosBase.PagarImprimir

    If Opcao = "pagamentos" OrElse Opcao = "pagamentos_fromdocsvendas" Then
        Titulo = Traducao.EstruturaAplicacaoTermosBase.Pagar

    ElseIf Opcao = "adiantamentos" Then
        Titulo = Traducao.EstruturaAplicacaoTermosBase.Adiantar
        OpcaoE_Imprimir = Traducao.EstruturaAplicacaoTermosBase.AdiantarImprimir
    End If

    Html.F3M().Hidden("tipopagamento", Opcao)
    Html.F3M().Hidden("IDTipoDocumentoServico", ViewBag.IDTipoDocumentoServico)
End Code
<div class="container-fluid container-fluid-window container-window-centrada">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            <div class="f3m-top__title">@Titulo</div>
        </div>
    </div>
    <div class="container-pos">
        @Code
            If Opcao = "recebimentos" Then
                @<div id="listOfRecebimentos">
                    @Html.Partial("~/Areas/PagamentosVendas/Views/Recebimentos/Index.vbhtml")
                </div>
            End If
        End Code
        @* LOADING *@
        @Html.Partial(F3MBarLoading)
        <div class="handson-container @(If(Opcao = "recebimentos", "handson-color", String.Empty))">
            <div id="hdsnDocumentos"></div>
        </div>
        <div class="row">
            <!--Formas de pagamento-->
            <div class="@(ClassesCSS.SoXS5)">
                <div id="dvFormasPagamento" class="lista-scroll"></div>
            </div>
            <div class="@(ClassesCSS.SoXS7)">
                <div class="row">
                    <!--lista de valores a pagar-->
                    <div class="@(ClassesCSS.SoXS7) text-right">
                        <div class="row">
                            <div id="dvTotais" class="@(ClassesCSS.SoXS12)">
                                @Code
                                    If Opcao = "pagamentos" Then
                                        @<div class="valor-titulo">@Traducao.EstruturaAplicacaoTermosBase.Saldo</div>
                                        @<h3 class="valor-dinheiro"><span id="saldo"></span><span>&nbsp;@SimboloMoeda</span></h3>
                                        @<hr />
                                    End If
                                End Code
                                <div class="valor-titulo">@Traducao.EstruturaAplicacaoTermosBase.ValorEntregue</div>
                                <h3 class="valor-dinheiro"><span id="valorEntrege"></span><span>&nbsp;@SimboloMoeda</span></h3>
                                <hr />
                                <div class="valor-titulo">@Traducao.EstruturaAplicacaoTermosBase.Troco</div>
                                <h3 class="valor-dinheiro"><span id="troco"></span><span>&nbsp;@SimboloMoeda</span></h3>
                            </div>
                        </div>
                        @Code
                            If Opcao <> "recebimentos" Then
                        End Code
                        <div Class="row">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {
                                    .Id = "IDContaCaixa",
                                    .Label = Traducao.EstruturaLojas.Caixa,
                                    .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                    .Controlador = "../Caixas/ContasCaixa/CaixasPorLoja",
                                    .Modelo = Model,
                                    .EObrigatorio = True,
                                    .EEditavel = Model.PermiteEditarCaixa AndAlso Opcao <> "recebimentos",
                                    .ViewClassesCSS = {ClassesCSS.XS12 + " bottom"}
                                })
                            End Code
                        </div>
                        @Code
                        End If
                        End Code
                    </div>
                    <!--botões de acao de pagamento / impressao-->
                    <div class="@(ClassesCSS.SoXS5) btns-pos-holder">
                        @Code
                            If Opcao <> "recebimentos" Then
                                @<button id="btnSaveAndPrint" class="btn btn-line btn-block bttn-lg clsBtPrint permImpr @(Mvc.BotoesGrelha.BtsCRUD)" title="@OpcaoE_Imprimir"><div>@OpcaoE_Imprimir</div><h3><strong><span id="totalPagarImprimir"></span><span>&nbsp;@SimboloMoeda</span></strong></h3></button>
                                @<button id="btnSave" class="btn main-btn btn-block btn-lg clsBtSave @(Mvc.BotoesGrelha.BtsAcoes)" title="@Titulo"><div>@Titulo</div><h3><strong><span id="totalPagar"></span><span>&nbsp;@SimboloMoeda</span></strong></h3></button>
                            Else
                                @<button id="btnPrint" class="btn btn-line btn-block bttn-lg clsBtPrint permImpr @(Mvc.BotoesGrelha.BtsCRUD)" title="@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPImprimir"><div>@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPImprimir</div><h3><strong><span class="fm f3icon-print fm-3x"></span></strong></h3></button>
                                @<button id="btnAnular" class="btn btn-danger btn-block btn-nopay btn-lg" title=@Traducao.EstruturaAplicacaoTermosBase.Anular><span class="fm f3icon-trash-o"></span>@Traducao.EstruturaAplicacaoTermosBase.Anular</button>
                            End If

                            If Opcao <> "pagamentos_fromdocsvendas" Then
                                @<button id="btnRefresh" class="btn btn-info btn-block btn-nopay clsBtPrint permImpr @(Mvc.BotoesGrelha.BtsCRUD) btn-lg" title="@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar"><span class="fm f3icon-refresh"></span> @Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar</button>
                            End If
                            @<button id="btnCancelar" class="btn btn-warning btn-block btn-nopay btn-lg" title="@Traducao.EstruturaAplicacaoTermosBase.Cancelar"><span class="fm f3icon-times-square"></span>@Traducao.EstruturaAplicacaoTermosBase.Cancelar</button>
                        End Code
                    </div>
                </div>
            </div>
            @*<div class="flex com-eq-height">

        </div>*@
        </div>
    </div>
</div>

<h1 id="lblAnulado" class="anulado">@Traducao.EstruturaAplicacaoTermosBase.Anulado</h1>