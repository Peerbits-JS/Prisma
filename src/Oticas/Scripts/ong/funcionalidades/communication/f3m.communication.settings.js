"use strict";

var $communsetting = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var selArvore = '#arvoremenu';

    self.Init = () => {
        $('#btnAdd').off().on('click', () => self.NewTemplate());

        $('#btnHistoric').off().on('click', () => self.ClickHistoric());

        self.CarregaKendoTreeView();

        $('#BotaoAbrirEsquerda, #BotaoFecharEsquerda').on('click', () => setTimeout(() => {
            //self.GetHandsontableInstance().render()
        }, 250));
    }

    self.IsDirtyActive = false;

    self.DisableTree = () => {
        let tree = $('#arvoremenu').data('kendoTreeView');
        tree.enable(false);
    }

    self.DesselectTree = () => {
        let tree = $('#arvoremenu').data('kendoTreeView');
        tree.select(null);
    }

    self.CarregaKendoTreeView = function () {
        var dataSource = new kendo.data.HierarchicalDataSource({
            transport: {
                read: {
                    url: rootDir + "Communication/CommunicationSmsTemplates/GetTemplates",
                    dataType: "json",
                }
            },
            schema: {
                model: {
                    id: "ID"
                }
            }
        });

        $(selArvore).kendoTreeView({
            dataTextField: 'Descricao',
            dataSource: dataSource,
            expanded: true,
            select: self.SelectTree
        }).data('kendoTreeView');
    };

    self.SelectTree = (e) => {
        e.preventDefault();

        if (self.IsDirtyActive) {
            UtilsConfirma(base.constantes.tpalerta.question, 'Tem alterações pendentes! Pretende continuar e perder a informação ?', () => {
                self.SelectTreeAndOpenTemplate(e);
            }, () => false);
        }
        else {
            self.SelectTreeAndOpenTemplate(e);
        }
    }

    self.SelectTreeAndOpenTemplate = (e) => {
        let idTemplate = e.sender.dataItem(e.sender.findByUid(e.node.getAttribute('data-uid')))['ID'];
        self.OpenTemplate(idTemplate, () => e.sender.select(e.node));
    }

    self.ClickHistoric = () => {
        if (self.IsDirtyActive) {
            UtilsConfirma(base.constantes.tpalerta.question, 'Tem alterações pendentes! Pretende continuar e perder a informação ?', self.OpenHistoric, () => false);
        }
        else {
            self.OpenHistoric();
        }
    }

    self.OpenHistoric = () => {
        KendoLoading($('#iframeBody'), true);
        $.get(rootDir + 'Communication/Comunicacaosetting/Historic', (res) => {
            $('#btnHistoric').addClass('active');
            self.DesselectTree();
            $('#AreaGeral').html(res);
            KendoLoading($('#iframeBody'), false);
            self.IsDirtyActive = false;
        });
    }

    self.CopyTemplate = () => {
        KendoLoading($('#iframeBody'), true);
        $.post(rootDir + 'Communication/CommunicationSmsTemplates/Copy', { idTemplate: $communicationtemplate.ajax.GetIdTemplate() }, (res) => {
            $('#AreaGeral').html(res);
            KendoLoading($('#iframeBody'), false);
            self.IsDirtyActive = true;
            $communicationtemplate.ajax.InitializeMultiSelects();
        });
    }

    self.NewTemplate = () => {
        KendoLoading($('#iframeBody'), true);
        $.get(rootDir + 'Communication/CommunicationSmsTemplates', (res) => {
            $('#AreaGeral').html(res);
            KendoLoading($('#iframeBody'), false);
            self.IsDirtyActive = true;
            $('#SMSModoEdita').removeClass('bts-modo-edita');
        });
    }

    self.OpenTemplate = (idTemplate, fnSuccessCallback = () => { }) => {
        KendoLoading($('#iframeBody'), true);
        $.get(rootDir + 'Communication/CommunicationSmsTemplates/Template', { idTemplate: idTemplate }, (res) => {
            $('#btnHistoric').removeClass('active');
            $('#AreaGeral').html(res);
            KendoLoading($('#iframeBody'), false);
            self.IsDirtyActive = false;
            fnSuccessCallback();
            $communicationtemplate.ajax.InitializeMultiSelects();
        });
    }

    self.ReadTree = () => {
        let tree = $('#arvoremenu').data('kendoTreeView');
        tree.dataSource.read();
    }

    self.ReadTreeSelectNodeAndOpenTemplate = (idTemplate) => {
        let tree = $('#arvoremenu').data('kendoTreeView');
        tree.dataSource.read().then(() => {
            let getitem = $.grep(tree.dataSource.data(), (item) => item['ID'] === idTemplate)[0];
            var selectitem = tree.findByUid(getitem.uid);
            tree.select(selectitem);
        });
        $communsetting.ajax.OpenTemplate(idTemplate);
    }

    return parent;

}($communsetting || {}, jQuery));

$(document).ready(() => $communsetting.ajax.Init());

var CommunicationSettingsDateChange = $communsetting.ajax.DateChange;