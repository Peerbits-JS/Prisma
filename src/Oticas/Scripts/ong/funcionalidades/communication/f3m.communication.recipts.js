"use strict";

var $communicationrecipts = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var BtnMsgSend = "#btnMsgSend";
    var RemainCharSpan = "#spnRemainChar";
    var SpanMsgCount = "#spnMsgCount";
    var MaxMsgCount = 160;

    self.Init = () => {
        $('#TexoMsgArea').on('change', () => self.CaluculatemsgCount());

        $('#TexoMsgArea').on('keyup', () => self.CaluculatemsgCount());

        $('#btnMsgSend').on('click', () => self.SendTemplateSms());

        self.KendoGrid();
    }

    self.CaluculatemsgCount = () => {
        let TotalChar = $('#TexoMsgArea').val().trim().length;
        let remain = MaxMsgCount;
        let msgCount = Math.floor(TotalChar / MaxMsgCount) + 1;

        remain = TotalChar % MaxMsgCount;

        (remain == 0 && TotalChar == 0) ? $(BtnMsgSend).prop("disabled", true) : $(BtnMsgSend).prop("disabled", false);

        $(RemainCharSpan).text(remain);
        $(SpanMsgCount).text(msgCount);
    };

    self.KendoGrid = () => {
        $("#grid").kendoGrid({
            dataSource: new kendo.data.DataSource({
                transport: {
                    read: {
                        url: rootDir + "Communication/CommunicationSmsTemplates/GetRecipts",
                        data: { idTemplate: $communicationtemplate.ajax.GetIdTemplate() },
                    },
                    
                },
                pageSize: 20
            }),
            height: 300,
            pageable: {
                refresh: true,
                pageSizes: ['all', 20, 50, 100],
                buttonCount: 20,
                messages: {
                    allPages: "Todas",
                }
            },
            dataBound: function (e) {
                //todo maf
                //$('#header-checkbox').prop('checked', false);
            },
            columns: self.KendoGridGetColumns()
        });
    }

    self.KendoGridGetColumns = () => {
        return [
            {
                type: 'boolean',
                attributes: { style: "text-align:center;" },
                headerAttributes: { style: "text-align: center;" },
                headerTemplate: ' <input id="header-checkbox" type="checkbox" class="clsF3MReciptsCheckbox" onclick="$communicationrecipts.ajax.SelectAllRecips(this, event)" />',
                template: '<input data-field="isSelected" type="checkbox" class="chkbx clsF3MReciptsCheckbox" onchange="$communicationrecipts.ajax.ChangeSelectedColumn(this)" #= isSelected ? \'checked="checked"\' : "" # #= (Telemovel !== null  && Telemovel !== "") ? "" : \'disabled\' # />',
                field: "isSelected",
                width: 50
            },
            {
                title: 'Código',
                field: "Codigo",
                width: 100
            },
            {
                title: 'Nome',
                field: "Nome",
                width: 150
            },
            {
                title: 'Telémovel',
                field: "Telemovel",
                width: 100
            }
        ]
    }

    self.SelectAllRecips = (input) => {
        var grid = $("#grid").data('kendoGrid');
        var ds = grid.dataSource.data();
        var checkbox = $(input);

        for (var index = 0, len = ds.length; index < len; index++) {
            let row = ds[index];

            if (row['Telemovel'] !== null && row['Telemovel'] !== '') {
                row['isSelected'] = checkbox.prop('checked');
            }
        }

        grid.refresh();
        self.RefreshNumberOfRecipts();
    }

    self.ChangeSelectedColumn = (input) => {
        let grid = $("#grid").data('kendoGrid');
        let ds = grid.dataSource.data();
        //
        let dtUID = $(input.parentElement.parentElement).attr('data-uid');
        let fieldName = $(input).attr('data-field');
        let objDataItem = $.grep(ds, (item) => item['uid'] === dtUID);

        objDataItem[0][fieldName] = input.checked;
        //
        self.RefreshNumberOfRecipts();
        //
        let selected =  $.grep(ds, (item) => item['isSelected']).length;
        self.CheckHeader(ds.length === selected);
    };

    self.RefreshNumberOfRecipts = () => {
        let ds = $("#grid").data('kendoGrid').dataSource.data();
        let numberOfReciptsSelected = $.grep(ds, (item) => item['isSelected']).length;
        $('#number-recipts').text(numberOfReciptsSelected);
    }

    self.CheckHeader = (bool) => {
        $('#header-checkbox').prop('checked', bool);
    }

    self.CommunicationSmsEnviaParams = function (objFilter) {
        GrelhaUtilsPreencheObjetoFiltroValor(objFilter, true, "isOnlySms", '', true);

        return objFilter;
    }

    self.SendTemplateSms = () => {
        let model = self.SendTemplateSmsGetModel();
        UtilsConfirma(base.constantes.tpalerta.question, 'Tem a certeza que pretende enviar para ' + model.Recipts.length + ' destinatário(s)?', () => self.Send(model), () => false);
    }

    self.Send = (model) => {
        let url = rootDir + "Communication/CommunicationSmsTemplates/SendTemplateSms";

        $.post(url, { model: model }, (res) => {
            if (res.Erros && res.Erros.length) {
                KendoLoading($('#iframeBody'), false);
                UtilsConfirma(base.constantes.tpalerta.error, 'Ocorreu um erro, por favor tente novamente.', () => false, () => false);
            }
            else {
                UtilsNotifica(base.constantes.tpalerta.s, "Enviado com sucesso para " + model.Recipts.length + " destinatário(s).");
                $(BtnMsgSend).prop("disabled", true);
                $('#TexoMsgArea').prop('disabled', true);
                $('#textosbase').addClass('disabled');
                $('.clsF3MReciptsCheckbox').prop('disabled', true);
            }
            setTimeout(() => {
                $('#mod-progress').modal('hide');
            }, 250)
        });
    }

    self.SendTemplateSmsGetModel = () => {
        let idSistemaEnvio = $('#IDSistemaEnvio').val();
        let message = $('#TexoMsgArea').val();

        let grid = $("#grid").data('kendoGrid');
        let ds = $.grep(grid.dataSource.data(), (item) => item['isSelected']);
        let recipts = [];

        for (var index = 0, len = ds.length; index < len; index++) {
            let row = ds[index];
            recipts.push({
                ID: row['ID'],
                Telemovel: row['Telemovel'],
                Nome: row['Nome']
            })
        }

        return {
            IDConnection : pbConnectionId,
            IDTemplate: $communicationtemplate.ajax.GetIdTemplate(),
            IDSistemaEnvio: idSistemaEnvio,
            Message: message,
            Recipts: recipts
        }
    }

    return parent;

}($communicationrecipts || {}, jQuery));

$(document).ready(() => $communicationrecipts.ajax.Init());