"use strict";
var $kendoScheduler = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constCamposOF = base.constantes.camposObjetoFiltro;
    var filtroTextoID = constCamposOF.FiltroTexto;
    var schedulerClass = ".k-scheduler";

    self.Init = function () {
        self.ResizeScheduler();

        $('#btnReset').on('click', function () {
            self.ReadScheduler();
        });

        var scheduler = $(schedulerClass).data("kendoScheduler");
        scheduler.bind("moveEnd", self.schedulerMoveEnd);
    };

    /* Funções de eventos do calendário definidas no controlo */
    self.schedulerEventEdit = function (e) {
        /* Procura por funções especificas para executar no evento EDIT do calendario */
        var fn = window['KendoSchedulerEventEditEspecifico'];
        if (typeof fn === 'function') {
            fn(e);
        }
    };

    self.schedulerEventRequestEnd = function (e) {
        if (e.type === "create") {
            UtilsNotifica(base.constantes.tpalerta.s, "Adicionado com sucesso.");
        } else if (e.type === "update") {
            UtilsNotifica(base.constantes.tpalerta.s, "Atualizado com sucesso.");
        } else if (e.type === "destroy") {
            UtilsNotifica(base.constantes.tpalerta.s, "Removido com sucesso.");
        }

        /* Provoca um read ao calendario apos manipulação de evento */
        if (e.type === "create" || e.type === "update" || e.type === "destroy") {
            self.ReadScheduler();
        }
    };

    self.schedulerEventSave = function (e) {
        /* Procura por funções especificas para executar no evento SAVE do calendario */
        var fn = window['KendoSchedulerEventSaveEspecifico'];
        if (typeof fn === 'function') {
            fn(e);
        }
    };

    self.schedulerMoveEnd = function (e) {
        /* Procura por funções especificas para executar no evento MOVEEND do calendario */
        var fn = window['KendoSchedulerMoveEndEspecifico'];
        if (typeof fn === 'function') {
            fn(e);
        }
    };

    self.schedulerEventErrorHandler = function (e) { };

    self.schedulerEventEnviaParametros = function () {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDLoja', '', KendoRetornaElemento($('#IDLojaC')).value());
        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDEspecialidadeC')))) { GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDEspecialidade', '', KendoRetornaElemento($('#IDEspecialidadeC')).value()); }
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDMedicoTecnico', '', KendoRetornaElemento($('#IDMedicoTecnicoC')).value());

        let schedulerViewName = '';
        let selectedDate = self.M();

        if (self.eventSchedulerEventNavigate) {
            schedulerViewName = self.eventSchedulerEventNavigate.view;
            selectedDate = self.M(self.eventSchedulerEventNavigate.date);
        }
        else {
            selectedDate = self.M(self.GetScheduler().date());
            schedulerViewName = self.GetScheduler().view().name;
        }

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'SelectedDate', '', selectedDate);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'ViewName', '', schedulerViewName);

        if (schedulerViewName === "day" || schedulerViewName === "week") {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'CarregaPlanificacoes', '', true);
        }


        let schedular = self.GetScheduler();
        
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'startDate', '', self.M(schedular.view().startDate()));
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'endDate', '', self.M(schedular.view().endDate()));


        self.eventSchedulerEventNavigate = null;
        return objetoFiltro;
    };

    self.schedulerEventNavigate = (e) => {
        let scheduler = e.sender, action = e.action, date = e.date, view = e.view;

        switch (action) {
            case 'next':
            case 'previous':
            case 'today':
                scheduler.date(date);
                break;

            case 'changeView':
                scheduler.view(view);
                break;
        }

        self.ReadScheduler(e, scheduler);
    };

    self.schedulerParse = function (d) {
        /* Procura por funções especificas para executar no evento Parse do calendario */
        var fn = window['KendoSchedulerEventParseEspecifico'];
        if (typeof fn === 'function') {
            fn(d);
        }
        return d;
    };

    self.schedulerEventDataBound = function (e) {
        /* Procura por funções especificas para executar no evento DATABOUND do calendario */
        var fn = window['KendoSchedulerEventDataBoundEspecifico'];
        if (typeof fn === 'function') {
            fn(e);
        }
    };

    self.schedulerTemplateSlot = function (e) {
        /* Procura por funções especificas para executar para definir template dos slots do calendario */
        var fn = window['KendoSchedulerTemplateSlotEspecifico'];
        if (typeof fn === 'function') {
            return fn(e);
        }
    };

    /* Funções auxiliares */
    self.ChangeFiltrosCabecalho = function () {
        /* Procura por função especifica para alterar o resource do calendario */
        var fn = window['KendoChangeResources'];
        if (typeof fn === 'function') {
            fn();
        }
        self.ReadScheduler();
    };

    self.eventSchedulerEventNavigate = null;

    self.ReadScheduler = (evt, scheduler) => {
        scheduler = scheduler || self.GetScheduler();
        self.eventSchedulerEventNavigate = evt;
        scheduler.dataSource.read();
    };

    self.GetScheduler = () => $(schedulerClass).getKendoScheduler();

    self.ResizeScheduler = function () {
        var sched = self.GetScheduler();
        var winHeigth = $(window).height();
        var elemTopPosition = sched.element.position().top;
        var offSet = 2;

        sched.element.height(winHeigth - elemTopPosition - offSet);
        sched.resize(true);
    };

    /* MedicosTecnicos */
    self.LojasEnviaParams = function (e) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDEmpresa', '', constIDEmpresa);

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'Ativo', '', true);

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'TemAgenda', '', true);

        return objetoFiltro;
    };

    self.ClienteEnviaParams = function (e) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        if (UtilsVerificaObjetoNotNullUndefinedVazio(e.FiltroTexto)) {
            objetoFiltro[filtroTextoID] = e.FiltroTexto;
            }
        else {
            objetoFiltro[filtroTextoID] = $('#Nome').val();
            }
        return objetoFiltro;
    };

    self.EspecialidadeEnviaParams = function (e) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDMedicoTecnico', '', $('#IDMedicoTecnico').val());

        return objetoFiltro;
    };

    self.MedicoTecnicoEnviaParams = function (e) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        objetoFiltro[filtroTextoID] = KendoRetornaElemento($('#IDMedicoTecnico')).text();

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDEspecialidade', '', $('#IDEspecialidade').val());

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'TemAgenda', '', true);

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'Ativo', '', true);

        return objetoFiltro;
    };

    self.MedicoTecnicoPesquisaEnviaParams = function (e) {
        var objetoFiltro = GrelhaUtilsObjetoFiltro();

        if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento($('#IDEspecialidadeC')))) {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDEspecialidade', '', KendoRetornaElemento($('#IDEspecialidadeC')).value());
        }

        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'TemAgenda', '', true);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'ECalendario', '', true);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'Ativo', '', true);

        return objetoFiltro;
    };

    self.EspecialidadeChange = function (e) {
        var cmbMedicoTecnico = KendoRetornaElemento($('#IDMedicoTecnico'));
        if (e.selectedIndex < 0) {
            cmbMedicoTecnico.value(null);
            cmbMedicoTecnico.dataSource.read();
        } else {
            if (e.selectedIndex >= 0) {
                cmbMedicoTecnico.dataSource.read();
            }
        }
    };

    self.MedicoTecnicoChange = function (e) {
        var cmbEspecialidade = KendoRetornaElemento($('#IDEspecialidade'));
        if (e.selectedIndex < 0) {
            cmbEspecialidade.value(null);
            cmbEspecialidade.dataSource.read();
        } else {
            if (e.selectedIndex >= 0) {
                cmbEspecialidade.dataSource.read();
            }
        }
    };

    self.ClienteChange = function (e) {
        var dtItem = e.dataItem();
        if (dtItem !== undefined) {
            $('#Contacto').val(dtItem.TelemovelPorDefeito || dtItem.TelefonePorDefeito);
            $('#Nome').val(dtItem.Nome);
        } else {
            $('#Contacto').val('');
            $('#Nome').val('');
        }
    };

    self.M = function (date) {
        date = date || new Date();

        let yr = date.getFullYear();
        let month = (date.getMonth() + 1) < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1);
        let day = date.getDate() < 10 ? '0' + date.getDate() : date.getDate();
        return yr + '-' + month + '-' + day;
    }

    return parent;
}($kendoScheduler || {}, jQuery));

var KendoSchedulerInit = $kendoScheduler.ajax.Init;
var KendoSchedulerResize = $kendoScheduler.ajax.ResizeScheduler;
var KendoSchedulerRead = $kendoScheduler.ajax.ReadScheduler;

var KendoSchedulerEventEdit = $kendoScheduler.ajax.schedulerEventEdit;
var KendoSchedulerEventRequestEnd = $kendoScheduler.ajax.schedulerEventRequestEnd;
var KendoSchedulerEventSave = $kendoScheduler.ajax.schedulerEventSave;
var KendoSchedulerEventErrorHandler = $kendoScheduler.ajax.schedulerEventErrorHandler;
var KendoSchedulerEventDataBound = $kendoScheduler.ajax.schedulerEventDataBound;
var KendoSchedulerEventNavigate = $kendoScheduler.ajax.schedulerEventNavigate;
var KendoSchedulerParse = $kendoScheduler.ajax.schedulerParse;
var KendoSchedulerEventEnviaParametros = $kendoScheduler.ajax.schedulerEventEnviaParametros;
var KendoSchedulerTemplateSlot = $kendoScheduler.ajax.schedulerTemplateSlot;

var KendoSchedulerChangeFiltrosCabecalho = $kendoScheduler.ajax.ChangeFiltrosCabecalho;
var KendoSchedulerClienteEnviaParams = $kendoScheduler.ajax.ClienteEnviaParams;
var KendoSchedulerEspecialidadeEnviaParams = $kendoScheduler.ajax.EspecialidadeEnviaParams;
var KendoSchedulerMedicoTecnicoEnviaParams = $kendoScheduler.ajax.MedicoTecnicoEnviaParams;
var KendoSchedulerMedicoTecnicoPesquisaEnviaParams = $kendoScheduler.ajax.MedicoTecnicoPesquisaEnviaParams;
var KendoSchedulerLojasEnviaParams = $kendoScheduler.ajax.LojasEnviaParams;
var KendoSchedulerEspecialidadeChange = $kendoScheduler.ajax.EspecialidadeChange;
var KendoSchedulerMedicoTecnicoChange = $kendoScheduler.ajax.MedicoTecnicoChange;
var KendoSchedulerClienteChange = $kendoScheduler.ajax.ClienteChange;

$(document).ready(function (e) {
    KendoSchedulerInit();
});

$(window).resize(function (e) {
    KendoSchedulerResize();
});