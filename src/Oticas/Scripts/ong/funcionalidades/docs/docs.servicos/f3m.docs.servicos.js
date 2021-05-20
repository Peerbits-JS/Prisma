"use strict";

var $servicos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    //constantes campos genericos
    var constCamposGen = constsBase.camposGenericos;
    var campoID = constCamposGen.ID, campoCod = constCamposGen.Codigo, campoDesc = constCamposGen.Descricao;
    var constTipoDeCampo = constsBase.TipoDeCampo;
    var campoEmExecucao = constCamposGen.IDEmExecucao;

    //constantes acoes e class's
    var constBtsClass = constsBase.grelhaBotoesCls;
    var btClassGuardar = constBtsClass.Guardar, btClassGuardarFecha = constBtsClass.GuardarFecha, btClassGuardarContinua = constBtsClass.GuardarCont, btClassGuardarFecha2 = constBtsClass.GuardarFecha2;
    var btClassDisabled = constBtsClass.Disabled, constRequired = constBtsClass.Required;

    //constantes botoes sub formulario (servicos)
    var constIDsBts = constsBase.grelhaBotoesIDs;
    var btIDAdd = constIDsBts.Adicionar, btIDGuardarFechar = constIDsBts.GuardarFecha;
    var btIDGuardarFechar2 = constIDsBts.GuardarFecha2, btIDRemove = constIDsBts.Remover, btIDDuplicar = constIDsBts.Duplicar, btnSubstituicaoArtigos = 'btnSubstituicaoArtigos';

    //constantes estados
    var constEstados = constsBase.EstadoFormEAcessos;

    //constantes handsontable
    var constTipoCompoHT = constsBase.ComponentesHT, constSourceHT = constsBase.SourceHT, constColHT = constsBase.ColunasHT;

    //constantes json dates
    var constJSONDates = constsBase.ConvertJSONDate;

    //constantes campos funcionalidade
    var campoIDEnti = 'IDEntidade';
    var campoTaxaIVA = "TaxaIva";
    var campoIDMoeda = 'IDMoeda', campoTaxaConv = "TaxaConversao";
    var campoIDRegimeIva = 'IDRegimeIva', campoIDEspacoFiscal = 'IDEspacoFiscal', campoIDLocalOperacao = 'IDLocalOperacao';

    //constantes ids handsontables
    var constHdsnLentes = "hdsnLentes", constHdsnLonge = "hdsnLonge", constHdsnPerto = "hdsnPerto", constHdsnArtigos = "hdsnArtigos";
    var hdsnLentes = "#" + constHdsnLentes, hdsnLonge = "#" + constHdsnLonge, hdsnPerto = "#" + constHdsnPerto, hdsnArtigos = "#" + constHdsnArtigos;

    //constantes divs hdsns
    var divHdsnL = "#divHdsnLentes", divHdsnLP = "#divHdsnLongePerto";

    //constantes floating divs
    var divFloatingDefinicao = "elemFloatingDefinicao", divFloatingEntrega = "elemFloatingEntrega", divFloatingConfigGraduacoes = "elemFloatingConfigGraduacoes";
    var divFloatingTransposicao = "elemFloatingTransposicao", divFloatingLimpar = "elemFloatingLimpar";

    //constantes casas decimais
    var campoCasasDecPU = 'CasasDecimaisPrecosUnitarios', campoCasasDecTot = 'CasasDecimaisTotais', campoCasasDecIVA = 'CasasDecimaisIva', campoSimboloMoeda = 'Simbolo';

    //constantes tipo de servico
    var tblLentes = "#tblLentes", tblOculos = "#tblOculos";

    //constantes definicoes graduacoes
    var spnConfigGraduacoes = "#spnConfigGraduacoes", spnConfigGraduacoesIcon = "#spnConfigGraduacoesIcon";
    var spnTransposicao = "#spnTransposicao";
    var spnLimpar = "#spnLimpar", spnLimparOE = "#spnLimparOE", spnLimparOD = "#spnLimparOD", spnLimparAmbos = "#spnLimparAmbos";
    var spnCopiaEsquerdaLC = "#spnCopiaEsquerdaLC", spnCopiaDireitaLC = "#spnCopiaDireitaLC", spnCopiaEsquerdaO = "#spnCopiaEsquerdaO", spnCopiaDireitaO = "#spnCopiaDireitaO";
    var rdBtnTipo = "input[type='radio'][name='TipoServico']", rdBtnTipo2 = "input[type='radio'][name='TipoServicoOlho']";

    //constantes copiar
    var campoAmbos = "Ambos", campoOD = "OlhoDireito", campoTabOD = "TabOlhoDireito", clsTOD = "." + campoTabOD;
    var campoOE = "OlhoEsquerdo", campoTabOE = "TabOlhoEsquerdo", clsTOE = "." + campoTabOE;

    //constantes linhas de graduacoes
    var campoTabLonge = "TabLonge", clsTabLonge = "." + campoTabLonge, campoTabInt = "TabInt", clsTabInt = "." + campoTabInt, campoTabPerto = "TabPerto", clsTabPerto = "." + campoTabPerto;
    var campoTabLentes = "TabLentes";

    //constantes posicoes floating divs
    var Posicao = {
        Bottom: 0,
        Top: 1,
        Center: 2
    };

    //constantes opacidade floating divs
    var Opacity = {
        None: 0
    };

    //constantes tipos de servico
    var TipoServico = {
        LongePerto: 1,
        Longe: 2,
        Perto: 3,
        BifocalAmbos: 4,
        ProgressivaAmbos: 5,
        Contacto: 6,
        BifocalOlhoDireito: 7,
        BifocalOlhoEsquerdo: 8,
        ProgressivaOlhoDireito: 9,
        ProgressivaOlhoEsquerdo: 10
    };

    //constantes tipos de olho
    var TipoOlho = {
        Direito: 1,
        Esquerdo: 2,
        Aro: 3,
        Diversos: 4
    };

    //constantes tipos de graduacao
    var TipoGraduacao = {
        Longe: 1,
        Intermedio: 2,
        Perto: 3,
        LentesContato: 4,
        Diversos: 5
    };

    //constantes tipos de artigo
    var TipoArtigo = {
        LentesOftalmicas: 1,
        Aros: 2,
        LentesContacto: 3,
        OculosSol: 4,
        Diversos: 5
    };

    //------------------------------------ V A R I A V E I S     P R I V A D A S
    self.ModeloServico = {}; //modelo lado cliente
    var ListaColunasIgnoraBloqueioAssinatura = []; //colunas a bloquear pela assinatura
    var htmlSpanTags = '<span class=titulocolunaHT></span>';  //colunas merged na tab artigos
    var NumMaxServicos = 5; //num max de servicos
    var selectedHT; //handsontable selecionada
    var DisableViaEstado = false; //inativa campos via estado anulado ou efetivo c/ registos
    //  flags
    var isLOAD_DATA = false;
    var isTRIGGER_CLICK = false; //rdBtnTipo
    var isTRIGGER_CLICK_TIPO2 = false; //rdBtnTipo2
    //  end flags

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //trata bind dos eventos de init
        self.BindInitEvents();

        //trata floating divs
        self.PosicionaFloatingDivs();

        //trata observacoes e avisos
        UtilsObservacoesTrataEspecifico("tabObservacoes", "Observacoes", "Avisos");

        //trata o historico da oficina
        self.TrataHistoricoFases();
    };

    /* @description funcao document ready */
    self.BindInitEvents = function () {
        $("." + btClassGuardarFecha2 + ", ." + btClassGuardarFecha + ", ." + btClassGuardar + ", ." + btClassGuardarContinua).unbind("click").click(function (e) {
            var elemID = $(e.currentTarget).attr("id");
            var elemBtID = elemID.replace("F3MGrelhaFormDocumentosVendasServicos", "");
            var grid = KendoRetornaElemento($("#F3MGrelhaFormDocumentosVendasServicos"));
            self.Acoes(grid, elemBtID);
        });

        $(".input-dioptria").on("mousedown", function (e) {
            if ((!$(e.currentTarget).hasClass('Altura')) && (!$(e.currentTarget).hasClass('AcuidadeVisual')) && (!$(e.currentTarget).hasClass('AnguloPantoscopico')) && (!$(e.currentTarget).hasClass('DistanciaVertex')) && (!$(e.currentTarget).hasClass('DNP'))) {
                if (DisableViaEstado) {
                    e.stopImmediatePropagation();
                    e.preventDefault();
                    return false;
                }
            }
        });

        $(".input-dioptria").on("focus", function (e) {
            if ((!$(e.currentTarget).hasClass('Altura')) && (!$(e.currentTarget).hasClass('AcuidadeVisual')) && (!$(e.currentTarget).hasClass('AnguloPantoscopico')) && (!$(e.currentTarget).hasClass('DistanciaVertex')) && (!$(e.currentTarget).hasClass('DNP'))) {
                if (DisableViaEstado) {
                    e.stopImmediatePropagation();
                    e.preventDefault();
                    return false;
                }
            }
            e.currentTarget.oldValue = e.currentTarget.value;
        });

        $(".input-dioptria").on("blur", function (e) {
            var tipoGraduacao = e.currentTarget.className.split(" ")[2];
            var graduacoesAlteradas = JSON.parse($('#GraduacoesAlteradas').val());

            if ($.inArray(tipoGraduacao, graduacoesAlteradas) === -1) {
                graduacoesAlteradas.push(tipoGraduacao);
                $('#GraduacoesAlteradas').val(JSON.stringify(graduacoesAlteradas))
            }

            if (!UtilsVerificaObjetoNotNullUndefinedVazio($(e.currentTarget).val())) {
                $(e.currentTarget).val('0');
            }

            var max = parseInt($(e.currentTarget).attr("max"));
            var min = parseInt($(e.currentTarget).attr("min"));
            var val = parseInt($(e.currentTarget).val());
            if (val > max || val < min) {
                $(e.currentTarget).val(val > max ? max : min);
            }

            var getOlho = e.currentTarget.className.split(" ")[1]; // DIREITO || ESQUERDO
            var IDTipoOlho = getOlho === campoTabOD ? TipoOlho.Direito : TipoOlho.Esquerdo; // 1 || 2
            var getTab = e.currentTarget.parentElement.parentElement.className.split(" ")[0]; //LONGE || INTERMEDIO ||  PERTO

            var IDTipoGraduacao;
            switch (getTab) {
                case campoTabLonge:

                    IDTipoGraduacao = TipoGraduacao.Longe;
                    var valorPE = parseFloat($(e.currentTarget).closest('tr').find('.' + getOlho + '.PotenciaEsferica').val()) + parseFloat($(e.currentTarget).closest('tr').find('.' + getOlho + '.Adicao').val());
                    $($(e.currentTarget).closest('tr').siblings()[1]).find('.' + getOlho + '.PotenciaEsferica').val(valorPE);

                    self.AtualizaObjGraduacoes(ModeloServico.Servicos, IDTipoOlho, TipoGraduacao.Perto, 'PotenciaEsferica', valorPE);

                    var valorPC = parseFloat($(e.currentTarget).closest('tr').find('.' + getOlho + '.PotenciaCilindrica').val());
                    $($(e.currentTarget).closest('tr').siblings()[1]).find('.' + getOlho + '.PotenciaCilindrica').val(valorPC);

                    self.AtualizaObjGraduacoes(ModeloServico.Servicos, IDTipoOlho, TipoGraduacao.Perto, 'PotenciaCilindrica', valorPC);

                    var valorAX = parseFloat($(e.currentTarget).closest('tr').find('.' + getOlho + '.Eixo').val());
                    $($(e.currentTarget).closest('tr').siblings()[1]).find('.' + getOlho + '.Eixo').val(valorAX);


                    self.AtualizaObjGraduacoes(ModeloServico.Servicos, IDTipoOlho, TipoGraduacao.Perto, 'Eixo', valorAX);


                    break;
                case campoTabPerto:
                    IDTipoGraduacao = TipoGraduacao.Perto;
                    break;
                case campoTabInt:
                    IDTipoGraduacao = TipoGraduacao.Intermedio;
                    break;
                case campoTabLentes:
                    IDTipoGraduacao = TipoGraduacao.LentesContato;
                    break;
            }
            var getCampoID = e.currentTarget.className.split(" ")[2];
            var valor = $(e.currentTarget).val();
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, IDTipoOlho, IDTipoGraduacao, getCampoID, valor);

            if (e.currentTarget.oldValue != e.currentTarget.value && !$(e.relatedTarget).hasClass("input-dioptria") || !$(e.relatedTarget).length) {
                if (!$('#spnCopiaDireitaO').is(':active') && !$('#spnCopiaEsquerdaO').is(':active') &&
                    !$('#spnCopiaDireitaLC').is(':active') && !$('#spnCopiaEsquerdaLC').is(':active')) {
                    self.ValidaExisteArtigo(e.currentTarget);
                } else {
                    var target = e.currentTarget;
                    setTimeout(function () {
                        self.ValidaExisteArtigo(target);
                    }, 100);
                }
            }
        });

        $("#DataReceita").on("change", function (e) {
            self.SetValorCampoObj(ModeloServico.Servicos, "DataReceita", $(e.currentTarget).val(), self.GetServicoActivo());
            self.AtivaDirty();
        });

        $(".Currency").html("&nbsp;" + $("#SimboloMoedaRefCliente").val());

        $("#accordion").on("show.bs.collapse", function () {
            $("#divLimparTransposicao").css("display", "block");

        }).on("hidden.bs.collapse", function () {
            $("#divLimparTransposicao").css("display", "none");
        });

        $(".anexContainer").on("click", function (e) {
            self.AbreAnexos();
            return false;
        });

        $(".adiantamentoPagamento").off('click').on("click", function (e) {
            self.AbrePagamentosAdiantamentos(e);
            return false;
        });

        $('#recebimentos').off('click').on('click', function (e) {
            self.AbreRecebimentos(e);
            return false;
        });

        $("#Entidade1Automatica").on("click", function (e) {
            self.AtualizaComparticipacoes();
        });

        $("#IDEntidade1").on("change", function (e) {
            self.AtualizaComparticipacoes();
        });

        $('#spanTotalIva').on('click', function (e) {
            self.PreencheIncidencias();
        });

        $("#" + btnSubstituicaoArtigos).on("click", () => self.GeraSubstituicaoArtigos());

        $('#documentoVenda, #entidade2').off('click').on('click', function (e) {
            var _url = rootDir + 'DocumentosVendasServicos/BlnEEfetivo';
            var _id = parseInt($('#' + campoID).val());

            UtilsChamadaAjax(_url, true, JSON.stringify({ IDDocumentoVenda: _id }),
                function (res) {
                    if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                        if (res) {
                            var urlAux = rootDir + "DocumentosVendasServicos/LerDocumentosAssociados";
                            var objetoFiltro = GrelhaUtilsObjetoFiltro();
                            var iddocumento = $('#IDDocumentoVenda').val();
                            var tipodocumento = $("#IDTipoDocumento").val();
                            var totalentidade2 = $("#TotalEntidade2").val().replace(',', '.');

                            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'iddocumento', '', iddocumento);
                            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'tipodocumento', '', tipodocumento);
                            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'totalentidade2', '', totalentidade2);
                            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'opcao', '', e.currentTarget.id);
                            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'origem', '', 'servicos');

                            UtilsChamadaAjax(urlAux, true, JSON.stringify({ inObjFiltro: objetoFiltro }),
                                function (res) {
                                    if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {

                                        if (res.ID > 0) {
                                            UtilsAbreTab('/Documentos/DocumentosVendas?IDDrillDown=' + res.ID, resources['DocumentosVendas'], 'f3icon-glasses', '1', '', '');
                                        }
                                        else {
                                            self.GeraDocVenda(e.currentTarget.id);
                                        }
                                    }
                                }, function (e) { throw e; }, 1, true);
                        }
                        else {
                            UtilsNotifica(base.constantes.tpalerta['i'], resources['DocNaoEfetivo']);
                        }
                    }
                }, function (e) { throw e; }, 1, true);
        });

        $('#btnImportarConsulta').on('click', function (e) {
            var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
            var objData = {};
            var acao = '../Exames/Exames/IndexGrelhaEspecifico';
            JanelaDesenha(janelaMenuLateral, objData, acao, acao);
        });

        $('#btnImportarSubServico').on('click', function () {
            var objData = {};
            var acao = '../Documentos/DocumentosVendasServicos/IndexGrelhaEspecifico';

            JanelaDesenha(base.constantes.janelasPopupIDs.Menu, objData, acao, acao);
        });

        //$('#' + campoIDEnti).val() ? $('#btnImportarConsulta').show() : $('#btnImportarConsulta').hide();
    };

    /* @description funcao que trata o historico da oficina */
    self.TrataHistoricoFases = function () {
        if ($('#fasesHistorico').length) {
            $('#tabHistorico > .row').prepend($('#fasesHistorico'));
        }
    };

    //------------------------------------ T A B S
    /* @description funcao do clique nos tabs */
    self.CliqueTab = function (e) {
        var tabHref = $(e).attr("href");

        self.RemoveLinhasHeader();

        switch (tabHref) {
            case "#tabServicos":
                if (!$(hdsnPerto).hasClass("handsontable") && !$(hdsnLonge).hasClass("handsontable") && !$(hdsnLentes).hasClass("handsontable")) {
                    self.InitTabServicos(true);

                    if (constIsMobile === true) {
                        if ($('#btnsomatorio').find('span').hasClass('fm f3icon-angle-right')) {
                            $("#btnsomatorio").trigger("click");
                        }
                    }
                    else {
                        if ($('#btnsomatorio').find('span').hasClass('fm f3icon-angle-left')) {
                            $("#btnsomatorio").trigger("click");
                        }
                    }
                }
                break;

            case "#tabArtigos":
                self.InitTabArtigos();

                if (constIsMobile === true) {
                    if ($('#btnsomatorio').find('span').hasClass('fm f3icon-angle-right')) {
                        $("#btnsomatorio").trigger("click");
                    }
                }
                else {
                    if ($('#btnsomatorio').find('span').hasClass('fm f3icon-angle-left')) {
                        $("#btnsomatorio").trigger("click");
                    }
                }
                break;
        }
    };

    /* @description funcao do clique no tab servicos */
    self.InitTabServicos = function (boolClick) {
        var gBts = $("#ServicosBts");
        gBts.find("." + constBtsClass.Todos).on("click", function (e) {
            self.CliqueBotoes(e);
        });

        //Configura floating divs
        ElemFloatingMostraPosiciona(divFloatingEntrega, Posicao.Bottom, Opacity.None, self.AtualizaLabelEntrega, null);

        self.ConfiguraInputsTabServicos();

        self.ConfiguraCliqueLinhasServicos();

        // PDC 08/10/2018 - FIX para a altura da dropdown list com as horas
        $('[aria-controls="DataEntregaLonge_timeview"]').one('click', function () {
            $('.k-animation-container').height('');
        });
        $('[aria-controls="DataEntregaPerto_timeview"]').one('click', function () {
            $('.k-animation-container').height('');
        });
    };

    /* @description funcao do clique no tab artigos */
    self.InitTabArtigos = function () {
        var result = ModeloServico.Servicos.filter(function (f) {
            return f.AcaoCRUD != constEstados.Remover;
        });

        var data = self.MapeiaLinhasPorTipoServico(result, true);

        data.push({
            Diametro: "<div class='leftDescription'>" + resources.Diversos + "</div>",
            IDTipoOlho: 0
        });

        var arrDivSemRems = ModeloServico.Diversos.filter(function (f) {
            return f.AcaoCRUD != constEstados.Remover;
        });

        data.push.apply(data, arrDivSemRems);

        var arrayMergeCells = [];
        for (var i = 0, len = data.length; i < len; i++) {
            var item = data[i];

            if (item.IDTipoOlho === 0) {
                arrayMergeCells.push({ row: i, col: 0, rowspan: 1, colspan: self.RetornaColunasHT().length });
            }
        }

        self.InitHandsonTable(constHdsnArtigos, data, null, arrayMergeCells, true, true, null);
    };

    /* @description funcao que faz o bind aos campos no tab servicos */
    self.ConfiguraInputsTabServicos = function () {

        $(spnConfigGraduacoes + "," + spnConfigGraduacoesIcon).on("click", function (e) {
            ElemFloatingCliqueElemRef(divFloatingConfigGraduacoes, $(e.currentTarget), Posicao.Bottom, Opacity.None, self.AtualizaLabelGraduacoes, null);

            $("#VerPrismas, #VisaoIntermedia").on("change", function (e) {
                var chkID = $(e.currentTarget).attr("id");
                var checked = $(e.currentTarget).is(":checked");

                self.ConfiguraDefinicoes(chkID, checked);
                self.SetValorCampoObj(ModeloServico.Servicos, chkID, checked, self.GetServicoActivo());
            });

            return false;
        });

        $(spnTransposicao).on("click", function (e) {
            ElemFloatingCliqueElemRef(divFloatingTransposicao, $(e.currentTarget), Posicao.Bottom, Opacity.None, null, null);
            $("#elemFloatingTransposicao label").off("click");
            $("#elemFloatingTransposicao label").on("click", function (e) {
                var servico = self.SubServicoRetorna(self.GetServicoActivo());
                var tbl = (servico[0].IDTipoServico !== 6) ? $("#tblOculos table") : $("#tblLentes table");
                var rows = tbl.find("tr");
                var btn = $(e.currentTarget).find("span").attr("id");

                $.each(rows, function (index, value) {
                    if (btn === "spnTranspOE") {
                        self.CalculaTransposicao($(value).find(clsTOE + ".PotenciaEsferica"), $(value).find(clsTOE + ".PotenciaCilindrica"), $(value).find(clsTOE + ".Eixo"));
                    } else if (btn === "spnTranspOD") {
                        self.CalculaTransposicao($(value).find(clsTOD + ".PotenciaEsferica"), $(value).find(clsTOD + ".PotenciaCilindrica"), $(value).find(clsTOD + ".Eixo"));
                    } else if (btn === "spnTranspAmbos") {
                        self.CalculaTransposicao($(value).find(clsTOE + ".PotenciaEsferica"), $(value).find(clsTOE + ".PotenciaCilindrica"), $(value).find(clsTOE + ".Eixo"));
                        self.CalculaTransposicao($(value).find(clsTOD + ".PotenciaEsferica"), $(value).find(clsTOD + ".PotenciaCilindrica"), $(value).find(clsTOD + ".Eixo"));
                    }
                });

                return false;
            });
            return false;
        });

        $(spnLimpar).on("click", function (e) {
            ElemFloatingCliqueElemRef(divFloatingLimpar, $(e.currentTarget), Posicao.Bottom, Opacity.None, null, null);
            $("#elemFloatingLimpar label").on("click", function (e) {
                var btnLimp = $(e.currentTarget).find("span").attr("id");
                if (btnLimp === "spnLimparOE") {
                    $(clsTOE).val(0);
                }
                else if (btnLimp === "spnLimparOD") {
                    $(clsTOD).val(0);

                }
                else if (btnLimp === "spnLimparAmbos") {
                    $(clsTOE).val(0);
                    $(clsTOD).val(0);
                }

                self.LimpaGraduacoes(btnLimp);

                return false;
            });
            return false;
        });

        $(spnCopiaEsquerdaLC + ", " + spnCopiaEsquerdaO + ", " + spnCopiaDireitaLC + ", " + spnCopiaDireitaO).on("click", function (e) {
            
            var servico = self.SubServicoRetorna(self.GetServicoActivo());
            var tbl = (servico[0].IDTipoServico !== 6) ? $("#tblOculos table") : $("#tblLentes table");
            var rows = tbl.find("tr");
            $.each(rows, function (index, value) {
                var inputs;
                if (e.currentTarget.id.indexOf("Esquerda") > -1) {
                    inputs = $(value).find("td input" + clsTOE);
                    $.each(inputs, function (index1, value1) {
                        $(value1).val($(value).find("input." + $(value1).attr("class").replace(campoTabOE, campoTabOD).replace(/\s+/g, ".")).val());
   
                        var getTab = value1.parentElement.parentElement.className.split(" ")[0];

                        var IDTipoGraduacao;
                        switch (getTab) {
                            case campoTabLonge:
                                IDTipoGraduacao = TipoGraduacao.Longe;
                                break;
                            case campoTabPerto:
                                IDTipoGraduacao = TipoGraduacao.Perto;
                                break;
                            case campoTabInt:
                                IDTipoGraduacao = TipoGraduacao.Intermedio;
                                break;
                            case campoTabLentes:
                                IDTipoGraduacao = TipoGraduacao.LentesContato;
                                break;
                        }
                        self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, IDTipoGraduacao, value1.className.split(" ")[2], $(value1).val());
                    });
                } else {
                    inputs = $(value).find("td input" + clsTOD);
                    $.each(inputs, function (index2, value2) {
                        $(value2).val($(value).find("input." + $(value2).attr("class").replace(campoTabOD, campoTabOE).replace(/\s+/g, ".")).val());
                        var getTab = value2.parentElement.parentElement.className.split(" ")[0]; //LONGE || INTERMEDIO ||  PERTO

                        var IDTipoGraduacao;
                        switch (getTab) {
                            case campoTabLonge:
                                IDTipoGraduacao = TipoGraduacao.Longe;
                                break;
                            case campoTabPerto:
                                IDTipoGraduacao = TipoGraduacao.Perto;
                                break;
                            case campoTabInt:
                                IDTipoGraduacao = TipoGraduacao.Intermedio;
                                break;
                            case campoTabLentes:
                                IDTipoGraduacao = TipoGraduacao.LentesContato;
                                break;
                        }
                        self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, IDTipoGraduacao, value2.className.split(" ")[2], $(value2).val());
                    });
                }
            });
        });

    };

    //------------------------------------ C A B E C A L H O    E S P E C I F I C O
    /* @description funcao especifica quando e' alterada a entidade */
    self.ChangeEntidade = function (inEntSel) {
        if ($("#Idade").length > 0) {
            var dataNascimento = inEntSel["DataNascimento"] != null ? new Date(parseInt(inEntSel["DataNascimento"].replace("/Date(", "").replace(")/", ""))) : "";
            var idade = dataNascimento !== "" ? UtilsCalculaIdade(dataNascimento) : "";
            $("#Idade").val(idade);
        }

        //notifica com os avisos do cliente
        UtilsNotifica(base.constantes.tpalerta['i'], inEntSel['Avisos']);

        KendoRetornaElemento($('#IDEntidade1')).value(inEntSel.IDEntidade1);
        KendoRetornaElemento($('#IDEntidade2')).value(inEntSel.IDEntidade2);
        $('#NumeroBeneficiario1').val(inEntSel.NumeroBeneficiario1);
        $('#NumeroBeneficiario2').val(inEntSel.NumeroBeneficiario2);
        $('#Parentesco1').val(inEntSel.Parentesco1);
        $('#Parentesco2').val(inEntSel.Parentesco2);

        //$('#' + campoIDEnti).val() ? $('#btnImportarConsulta').show() : $('#btnImportarConsulta').hide();

        self.ConfiguraColunasMoedaBase(inEntSel[campoSimboloMoeda], inEntSel[campoCasasDecTot], inEntSel[campoCasasDecPU], inEntSel[campoCasasDecIVA]);
        self.Calcula(null, null, null, true, null, null, true);
    };

    /* @description funcao especifica que trata a informacao quando e' alterada a entidade */
    self.TrataInformacaoEntidade = function (inEntSel) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(inEntSel)) {
            // Moeda
            let campoMoeda = $('#' + campoIDMoeda);
            if (UtilsVerificaObjetoNotNullUndefinedVazio(campoMoeda)) {
                campoMoeda.val(inEntSel[campoIDMoeda]);
            }
            // Taxa de conversao
            let elemTaxaConv = $('#' + campoTaxaConv);
            if (UtilsVerificaObjetoNotNullUndefinedVazio(elemTaxaConv)) {
                let valorTaxaConvDoc = UtilsFormataSeparadoresDecimais_Milhares(parseFloat(inEntSel[campoTaxaConv]).toFixed(6), 'Currency');
                elemTaxaConv.val(valorTaxaConvDoc);
            }
            // Espaco fiscal
            let campoEspacoFiscal = $('#' + campoIDEspacoFiscal);
            if (UtilsVerificaObjetoNotNullUndefinedVazio(campoEspacoFiscal)) {
                campoEspacoFiscal.val(inEntSel.IDEspacoFiscal);
                $('#EspacoFiscal').val(inEntSel.DescricaoEspacoFiscal);
            }
            // Regime de iva
            let campoRegimeIva = $('#' + campoIDRegimeIva);
            if (UtilsVerificaObjetoNotNullUndefinedVazio(campoRegimeIva)) {
                campoRegimeIva.val(inEntSel.IDRegimeIva);
                $('#RegimeIva').val(inEntSel.DescricaoRegimeIva);
            }
            // Local da operacao
            let campoLocalOperacao = $('#' + campoIDLocalOperacao);
            if (UtilsVerificaObjetoNotNullUndefinedVazio(campoLocalOperacao)) {
                campoLocalOperacao.val(inEntSel.IDLocalOperacao);
                $('#DescricaoLocalOperacao').val(inEntSel.DescricaoLocalOperacao);
            }
            // SiglaPais
            if (UtilsVerificaObjetoNotNullUndefinedVazio($('#SiglaPaisFiscal'))) {
                $('#SiglaPaisFiscal').val(inEntSel.SiglaPais);
            }
        }
        else {
            // Moeda
            let campoMoeda = $('#' + campoIDMoeda);
            campoMoeda.val(undefined);
            // Taxa de conversao
            let elemTaxaConv = $('#' + campoTaxaConv);
            elemTaxaConv.val(undefined);
            // Espaco fiscal
            let campoEspacoFiscal = $('#' + campoIDEspacoFiscal);
            campoEspacoFiscal.val(undefined);
            // Regime de iva
            let campoRegimeIva = $('#' + campoIDRegimeIva);
            campoRegimeIva.val(undefined);
            // Local da operacao
            let campoLocalOperacao = $('#' + campoIDLocalOperacao);
            campoLocalOperacao.val(undefined);
        }
    };

    /* @description funcao especifica quando e' alterada a moeda do cliente */
    self.ChangeMoeda = function (inCmbMoeda) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(inCmbMoeda)) {
            var novoSimboloMoeda = inCmbMoeda.dataItem()[campoSimboloMoeda];
            var intCasasDecTotais = inCmbMoeda.dataItem()[campoCasasDecTot];
            var intCasasDecPrecoUni = inCmbMoeda.dataItem()[campoCasasDecPU];
            var intCasasDecIVA = inCmbMoeda.dataItem()[campoCasasDecIVA];
            var arrHdsn = [];

            self.ConfiguraColunasMoedaBase(novoSimboloMoeda, intCasasDecTotais, intCasasDecPrecoUni, intCasasDecIVA, arrHdsn);
            self.Calcula(null, arrHdsn, null, true, null, null);
        }
    };

    //------------------------------------ F L O A T I N G     D I V S
    /* @description funcao que trata o posicionamento das floating divs */
    self.PosicionaFloatingDivs = function () {
        ElemFloatingMostraPosiciona("elemFloatingDescontos", Posicao.Bottom, Opacity.None, self.AtualizaOutrosDescontos, null);
        ElemFloatingMostraPosiciona('elemFloatingIncidencias', Posicao.Bottom, Opacity.None, null, null);
    };

    /* @description funcao que abre e posiciona a floating div das entregas na tab dos artigos */
    self.CliqueFloatingEntregasArtigos = function (e) {
        var gridHT = window.HotRegisterer.bucket[constHdsnArtigos];
        var activeRow = gridHT.getSelected()[0][0];
        var IDServico = gridHT.getDataAtRowProp(activeRow, "IDServico");
        var elem = $(elemFloatingEntregaArtigos).find(".set-resumo");

        self.TrataDatasEntrega("DataEntregaLongeAux", "DataEntregaPertoAux", IDServico);

        if (UtilsVerificaObjetoNotNullUndefinedVazio(elem)) {
            if ($(e).parents().closest(".ht_clone_left").length > 0) {
                elem.removeClass("abre-dir").removeAttr("style").css("left", "65px");
            }
            else {
                elem.addClass("abre-dir").removeAttr("style").css("right", "22px");
            }
        }
        ElemFloatingCliqueElemRef("elemFloatingEntregaArtigos", $(e), 0, 0, self.AtualizaLabelEntregaArtigos, null);
    };

    /* @description funcao que atualiza o valor do campo 'Outros Descontos'*/
    self.AtualizaOutrosDescontos = function () {
        var val = KendoRetornaElemento($("#TotalPontos")).value() + KendoRetornaElemento($("#TotalValesOferta")).value();
        $("#IdOutrosDescontos").text(parseFloat(val).toFixed(constRefCasasDecimaisTotais));
    };

    /* @description funcao especifica quando e' alterada a moeda do cliente */
    self.AtualizaComparticipacoes = function () {
        var arrHdsn = [];

        UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnLonge]) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnLonge]) : false;
        UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnLonge]) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnPerto]) : false;
        UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnLonge]) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnLentes]) : false;
        UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnLonge]) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnArtigos]) : false;

        self.ReplaceExecuteFunction(arrHdsn);
    };

    //------------------------------------ S E R V I C O S
    /* @description  funcao que retorna o ID do servico ativo  */
    self.GetServicoActivo = function () {
        return parseInt($("#ulServicos").find(".active").attr("id").replace("liServico", ""));
    };

    /* @description funcao que retorna a lista de sub servicos */
    self.RetornaListaSubServicos = function () {
        return ModeloServico.Servicos;
    };

    /* @description funcao que retorna o subservico by id */
    self.SubServicoRetorna = (subServicoId) => $.grep(ModeloServico.Servicos, (data) => data.ID === subServicoId && data.AcaoCRUD != constEstados.Remover);

    /* @description funcao que verificar o tipo de acao a executar nos subservicos (adicionar, duplicar, remover) */
    self.CliqueBotoes = function (e) {
        e.preventDefault();
        var elemBt = $(e.currentTarget);
        if (!elemBt.hasClass(btClassDisabled) && elemBt) {
            var elemBtID = elemBt.attr("id").replace("Servicos", "");
            self.AcoesServico(elemBtID);
        }
        e.stopImmediatePropagation();
    };

    /* @description funcao de acoes nos subservicos (adicionar, duplicar, remover) */
    self.AcoesServico = function (elemID) {

        F3MFormulariosAtivaCliqueGravareContinuar(null);
        switch (elemID) {
            case btIDDuplicar:
                self.SubServicoDuplica(self.GetServicoActivo());
                break;

            case btIDRemove:
                self.SubServicoRemove(self.GetServicoActivo());
                break;

            case btnSubstituicaoArtigos:
                return;
                break;
        }

        self.AtivaDirty();
    };

    /* @description funcao da acao adicionar um subservico */
    self.SubServicoAdiciona = function (byModel, tipoServicoCheck) {

        var ListOfServicos = ModeloServico.Servicos.filter(function (f) { return f.AcaoCRUD != constEstados.Remover; });

        if (ListOfServicos.length < NumMaxServicos) {
            var novoLI = $("#ulServicos > li.active").clone();
            var novoID = parseInt($("#ulServicos > li:last").attr("id").replace("liServico", "")) + 1;
            $(novoLI).attr("id", "liServico" + novoID);
            $("#ulServicos > li.active").removeClass("active");
            $("#ulServicos").append(novoLI);
            $("#liServico" + novoID).addClass("active");

            var urlAux = rootDir + "DocumentosVendasServicos/" + "/AddSubServico";
            var filtro = JSON.stringify({ modelo: null });

            if (UtilsVerificaObjetoNotNullUndefined(byModel)) {
                filtro = JSON.stringify({ modelo: byModel });
            }
            else if (tipoServicoCheck) {
                filtro = JSON.stringify({ modelo: null, IDTipoServico: tipoServicoCheck });
            }
            else {
                var IDTipoServicoLentes = $('.AddLentesContacto').length === 1 ? 6 : null;
                if (UtilsVerificaObjetoNotNullUndefined(IDTipoServicoLentes)) {
                    filtro = JSON.stringify({ modelo: null, IDTipoServico: IDTipoServicoLentes });
                }
            }

            UtilsChamadaAjax(urlAux, false, filtro,
                function (res) {
                    if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                        res.ID = novoID;
                        if (UtilsVerificaObjetoNotNullUndefined(res.DataReceita)) {
                            res.DataReceita = UtilsConverteJSONDate(res.DataReceita, constJSONDates.ConvertToDDMMAAAA);
                        }
                        res.DocumentosVendasLinhas.map(function (data) {
                            return data.IDServico = res.ID;
                        });

                        $.merge(ModeloServico.Servicos, [res]);
 
                        self.SetValorCampoObj(ModeloServico.Servicos, "CombinacaoDefeito", $("#CombinacaoDefeito").prop("checked"), res.ID);
                        self.CarregaSubServico(res.ID);
                        self.EnableOrDisableBtRemoverServico();
                        self.ConfiguraCliqueLinhasServicos();
                    }
                }, function (e) { }, 1, true);
        }
    };

    /* @description funcao da acao remover um subservico */
    self.SubServicoRemove = function (inServID) {
        var subServico = self.SubServicoRetorna(inServID)[0];

        if (subServico.AcaoCRUD == constEstados.Adicionar) {
            ModeloServico.Servicos = $.grep(ModeloServico.Servicos, function (a, x) {
                return a.ID != inServID;
            });
        }
        else {
            subServico.AcaoCRUD = constEstados.Remover;
        }

        $("#liServico" + inServID).hide("fast", function () {
            $("#liServico" + inServID).remove();
            $("#ulServicos > li:first").trigger("click");
        });

        self.EnableOrDisableBtRemoverServico();

        self.Calcula(null, null, null, true, null, null);
        self.ExisteMaisQueUmSubServico();
    };

    /* @description funcao da acao duplicar um subservico */
    self.SubServicoDuplica = function (inServID) {
        let servico = self.SubServicoRetorna(inServID)[0];
        self.SubServicoAdiciona(servico);
        self.Calcula(null, null, null, true, null, null);
    };

    /* @description funcao quando e' clicado na barra do lado direito e carrega o servico */
    self.ConfiguraCliqueLinhasServicos = function () {
        var serBts = $("#ulServicos > li");
        serBts.on("click", function (e) {

            var tab = $('#tabsSevicos li a.active').attr("href").replace("#", "");
            $(".f3m-tabs a[href='#tabServicos']").trigger("click");

            self.CliqueLinhasServicos(e, tab);
        });
    };

    /* @description funcao de acoes nos subservicos (adicionar, duplicar, remover) */
    self.CliqueLinhasServicos = function (e, tab) {
        e.preventDefault();
        $("#ulServicos > li.active").removeClass("active");
        $(e.currentTarget).addClass("active");

        var servID = parseInt(e.currentTarget.id.replace("liServico", ""));
        if (servID != null && tab === "tabServicos") {
            self.CarregaSubServico(servID);
        }

        e.stopImmediatePropagation();
    };

    /* @description funcao que carrega a lista de servicos*/
    self.CarregaListaServicos = function () {
        for (var i = 0, len = ModeloServico.Servicos.length; i < len; i++) {
            self.TrataJSONDatas(ModeloServico.Servicos[i]);
        }

        self.CarregaLinhasServicos();
        self.ConfiguraCliqueLinhasServicos();

    };


    self.AppendSubServico = function (value) {
        let li = document.createElement("li");
        let a = document.createElement("a");
        let divText = document.createElement("div");

        li.classList.add("nav-item", "animated", "fadeIn", "f3m-nav-servico__item");
        li.id = "liServico" + value.ID;

        divText.classList.add('clsF3MliServico');

        if (value.DescricaoServico) {
            let stringToSplit = value.DescricaoServico.split(',');
            divText.textContent = stringToSplit[0];

            if (stringToSplit[1]) {
                let smallText = document.createElement("span");
                smallText.classList.add('smallText');
                smallText.textContent = stringToSplit[1].replace(/\s/g, '');
                divText.appendChild(smallText);
            }
        }

        a.classList.add("nav-link");
        a.appendChild(divText);

        li.appendChild(a);

        $("#ulServicos").append(li);
    };
         
    /* @description funcao que carrega a info de cada servico */
    self.CarregaLinhasServicos = function () {
        
        $.each(ModeloServico.Servicos, function (index, value) {

            self.AppendSubServico(value);
            if (value.IDDocumentosVendasServicosSubstituicaoArtigos) {
                let id = "liServico" + value.ID;
                let li = document.getElementById(id);
                $(li).children().append("<span class='badge'><span class='fm f3icon-troca-artigos' title='Artigos Substituidos'></span></span>");
            }
                       
        });

        $("#ulServicos > li:first").addClass('active');

        self.EnableOrDisableBtRemoverServico();
    };

    /* @description funcao que carrega a info de um servico by id */
    self.CarregaSubServico = function (inSubServID) {
        KendoLoading($(".f3m-tabs.clsF3MTabs"), true);
        var servico = self.SubServicoRetorna(inSubServID);

        if (servico !== null) {
            var model = servico[0];
            var grad = model.DocumentosVendasLinhasGraduacoes;
            var gradLen = grad.length;
            var modelID = model.ID;

            //CARREGA GRADUACOES
            $.each(grad, function (ja, na) {
                var gradLinha = na;
                var seletor = "";

                switch (gradLinha.IDTipoGraduacao) {
                    case 1:
                        seletor = "tr" + clsTabLonge;
                        break;
                    case 2:
                        seletor = "tr" + clsTabInt;
                        break;
                    case 3:
                        seletor = "tr" + clsTabPerto;
                        break;
                }

                switch (gradLinha.IDTipoOlho) {
                    case 1:
                        seletor = seletor + " " + clsTOD;
                        break;
                    case 2:
                        seletor = seletor + " " + clsTOE;
                        break;
                }

                var tbl = gradLinha.IDTipoGraduacao == TipoGraduacao.LentesContato ? $("#tblLentes table") : $("#tblOculos table");
                $.each(gradLinha, function (j, n) {
                    if (!j.startsWith("_") && j.charAt(0) == j.charAt(0).toUpperCase()) {
                        var elem = tbl.find(seletor + "." + j);
                        if (elem.length) {
                            if (UtilsVerificaObjetoNotNullUndefinedVazio(n)) {
                                n = n.toString().replace(',', '.');
                            }
                            $(elem).val(n);
                        }
                    }
                });
            });

            var casasdecimais = $("#" + campoCasasDecTot).val();
            if (!(model.IDTipoServico == TipoServico.Contacto)) {
                $("#totalLonge").text(UtilsFormataSeparadoresDecimais_Milhares(model.TotalLonge.toFixed(casasdecimais), constTipoDeCampo.Moeda));
                $("#totalCompLonge").text(UtilsFormataSeparadoresDecimais_Milhares(model.TotalComparticipadoLonge.toFixed(casasdecimais), constTipoDeCampo.Moeda));
                $("#totalPerto").text(UtilsFormataSeparadoresDecimais_Milhares(model.TotalPerto.toFixed(casasdecimais), constTipoDeCampo.Moeda));
                $("#totalCompPerto").text(UtilsFormataSeparadoresDecimais_Milhares(model.TotalComparticipadoPerto.toFixed(casasdecimais), constTipoDeCampo.Moeda));
            } else {
                $("#totalLentes").text(UtilsFormataSeparadoresDecimais_Milhares(model.TotalLentesContacto.toFixed(casasdecimais), constTipoDeCampo.Moeda));
                $("#totalCompLentes").text(UtilsFormataSeparadoresDecimais_Milhares(model.TotalComparticipadoLentesContacto.toFixed(casasdecimais), constTipoDeCampo.Moeda));
            }

            self.AtualizaMaisDefinicoes(model);

            self.AtualizaCamposELabelDefinicao(model);

            //Carrega Handsons
            if (servico[0].IDTipoServico == TipoServico.Contacto) {
                self.SetLC();
            }
            else {
                self.SetO();

                var dataL = $.grep(servico[0].DocumentosVendasLinhas, function (data) {
                    return data.IDTipoGraduacao == 1;
                });
                var dataP = $.grep(servico[0].DocumentosVendasLinhas, function (data) {
                    return data.IDTipoGraduacao == 3;
                });
                self.InitHandsonTable(constHdsnLonge, dataL, 133);
                self.InitHandsonTable(constHdsnPerto, dataP, 133);
            }
        } else {
            self.SetO();
            self.InitHandsonTableModeloVazio(constHdsnLonge, constHdsnPerto);
            $(".input-dioptria").val(0);
        }

        self.AtualizaTituloColuna();

        KendoLoading($(".f3m-tabs.clsF3MTabs"), false);
    };

    /* @description funcao de limpar graduacoes */
    self.LimpaGraduacoes = function (inTipo) {
        var servico = self.SubServicoRetorna(self.GetServicoActivo());
        var tbl = (servico[0].IDTipoServico !== 6) ? $("#tblOculos table") : $("#tblLentes table");
        let rows = tbl.find("tr");

        switch (inTipo) {
            case "spnLimparOE":
                for (let i = 0; i < rows.length; i++) {
                    let inputs = $(rows[i]).find("td .input-dioptria" + clsTOE);
                    for (let j = 0; j < inputs.length; j++) {
                        let getTab = inputs[j].parentElement.parentElement.className.split(" ")[0]; //LONGE || INTERMEDIO ||  PERTO

                        let IDTipoGraduacao;
                        switch (getTab) {
                            case campoTabLonge:
                                IDTipoGraduacao = TipoGraduacao.Longe;
                                break;
                            case campoTabPerto:
                                IDTipoGraduacao = TipoGraduacao.Perto;
                                break;
                            case campoTabInt:
                                IDTipoGraduacao = TipoGraduacao.Intermedio;
                                break;
                            case campoTabLentes:
                                IDTipoGraduacao = TipoGraduacao.LentesContato;
                                break;
                        }

                        self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, IDTipoGraduacao, inputs[j].className.split(" ")[2], parseFloat($(inputs[j]).val()));
                    }
                }
                break;

            case "spnLimparOD":
                for (let i = 0; i < rows.length; i++) {
                    let inputs = $(rows[i]).find("td .input-dioptria" + clsTOD);
                    for (let j = 0; j < inputs.length; j++) {

                        let getTab = inputs[j].parentElement.parentElement.className.split(" ")[0]; //LONGE || INTERMEDIO ||  PERTO

                        let IDTipoGraduacao;
                        switch (getTab) {
                            case campoTabLonge:
                                IDTipoGraduacao = TipoGraduacao.Longe;
                                break;
                            case campoTabPerto:
                                IDTipoGraduacao = TipoGraduacao.Perto;
                                break;
                            case campoTabInt:
                                IDTipoGraduacao = TipoGraduacao.Intermedio;
                                break;
                            case campoTabLentes:
                                IDTipoGraduacao = TipoGraduacao.LentesContato;
                                break;
                        }

                        self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, IDTipoGraduacao, inputs[j].className.split(" ")[2], parseFloat($(inputs[j]).val()));
                    }
                }
                break;


            case "spnLimparAmbos":
                for (let i = 0; i < rows.length; i++) {
                    let inputs = $(rows[i]).find("td .input-dioptria");
                    for (let j = 0; j < inputs.length; j++) {
                        var getOlho = inputs[j].className.split(" ")[1]; // DIREITO || ESQUERDO
                        var IDTipoOlho = getOlho == campoTabOD ? TipoOlho.Direito : TipoOlho.Esquerdo; // 1 || 2

                        let getTab = inputs[j].parentElement.parentElement.className.split(" ")[0]; //LONGE || INTERMEDIO ||  PERTO

                        let IDTipoGraduacao;
                        switch (getTab) {
                            case campoTabLonge:
                                IDTipoGraduacao = TipoGraduacao.Longe;
                                break;
                            case campoTabPerto:
                                IDTipoGraduacao = TipoGraduacao.Perto;
                                break;
                            case campoTabInt:
                                IDTipoGraduacao = TipoGraduacao.Intermedio;
                                break;
                            case campoTabLentes:
                                IDTipoGraduacao = TipoGraduacao.LentesContato;
                                break;
                        }

                        self.AtualizaObjGraduacoes(ModeloServico.Servicos, IDTipoOlho, IDTipoGraduacao, inputs[j].className.split(" ")[2], parseFloat($(inputs[j]).val()));
                    }
                }
                break;
        }
    };

    /* @description funcao que trata se o botao de remover um servico esta ativo ou nao */
    self.EnableOrDisableBtRemoverServico = function () {
        var result = ModeloServico.Servicos.filter(function (f) { return f.AcaoCRUD != constEstados.Remover; });

        if (result.length > 1) {
            $("#ServicosBtRemove").removeClass("disabled");
        }
        else {
            $("#ServicosBtRemove").addClass("disabled");
        }

        if (result.length < NumMaxServicos) {
            $('#ServicosBtAdd').removeClass('disabled');
            $('#ServicosBtCopy').removeClass('disabled');
        }
        else {
            $('#ServicosBtAdd').addClass('disabled');
            $('#ServicosBtCopy').addClass('disabled');
        }
    };

    /* @description funcao que atualiza a label de descricao na handson artigos */
    self.AtualizaLabelEntregaArtigos = function () {
        var gridHT = window.HotRegisterer.bucket[constHdsnArtigos];
        var activeRow = gridHT.getSelected()[0][0];
        var IDServico = gridHT.getDataAtRowProp(activeRow, "IDServico");

        var obj = ModeloServico.Servicos.filter(function (f) {
            return f.ID == IDServico;
        });
        var descrSubServico = obj[0].DescricaoServico == null ? " - " : obj[0].DescricaoServico;
        var dataEntregaLonge = KendoRetornaElemento($("#DataEntregaLongeAux"))._oldText;
        var dataEntregaPerto = KendoRetornaElemento($("#DataEntregaPertoAux"))._oldText;

        self.SetValorCampoObj(ModeloServico.Servicos, "DataEntregaLonge", dataEntregaLonge, IDServico);
        self.SetValorCampoObj(ModeloServico.Servicos, "DataEntregaPerto", dataEntregaPerto, IDServico);

        var descricao = self.GetLabelArtigos(obj[0]);

        var newDescr = "<div class='leftDescription'>" + descrSubServico + " // <a onclick='$servicos.ajax.CliqueFloatingEntregasArtigos(this);'>" + descricao + "</a> </div>";

        gridHT.setDataAtRowProp(activeRow, "Diametro", newDescr);
    };

    /* @description funcao que retorna a descricao para a label na handson artigos */
    self.GetLabelArtigos = function (objData) {
        var dataEntregaLonge = objData.DataEntregaLonge == null ? "" : objData.DataEntregaLonge;
        var dataEntregaPerto = objData.DataEntregaPerto == null ? "" : objData.DataEntregaPerto;
        var finalDescr;

        switch (objData.IDTipoServico) {
            case TipoServico.LongePerto:
                finalDescr = resources.EntL + " - " + dataEntregaLonge + " // " + resources.EntP + " - " + dataEntregaPerto;
                break;
            case TipoServico.Perto:
                finalDescr = resources.EntP + " - " + dataEntregaPerto;
                break;
            case TipoServico.Longe:
                finalDescr = resources.EntL + " - " + dataEntregaLonge;
                break;
            default:
                finalDescr = resources.Entrega + " - " + dataEntregaLonge;
                break;
        }

        return finalDescr;
    };

    /* @description funcao que atualiza os campos e labels das datas de entrega do servico*/
    self.AtualizaCamposELabelEntrega = function (model) {
        KendoRetornaElemento($("#DataEntregaLonge")) != undefined ? KendoRetornaElemento($("#DataEntregaLonge")).value(model.DataEntregaLonge) : false;
        KendoRetornaElemento($("#DataEntregaPerto")) != undefined ? KendoRetornaElemento($("#DataEntregaPerto")).value(model.DataEntregaPerto) : false;

        $("#BoxLonge").val(model.BoxLonge);
        $("#BoxPerto").val(model.BoxPerto);

        self.AtualizaLabelEntrega();
    };

    /* @description funcao que atualiza as definicoes do servico */
    self.AtualizaCamposELabelDefinicao = function (model) {
        var result = $.grep(ModeloServico.Servicos, function (e) {
            return e.ID == self.GetServicoActivo();
        });

        self.AtualizaLabelDefinicao(model);

        self.ExisteMaisQueUmSubServico();

        self.AtualizaCamposELabelEntrega(result[0]);
    };

    self.ExisteMaisQueUmSubServico = function () {
        var servicosExistentes = ModeloServico.Servicos.filter(elem => elem.AcaoCRUD != constEstados.Remover);

        $.each(servicosExistentes, function (index, value) {
            var numSubServico = servicosExistentes.filter((elem, i) => elem.IDTipoServico == value.IDTipoServico && i <= index).length;
            var existeMaisQueUmSubservicoDoMesmoTipo = servicosExistentes.find((elem, i) => elem.IDTipoServico == value.IDTipoServico && i > index) != undefined;

            let servicoLi = document.getElementById('liServico' + value.ID);

            if (servicoLi != null) {
                var spanNum = servicoLi.getElementsByClassName('clsF3MNum');

                if (existeMaisQueUmSubservicoDoMesmoTipo || numSubServico > 1) {
                    var str1 = numSubServico + " - ";

                    if (spanNum.length > 0) {
                        spanNum[0].textContent = str1;
                    } else {
                        var liServicoDesc = servicoLi.getElementsByClassName('clsF3MliServico')[0];

                        var span = document.createElement('span');
                        span.classList.add('clsF3MNum');
                        span.textContent = str1;

                        liServicoDesc.prepend(span);
                    }
                } else {
                    if (spanNum.length > 0) {
                        spanNum[0].remove();
                    }
                }
            }
        });
    }

    /* @description funcao que atualiza mais definicoes do servico (med tec + receita) */
    self.AtualizaMaisDefinicoes = function (model) {
        self.ConfiguraDefinicoes("VerPrismas", model.VerPrismas);
        $("#VerPrismas").prop("checked", model.VerPrismas);

        self.ConfiguraDefinicoes("VisaoIntermedia", model.VisaoIntermedia);
        $("#VisaoIntermedia").prop("checked", model.VisaoIntermedia);

        KendoRetornaElemento($("#DataReceita")) != undefined ? KendoRetornaElemento($("#DataReceita")).value(model.DataReceita) : false;

        self.PreencheMedicoTecnico(model.IDMedicoTecnico, model.DescricaoMedicoTecnico);

        self.AtualizaLabelGraduacoes();
    };

    /* @description funcao que atualiza as a label entrega */
    self.AtualizaLabelEntrega = function () {
        var emptyText = resources.Entrega;

        if (KendoRetornaElemento($("#DataEntregaLonge")) != undefined) {
            var obj = ModeloServico.Servicos.filter(function (f) {
                return f.ID == self.GetServicoActivo();
            });
            self.TrataJSONDatas(obj);

            self.SetValorCampoObj(ModeloServico.Servicos, "DataEntregaLonge", KendoRetornaElemento($("#DataEntregaLonge"))._oldText, self.GetServicoActivo());
            self.SetValorCampoObj(ModeloServico.Servicos, "DataEntregaPerto", KendoRetornaElemento($("#DataEntregaPerto"))._oldText, self.GetServicoActivo());
            self.SetValorCampoObj(ModeloServico.Servicos, "BoxLonge", $("#BoxLonge").val(), self.GetServicoActivo());
            self.SetValorCampoObj(ModeloServico.Servicos, "BoxPerto", $("#BoxPerto").val(), self.GetServicoActivo());

            self.TrataDatasEntrega("DataEntregaLonge", "DataEntregaPerto", self.GetServicoActivo());

            if (obj[0].IDTipoServico == TipoServico.LongePerto) {
                $(".clsF3MTxtEntrega").text(resources.EntregaLonge + " " + KendoRetornaElemento($("#DataEntregaLonge"))._oldText + " // " + resources.EntregaPerto + " " + KendoRetornaElemento($("#DataEntregaPerto"))._oldText);
            } else if (obj[0].IDTipoServico == TipoServico.Longe) {
                $(".clsF3MTxtEntrega").text(resources.EntregaLonge + " " + KendoRetornaElemento($("#DataEntregaLonge"))._oldText);
            } else if (obj[0].IDTipoServico == TipoServico.Perto) {
                $(".clsF3MTxtEntrega").text(resources.EntregaPerto + " " + KendoRetornaElemento($("#DataEntregaPerto"))._oldText);
            } else {
                $(".clsF3MTxtEntrega").text(resources.Entrega + " " + KendoRetornaElemento($("#DataEntregaLonge"))._oldText);
            }
        }
        else {
            $(".clsF3MTxtEntrega").text(emptyText);
        }
    };

    /* @description funcao que atualiza as datas de entrega e box's */
    self.TrataDatasEntrega = function (campoDataLonge, campoDataPerto, IDServico) {
        let elemBoxPerto = $('#BoxPerto');
        let elemBoxLonge = $('#BoxLonge');
        let elemPertoAux = '';
        let elemLongeAux = '';

        let objServico = ModeloServico.Servicos.filter(function (f) {
            return f.ID == IDServico;
        })[0];

        switch (objServico.IDTipoServico) {
            case TipoServico.LongePerto:
                //DATAS
                $("#" + campoDataPerto).parents("div.divDataTempo").show();
                $("#" + campoDataLonge).parents("div.divDataTempo").show();

                $("label[for='" + campoDataPerto + "']").text(resources.DataEntregaPerto);
                $("label[for='" + campoDataLonge + "']").text(resources.DataEntregaLonge);

                KendoRetornaElemento($("#" + campoDataPerto)).value(objServico.DataEntregaPerto);
                KendoRetornaElemento($("#" + campoDataLonge)).value(objServico.DataEntregaLonge);
                //END DATAS

                //BOXs
                elemBoxPerto.parents("div.divCaixaTexto").show();
                elemBoxLonge.parents("div.divCaixaTexto").show();

                $("label[for='BoxPerto']").text(resources.BoxPerto);
                $("label[for='BoxLonge']").text(resources.BoxLonge);

                //END BOXs
                break;

            case TipoServico.Perto:
                //DATAS
                $("#" + campoDataPerto).parents("div.divDataTempo").show();
                $("#" + campoDataLonge).parents("div.divDataTempo").hide();

                $("label[for='" + campoDataPerto + "']").text(resources.DataEntPerto);

                KendoRetornaElemento($("#" + campoDataLonge)).value(null);
                KendoRetornaElemento($("#" + campoDataPerto)).value(objServico.DataEntregaPerto);
                //END DATAS

                //BOXs
                elemBoxPerto.parents("div.divCaixaTexto").show();
                elemBoxLonge.parents("div.divCaixaTexto").hide();

                $("label[for='BoxPerto']").text(resources.BoxPerto);

                elemBoxLonge.val('');
                //END BOXs
                break;

            case TipoServico.Longe:
                //DATAS
                $("#" + campoDataPerto).parents("div.divDataTempo").hide();
                $("#" + campoDataLonge).parents("div.divDataTempo").show();

                $("label[for='" + campoDataLonge + "']").text(resources.DataEntLonge);

                KendoRetornaElemento($("#" + campoDataPerto)).value(null);
                KendoRetornaElemento($("#" + campoDataLonge)).value(objServico.DataEntregaLonge);
                //END DATAS

                //BOXs
                elemBoxPerto.parents("div.divCaixaTexto").hide();
                elemBoxLonge.parents("div.divCaixaTexto").show();

                $("label[for='BoxLonge']").text(resources.BoxLonge);


                elemBoxPerto.val('');
                //END BOXs
                break;

            default:
                //DATAS
                $("#" + campoDataPerto).parents("div.divDataTempo").hide();
                $("#" + campoDataLonge).parents("div.divDataTempo").show();

                $("label[for='" + campoDataLonge + "']").text(resources.DataEntrega);

                KendoRetornaElemento($("#" + campoDataPerto)).value(null);
                KendoRetornaElemento($("#" + campoDataLonge)).value(objServico.DataEntregaLonge);
                //END DATAS

                //BOXs
                elemBoxPerto.parents("div.divCaixaTexto").hide();
                elemBoxLonge.parents("div.divCaixaTexto").show();

                $("label[for='BoxLonge']").text(resources.Box);

                elemBoxPerto.val('');
                //END BOXs
                break;
        }
    };

    /* @description funcao que trata as datas de entrega e receita */
    self.TrataJSONDatas = function (obj) {
        var datReceita = obj.DataReceita;
        datReceita != null && datReceita.toLowerCase().indexOf("/date") >= 0 ? obj.DataReceita = UtilsConverteJSONDate(datReceita, constJSONDates.ConvertToDDMMAAAA) : false;

        var datEntregaLonge = obj.DataEntregaLonge;
        datEntregaLonge != null && datEntregaLonge.toLowerCase().indexOf("/date") >= 0 ? obj.DataEntregaLonge = UtilsConverteJSONDate(datEntregaLonge, constJSONDates.ConvertToDDMMAAAAHHmmSS) : false;

        var datEntregaPerto = obj.DataEntregaPerto;
        datEntregaPerto != null && datEntregaPerto.toLowerCase().indexOf("/date") >= 0 ? obj.DataEntregaPerto = UtilsConverteJSONDate(datEntregaPerto, constJSONDates.ConvertToDDMMAAAAHHmmSS) : false;
    };

    //------------------------------------ G R A D U A C O E S
    /* @description funcao que retorna se e' oculos ou lentes de contacto */
    self.RetornaTipoOculosSelecionado = function () {
        return $("#ServicoO").parent().hasClass('active') ? true : false;
    };

    /* @description funcao que  preenche as graduacoes pelo modelo */
    self.PreencheGraduacoes = function (hdsn, ColEditorRow, data) {
        var tr = $("tr.Tab" + hdsn.rootElement.id.replace("hdsn", ""));
        var selector = clsTOD;
        if (ColEditorRow == 1) {
            selector = clsTOE;
        }
        var IDTipoGraduacao = hdsn.getSourceDataAtRow(hdsn.getSelected()[0][0]).IDTipoGraduacao;
        if (IDTipoGraduacao == 4) { // LCs

            $(tr).find(selector + ".RaioCurvatura").val(data.RaioCurvatura);
            $(tr).find(selector + ".DetalheRaio").val(data.DetalheRaio);
            $(tr).find(selector + ".PotenciaEsferica").val(data.PotenciaEsferica);
            $(tr).find(selector + ".PotenciaCilindrica").val(data.PotenciaCilindrica);
            $(tr).find(selector + ".Eixo").val(data.Eixo);
            $(tr).find(selector + ".Adicao").val(data.Adicao);

            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "RaioCurvatura", data.RaioCurvatura);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "DetalheRaio", data.DetalheRaio);

            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "PotenciaEsferica", data.PotenciaEsferica);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "PotenciaCilindrica", data.PotenciaCilindrica);

            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "Eixo", data.Eixo);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "Adicao", data.Adicao);

        }
        else {
            $(tr).find(selector + ".PotenciaEsferica").val(data.PotenciaEsferica);
            $(tr).find(selector + ".PotenciaCilindrica").val(data.PotenciaCilindrica);
            $(tr).find(selector + ".PotenciaPrismatica").val(data.PotenciaPrismatica);
            $(tr).find(selector + ".Adicao").val(data.Adicao);

            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "PotenciaEsferica", data.PotenciaEsferica);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "PotenciaCilindrica", data.PotenciaCilindrica);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "PotenciaPrismatica", data.PotenciaPrismatica);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, ColEditorRow + 1, IDTipoGraduacao, "Adicao", data.Adicao);
        }
    };

    /* @description funcao que  atualiza as graducoes de um determinado servico */
    self.AtualizaObjGraduacoes = function (Obj, IDTipoOlho, IDTipoGraduacao, IDCampo, Value) {
        var getIDServicoAtivo = self.GetServicoActivo();
        var result = $.grep(Obj, function (e) {
            return e.ID == getIDServicoAtivo;
        });

        if (result.length) {
            var result2 = $.grep(result[0].DocumentosVendasLinhasGraduacoes, function (e) {
                return e.IDTipoOlho == IDTipoOlho && e.IDTipoGraduacao == IDTipoGraduacao;
            });

            if (IDCampo === "DetalheRaio") {
                result2[0][IDCampo] = Value;
            }
            else if (IDCampo === "RaioCurvatura" ) {
                result2[0][IDCampo] = Value;
                if ($.isNumeric(result2[0][IDCampo])) {
                    result2[0][IDCampo] = parseFloat(Value).toFixed(2);
                    if (IDTipoOlho === TipoOlho.Direito) {
                        $('.TabLentes .TabOlhoDireito.RaioCurvatura').val(parseFloat(Value).toFixed(2));
                    }
                    else {
                        $('.TabLentes .TabOlhoEsquerdo.RaioCurvatura').val(parseFloat(Value).toFixed(2));
                    }
                }
            }
            else if ($.isNumeric(result2[0][IDCampo])) {
                result2[0][IDCampo] = parseFloat(Value);
            }
            else if ($.isNumeric(Value)) {
                result2[0][IDCampo] = parseFloat(Value);
            }
            else {
                result2[0][IDCampo] = Value;
            }
        }

        self.AtivaDirty();
    };

    /* @description funcao quando e' escolhido o tipo lentes de contacto  */
    self.SetLC = function () {
        var servico = self.SubServicoRetorna(self.GetServicoActivo());
        $("#TipoDeLente").val("LC");

        $(tblOculos).hide();
        $(tblLentes).show();
        $(divHdsnLP).hide();
        $(divHdsnL).show();
        $("#BoxLonge").closest(".row").hide();
        $("#BoxPerto").closest(".row").hide();
        // Mostra label do botao adicionar
        $('#ServicosBtAdd .label-btn-acoes').remove();
        $('#ServicosBtAdd').append('<div class="label-btn-acoes AddLentesContacto"> <span>' + resources.Adicionar + '</span><br><span>' + 'SubServiço' + '</span></div>');

        self.SetValorCampoObj(ModeloServico.Servicos, "IDTipoServico", TipoServico.Contacto, self.GetServicoActivo());

        if (!$(hdsnLentes).hasClass("handsontable")) {
            self.InitHandsonTableModeloVazio(constHdsnLentes, null, 102);
        }
        else {
            var dataLC = $.grep(servico[0].DocumentosVendasLinhas, function (data) {
                return data.IDTipoGraduacao == 4;
            });

            var hdsn = window.HotRegisterer.bucket[constHdsnLentes];
            hdsn.loadData(dataLC);
        }

        self.AtualizaLabelEntrega();
    };

    /* @description funcao quando e' escolhido o tipo oculos */
    self.SetO = function () {
        $("#TipoDeLente").val("LO");

        $(tblLentes).hide();
        $(tblOculos).show();
        $(divHdsnL).hide();
        $(divHdsnLP).show();     

        $("#BoxLonge").closest(".row").show();
        $("#BoxPerto").closest(".row").show();
        // Mostra label do botao adicionar
        $('#ServicosBtAdd .label-btn-acoes').remove();
        $('#ServicosBtAdd').append('<div class=label-btn-acoes> <span>' + resources.Adicionar + '</span><br><span>' + 'SubServiço' + '</span></div>');

        var result = $.grep(ModeloServico.Servicos, function (e) {
            return e.ID === self.GetServicoActivo();
        });

        if (result[0].IDTipoServico === TipoServico.Longe) {

            $("#containerLonge").css("display", "block");
            $("#containerPerto").css("display", "none");
            $(clsTabLonge).show();
            $(clsTabPerto).hide();
            $('.LblPerto').addClass('invisible');

        } else if (result[0].IDTipoServico === TipoServico.Perto) {

            $(clsTabLonge).hide();
            $(clsTabPerto).show();
            $("#containerLonge").css("display", "none");
            $("#containerPerto").css("display", "block");
            $('.LblPerto').removeClass('invisible');

        } else if (result[0].IDTipoServico === TipoServico.LongePerto) {

            $(clsTabLonge).show();
            $(clsTabPerto).show();
            $('.LblPerto').addClass('invisible');
            $("#containerLonge").css("display", "block");
            $("#containerPerto").css("display", "block");

        } else {

            $("#containerLonge").css("display", "block");
            $("#containerPerto").css("display", "none");
            $('.LblPerto').addClass('invisible');
        }

        if (!$(hdsnPerto).hasClass("handsontable")) {
            self.InitHandsonTableModeloVazio(constHdsnLonge, constHdsnPerto);
        }
        else {
            self.HandsonTableStretchHTHeightAndRender(constHdsnLonge);
            self.HandsonTableStretchHTHeightAndRender(constHdsnPerto);
        }

        self.AtualizaLabelEntrega();
    };


    /* @description funcao do evento clique transposicao*/
    self.CalculaTransposicao = function (inputESF, inputCIL, inputAX) {
        inputESF.val(parseFloat(inputESF.val()) + parseFloat(inputCIL.val()));
        self.AtualizaTransposicao(inputESF);

        inputCIL.val(parseFloat(inputCIL.val()) - parseFloat(inputCIL.val()) * 2);
        self.AtualizaTransposicao(inputCIL);

        inputAX.val(parseInt(inputAX.val()) + 90 > 180 ? parseFloat(inputAX.val()) + 90 - 180 : parseInt(inputAX.val()) + 90);
        self.AtualizaTransposicao(inputAX);
    };

    /* @description funcao quando e' piscada ou nao a opcao VerPrismas   */
    self.ConfiguraDefinicoes = function (chkID, checked) {
        var tbl = $("#tblOculos table");
        var rows = tbl.find("tr");

        if (chkID === "VerPrismas") {
            if (checked) {
                rows.find(".PotenciaPrismatica").parent().show();
                rows.find(".BasePrismatica").parent().show();
                $(".input-dioptria").addClass("com-prismas");
            } else {
                rows.find(".PotenciaPrismatica").parent().hide();
                rows.find(".BasePrismatica").parent().hide();
                $(".input-dioptria").removeClass("com-prismas");
            }
        } else {
            var tr = $(tbl).find("td span.tab-span-intermedio").closest("tr");
            checked ? tr.show() : tr.hide();
        }
    };

    /* @description funcao que atualiza as graduacoes pela transposicao*/
    self.AtualizaTransposicao = function (elem) {
        if (elem.hasClass("input-dioptria")) {
            var getOlho = elem[0].className.split(" ")[1]; // DIREITO || ESQUERDO
            var IDTipoOlho = getOlho == campoTabOD ? TipoOlho.Direito : TipoOlho.Esquerdo; // 1 || 2

            var getTab = elem[0].parentElement.parentElement.className.split(" ")[0]; //LONGE || INTERMEDIO ||  PERTO

            var IDTipoGraduacao;
            switch (getTab) {
                case campoTabLonge:
                    IDTipoGraduacao = TipoGraduacao.Longe;
                    break;
                case campoTabPerto:
                    IDTipoGraduacao = TipoGraduacao.Perto;
                    break;
                case campoTabInt:
                    IDTipoGraduacao = TipoGraduacao.Intermedio;
                    break;
                case campoTabLentes:
                    IDTipoGraduacao = TipoGraduacao.LentesContato;
                    break;
            }
            var Campo = elem[0].className.split(" ")[2];

            self.AtualizaObjGraduacoes(ModeloServico.Servicos, IDTipoOlho, IDTipoGraduacao, Campo, parseFloat(elem.val()));
        }
    };

    /* @description funcao que atualiza as a label + definicoes */
    self.AtualizaLabelDefinicao = function (model) {
        var textDef;
        if (!model.DescricaoServico) {
            if (self.RetornaTipoOculosSelecionado()) {
                let text = $("input[name='TipoServico']:checked").parent().text();
                let textDesc = $("input[name='TipoServicoOlho']:checked").parent().text();

                let span = document.createElement('span');
                span.classList.add('smallText');
                span.textContent = textDesc;

                $("#ulServicos li.active .clsF3MliServico").text(text).append(span);

                textDef = text + "," + textDesc;
            } else {
                textDef = resources.LentesContacto;
                $("#ulServicos li.active .clsF3MliServico").text(textDef);
            }

            self.SetValorCampoObj(ModeloServico.Servicos, "DescricaoServico", textDef, self.GetServicoActivo());

        } 
        self.AtualizaTituloColuna();
    };

    /* @description funcao que atualiza as a label graduacoes */
    self.AtualizaLabelGraduacoes = function () {
        var res = "";
        var dat = KendoRetornaElemento($("#DataReceita"))._oldText;
        var med = self.GetValorCampoObj("DescricaoMedicoTecnico", self.GetServicoActivo());

        if (dat !== null && dat.indexOf('/Date') != -1) {
            dat = UtilsConverteJSONDate(dat, constJSONDates.ConvertToDDMMAAAA);
        }

        if (med !== null && med.length) {
            res = res + " " + med;
        }

        if (dat !== null && dat.length) {
            res = res + (res.length > 0 ? "," : "") + " rec. " + dat;
        }

        res = res === "" ? $("#strMaisDefinicoes").val() : res;
        $(spnConfigGraduacoes).text(res);
    };

    //------------------------------------ M E D I C O     T E' C N I C O
    /* @description funcao envia parametros do medico tecnico */
    self.MedicoTecnicoEnviaParametros = function (objFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objFiltro, true, 'Ativo', '', true);
        return objFiltro;
    };

    /* @description funcao change do medico tecnico */
    self.MedicoTecnicoChange = function (inComboMedTec) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(inComboMedTec) && inComboMedTec.value() !== '') {
            self.SetValorCampoObj(ModeloServico.Servicos, "IDMedicoTecnico", inComboMedTec.dataItem().ID, self.GetServicoActivo());
            self.SetValorCampoObj(ModeloServico.Servicos, "DescricaoMedicoTecnico", inComboMedTec.dataItem().Nome, self.GetServicoActivo());
        }
        else {
            self.SetValorCampoObj(ModeloServico.Servicos, "IDMedicoTecnico", null, self.GetServicoActivo());
            self.SetValorCampoObj(ModeloServico.Servicos, "DescricaoMedicoTecnico", null, self.GetServicoActivo());
        }
    };

    /* @description funcao que preenche os dados do medico tecnico */
    self.PreencheMedicoTecnico = function (idMedicoTecnico, nomeMedicoTecnico) {
        var elemMedTec = KendoRetornaElemento($("#IDMedicoTecnico"));

        if (elemMedTec) {
            elemMedTec.text(nomeMedicoTecnico);
            $($(elemMedTec.element).parent().find('.clsF3MInput:last')[0]).attr('value', idMedicoTecnico);
            elemMedTec.value(idMedicoTecnico);
            ComboBoxAtivaDesativaDrillDown(['IDMedicoTecnico']);

            elemMedTec.dataSource.read().then(function () {
                elemMedTec.value(idMedicoTecnico);
                elemMedTec.text(nomeMedicoTecnico);
            });
        }
    };

    //------------------------------------ H A N D S O N T A B L E     S E R V I C O S || A R T I G O S
    /* @description funcao que retorna a handson selecionada */
    self.RetornaSelectedHT = function () {
        return selectedHT;
    };

    /* @description funcao que atualiza handson selecionada */
    self.SetSelectedHT = function (inHdsn, inIndexLinha, inIndexCol) {
        selectedHT = inHdsn;

        var colunaAtual = inHdsn.getSettings().columns[inIndexCol];
        colunaAtual[constColHT.F3MControlador] = inHdsn.getCellMeta(inIndexLinha, inIndexCol).Controlador;
        colunaAtual[constColHT.F3MControladorExtra] = inHdsn.getCellMeta(inIndexLinha, inIndexCol).ControladorExtra;

        return inHdsn;
    };

    /* @description funcao que desenha as handsons  nas tabs servicos e artigos */
    self.InitHandsonTable = function (inHdsn, data, altura, arrMergeCells, boolDisableContextMenu, boolAddNewLines) {
        var inDadosHT = self.RetornaColunasHT();
        if (inDadosHT !== undefined && inDadosHT.data !== null) {

            var numberOfFixedColumns = 3;
            if (constIsMobile === true) { numberOfFixedColumns = 0; }

            boolAddNewLines = DisableViaEstado ? false : boolAddNewLines;

            var hdsn = HandsonTableDesenhaNovo(inHdsn, data, altura, inDadosHT, boolAddNewLines, null, null, true, numberOfFixedColumns, null, false, null, null, ListaColunasIgnoraBloqueioAssinatura);
            hdsn.updateSettings({
                readOnly: DisableViaEstado,
                mergeCells: arrMergeCells,
                rowHeaders: function (index) {
                    var rowHead = "";
                    switch (hdsn.getSourceDataAtRow(index).IDTipoOlho) {
                        case TipoOlho.Direito:
                            rowHead = resources.OD;
                            break;
                        case TipoOlho.Aro:
                            rowHead = resources.Aro;
                            break;
                        case TipoOlho.Esquerdo:
                            rowHead = resources.OE;
                            break;
                    }
                    return rowHead;
                },
                beforeOnCellMouseDown: function (e, coords, td) {
                    if (coords.row != -1) {
                        selectedHT = hdsn;
                    }
                },
                afterChange: function (changes, source) {
                    if (source === constSourceHT.LoadData || source === constSourceHT.PopulateFromArray) { return; }

                    var ColEditor = hdsn.getActiveEditor();
                    var ColEditorProp = ColEditor != undefined ? ColEditor.prop : null;
                    var ColEditorOpened = ColEditor != undefined ? ColEditor._opened : null;
                    var ColEditorRow = ColEditor != undefined ? ColEditor.row : null;
                    var ColEditorCol = ColEditor != undefined ? ColEditor.col : null;

                    if (changes[0][1] === "Diametro") {
                        var diam = changes[0][3];
                        if ($.isNumeric(diam)) {
                            if (diam < 20) {
                                diam = parseFloat(diam).toFixed(2);
                                hdsn.getSourceDataAtRow(changes[0][0]).Diametro = diam;
                            }
                        }
                    }

                    if (source === constSourceHT.Edit && self.DeveCalcular(changes, hdsn, ColEditorProp)) {

                        self.Calcula(changes, hdsn, ColEditorProp, false, null, changes[0][2]);
                    } else if ((source == constSourceHT.Edit || source === constSourceHT.Paste) && (changes[0][1] === "CodigoArtigo" || changes[0][1] === "Campanha")) {
                        var bool = false;
                        if (isTRIGGER_CLICK_TIPO2 === true) {
                            ColEditor = null;
                            bool = true;
                        }
                        self.CamposPreencher(hdsn, changes, ColEditorRow, ColEditorCol);
                        self.Calcula(changes, hdsn, ColEditor, bool, null, null);
                    }
                    else {
                        self.AtivaDirty();
                    }
                },
                manualRowResize: false,
                columnSorting: false,
                sortIndicator: false,
                contextMenu: self.RetornaContextMenuHT(hdsn, boolDisableContextMenu),
                afterCreateRow: function (index, amount) {
                    if (!isLOAD_DATA) {
                        var newIndex = index;

                        if (hdsn.getSelected() != undefined) {
                            if (hdsn.getSelected()[0][0] == hdsn.countVisibleRows() - 1) {
                                newIndex = index - 1;
                            }
                        }
                        self.AdicionaDiversos(newIndex, hdsn);
                    }
                    isLOAD_DATA = false;
                },
                beforeRemoveRow: function (index, amount) {
                    self.RemoveDiversos(index, amount, hdsn);
                },
                afterRemoveRow: function () {
                    hdsn.render();
                    self.HandsonTableStretchHTHeightAndRender(inHdsn);
                },
                afterLoadData: function () {
                    isLOAD_DATA = false;
                    self.ConfigControladoresLookUps(hdsn);
                },
                rowHeaderWidth: [50],
                fillHandle: false,
                beforeChange: function (changes, source) {
                    if (source === constSourceHT.LoadData || source === constSourceHT.PopulateFromArray) { return; }

                    var nomeColuna = changes[0][1];
                    var valorCel = changes[0][3];
                    var linhaAtualDS = this.getSourceDataAtRow(changes[0][0]);

                    if (nomeColuna === 'CodigoArtigo') {
                        var elemDS = HandsonTableVarGridHTF4DS();
                        if (elemDS.length) {
                            linhaAtualDS['CodigoArtigo'] = elemDS[0][campoCod];
                            linhaAtualDS['IDArtigo'] = elemDS[0][campoID];
                            changes[0][3] = elemDS[0][campoCod];
                            this.getActiveEditor().cellProperties.valid = true; //retirar o erro
                        }
                    }
                    let ColEditor = this.getActiveEditor();
                    if (changes[0][3] === '' && ColEditor.cellProperties.type === 'numeric') {
                        changes[0][3] = 0;
                    }
                }
            });
            self.ConfigControladoresLookUps(hdsn);
        }
    };

    /* @description funcao que retorna as colunas das handsons Longe / Perto / LCs / Artigos*/
    self.RetornaColunasHT = function () {
        var moedaRefEmpresa = $("#SimboloMoedaRefEmpresa").val();
        var moedaRefCliente = $("#SimboloMoedaRefCliente").val();
        var casasDecTotais = $("#" + campoCasasDecTot).val();
        var casasDecPrecosUni = $("#" + campoCasasDecPU).val();

        var _ListaCamposPreencher = [
            { "Coluna": campoDesc, "Campo": campoDesc },
            { "Coluna": "IDArtigo", "Campo": campoID },
            { "Coluna": "IDMarca", "Campo": "IDMarca" },
            { "Coluna": "IDModelo", "Campo": "IDModelo" },
            { "Coluna": "IDTratamentoLente", "Campo": "IDTratamentoLente" },
            { "Coluna": "IDCorLente", "Campo": "IDCorLente" },
            { "Coluna": "Diametro", "Campo": "Diametro" },
            { "Coluna": "PrecoUnitario", "Campo": "ValorComIva" },
            { "Coluna": "IDTaxaIva", "Campo": "IDTaxa" },
            { "Coluna": campoTaxaIVA, "Campo": "Taxa" },
            { "Coluna": "TotalFinal", "Campo": "ValorComIva" },
            { "Coluna": "MotivoIsencaoIva", "Campo": "MotivoIsencaoIva" },
            { "Coluna": "CodigoTaxaIva", "Campo": "CodigoTaxaIva" },
            { "Coluna": "CodigoArtigo", "Campo": "CodigoArtigo" },
            { "Coluna": "CodigoBarrasArtigo", "Campo": "CodigoBarrasArtigo" },
            { "Coluna": "CodigoUnidade", "Campo": "CodigoUnidade" },
            { "Coluna": "CodigoTipoIva", "Campo": "CodigoSistemaTipoIva" },
            { "Coluna": "CodigoRegiaoIva", "Campo": "CodigoRegiaoIVA" },
            { "Coluna": "IDUnidade", "Campo": "IDUnidade" },
            { "Coluna": "NumCasasDecUnidade", "Campo": "NumCasasDecUnidade" },
            { "Coluna": "IDTipoLente", "Campo": "IDTipoLente" },
            { "Coluna": "IDMateria", "Campo": "IDMateriaLente" },
            { "Coluna": "IDsSuplementos", "Campo": "IDsSuplementos" },
            { "Coluna": "IndiceRefracao", "Campo": "IndiceRefracao" },
            { "Coluna": "Fotocromatica", "Campo": "Fotocromatica" }
        ];

        var columns = [
            {
                ID: "Diametro",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: "Ø",
                renderer: "html",
                readOnly: DisableViaEstado || true,
                className: "htRight",
                invalidCellClassName: "",
                width: 50
            }, {
                ID: "CodigoArtigo",
                TipoEditor: constTipoCompoHT.F3MLookup,
                Label: resources["Artigo"],
                width: 110,
                Controlador: rootDir + "/DocumentosVendasServicos/ListaArtigosComboCodigo",
                ControladorExtra: rootDir + "/Artigos/Artigos/IndexGrelha",
                ListaCamposPreencher: _ListaCamposPreencher,
                readOnly: DisableViaEstado || false,
                CampoTexto: "Codigo",
                invalidCellClassName: "",
                FuncaoEnviaParams: function (objetoFiltro, hdsn) {
                    return self.EnviaParametrosArtigos(objetoFiltro, hdsn);
                }
            }, {
                ID: campoDesc,
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources[campoDesc],
                width: 300,
                readOnly: DisableViaEstado || false
            }, {
                ID: "Campanha",
                Label: resources["Campanha"],
                TipoEditor: constTipoCompoHT.F3MLookup,
                ListaCamposPreencher: [{ "Coluna": "IDCampanha", "Campo": "ID" }],
                width: 100,
                Controlador: rootDir + "/TabelasAuxiliares/Campanhas",
                readOnly: true
            }, {
                ID: "Quantidade",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["Qtd"],
                width: 40,
                readOnly: DisableViaEstado || true
            }, {
                ID: "PrecoUnitario",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDPrecoUnitario"],
                CasasDecimais: casasDecPrecosUni,
                readOnly: DisableViaEstado || true
            }, {
                ID: "Desconto1",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["PercentagemDesconto"],
                CasasDecimais: 2,
                readOnly: DisableViaEstado || true
            }, {
                ID: "ValorDescontoLinha",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDVDescLin"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }, {
                ID: "TotalComDescontoLinha",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDTotalComDesconto"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }, {
                ID: "ValorDescontoCabecalho",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDVDescCab"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }, {
                ID: "TotalComDescontoCabecalho",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDTotalComDescontoCabecalho"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }, {
                ID: "PrecoUnitarioEfetivo",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDPrecoUnitarioEfetivo"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }, {
                ID: "ValorUnitarioEntidade1",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDValorUnitarioEntidade1"],
                CasasDecimais: casasDecPrecosUni,
                readOnly: DisableViaEstado || true
            }, {
                ID: "ValorEntidade1",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDVComp1"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }, {
                ID: "ValorUnitarioEntidade2",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDValorUnitarioEntidade2"],
                CasasDecimais: casasDecPrecosUni,
                readOnly: DisableViaEstado || true
            }, {
                ID: "ValorEntidade2",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDVComp2"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }, {
                ID: "TotalFinal",
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources["MDTotalFinal"],
                CasasDecimais: casasDecTotais,
                readOnly: DisableViaEstado || true
            }];

        return $.grep(columns, function (Obj, i) {
            return Obj.Label = Obj.Label.replace(moedaRefEmpresa, moedaRefCliente);
        });
    };

    /* @description funcao que retorna o context menu da hansdon */
    self.RetornaContextMenuHT = function (gridHT, boolDisableContextMenu) {
        return DisableViaEstado ? false : {
            items: {
                "row_above": {
                    name: resources["AdicionarLinhaCima"],
                    disabled: function () {
                        return gridHT.getDataAtRowProp(gridHT.getSelected()[0][0], "IDTipoOlho") !== TipoOlho.Diversos;
                    }
                },
                "row_below": {
                    name: resources["AdicionarLinhaBaixo"],
                    disabled: function () {
                        return gridHT.getDataAtRowProp(gridHT.getSelected()[0][0], "IDTipoOlho") !== TipoOlho.Diversos;
                    }
                },
                "hsep1": constTipoCompoHT.F3MSeparadorContextMenu,
                "replicarLinhaCima": {
                    name: resources["ReplicarLinhaParaCima"],
                    disabled: function () {
                        return boolDisableContextMenu ? true : self.DisableReplicarLinhaCima(gridHT);
                    },
                    callback: function (key, options) {
                        self.ReplicarLinhaCima(key, options, gridHT);
                    }
                },
                "replicarLinhaBaixo": {
                    name: resources["ReplicarLinhaParaBaixo"],
                    disabled: function () {
                        return boolDisableContextMenu ? true : self.DisableReplicarLinhaBaixo(gridHT);
                    },
                    callback: function (key, options) {
                        self.ReplicarLinhaBaixo(key, options, gridHT);
                    }
                },
                "hsep2": constTipoCompoHT.F3MSeparadorContextMenu,
                "limparLinha": {
                    name: resources["LimparLinha"],
                    disabled: function () {
                        return boolDisableContextMenu ? true : false;
                    },
                    callback: function (key, options) {
                        self.LimparLinha(gridHT, options[0].start.row, false);
                    }
                },
                "limparTudo": {
                    name: resources["LimparTudo"],
                    disabled: function () {
                        return boolDisableContextMenu ? true : false;
                    },
                    callback: function (key, options) {
                        self.LimparGridHT(gridHT);
                    }
                },
                "hsep3": constTipoCompoHT.F3MSeparadorContextMenu,
                "remove_row": {
                    name: resources["RemoverLinhaHT"],
                    disabled: function () {
                        return gridHT.getDataAtRowProp(gridHT.getSelected()[0][0], "IDTipoOlho") !== TipoOlho.Diversos;
                    },
                    callback: function (key, options) {
                        gridHT.alter("remove_row", options[0].start.row);
                        self.Calcula(null, window.HotRegisterer.bucket[constHdsnArtigos], null, true, KendoRetornaElemento($("#TotalMoedaDocumento")), null);
                    }
                }
            }
        };
    };

    /* @description funcao que executa a funcao generica HandsonTableStretchHTHeight e faz tambem o render da hansdon */
    self.HandsonTableStretchHTHeightAndRender = function (inHdsnID) {
        var hdsn = HotRegisterer.getInstance(inHdsnID);

        if (UtilsVerificaObjetoNotNullUndefinedVazio(hdsn)) {
            hdsn.render();

            if (UtilsVerificaObjetoNotNullUndefinedVazio($('#' + inHdsnID).find('.ht_master .wtHider').css('height'))) {
                var value = parseInt($('#' + inHdsnID).find('.ht_master .wtHider').css('height').replace('px', '')) + 10;
                hdsn.updateSettings({ height: value });
            }
        }
    };

    /* @description  funcao que  atualiza o titulo da coluna || -1 || da handsontable (hdsnPerto || hdsnLonge) e a label dos totais (LONGE || PERTO || BIFOC. || PROG.)  */
    self.AtualizaTituloColuna = function () {
        var htmlLonge = htmlSpanTags;
        var htmlPerto = htmlSpanTags;

        var obj = ModeloServico.Servicos.filter(function (f) {
            return f.ID == self.GetServicoActivo();
        });

        switch (obj[0].IDTipoServico) {
            case TipoServico.LongePerto:
                htmlLonge = '<span class=titulocolunaHT>' + resources.Longe + '</span>';
                htmlPerto = '<span class=titulocolunaHT>' + resources.Perto + '</span>';

                $('#lblLonge').text(resources.Longe);
                break;

            case TipoServico.Longe:
                htmlLonge = '<span class=titulocolunaHT>' + resources.Longe + '</span>';
                htmlPerto = htmlSpanTags;

                $('#lblLonge').text(resources.Longe);
                break;

            case TipoServico.Perto:
                htmlLonge = htmlSpanTags;
                htmlPerto = '<span class=titulocolunaHT>' + resources.Perto + '</span>';

                break;

            case TipoServico.BifocalAmbos:
            case TipoServico.BifocalOlhoDireito:
            case TipoServico.BifocalOlhoEsquerdo:
                htmlLonge = '<span class=titulocolunaHT>' + resources.Bifoc + '</span>';
                htmlPerto = htmlSpanTags;

                $('#lblLonge').text(resources.Bifoc);
                break;

            case TipoServico.ProgressivaAmbos:
            case TipoServico.ProgressivaOlhoDireito:
            case TipoServico.ProgressivaOlhoEsquerdo:

                htmlLonge = '<span class=titulocolunaHT>' + resources.Progr + '</span>';
                htmlPerto = htmlSpanTags;

                $('#lblLonge').text(resources.Progr);
                break;
        }

        var hdsnLonge = window.HotRegisterer.bucket[constHdsnLonge];
        if (UtilsVerificaObjetoNotNullUndefinedVazio(hdsnLonge)) {
            hdsnLonge.updateSettings({
                afterGetColHeader: function (col, TH) {
                    if (col < 0) {
                        TH.innerHTML = htmlLonge;
                    }
                    HandsonTableAlinhaTituloDasColunas(hdsnLonge, col, TH);
                }
            });
        }

        var hdsnPerto = window.HotRegisterer.bucket[constHdsnPerto];
        if (UtilsVerificaObjetoNotNullUndefinedVazio(hdsnPerto)) {
            hdsnPerto.updateSettings({
                afterGetColHeader: function (col, TH) {
                    if (col < 0) {
                        TH.innerHTML = htmlPerto;
                    }
                    HandsonTableAlinhaTituloDasColunas(hdsnPerto, col, TH);
                }
            });
        }
    };

    /* @description funcao atualiza as casas decimais e o simbolo nas handson e nos hiddens */
    self.ConfiguraColunasMoedaBase = function (novoSimboloMoeda, inCasasDecTotais, inCasasDecPrecoUni, inCasasDecIVA, arrHdsn) {
        if ($("#SimboloMoedaRefCliente").length > 0) {
            var atualSimboloMoeda = $("#SimboloMoedaRefCliente").val();

            var newHeaders = $.map(ServicosRetornaColunasHT(), function (Obj, i) {
                return Obj.Label.replace(atualSimboloMoeda, novoSimboloMoeda);
            });

            if (UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnLonge])) {
                window.HotRegisterer.bucket.hdsnLonge.updateSettings({
                    colHeaders: newHeaders,
                    cells: function (row, col, prop) {
                        return self.SetCasasDecimais(row, col, prop, inCasasDecTotais, inCasasDecPrecoUni);
                    }
                });
                self.ConfigControladoresLookUps(window.HotRegisterer.bucket[constHdsnLonge]);
                UtilsVerificaObjetoNotNullUndefinedVazio(arrHdsn) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnLonge]) : false;
            }

            if (UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnPerto])) {
                window.HotRegisterer.bucket.hdsnPerto.updateSettings({
                    colHeaders: newHeaders,
                    cells: function (row, col, prop) {
                        return self.SetCasasDecimais(row, col, prop, inCasasDecTotais, inCasasDecPrecoUni);
                    }
                });
                self.ConfigControladoresLookUps(window.HotRegisterer.bucket[constHdsnPerto]);
                UtilsVerificaObjetoNotNullUndefinedVazio(arrHdsn) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnPerto]) : false;
            }

            if (UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnLentes])) {
                window.HotRegisterer.bucket.hdsnLentes.updateSettings({
                    colHeaders: newHeaders,
                    cells: function (row, col, prop) {
                        return self.SetCasasDecimais(row, col, prop, inCasasDecTotais, inCasasDecPrecoUni);
                    }
                });
                self.ConfigControladoresLookUps(window.HotRegisterer.bucket[constHdsnLentes]);
                UtilsVerificaObjetoNotNullUndefinedVazio(arrHdsn) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnLentes]) : false;
            }

            if (UtilsVerificaObjetoNotNullUndefinedVazio(window.HotRegisterer.bucket[constHdsnArtigos])) {
                window.HotRegisterer.bucket[constHdsnArtigos].updateSettings({
                    colHeaders: newHeaders,
                    cells: function (row, col, prop) {
                        return self.SetCasasDecimais(row, col, prop, inCasasDecTotais, inCasasDecPrecoUni);
                    }
                });
                self.ConfigControladoresLookUps(window.HotRegisterer.bucket[constHdsnArtigos]);
                UtilsVerificaObjetoNotNullUndefinedVazio(arrHdsn) ? arrHdsn.push(window.HotRegisterer.bucket[constHdsnArtigos]) : false;
            }

            var newHeadersIva = $.map(self.RetornaColunasIncidencias(), function (Obj, i) {
                return Obj.Label.replace(atualSimboloMoeda, novoSimboloMoeda);
            });

            if (window.HotRegisterer.bucket['hdsnIncidencias'] != undefined) {
                window.HotRegisterer.bucket['hdsnIncidencias'].updateSettings({
                    colHeaders: newHeadersIva,
                    cells: function (row, col, prop) {
                        return self.SetCasasDecimais(row, col, prop, inCasasDecTotais, inCasasDecPrecoUni);
                    }
                });

                //self.ConfigReadOnlyColunasHT(window.HotRegisterer.bucket['hdsnIncidencias']);
                window.HotRegisterer.bucket['hdsnIncidencias'].render();
            }

            //ALTERA O STEP E O FORMAT DOS NUMERIC TEXT BOX PARA A MOEDA ATUAL
            KendoNumericChangeDecimals('TotalMoedaDocumento', inCasasDecTotais);
            KendoNumericChangeDecimals('ValorDesconto', inCasasDecTotais);
            KendoNumericChangeDecimals('TotalPontos', inCasasDecTotais);
            KendoNumericChangeDecimals('TotalValesOferta', inCasasDecTotais);
            KendoNumericChangeDecimals('TotalEntidade2', inCasasDecTotais);

            $(".Currency").html("&nbsp;" + novoSimboloMoeda);
            $("#SimboloMoedaRefCliente").val(novoSimboloMoeda);
            $("#" + campoCasasDecTot).val(inCasasDecTotais);
            $("#" + campoCasasDecPU).val(inCasasDecPrecoUni);
            $("#" + campoCasasDecIVA).val(inCasasDecIVA);
        }
    };

    /* @description funcao que configura as casas decimais de cada celula da handson */
    self.SetCasasDecimais = function (row, col, prop, inCasasDecTotais, inCasasDecPrecoUni) {
        let cellProperties = {};
        let valor = 0;
        let formatoCD = 0;

        switch (prop) {
            case "Desconto1": case "Desconto2": case "ValorDescontoLinha": case "TotalComDescontoLinha": case "ValorDescontoCabecalho": case "TotalComDescontoCabecalho": case "SubTotal": case "ValorEntidade1": case "ValorEntidade2": case "TotalFinal":
                formatoCD = valor.toFixed(inCasasDecTotais);
                cellProperties.format = formatoCD;
                break;

            case "PrecoUnitario": case "ValorUnitarioEntidade1": case "ValorUnitarioEntidade2": case "PrecoUnitarioEfetivo":
                formatoCD = valor.toFixed(inCasasDecPrecoUni);
                cellProperties.format = formatoCD;
                break;
        }

        return cellProperties;
    };

    /* @description funcao que configura os urls dos controllers da handson (f4) */
    self.ConfigControladoresLookUps = function (inHdsn) {
        for (var i = 0; i < inHdsn.countRows(); i++) {
            self.ConfigColunasBloqueadas(i, inHdsn);
        }
        inHdsn.render();
    };

    /* @description funcao que configura os urls dos controllers da handson (f4) e as colunas bloquedas */
    self.ConfigColunasBloqueadas = function (i, gridHT) {
        let _boolUtilizaConfigDescontos = $('#UtilizaConfigDescontos').val() === 'True';

        var valorColDescricao = gridHT.getDataAtRowProp(i, "Descricao");
        if (valorColDescricao != null) {
            var arrayColsBloquear = ["Campanha", "Quantidade", "PrecoUnitario", "", "", "", "ValorUnitarioEntidade1", "ValorEntidade1", "ValorUnitarioEntidade2", "ValorEntidade2"];


            //if (!_boolUtilizaConfigDescontos) {
            arrayColsBloquear.push("Desconto1", "ValorDescontoLinha", "TotalComDescontoLinha");
            //}

            self.DesbloqueiaColunasComArtigo(i, gridHT, valorColDescricao !== "" ? true : false, arrayColsBloquear);
        }

        let cell = gridHT.getCellMeta(i, 0);
        let tipoOlho = gridHT.getDataAtRowProp(i, "IDTipoOlho");
        if (tipoOlho != 0 && tipoOlho != TipoOlho.Aro && tipoOlho != TipoOlho.Diversos && tipoOlho != null) { // != DE MERGE CELLS && != ARO  && != DIVERSOS
            cell.readOnly = DisableViaEstado || false;
        }

        if (tipoOlho == 0) {
            cell["className"] = "handson-titulo htRight";
        }

        cell = gridHT.getCellMeta(i, 1);

        if (tipoOlho != null && tipoOlho != TipoOlho.Aro && tipoOlho != TipoOlho.Diversos) { //ARO || DIVERSOS
            cell.Controlador = rootDir + "/TabelasAuxiliares/CatalogosLentes";
            cell.ControladorExtra = "";
        }
        else {
            cell.Controlador = rootDir + "/DocumentosVendasServicos/ListaArtigosComboCodigo";
            cell.ControladorExtra = rootDir + "/Artigos/Artigos/IndexGrelha";
        }

        if (tipoOlho == TipoOlho.Diversos || tipoOlho == null) {
            cell.invalidCellClassName = "htInvalid";
        }
    };

    /* @description funcao que desbloqueia as colunas em que a linha tem artigo  */
    self.DesbloqueiaColunasComArtigo = function (i, inGridHT, boolDesbloqueado, arrayColsBloquear) {
        for (var j = 0; j < arrayColsBloquear.length; j++) {
            var index = UtilsRetornaIndiceArrayObjetos(inGridHT.getSettings().__proto__.columns, arrayColsBloquear[j], "ID");
            if (index > -1) {
                var cellb = inGridHT.getCellMeta(i, index);
                cellb.readOnly = DisableViaEstado || !boolDesbloqueado;
                if (arrayColsBloquear[j] == "PrecoUnitario" && cellb.readOnly == false) {
                    cellb.readOnly = self.LimiteMaxDesconto();
                }

            }
        }
    };

    /* @description funcao que limpa todas as linhas do servico */
    self.LimpaLinhasServico = function (inBoolLimpaHT_Longe, inBoolLimpaHT_Perto, inBoolLimpaHT_Lentes) {
        var gridHTLonge = window.HotRegisterer.bucket.hdsnLonge;
        var gridHTPerto = window.HotRegisterer.bucket.hdsnPerto;
        var gridHTLentes = window.HotRegisterer.bucket.hdsnLentes;

        if (inBoolLimpaHT_Longe) {
            gridHTLonge != undefined && $(gridHTLonge.rootElement).is(":visible") ? self.LimparGridHT(gridHTLonge) : true;
        }

        if (inBoolLimpaHT_Perto) {
            gridHTPerto != undefined && $(gridHTPerto.rootElement).is(":visible") ? self.LimparGridHT(gridHTPerto) : true;
        }

        if (inBoolLimpaHT_Lentes) {
            gridHTLentes != undefined && $(gridHTLentes.rootElement).is(":visible") ? self.LimparGridHT(gridHTLentes) : true;
        }
    };

    /* @description funcao enviar parametros para o lookup dos artigos nas handsons */
    self.EnviaParametrosArtigos = function (objetoFiltro, gridHT) {
        var IDTipoArtigo;

        if (gridHT === 'F3MGrelhaArtigos') {
            gridHT = selectedHT;
        }

        if (!UtilsVerificaObjetoNotNullUndefined(gridHT.getSelected())) {
            gridHT.selectCell(0, 1);
        }

        var IDTipoServico = self.GetValorCampoObj("IDTipoServico", gridHT.getDataAtRowProp(gridHT.getSelected()[0][0], "IDServico"));
        var IDTipoGraduacao = gridHT.getSourceDataAtRow(gridHT.getSelected()[0][0]).IDTipoGraduacao;

        if (IDTipoServico != null) {
            if (IDTipoServico == TipoServico.Contacto) {
                IDTipoArtigo = IDTipoGraduacao == 2 ? 2 : 3;  // LENTEES DE CONTACTO
            }
            else {
                IDTipoArtigo = IDTipoGraduacao == 2 ? 2 : 1; //LENTES OFTALMICAS
            }

            //MAF
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDTipoServico', '', IDTipoServico);
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDTipoOlho', '', gridHT.getSourceDataAtRow(gridHT.getSelected()[0][0]).IDTipoOlho);

        }
        else {
            IDTipoArtigo = 5; // DIVERSOS
        }

        if (gridHT.getSourceDataAtRow(gridHT.getSelected()[0][0]).IDTipoOlho == 3) {
            IDTipoArtigo = 2;
        }


        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#' + campoTaxaConv)))) {
            var taxaConv = parseFloat(KendoRetornaElemento($('#' + campoTaxaConv)).value());
            var IDEnt = $('#' + campoIDEnti).val();
            var IDMoed = $('#' + campoIDMoeda).val();

            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, campoTaxaConv, '', taxaConv);
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, campoIDEnti, '', IDEnt);
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, campoIDMoeda, '', IDMoed);
        }
        var elem = $("<input id='IDTipoArtigo' name='IDTipoArtigo' tabindex='-1' type='hidden' value='" + IDTipoArtigo + "'>");
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, "IDTipoArtigo");

        return objetoFiltro;
    };

    /* @description funcao que gera a handson 'vazia' */
    self.InitHandsonTableModeloVazio = function (inHdsn1, inHdsn2) {
        var servico = self.SubServicoRetorna(self.GetServicoActivo());

        if (inHdsn1 !== null && inHdsn2 !== null) {
            var data1 = [];
            var data2 = [];
            data1.push(servico[0].DocumentosVendasLinhas[0]);
            data1.push(servico[0].DocumentosVendasLinhas[1]);
            data1.push(servico[0].DocumentosVendasLinhas[2]);
            data2.push(servico[0].DocumentosVendasLinhas[3]);
            data2.push(servico[0].DocumentosVendasLinhas[4]);
            data2.push(servico[0].DocumentosVendasLinhas[5]);
            self.InitHandsonTable(inHdsn1, data1, 133);
            self.InitHandsonTable(inHdsn2, data2, 133);
        } else if (inHdsn1 !== null && inHdsn2 == null) {
            var data = [];
            data.push(servico[0].DocumentosVendasLinhas[6]);
            data.push(servico[0].DocumentosVendasLinhas[7]);
            self.InitHandsonTable(inHdsn1, data, 102);
        }
    };

    //----------------- H A N D S O N T A B L E     S E R V I C O S || A R T I G O S -> C A M P O S     P R E E N C H E R
    /* @description funcao que preenche propriedades do modelo conforme o artigo escolhido */
    self.CamposPreencher = function (hdsn, changes, ColEditorRow, ColEditorCol) {
        var campoAlterado = changes[0][1];
        var data = null;
        if (UtilsVerificaObjetoNotNullUndefinedVazio(changes[0][3])) {

            var campo = campoAlterado === 'CodigoArtigo' ? campoCod : campoDesc;
            data = $.grep(HandsonTableVarGridHTF4DS(), function (data, i) {
                return data[campo].toLowerCase() === changes[0][3].toLowerCase();
            })[0];
        }

        if (campoAlterado === 'CodigoArtigo' &&
            (ColEditorRow == 0 || ColEditorRow == 1) &&
            UtilsVerificaObjetoNotNullUndefined(data) && hdsn.getActiveEditor()._opened) {

            self.PreencheGraduacoes(hdsn, ColEditorRow, data);
        }

        if (isTRIGGER_CLICK_TIPO2 === true) {
            hdsn.deselectCell();

            for (var i = 0; i < hdsn.getSourceData().length; i++) {
                ColEditorRow = i;
                ColEditorCol = 1;

                self.CamposPreencherExec(null, hdsn, ColEditorRow, ColEditorCol);
            }
            isTRIGGER_CLICK_TIPO2 = false;

        }
        else {
            self.CamposPreencherExec(data, hdsn, ColEditorRow, ColEditorCol, changes);
        }
    };

    /* @description funcao que preenche propriedades do modelo conforme o artigo escolhido */
    self.CamposPreencherExec = function (data, hdsn, ColEditorRow, ColEditorCol, inChanges) {
        if (UtilsVerificaObjetoNotNullUndefined(hdsn.getCellMeta(ColEditorRow, ColEditorCol).ListaCamposPreencher)) {
            var campoAlterado = inChanges[0][1];
            var dataLength = hdsn.getCellMeta(ColEditorRow, ColEditorCol).ListaCamposPreencher.length;
            var ID = hdsn.getSourceDataAtRow(ColEditorRow).ID;
            var IDServico = hdsn.getSourceDataAtRow(ColEditorRow).IDServico;
            var boolExisteArtigo = false;

            for (var i = 0; i < dataLength; i++) {
                var item = hdsn.getCellMeta(ColEditorRow, ColEditorCol).ListaCamposPreencher[i];
                var Coluna = item.Coluna;
                var Campo = item.Campo;
                var Valor = item.Valor;

                $.map(hdsn.getSourceData(), function (obj, i) {
                    if (obj.ID === ID && obj.IDServico === IDServico) {
                        if (data != null) {
                            obj[Coluna] = data[Campo];
                            boolExisteArtigo = true;
                        }
                        else {
                            obj[Coluna] = null;
                        }
                    }
                });
            }

            if (boolExisteArtigo && campoAlterado === 'CodigoArtigo') {
                $.map(hdsn.getSourceData(), function (obj, i) {
                    if (obj.ID === ID && obj.IDServico === IDServico) {
                        if (obj.AcaoCRUD === parseInt(constEstados.Remover)) {
                            obj.AcaoCRUD = parseInt(constEstados.Alterar);
                        }
                    }

                    if (obj.IDTipoOlho === TipoOlho.Diversos) {
                        obj['Diametro'] = null;
                    }
                });
            }
            else if (campoAlterado === 'CodigoArtigo') {
                $.map(hdsn.getSourceData(), function (obj, i) {
                    if (obj.ID === ID && obj.IDServico === IDServico) {
                        obj['Campanha'] = null;
                        obj['Quantidade'] = 1;
                        obj['PrecoUnitario'] = parseFloat(0);

                        if (obj.IDTipoOlho === TipoOlho.Aro) {
                            obj['Diametro'] = null;
                        }
                    }
                });
            }
        }

        self.ConfigColunasBloqueadas(ColEditorRow, hdsn);
    };

    //----------------- H A N D S O N T A B L E     A R T I G O S -> D I V E R S O S
    /* @description funcao que mapeia as linhas por servico */
    self.MapeiaLinhasPorTipoServico = function (arrServicos, inCabecalho) {
        return $.map(arrServicos, function (objData, i) {
            self.TrataJSONDatas(objData);

            var descrSubServico = objData.DescricaoServico == null ? " - " : objData.DescricaoServico;
            var descricao = self.GetLabelArtigos(objData);

            if (inCabecalho) {
                objData.DocumentosVendasLinhas.unshift({
                    Diametro: "<div class='leftDescription'>" + descrSubServico + " //  <a id='entregaArtigosClique' onclick='$servicos.ajax.CliqueFloatingEntregasArtigos(this);'>" + descricao + "</a> </div>",
                    IDTipoOlho: 0,
                    IDServico: objData.ID
                });
            }

            objData.DataEntregaLongeAux = objData.DataEntregaLonge;
            objData.DataEntregaPertoAux = objData.DataEntregaPerto;

            if (objData.IDTipoServico === TipoServico.Contacto) {
                return $.grep(objData.DocumentosVendasLinhas, function (obj, i) {
                    return obj.IDTipoGraduacao === TipoGraduacao.LentesContato && (obj.IDTipoOlho === TipoOlho.Direito || obj.IDTipoOlho === TipoOlho.Esquerdo) || obj.IDTipoOlho == 0;
                });
            } else if (objData.IDTipoServico === TipoServico.Longe) {
                return $.grep(objData.DocumentosVendasLinhas, function (obj, i) {
                    return obj.IDTipoGraduacao === TipoGraduacao.Longe || obj.IDTipoOlho == 0;
                });
            } else if (objData.IDTipoServico === TipoServico.Perto) {
                return $.grep(objData.DocumentosVendasLinhas, function (obj, i) {
                    return obj.IDTipoGraduacao === TipoGraduacao.Perto || obj.IDTipoOlho == 0;
                });
            } else if (objData.IDTipoServico === TipoServico.LongePerto) {
                return $.grep(objData.DocumentosVendasLinhas, function (obj, i) {
                    return (obj.IDTipoGraduacao === TipoGraduacao.Longe || obj.IDTipoGraduacao === TipoGraduacao.Perto) && (obj.IDTipoOlho === TipoOlho.Direito || obj.IDTipoOlho === TipoOlho.Esquerdo || obj.IDTipoOlho === TipoOlho.Aro) || obj.IDTipoOlho == 0;
                });
            } else {
                return $.grep(objData.DocumentosVendasLinhas, function (obj, i) {
                    return obj.IDTipoGraduacao === TipoGraduacao.Longe && (obj.IDTipoOlho === TipoOlho.Direito || obj.IDTipoOlho === TipoOlho.Esquerdo || obj.IDTipoOlho === TipoOlho.Aro) || obj.IDTipoOlho == 0;
                });
            }
        });
    };

    /* @description funcao quando e' inserido um diverso na handson da tab artigos */
    self.AdicionaDiversos = function (index, gridHT) {
        gridHT.render();

        if (index != -1 && gridHT.getSelected() != undefined) {
            gridHT.setDataAtRowProp(index, "ID", Math.max.apply(Math, gridHT.getSourceData().map(function (o) { return o.ID; }).filter(function (n) { return n != undefined; })) + 1);
            gridHT.setDataAtRowProp(index, "Ordem", Math.max.apply(Math, gridHT.getSourceData().map(function (o) { return o.Ordem; }).filter(function (n) { return n != undefined; })) + 1);
            gridHT.setDataAtRowProp(index, "IDTipoOlho", TipoOlho.Diversos);
            gridHT.setDataAtRowProp(index, "AcaoCRUD", constEstados.Adicionar);

            gridHT.setDataAtRowProp(index, "Diametro", null);

            var result = gridHT.getSourceData().filter(function (f) {
                return f.IDTipoOlho === TipoOlho.Diversos;
            });

            var resultRems = ModeloServico.Diversos.filter(function (f) {
                return f.AcaoCRUD === constEstados.Remover;
            });

            for (var i = 0; i < result.length; i++) {
                var item = result[i];

                item.Ordem = i;
            }

            ModeloServico.Diversos = result;
            ModeloServico.Diversos.push.apply(ModeloServico.Diversos, resultRems);

            self.HandsonTableStretchHTHeightAndRender(constHdsnArtigos);
        }
    };

    /* @description funcao quando e' removido um diverso na handson da tab artigos */
    self.RemoveDiversos = function (index, amount, gridHT) {
        for (var i = 0; i < amount; i++) {

            var modelLinha = ModeloServico.Diversos.filter(function (f) {
                return f.ID === gridHT.getSourceDataAtRow(index + i).ID;
            })[0];

            if (modelLinha.AcaoCRUD != constEstados.Adicionar) {
                modelLinha.AcaoCRUD = constEstados.Remover;
            }
            else {
                var indexOfModelLinha = ModeloServico.Diversos.indexOf(modelLinha);
                ModeloServico.Diversos.splice(indexOfModelLinha, 1);
            }
        }
    };

    //----------------- H A N D S O N T A B L E     S E R V I C O S || A R T I G O S -> C O N T E X T     M E N U
    /* @description funcao que limpa todas as linhas da handson */
    self.LimparGridHT = function (inHdsn) {
        for (var i = 0; i < inHdsn.getSourceData().length; i++) {
            self.LimparLinha(inHdsn, i, true);
        }
        self.Calcula(null, null, null, true, null, null);
    };

    /* @description funcao que limpa uma linha da handson */
    self.LimparLinha = function (inHdsn, inRow, inBoolFromLimparGridHT) {
        var obj = $.grep(ModeloServico.Servicos, function (obj, i) {
            return obj.ID === self.GetServicoActivo();
        });

        var index = inRow;
        if (inHdsn.rootElement.id === "hdsnPerto") { index += 3; }
        if (inHdsn.rootElement.id === "hdsnLentes") { index += 6; }

        var modelLinha = obj[0].DocumentosVendasLinhas[index];

        if (UtilsVerificaObjetoNotNullUndefinedVazio(modelLinha)) {
            modelLinha.CodigoArtigo = null;
            modelLinha.DescricaoMarca = null;
            modelLinha.CodigoBarrasArtigo = null;
            modelLinha.CodigoMotivoIsencaoIva = null;
            modelLinha.CodigoRegiaoIva = null;
            modelLinha.CodigoTipoIva = null;
            modelLinha.Descricao = null;
            modelLinha.Diametro = null;
            modelLinha.EspacoFiscal = null;
            modelLinha.IDArtigo = null;
            modelLinha.IDEspacoFiscal = null;
            modelLinha.IDMarca = null;
            modelLinha.IDMateria = null;
            modelLinha.IDModelo = null;
            modelLinha.IDTaxaIva = null;
            modelLinha.IDTipoIva = null;
            modelLinha.IDTipoLente = null;
            modelLinha.IDMateria = null;
            modelLinha[campoTaxaIVA] = null;
            modelLinha.IDRegimeIva = null;
            modelLinha.IDUnidade = null;
            modelLinha.CodigoUnidade = null;
            modelLinha.RegimeIva = null;
            modelLinha.MotivoIsencaoIva = null;

            modelLinha.Quantidade = 1;
            modelLinha.TotalFinal = 0;
            modelLinha.PrecoUnitario = 0;
            modelLinha.TotalComDescontoCabecalho = 0;
            modelLinha.TotalComDescontoLinha = 0;
            modelLinha.TotalSemDescontoLinha = 0;
            modelLinha.PrecoTotal = 0;
            modelLinha.PrecoUnitarioEfetivo = 0;
            modelLinha.ValorIVA = 0;
            modelLinha.ValorImposto = 0;
            modelLinha.ValorIncidencia = 0;

            //reset values
            modelLinha.IDCampanha = null;
            modelLinha.Campanha = null;
            modelLinha.CodigoIva = null;
            modelLinha.CodigoTaxaIva = null;

            modelLinha.Desconto1 = 0;
            modelLinha.PrecoUnitarioEfetivoSemIva = 0;
            modelLinha.ValorDescontoCabecalho = 0;
            modelLinha.ValorDescontoEfetivoSemIva = 0;
            modelLinha.ValorDescontoLinha = 0;
            modelLinha.ValorEntidade1 = 0;
            modelLinha.ValorEntidade2 = 0;
            modelLinha.ValorUnitarioEntidade1 = 0;
            modelLinha.ValorUnitarioEntidade2 = 0;
            modelLinha.PercIncidencia = 0;

            if (modelLinha.AcaoCRUD != constEstados.Adicionar) {
                modelLinha.AcaoCRUD = constEstados.Remover;
            }
        }

        var arrayColsBloquear = ["Campanha", "Quantidade", "PrecoUnitario", "Desconto1", "ValorDescontoLinha", "TotalComDescontoLinha", "ValorUnitarioEntidade1", "ValorEntidade1", "ValorUnitarioEntidade2", "ValorEntidade2"];
        self.DesbloqueiaColunasComArtigo(inRow, inHdsn, false, arrayColsBloquear);
        inHdsn.render();
        //
        inBoolFromLimparGridHT != true ? self.Calcula(null, null, null, true, null, null) : null;

    };

    /* @description funcao que copia para a linha de cima */
    self.ReplicarLinhaCima = function (inKey, inOptions, inHdsn) {
        var arrayToCopy = jQuery.extend({}, inHdsn.getSourceDataAtRow(1));
        var obj = self.SubServicoRetorna(self.GetServicoActivo());

        var obj2 = $.grep(obj[0].DocumentosVendasLinhas, function (data, i) {
            return data.IDTipoGraduacao === arrayToCopy.IDTipoGraduacao;
        });
        arrayToCopy.IDTipoOlho = TipoOlho.Direito;
        arrayToCopy.ID = obj2[0].ID;
        arrayToCopy.AcaoCRUD = obj2[1].AcaoCRUD;
        obj2[0] = arrayToCopy;

        for (var i = 0; i < ModeloServico.Servicos.length; i++) {
            if (ModeloServico.Servicos[i].ID === self.GetServicoActivo() && ModeloServico.Servicos[i].AcaoCRUD != constEstados.Remover) {
                for (var j = 0; j < ModeloServico.Servicos[i].DocumentosVendasLinhas.length; j++) {
                    if (ModeloServico.Servicos[i].DocumentosVendasLinhas[j].IDTipoOlho === arrayToCopy.IDTipoOlho && ModeloServico.Servicos[i].DocumentosVendasLinhas[j].IDTipoGraduacao === arrayToCopy.IDTipoGraduacao) {
                        ModeloServico.Servicos[i].DocumentosVendasLinhas[j] = obj2[0];
                        inHdsn.loadData(obj2);
                        break;
                    }
                }
            }
        }

        //self.PreencheGraduacoes(gridHT, 0, arrayToCopy);
        self.Calcula(null, null, null, true, null, null);
        self.TrataDepoisReplicar(arrayToCopy);
    };

    /* @description funcao que copia para a linha de baixo */
    self.ReplicarLinhaBaixo = function (inKey, inOptions, inHdsn) {
        var arrayToCopy = jQuery.extend({}, inHdsn.getSourceDataAtRow(0));
        var obj = self.SubServicoRetorna(self.GetServicoActivo());

        var obj2 = $.grep(obj[0].DocumentosVendasLinhas, function (data, i) {
            return data.IDTipoGraduacao === arrayToCopy.IDTipoGraduacao;
        });
        arrayToCopy.IDTipoOlho = TipoOlho.Esquerdo;
        arrayToCopy.ID = obj2[1].ID;
        if (UtilsVerificaObjetoNotNullUndefined(arrayToCopy.Descricao) && obj2[1].AcaoCRUD == constEstados.Remover) {
            obj2[1].AcaoCRUD = constEstados.Alterar;
        };
        arrayToCopy.AcaoCRUD = obj2[1].AcaoCRUD;
        obj2[1] = arrayToCopy;

        for (var i = 0; i < ModeloServico.Servicos.length; i++) {
            if (ModeloServico.Servicos[i].ID === self.GetServicoActivo() && ModeloServico.Servicos[i].AcaoCRUD != constEstados.Remover) {
                for (var j = 0; j < ModeloServico.Servicos[i].DocumentosVendasLinhas.length; j++) {
                    if (ModeloServico.Servicos[i].DocumentosVendasLinhas[j].IDTipoOlho === arrayToCopy.IDTipoOlho && ModeloServico.Servicos[i].DocumentosVendasLinhas[j].IDTipoGraduacao === arrayToCopy.IDTipoGraduacao) {
                        ModeloServico.Servicos[i].DocumentosVendasLinhas[j] = obj2[1];
                        inHdsn.loadData(obj2);
                        break;
                    }
                }
            }
        }

        //self.PreencheGraduacoes(gridHT, 1, arrayToCopy);
        self.Calcula(null, null, null, true, null, null);
        self.TrataDepoisReplicar(arrayToCopy);
    };

    /* @description que verifica se a opcao replicar para cima esta disponivel */
    self.DisableReplicarLinhaCima = function (inHdsn) {
        var currentHTID = inHdsn.rootElement.id; // event.currentTarget.id;

        var IDTipoServico = self.GetValorCampoObj("IDTipoServico", inHdsn.getDataAtRowProp(inHdsn[0], "IDServico"));

        if (IDTipoServico == 7 || IDTipoServico == 8 || IDTipoServico == 9 || IDTipoServico == 10) {
            return true;
        }

        if (currentHTID !== "") {
            var gridHT = window.HotRegisterer.bucket[currentHTID];
            var activeRow;

            if (gridHT.getSelected() != undefined) {
                activeRow = gridHT.getSelected()[0][0];
            }
            else {
                return true;
            }

            switch (inHdsn.getSourceDataAtRow(activeRow).IDTipoOlho) {
                case TipoOlho.Direito: //OD
                case TipoOlho.Aro: //ARO
                    return true;

                case TipoOlho.Esquerdo: //OE
                    return false;
            }
        }
        else {
            if (!$(event.realTarget.parentElement.parentElement).find(".htDisabled").length) {
                return false;
            }
            else {
                return true;
            }
        }
    };

    /* @description que verifica se a opcao replicar para baixo esta disponivel */
    self.DisableReplicarLinhaBaixo = function (inHdsn) {
        var currentHTID = inHdsn.rootElement.id; //event.currentTarget.id;

        var IDTipoServico = self.GetValorCampoObj("IDTipoServico", inHdsn.getDataAtRowProp(inHdsn.getSelected()[0][0], "IDServico"));
        if (IDTipoServico == 7 || IDTipoServico == 8 || IDTipoServico == 9 || IDTipoServico == 10) {
            return true;
        }

        if (currentHTID !== "") {
            var gridHT = window.HotRegisterer.bucket[currentHTID];
            var activeRow;

            if (gridHT.getSelected() != undefined) {
                activeRow = gridHT.getSelected()[0][0];
            }
            else {
                return true;
            }

            switch (gridHT.getSourceDataAtRow(activeRow).IDTipoOlho) {
                case TipoOlho.Direito: //OD
                    return false;

                case TipoOlho.Aro: //ARO
                case TipoOlho.Esquerdo: //OE
                    return true;
            }
        }
        else {
            if (!$(event.realTarget.parentElement.parentElement).find(".htDisabled").length) {
                return false;
            }
            else {
                return true;
            }
        }
    };

    /* @description funcao que executa o blur depois de replicar */
    self.TrataDepoisReplicar = function (inArrayToCopy) {
        //new string
        var strFind = '';
        //get tipo graduacao
        switch (inArrayToCopy.IDTipoGraduacao) {
            case TipoGraduacao.Longe:
                strFind += '.TabLonge';
                break;

            case TipoGraduacao.Perto:
                strFind += '.TabPerto';
                break;

            case TipoGraduacao.LentesContato:
                strFind += 'TabLentes';
                break;
        }

        strFind += ' ';

        //get tipo olho
        switch (inArrayToCopy.IDTipoOlho) {
            case TipoOlho.Direito:
                strFind += '.TabOlhoDireito';
                break;

            case TipoOlho.Esquerdo:
                strFind += '.TabOlhoEsquerdo';
                break;
        }

        strFind += '.PotenciaEsferica';

        //trigger blur
        $(strFind).blur();
    };

    //------------------------------------ H A N D S O N T A B L E     I N C I D E N C I A S
    /* @description funcao que desenha a handson incidencias*/
    self.PreencheIncidencias = function () {
        var urlAux = rootDir + '/Documentos/DocumentosVendasServicos/PreencherIncidencias';
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var IDDocumentoVendaAux = $('#IDDocumentoVenda').val();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDDocumentoVendaAux', '', IDDocumentoVendaAux);

        UtilsChamadaAjax(urlAux, true, JSON.stringify({ inObjFiltro: objetoFiltro, modelo: self.PreencheModeloServicos() }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    var hdsnIncidencias = HandsonTableDesenhaNovo('hdsnIncidencias', res, 150, self.RetornaColunasIncidencias());
                }
            }, function (e) { }, 1, true);
    };

    /* @description funcao que retorna as colunas da handson incidencias*/
    self.RetornaColunasIncidencias = function () {
        var moedaRefEmpresa = $('#SimboloMoedaRefEmpresa').val();
        var moedaRefCliente = $('#SimboloMoedaRefCliente').val();
        var intCasasDecTotais = $('#' + campoCasasDecTot).val();
        var intCasasDecIVA = $('#' + campoCasasDecIVA).val();

        var columns = [
            {
                ID: campoTaxaIVA,
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources['PercTaxa'],
                CasasDecimais: intCasasDecIVA,
                width: 55,
                readOnly: DisableViaEstado || true
            }, {
                ID: 'ValorIncidencia',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources['MDIncid'],
                CasasDecimais: intCasasDecTotais,
                width: 60,
                readOnly: DisableViaEstado || true
            }, {
                ID: 'ValorIVA',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources['MDIva'],
                CasasDecimais: intCasasDecTotais,
                width: 60,
                readOnly: DisableViaEstado || true
            }];

        return $.grep(columns, function (Obj, i) {
            return Obj.Label = Obj.Label.replace(moedaRefEmpresa, moedaRefCliente);
        });
    };

    //------------------------------------ B O T O E S     L A D O     D I R E I T O || H I S T O' R I C O

    self.AbreDocumentoVendaAssociadoFromHistorico = function () {
        var urlAux = rootDir + "DocumentosVendasServicos/LerDocumentosAssociados";
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var iddocumento = $('#IDDocumentoVenda').val();
        var tipodocumento = $("#IDTipoDocumento").val();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'iddocumento', '', iddocumento);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'tipodocumento', '', tipodocumento);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'opcao', '', 'documentoVenda');
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'origem', '', 'servicos');

        UtilsChamadaAjax(urlAux, true, JSON.stringify({ inObjFiltro: objetoFiltro }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    if (res.ID > 0) {
                        UtilsAbreTab('/Documentos/DocumentosVendas?IDDrillDown=' + res.ID, resources['DocumentosVendas'], 'f3icon-glasses', '1', '', '');
                    }
                }
            }, function (e) { throw e; }, 1, true);
    };

    /* @description funcao que abre os anexos dos servicos */
    self.AbreAnexos = function () {
        var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
        var UrlAux = rootDir + "/Documentos/DocumentosVendasAnexos";
        JanelaDesenha(janelaMenuLateral, self.RetornaObjData(), UrlAux);
    };

    /* @description funcao que abre os anexos dos servicos */
    self.AbrePagamentosAdiantamentos = function (e) {
        var urlAux = rootDir + "DocumentosVendasServicos/LerDocumentosAssociados";
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var iddocumento = $('#IDDocumentoVenda').val();
        var tipodocumento = $("#IDTipoDocumento").val();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'iddocumento', '', iddocumento);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'tipodocumento', '', tipodocumento);

        UtilsChamadaAjax(urlAux, true, JSON.stringify({ inObjFiltro: objetoFiltro }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    var accao = constEstados.Adicionar;
                    if (res.ID > 0) {
                        UtilsNotifica(base.constantes.tpalerta.i, resources.documento_venda_existente.replace('{0}', res.Documento));
                    } else {
                        self.AbreAdiantamentos(e);
                    }
                }
            }, function (e) { }, 1, true);
    };

    /* @description funcao que abre os os recebimentos ao servico ou a fatura */
    self.AbreRecebimentos = function (e) {
        var _UrlAux = window.location.pathname + '/BlnTemRecebimentos';
        var IDDocumentoVendaAux = parseInt($('#IDDocumentoVenda').val());
        var IDMoedaAux = parseInt($('#' + campoIDMoeda).val());
        var OpcaoAux = 'recebimentos';

        KendoLoading($("#F3MGrelhaFormDocumentosVendasForm"), true);

        UtilsChamadaAjax(_UrlAux, true, JSON.stringify({
            IDDocumentoVenda: IDDocumentoVendaAux
        }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    if (res == true) {
                        var _janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
                        var _UrlAuxPagamentosVendas = rootDir + '/PagamentosVendas/PagamentosVendas?IDDocumentoVendaServico=' + IDDocumentoVendaAux + '&' + campoIDMoeda + '=' + IDMoedaAux + '&Opcao=' + OpcaoAux;

                        JanelaDesenha(_janelaMenuLateral, self.RetornaObjData(), _UrlAuxPagamentosVendas, '', null, null, null, null, null, function (inEvt) {
                            inEvt.sender.element.addClass('janela-centrada');
                            janelaRefrescar(inEvt, '', false, 'f3m-window-bg-centrada');
                            FrontendGrelhaLoading();
                        }, self.AtualizaHistorico, null, null, null, null);
                    }
                    else {
                        UtilsNotifica(base.constantes.tpalerta.i, resources.nao_tem_recebimentos);
                    }

                    KendoLoading($("#F3MGrelhaFormDocumentosVendasForm"), false);
                }
            },
            function () {
                return false;
            }, 1, true);
    };

    /* @description funcao que abre os os adiantamentos do servico */
    self.AbreAdiantamentos = function (e) {
        var _UrlAux = window.location.pathname + '/BlnPodeAdiantar';
        var _ID = parseInt($('#' + campoID).val());
        var _IDMoedaAux = parseInt($('#' + campoIDMoeda).val());
        var OpcaoAux = '';

        if (UtilsVerificaObjetoNotNullUndefined(e.currentTarget)) {
            OpcaoAux = e.currentTarget.id;
        }
        else {
            OpcaoAux = $('#pagamentos').length > 0 ? 'pagamentos' : 'adiantamentos';
        }

        UtilsChamadaAjax(_UrlAux, true, JSON.stringify({
            IDDocumentoVenda: _ID
        }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    if (res == true) {
                        var _janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;

                        var _UrlAuxPagamentosVendas = rootDir + '/PagamentosVendas/PagamentosVendas?IDDocumentoVenda=' + _ID + '&' + campoIDMoeda + '=' + _IDMoedaAux + '&Opcao=' + OpcaoAux;
                        JanelaDesenha(_janelaMenuLateral, self.RetornaObjData(), _UrlAuxPagamentosVendas, '', null, null, null, null, null, function (inEvt) {
                            inEvt.sender.element.addClass('janela-centrada');
                            janelaRefrescar(inEvt, '', false, 'f3m-window-bg-centrada');
                            FrontendGrelhaLoading();
                        }, self.AtualizaHistorico, null, null, null, null);
                    }
                }
                else {
                    UtilsNotifica(base.constantes.tpalerta[res.TipoAlerta], res.Errors);
                }
            },
            function () {
                return false;
            }, 1, true);
    };

    /* @description funcao que gera a fatura ou a fatura da entidade 2 */
    self.GeraDocVenda = function (inTipoDoc) {
        //props UtilsAbreTab
        var _id = $('#' + campoID).val();
        var _url = 'Documentos/DocumentosVendas';
        var _tabnome = resources['DocumentosVendas'], _tabicon = 'f3icon-doc-finance';
        //action result AdicionaEsp
        if (inTipoDoc === 'documentoVenda') {
            sessionStorage.setItem('AdicionaEsp', rootDir + _url + '/AdicionaEsp?IDServico=' + _id);
        }
        else {
            sessionStorage.setItem('AdicionaEsp', rootDir + _url + '/AdicionaEsp?IDServicoToFT2=' + _id);
        }
        //UtilsAbreTab
        UtilsAbreTab(_url, _tabnome, _tabicon, null, constEstados.Adicionar, null);
    };

    /*@description funcao que atualiza o historico */
    self.AtualizaHistorico = function (fnSuccessCallback) {
        var _url = rootDir + 'Historicos/Historicos/RetornaHistDocsVendas?IDDocumentoVenda=' + $('#' + campoID).val() + '&EServico=True';

        $.get(_url, {}, (res) => {
            var htmlHist = $('#fasesHistorico');
            $('#tabHistorico').html(res);
            $('#tabHistorico > .row').prepend(htmlHist);
            if (typeof (fnSuccessCallback) == 'function') fnSuccessCallback();
        });
    };

    //------------------------------------ C A L C U L O S
    /*@description funcao que efetua os calculos no servidor */
    self.Calcula = function (changes, gridHT, ColEditor, CalculaGlobal, CampoAlterado, ValorAlterado, inFROMEntidade) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        var urlAux = rootDir + "DocumentosVendasServicos/" + "Calcula";

        var _modelo = self.PreencheModeloServicos();

        if (!CalculaGlobal && !$.isArray(gridHT)) {
            var lin = gridHT.getDataAtRowProp(changes[0][0], "ID");
            var col = changes[0][1];
            var IDServico = gridHT.getDataAtRowProp(changes[0][0], "IDServico");

            objetoFiltro.CamposFiltrar.IDLinha = { "CampoValor": lin, "CampoTexto": lin };
            objetoFiltro.CamposFiltrar.Col = { "CampoValor": col, "CampoTexto": col };
            objetoFiltro.CamposFiltrar.IDServico = { "CampoValor": IDServico, "CampoTexto": IDServico };
            objetoFiltro.CamposFiltrar.CampoAlterado = { "CampoValor": ValorAlterado };
        }
        else {
            if (UtilsVerificaObjetoNotNullUndefined(CampoAlterado)) {
                objetoFiltro.CamposFiltrar.CampoAlterado = { "CampoValor": CampoAlterado.value(), "CampoTexto": $(CampoAlterado.element).attr("id") };
            }
        }

        //para os calculos saberem  que todas as linhas vao para o servidor
        objetoFiltro.CampoValores.ELinhasTodas = { "CampoValor": true };

        if (inFROMEntidade) {
            //para os calculos saberem  que calcula via entidade 
            objetoFiltro.CampoValores.EServicosChangeEntidade = { "CampoValor": true };
        }
        else {
            objetoFiltro.CampoValores.EServicosChangeEntidade = { "CampoValor": false };
        }

        UtilsChamadaAjax(urlAux, true, JSON.stringify({ inObjFiltro: objetoFiltro, modelo: _modelo }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {

                    if (inFROMEntidade) {
                        //calculo efetuado a partir da entidade tem que carregar as grelhas
                        gridHT = self.RetornaGrelhasCalculoEntidade(res);
                    }

                    if ($.isArray(gridHT)) {
                        for (var i = 0, len = gridHT.length; i < len; i++) {
                            if (UtilsVerificaObjetoNotNullUndefined(gridHT[i]) && UtilsVerificaObjetoNotNullUndefined(gridHT[i].rootElement)) {
                                self.CarregaGrelhas(res, gridHT[i], ColEditor);
                            }
                        }
                        self.CarregaTotais(res);
                    }
                    else {
                        if (UtilsVerificaObjetoNotNullUndefined(gridHT) && UtilsVerificaObjetoNotNullUndefined(gridHT.rootElement)) {
                            self.CarregaGrelhas(res, gridHT, ColEditor);
                        }
                        else {
                            self.CarregaTotais(res);
                        }
                    }
                }
            }, function (e) { throw e; }, 1, true);
    };

    /*@description funcao que efetua os calculos dos descontos no servidor */
    self.CalculaDescontoGlobal = function (e) {

        //here

        self.Calcula(null, window.HotRegisterer.bucket[constHdsnArtigos], null, true, e.sender, null);
    };

    /*@description funcao que verificar se vai efetuar calculos */
    self.DeveCalcular = function (inChanges, inHdsn, ColEditor) {
        if (inChanges[0][2] === inChanges[0][3] || ColEditor !== inChanges[0][1]) {
            return false;
        }

        var col = inChanges[0][1];
        if (col !== "Descricao" && col !== "IDMarca" &&
            col !== "IDMateria" && col !== "IDTipoLente" && col !== "IDModelo" &&
            col !== "IDTratamentoLente" && col !== "IDCorLente") {

            var vl;
            var vl2;
            switch (col) {
                case "Diametro":
                    return true;

                case "Quantidade":
                    vl = inHdsn.getDataAtRowProp(inChanges[0][0], "PrecoUnitario");
                    if (vl !== null && vl > 0) {
                        return true;
                    }
                    break;
                case "PrecoUnitario":
                    vl = inHdsn.getDataAtRowProp(inChanges[0][0], "Quantidade");
                    if (vl !== null && vl > 0) {
                        return true;
                    }
                    break;
                case "Desconto1":
                    vl = inHdsn.getDataAtRowProp(inChanges[0][0], "Quantidade");
                    vl2 = inHdsn.getDataAtRowProp(inChanges[0][0], "PrecoUnitario");
                    if (vl !== null && vl > 0 && vl2 !== null && vl2 > 0) {
                        return true;
                    }
                    break;
                case "ValorDescontoLinha":
                    vl = inHdsn.getDataAtRowProp(inChanges[0][0], "Quantidade");
                    vl2 = inHdsn.getDataAtRowProp(inChanges[0][0], "PrecoUnitario");
                    if (vl !== null && vl > 0 && vl2 !== null && vl2 > 0) {
                        return true;
                    }
                    break;
                case "TotalComDescontoLinha":
                    return true;
                case "ValorDescontoCabecalho":
                    vl = inHdsn.getDataAtRowProp(inChanges[0][0], "Quantidade");
                    vl2 = inHdsn.getDataAtRowProp(inChanges[0][0], "PrecoUnitario");
                    if (vl !== null && vl > 0 && vl2 !== null && vl2 > 0) {
                        return true;
                    }
                    break;
                case "TotalComDescontoCabecalho":
                    return true;
                case "ValorUnitarioEntidade1":
                    return true;
                case "ValorEntidade1":
                    return true;
                case "ValorUnitarioEntidade2":
                    return true;
                case "ValorEntidade2":
                    vl = inHdsn.getDataAtRowProp(inChanges[0][0], "Quantidade");
                    vl2 = inHdsn.getDataAtRowProp(inChanges[0][0], "PrecoUnitario");
                    if (vl !== null && vl > 0 && vl2 !== null && vl2 > 0) {
                        return true;
                    }
                    break;
                case "TotalFinal":
                    return true;
            }
            return false;
        } else {
            return false;
        }
    };

    /*@description funcao que carrega as handsons depois de fazer calculos */
    self.CarregaGrelhas = function (inRes, ingridHT, ColEditor) {
        var data = [];

        ModeloServico.Servicos = inRes.Servicos;
        ModeloServico.Diversos = inRes.Diversos;

        var IDTipoGradFiltrar = 0;
        switch (ingridHT.rootElement.id) {
            case constHdsnLonge:
                IDTipoGradFiltrar = 1;
                break;
            case constHdsnPerto:
                IDTipoGradFiltrar = 3;
                break;
            case constHdsnLentes:
                IDTipoGradFiltrar = 4;
                break;
        }

        if (ingridHT.rootElement.id === constHdsnArtigos) {
            var result = ModeloServico.Servicos.filter(function (f) {
                return f.AcaoCRUD != constEstados.Remover;
            });
            data = self.MapeiaLinhasPorTipoServico(result, true);
        } else {
            var IDServicoAtivo = self.GetServicoActivo();
            data = $.map(ModeloServico.Servicos, function (data) {
                if (data.ID === IDServicoAtivo) {
                    return data.DocumentosVendasLinhas.filter(function (index) {
                        return index.IDTipoGraduacao === IDTipoGradFiltrar;
                    });
                }
            });
        }

        var currentTab = $('.clsF3MTabs li a.active').attr('href').replace('#', '');

        if (ingridHT.rootElement.id === constHdsnArtigos && currentTab === 'tabArtigos') {
            data.push({
                Diametro: "<div class='leftDescription'>" + resources.Diversos + "</div>",
                IDTipoOlho: 0
            });
            var arrDivSemRems = ModeloServico.Diversos.filter(function (f) {
                return f.AcaoCRUD != constEstados.Remover;
            });
            data.push.apply(data, arrDivSemRems);
        }

        if (currentTab !== 'tabComparticipacao') {
            isLOAD_DATA = true;
            ingridHT.loadData(data);
        }

        self.CarregaTotais(inRes);
        self.AtivaDirty();
    };

    /*@description funcao que carrega os totais depois de fazer calculos */
    self.CarregaTotais = function (inRes) {
        var casasDecTotais = $("#" + campoCasasDecTot).val();
        var casasDecPerc = constRefCasasDecimaisPercentagem;

        //atualiza a quantidade de servicos
        var qtdSv = inRes.Servicos.filter(function (f) {
            return f.AcaoCRUD != constEstados.Remover;
        }).length;
        $("#qtdServicos").text(qtdSv);

        var sv = inRes.Servicos.filter(function (f) {
            return f.ID === self.GetServicoActivo();
        })[0];

        if (UtilsVerificaObjetoNotNullUndefinedVazio(sv)) {
            //SERVICO
            $("#totalLonge").text(UtilsFormataSeparadoresDecimais_Milhares(sv.TotalLonge.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
            $("#totalCompLonge").text(UtilsFormataSeparadoresDecimais_Milhares(sv.TotalComparticipadoLonge.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
            $("#totalPerto").text(UtilsFormataSeparadoresDecimais_Milhares(sv.TotalPerto.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
            $("#totalCompPerto").text(UtilsFormataSeparadoresDecimais_Milhares(sv.TotalComparticipadoPerto.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
            $("#totalLentes").text(UtilsFormataSeparadoresDecimais_Milhares(sv.TotalLentesContacto.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
            $("#totalCompLentes").text(UtilsFormataSeparadoresDecimais_Milhares(sv.TotalComparticipadoLentesContacto.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
        }

        //GERAL
        $("#Resumo").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.TotalMoedaDocumento.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
        $("#totServicos").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.TotalMoedaServicos.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
        $("#IdTotalIva, #TotalIva").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.TotalIva.toFixed(casasDecTotais), constTipoDeCampo.Moeda));

        //MAF
        if (inRes.SubTotal == null) {
            inRes.SubTotal = parseInt(0);
        }

        $("#SubTotal, #IdSubtotal").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.SubTotal.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
        $("#DescontosLinha").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.DescontosLinha.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
        $("#OutrosDescontos").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.OutrosDescontos.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
        $("#IdTotalEntidade1").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.TotalEntidade1.toFixed(casasDecTotais), constTipoDeCampo.Moeda));
        $("#IdOutrosDescontos").text(UtilsFormataSeparadoresDecimais_Milhares(inRes.OutrosDescontos.toFixed(casasDecTotais), constTipoDeCampo.Moeda));

        KendoRetornaElemento($("#TotalMoedaDocumento")).value(inRes.TotalMoedaDocumento.toFixed(casasDecTotais));
        KendoRetornaElemento($("#TotalEntidade2")).value(inRes.TotalEntidade2.toFixed(casasDecTotais));
        KendoRetornaElemento($("#ValorDesconto")).value(inRes.ValorDesconto.toFixed(casasDecTotais));
        KendoRetornaElemento($("#PercentagemDesconto")).value(inRes.PercentagemDesconto.toFixed(casasDecPerc));
        KendoRetornaElemento($("#TotalPontos")).value(inRes.TotalPontos.toFixed(casasDecTotais));
        KendoRetornaElemento($("#TotalValesOferta")).value(inRes.TotalValesOferta.toFixed(casasDecTotais));
    };

    //------------------------------------ M O D E L O     F U N C I O N A L I D A D E
    /* @description funcao que carrega o modelo em vez de fazer a chamada ajax */
    self.DataBoundModelo = function (inData) {
        //remove temp ds from dom
        $('#tempHdsnDS').remove();
        ModeloServico = inData;
        if ($("#ID").val() !== '0' || $('#DocEstaEmDuplicacao').val() === 'True') {
            self.CarregaListaServicos();
        }

        if (inData.RegistoBloqueado || $('#CodigoTipoEstado').val() === "ANL") {
            self.InativaCamposViaEstado(true);
        }
        else {
            self.InativaCamposViaEstado(false);
        }

        //ListaColunasFases = [{ DocEstaAssinado: "False" }];
        ListaColunasIgnoraBloqueioAssinatura = [{ DocEstaAssinado: "False" }];

        $(".clsF3MTabs a[data-toggle=tab]").on("shown.bs.tab", function (e) {
            var elem = $('#iframeBody');
            var selectedHT = $servicos.ajax.RetornaSelectedHT();
            var idelem;

            if (UtilsVerificaObjetoNotNullUndefinedVazio(selectedHT)) {
                idelem = $(selectedHT.rootElement).parent().attr('data-id-bar-loading');
            }
            KendoLoading(elem, false, true, idelem);

            self.CliqueTab($(e.currentTarget));

            var tab = e.currentTarget.hash.replace("#", "");
            if (tab === "tabHistorico") {
                //self.InitFolesServicos(); // Pedido para retirar as fases do servico pelo GN em 15-09-2k17
            }
            else if (tab === "tabServicos") {
                if ($("#ID").val() !== '0' || $('#DocEstaEmDuplicacao').val() === 'True') {
                    self.CarregaSubServico(self.GetServicoActivo());
                    self.HandsonTableStretchHTHeightAndRender(constHdsnLonge);
                    self.HandsonTableStretchHTHeightAndRender(constHdsnPerto);
                    
                }

            }
            else if (tab === "tabArtigos") {
                self.HandsonTableStretchHTHeightAndRender(constHdsnArtigos);
            }
        });

        F3MFormulariosCliqueTabAtivo(true);
    };

    /*@description funcao que remove as linhas merge da tab artigos */
    self.RemoveLinhasHeader = function () {
        if (ModeloServico.Servicos !== undefined) {
            $.map(ModeloServico.Servicos, function (objData, i) {
                objData.DocumentosVendasLinhas = objData.DocumentosVendasLinhas.filter(function (f) {
                    return f.IDTipoOlho != 0;
                });
            });
        }
    };

    /*@description funcao que retorna o modelo */
    self.PreencheModeloServicos = function () {
        self.RemoveLinhasHeader();

        var form = $("#FormularioPrincipalOpcoes");
        var modelForm = GrelhaUtilsGetModeloForm(GrelhaFormDTO(form));

        modelForm.TotalMoedaDocumento = KendoRetornaElemento($("#TotalMoedaDocumento")).value();
        modelForm.PercentagemDesconto = KendoRetornaElemento($("#PercentagemDesconto")).value();
        modelForm.ValorDesconto = KendoRetornaElemento($("#ValorDesconto")).value();
        modelForm.TotalPontos = KendoRetornaElemento($("#TotalPontos")).value();
        modelForm.TotalValesOferta = KendoRetornaElemento($("#TotalValesOferta")).value();
        modelForm.TotalEntidade2 = KendoRetornaElemento($("#TotalEntidade2")).value();
        modelForm.IDEstado = $("#EstadoInicial").attr("value");
        modelForm.DescricaoEstado = $("#EstadoInicial").text();
        modelForm.TotalEntidade1 = parseFloat($("#IdTotalEntidade1").text());
        modelForm.TotalIva = parseFloat($("#IdTotalIva").text());
        modelForm.IDLoja = $("#IDLoja").val();
        modelForm.Concorrencia = $('#Concorrencia').val();
        modelForm.TipoFiscal = "SV";

        modelForm.GraduacoesAlteradas = JSON.parse($('#GraduacoesAlteradas').val());

        modelForm.IDMedicoTecnico = null;
        modelForm.DescricaoMedicoTecnico = null;

        modelForm.Servicos = ModeloServico.Servicos;
        modelForm.Diversos = ModeloServico.Diversos;

        //Se nao clicou na tab artigos significa que nao tem alteracoes nos diversos
        var gridHTArtigos = window.HotRegisterer.bucket[hdsnArtigos];
        if (gridHTArtigos != undefined) {
            modelForm.Diversos = gridHTArtigos.getSourceData().filter(function (f) {
                return f.IDTipoOlho === TipoOlho.Diversos;
            });
            // model.Diversos.push.apply(model.Diversos, ListaDiversosRemovidos);
        }

        //TRATA DATAS
        //SERVICOS
        for (var i = 0, len = modelForm.Servicos.length; i < len; i++) {
            var item = modelForm.Servicos[i];

            //DT. RECEITA
            if (UtilsVerificaObjetoNotNullUndefinedVazio(item.DataReceita)) {
                item.DataReceita = UtilsConverteJSONDate(item.DataReceita, constJSONDates.ConvertToDDMMAAAA);
            }
            //DT. ENTREGA LONGE
            if (UtilsVerificaObjetoNotNullUndefinedVazio(item.DataEntregaLonge)) {
                item.DataEntregaLonge = UtilsConverteJSONDate(item.DataEntregaLonge, constJSONDates.ConvertToDDMMAAAAHHmm);
                item.DataEntregaLongeAux = item.DataEntregaLonge;
            }

            //DT. ENTREGA PERTO
            if (UtilsVerificaObjetoNotNullUndefinedVazio(item.DataEntregaPerto)) {
                item.DataEntregaPerto = UtilsConverteJSONDate(item.DataEntregaPerto, constJSONDates.ConvertToDDMMAAAAHHmm);
                item.DataEntregaPertoAux = item.DataEntregaPerto;
            }

            ////FASES
            //for (var j = 0, lenJ = item.Fases.length; j < lenJ; j++) {
            //    var itemJ = item.Fases[j];
            //
            //    //DT.
            //    if (UtilsVerificaObjetoNotNullUndefinedVazio(itemJ.Data)) {
            //        itemJ.Data = UtilsConverteJSONDate(itemJ.Data, constJSONDates.ConvertToDDMMAAAAHHmm);
            //    }
            //    //DT. CRIACAO
            //    if (UtilsVerificaObjetoNotNullUndefinedVazio(itemJ.DataCriacao)) {
            //        itemJ.DataCriacao = UtilsConverteJSONDate(itemJ.DataCriacao, constJSONDates.ConvertToDDMMAAAAHHmm);
            //    }
            //}

            //GRADUACOES
            for (var k = 0, lenK = item.DocumentosVendasLinhasGraduacoes.length; k < lenK; k++) {
                var itemK = item.DocumentosVendasLinhasGraduacoes[k];

                //DT. CRIACAO
                if (UtilsVerificaObjetoNotNullUndefinedVazio(itemK.DataCriacao)) {
                    itemK.DataCriacao = UtilsConverteJSONDate(itemK.DataCriacao, constJSONDates.ConvertToDDMMAAAAHHmm);
                }

                //DT. ALTERACAO
                if (UtilsVerificaObjetoNotNullUndefinedVazio(itemK.DataAlteracao)) {
                    itemK.DataAlteracao = UtilsConverteJSONDate(itemK.DataAlteracao, constJSONDates.ConvertToDDMMAAAAHHmm);
                }
            }

            //LINHAS DOS SERVICOS
            for (var l = 0, lenL = item.DocumentosVendasLinhas.length; l < lenL; l++) {
                var itemL = item.DocumentosVendasLinhas[l];

                //DT. CRIACAO
                if (UtilsVerificaObjetoNotNullUndefinedVazio(itemL.DataCriacao)) {
                    itemL.DataCriacao = UtilsConverteJSONDate(itemL.DataCriacao, constJSONDates.ConvertToDDMMAAAAHHmm);
                }

                //DT. ALTERACAO
                if (UtilsVerificaObjetoNotNullUndefinedVazio(itemL.DataAlteracao)) {
                    itemL.DataAlteracao = UtilsConverteJSONDate(itemL.DataAlteracao, constJSONDates.ConvertToDDMMAAAAHHmm);
                }
            }
        }

        //DIVERSOS
        for (var d = 0, lenD = modelForm.Diversos.length; d < lenD; d++) {
            var itemD = modelForm.Diversos[d];
            //DT. CRIACAO
            if (UtilsVerificaObjetoNotNullUndefinedVazio(itemD.DataCriacao)) {
                itemD.DataCriacao = UtilsConverteJSONDate(itemD.DataCriacao, constJSONDates.ConvertToDDMMAAAAHHmm);
            }
        }

        return modelForm;
    };

    //------------------------------------ G R A V A     E S P E C I F I C O
    /*@description funcao especifica de gravacao */
    self.Acoes = function (inGrid, inElemBtID) {
        var valorID = null;
        var model = self.PreencheModeloServicos();
        var gridDS = inGrid.dataSource;
        var boolModel = UtilsVerificaObjetoNotNullUndefined(model);

        if (boolModel) {
            valorID = UtilsVerificaObjetoNotNullUndefinedVazio(model[campoID]) ? model[campoID] : null;
        }
        var options;
        var url;

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(model.NumeroDocumento)) {
            model.NumeroDocumento = 0;
        }

        switch (inElemBtID) {
            case btIDGuardarFechar:
            case btIDGuardarFechar2:
            case constIDsBts.GuardarCont:
            case constIDsBts.Guardar:
                if (boolModel) {
                    if (!$(".htInvalid").length) {
                        options = gridDS.transport.options;
                        url = valorID !== null && valorID > 0 ? options.update.url : options.create.url;

                        self.Valida(inGrid, url, model, inElemBtID);
                    }
                    else {
                        UtilsAlerta(base.constantes.tpalerta.i, resources.existem_campos_invalidos_nas_grelhas);
                    }
                }
                break;
        }
    };

    /*@description funcao especifica de gravacao */
    self.Valida = function (inGrelha, inURL, inModelo, inElemBtID) {
        var formulario = $("#FormularioPrincipalOpcoes");
        var gridID = inGrelha.element.attr("id");
        var urlNovo = $("#" + gridID + "Form form").attr("action").split("?")[0];
        GrelhaUtilsValidaEGrava(inGrelha, formulario, urlNovo, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso, null);
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /* @description  funcao que atribui o valor de uma propriedade ao servico (objeto)  */
    self.SetValorCampoObj = function (inObj, inCampoToSetValor, inValor, inIDServico) {
        var result = $.grep(inObj, function (e) {
            return e.ID === inIDServico;
        });

        if (result.length) {
            result[0][inCampoToSetValor] = inValor;
        }
    };

    /* @description  funcao que vai buscar o valor de uma propriedade ao servico (objeto)  */
    self.GetValorCampoObj = function (inCampoToGetValor, inIDServico) {
        var obj = UtilsVerificaObjetoNotNullUndefinedVazio(ModeloServico.Servicos) ? ModeloServico.Servicos : window.parent.ModeloServico;
        var result = $.grep(obj, function (e) {
            return e.ID === inIDServico;
        });

        if (result.length) {
            return result[0][inCampoToGetValor];
        }
    };

    /* @description  funcao que vai ao banco validar se existe algum artigo c/ as graduacoes selecionadas */
    self.ValidaExisteArtigo = function (inInput) {
        var urlAux = rootDir + "DocumentosVendasServicos" + "/ValidaExisteArtigo";
        var IDTipoGraduacao;
        var IDTipoOlho;

        switch ($(inInput).closest("tr").attr("class")) {
            case campoTabLonge:
                IDTipoGraduacao = TipoGraduacao.Longe;
                break;
            case campoTabPerto:
                IDTipoGraduacao = TipoGraduacao.Perto;
                break;
            case campoTabInt:
                IDTipoGraduacao = TipoGraduacao.Intermedio;
                break;
            case campoTabLentes:
                IDTipoGraduacao = TipoGraduacao.LentesContato;
                break;
        }

        switch (inInput.classList[1]) {
            case "TabOlhoDireito":
                IDTipoOlho = 1;
                break;

            case "TabOlhoEsquerdo":
                IDTipoOlho = 2;
                break;
        }

        var model = self.PreencheModeloServicos();
        var servico = self.SubServicoRetorna(self.GetServicoActivo())[0];

        var IDLinha = $.grep(servico.DocumentosVendasLinhas, function (obj, i) {
            return obj['IDTipoOlho'] === IDTipoOlho && obj['IDTipoGraduacao'] === IDTipoGraduacao;
        })[0]['ID'];

        var objetoFiltro = GrelhaUtilsObjetoFiltro();
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'Col', '', 'PrecoUnitario');
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDLinha', '', IDLinha);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDServico', '', self.GetServicoActivo());

        UtilsChamadaAjax(urlAux, true, JSON.stringify({ 'modelo': self.PreencheModeloServicos(), 'servico': self.SubServicoRetorna(self.GetServicoActivo())[0], 'objfiltro': objetoFiltro }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    var data = [];
                    var hdsn;

                    if (res.IDTipoServico === TipoServico.Contacto) {
                        data = $.grep(res.DocumentosVendasLinhas, function (obj, i) {
                            return obj.IDTipoGraduacao === TipoGraduacao.LentesContato && (obj.IDTipoOlho === TipoOlho.Direito || obj.IDTipoOlho === TipoOlho.Esquerdo) || obj.IDTipoOlho == 0;
                        });
                        hdsn = window.HotRegisterer.bucket[constHdsnLentes];
                        hdsn.loadData(data);
                    } else if (res.IDTipoServico === TipoServico.Longe ||
                        res.IDTipoServico === TipoServico.ProgressivaAmbos || res.IDTipoServico === TipoServico.ProgressivaOlhoDireito || res.IDTipoServico === TipoServico.ProgressivaOlhoEsquerdo ||
                        res.IDTipoServico === TipoServico.BifocalAmbos || res.IDTipoServico === TipoServico.BifocalOlhoDireito || res.IDTipoServico === TipoServico.BifocalOlhoEsquerdo) {
                        data = $.grep(res.DocumentosVendasLinhas, function (obj, i) {
                            return obj.IDTipoGraduacao === TipoGraduacao.Longe || obj.IDTipoOlho == 0;
                        });
                        hdsn = window.HotRegisterer.bucket[constHdsnLonge];
                        hdsn.loadData(data);
                    } else if (res.IDTipoServico === TipoServico.Perto) {
                        data = $.grep(res.DocumentosVendasLinhas, function (obj, i) {
                            return obj.IDTipoGraduacao === TipoGraduacao.Perto || obj.IDTipoOlho == 0;
                        });
                        hdsn = window.HotRegisterer.bucket[constHdsnPerto];
                        hdsn.loadData(data);
                    } else if (res.IDTipoServico === TipoServico.LongePerto) {
                        data = $.grep(res.DocumentosVendasLinhas, function (obj, i) {
                            return obj.IDTipoGraduacao === TipoGraduacao.Longe || obj.IDTipoOlho == 0;
                        });
                        hdsn = window.HotRegisterer.bucket[constHdsnLonge];
                        hdsn.loadData(data);

                        data = $.grep(res.DocumentosVendasLinhas, function (obj, i) {
                            return obj.IDTipoGraduacao === TipoGraduacao.Perto || obj.IDTipoOlho == 0;
                        });
                        hdsn = window.HotRegisterer.bucket[constHdsnPerto];
                        hdsn.loadData(data);
                    } else {
                        data = $.grep(res.DocumentosVendasLinhas, function (obj, i) {
                            return obj.IDTipoGraduacao === TipoGraduacao.Longe && (obj.IDTipoOlho === TipoOlho.Direito || obj.IDTipoOlho === TipoOlho.Esquerdo || obj.IDTipoOlho === TipoOlho.Aro) || obj.IDTipoOlho == 0;
                        });
                    }

                    $.map(ModeloServico.Servicos, function (obj, i) {
                        if (obj.ID === res.ID) {
                            ModeloServico.Servicos[i] = res;
                        }
                    });

                    self.Calcula(null, null, null, true, null, null);
                }
            }, function (e) { throw e; }, 1, true);
    };

    /*@description Funcao de debounce c/ timer de 250 ms */
    self.ReplaceExecuteFunction = function (hdsn) {
        var timer;

        return function (hdsn) {
            clearTimeout(timer);
            timer = setTimeout(function () {

                self.Calcula(null, hdsn, null, true, null, null);

                clearTimeout(timer);
            }, 250);
        };
    }();

    /*@description funcao retorna propiedades para a modal */
    self.RetornaObjData = function () {
        var objData = new Object();
        objData[campoIDEnti] = $("#" + campoIDEnti).val();
        objData.Modo = "0";

        return objData;
    };

    //TODO
    self.InativaCamposViaEstado = function (inInativa) {
        if (inInativa) {
            $('#ServicosBts a').addClass('disabled');
            $('#dropdownMenuImport').addClass('disabled');
            $('#divLimparTransposicao span').addClass('disabled');
            $('td a:not(.clsF3MHistorico)').addClass('disabled');
        }
        else {
            $('#divLimparTransposicao span').removeClass('disabled');
            $('td a:not(.clsF3MHistorico)').removeClass('disabled');
            self.EnableOrDisableBtRemoverServico();
        }
        DisableViaEstado = inInativa;

        KendoDesativaElemento('spnCopiaEsquerdaO', inInativa);
        KendoDesativaElemento('spnCopiaDireitaO', inInativa);

        //
        $('#' + btnSubstituicaoArtigos).removeClass('disabled');
    };

    /* @description funcao que ativa o DIRTY */
    self.AtivaDirty = function () {
        GrelhaFormAtivaDesativaBotoesAcoes("F3MGrelhaFormDocumentosVendasServicos", true);
    };

    self.PreencheImportacao = function (dataItem) {
        var sv = ModeloServico.Servicos.filter(function (f) { return f.ID === self.GetServicoActivo(); })[0];

        if (UtilsVerificaObjetoNotNullUndefinedVazio(dataItem.LOD_OBS)) {
            $('#Observacoes').val(dataItem.LOD_OBS).change();
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(dataItem.IDMedicoTecnico)) {
            self.PreencheMedicoTecnico(dataItem.IDMedicoTecnico, dataItem.DescricaoMedicoTecnico);
            self.SetValorCampoObj(ModeloServico.Servicos, "IDMedicoTecnico", dataItem.IDMedicoTecnico, self.GetServicoActivo());
            self.SetValorCampoObj(ModeloServico.Servicos, "DescricaoMedicoTecnico", dataItem.DescricaoMedicoTecnico, self.GetServicoActivo());
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(dataItem.DataExame)) {
            var dt = new Date(dataItem.DataExame).toJSON();
            dt = UtilsConverteJSONDate(dt, constJSONDates.ConvertToDDMMAAAA);

            self.SetValorCampoObj(ModeloServico.Servicos, "DataReceita", dt, self.GetServicoActivo());
            var elemDataReceita = KendoRetornaElemento($("#DataReceita"));
            elemDataReceita.value(dt);
        }

        self.AtualizaLabelGraduacoes();

        if (sv.IDTipoServico === TipoServico.Contacto) {
            // Esfera
            $('.TabLentes .TabOlhoDireito.PotenciaEsferica').val(dataItem.LOD_ESF);
            $('.TabLentes .TabOlhoEsquerdo.PotenciaEsferica').val(dataItem.LOE_ESF);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.LentesContato, "PotenciaEsferica", dataItem.LOD_ESF);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.LentesContato, "PotenciaEsferica", dataItem.LOE_ESF);

            // Cilindro
            $('.TabLentes .TabOlhoDireito.PotenciaCilindrica').val(dataItem.LOD_CIL);
            $('.TabLentes .TabOlhoEsquerdo.PotenciaCilindrica').val(dataItem.LOE_CIL);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.LentesContato, "PotenciaCilindrica", dataItem.LOD_CIL);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.LentesContato, "PotenciaCilindrica", dataItem.LOE_CIL);

            // Eixo
            $('.TabLentes .TabOlhoDireito.Eixo').val(dataItem.LOD_AX);
            $('.TabLentes .TabOlhoEsquerdo.Eixo').val(dataItem.LOE_AX);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.LentesContato, "Eixo", dataItem.LOD_AX);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.LentesContato, "Eixo", dataItem.LOE_AX);


            // Diametro - FALTA PROCURAR CAMPO
            //$('.TabLentes .TabOlhoDireito').val(dataItem.LOD_DIAM);
            //$('.TabLentes .TabOlhoEsquerdo').val(dataItem.LOE_DIAM);
            //self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "Diametro", dataItem.LOD_DIAM);
            //self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "Diametro", dataItem.LOE_DIAM);

            // Raio
            $('.TabLentes .TabOlhoDireito.RaioCurvatura').val(dataItem.LOD_RAIO);
            $('.TabLentes .TabOlhoEsquerdo.RaioCurvatura').val(dataItem.LOE_RAIO);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "RaioCurvatura", dataItem.LOD_RAIO);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "RaioCurvatura", dataItem.LOE_RAIO);


            // Adicao
            $('.TabLentes .TabOlhoDireito.Adicao').val(dataItem.LOD_ADD);
            $('.TabLentes .TabOlhoEsquerdo.Adicao').val(dataItem.LOE_ADD);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "Adicao", dataItem.LOD_ADD);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "Adicao", dataItem.LOE_ADD);

            //trigger blur
            $('.TabLentes .TabOlhoDireito.RaioCurvatura').blur();
        }
        else {
            // Esfera
            $('.TabLonge .TabOlhoDireito.PotenciaEsferica').val(dataItem.LOD_ESF);
            $('.TabLonge .TabOlhoEsquerdo.PotenciaEsferica').val(dataItem.LOE_ESF);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "PotenciaEsferica", dataItem.LOD_ESF);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "PotenciaEsferica", dataItem.LOE_ESF);

            // Cilindro
            $('.TabLonge .TabOlhoDireito.PotenciaCilindrica').val(dataItem.LOD_CIL);
            $('.TabLonge .TabOlhoEsquerdo.PotenciaCilindrica').val(dataItem.LOE_CIL);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "PotenciaCilindrica", dataItem.LOD_CIL);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "PotenciaCilindrica", dataItem.LOE_CIL);

            // Eixo
            $('.TabLonge .TabOlhoDireito.Eixo').val(dataItem.LOD_AX);
            $('.TabLonge .TabOlhoEsquerdo.Eixo').val(dataItem.LOE_AX);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "Eixo", dataItem.LOD_AX);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "Eixo", dataItem.LOE_AX);

            // Adicao
            $('.TabLonge .TabOlhoDireito.Adicao').val(dataItem.LOD_ADD);
            $('.TabLonge .TabOlhoEsquerdo.Adicao').val(dataItem.LOE_ADD);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "Adicao", dataItem.LOD_ADD);
            self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "Adicao", dataItem.LOE_ADD);


            // PRISM - FALTA PROCURAR CAMPO
            if ($('.TabLonge .TabOlhoDireito.PotenciaPrismatica').is(':visible')) {
                $('.TabLonge .TabOlhoDireito.PotenciaPrismatica').val(dataItem.LOD_PRISM);
                $('.TabLonge .TabOlhoEsquerdo.PotenciaPrismatica').val(dataItem.LOE_PRISM);
                self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Direito, TipoGraduacao.Longe, "PotenciaPrismatica", dataItem.LOD_PRISM);
                self.AtualizaObjGraduacoes(ModeloServico.Servicos, TipoOlho.Esquerdo, TipoGraduacao.Longe, "PotenciaPrismatica", dataItem.LOE_PRISM);
            }

            //trigger blur
            $('.TabLonge .TabOlhoDireito.PotenciaEsferica').blur();
            $('.TabLonge .TabOlhoEsquerdo.PotenciaEsferica').blur();
        }
    };

    self.PreencheImportacaoSubservico = function (dataItem) {
        let idServicoAtivo = self.GetServicoActivo();
        var sv = ModeloServico.Servicos.filter(function (f) { return f.ID === idServicoAtivo })[0];

        if (dataItem.Observacoes) {
            $('#Observacoes').val(dataItem.Observacoes).change();
        }

        if (dataItem.IDMedicoTecnico > 0) {
            self.PreencheMedicoTecnico(dataItem.IDMedicoTecnico, dataItem.DescricaoMedicoTecnico);
            self.SetValorCampoObj(ModeloServico.Servicos, "IDMedicoTecnico", dataItem.IDMedicoTecnico, idServicoAtivo);
            self.SetValorCampoObj(ModeloServico.Servicos, "DescricaoMedicoTecnico", dataItem.DescricaoMedicoTecnico, idServicoAtivo);
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(dataItem.DataReceita)) {
            var dt = new Date(dataItem.DataReceita).toJSON();
            dt = UtilsConverteJSONDate(dt, constJSONDates.ConvertToDDMMAAAA);

            self.SetValorCampoObj(ModeloServico.Servicos, "DataReceita", dt, idServicoAtivo);
            var elemDataReceita = KendoRetornaElemento($("#DataReceita"));
            elemDataReceita.value(dt);
        }

        self.AtualizaLabelGraduacoes();

        self.AtualizaGraduacoesImportadasSubservico(dataItem.GraduacoesImportacao);
    };

    self.AtualizaGraduacoesImportadasSubservico = function (lstGraduacoes) {
        for (let i = 0, len = lstGraduacoes.length; i < len; i++) {
            let linhaGraduacao = lstGraduacoes[i];

            let olhoTab = linhaGraduacao.IDTipoOlho === TipoOlho.Direito ? 'TabOlhoDireito' : 'TabOlhoEsquerdo';
            let tipoGraduacaoTab;
            let lstProps;

            if (linhaGraduacao.IDTipoGraduacao === TipoGraduacao.LentesContato) {
                tipoGraduacaoTab = 'TabLentes';
                lstProps = ["RaioCurvatura", "DetalheRaio", "PotenciaEsferica", "PotenciaCilindrica", "Eixo", "Adicao", "AcuidadeVisual"];
            } else {
                switch (linhaGraduacao.IDTipoGraduacao) {
                    case TipoGraduacao.Longe:
                        tipoGraduacaoTab = 'TabLonge';
                        break;
                    case TipoGraduacao.Intermedio:
                        tipoGraduacaoTab = 'TabInt';
                        break;
                    case TipoGraduacao.Perto:
                        tipoGraduacaoTab = 'TabPerto';
                        break;
                }

                lstProps = ["PotenciaEsferica", "PotenciaCilindrica", "Eixo", "Adicao", "DNP", "Altura",
                    "PotenciaPrismatica", "BasePrismatica", "AcuidadeVisual", "AnguloPantoscopico", "DistanciaVertex"];
            }

            for (let j = 0, lenProps = lstProps.length; j < lenProps; j++) {
                let prop = lstProps[j];

                $('.' + tipoGraduacaoTab + ' .' + olhoTab + '.' + prop).val(linhaGraduacao[prop]);
                self.AtualizaObjGraduacoes(ModeloServico.Servicos, linhaGraduacao.IDTipoOlho, linhaGraduacao.IDTipoGraduacao, prop, linhaGraduacao[prop]);
            }
        }
    };

    /* @description funcao que retorna as grelhas quando os calculos sao efetuados a partir da entidade */
    self.RetornaGrelhasCalculoEntidade = function (inRes) {
        //get tab ativa
        var _tabAtiva = $('.clsF3MTabs [role=presentation] > a.active').attr('href').replace('#', '');
        //get grid
        var grid = null;

        switch (_tabAtiva) {
            case 'tabServicos':
                //get servico
                var _servico = $.grep(inRes.Servicos, (x) => x.ID === self.GetServicoActivo())[0];
                switch (_servico.IDTipoServico) {
                    case TipoServico.LongePerto:
                        //set grids
                        grid = [HotRegisterer.bucket[constHdsnLonge], HotRegisterer.bucket[constHdsnPerto]];
                        break;

                    case TipoServico.Contacto:
                        //set grid
                        grid = HotRegisterer.bucket[constHdsnLentes];
                        break;

                    default:
                        //set grid
                        grid = HotRegisterer.bucket[constHdsnLonge];
                }

                break;

            case 'tabArtigos':
                //set grid
                grid = HotRegisterer.bucket[constHdsnArtigos];
                break;

            default:
                //set globald ds
                ModeloServico.Servicos = inRes.Servicos;
                ModeloServico.Diversos = inRes.Diversos;
        }
        //return grid /// grids
        return grid;
    };


    /* @description Funcao que a substituicao de artigos */
    self.GeraSubstituicaoArtigos = function () {
        var id = self.GetServicoActivo();
        var servico = $.grep(ModeloServico.Servicos, (servico) => servico.ID == id)[0];

        var artigos = $.grep(servico.DocumentosVendasLinhas, (artigo) => artigo['CodigoArtigo']).length;
        if (artigos === 0) {
            return UtilsNotifica(base.constantes.tpalerta.warn, "Não existem artigos para substituir."); //TODO resx
        }

        var _url = 'Documentos/DocumentosVendasServicosSubstituicao';
        var _tabnome = 'Documentos de Substituição', _tabicon = 'f3icon-troca-artigos';

        if (servico.IDDocumentosVendasServicosSubstituicaoArtigos) {
            //edita
            UtilsAbreTab(_url + '?IDDrillDown=' + servico.IDDocumentosVendasServicosSubstituicaoArtigos, _tabnome, _tabicon, null, null, null);
        }
        else {
            //adiciona
            sessionStorage.setItem('AdicionaEsp', rootDir + _url + '/AdicionaEsp?IDServico=' + id);
            UtilsAbreTab(_url, _tabnome, _tabicon, null, constEstados.Adicionar, null);
        }
    };

    self.LimiteMaxDesconto = function () {
        var limiteMaxDesconto = 0;
        if (UtilsVerificaObjetoNotNullUndefinedVazio($('#LimiteMaxDesconto'))) {
            limiteMaxDesconto = $('#LimiteMaxDesconto').val();
        }
        return limiteMaxDesconto > 0;
    };


    return parent;

}($servicos || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var ServicosInit = $servicos.ajax.Init;
var ServicosEnviaParametrosArtigos = $servicos.ajax.EnviaParametrosArtigos;
var ServicosMedicoTecnicoEnviaParametros = $servicos.ajax.MedicoTecnicoEnviaParametros;
var ServicosMedicoTecnicoChange = $servicos.ajax.MedicoTecnicoChange;
var ServicosRetornaColunasHT = $servicos.ajax.RetornaColunasHT;
var ServicosCalculaDescontoGlobal = $servicos.ajax.CalculaDescontoGlobal;
var ServicosSetSelectedHT = $servicos.ajax.SetSelectedHT;
var ModeloServico = $servicos.ajax.ModeloServico;
var ServicosRetornaHT = $servicos.ajax.RetornaSelectedHT;
var ServicosHistoricoExpandeFoles = $servicos.ajax.ExpandeFoles;
var ServicosDataBoundModelo = $servicos.ajax.DataBoundModelo;
var ServicosRetornaModelo = $servicos.ajax.PreencheModeloServicos;
//cabecalho
var CabecalhoChangeEntidade = $servicos.ajax.ChangeEntidade;
var CabecalhoTrataInformacaoEntidade = $servicos.ajax.TrataInformacaoEntidade;
var CabecalhoChangeMoeda = $servicos.ajax.ChangeMoeda;
//botoes lado direito e historico
var ServicosAbreDocumentoVendaAssociadoFromHistorico = $servicos.ajax.AbreDocumentoVendaAssociadoFromHistorico;
var ServicosCliquePagamentos = $servicos.ajax.CliquePagamentos;
var ServicosAbreAdiantamentos = $servicos.ajax.AbreAdiantamentos;
var ServicosAbreRecebimentos = $servicos.ajax.AbreRecebimentos;

// importacao 
var ServicosPreencheImportacao = $servicos.ajax.PreencheImportacao;
var ServicosPreencheImportacaoSubservico = $servicos.ajax.PreencheImportacaoSubservico;

$(document).ready(function (e) {
    ServicosInit();
});


$(document).ajaxSend(function (inEvent, jqxhr, inSettings) {
    var request = inSettings['url'];

    if (request.indexOf('CrudFasesAndRefreshHistory') === -1) {
        var requestsBarLoding = ['Calcula'];
        requestsBarLoding.push('CatalogosLentes/ListaCombo', 'ListaArtigosComboCodigo/ListaCombo', 'Campanhas/ListaCombo');
        var selectedHT = $servicos.ajax.RetornaSelectedHT();
        var idelem;

        if (UtilsVerificaObjetoNotNullUndefinedVazio(selectedHT)) {
            idelem = $(selectedHT.rootElement).parent().attr('data-id-bar-loading');
        }
        KendoBarLoading(null, inSettings, requestsBarLoding, idelem);
    }

}).ajaxStop(function () {
    if (!$('#ulServicos .Waiting').length) {
        var elem = $('#iframeBody');
        var selectedHT = $servicos.ajax.RetornaSelectedHT();
        var idelem;

        if (UtilsVerificaObjetoNotNullUndefinedVazio(selectedHT)) {
            idelem = $(selectedHT.rootElement).parent().attr('data-id-bar-loading');
        }
        KendoLoading(elem, false, true, idelem);
    }
});