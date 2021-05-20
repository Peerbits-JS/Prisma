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

@*class servicos*@
<div role="tabpanel" class="tab-pane fade" id="tabServicos">
    <div class="form-container">
        <div id="divServicos">
            <div class="f3m-top submenu clearfix">
                <div class="f3m-top__left float-left">
                    <ul id="ulServicos" class="nav f3m-nav-servico"></ul>
                </div>

                <div class="f3m-top__right float-right">
                    <!-- Botões Ações -->
                    <div id="ServicosBts" class="float-right">
                        @Code
                            If AcaoForm <> AcoesFormulario.Consultar Then
                                @Html.Raw(String.Format(botaoHtml, "Servicos" & Mvc.BotoesGrelha.Remover, Mvc.BotoesGrelha.Remover & clsCSSAcoes, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPApagar, "trash-o"))
                                @Html.Raw(String.Format(botaoHtml, "Servicos" & Mvc.BotoesGrelha.Duplicar, Mvc.BotoesGrelha.Duplicar & clsCSSAcoes, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPDuplicar, "copy"))
                                @Html.Raw(String.Format(botaoHtml, "Servicos" & Mvc.BotoesGrelha.Adicionar, "adicionar2" & clsCSSAcoes, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAdicionar, "add"))

                            End If

                            @If AcaoForm <> AcoesFormulario.Adicionar AndAlso estaEfetivo AndAlso ModulosSessao.Existe(ClsF3MSessao.RetornaChaveSessao(), ModulosLicenciamento.Prisma.Oficina) Then
                                @<a id="btnSubstituicaoArtigos" class="f3mlink grelha-bts InativaOnDirty" title="Substituir Artigos">
                                    <span Class="fm f3icon-troca-artigos"></span>
                                    <div class="label-btn-acoes">
                                        <span>Substituir</span>
                                        <br>
                                        <span>Artigos</span>
                                    </div>
                                </a>
                            End If

                            If AcaoForm <> AcoesFormulario.Consultar Then
                                End code
                                    <div class="dropdown f3m-dropdown-link bts-modo-edita">
                                        <a class="dropdown-toggle f3mlink" id="dropdownMenuImport" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <span class="fm f3icon-import"></span>
                                            <span class="fm f3icon-chevron-down-2"></span>
                                        </a>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuImport">
                                            <a id="btnImportarSubServico" href="#" class="dropdown-item f3m-dropdown-link__item" title="@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPImportar"><span>Importar SubServiço</span></a>
                                            <a id="btnImportarConsulta" href="#" class="dropdown-item f3m-dropdown-link__item" title="@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPImportar"><span>Importar Consulta</span></a>
                                        </div>
                                    </div>
                                @Code
                                    End If

                        End Code
                    </div>
  
                </div>
            </div>

            <!-- ACCORDION -->
            @Html.Partial(URLDocumentosComum & "Servicos/Dioptrias.vbhtml")

            <div class="f3m-top submenu clearfix">
                <div id="elemFloatingEntrega" class="float-left clsF3MElemFloating">
                    <a class="clsF3MElemFloatingText f3mlink f3m-label" title="Configurações">
                        <span class="fm f3icon-cogs"></span>
                        <span class="clsF3MTxtEntrega align-top">@Traducao.EstruturaDocumentos.Entrega</span>
                    </a>
                    <div class="set-resumo">
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataEntregaLonge",
                                    .Label = Traducao.EstruturaDocumentos.DataEntregaLonge,
                                    .TipoEditor = Mvc.Componentes.F3MDataTempo,
                                    .Modelo = Model.Modelo,
                                    .ViewClassesCSS = {"col"}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataEntregaPerto",
                                                        .Label = Traducao.EstruturaDocumentos.DataEntregaPerto,
                                                        .TipoEditor = Mvc.Componentes.F3MDataTempo,
                                                        .Modelo = Model.Modelo,
                                                        .ViewClassesCSS = {"col"}})
                            End Code
                        </div>

                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "BoxLonge",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.BoxLonge,
                                    .TipoEditor = Mvc.Componentes.F3MTexto,
                                    .Modelo = Model.Modelo,
                                    .ViewClassesCSS = {"col"}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "BoxPerto",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.BoxPerto,
                                    .TipoEditor = Mvc.Componentes.F3MTexto,
                                    .Modelo = Model.Modelo,
                                    .ViewClassesCSS = {"col"}})
                            End Code
                        </div>
                    </div>
                </div>
            </div>

            <!-- HANDSONTABLES -->
            @Html.Partial(URLDocumentosComum & "Servicos/Tabelas.vbhtml")
        </div>
    </div>
</div>


@Html.Partial(URLDocumentosComum & "Servicos/Modal.vbhtml")
