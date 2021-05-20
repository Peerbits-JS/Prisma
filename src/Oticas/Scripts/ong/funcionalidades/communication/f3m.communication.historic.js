"use strict";

var $communicationhistoric = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    const constsBase = base.constantes;

    const IDTemplate = "#IDTemplate", IDDestination = "#Destinatarios", IDStatus = "#Status", IDDataDe = "#Datade", IDDataa = "#Dataa";

    const IDHDSN = 'hdsnSms';
    const hdsnColumns = { Template: 'Template', DataEnvio: 'DataEnvio', Destinatarios: 'Destinatarios', Status: 'Status', Mensagem: 'Mensagem' };

    const constJSONDates = constsBase.ConvertJSONDate;

    const FilterBtn = "#btnFilters", ResetBtn = '#btnReset';

    self.Init = () => {
        self.TrataBotoesInit();

        $(FilterBtn).on('click', () => self.Filterdata());

        $(ResetBtn).on('click', () => self.Filterdata());

        self.HandsontableFirstTime();
    }

    self.TrataBotoesInit = () => {
        $('#btnReset').removeClass('hidden');
        $('#btnAdd').removeClass('hidden').removeClass('disabled');
        $('#btnSave').addClass('hidden').addClass('disabled');
        $('#btnCancel').addClass('hidden').addClass('disabled');
        $('#btnCopy').addClass('hidden').addClass('disabled');
        $('#btnRemove').addClass('hidden').addClass('disabled');
        $('#btnEdit').addClass('hidden').addClass('disabled');
        $('#SMSModoEdita').addClass('bts-modo-edita');
    }

    self.Filterdata = () => {
        let url = rootDir + "Communication/Comunicacaosetting/GetCommunicationHistory";
        let params = self.FilterdataGetParams();

        KendoLoading($('#iframeBody'), true);
        UtilsChamadaAjax(url, true, JSON.stringify({ filter: params }), self.FilterdataSuccessCallback, () => { return false }, 1, true);
    }

    self.FilterdataGetParams = () => {
        let tempValue = KendoRetornaElemento($(IDTemplate)).dataItem().ID;
        let tempDestination = KendoRetornaElemento($(IDDestination)).dataItem().ID;
        let tempStaus = KendoRetornaElemento($(IDStatus)).dataItem().ID;
        let tempDataDe = $(IDDataDe).val();
        let tempDataa = $(IDDataa).val();

        return {
            Destination: tempDestination, Status: tempStaus, DataDe: tempDataDe, Dataa: tempDataa, IDTemplate: tempValue
        }
    }

    self.FilterdataSuccessCallback = (res) => {
        let hdsn = self.GetHandsontableInstance();

        if (res && res.length > 0) {
            hdsn.updateSettings({
                mergeCells: false,
                maxRows: res.length
            });
            hdsn.loadData(self.ConvertJSONDates(res));

            self.HandsontableHeight(hdsn);
        }
        else {
            self.MergeCellsEmptyData(hdsn);
        }

        KendoLoading($('#iframeBody'), false);
    };

    self.GetColumns = () => {
        return [
            {
                ID: hdsnColumns.Template,
                Label: 'Template',
                width: 20,
                readOnly: true
            },
            {
                ID: hdsnColumns.DataEnvio,
                Label: 'Data Envio',
                width: 20,
                readOnly: true
            },
            {
                ID: hdsnColumns.Destinatarios,
                Label: 'Destinatários',
                width: 20,
                readOnly: true
            },
            {
                ID: hdsnColumns.Status,
                Label: 'Status',
                width: 20,
                renderer: self.GetStatusColumn,
                readOnly: true
            },
            {
                ID: hdsnColumns.Mensagem,
                Label: 'Mensagem',
                width: 50,
                readOnly: true
            }];
    }

    self.GetStatusColumn = (instance, td, row, col, prop, value, cellProperties) => {
        let escaped = Handsontable.helper.stringify(value);
        let span;

        if (escaped != "") {
            if (value == true) {

                span = document.createElement('span');
                span.innerHTML = "Enviado";

                span.className = "badge badge-success";
            }
            else {
                span = document.createElement('span');
                span.innerHTML = "Erro de envio";

                span.className = "badge badge-danger";
            }

            Handsontable.dom.empty(td);
            td.appendChild(span);
        }

        return td;
    }

    self.ConstroiHT = (inData) => {
        let hdsn = HandsonTableDesenhaNovo(IDHDSN, inData, 200, self.GetColumns(), false);

        hdsn.updateSettings({
            fillHandle: false,
            rowHeaders: true,
            columnSorting: false,
            manualColumnResize: false,
            manualRowResize: false,
        });

        return hdsn;
    };

    self.GetHandsontableInstance = () => HotRegisterer.bucket[IDHDSN];

    self.HandsontableFirstTime = () => {
        var dsHandsontableFirstTime = [{
            'Template': 'Clique em Aplicar Filtros para pesquisar.'
        }];

        let hdsn = self.ConstroiHT(dsHandsontableFirstTime);

        hdsn.updateSettings({
            mergeCells: [{ row: 0, col: 0, rowspan: 1, colspan: 5 }]
        })

        //get cell
        var cell = hdsn.getCellMeta(0, 0);
        //set css classes
        cell["className"] = "handson-titulo htCenter";
        //render
        hdsn.render();
    }

    self.MergeCellsEmptyData = (hdsn) => {
        var dsHandsontableEmptyData = [{
            'Template': 'A pesquisa não retornou dados.'
        }];

        hdsn.loadData(dsHandsontableEmptyData);

        hdsn.updateSettings({
            mergeCells: [{ row: 0, col: 0, rowspan: 1, colspan: 5 }]
        })

        //get cell
        var cell = hdsn.getCellMeta(0, 0);
        //set css classes
        cell['className'] = 'bg-success htCenter';
        //render
        hdsn.render();
    }

    self.HandsontableHeight = (hdsn) => {
        hdsn = hdsn || self.GetHandsontableInstance();

        var height = $('#AreaGeral').height() - 120;
        //min height = 350
        height = height < 350 ? 350 : height;

        hdsn.updateSettings({
            height: height
        });
    };

    self.ConvertJSONDates = (ds) => {
        for (let index = 0; index < ds.length; index++) {
            let item = ds[index];
            item['DataEnvio'] = UtilsConverteJSONDate(item['DataEnvio'], constJSONDates.ConvertToDDMMAAAA);
        }

        return ds;
    }

    self.DateChange = (event) => {
        let elemDate = event.sender;

        if (!ValidaData(elemDate.element.val())) {
            elemDate.value(new Date);
        }
    };

    return parent;

}($communicationhistoric || {}, jQuery));

$(document).ready(() => $communicationhistoric.ajax.Init());

var CommunicationSettingsDateChange = $communicationhistoric.ajax.DateChange;

$(window).resize(function () {
    if (this.resizeTO) clearTimeout(this.resizeTO);
    this.resizeTO = setTimeout(function () {
        $communicationhistoric.ajax.HandsontableHeight();
    }, 100);
});