Imports System.Web
Imports System.Web.Optimization
Imports F3M.Modelos.Base

Public Module BundleConfig
    ''' <summary>
    ''' Registers the bundles.
    ''' For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862    
    ''' </summary>
    ''' <param name="bundles">The bundles.</param>
    Public Sub RegisterBundles(ByVal bundles As BundleCollection)
        Const strKendoVersion As String = "2019.1.220"
        Const strHandsontableVersion As String = "6.2.0"
        Const handsOnTableV8 As String = "8.2.0"
        Const strF3MPathScript As String = "~/F3M/Scripts/"
        Const strPathScript As String = "~/Scripts/ong/"
        ' ------------------- Cultures ------------------
        ' pt-PT
        bundles.Add(New ScriptBundle("~/bundles/f3m/culturept-PT").Include(strF3MPathScript & "kendo/cultures/kendo.culture.pt-PT.min.js",
                                                                            strF3MPathScript & "kendo/cultures/kendo.pt-PT.js"))
        ' en-GB
        bundles.Add(New ScriptBundle("~/bundles/f3m/cultureen-GB").Include(strF3MPathScript & "kendo/cultures/kendo.culture.en-GB.min.js"))

        ' ------------------- CSS -------------------
        Const strF3MPathStyles As String = "~/F3M/Content/"
        Const strKendoPathStyles As String = strF3MPathStyles & "kendo/" & strKendoVersion & "/"

        bundles.Add(New StyleBundle("~/Content/f3mstyle") _
                        .Include(strF3MPathStyles & "f3m/f3icon.css") _
                        .Include(strF3MPathStyles & "bootstrap.min.css") _
                        .Include(strF3MPathStyles & "bootstrap-select.min.css") _
                        .Include(strF3MPathStyles & "queryBuilder/query-builder.default.min.css") _
                        .Include(strF3MPathStyles & "queryBuilder/bootstrap-datepicker.standalone.css") _
                        .Include(strKendoPathStyles & "kendo.default.min.css") _
                        .Include(strKendoPathStyles & "kendo.common-bootstrap.min.css", New CssRewriteUrlTransform()) _
                        .Include(strF3MPathStyles & "animate/animate.css") _
                        .Include("~/Content/f3m/prisma.css") _
                        .Include(strF3MPathStyles & "f3m/base64-backgrounds.css"))

        bundles.Add(New StyleBundle("~/Content/handsontablestyle").Include(strF3MPathStyles & "handsontable/" & strHandsontableVersion & "/pikaday/pikaday.css",
                                                                          strF3MPathStyles & "handsontable/" & strHandsontableVersion & "/clockpicker/bootstrap-clockpicker.min.css",
                                                                          strF3MPathStyles & "handsontable/" & strHandsontableVersion & "/handsontable.full.css"))

        bundles.Add(New StyleBundle("~/Content/handsontablestylev8").Include(strF3MPathStyles & "handsontable/" & handsOnTableV8 & "/pikaday/pikaday.css",
                                                                          strF3MPathStyles & "handsontable/" & handsOnTableV8 & "/clockpicker/bootstrap-clockpicker.min.css",
                                                                          strF3MPathStyles & "handsontable/" & handsOnTableV8 & "/handsontable.full.css"))

        ' ------------------- SCRIPTS -------------------
        Const strKendoPathScript As String = strF3MPathScript & "kendo/" & strKendoVersion & "/"
        Const jqueryVersao As String = "2.1.4"
        Const jqueryUIVersao As String = "1.11.4"

        ' ------------------- ANALYSIS -------------------

        bundles.Add(New ScriptBundle("~/bundles/querybuilderjs") _
            .Include("~/Areas/Testing/Temp_CSS/query-builder/bootstrap-datepicker.min.js",
                     "~/Areas/Testing/Temp_CSS/query-builder/query-builder.standalone.min.js",
                     "~/Areas/Testing/Temp_CSS/query-builder/query-builder.pt-PT.js"
                    ))
        ' -------------------------------------------------------

        Dim base() As String = {strF3MPathScript & "jquery-" & jqueryVersao & ".min.js",
                                strF3MPathScript & "jquery-ui-" & jqueryUIVersao & ".min.js",
                                strF3MPathScript & "jquery.blockUI.js",
                                strF3MPathScript & "modernizr-*",
                                strF3MPathScript & "umd/popper.min.js",
                                strF3MPathScript & "bootstrap.min.js",
                                strF3MPathScript & "bootstrap-select.min.js",
                                strF3MPathScript & "kendo.modernizr.custom.js",
                                strF3MPathScript & "tabdrop.js"}

        bundles.Add(New ScriptBundle("~/bundles/basejs").Include(base))
        bundles.Add(New ScriptBundle("~/bundles/kendojs").Include(strKendoPathScript & "jszip.min.js",
                                                                  strKendoPathScript & "kendo.all.min.js",
                                                                  strKendoPathScript & "kendo.aspnetmvc.min.js")) 'INCLUIDO O DE.JS DEVIDO À CONFIGURACAO DA MOEDA NA MATRIZ. TODO: MELHORAR 

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsbase").Include(strF3MPathScript & "f3m/frontend/libs/LZString.min.js",
                                                                     strF3MPathScript & "f3m/base/f3m.base*",
                                                                     strF3MPathScript & "f3m/componentes/f3m.grelha.utils.js",
                                                                     strF3MPathScript & "f3m/componentes/f3m.grelha.vistas.js",
                                                                     strF3MPathScript & "f3m/servicos/f3m*"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsbaseformulariosopcoes").Include(strF3MPathScript & "f3m/base/f3m.base.formularios.js",
                                                                                      strPathScript & "componentes.prisma/F3M_GridExcel.esp.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAreaSideBar").Include(strF3MPathScript & "f3m/base/f3m.base.areaSideBars.js"))

        ' HANDSONTABLE
        bundles.Add(New ScriptBundle("~/bundles/handsontable").Include(strF3MPathScript & "handsontable/" & strHandsontableVersion & "/numeral/numeral.js",
                                                                       strF3MPathScript & "handsontable/" & strHandsontableVersion & "/numeral/pt-PT.js",
                                                                       strF3MPathScript & "handsontable/" & strHandsontableVersion & "/pikaday/pikaday.js",
                                                                       strF3MPathScript & "handsontable/" & strHandsontableVersion & "/clockpicker/bootstrap-clockpicker.min.js",
                                                                       strF3MPathScript & "handsontable/" & strHandsontableVersion & "/moment/moment.js",
                                                                       strF3MPathScript & "handsontable/" & strHandsontableVersion & "/zeroclipboard/ZeroClipboard.js",
                                                                       strF3MPathScript & "handsontable/" & strHandsontableVersion & "/handsontable.full.min.js",
                                                                       strF3MPathScript & "f3m/componentes/F3M_GridExcel.js"))

        bundles.Add(New ScriptBundle("~/bundles/handsontablev8").Include(strF3MPathScript & "handsontable/" & handsOnTableV8 & "/numeral/numeral.js",
                                                                       strF3MPathScript & "handsontable/" & handsOnTableV8 & "/numeral/pt-PT.js",
                                                                       strF3MPathScript & "handsontable/" & handsOnTableV8 & "/pikaday/pikaday.js",
                                                                       strF3MPathScript & "handsontable/" & handsOnTableV8 & "/clockpicker/bootstrap-clockpicker.min.js",
                                                                       strF3MPathScript & "handsontable/" & handsOnTableV8 & "/moment/moment.js",
                                                                       strF3MPathScript & "handsontable/" & handsOnTableV8 & "/zeroclipboard/ZeroClipboard.js",
                                                                       strF3MPathScript & "handsontable/" & handsOnTableV8 & "/handsontable.full.min.js",
                                                                       strF3MPathScript & "f3m/componentes/F3M_GridExcel.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m-handsontable").Include(strF3MPathScript & "f3m/componentes/f3m-handsontable.js"))

        ' PARA FUNCIONALIDADES COM TREEVIEW
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTreeView").Include(strF3MPathScript & "f3m/componentes/f3m.arvore.utils.js"))

        ' PARA FUNCIONALIDADES COM SCHEDULER
        bundles.Add(New ScriptBundle("~/bundles/f3m/timezones").Include(strKendoPathScript & "kendo.timezones.min.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsScheduler").Include(strPathScript & "componentes.prisma/scheduler/f3m.scheduler.js"))


        bundles.Add(New ScriptBundle("~/bundles/jquery").Include(strF3MPathScript & "jquery-{version}.js"))
        bundles.Add(New ScriptBundle("~/bundles/modernizr").Include(strF3MPathScript & "modernizr-*"))
        bundles.Add(New ScriptBundle("~/bundles/bootstrap").Include(strF3MPathScript & "bootstrap.js", strF3MPathScript & "respond.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularios").Include(strF3MPathScript & "f3m/componentes/F3M_GridForm.js",
                                                                            strF3MPathScript & "f3m/componentes/F3M_Grid.js",
                                                                            strF3MPathScript & "f3m/componentes/F3M_GridLinhas.js",
                                                                            strF3MPathScript & "f3m/componentes/F3M_Components.js",
                                                                            strF3MPathScript & "f3m/componentes/f3m.pesquisa.js",
                                                                            strF3MPathScript & "f3m/funcionalidades/comum/f3m.observacoes.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliares").Include(strF3MPathScript & "f3m/componentes/F3M_Grid.js",
                                                                                  strF3MPathScript & "f3m/componentes/F3M_GridLinhas.js",
                                                                                  strF3MPathScript & "f3m/componentes/F3M_Components.js",
                                                                                  strF3MPathScript & "f3m/componentes/F3M_F4.js",
                                                                                  strF3MPathScript & "f3m/funcionalidades/comum/f3m.observacoes.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsGridExcel").Include(strF3MPathScript & "f3m/componentes/F3M_GridExcel.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/vistas").Include(strF3MPathScript & "f3m/componentes/f3m.vistas.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/pesquisa").Include(strF3MPathScript & "f3m/componentes/f3m.pesquisa.js"))

        ' BUNDLE PARA Fornecedores
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioFornecedores").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.foto.js",
                                                                                       strF3MPathScript & "f3m/funcionalidades/fornecedores/f3m.fornecedores.js"))

        ' BUNDLE PARA Clientes
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioClientes").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.foto.js",
                                                                                   strF3MPathScript & "f3m/funcionalidades/clientes/f3m.clientes.js",
                                                                                   strPathScript & "funcionalidades/clientes/f3m.clientes.esp.js"))
        ' BUNDLES PARA ANEXOS
        bundles.Add(New StyleBundle("~/Content/f3m/anexos").Include(strF3MPathStyles & "uploader/uploader.css",
                                                                    strF3MPathStyles & "owl/owl.carousel.css",
                                                                    strF3MPathStyles & "owl/owl.theme.css",
                                                                    strF3MPathStyles & "owl/owl.transitions.css"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAnexos").Include(strF3MPathScript & "uploader/uploader.js",
                                                                       strF3MPathScript & "owl/owl.carousel.min.js",
                                                                       strF3MPathScript & "f3m/funcionalidades/anexos/f3m.anexos.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsImportacao").Include(strF3MPathScript & "uploader/uploader.js",
                                                                   strF3MPathScript & "owl/owl.carousel.min.js",
                                                                   strF3MPathScript & "f3m/componentes/F3M_Importacao.js"))

        ' BUNDLES PARA COMUNICACAO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsEmail").Include(strF3MPathScript & "f3m/funcionalidades/utilitarios/f3m.email.js"))

        ' JS PARA TABELAS AUXILIARES
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioFormasPagamento").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.formaspagamento.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioFormasExpedicao").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.formasexpedicao.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioCondicoesPagamento").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.condicoespagamento.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresArmazens").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.armazens.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioSegmentosMercado").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.segmentosmercado.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioSetoresAtividade").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.setoresatividade.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresMoedas").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.moedas.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresGrupos").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.grupos.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresBancos").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.bancos.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresContasBancarias").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.contasbancarias.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresTiposArtigos").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.tiposartigos.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresEntidades").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.foto.js", strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.entidades.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresMedicosTecnicos").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.foto.js",
                                                                                                 strPathScript & "funcionalidades/tabelasauxiliares/f3m.medicostecnicos.js",
                                                                                                 strF3MPathScript & "f3m/componentes/f3m.arvore.utils.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioEstados").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.estados.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsImpostoSelo").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.impostoselo.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresIVA").Include(strF3MPathScript & "f3m/funcionalidades/tabelasAuxiliares/f3m.iva.js"))

        'ESPECIFICOS PRISMA
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresCatalogoLentes").Include(strPathScript & "funcionalidades/catalogolentes/f3m.catalogolentes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresCatalogoLentesMatrizPrecos").Include(strPathScript & "funcionalidades/catalogolentes/f3m.catalogolentes.matrizprecos.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresTratamentosLentes").Include(strPathScript & "funcionalidades/tabelasAuxiliares/f3m.tratamentoslentes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresCoresLentes").Include(strPathScript & "funcionalidades/tabelasAuxiliares/f3m.coreslentes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresSuplementosLentes").Include(strPathScript & "funcionalidades/tabelasauxiliares/f3m.suplementoslentes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresComparticipacoes").Include(strPathScript & "funcionalidades/tabelasauxiliares/f3m.comparticipacoes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresModelosArtigos").Include(strPathScript & "funcionalidades/tabelasAuxiliares/f3m.modelosartigos.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresMarcas").Include(strPathScript & "funcionalidades/tabelasAuxiliares/f3m.marcas.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresComposicoes").Include(strPathScript & "funcionalidades/tabelasAuxiliares/f3m.composicoes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsPagamentos").Include(strPathScript & "funcionalidades/pagamentos/f3m.pagamentos.js",
                                                                           strPathScript & "componentes.prisma/F3M_GridExcel.esp.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsRecebimentos").Include(strPathScript & "funcionalidades/pagamentos/f3m.recebimentos.js",
                                                                                strPathScript & "funcionalidades/docs/docs.vendas/f3m.docs.vendas.imprimir.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresMovimentosCaixa").Include(strPathScript & "funcionalidades/tabelasauxiliares/f3m.movimentoscaixa.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresContasCaixa").Include(strPathScript & "funcionalidades/tabelasauxiliares/f3m.contascaixa.js"))

        'bundles.Add(New ScriptBundle("~/bundles/f3m/jsPerfis").Include("~/Scripts/f3m/componentes/f3m.arvore.utils.js",
        '                                                               "~/Scripts/f3m/administracao/f3m.perfis.js"))
        'bundles.Add(New ScriptBundle("~/bundles/f3m/jsUtilizadores").Include("~/Scripts/f3m/administracao/f3m.utilizadores.js"))

        ' BUNDLES PARA TIPOS DOCUMENTO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresTiposDocumento").Include(strPathScript & "funcionalidades/tiposdocumento/f3m.tiposdocumento.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabelasAuxiliaresTiposDocumentoSeries").Include(strPathScript & "funcionalidades/tiposdocumento/f3m.tiposdocumentoseries.js",
                                                                                                strPathScript & "funcionalidades/tiposdocumento/f3m.tiposdocumento.esp.js"))


        ' BUNDLES PARA ARTIGOS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioArtigos").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.foto.js",
                                                                                  strPathScript & "funcionalidades/artigos/f3m.artigos.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioArtigosDimensoesComponentes").Include(strF3MPathScript & "numeral.min.js",
                                                                                                      strF3MPathScript & "de.min.js",
                                                                                                      strF3MPathScript & "handsontable.full.min.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioArtigosComponentes").Include(strF3MPathScript & "f3m/funcionalidades/artigos/f3m.componentes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioArtigosDimensoes").Include(strF3MPathScript & "f3m/funcionalidades/artigos/f3m.dimensoes.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioArtigosAssociados").Include(strF3MPathScript & "f3m/funcionalidades/artigos/f3m.associados.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioArtigosUnidades").Include(strF3MPathScript & "f3m/funcionalidades/artigos/f3m.unidades.js"))

        ' BUNDLES PARA DOCUMENTOS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioDocumentosServicos").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js",
                                                                                             strPathScript & "/funcionalidades/docs/docs.servicos/f3m.docs.servicos.subServico.js",
                                                                                             strPathScript & "/funcionalidades/docs/docs.servicos/f3m.docs.servicos.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAppointments").Include(strPathScript & "funcionalidades/clientes/f3m.appointments.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocStocks").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js",
                                                                          strF3MPathScript & "f3m/funcionalidades/documentos/f3m.docstocks.js",
                                                                          strPathScript & "funcionalidades/docs/docs.stocks/f3m.docs.stocks.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocCompras").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js",
                                                                          strF3MPathScript & "f3m/funcionalidades/documentos/f3m.docstocks.js",
                                                                          strF3MPathScript & "f3m/funcionalidades/documentos/f3m.doccompras.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocVendas").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js",
                                                                          strF3MPathScript & "f3m/funcionalidades/documentos/f3m.docstocks.js",
                                                                          strPathScript & "funcionalidades/docs/docs.vendas/f3m.docs.vendas.js",
                                                                          strPathScript & "componentes.prisma/F3M_GridExcel.esp.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocPagsCompras").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js",
                                                                               strF3MPathScript & "f3m/funcionalidades/documentos/f3m.docpagamentoscompras.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocumentosPagsComprasFormasPag").Include(strF3MPathScript & "f3m/funcionalidades/documentos/f3m.docpagscomprasFormasPag.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocStocksDims").Include(strF3MPathScript & "f3m/funcionalidades/documentos/f3m.docstocksDims.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsConsultarStock").Include(strF3MPathScript & "f3m/funcionalidades/documentos/f3m.consultarStock.js"))

        ' JS PARA PARAMETROS CONTEXTO/EMPRESA
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsParametrosContexto").Include(strF3MPathScript & "f3m/administracao/f3m.parametroscontexto.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsParametrosTaxaIva").Include(strPathScript & "funcionalidades/admin/f3m.parametrostaxasiva.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsParametrosStocks").Include(strPathScript & "funcionalidades/admin/f3m.parametrosstocks.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsParametrosOutros").Include(strPathScript & "funcionalidades/admin/f3m.parametrosoutros.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsParametrosArtigos").Include(strPathScript & "funcionalidades/admin/f3m.parametrosartigos.js"))

        'JS PARA DOCUMENTOS (CABEÇALHO COMUM)
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocumentosComum").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.documento.js"))

        ' BUNDLES PARA CARGA/DESCARGA
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioCargaDescarga").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.cargadescarga.js"))

        'JS PARA TOUCH ?
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsServicosTouch").Include(strF3MPathScript & "f3m/componentes/f3m.touch.js"))

        ' AS - Para tratar a indicação de conteúdo das observações
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsBaseObservacoes").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.observacoes.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsEstadosLadoDireito").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js"))
        'JS PARA DOCUMENTOS (UTILITARIOS COMUM)
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsSAFT").Include(strF3MPathScript & "f3m/funcionalidades/utilitarios/f3m.SAFT.js"))

        'PC - BUNDLES PARA IMPORTACAO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocImportacoes").Include(strF3MPathScript & "kendo/cultures/kendo.culture.pt-PT.min.js",
                                                                               strF3MPathScript & "kendo/cultures/kendo.pt-PT.js",
                                                                               strF3MPathScript & "f3m/funcionalidades/documentos/f3m.docimportacoes.js"))

        'MAF - JS PARA REMOVER E CRIAR A BD DO INDEXEDDB E IMPRIMIR DOCS (2ª VIA OU ORIGINAL E QUANDO TEM NCA's) 
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocumentosVendasUtils").Include(strF3MPathScript & "f3m/funcionalidades/documentos/f3m.doc.index.js",
                                                                                strPathScript & "funcionalidades/docs/docs.vendas/f3m.docs.vendas.imprimir.js"))

        'MAF - JS PARA REMOVER E CRIAR A BD DO INDEXEDDB E IMPRIMIR DOCS (2ª VIA OU ORIGINAL)
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocumentosUtils").Include(strF3MPathScript & "f3m/funcionalidades/documentos/f3m.doc.index.js",
                                                                                strF3MPathScript & "f3m/funcionalidades/documentos/f3m.doc.imprimir.js"))

        ' Front-End
        bundles.Add(New ScriptBundle("~/bundles/f3m/frontend").Include(strF3MPathScript & "f3m/frontend/f3m.frontend.js"))

        'PC - BUNDLES PARA CONSULTAS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsConsultas").Include(strF3MPathScript & "f3m/funcionalidades/consultas/f3m.consultas.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsConsultasParametros").Include(strF3MPathScript & "f3m/funcionalidades/consultas/f3m.consultas.parametros.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsConsultasMultiSelect").Include(strF3MPathScript & "f3m/funcionalidades/consultas/f3m.consultasmultiselect.js"))

        'MJS - BUNDLE PARA CONTROLO DE CAIXA
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAberturaFechoCaixa").Include(
            strF3MPathScript & "f3m/componentes/F3M_Grid.js",
            strF3MPathScript & "f3m/componentes/F3M_Components.js",
            strF3MPathScript & "f3m/funcionalidades/caixas/f3m.caixas.aberturafecho.js"
        ))

        'MAF - JS PARA AS ETIQUETAS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsEtiquetas").Include(strPathScript & "funcionalidades/etiquetas/f3m.etiquetas.js",
                                                                          strPathScript & "funcionalidades/etiquetas/f3m.etiquetas.artigos.js"))

        ' Modal Crop Foto para header principal
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsModalCropFoto").Include(strF3MPathScript & "f3m/componentes/F3M_Components.js",
                                                                              strF3MPathScript & "f3m/administracao/f3m.configuracoes.js",
                                                                              strF3MPathScript & "f3m/funcionalidades/comum/f3m.foto.js",
                                                                              strF3MPathScript & "f3m/frontend/libs/cropper.js"))

        ' Carregado apenas no início de sessão
        bundles.Add(New ScriptBundle("~/bundles/f3m/frontendStart").Include(strF3MPathScript & "f3m/frontend/f3m.frontend.start.js"))

        'MAF - JS PARA DUPLICAR DOCUMENTOS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocDuplicar").Include(strF3MPathScript & "f3m/funcionalidades/documentos/f3m.doc.duplicar.js"))

        'MAF - JS PARA RECALCULO DE STOCKS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsRecalculoStocks").Include(strF3MPathScript & "f3m/funcionalidades/recalculos/f3m.recalculos.stocks.js"))

        'MAF - JS PARA O INDEX DOS EXAMES
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsExamesIndex").Include(strPathScript & "funcionalidades/exames/f3m.exames.index.js"))

        'MAF - JS PARA EXAMES
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsExames").Include(strF3MPathScript & "f3m/funcionalidades/comum/f3m.foto.js",
                                                                       strPathScript & "funcionalidades/exames/f3m.exames.detalhe.js",
                                                                        strPathScript & "funcionalidades/exames/f3m.exames.cab.js",
                                                                       strPathScript & "funcionalidades/exames/f3m.exames.ladodireito.js"))

        'MAF - JS PARA OS COMPONENETES NOS EXAMES
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsExamesComponentes").Include(strPathScript & "funcionalidades/exames/f3m.exames.componentes.js"))

        'MAF - JS PARA HISTORICO DE EXAMES
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsExamesHistorico").Include(strPathScript & "funcionalidades/exames/f3m.exames.historico.js"))

        'JS PARA AGENDAMENTO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAgendamento").Include(strPathScript & "funcionalidades/agendamento/f3m.agendamento.js"))

        'JS PARA PLANEAMENTO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsPlaneamento").Include(strPathScript & "funcionalidades/planeamento/f3m.planificacao.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsLicenciamento").Include(strF3MPathScript & "f3m/componentes/f3m.arvore.utils.js",
                                                                              strF3MPathScript & "f3m/administracao/f3m.licenciamento.js"))

        'MAF - JS PARA O CABECALHO DO ESOCIAL
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTabComponent").Include(strF3MPathScript & "f3m/componentes/f3m.tabcomponent.js"))

        'PC - JS PARA OS TIPOS DE CONSULTA (TEMPLATES)
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTiposConsultas").Include(strPathScript & "funcionalidades/exames/f3m.tiposconsultas.js"))

        'MAF - JS PARA A MSG DE ERRO NAS CONSULTAS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsLogin").Include(strF3MPathScript & "ladda/spin.min.js",
                                                                      strF3MPathScript & "ladda/ladda.min.js",
                                                                      strF3MPathScript & "f3m/administracao/login.js"))



        'MAF - JS PARA A IMPORTACAO NOS SERVICOS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsServicosImportacao").Include(strPathScript & "funcionalidades/docs/docs.servicos/f3m.docs.servicos.importacao.js"))

        'MAF . JS PARA O COMPONENTE FOTO GRID
        bundles.Add(New ScriptBundle("~/bundles/f3m/frontendLibsFotos").Include(strF3MPathScript & "f3m/frontend/libs/cropper.js",
                                                                                   strF3MPathScript & "f3m/frontend/libs/masonry.pkgd.min.js",
                                                                                   strF3MPathScript & "f3m/frontend/libs/imagesloaded.pkgd.min.js"))


        'MAF - JS PARA OS DESCONTOS DO IVA
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsIVADescontos").Include(strPathScript & "funcionalidades/descontosiva/f3m.descontos.iva.js"))

        'MAF - JS PARA A CONTAGEM DE STOCKS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocsStockContagem").Include(strF3MPathScript & "uploader/uploader.js",
                                                                                  strPathScript & "funcionalidades/docs/docs.stocks.contagem/f3m.docs.stocks.contagem.js",
                                                                                  strPathScript & "funcionalidades/docs/docs.stocks.contagem/f3m.docs.stocks.contagem.condicoes.js",
                                                                                  strPathScript & "funcionalidades/docs/docs.stocks.contagem/f3m.docs.stocks.contagem.cab.js",
                                                                                  strPathScript & "funcionalidades/docs/docs.stocks.contagem/f3m.docs.stocks.contagem.artigos.js",
                                                                                  strPathScript & "funcionalidades/docs/docs.stocks.contagem/f3m.docs.stocks.contagem.grelha.js",
                                                                                  strPathScript & "funcionalidades/docs/docs.stocks.contagem/f3m.docs.stocks.contagem.botoes.js",
                                                                                  strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js"))

        'MAF - JS PARA A MODAL DA CONTAGEM DE STOCKS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocsStockContagemContar").Include(strPathScript & "funcionalidades/docs/docs.stocks.contagem/f3m.docs.stocks.contagem.contar.js"))

        'MJS - JS PARA INVENTARIOAT
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsInventarioATIndex").Include(strPathScript & "funcionalidades/inventarioAT/f3m.inventarioAT.index.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsInventarioAT").Include(strPathScript & "funcionalidades/inventarioAT/f3m.inventarioAT.js",
                                                                             strPathScript & "componentes.prisma/F3M_GridExcel.esp.js"))

        'MAF - JS FOR ACCOUNTING CONFIGURATION
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAccountingConfiguration").Include(strPathScript & "funcionalidades/accounting/accounting.configuration/f3m.accounting.configuration.js",
                                                                                          strPathScript & "funcionalidades/accounting/accounting.configuration/f3m.accounting.configuration.conditions.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAccountingConfigurationEntities").Include(strPathScript & "funcionalidades/accounting/accounting.configuration/f3m.accounting.configuration.entities.js"))

        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAccountingConfigurationDocumentTypes").Include(strPathScript & "funcionalidades/accounting/accounting.configuration/f3m.accounting.configuration.docs.types.js",
                                                                                                   strPathScript & "componentes.prisma/F3M_GridExcel.esp.js"))

        'MJS - JS PARA ACCOUNTING EXPORT
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAccountingExport").Include(strPathScript & "funcionalidades/accounting/accounting.export/f3m.accounting.export.js"))

        'MAF - JS PARA MEDICOS TECNICOS (INDEX GRELHA)
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsMedicosTecnicosIndexGrelha").Include(strPathScript & "funcionalidades/medicos.tecnicos/f3m.medicos.tecnicos.index.grelha.js"))

        'MAF - JS PARA OS TIPOS DE FASES
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsTiposFases").Include(strPathScript & "funcionalidades/tipos.fases/f3m.tipos.fases.js"))

        'MAF  - JS PARA AS FASES DO SERVICO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioDocumentosServicosFases").Include(strPathScript & "/funcionalidades/docs/docs.servicos/f3m.docs.servicos.fases.js"))

        'DFS - JS PARA OS REPORTS
        bundles.Add(New ScriptBundle("~/bundles/f3m/vistas").Include(strF3MPathScript & "f3m/componentes/f3m.vistas.js"))

        'DFS - JS PARA AS ENTIDADES NOS STOCKS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocStocksEntidade").Include(strF3MPathScript & "f3m/funcionalidades/documentos/f3m.doc.stock.entidade.js"))

        'MAF - JS PARA OS SERVICOS DE SUBSTITUICAO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsDocsServicosSubstituicao").Include(
                    strPathScript & "funcionalidades/docs/docs.servicos.substituicao/f3m.docs.servicos.substituicao.js",
                    strPathScript & "funcionalidades/docs/docs.servicos.substituicao/f3m.docs.servicos.substituicao.cab.js",
                    strPathScript & "funcionalidades/docs/docs.servicos.substituicao/f3m.docs.servicos.substituicao.artigos.js",
                    strPathScript & "funcionalidades/docs/docs.servicos.substituicao/f3m.docs.servicos.substituicao.grads.js",
                    strF3MPathScript & "f3m/funcionalidades/comum/f3m.estadosladodireito.js"))

        'MAF - JS PARA O CATÁLOGO DE LENTES NOS SERVICOS DE SUBSTITUICAO
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsCatalogoLentesSubstituicaoArtigos").Include(strPathScript & "funcionalidades/docs/docs.servicos.substituicao/f3m.docs.servicos.substituicao.catalogo.lentes.js"))

        'JS - Para a janela de ativação do report
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAtivaDesigner").Include(strF3MPathScript & "f3m/administracao/f3m.ativadesigner.js"))

        'JS - SMS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsCommunicationSms").Include(strPathScript & "funcionalidades/communication/f3m.communication.sms.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsCommunicationSmsAddMobilePhoneNumber").Include(strPathScript & "funcionalidades/communication/f3m.communication.sms.addmobilephonenumber.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsFormularioCommunsetting").Include(strPathScript & "funcionalidades/communication/f3m.communication.settings.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsCommunicationTemplate").Include(strPathScript & "funcionalidades/Communication/f3m.communication.template.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsCommunicationRecipts").Include(strPathScript & "funcionalidades/Communication/f3m.communication.recipts.js"))
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsCommunicationSmsTemplatesHistoric").Include(strPathScript & "funcionalidades/Communication/f3m.communication.historic.js"))

        'JS - ANALISES DINAMICAS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsAnalisesDinamicasF3M").Include(strF3MPathScript & "f3m/funcionalidades/analisesdinamicasF3M/f3m.analysis.js",
                                                                                     strF3MPathScript & "f3m/funcionalidades/analisesdinamicasF3M/f3m.analysis.core.js",
                                                                                     strF3MPathScript & "f3m/funcionalidades/analisesdinamicasF3M/f3m.analysis.print.js"))

        'JS - GESTOR DE ANALISES DINAMICAS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsGestorAnalisesDinamicasF3M").Include(strF3MPathScript & "f3m/funcionalidades/analisesdinamicasF3M/f3m.analysis.manage.js",
                                                                                           strF3MPathScript & "f3m/funcionalidades/analisesdinamicasF3M/f3m.analysis.core.js"))

        'JS - MULTISELECTION ANALISES DINAMICAS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsMultiSelectionAnalisesDinamicasF3M").Include(strF3MPathScript & "f3m/funcionalidades/analisesdinamicasF3M/f3m.analysis.multiselection.js"))

        'JS - LOOKUP ANALISES DINAMICAS
        bundles.Add(New ScriptBundle("~/bundles/f3m/jsLookupAnalisesDinamicasF3M").Include(strF3MPathScript & "f3m/funcionalidades/analisesdinamicasF3M/f3m.analysisLookup.js"))
    End Sub
End Module