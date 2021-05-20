'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $servicosimportar = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //
        $('#BtSelect').on('click', self.Select);
        //
        $('#BtRefresh').on('click', self.Refresh);
        //
        $('.CLSF3MImprimir').on('click', self.ClickPrint);
    };

    //------------------------------------ P R I N T
    self.ClickPrint = function (e) {
        if (self.GetPrintAccess()) {
            self.Print(e.target.id);
        }
        else {
            UtilsNotifica(base.constantes.tpalerta['i'], resources['SemAcessoImprimir']); //Não tem permissão para imprimir
        }
    }

    self.Print = function (buttonId) {
        let grid = self.RetornaGridInstance();
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

    //------------------------------------ G R I D     G E N
    /* @description funcao */
    self.GrelhaFormChange = function (grid) { };

    /* @description funcao */
    self.GrelhaFormEdit = function(grid) { };

    /* @description funcao databound da grelha */
    self.GrelhaFormDataBound = function (e) {
        //get grid
        var grid = e.sender;
        //bind dblclick evt to select line
        $(grid.element).find('table tr').dblclick(function () {
            //select line
            self.Select();
        });
        //set height
        KendoGridClienteDimensionaVerticalmente(grid);
        var getHeight = grid.element.find('.k-grid-content').height();
        grid.element.find('.k-grid-content').height(getHeight);
    };

    //------------------------------------ G R I D     E S P
    /* @description funcao que envia parametros da grelha (IDCliente) */
    self.EnviaParametros = function (inObjetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltro(inObjetoFiltro, window.parent.$('#IDEntidade'), true, "IDCliente");
        return inObjetoFiltro;
    };

    //------------------------------------ A C T I O N S
    /* @description funcao quando e clicaco no botao de select */
    self.Select = function () {
        var _grid = self.RetornaGridInstance();
        var _dataItem = _grid.dataItem(_grid.select());

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_dataItem)) {
            let eSubservico = _dataItem.GraduacoesImportacao !== null && _dataItem.GraduacoesImportacao !== undefined;

            if (eSubservico) {
                window.parent.ServicosPreencheImportacaoSubservico(_dataItem);
            } else {
                window.parent.ServicosPreencheImportacao(_dataItem);
            }

            window.parent.$('#janelaMenu').data('kendoWindow').close();
        }
    };

    /* @description funcao que atualiza os dados da grelha (read) */
    self.Refresh = function () {
        //get grid
        var _grid = self.RetornaGridInstance();
        //read
        _grid.dataSource.read();
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /* @description funcao que retorna a instancia da grelha de importacao */
    self.RetornaGridInstance = function () {
        return $('.' + base.constantes.tiposComponentes.grelhaForm).data('kendoGrid');
    };

    self.OpenAppointment = function (element) {
        let id = element.getAttribute('f3m-data-id');
        let grid = self.RetornaGridInstance();
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

    return parent;

}($servicosimportar || {}, jQuery));

//document ready
var ServicosImportarInit = $servicosimportar.ajax.Init;
//grid gen
var GrelhaFormChange = $servicosimportar.ajax.GrelhaFormChange;
var GrelhaFormEdit = $servicosimportar.ajax.GrelhaFormEdit;
var GrelhaFormDataBound = $servicosimportar.ajax.GrelhaFormDataBound;
//grid esp
var ServicosImportarEnviaParametros = $servicosimportar.ajax.EnviaParametros;
//
var ServicosImportarOpenAppointment = $servicosimportar.ajax.OpenAppointment;

$(document).ready(function (e) {
    //document ready
    ServicosImportarInit();
});