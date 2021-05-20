"use strict";

var $communicationsmsaddmobilephonenumber = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var entityToSavePhoneNumberId ="#hdClientId"; 
    var mobilePhoneNumber ="#MobilePhoneNumber"; 
    var btnMovelSave = "#btnMovelSave";

    self.Init = () => {
        $(btnMovelSave).on('click', () => self.SaveMobilePhoneNumber());

        $(mobilePhoneNumber).on('keyup', () => self.CalculateMovel());
    };

    self.SaveMobilePhoneNumber = () => {
        let movel = $(mobilePhoneNumber).val().trim();
        let clientId = $(entityToSavePhoneNumberId).val().trim();
        let url = rootDir + "Communication/CommunicationSms/UpdateMobilePhoneNumber?IDClientID=" + clientId + "&CDMovel=" + movel;

        UtilsChamadaAjax(url, true, {}, self.SaveMobilePhoneNumberSuccessCallback, () => false, 1, true);
    }

    self.SaveMobilePhoneNumberSuccessCallback = (res) => {
        if (res.Status == 1) {
            //notification
            UtilsNotifica(base.constantes.tpalerta.s, res.Msg)
            //close modal
            self.CloseModal();
            //open sms modal
            self.SelectRowAndOpenSmsModal();
        }
    }

    self.SelectRowAndOpenSmsModal = () => {
        //grid
        let grid = $('.F3MGrelhaForm').data('kendoGrid');
        //selected row
        let selectedRow = grid.dataItem(grid.select());
        //read grid
        grid.dataSource.read().then(() => {
            //row to select
            let selectRow = $.grep($('.F3MGrelhaForm').data('kendoGrid').dataSource.data(), (item) => item['ID'] === selectedRow['ID'])[0];

            if (selectRow) {
                //row to select
                let row = grid.element.find("tbody>tr[data-uid=" + selectRow['uid'] + "]");
                //select row
                grid.select(row);
                //scroll to selected row
                grid.element.find(".k-grid-content").animate({ scrollTop: grid.select().offset().top }, 400);
                //open sms modal
                $('.clsBtSms').click();
            }
        });
    };

    self.CalculateMovel = () => {
        $(mobilePhoneNumber).val($(mobilePhoneNumber).val().replace(/[^0-9]/g, ''));
        $(btnMovelSave).prop("disabled", $(mobilePhoneNumber).val().length !== 9);
    };

    self.CloseModal = () => $(".k-window .k-window-content").each((index, element) => $(element).data("kendoWindow").close());

    return parent;

}($communicationsmsaddmobilephonenumber || {}, jQuery));

$(document).ready(() => $communicationsmsaddmobilephonenumber.ajax.Init());
