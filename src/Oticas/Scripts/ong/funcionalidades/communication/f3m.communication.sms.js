"use strict";

var $communication = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var BtnMsgSend="#btnMsgSend";
    var TexoMsgArea ="#TexoMsgArea"; 
    var DocLink = ".DocLink";

    var RemainCharSpan="#spnRemainChar";
    var HiddenIDDestinaction = "#hdIdChamada";
    var HiddenTipoChamada = "#hdSmsFrom";
    var SpanMsgCount="#spnMsgCount";
    var SmsContainer =".clsF3MBodySMS";
    var MaxMsgCount = 160;

    self.Init = () => {
        self.ScrollToLastMsg();

        $(DocLink).on('click', () => self.DocClick($(this)));

        $(BtnMsgSend).on('click', () => self.SendMsg());

        $(TexoMsgArea).on('change', () => self.CaluculatemsgCount());

        $(TexoMsgArea).on('keyup', () => self.CaluculatemsgCount());
    };

    self.SendMsg = () => {
        var MsgModule = {
            IDComunicacao: KendoRetornaElemento($('#IDmsgsystem')).dataItem().ID,
            IDChamada: $(HiddenIDDestinaction).val(),
            TipoChamada: $(HiddenTipoChamada).val(),
            Documento: UtilsVerificaObjetoNotNullUndefinedVazio($('#Documento').val()) ? $('#Documento').val() : null,
            DocumentID: UtilsVerificaObjetoNotNullUndefinedVazio($('#Documento').val()) ? $('#hdDocId').val() : null,
            TextoMensagem: $(TexoMsgArea).val()
        };


        UtilsChamadaAjax(rootDir + "Communication/CommunicationSms/SendMsg", true, JSON.stringify({ jsondata: MsgModule }),
            function (res) {
                if (!UtilsChamadaAjaxTemErros(res)) {

                    if (res.Status == true) {
                        UtilsNotifica(base.constantes.tpalerta.s, res.Msg)

                    }
                    else {
                        UtilsNotifica(base.constantes.tpalerta.error, "Obtendo erro durante o envio de SMS " + res.Msg)
                    }
                    self.MsgAppend(res)
                }
            }, function (e) { return false; }, 1, true);
    }

    self.MsgAppend = (Response) => {
        var StatusString = Response.Status == 1 ? '<span class="badge badge-success"><span class="fm f3icon-check"></span></span>' : '<span class="badge badge-danger" data-toggle="tooltip"  data-original-title="' + Response.Msg + '" title="' + Response.Msg + '"><span class="fm f3icon-close"></span></span>'
        var UserString = $('#Documento').val() != undefined ? '<span>,referente a <a DocId="' + $('#hdDocId').val() + '"  SmsFrom="' + $('#hdSmsFrom').val() + '" class="DocLink" onclick="$communication.ajax.DocClick($(this))" style="text-decoration:underline;color:deepskyblue">' + $('#Documento').val() + ' </a></span>' : ""

        var NewRow = '<div class="row"> '
            + '<div class = "col-12">'
            + '<div class="float-left">Status de envio</div>'
            + '<div class="float-right">';

        if (Response.Status == 1) {
            NewRow += 'Enviado a ';
        }
        else {
            NewRow += 'Não enviado a ';
        }
            
        NewRow += Response.Date + ' por ' + $("#hdUsers").val()   
            + UserString
            + StatusString
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="row mt-1 mb-3">'
            + '<div class="col-12">'
            + '<div class="card bg-light"><div class="card-body">'
            + $(TexoMsgArea).val()
            + '</div></div>'
            + '</div>'
            + '</div>';

        $('#empty-hitoric').remove();
        $(SmsContainer).append(NewRow);

        Response.Status == 1 ? $(TexoMsgArea).val('') : "";

        var SentSmsCount = Response.SmsCount != undefined ? parseInt(Response.SmsCount) : 0;

        var LastSmsCout = parseInt($("#spRemainSms").text());

        $("#spRemainSms").text(LastSmsCout - SentSmsCount);

        self.ScrollToLastMsg();

        self.CaluculatemsgCount();
    };

    self.CaluculatemsgCount = () => {
        var TotalChar = $(TexoMsgArea).val().trim().length;
        var remain = MaxMsgCount;
        var currentMsgSystem = KendoRetornaElemento($('#IDmsgsystem')).dataItem().ID;

        var msgCount = Math.floor(TotalChar / MaxMsgCount) + 1;

        remain = TotalChar % MaxMsgCount;

        (remain == 0 && TotalChar == 0) || currentMsgSystem === '' ? $(BtnMsgSend).prop("disabled", true) : $(BtnMsgSend).prop("disabled", false);

        $(RemainCharSpan).text(remain);
        $(SpanMsgCount).text(msgCount);

    };

    self.DocClick = (el) => {
        var SmsFrom = el.attr("SmsFrom");
        var DocID = el.attr("DocId");

        if (SmsFrom == "DocumentosVendasServicos") {
            self.OpenService(DocID);

        } else if (SmsFrom == "DocumentosVendas") {
            self.OpenSaleDocument(DocID);
        }
    };

    self.OpenSaleDocument = (DocID) => {
        //props UtilsAbreTab
        let url = '/Documentos/DocumentosVendas?IDDrillDown=' + DocID;
        let tabnome = resources['DocumentosVendas'], _tabicon = 'f3icon-doc-finance';
        //UtilsAbreTab
        UtilsAbreTab(url, tabnome, _tabicon, null, null, null);
    };

    self.OpenService = (DocID) => {
        //props UtilsAbreTab
        let url = '/Documentos/DocumentosVendasServicos?IDDrillDown=' + DocID;
        let tabnome = resources['Servicos'], _tabicon = 'f3icon-glasses';
        //UtilsAbreTab
        UtilsAbreTab(url, tabnome, _tabicon, null, null, null);
    };

    self.CloseModal = () => $(".k-window .k-window-content").each((index, element) => $(element).data("kendoWindow").close());

    self.ScrollToLastMsg = () => {
        let container = $('.clsF3MBodySMS');
        let scrollTo = $('.clsF3MBodySMS > .row').last();

        if (scrollTo.length > 0) {
            container.animate({
                scrollTop: scrollTo.offset().top - container.offset().top + container.scrollTop()
            });
        }
    }

    self.CommunicationSmsEnviaParams = function(objFilter) {
        GrelhaUtilsPreencheObjetoFiltroValor(objFilter, true, "isOnlySms", '', true);

        return objFilter;
    }

    return parent;

}($communication || {}, jQuery));

$(document).ready(() => $communication.ajax.Init());
   
var CommunicationSmsEnviaParams = $communication.ajax.CommunicationSmsEnviaParams;