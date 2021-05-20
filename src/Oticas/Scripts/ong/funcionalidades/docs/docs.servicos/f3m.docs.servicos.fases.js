'use strict';

var $servicosfases = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    const constsBase = base.constantes;
    const formaction = constsBase.EstadoFormEAcessos;
    const jsondates = constsBase.ConvertJSONDate;
    const columns = { isChecked: 'cbx_', date: 'date_', user: 'user_', notes: 'obs_', row: 'tr_' };

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.init = () => {
        //
        $('[data-toggle="tooltip"]').tooltip();
        //
        $('a.clsF3MTabEstados[data-toggle="tab"]').first().click();
        //
        $('a.clsF3MTabEstados[data-toggle="tab"]').on('shown.bs.tab', (elem) => self.scrollToLastChecked(elem.target.getAttribute('href')));
        //
        self.scrollToLastChecked($('a.clsF3MTabEstados.active').attr('href'));

    };

    self.stateChange = (elem) => {
        if ($(elem).is(':checked')) {
            self.crud(elem);
        }
        else {
            $(elem).prop('checked', true);
            UtilsAlerta(base.constantes.tpalerta.question, 'Tem a certeza que deseja remover a informação do estado?', () => self.crud(elem), () => $(elem).prop('checked', true));
        }
    };

    self.notesOnClick = (elem) => {
        $(elem).find('span').hide();
        $(elem).find('input').show().focus();
    };

    self.notesOnChange = (elem) => self.crud(elem);

    self.notesOnFocusOut = (elem) => {
        $(elem).hide();
        $(elem).prev().text($(elem).val()).parent().attr('data-title', $(elem).val());
        $(elem).prev().show();
    };

    self.crud = (elem) => {
        var url = rootDir + 'Documentos/DocumentosVendasServicos/CrudFasesAndRefreshHistory';
        var model = self.crudGetModel(elem);

        self.startLoading();

        $.post(url, model, (res) => self.crudSuccessCallback(model, res));
    };

    self.crudSuccessCallback = (model, res) =>  {
        switch (res.ID) {
            case 0:
                self.emptyData(model, res);
                break;

            default:
                self.updateData(model, res);
        }

        self.completeLoading();
    };

    self.crudGetModel = (elem) => {
        var currentInput = elem.getAttribute('id').split('_');

        var idServico = currentInput[1];
        var idTipoServico= currentInput[2];
        var idTipoFase = currentInput[3];
        var id = currentInput[4];

        var idInputs = idServico + '_' + idTipoServico + '_' + idTipoFase + '_' + id ;

        var model = {
            AcaoFormulario: self.crudGetModelAction(elem),
            IsChecked: $('#' + columns.isChecked + idInputs).is(':checked'),
            IDTipoFase: idTipoFase,
            IDServico: idServico,
            IDTipoServico: idTipoServico,
            ID: id,
            Observacoes: $('#' + columns.notes + idInputs).val()
        };

        return model;
    };

    self.crudGetModelAction = (elem) => {
        var currentInput = elem.getAttribute('id').split('_');
        var inputName = currentInput[0];
        var id = currentInput[4];

        if (id === formaction.Adicionar) {
            return 0; // add
        }

        if (id !== formaction.Adicionar && inputName === 'cbx') {
            return 2; // remove
        }

        return 1; // edit
    }; 

    self.emptyData = (model, res) => {
        var oldId = model.IDServico + '_' + model.IDTipoServico + '_' + model.IDTipoFase + '_' + model.ID;
        var newId = res.IDServico + '_' + res.IDTipoServico + '_' + res.IDTipoFase + '_' + res.ID;

        //checkbox
        $('#' + columns.isChecked + oldId).attr('id', columns.isChecked + newId).prop('checked', false).removeAttr('checked').siblings('label').attr('for', columns.isChecked + newId);
        //date
        $('#' + columns.date + oldId).attr('id', columns.date + newId).text(null);
        //user
        $('#' + columns.user + oldId).attr('id', columns.user + newId).text(null);
        //notes
        $('#' + columns.notes + oldId).attr('id', columns.notes + newId).val(null).siblings('span').text(null);
        self.updateTooltip($('#' + columns.notes + newId).parent('td'), 'Clique para editar');
        //tr
        $('#' + columns.row + oldId).attr('id', columns.row + newId)
    };

    self.updateData = (model, res) => {
        var oldId = model.IDServico + '_' + model.IDTipoServico + '_' + model.IDTipoFase + '_' + model.ID;
        var newId = res.IDServico + '_' + res.IDTipoServico + '_' + res.IDTipoFase + '_' + res.ID;

        //checkbox
        $('#' + columns.isChecked + oldId).attr('id', columns.isChecked + newId).prop('checked', true).attr('checked', true).siblings('label').attr('for', columns.isChecked + newId);
        //date
        $('#' + columns.date + oldId).attr('id', columns.date + newId).text(UtilsConverteJSONDate(res.Data, jsondates.ConvertToDDMMAAAAHHmm));
        //user
        $('#' + columns.user + oldId).attr('id', columns.user + newId).text(res.UtilizadorEstado);
        //notes
        $('#' + columns.notes + oldId).attr('id', columns.notes + newId).text(res.Observacoes).siblings('span').text(res.Observacoes);
        self.updateTooltip($('#' + columns.notes + newId).parent('td'), res.Observacoes);
        //tr
        $('#' + columns.row + oldId).attr('id', columns.row + newId);
    };

    self.updateTooltip = (elem, value) => elem.attr('data-original-title', value).tooltip();

    self.scrollToLastChecked = (tabId) => {
        var lastCheckedByTab = $(tabId).find('.clsF3MCheckbox[checked]').last();

        if (lastCheckedByTab.length) {
            var row = lastCheckedByTab.parents('tr');
            var container = $(tabId).find('table tbody');
            var scrollTo = $(row);
            //
            container.animate({
                scrollTop: scrollTo.offset().top - container.offset().top + container.scrollTop()
            });
        }
    };

    self.startLoading = () => $('#estadosloader').removeClass('hidden');

    self.completeLoading = () => {
        $('.circle-loader').toggleClass('load-complete');
        $('.checkmark').toggle();

        setTimeout(() => {
            $('#estadosloader').addClass('hidden');
            $('.circle-loader').toggleClass('load-complete');
            $('.checkmark').toggle();
        }, 1500);
    };

    return parent;

}($servicosfases || {}, jQuery));

$(document).ready(() => $servicosfases.ajax.init());