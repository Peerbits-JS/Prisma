'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $accountingconfigdocstypes= (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //base
    var constsBase = base.constantes;

    //conditions
    var constYear = 'Year', constModule = 'ModuleDescription', constType = 'TypeDescription';

    //header
    var constAlternativa = 'lblAlternativa', constAlternativeCode = 'AlternativeCode',
        constClasseIVA = 'ReflectsIVAClassByFinancialAccount', constCentrosCusto = 'ReflectsCostCenterByFinancialAccount';

    //handsontable
    var HDSNID = 'hdsnTiposDocumentos', constTipoCompoHT = constsBase.ComponentesHT, constSourceHT = constsBase.SourceHT;

    //errors
    var msgErroID = constsBase.janelasPopupIDs.Erro;

    //obj value to ValueDescription handsontable column
    var objValuesValueDescription = [
        { Id: 1, Descr: 'Iva' },
        { Id: 2, Descr: 'Mercadoria sem Iva' },
        { Id: 3, Descr: 'Mercadoria com Iva' },
        { Id: 4, Descr: 'Custo mercadoria' },
        { Id: 5, Descr: 'Custo mercadoria compras' },
        { Id: 6, Descr: 'Desconto' },
        { Id: 7, Descr: 'Total documento' },
        { Id: 8, Descr: 'Total comparticipação' },
        { Id: 9, Descr: 'Valor recebido' }
    ];

    //handsontable => array of lines to remove
    self.DocumentTypesToRemove = [];

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description Document ready function */
    self.Init = function () {
        $('#container .clsF3MInput').on('change', () => self.InputsChange());
        //remove label for AlternativeDescription to show on errors
        $('label[for=AlternativeDescription]').addClass('hidden');
    };

    //------------------------------------ I N P U T S
    /* @description Function that sets flag if has changes on container inputs to true */
    self.InputsChange = function () {
        $accountingconfigconditions.ajax.HasChangesOnContainerInputs = true;

        //check if pop up errors is visible
        if (self.IsErrorsPopUpVisible()) {
            //validate
            GrelhaUtilsValida($('#container'));
        }
    };

    //------------------------------------ A L T E R N A T I V E     C O D E
    /* @description Funcao que */
    self.GetAndSetAlternativeCode = function () {
        self.ReqGetAlternativeCode(function (res) {
            //check if has type
            if ($accountingconfigconditions.ajax.GetListViewDataItemSelectedByID(constType)) {
                //set new alterntive code
                $('#' + constAlternativeCode).val(res);
            }
            else {
                //reset alterntive code
                $('#' + constAlternativeCode).val('');
            }
        });
    };

    /* @description Funcao que */
    self.ReqGetAlternativeCode = function (fnSuccessCallback) {
        //get url
        var _url = rootDir + 'Accounting/AccountingConfiguration/GetAlternative';
        //get model
        var modelo = {};
        //get year
        var _yearDataItem = $accountingconfigconditions.ajax.GetComboDataItemSelectedByID(constYear);
        modelo['Year'] = _yearDataItem ? _yearDataItem['ID'] : null;
        //get module 
        var _moduleDataItem = $accountingconfigconditions.ajax.GetComboDataItemSelectedByID(constModule);
        modelo['ModuleCode'] = _moduleDataItem ? _moduleDataItem['Code'] : '';
        //get  type
        var _typeDataItem = $accountingconfigconditions.ajax.GetListViewDataItemSelectedByID(constType);
        modelo['TypeCode'] = _typeDataItem ? _typeDataItem['Code'] : '';
        //req with success callback
        $.post(_url, { modelo: modelo }, (res) => fnSuccessCallback(res));
    };

    /* @description Funcao que atualiza a label alternativa */
    self.AtualizaLabelAlternativa = function () {
        //get data item
        var _dtItem = $accountingconfigconditions.ajax.GetListViewDataItemSelectedByID(constType);
        var _descr = ' - ';

        if (_dtItem) {
            _descr = _dtItem['Code'] + ' - ' + _dtItem['Description'];
        }
        //set label
        $('#' + constAlternativa).text(_descr);
    };

    //------------------------------------ I V A     C L A S S
    /*@description Function change of iva class checkbox */
    self.IVAClassChange = function (elem) {
        //get state
        var IsChecked = self.GetClasseIVAState();
        //hide or show
        self.ReadOnlyColumnHT('IVAClass', IsChecked);
    };

    /*@description Function that returns checkbox iva class state (true /// false) */
    self.GetClasseIVAState = function () {
        return $('#' + constClasseIVA).is(':checked');
    };

    //------------------------------------ C O S T     C E N T E R
    /*@description Function change of cost center checkbox */
    self.CostCenterChange = function (elem) {
        //get state
        var IsChecked = self.GetCostCenterState();
        //hide or show
        self.ReadOnlyColumnHT('CostCenter', IsChecked);
    };

    /*@description Function that returns checkbox cost center state (true /// false) */
    self.GetCostCenterState = function () {
        return $('#' + constCentrosCusto).is(':checked');
    };

    //------------------------------------ H A N D S O N T A B L E 
    //---------------- I N S T A N C E
    /* @description Function that returns handsontable instance */
    self.GetHT = function () {
        return HotRegisterer.bucket[HDSNID];
    };

    /* @description Function that create handsontable and set props /// methods */
    self.SetHT = function (dataSource) {
        //remove from dom
        $('#tempHdsnDS').remove();
        //get columns
        var _columns = self.GetHTColumns();
        //hdsn
        var _hdsn = HandsonTableDesenhaNovo(HDSNID, dataSource, null, _columns, true, null, null, null, null, null, null, null, null, null, null, null);
        //update settings
        _hdsn.updateSettings({
            fillHandle: false,
            columnSorting: false,
            manualColumnResize: false,
            afterChange: self.AfterChange,
            afterCreateRow: self.AfterCreateRow,
            contextMenu: self.GetContextMenu(),
            afterRemoveRow: self.AfterRemoveRow
        });
        HandsonTableKeyUp(HDSNID);
    };

    /* @description Function that returns handsontable data source */
    self.GetHTDataSource = function () {
        //get hdsn
        var _hdsn = self.GetHT();
        //return datasource
        return $.grep(_hdsn.getSourceData(), (dataItem) => dataItem['Account']);
    };

    //---------------- C O L U M N S 
    /* @description Function that returns handsontable columns */
    self.GetHTColumns = function () {
        var _columns = [
            {
                ID: "Account",
                Label: resources['Conta'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                TamMaximo: 50,
                EObrigatorio: true,
                width: 200
            },
            {
                ID: 'ValueDescription',
                Label: resources['Valor'],
                TipoEditor: constTipoCompoHT.F3MDropDownList,
                source: $.map(objValuesValueDescription, (val) => val['Descr']),
                EObrigatorio: true,
                width: 200
            },
            {
                ID: 'NatureDescription',
                Label: resources['Natureza'],
                TipoEditor: constTipoCompoHT.F3MDropDownList,
                source: ['D', 'C'],
                EObrigatorio: true,
                width: 200
            },
            {
                ID: 'IVAClass',
                Label: resources['ClasseIVA'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                TamMaximo: 50,
                width: 200,
                readOnly: self.GetClasseIVAState()
            },
            {
                ID: 'CostCenter',
                Label: resources['CentroCusto'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                TamMaximo: 50,
                width: 200,
                readOnly: self.GetCostCenterState()
            }
        ];

        return _columns;
    };

    /* @description Function that set read only column on handsontable */
    self.ReadOnlyColumnHT = function (propCol, IsReadOnly) {
        //get hdsn
        var _hdsn = self.GetHT();
        //get index column
        var _indexCol = _hdsn.propToCol(propCol);

        for (var i = 0; i < _hdsn.countRows(); i++) {
            self.ReadOnlyColumnRowHT(_hdsn, i, _indexCol, IsReadOnly);
        }

        //render
        _hdsn.render();
    };

    /* @description Function that set read only column /// row on handsontable */
    self.ReadOnlyColumnRowHT = function (hdsn, row, col, IsReadOnly) {
        hdsn.setCellMeta(row, col, 'readOnly', IsReadOnly);
    };

    //---------------- A F T E R     C H A N G E
    /* @description Function after change for handsontable */
    self.AfterChange = function (changes, source) {
        if (source === constSourceHT.LoadData || source === constSourceHT.PopulateFromArray) { return; }
        //set props
        var _hdsn = this;
        var _row = changes[0][0];
        var _prop = changes[0][1];
        var _oldValue = changes[0][2];
        var _newValue = changes[0][3];
        //after change cols
        if (_oldValue !== _newValue) {
            switch (_prop) {
                case 'ValueDescription':
                    self.AfterChange_ValueDescription(_hdsn, _row, _newValue);
                    break;
            }
            //sets flag if has changes on container inputs to true
            $accountingconfigconditions.ajax.HasChangesOnContainerInputs = true;
            //set dirty
            var form = $('.' + base.constantes.tiposComponentes.grelhaForm).attr('id');
            GrelhaFormAtivaDesativaBotoesAcoes(form, true);
        }        
    };

    /* @description Function after change column value description for handsontable */
    self.AfterChange_ValueDescription = function (hdsn, row, value) {
        //get idvalor
        var _idValor = $.grep(objValuesValueDescription, (data) => data['Descr'] === value)[0];

        if (_idValor) {
            //set id valor
            hdsn.setDataAtRowProp(row, 'ValueId', _idValor['Id']);
        }
    };

    //---------------- A F T E R     C R E A T E     R O W
    /* @description Function after create row for handsontable */
    self.AfterCreateRow = function (index, amount, source) {
        //get hdsn
        var _hdsn = this;

        //trata bloqeuio coluna IVAClass
        //  get index column
        var _indexColIVAClass = _hdsn.propToCol('IVAClass');
        //   get is read only
        var IsReadOnlyIVAClass = self.GetClasseIVAState();
        self.ReadOnlyColumnRowHT(_hdsn, index, _indexColIVAClass, IsReadOnlyIVAClass);

        //trata bloqeuio coluna CostCenter
        //  get index column
        var _indexColCostCenter = _hdsn.propToCol('CostCenter');
        //   get is read only
        var IsReadOnlyICostCenter = self.GetCostCenterState();
        self.ReadOnlyColumnRowHT(_hdsn, index, _indexColCostCenter, IsReadOnlyICostCenter);

        //render
        _hdsn.render();
    };

    //---------------- A F T E R     R E M O V E     R O W
    /* @description Function after remove row for handsontable */
    self.AfterRemoveRow = function (index, amount, physicalRows, source) {
        //sets flag if has changes on container inputs to true
        $accountingconfigconditions.ajax.HasChangesOnContainerInputs = true;
        //set dirty
        var form = $('.' + base.constantes.tiposComponentes.grelhaForm).attr('id');
        GrelhaFormAtivaDesativaBotoesAcoes(form, true);
    };

    //---------------- C O N T E X T     M E N U
    /* @description Function that returns context menu for handsontable */
    self.GetContextMenu = function () {
        //get context menu
        var _contextMenu = {
            items: {
                "remove_row": { 
                    name: resources['RemoverLinhaHT'],
                    disabled: function () {
                        //disable option when last row was clicked
                        return this.getSelected()[0][0] === this.countRows() - 1; 
                    },
                    callback: function () {
                        //get hdsn
                        var _hdsn = this;
                        //get selected row
                        var _selectedRow = _hdsn.getSelected()[0][0];
                        //push to remove lines
                        var _dataItemToRemove = _hdsn.getSourceData()[_selectedRow];
                        if (_dataItemToRemove['Id']) {
                            _dataItemToRemove['EntityState'] = 2;
                            self.DocumentTypesToRemove.push(_dataItemToRemove);
                        }
                        //remove row
                        this.alter('remove_row', _selectedRow);
                    }
                }
            }
        };
        //return context menu
        return _contextMenu;
    } 

    //------------------------------------ A U X     F U N C T I O N S
    /*@descripton Function that returns if pop up errors is visible */
    self.IsErrorsPopUpVisible = function () {
        //get pop up erros
        var _popUpErros = $('#' + msgErroID).data('kendoWindow');
        //return if is visible
        return _popUpErros && _popUpErros.options.visible;
    };

    return parent;

}($accountingconfigdocstypes || {}, jQuery));

//this
var ContabilidadeConfigTiposDocsInit = $accountingconfigdocstypes.ajax.Init;
//iva class
var ContabilidadeConfigTiposDocsIVAClassChange = $accountingconfigdocstypes.ajax.IVAClassChange;
//cost center
var ContabilidadeConfigTiposDocsCostCenterChange = $accountingconfigdocstypes.ajax.CostCenterChange;

//doc ready
$(document).ready(() => $accountingconfigdocstypes.ajax.Init());