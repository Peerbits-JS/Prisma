@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@ModelType MovimentosCaixa

@Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresMovimentosCaixa")

@Html.Partial(URLs.PartialTopo)

@Code
    Dim AcaoForm As Int16 = Model.AcaoFormulario
    Dim blnTemDocumentos As Boolean = False
    Dim intCasasDecimais As Integer = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisIva

    If AcaoForm = AcoesFormulario.Alterar Then
        blnTemDocumentos = Not Model.IDDocumento Is Nothing
    End If

    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    Html.F3M().Hidden("Natureza", Model.Natureza, atrHTML)
    Html.F3M().Hidden("IDLoja", Model.IDLoja, atrHTML)
    Html.F3M().Hidden("VerificaCaixaAberta", True, atrHTML)
End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div class="row desContainer">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {
                                .Id = CamposGenericos.DataDocumento,
                                .Label = Traducao.EstruturaAplicacaoTermosBase.DataDocumento,
                                .TipoEditor = Mvc.Componentes.F3MData,
                                .Modelo = Model,
                                .EEditavel = Not blnTemDocumentos,
                                .EObrigatorio = True,
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS2}
                            })

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {
                        .Id = "IDContaCaixa",
                        .Label = Traducao.EstruturaLojas.Caixa,
                        .TipoEditor = Mvc.Componentes.F3MDropDownList,
                        .Controlador = "../Caixas/ContasCaixa/CaixasPorLoja",
                        .Modelo = Model,
                        .EEditavel = AcaoForm = AcoesFormulario.Adicionar AndAlso Model.PermiteEditarCaixa,
                        .EObrigatorio = True,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS3}
                    })

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {
                        .Id = "IDSistemaNaturezas",
                        .Label = Traducao.EstruturaTabelasSistema.Naturezas,
                        .TipoEditor = Mvc.Componentes.F3MDropDownList,
                        .Controlador = String.Concat(URLs.Areas.F3MSist, "SistemaNaturezas"),
                        .Modelo = Model,
                        .EEditavel = Not blnTemDocumentos,
                        .EObrigatorio = True,
                        .FuncaoJSEnviaParams = "MovimentosCaixaFormasPagamentoEnviaParams",
                        .FuncaoJSChange = "MovimentosCaixaFormasPagamentoChange",
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS2}
                    })

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {
                        .Id = CamposGenericos.IDFormaPagamento,
                        .Label = Traducao.EstruturaClientes.FormaPagamento,
                        .TipoEditor = Mvc.Componentes.F3MLookup,
                        .Controlador = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.FormasPagamento,
                        .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
                        .Modelo = Model,
                        .EEditavel = Not blnTemDocumentos,
                        .EObrigatorio = True,
                        .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.FormasPagamento,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS3}
                    })

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {
                        .Id = CamposGenericos.Valor,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Valor,
                        .TipoEditor = Mvc.Componentes.F3MMoeda,
                        .Modelo = Model,
                        .EObrigatorio = True,
                        .EEditavel = Not blnTemDocumentos,
                        .CasasDecimais = intCasasDecimais,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS2}
                    })
                End Code
            </div>
            <div>
                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {
                            .Id = CamposGenericos.Descricao,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                            .TipoEditor = Mvc.Componentes.F3MTextArea,
                            .Modelo = Model,
                            .EEditavel = Not blnTemDocumentos,
                            .EObrigatorio = True,
                            .AtributosHtml = New With {.class = "textarea-input"},
                            .ViewClassesCSS = {ClassesCSS.XS12}
                        })
                    End Code
                </div>
            </div>
        </div>
    </div>
</div>