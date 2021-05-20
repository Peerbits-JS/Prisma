'use strict';
var $Planificacao = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    const schedulerClass = '.k-scheduler';

    self.schedulerEventSaveEspecifico = function (e) {
        if (e.container && e.container.hasClass('k-scheduler-edit-form')) {
            var validator = $('.ValidaForm').kendoValidator({
                rules: {
                    greaterdate: function (input) {
                        if ($(input).is(':visible')) {
                            if ($(input).data('role') === 'datetimepicker') {
                                return KendoRetornaElemento($('#Start')).value() < KendoRetornaElemento($('#End')).value();
                            } else {
                                return KendoRetornaElemento($('#Start')).value() <= KendoRetornaElemento($('#End')).value();
                            }
                        }
                        return true;
                    }
                }
            }).data('kendoValidator');

            if (!validator.validate()) {
                e.preventDefault();
                return false;
            }

            e.event.IDLoja = KendoRetornaElemento($('#IDLoja')).value();
            e.event.IDMedicoTecnico = KendoRetornaElemento($('#IDMedicoTecnico')).value();
            e.event.title = 'Planeamento';
            //e.event.start = KendoRetornaElemento($('#Start')).value();
            //e.event.end = KendoRetornaElemento($('#End')).value();
            //e.event.isAllDay = $('#isAllDay').prop('checked');
        }
    };

    self.schedulerEventEditEspecifico = function (e) {
        var startDate = new Date(e.event.start);
        var endDate = new Date(e.event.end);

        KendoRetornaElemento($('#Start')).value(startDate);
        KendoRetornaElemento($('#End')).value(endDate);

        var cmbMedicoTecnicoC = KendoRetornaElemento($('#IDMedicoTecnicoC'));

        var cmbLoja = KendoRetornaElemento($('#IDLoja'));
        var cmbMedicoTecnico = KendoRetornaElemento($('#IDMedicoTecnico'));

        if (e.event.ID > 0) {  /* EDITA */
            if (e.event.IDLoja > 0) {
                cmbLoja.value(e.event.IDLoja);
                $($(cmbLoja.element).parent().find('.clsF3MInput:last')[0]).attr('value', e.event.IDLoja);
                ComboBoxAtivaDesativaDrillDown([$(cmbLoja.element).attr('id')]);
            }

            if (e.event.IDMedicoTecnico > 0) {
                cmbMedicoTecnico.value(e.event.IDMedicoTecnico);
                $($(cmbMedicoTecnico.element).parent().find('.clsF3MInput:last')[0]).attr('value', e.event.IDMedicoTecnico);
                ComboBoxAtivaDesativaDrillDown([$(cmbMedicoTecnico.element).attr('id')]);
            }
        } else { /* ADICIONA */
            if (cmbMedicoTecnicoC.selectedIndex > -1) {
                cmbMedicoTecnico.value(cmbMedicoTecnicoC.value());
            }
            // EDITA uma unica ocorrencia de uma serie
            if (e.event.IDLoja && e.event.IDMedicoTecnico) {
                // Preenche loja
                cmbLoja.value(e.event.IDLoja);
                $($(cmbLoja.element).parent().find('.clsF3MInput:last')[0]).attr('value', e.event.IDLoja);
                ComboBoxAtivaDesativaDrillDown([$(cmbLoja.element).attr('id')]);
                // Preenche MedicoTecnico
                cmbMedicoTecnico.value(e.event.IDMedicoTecnico);
                $($(cmbMedicoTecnico.element).parent().find('.clsF3MInput:last')[0]).attr('value', e.event.IDMedicoTecnico);
                ComboBoxAtivaDesativaDrillDown([$(cmbMedicoTecnico.element).attr('id')]);
            }
        }

        $('#Start, #End').on('change', function (e) {
            var inicio = KendoRetornaElemento($('#Start'));
            var fim = KendoRetornaElemento($('#End'));

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
            } else if (targetID === 'End' && inicio.value() > fim.value()) {
                let acertaDataInicio = fim.value().getTime() - 1800000;
                acertaDataInicio = new Date(acertaDataInicio);
                inicio.value(acertaDataInicio);
            }
        });

        var recEditor = $('div[name=recurrenceRule]').data('kendoRecurrenceEditor');

        recEditor.options.messages = {
            frequencies: {
                'never': 'Nunca',
                'daily': 'diário',
                'weekly': 'semanal',
                'monthly': 'mensal',
                'yearly': 'anual'
            },
            daily: {
                'repeatEvery': 'A cada:',
                'interval': 'dia(s)'
            },
            weekly: {
                'interval': 'semana(s)',
                'repeatEvery': 'A cada:',
                'repeatOn': 'Nos dias:'
            },
            monthly: {
                'repeatEvery': 'A cada:',
                'repeatOn': 'No(s):',
                'interval': 'mês(es)',
                'day': 'dia'
            },
            yearly: {
                'repeatEvery': 'A cada:',
                'repeatOn': 'No(s):',
                'interval': 'ano',
                'of': 'de'
            },
            end: {
                'label': 'Fim:',
                'never': 'nunca',
                'after': 'ao fim de',
                'occurrence': 'vez(es)',
                'on': 'em'
            },
            offsetPositions: {
                'first': 'primeiro(a)',
                'second': 'segundo(a)',
                'third': 'terceiro(a)',
                'fourth': 'quarto(a)',
                'last': 'quinto(a)'
            },
            weekdays: {
                'day': 'dia',
                'weekday': 'dia da semana',
                'weekend': 'fim de semana'
            }
        };

        var data = recEditor._frequency.dataSource.data();
        data[0].text = 'Nunca';
        data[1].text = 'Todos os dias';
        data[2].text = 'Todas as semanas';
        data[3].text = 'Todos os meses';
        data[4].text = 'Todos os anos';
        recEditor.value(e.event.recurrenceRule);
        recEditor._frequency.refresh();
        //recEditor._frequency.trigger('change');

        var divEsq = recEditor.element.find('span:first');
        var divDireita = recEditor.element.find('div:first');
        $(divEsq).css({ 'width': '100%' });
        $(divDireita).css({ 'margin-top': '15px' });

        /* atualiza mensagem de remocao TODO: FIX*/
        //e.sender.options.messages.editable.confirmation = 'Tem a certeza que pretende remover este registo?';
    };

    self.schedulerEventDataBoundEspecifico = function (e) {
        self.AtualizaValoresFiltros();
    };

    /* FUNCOES AUXILIARES */
    self.AtualizaValoresFiltros = function () {
        try {
            $('#badgeLojas').text(KendoRetornaElemento($('#IDLojaC')).value().length);
            $('#badgeMedicosTecnicos').text(KendoRetornaElemento($('#IDMedicoTecnicoC')).value().length);
        } catch (ex) {
            alert(ex);
        }
    };

    self.ChangeResources = function () {
        var boolTrocaResources = false;
        var scheduler = $(schedulerClass).getKendoScheduler();

        var cmbLojaC = KendoRetornaElemento($('#IDLojaC'));
        var cmbMedicoTecnicoC = KendoRetornaElemento($('#IDMedicoTecnicoC'));

        if (cmbMedicoTecnicoC.dataItem()
            && cmbMedicoTecnicoC.value().length === 1
            && !cmbLojaC.dataItem()) {
            if (scheduler.resources[0].field === 'IDMedicoTecnico') {
                boolTrocaResources = true;
            }
        } else {
            if (scheduler.resources[0].field === 'IDLoja') {
                boolTrocaResources = true;
            }
        }

        if (boolTrocaResources) {
            scheduler.resources.reverse();
            scheduler.resources[0].dataSource.read();
            scheduler.view(scheduler.view().name);
            scheduler.refresh();
        }
    };

    return parent;
}($Planificacao || {}, jQuery));

var KendoSchedulerEventSaveEspecifico = $Planificacao.ajax.schedulerEventSaveEspecifico;
var KendoSchedulerEventEditEspecifico = $Planificacao.ajax.schedulerEventEditEspecifico;
var KendoSchedulerEventDataBoundEspecifico = $Planificacao.ajax.schedulerEventDataBoundEspecifico;
var KendoChangeResources = $Planificacao.ajax.ChangeResources;

$(document).ready(function (e) {
    KendoSchedulerInit();
});