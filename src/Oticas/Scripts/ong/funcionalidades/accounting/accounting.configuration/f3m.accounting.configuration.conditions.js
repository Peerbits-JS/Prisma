'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $accountingconfigconditions = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T S
    //form
    var constID = 'ID';

    //conditions
    var constYear = 'Year', constModule = 'ModuleDescription', constType = 'TypeDescription';

    //badges
    var constBadges = { year: 'CLSF3MLadoEsqYear', module: 'CLSF3MLadoEsqModule', type: 'CLSF3MLadoEsqType' };

    //container
    var consIDContainer = 'container', constSpanSemLinhas = 'span-sem-linhas';

    // flag if has changes on container inputs
    self.HasChangesOnContainerInputs = true;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description Document ready function */
    self.Init = function () {
        //set list view
        self.SetListView();
    };

    //------------------------------------ B A D G E S
    /* @description Functions that updates badge by combo */
    self.SetBadgeByCombo = function (comboId, badge) {
        //get data item
        var _dtItem = self.GetComboDataItemSelectedByID(comboId);
        var _descr = ' - ';

        if (_dtItem) {
            _descr = _dtItem['Description'];
        }
        //set badge
        $('.' + badge).text(_descr);
    };

    /* @description Functions that updates badge by list view */
    self.SetBadgeByListView = function (listViewId, badge) {
        //get data item
        var _dtItem = self.GetListViewDataItemSelectedByID(listViewId);
        var _descr = ' - ';

        if (_dtItem) {
            _descr = _dtItem['Description'];
        }
        //set badge
        $('.' + badge).text(_descr);
    };

    //------------------------------------ Y E A R
    /*@description Function after change  of year combo */
    self.YearChange = function (combo) {
        if (!self.IsContainerVisible()) {
            self.RenderContainer();
        }
        else {
            //get module  code
            var _moduleCode = self.GetModuleCode();

            if (_moduleCode !== '008') {
                //set alternative code
                $accountingconfigdocstypes.ajax.GetAndSetAlternativeCode();
            }
        }
        //set year badge
        self.SetBadgeByCombo(constYear, constBadges.year);
    };

    //------------------------------------ M O D U L E
    //flag if combo moudule is with event prevented
    self.IsModuleComboPrevented = false;

    /*@description Function after change  of module combo */
    self.ModuleChange = function (combo) {
        // verifica se a combo esta com o evento prevented
        if (!self.IsModuleComboPrevented) {
            //get list view
            var _elemListView = $('#' + constType).data("kendoListView");

            if (_elemListView) {
                //read ds
                _elemListView.dataSource.read();
            }

            if (!self.IsContainerVisible() || !UtilsVerificaObjetoNotNullUndefinedVazio(combo.value())) {
                //clear container
                self.SetHTMLOnContainer('');
            }

            //atualiza badge
            self.SetBadgeByCombo(constModule, constBadges.module);
        }
    };

    /*@description Function select of module combo */
    self.ModuleSelect = function (combo) {
        //get old code
        var _oldCode = combo.sender.dataItem().Code;
        //get new code
        var _newCode = combo.dataItem.Code;
        //check if do ask 
        var _DoAsk = self.IsContainerVisible() && _oldCode && _oldCode !== _newCode && (_oldCode === '008' || _newCode === '008');

        if (_DoAsk && self.HasChangesOnContainerInputs) {
            //set flag to true
            self.IsModuleComboPrevented = true;
            //prevent combo 
            combo.preventDefault();
            //ask
            UtilsConfirma(base.constantes.tpalerta.question, resources['ConfiguracaoContabilidadeAlterouModulo'], function () {
                //set flag to false
                self.IsModuleComboPrevented = false;
                //clear container
                self.SetHTMLOnContainer('');
                //set new value
                combo.sender.value(combo.dataItem['Description']);
                //trigger change 
                self.ModuleChange(combo.sender);
            }, function () {
                //set 
                self.IsModuleComboPrevented = false;
            });
        }
        else if (_DoAsk && !self.HasChangesOnContainerInputs) {
            //clear container
            self.SetHTMLOnContainer('');
        }
    };

    /*@description Function data bound of module combo */
    self.ModuleDataBound = function (combo) {
        if ($accountingconfig.ajax.IsOnCopyMode()) {
            KendoDesativaElemento('ModuleDescription', true);
        }
    };

    /*@description Function that returns module code selected */
    self.GetModuleCode = function () {
        //get module
        var _module = self.GetComboDataItemSelectedByID(constModule);
        //return module
        return _module ? _module['Code'] : null;
    };

    //------------------------------------ T Y P E
    /*@description Function that send parameters of type list view */
    self.TypeSendParams = function () {
        var reqParams = { modelo: {} };
        //get dataitem
        var _dataItem = self.GetComboDataItemSelectedByID(constModule);

        if (_dataItem) {
            reqParams.modelo['Id'] = _dataItem['Id'];
            reqParams.modelo['Code'] = _dataItem['Code'];
            reqParams.modelo['Description'] = _dataItem['Description'];
        }
        else if ($accountingconfig.ajax.IsOnCopyMode()) {
            reqParams.modelo['Id'] = $('#ModuleCodeOnUpdate').val();
            reqParams.modelo['Code'] = $('#ModuleCodeOnUpdate').val();
            reqParams.modelo['Description'] = $('#ModuleDescriptionOnUpdate').val();
        }

        return reqParams;
    };

    /*@description Function after change of type list view */
    self.TypeChange = function (listView) {
        var IsCopyModeValid = ($accountingconfig.ajax.IsOnCopyMode() && $('#ModuleCodeOnUpdate').val() !== '008') || !$accountingconfig.ajax.IsOnCopyMode();
        if ($('#' + constID).val() === '0' && IsCopyModeValid) {
            //get module  code
            var _moduleCode = self.GetModuleCode();

            if (!self.IsContainerVisible()) {
                self.RenderContainer(() => {

                    if (_moduleCode !== '008') {
                        //set alternative code
                        $accountingconfigdocstypes.ajax.GetAndSetAlternativeCode();
                        //atualiza label alternativa
                        $accountingconfigdocstypes.ajax.AtualizaLabelAlternativa();
                    }
                    else {
                        $accountingconfigentities.ajax.GetEntities();
                    }
                });
            }
            else {
                if (_moduleCode !== '008') {
                    //set alternative code 
                    $accountingconfigdocstypes.ajax.GetAndSetAlternativeCode();
                    //set alternative label
                    $accountingconfigdocstypes.ajax.AtualizaLabelAlternativa();
                }
                else {
                    $accountingconfigentities.ajax.GetEntities();
                }
            }

            //set badge
            self.SetBadgeByListView(constType, constBadges.type);
        }
        else {
            if (listView.sender.select().index() === -1) {
                //get item to select
                var itemToSelect = listView.sender.element.children().first();
                //select item
                listView.sender.select(itemToSelect);
            }
        }
    };

    /*@description Function select of type list view */
    self.TypeChooseItem = function (e) {
        if ($('#' + constID).val() === '0' && self.IsContainerVisible() && !$accountingconfig.ajax.IsOnCopyMode()) {
            //get module  code
            var _moduleCode = self.GetModuleCode();
            //check if module code  equals to tables and has changes on inputs
            if (_moduleCode === '008' && self.HasChangesOnContainerInputs) {
                //get new item
                var newSelectedItem = $(e.currentTarget).attr('data-uid');
                //stop change function
                e.stopImmediatePropagation();
                //ask if has changes
                UtilsConfirma(base.constantes.tpalerta.question, resources['ConfiguracaoContabilidadeAlterouModulo'], function () {
                    self.HasChangesOnContainerInputs = false;
                    var listView = $("#TypeDescription").data("kendoListView");
                    listView.select(listView.element.find('[data-uid="' + newSelectedItem + '"]'));
                }, function () { });
            }
        }
    };

    /*@description Function data bound of type list view */
    self.TypeDataBound = function (listView) {
        if ($accountingconfig.ajax.IsOnCopyMode()) {
            //get uid to select
            var uid = $.grep(listView.items, function (dataItem) {
                return dataItem['Code'] === $('#TypeCodeOnUpdate').val();
            })[0]['uid'];
            //get item to select
            let itemToSelect = listView.sender.element.find('[data-uid="' + uid + '"]');

            if ($('#ModuleCodeOnUpdate').val() === '008') {
                //disabled item
                itemToSelect.addClass('k-state-disabled');
            }
            //select item
            listView.sender.select(itemToSelect);
        }
        else {
            if ($('#' + constID).val() === '0') {
                //atualiza label alternativa
                var _moduleCode = self.GetModuleCode();

                if (self.IsContainerVisible() && UtilsVerificaObjetoNotNullUndefinedVazio(_moduleCode) && _moduleCode !== '008') {
                    //set alternative code 
                    $accountingconfigdocstypes.ajax.GetAndSetAlternativeCode();
                    //set alternative label
                    $accountingconfigdocstypes.ajax.AtualizaLabelAlternativa();
                }

                //set type badge
                self.SetBadgeByCombo(constType, constBadges.type);
            }
            else {
                //get item to select
                let itemToSelect = listView.sender.element.children().first();
                //disabled item
                itemToSelect.addClass('k-state-disabled');
                //select item
                listView.sender.select(itemToSelect);
            }
        }
        //bind choose item
        $('.items').on('click', (e) => self.TypeChooseItem(e));
    };

    /*@description Function that returns data source to type list view */
    self.TypeGetDataSource = function () {
        //get datasource
        var typeDataSource = [];

        var IsCopyModeValid = ($accountingconfig.ajax.IsOnCopyMode() && $('#ModuleCodeOnUpdate').val() !== '008') || !$accountingconfig.ajax.IsOnCopyMode();
        if ($('#' + constID).val() === '0' && IsCopyModeValid) {
            typeDataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        url: '../Accounting/AccountingConfiguration/GetTypes',
                        dataType: "json",
                        type: 'POST',
                        data: self.TypeSendParams
                    }
                },
                pageSize: 15
            });
        }
        else {
            typeDataSource = [{
                Code: $('#TypeCodeOnUpdate').val(),
                Description: $('#TypeDescriptionOnUpdate').val()
            }];
        }

        return typeDataSource;
    };

    //------------------------------------ C O N T A I N E R
    /*@description Function that returns if container is visible (has class hidden) */
    self.IsContainerVisible = function () {
        return $('.clsF3MSemLinhas').hasClass('hidden');
    };

    /*@description Request to render container */
    self.ReqContainer = function (fnSuccessCallback) {
        //get module
        var _module = self.GetComboDataItemSelectedByID(constModule);
        //get url
        var _url = self.GetActionUrlToContainer(_module);
        //request
        $.get(_url, x => {
            typeof fnSuccessCallback === 'function' ? fnSuccessCallback(x) : null;
        });
    };

    /*@description Function that render container */
    self.RenderContainer = function (fnSuccessCallback) {
        var _year = self.GetComboDataItemSelectedByID(constYear);
        var _module = self.GetComboDataItemSelectedByID(constModule);
        var _type = self.GetListViewDataItemSelectedByID(constType);

        if (_year && _module && _type) {
            //loading to true
            KendoLoading($('#' + consIDContainer), true);
            //req
            self.ReqContainer((x) => {
                //set html on container
                self.SetHTMLOnContainer(x);
                //loading to false
                KendoLoading($('#' + consIDContainer), false);
                typeof fnSuccessCallback === 'function' ? fnSuccessCallback(x) : null;
            });
        }
        else {
            self.SetHTMLOnContainer('');
        }
    };

    /*@description Function that sets html on container */
    self.SetHTMLOnContainer = function (htmlToContainer) {
        if (UtilsVerificaObjetoNotNullUndefinedVazio(htmlToContainer)) {
            $('#' + constSpanSemLinhas).addClass('hidden');
        }
        else {
            $('#' + constSpanSemLinhas).removeClass('hidden');
        }
        //set html
        $('#' + consIDContainer).html(htmlToContainer);

        //sets flag if has changes on container inputs to true
        self.HasChangesOnContainerInputs = false;
    };

    //------------------------------------ A U X     F U N C T I O N S
    /* @description Function that create list view and set props /// methods */
    self.SetListView = function () {
        //trata kendo loading 
        kendo.ui.ListView.fn._progress = function () {
            FrontendTrataMaskKendoLoading(this.element, !0);
        };
        //set datasource
        var dataSource = self.TypeGetDataSource();
        //controi list view
        $('#' + constType).kendoListView({
            dataSource: dataSource,
            selectable: 'single',
            template: kendo.template($("#template").html()),
            navigatable: false,
            change: self.TypeChange,
            dataBound: self.TypeDataBound
        });
    };

    /*@description Function that returns data item selected by id combo */
    self.GetComboDataItemSelectedByID = function (comboId) {
        var _DSItemSelected = null;
        //get combo
        var _elemCombo = KendoRetornaElemento($('#' + comboId));

        if (_elemCombo && _elemCombo.selectedIndex !== 0) {
            //get dataitem
            var _comboDataItem = _elemCombo.dataItem();

            if (_comboDataItem) {
                //set dataitem
                _DSItemSelected = _comboDataItem;
            }
        }
        //return seleced dataitem
        return _DSItemSelected;
    };

    /*@description Function that returns data item selected by id list view */
    self.GetListViewDataItemSelectedByID = function (listViewId) {
        var _DSItemSelected = null;
        //get list view
        var _elemListView = $('#' + listViewId).data("kendoListView");

        if (_elemListView) {
            //get index
            var _index = _elemListView.select().index();

            if (_index !== -1) {
                //set _DSItemSelected
                _DSItemSelected = _elemListView.dataSource.view()[_index];
            }
        }
        //return seleced dataitem
        return _DSItemSelected;
    };

    /*@description Function that return action to render container */
    self.GetActionUrlToContainer = function (elemModule) {
        //get url
        var _url = rootDir + 'Accounting/AccountingConfiguration/';
        //get module
        var _module = self.GetModuleCode();

        switch (_module) {
            case '008': //tabelas
                _url += 'GetAccounts';
                break;

            default:
                _url += 'GetDocumentTypes';
        }
        //return url
        return _url;
    };

    return parent;

}($accountingconfigconditions || {}, jQuery));

//this
var AccountingConfigConditionsInit = $accountingconfigconditions.ajax.Init;
//year
var AccountingConfigConditionsYearChange = $accountingconfigconditions.ajax.YearChange;
//module
var AccountingConfigConditionsModuleChange = $accountingconfigconditions.ajax.ModuleChange;
var AccountingConfigConditionsModuleSelect = $accountingconfigconditions.ajax.ModuleSelect;
var AccountingConfigConditionsModuleDataBound = $accountingconfigconditions.ajax.ModuleDataBound;

//doc ready
$(document).ready(() => AccountingConfigConditionsInit());