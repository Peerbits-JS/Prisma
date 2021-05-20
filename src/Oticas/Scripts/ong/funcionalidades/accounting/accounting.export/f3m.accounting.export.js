'use strict';

const constsBase = base.constantes;
const constTipoCompoHT = constsBase.ComponentesHT;
const constSourceHT = constsBase.SourceHT;
const constDivDocumentsGrid = 'divDocumentsGrid';
const constDivMovementsDetailGrid = 'divMovementsDetailGrid';
const constDocumentsGrid = 'documentsGrid';
const constMovementsDetailGrid = 'movementsDetailGrid';
const constUrl = rootDir + 'Accounting/AccountingExport/';
const constDocumentsRequest = 'GetDocuments';
const constMovementsDetailRequest = 'GetDocumentsDetails';
const constGenerateMovements = 'GenerateMovements';
const constExportFile = 'ExportFile';

class Filter {
    static getFilter() {
        var res = GrelhaUtilsGetModeloForm(GrelhaFormDTO($('#contabilidadeExportacao')));

        var modulesElem = $('#ModulesId').data('kendoMultiSelect');
        res.ModulesCode = modulesElem ? modulesElem.dataItems().map(x => x.Code) : [];
        res.ModulesId = res.ModulesId || [];

        var documentTypesElem = $('#DocumentTypesId').data('kendoMultiSelect');
        res.DocumentTypesCode = documentTypesElem ? documentTypesElem.dataItems().map(x => x.Code) : [];
        res.DocumentTypesId = res.DocumentTypesId || [];

        res.DocumentNumber = (res.DocumentNumber) ? parseInt(res.DocumentNumber) : null;

        return res;
    }
}

class Documents {
    constructor() {
        this.isMovementDetailVisible = $('#tabMovementsDetail.active').length > 0;
        this.idGrid = this.isMovementDetailVisible ? constMovementsDetailGrid : constDocumentsGrid;
        this.url = this.isMovementDetailVisible ? constMovementsDetailRequest : constDocumentsRequest;
        this.selected = [];
    }

    static setSelected(inArray) {
        this.selected = inArray;
    }

    static getSelected() {
        return this.selected;
    }

    showTabDocuments() {
        $('.bts-modo-edita').show();
        if ($('#' + constDocumentsGrid).is(':empty'))
            this.createGrid();
        this.renderGrid();
    }

    showTabMovementsDetail() {
        $('.bts-modo-edita').hide();
        $('#' + constMovementsDetailGrid).is(':empty') ? this.createGrid() : this.loadGrid();
        this.renderGrid();
    }

    createGrid() {
        const _columns = this.getGridColumns();
        const _objParamsHT = { pageable: true, pageSize: 250 };
        HandsonTableDesenhaNovo(this.idGrid, [], 400, _columns, true, null, null, null, null, null, null, null, null, null, null, null, _objParamsHT);
        this.loadGrid();
        HotRegisterer.bucket[this.idGrid].updateSettings({ selectionMode: true });
    }

    loadGrid() {
        const that = this;
        const url = constUrl + that.url;
        var params = { model: { filter: Filter.getFilter(), Documents: Documents.getSelectedDocuments() } };

        UtilsChamadaAjax(url, true, JSON.stringify(params), res => {
            if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                this.loadGridSuccessCallback(res);
            }
        }, function (e) { throw e; }, 1, true);
    }

    loadGridSuccessCallback(res) {
        if (res && res.length) {
            $('.clsF3MTextoSemLinhas').addClass('hidden');
            $('.clsF3MGrids').removeClass('hidden');

            const ht = Documents.getGrid();
            if (ht) {
                ht.loadData(res);
            }
        }
        else {
            if (this.idGrid !== 'movementsDetailGrid') {
                $('.clsF3MGrids').addClass('hidden');
                $('.clsF3MTextoSemLinhas').removeClass('hidden');
            }
        }
    }

    renderGrid() {
        const ht = Documents.getGrid();
        if (ht) {
            var _height = $('#iframeBody').height() - 150;
            ht.updateSettings({
                height: _height,
                selectionMode: 'single'
            });
            ht.render();
        }
    }

    getGridColumns() {
        if (!this.isMovementDetailVisible) {
            return [{
                ID: 'Selected',
                Label: '<input id="checkBoxColumn" class="htCheckboxRendererInput" autocomplete="off" type="checkbox" onClick="accountingexportcheckalldocuments(this);">',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                width: 40,
                readOnly: false
            }, {
                ID: "Store",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Loja'],
                readOnly: true,
                width: 80
            }, {
                ID: 'DocumentModuleTypeDescription',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Modulo'],
                readOnly: true,
                width: 80
            }, {
                ID: 'Document',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Documento'],
                readOnly: true,
                width: 100
            }, {
                ID: 'DocumentDateFormated',
                TipoEditor: constTipoCompoHT.F3MData,
                Label: resources['Data'],
                readOnly: true,
                width: 90
            }, {
                ID: 'Value',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources['Valor'],
                readOnly: true,
                width: 75,
                CasasDecimais: 2
            }, {
                ID: 'EntityType',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['TipoTerceiro'],
                readOnly: true,
                width: 75
            }, {
                ID: 'Entity',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Terceiro'],
                readOnly: true,
                width: 150
            }, {
                ID: 'IsGenerated',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: resources['Gerado'],
                readOnly: true,
                width: 75
            }, {
                ID: 'IsExported',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: resources['Exportado'],
                readOnly: true,
                width: 75
            }, {
                ID: 'HasErrors',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: resources['Erros'],
                readOnly: true,
                width: 75
            }, {
                ID: 'ErrorNotes',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Observacoes'],
                readOnly: true,
                renderer: Documents.setTextWithTooltip,
                width: 200
            }];
        } else {
            return [{
                ID: "StoreCode",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Loja'],
                readOnly: true,
                width: 80
            }, {
                ID: 'DocumentModuleTypeDescription',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Modulo'],
                readOnly: true,
                width: 80
            }, {
                ID: 'Document',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Documento'],
                readOnly: true,
                width: 100
            }, {
                ID: 'DocumentDateFormated',
                TipoEditor: constTipoCompoHT.F3MData,
                Label: resources['Data'],
                readOnly: true,
                width: 90
            }, {
                ID: 'Account',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Conta'],
                readOnly: true,
                width: 100
            }, {
                ID: 'Value',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: resources['Valor'],
                readOnly: true,
                width: 75,
                CasasDecimais: 2
            }, {
                ID: 'NatureDescription',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Natureza'],
                readOnly: true,
                width: 65
            }, {
                ID: 'VatClassAccount',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['ClasseIVA'],
                readOnly: true,
                width: 100
            }, {
                ID: 'CostCenterAccount',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['CentroCusto'],
                readOnly: true,
                width: 100
            }, {
                ID: 'ReflectsVatClass',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: 'R. IVA',
                readOnly: true,
                width: 65
            }, {
                ID: 'ReflectsCostCenter',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: 'R. CC',
                readOnly: true,
                width: 65
            }, {
                ID: 'IsGenerated',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: resources['Gerado'],
                readOnly: true,
                width: 75
            }, {
                ID: 'IsExported',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: resources['Exportado'],
                readOnly: true,
                width: 75
            }, {
                ID: 'HasErrors',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: resources['Erros'],
                readOnly: true,
                width: 75
            }, {
                ID: 'ErrorNotes',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Observacoes'],
                readOnly: true,
                renderer: Documents.setTextWithTooltip,
                width: 200
            }];
        }
    }

    static setTextWithTooltip(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.cellTypes.text.renderer.apply(this, arguments);
        let escapedText = Handsontable.helper.stringify(value);

        if (value) {
            $(td)
                .text(escapedText)
                .addClass('info-tooltip')
                .attr({
                    'data-toggle': 'tooltip',
                    'data-original-title': value,
                    'data-container': 'body'
                })
                .tooltip();
        }
    }

    clearContent() {
        HotRegisterer.bucket.documentsGrid ? HotRegisterer.bucket.documentsGrid.destroy() : true;
        HotRegisterer.bucket.movementsDetailGrid ? HotRegisterer.bucket.movementsDetailGrid.destroy() : true;
        HotRegisterer.remover(constDocumentsGrid);
        HotRegisterer.remover(constMovementsDetailGrid);
        $('#' + constDocumentsGrid).empty().siblings().remove();
        $('#' + constMovementsDetailGrid).empty().siblings().remove();
    }

    static getGrid() { return HotRegisterer.getInstance(new Documents().idGrid); }

    static getSelectedDocuments() {
        var ht = HotRegisterer.getInstance(constDocumentsGrid);
        if (ht)
            return ht.getSettings()['F3MDataSource']['data'].filter(x => x.Selected);
    }

    static checkAllDocuments(checkbox) {
        const chkval = $(checkbox).is(':checked');
        const ht = Documents.getGrid();
        const newColHeaders = ht.getColHeader();
        ht.getSettings().F3MDataSource.data.forEach(x => x.Selected = chkval);
        ht.getSourceData().forEach(x => x.Selected = chkval);
        newColHeaders[0] = chkval ? newColHeaders[0].replace('type="checkbox"', 'type="checkbox" checked="checked" ') : newColHeaders[0].replace('checked="checked"', '');
        ht.updateSettings({ colHeaders: newColHeaders });
    }

    static hasSelectedDocuments() { return this.getSelectedDocuments().length; }

    static hasGeneratedMovements() { return Documents.getGrid().getSettings()['F3MDataSource']['data'].filter(x => x.Selected && x.IsGenerated).length; }

    static hasDocumentsWithNoGeneratedMovements() { return Documents.getGrid().getSettings()['F3MDataSource']['data'].filter(x => x.Selected && !x.IsGenerated).length; }

    static hasDocumentsWithMovementsGenerationErrors() { return Documents.getGrid().getSettings()['F3MDataSource']['data'].filter(x => x.Selected && x.HasErrors).length; }
}

class AccountingExport {
    constructor() { }

    init() {
        $("a[href='#TabConditions']").on("shown.bs.tab", () => { this.showTabConditions(); });

        $("a[href='#TabData']").on("click", () => { this.validateShowTabData(); }).on("shown.bs.tab", () => { this.showTabData(); });

        $("a[href='#tabDocuments']").on("shown.bs.tab", () => { new Documents().showTabDocuments(); });

        $("a[href='#tabMovementsDetail']").on("shown.bs.tab", () => { new Documents().showTabMovementsDetail(); });

        $("#btnApplyFilter").on("click", () => { if (this.validateShowTabData()) { $("a[href='#TabData']").click(); } });

        $("#btnGM").on("click", () => { AccountingExport.validateGenerateMovements(); });

        $("#btnEF").on("click", () => { AccountingExport.validateExportFile(); });

        $("#btnReset").on("click", () => { AccountingExport.refresh(); });
    }

    showTabConditions() {
        $("a[href='#TabData']").removeClass('active');
        $("a[href='#TabConditions']").addClass('active');
        new Documents().clearContent();
    }

    validateShowTabData() {
        var errosForm = GrelhaUtilsValida($('#contabilidadeExportacao'));
        if (errosForm && errosForm.length) {
            event.preventDefault();
            event.stopImmediatePropagation();
            event.stopPropagation();
            return false;
        }

        if (new Date(KendoRetornaElemento($('#InitDate')).value()).getFullYear() !== new Date(KendoRetornaElemento($('#EndDate')).value()).getFullYear()) {
            UtilsAlerta(base.constantes.tpalerta.i, "O intervalo de datas deve pertencer ao mesmo ano.");
            event.preventDefault();
            event.stopImmediatePropagation();
            event.stopPropagation();
            return false;
        }

        return true;
    }

    showTabData() {
        $("a[href='#TabConditions']").removeClass('active');
        $("a[href='#TabData']").addClass('active');
        new Documents().showTabDocuments();
    }

    static changeInitDate(elemDate) {
        AccountingExport.validateDates(elemDate);
        AccountingExport.readModules();
        AccountingExport.readDocumentTypes();
    };

    static changeEndDate(elemDate) {
        AccountingExport.validateDates(elemDate);
        AccountingExport.readModules();
        AccountingExport.readDocumentTypes();
    }

    static validateDates(elemDate) {
        var _date = elemDate.sender.element.val();
        if (!ValidaData(_date)) {
            elemDate.sender.value(new Date);
        }
    }

    static readDocumentTypes() {
        var docsTypesMultiSelect = $("#DocumentTypesId").data('kendoMultiSelect');
        docsTypesMultiSelect.dataSource.read();
    }

    static readModules() {
        var modulesMultiSelect = $("#ModulesId").data('kendoMultiSelect');
        modulesMultiSelect.dataSource.read();
    }

    static validateGenerateMovements() {
        if (!Documents.hasSelectedDocuments()) {
            UtilsAlerta(base.constantes.tpalerta.i, "Tem que selecionar pelo menos 1 linha!");
        } else if (Documents.hasGeneratedMovements()) {
            UtilsConfirma(base.constantes.tpalerta.question,
                "Já existem movimentos gerados para algum dos documentos selecionados, pretende atualizar movimento gerado?", function () {
                    AccountingExport.generateMovements();
                }, function () { });
        } else {
            AccountingExport.generateMovements();
        }
    }

    static generateMovements() {
        const url = constUrl + constGenerateMovements;
        var params = { model: { filter: Filter.getFilter(), Documents: Documents.getSelectedDocuments() } };

        Documents.setSelected(params.model.Documents.filter(x => x.Selected));

        UtilsChamadaAjax(url, true, JSON.stringify(params),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                    var arrId = Documents.getSelected().map(x => x.Id);
                    var arrCode = Documents.getSelected().map(x => x.DocumentModuleTypeCode);
                    res.filter(value => arrId.includes(value.Id) && arrCode.includes(value.DocumentModuleTypeCode)).map(x => x.Selected = true);
                    var ht = Documents.getGrid();
                    if (ht)
                        ht.loadData(res);
                    UtilsNotifica(base.constantes.tpalerta['s'], "Gerado com sucesso!");
                }
            }, function (e) { throw e; }, 1, true);
    }

    static validateExportFile() {
        !Documents.hasSelectedDocuments() ? UtilsAlerta(base.constantes.tpalerta.i, "Tem que selecionar pelo menos 1 linha!") : AccountingExport.validateNoGeneratedMovements();
    }

    static validateNoGeneratedMovements() {
        if (Documents.hasDocumentsWithNoGeneratedMovements()) {
            UtilsConfirma(base.constantes.tpalerta.question,
                "Existem documentos sem movimento gerado, esses documentos não serão exportados para o ficheiro. Pretende continuar?", function () {
                    AccountingExport.validateMovementsGenerationErrors();
                }, function () { });
        } else {
            AccountingExport.validateMovementsGenerationErrors();
        }
    }

    static validateMovementsGenerationErrors() {
        if (Documents.hasDocumentsWithMovementsGenerationErrors()) {
            UtilsConfirma(base.constantes.tpalerta.question,
                "Existem documentos com movimento gerado em erro. O ficheiro a gerar terá esses movimentos com erro. Pretende continuar?", function () {
                    AccountingExport.exportFile();
                }, function () { });
            return false;
        } else {
            AccountingExport.exportFile();
        }
    }

    static exportFile() {
        const url = constUrl + constExportFile;
        var params = { model: { filter: Filter.getFilter(), Documents: Documents.getSelectedDocuments() } };

        UtilsChamadaAjax(url, true, JSON.stringify(params),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                    window.location.href = constUrl + '/DownloadFile' + '?id=' + res.id;
                }
            }, function (e) { throw e; }, 1, true);
    }

    static refresh() {
        new Documents().loadGrid();
    }

    static parameterSendModule() {
        return { filter: Filter.getFilter() };
    }

    static changeModule() {
        var dt = $("#DocumentTypesId").data('kendoMultiSelect');
        dt.dataSource.read();
    }

    static deselectModule(e) {
        var dt = $("#DocumentTypesId").data('kendoMultiSelect');
        dt.value([]);
    }

    static parameterSend() {
        return { filter: Filter.getFilter() };
    }
}

var accountingexportchangenitdate = AccountingExport.changeInitDate;
var accountingexportchangeenddate = AccountingExport.changeEndDate;

var accountingexportcheckalldocuments = Documents.checkAllDocuments;

var accountingexportmodulesendparameter = AccountingExport.parameterSendModule;
var accountingexportchangemodule = AccountingExport.changeModule;
var accountingexportdeselectmodule = AccountingExport.deselectModule;

var accountingexportparametersend = AccountingExport.parameterSend;

$(document).ready(() => new AccountingExport().init());

$(document).ajaxSend(function (inEvent, jqxhr, inSettings) {
    var elem = $('#iframeBody');
    KendoLoading(elem, true);
}).ajaxStop(function () {
    var elem = $('#iframeBody');
    KendoLoading(elem, false);
});