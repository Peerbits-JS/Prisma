@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutFuncionalidades

    Dim URLDocsPagsCompras As String = "~/F3M/Areas/DocumentosComum/Views/DocumentosPagamentosComprasPart/FormasPagamento/"
    Dim Opcao As String = ViewBag.Opcao

    Dim Titulo As String = Traducao.EstruturaAplicacaoTermosBase.Pagar

    If Opcao.ToLower = "recebimentos" Then
        Titulo = Traducao.EstruturaAplicacaoTermosBase.Liquidacao & " -  " & Model.Documento
    End If

    @Scripts.Render("~/bundles/f3m/jsDocumentosPagsComprasFormasPag")
End Code
<div class="container-fluid container-fluid-window container-window-centrada">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            <div class="f3m-top__title">@Titulo</div>
        </div>
    </div>
    <div class="container-pos">
        @*@Code
            If Opcao = "recebimentos" Then
            @<div id="listOfRecebimentos">
                @Html.Partial(URLDocsPagsCompras & "Recebimentos.vbhtml")
            </div>
            End If
            End Code*@
        <div class="row container-pos-data">
            <!--Formas de pagamento-->
            <div class="@(ClassesCSS.SoXS6)">
                <div id="dvFormasPagamento" class="lista-scroll">
                    @Html.Partial(URLDocsPagsCompras & "FormasPagamento.vbhtml")
                </div>
            </div>
            <div class="@(ClassesCSS.SoXS6)">
                <div class="row">
                    <!--lista de valores a pagar-->
                    <div class="@(ClassesCSS.SoXS5) text-right">
                        <div class="row">
                            <div id="dvTotais" class="@(ClassesCSS.SoXS12)">
                                @Code
                                    If Opcao = "pagamentos" Then
                                        @<div class="valor-titulo">@Traducao.EstruturaAplicacaoTermosBase.Saldo</div>
                                        @<h3 class="valor-dinheiro"><span id="saldo"></span><span>&nbsp;@Model.Simbolo</span></h3>
                                        @<hr />
                                    End If
                                End Code
                                <div class="valor-titulo">@Traducao.EstruturaAplicacaoTermosBase.ValorEntregue</div>
                                <h3 class="valor-dinheiro"><span id="valorEntregue">@FormatNumber(Model.ValorEntregue, Model.CasasDecimaisTotais)</span><span>&nbsp;@Model.Simbolo</span></h3>
                                <hr />
                                <div class="valor-titulo">@Traducao.EstruturaAplicacaoTermosBase.Troco</div>
                                <h3 class="valor-dinheiro"><span id="troco">@FormatNumber(Model.Troco, Model.CasasDecimaisTotais)</span><span>&nbsp;@Model.Simbolo</span></h3>
                            </div>
                        </div>
                        <div class="row">
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
                    </div>

                    <!--botões de acao de pagamento / impressao-->
                    <div class="@(ClassesCSS.SoXS7) btns-pos-holder">
                        @Code
                            If Opcao <> "recebimentos" Then
                                @<button id="btnSaveAndPrint" class="btn btn-line btn-block bttn-lg clsBtPrint permImpr @(Mvc.BotoesGrelha.BtsCRUD)" title="Pagar e Imprimir"><div>Pagar e Imprimir</div><h3><strong><span id="totalPagarImprimir"></span>&nbsp;<span class="clsF3MCurrency"></span></strong></h3></button>
                                @<button id="btnSave" class="btn main-btn btn-block btn-lg clsBtSave @(Mvc.BotoesGrelha.BtsAcoes)" title="Pagar"><div>Pagar</div><h3><strong><span id="totalPagar"></span>&nbsp;<span class="clsF3MCurrency"></span></strong></h3></button>
                                @<button id="btnRefresh" class="btn btn-info btn-block btn-nopay clsBtPrint permImpr @(Mvc.BotoesGrelha.BtsCRUD) btn-lg" title="@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar"><span class="fm f3icon-refresh"></span> @Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar</button>
                            Else
                                @<button id="btnPrint" class="btn btn-line btn-block bttn-lg clsBtPrint permImpr @(Mvc.BotoesGrelha.BtsCRUD)" title="@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPImprimir"><div>@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPImprimir</div><h3><strong><span class="fm f3icon-print fm-3x"></span></strong></h3></button>
                                @<button id="btnAnular" class="btn btn-danger btn-block btn-nopay btn-lg" title=@Traducao.EstruturaAplicacaoTermosBase.Anular><span class="fm f3icon-trash-o"></span>@Traducao.EstruturaAplicacaoTermosBase.Anular</button>
                            End If
                            @<button id="btnCancelar" class="btn btn-warning btn-block btn-nopay btn-lg" title="@Traducao.EstruturaAplicacaoTermosBase.Cancelar"><span class="fm f3icon-times-square"></span>@Traducao.EstruturaAplicacaoTermosBase.Cancelar</button>
                        End Code
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<h1 id="lblAnulado" class="anulado">@Traducao.EstruturaAplicacaoTermosBase.Anulado</h1>