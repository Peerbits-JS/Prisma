"use strict";

var $appointments = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = function () {
        //
        $('#BtRefresh').on('click', self.Refresh);
        //
        $('.CLSF3MImprimir').on('click', self.ClickPrint);
    };

    self.ClickPrint = function (e) {
        if (self.GetPrintAccess()) {
            self.Print(e.target.id);
        }
        else {
            UtilsNotifica(base.constantes.tpalerta['i'], resources['SemAcessoImprimir']); //Não tem permissão para imprimir
        }
    }

    self.Print = function (buttonId) {
        let grid = self.GetGridInstance();
        let gridDataSource = grid.dataItem(grid.select());
        let modelo = {};
        modelo['ID'] = UtilsVerificaObjetoNotNullUndefinedVazio(gridDataSource) ? gridDataSource['ID'] : 0;
        //
        let objParam = $svcImprimir.ajax.PreecheObjImpParametros(buttonId, modelo, null);
        $svcImprimir.ajax.AbreJanela(objParam, null);
    };

    self.GetPrintAccess = function () {
        return ($('#TemAcessoImprimir').val() === 'True');
    };

    self.Refresh = function () {
        let grid = self.GetGridInstance();
        grid.dataSource.read();
    };

    self.GetGridInstance = function () {
        return $('.' + base.constantes.tiposComponentes.grelhaForm).data('kendoGrid');
    };

    self.OpenAppointment = function (element) {
        let id = element.getAttribute('f3m-data-id');
        let grid = self.GetGridInstance();
        let uid = $.grep(grid.dataSource.data(), (dataItem) => dataItem.ID == id)[0].uid;
        let row = grid.table.find("[data-uid=" + uid + "]");
        //
        grid.select(row);
        //
        let gridDataSource = grid.dataItem(grid.select());
        let url = 'Exames/Exames?IDDrillDown=' + gridDataSource['ID'] + '&DataMarcacao=' + UtilsConverteJSONDate('/Date(' + gridDataSource.DataExame.getTime() + ')', 'DDMMAAAA');
        let tabnome = resources['Consultorio'], tabicon = 'f3icon-exames';
        UtilsAbreTab(url, tabnome, tabicon, null, null, null);
    }

    self.AppointmentsFilter = function (filter) {
        GrelhaUtilsPreencheObjetoFiltro(filter, window.parent.$('#ID'), true, "IDCliente");
        return filter;
    }

    self.GrelhaFormChange = function (grid) { };

    self.GrelhaFormEdit = function (grid) { };

    self.GrelhaFormDataBound = function (e) {
        let grid = e.sender;
        KendoGridClienteDimensionaVerticalmente(grid);
        //
        let getHeight = grid.element.find('.k-grid-content').height();
        grid.element.find('.k-grid-content').height(getHeight);
    };

    return parent;

}($appointments || {}, jQuery));

var AppointmentsFilter = $appointments.ajax.AppointmentsFilter;
var AppointmentsOpenAppointment = $appointments.ajax.OpenAppointment;
//grid gen
var GrelhaFormChange = $appointments.ajax.GrelhaFormChange;
var GrelhaFormEdit = $appointments.ajax.GrelhaFormEdit;
var GrelhaFormDataBound = $appointments.ajax.GrelhaFormDataBound;

$(document).ready(() => $appointments.ajax.Init());
