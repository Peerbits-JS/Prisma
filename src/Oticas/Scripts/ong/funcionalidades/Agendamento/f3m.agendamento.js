"use strict";
var $Agendamento = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};
    var constEstados = base.constantes.EstadoFormEAcessos;
    var constCamposGen = base.constantes.camposGenericos;
    var constCamposOF = base.constantes.camposObjetoFiltro;

    var schedulerClass = ".k-scheduler";
    var confirmouPlaneamento = false;
    var passouInit = false;
    var scrolling = false;

    self.DataSourcePlanificacao = [];
    self.IDsMedicosExistentes = [];

    self.schedulerEventEditEspecifico = function (e) {
        var evento = e.event;
        var startDate = new Date(evento.start);
        var endDate = new Date(evento.end);

        KendoRetornaElemento($('#Start')).value(startDate);
        KendoRetornaElemento($('#End')).value(endDate);

        var cmbLojaC = KendoRetornaElemento($('#IDLojaC'));
        var cmbEspecialidadeC = KendoRetornaElemento($('#IDEspecialidadeC'));
        var cmbMedicoTecnicoC = KendoRetornaElemento($('#IDMedicoTecnicoC'));

        var cmbLoja = KendoRetornaElemento($('#IDLoja'));
        var cmbEspecialidade = KendoRetornaElemento($('#IDEspecialidade'));
        var cmbMedicoTecnico = KendoRetornaElemento($('#IDMedicoTecnico'));
        var cmbCliente = KendoRetornaElemento($('#IDCliente'));

        if (evento.ID > 0) {  /* EDITA */
            if (evento.IDLoja > 0) {
                cmbLoja.value(evento.IDLoja);
                $($(cmbLoja.element).parent().find('.clsF3MInput:last')[0]).attr('value', evento.IDLoja);
                ComboBoxAtivaDesativaDrillDown([$(cmbLoja.element).attr('id')]);
            }

            if (evento.IDEspecialidade > 0) {
                cmbEspecialidade.value(evento.IDEspecialidade);
            }

            if (evento.IDMedicoTecnico > 0) {
                cmbMedicoTecnico.value(evento.IDMedicoTecnico);
                $($(cmbMedicoTecnico.element).parent().find('.clsF3MInput:last')[0]).attr('value', evento.IDMedicoTecnico);
                ComboBoxAtivaDesativaDrillDown([$(cmbMedicoTecnico.element).attr('id')]);
            }

            if (evento.IDCliente > 0) {
                cmbCliente.value(evento.IDCliente);
                $($(cmbCliente.element).parent().find('.clsF3MInput:last')[0]).attr('value', evento.IDCliente);
                ComboBoxAtivaDesativaDrillDown([$(cmbCliente.element).attr('id')]);
            }

            /* Adiciona botao para abrir consulta */
            let medTecVal = $('#IDMedicoTecnicoUtilizador').val();
            if (evento.IDMedicoTecnico !== null && medTecVal !== null && evento.IDMedicoTecnico === medTecVal) {
                $('div.k-edit-buttons.k-state-default').append('<a id="btnConsulta" class="k-button" href="#">Ir para a consulta</a>');

                $('#btnConsulta').on('click', function () {
                    self.AbreConsulta(evento);
                });
            }
        } else { /* ADICIONA */
            if (cmbLojaC.value() !== "") {
                cmbLoja.value(cmbLojaC.value());
            }
            if (cmbEspecialidadeC.selectedIndex > 0) {
                cmbEspecialidade.value(cmbEspecialidadeC.value());
            }
            if (cmbMedicoTecnicoC.value() !== "") {
                cmbMedicoTecnico.value(cmbMedicoTecnicoC.value());
                if (cmbEspecialidadeC.selectedIndex <= 0) {
                    cmbEspecialidade.value(1);
                }
            }
        }

        $('#Start, #End').on('change', function (e) {
            var inicio = KendoRetornaElemento($("#Start"));
            var fim = KendoRetornaElemento($("#End"));

            if (inicio.value() > fim.value()) {
                $(e.currentTarget).removeClass('k-valid').addClass('k-invalid');

                KendoColocaOuRetiraClasseInvalida($(e.currentTarget));
            } else {
                inicio.element.removeClass('k-invalid').addClass('k-valid');
                fim.element.removeClass('k-invalid').addClass('k-valid');
                KendoColocaOuRetiraClasseInvalida(inicio.element);
                KendoColocaOuRetiraClasseInvalida(fim.element);
            }

            // PDC 28/05/2019 - ao selecionar a data de inicio, a data de fim mantem-se sempre com o intervalo de 30 minutos
            let targetID = e.currentTarget.id;
            if (targetID === 'Start') {
                let acertaDataFim = inicio.value().getTime() + 1800000; // 1800000 miliseconds === 30 minutes
                acertaDataFim = new Date(acertaDataFim);
                fim.value(acertaDataFim);
            } else if (targetID === "End" && inicio.value() > fim.value()) {
                let acertaDataInicio = fim.value().getTime() - 1800000;
                acertaDataInicio = new Date(acertaDataInicio);
                inicio.value(acertaDataInicio);
            }
        });

        if ($(window).height() < 768) {
            $('[data-uid="' + evento.uid + '"].k-window-content').data('kendoWindow').bind('open', () => {
                $('.grelhaform-content').offset({ top: 0, left: 0 });
            });
        }
    };

    self.schedulerEventSaveEspecifico = function (e) {
        if (e.container && e.container.hasClass('k-scheduler-edit-form')) {
            var validator = $(".ValidaForm").kendoValidator({
                rules: {
                    greaterdate: function (input) {
                        if ($(input).is(':visible')) {
                            if ($(input).data('role') === "datetimepicker") {
                                return KendoRetornaElemento($('#Start')).value() < KendoRetornaElemento($('#End')).value();
                            } else {
                                return KendoRetornaElemento($('#Start')).value() <= KendoRetornaElemento($('#End')).value();
                            }
                        }
                        return true;
                    }
                }
            }).data("kendoValidator");

            if (!validator.validate()) {
                validator.hideMessages();
                e.preventDefault();
                return false;
            }

            e.event.IDLoja = KendoRetornaElemento($('#IDLoja')).value();
            e.event.IDEspecialidade = KendoRetornaElemento($('#IDEspecialidade')).value();
            e.event.IDMedicoTecnico = KendoRetornaElemento($('#IDMedicoTecnico')).value();
            e.event.Nome = $('#Nome').val();
            e.event.IDCliente = KendoRetornaElemento($('#IDCliente')).value();
            e.event.Contacto = $('#Contacto').val();
            e.event.Observacoes = $('#Observacoes').val();
            e.event.title = e.event.title.length ? e.event.title : KendoRetornaElemento($('#IDCliente')).text().length ? KendoRetornaElemento($('#IDCliente')).text() : $('#Nome').val();
            e.event.start = KendoRetornaElemento($('#Start')).value();
            e.event.end = KendoRetornaElemento($('#End')).value();
            e.event.isAllDay = $('#isAllDay').prop('checked');

            if (!confirmouPlaneamento) {
                var planeamento = self.ValidaSeTemPlaneamento(e.event);
                var marcacao = self.ValidaSeTemMarcacoes(e.sender, e.event);
                /* TODO MARCACOES*/
                var dtItemMedicoTecnico = KendoRetornaElemento($('#IDMedicoTecnico')).dataItem();
                if (marcacao !== 0) {
                    if (planeamento === 0 && dtItemMedicoTecnico) {
                        if (dtItemMedicoTecnico.IDSistemaAcoes === 2) {
                            e.preventDefault();
                            UtilsConfirma(base.constantes.tpalerta.question, resources.PlanificacaoNaoTemDisponibilidade, function () {
                                confirmouPlaneamento = true;
                                e.event.dirty = true;
                                var scheduler = $(schedulerClass).getKendoScheduler();
                                scheduler.saveEvent();
                            }, function () {
                                return false;
                            });
                            return false;
                        } else if (dtItemMedicoTecnico.IDSistemaAcoes === 3) {
                            e.preventDefault();
                            UtilsAlerta(base.constantes.tpalerta.i, resources.PlanificacaoNaoTemDisponibilidadeNaoContinua);
                            return false;
                        }
                    }
                } else {
                    UtilsAlerta(base.constantes.tpalerta.i, resources.MarcacoesJaExistemMarcacoesNestaHora);
                    e.preventDefault();
                    return false;
                }
            }
        }
    };

    self.schedulerEventDataBoundEspecifico = function (e) {
        if (!constIsSafari) {
            self.schedulerTooltip();
        }
        self.AtualizaValoresFiltros();

        self.resizeArea();
        self.ajusteCalendarioCurrentView();
        //self.PassouPrimeiroDB();
        confirmouPlaneamento = false;

        let kendoEventsDS = $(schedulerClass).getKendoScheduler().dataSource;
        let eventsData = kendoEventsDS.data();
        if (eventsData.length && $(eventsData).last()[0].id === 0 && $(eventsData).last()[0].IDLoja !== null) {
            $('#dvAgendamento .clsBtRefresh').click();
        }

        // PDC - Behaviour on mobile (IPAD)
        if (constIsSafari) {
            self.mobileSchedulerBehaviour();
        }
    };

    self.resizeArea = function () {
        let areaWidth = $('.area-side-bars').width();
        if (areaWidth < 500) {
            $('.k-scheduler-navigation').css('width', '100%');
            $('.k-nav-current').addClass("centrar-titulo");
        } else {
            $('.k-scheduler-navigation').css('width', '');
            $('.k-nav-current').removeClass("centrar-titulo");
        }
        if (areaWidth <= 650) {
            $('.k-sm-date-format').css('cssText', 'display: inline !important');
            $('.k-lg-date-format').css('cssText', 'display: none !important');
        } else {
            $('.k-sm-date-format').css('cssText', 'display: none !important');
            $('.k-lg-date-format').css('cssText', 'display: inline !important');
        }
    };

    self.ajusteCalendarioCurrentView = function () {
        if (!constIsMobile) {
            if ($('.area-side-bars').width() >= 880) {
                $('.k-webkit .k-scheduler-toolbar>ul.k-scheduler-views>li:not(.k-current-view)').css('display', 'inline-block');
                $('.k-scheduler-toolbar>ul.k-scheduler-views>li.k-current-view').css('display', 'none');
            } else {
                $('.k-webkit .k-scheduler-toolbar>ul.k-scheduler-views>li:not(.k-current-view)').css('display', 'none');
                $('.k-scheduler-toolbar>ul.k-scheduler-views>li.k-current-view').css('display', 'block');
            }
        }
    };

    self.schedulerEventParseEspecifico = function (data) {
        if (data && data.Data2) {
            var IDsMedicosExistentes = [];
            for (var i = 0; i < data.Data2.Data.length; i++) {
                let dataIndex = data.Data2.Data[i];
                dataIndex.Start = new Date(parseInt(dataIndex.Start.substr(6)));
                dataIndex.End = new Date(parseInt(dataIndex.End.substr(6)));

                if (dataIndex.ListaOcorrencias) {
                    for (var k = 0; k < dataIndex.ListaOcorrencias.length; k++) {
                        dataIndex.ListaOcorrencias[k].Start = new Date(parseInt(dataIndex.ListaOcorrencias[k].Start.substr(6)));
                        dataIndex.ListaOcorrencias[k].End = new Date(parseInt(dataIndex.ListaOcorrencias[k].End.substr(6)));
                    }
                }
                if (IDsMedicosExistentes.indexOf(dataIndex.IDMedicoTecnico) < 0) { IDsMedicosExistentes.push(dataIndex.IDMedicoTecnico); }
            }
            DSP = data.Data2.Data;
            IDME = IDsMedicosExistentes;
        }
    };

    self.schedulerMoveEndEspecifico = function (e) {
        if (!confirmouPlaneamento) {
            var planeamento = self.ValidaSeTemPlaneamento(e.event);
            var marcacao = self.ValidaSeTemMarcacoes(e.sender, e.event);
            /* TODO MARCACOES*/
            if (marcacao !== 0) {
                if (planeamento === 0) {
                    if (e.event.IDSistemaAcaoMedico === 2) {
                        e.preventDefault();
                        UtilsConfirma(base.constantes.tpalerta.question, resources.PlanificacaoNaoTemDisponibilidade, function () {
                            confirmouPlaneamento = true;
                            e.event.dirty = true;
                            e.event.start = e.start;
                            e.event.end = e.end;
                            var scheduler = $(schedulerClass).getKendoScheduler();
                            scheduler.dataSource.sync();
                        }, function () {
                            return false;
                        });
                        return false;
                    } else if (e.event.IDSistemaAcaoMedico === 3) {
                        e.preventDefault();
                        UtilsAlerta(base.constantes.tpalerta.i, resources.PlanificacaoNaoTemDisponibilidadeNaoContinua);
                        return false;
                    }
                }
            } else {
                UtilsAlerta(base.constantes.tpalerta.i, resources.MarcacoesJaExistemMarcacoesNestaHora);
                e.preventDefault();
                return false;
            }
        }
    };

    self.schedulerTemplateSlotEspecifico = function (e) {
        var strHtml = "<div style='height: calc(100% + 6px); width: 100%; margin-top: -3px;'>";

        if (IDME.length) {
            var w = Math.floor(100 / IDME.length);
            var cmbLojaC = KendoRetornaElemento($('#IDLojaC'));
            var cmbEspecialidadeC = KendoRetornaElemento($('#IDEspecialidadeC'));
            var cmbMedicoTecnicoC = KendoRetornaElemento($('#IDMedicoTecnicoC'));

            if (!(!cmbMedicoTecnicoC.dataItem() && !cmbLojaC.dataItem() && cmbEspecialidadeC.selectedIndex === 0)) {
                for (var j = 0; j < IDME.length; j++) {
                    var cor = '#fff', title = '';
                    
                    for (var i = 0; i < DSP.length; i++) {
                        if (DSP[i].ListaOcorrencias && DSP[i].ListaOcorrencias.length) {

                            if ($.grep(DSP[i].ListaOcorrencias, function (n, i) { return e.date >= n.Start && e.date < n.End && n.IDMedicoTecnico === IDME[j]; }).length) {
                                cor = DSP[i].Cor;
                                title = DSP[i].DescricaoMedicoTecnico;

                                if (cmbMedicoTecnicoC.dataItem() && cmbMedicoTecnicoC.value().length === 1 && !cmbLojaC.dataItem()) {
                                    /* VER ISTO COM PC - CORES DE FUNDO DAS DISPONIBILIDADES */
                                    //&& (cmbLojaC.dataItem() == undefined || (cmbLojaC.dataItem() != undefined && cmbLojaC.value().length > 1))) {
                                    cor = DSP[i].CorLoja;
                                    title = DSP[i].DescricaoLoja;
                                }
                            }
                        } else {
                            if (e.date >= DSP[i].Start && e.date < DSP[i].End && DSP[i].IDMedicoTecnico === IDME[j]) {
                                cor = DSP[i].Cor;
                                title = DSP[i].DescricaoMedicoTecnico;

                                if (cmbMedicoTecnicoC.dataItem() && cmbMedicoTecnicoC.value().length === 1 && !cmbLojaC.dataItem()) {
                                    /* VER ISTO COM PC - CORES DE FUNDO DAS DISPONIBILIDADES */
                                    //&& (cmbLojaC.dataItem() == undefined || (cmbLojaC.dataItem() != undefined && cmbLojaC.value().length > 1))) {
                                    cor = DSP[i].CorLoja;
                                    title = DSP[i].DescricaoLoja;
                                }
                            }
                        }
                    }
                    strHtml = strHtml + "<div style='opacity:0.3; background:" + cor + "; width: " + w + "%; height: 100%; float: left;' title='" + title + "'></div>";
                }
            }
        }

        strHtml = strHtml + "</div>";

        return strHtml;
    };

    self.ChangeResources = function () {
        var boolTrocaResources = false;
        var scheduler = $(schedulerClass).getKendoScheduler();

        var cmbLojaC = KendoRetornaElemento($('#IDLojaC'));
        var cmbMedicoTecnicoC = KendoRetornaElemento($('#IDMedicoTecnicoC'));

        if (cmbMedicoTecnicoC.dataItem() && cmbMedicoTecnicoC.value().length === 1 && !cmbLojaC.dataItem()) {
            if (scheduler.resources[0].field === "IDMedicoTecnico") {
                boolTrocaResources = true;
            }
        } else {
            if (scheduler.resources[0].field === "IDLoja") {
                boolTrocaResources = true;
            }
        }

        if (boolTrocaResources) {
            scheduler.resources.reverse();
            //scheduler.resources[0].dataSource.read();
            scheduler.view(scheduler.view().name);
            scheduler.refresh();
        }
    };

    self.readSchedule = () => { }

    self.schedulerTooltip = function () {
        /* remove tooltip existente e cria uma nova */
        $('div[role=tooltip]').parent().remove();

        $(schedulerClass).kendoTooltip({
            filter: ".k-event",
            position: 'top',
            width: 250,
            show: function () {
                KendoRemoveTitleEvento(this);
            },
            content: kendo.template($('#template').html())
        });
    };

    self.AbreConsulta = function (dataItem) {
        var IDMedicoTecnicoUtilizador = $('#IDMedicoTecnicoUtilizador').val();
        var _idAgendamento = dataItem.ID;
        var _url = 'Exames/Exames?DataMarcacao=' + UtilsConverteJSONDate('/Date(' + dataItem.start.getTime() + ')', 'DDMMAAAA');
        var tabnome = resources['Consultorio'], tabicon = 'f3icon-exames';

        if (IDMedicoTecnicoUtilizador !== null && IDMedicoTecnicoUtilizador === dataItem.IDMedicoTecnico) {
            sessionStorage.setItem('AdicionaEsp', rootDir + 'Exames/Exames' + '/AdicionaEsp?IDAgendamento=' + _idAgendamento + '&FromMarcacoes=True');
            UtilsAbreTab(_url, tabnome, tabicon, null, dataItem.IDConsulta ? constEstados.Alterar : constEstados.Adicionar, null);
        } else {
            UtilsConfirma(base.constantes.tpalerta.question, resources.MedicoUtilizadorDiferenteMedicoMarcacao, function () {
                sessionStorage.setItem('AdicionaEsp', rootDir + 'Exames/Exames' + '/AdicionaEsp?IDAgendamento=' + _idAgendamento + '&FromMarcacoes=True');

                UtilsAbreTab(_url, tabnome, tabicon, null, dataItem.IDConsulta ? constEstados.Alterar : constEstados.Adicionar, null);
            }, function () {
                return false;
            });
        }
    };

    /* FUNCOES AUXILIARES */
    self.ValidaSeTemPlaneamento = function (event) {
        var r = 0;

        if (DSP.length) {
            var DSPMedico = DSP.filter(function (f) {
                return f.IDMedicoTecnico === parseInt(event.IDMedicoTecnico);
            })[0];

            if (DSPMedico) {
                if (DSPMedico.ListaOcorrencias && DSPMedico.ListaOcorrencias.length) {
                    r = $.grep(DSPMedico.ListaOcorrencias, function (n, i) {
                        return n.IDMedicoTecnico === parseInt(event.IDMedicoTecnico) && (event.start >= n.Start && event.end <= n.End);
                    }).length;
                } else {
                    return event.start >= DSPMedico.Start && event.end <= DSPMedico.End;
                }
            }
        }

        return r;
    };

    self.ValidaSeTemMarcacoes = function (scheduler, event) {
        var r = 0;
        var ds = scheduler.dataSource.data();
        if (ds.length) {
            r = $.grep(ds, function (n, i) {
                return n.IDMedicoTecnico === event.IDMedicoTecnico && (event.start >= n.start && event.start < n.end);
            }).length;
        }
        return r;
    };

    self.AtualizaValoresFiltros = function () {
        try {
            $('#badgeLojas').text(KendoRetornaElemento($('#IDLojaC')).value().length);
            $('#badgeEspecialidades').text(KendoRetornaElemento($('#IDEspecialidadeC')).value().length);
            $('#badgeMedicosTecnicos').text(KendoRetornaElemento($('#IDMedicoTecnicoC')).value().length);
        } catch (ex) {
            alert(ex);
        }
    };

    self.removeTitleEvento = function (tt) {
        var divComTitle = tt.target().find('div[title]');
        if (divComTitle.length) {
            divComTitle.removeAttr('title');
        }
    };

    self.PassouPrimeiroDB = function () {
        if (!passouInit) {
            setTimeout(function () {
                $('li.k-state-default.k-view-week.k-state-selected').click();
            }, 100);
            passouInit = true;
        }
    };

    // PDC - Specific functions for IPAD
    self.mobileSchedulerBehaviour = () => {
        // Mapping of scheduler cells to set double click behaviour
        // Table header cells
        [...document.querySelectorAll('.k-scheduler-layout .k-scheduler-table.k-scheduler-header-all-day')]
            .map(i => {
                i.addEventListener('touchstart', self.touchstartHandler, true);
                i.addEventListener('touchend', self.touchendHandler, true);
                i.addEventListener('touchmove', self.touchmoveHandler, true);
            });
        // Table cells including td or div
        [...document.querySelectorAll('.k-scheduler-layout:not(.k-scheduler-agendaview) .k-scheduler-content > *')]
            .filter(elem => !elem.classList.contains('km-scroll-header') && !elem.classList.contains('k-current-time'))
            .map(i => {
                i.addEventListener('touchstart', self.touchstartHandler, true);
                i.addEventListener('touchend', self.touchendHandler, true);
                i.addEventListener('touchmove', self.touchmoveHandler, true);
            });
        // remove trash icons of already created events
        $('.k-scheduler-content > div[data-uid] .k-link.k-event-delete').remove();
    };

    self.touchmoveHandler = () => scrolling = true;

    self.touchstartHandler = () => scrolling = false;

    self.touchendHandler = e => {
        if (!scrolling) {
            KendoLoading($('#AreaGeral'), true);
            setTimeout(() => self.doubleclickHandler(e), 200); // timeout so we can see kendo loading
        }
    };

    self.doubleclickHandler = e => {
        let touch = e.changedTouches[0];
        let type = 'dblclick';

        let simulatedEvent = document.createEvent('MouseEvent');
        simulatedEvent.initMouseEvent(type, true, true, window, 1,
            touch.screenX, touch.screenY,
            touch.clientX, touch.clientY, false,
            false, false, false, 0, null);

        touch.target.dispatchEvent(simulatedEvent);
        // fix height of timeview's dropdown list
        let startTimeView = document.querySelector('#Start_timeview');
        let EndTimeView = document.querySelector('#End_timeview');

        if (!startTimeView.closest('.k-animation-container') || !EndTimeView.closest('.k-animation-container')) {
            document.querySelector('.k-picker-wrap span[aria-controls=Start_timeview]').addEventListener('click', () => {
                if (startTimeView.getAttribute('aria-hidden') === 'false') {
                    startTimeView.closest('.k-animation-container').style.height = '200px';
                }
            });
            document.querySelector('.k-picker-wrap span[aria-controls=End_timeview]').addEventListener('click', () => {
                if (EndTimeView.getAttribute('aria-hidden') === 'false') {
                    EndTimeView.closest('.k-animation-container').style.height = '200px';
                }
            });
        }
        //KendoLoading($('#AreaGeral'), false);
        e.preventDefault();
    };

    $(window).resize(function () {
        self.ajusteCalendarioCurrentView();
        self.resizeArea();

        $('.k-scheduler-views .k-link').on('click', function () {
            $('.k-state-default[style]').removeAttr('style');
        });
    });

    return parent;
}($Agendamento || {}, jQuery));

var KendoSchedulerEventEditEspecifico = $Agendamento.ajax.schedulerEventEditEspecifico;
var KendoSchedulerEventSaveEspecifico = $Agendamento.ajax.schedulerEventSaveEspecifico;
var KendoSchedulerEventDataBoundEspecifico = $Agendamento.ajax.schedulerEventDataBoundEspecifico;
var KendoSchedulerEventParseEspecifico = $Agendamento.ajax.schedulerEventParseEspecifico;
var KendoSchedulerMoveEndEspecifico = $Agendamento.ajax.schedulerMoveEndEspecifico;
var KendoSchedulerTemplateSlotEspecifico = $Agendamento.ajax.schedulerTemplateSlotEspecifico;
var KendoChangeResources = $Agendamento.ajax.ChangeResources;
var KendoRemoveTitleEvento = $Agendamento.ajax.removeTitleEvento;
var KendoSchedulerReadSchedule = $Agendamento.ajax.readSchedule;

var DSP = $Agendamento.ajax.DataSourcePlanificacao;
var IDME = $Agendamento.ajax.IDsMedicosExistentes;

$(document).ready(() => {
    ComboBoxAbrePopup();
});