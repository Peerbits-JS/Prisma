'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $accountingconfig = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T S
    //form
    var constID = 'ID', constCopyMode = 'IsOnCopyMode';

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description Document ready function */
    self.Init = function () {
    };

    //------------------------------------ C R U D
    /* @description Function that returns specific model */
    self.GetSpecificModel = function (model) {
        //set year
        // model['Year'] = model['Year'];

        if ($('#' + constID).val() === '0') {
            //set module
            model['ModuleCode'] = $accountingconfigconditions.ajax.GetModuleCode();
            var _moduleDataItem = $accountingconfigconditions.ajax.GetComboDataItemSelectedByID('ModuleDescription');
            if (_moduleDataItem) {
                model['ModuleDescription'] = _moduleDataItem['Description'];
            }
            //set type
            var _typeDataItem = $accountingconfigconditions.ajax.GetListViewDataItemSelectedByID('TypeDescription');
            if (_typeDataItem) {
                model['Type'] = _typeDataItem['Id'];
                model['TypeCode'] = _typeDataItem['Code'];
                model['TypeDescription'] = _typeDataItem['Description'];
            }
        }
        else {
            model['ModuleCode'] = $('#ModuleCodeOnUpdate').val();
            model['ModuleDescription'] = $('#ModuleDescriptionOnUpdate').val();
            //set type
            model['TypeCode'] = $('#TypeCodeOnUpdate').val();
            model['TypeDescription'] = $('#TypeDescriptionOnUpdate').val();
        }

        //set lines to model
        self.SetLinesToModel(model);

        //return model
        return model;
    };

    /* @description funcao especifica que valida antes de gravar */
    self.ValidaGravaEspecifico = function (evt, inArrTabelas, inGrelha, inFormulario, inURL, inModelo, inElemBtID) {
        var arrTokensToValidate = ['A', 'E', 'F', 'G', 'I', 'L', 'M', 'N','P','T'];
        var arrIndexTokensError = [];

        if (inModelo.DocumentTypes) {
            for (var i = 0; i < inModelo.DocumentTypes.length; i++) {
                if (inModelo.DocumentTypes[i].Account) {
                    var lettersFromAccount = inModelo.DocumentTypes[i].Account.replace(/[0-9]/g, '').toUpperCase().split('');
                    if (lettersFromAccount.length) {
                        for (var k = 0; k < lettersFromAccount.length; k++) {
                            if (arrTokensToValidate.indexOf(lettersFromAccount[k]) < 0) {
                                arrIndexTokensError.push(i);
                            }
                        }
                    }
                }
                if (inModelo.DocumentTypes[i].IVAClass) {
                    var lettersFromIVAClass = inModelo.DocumentTypes[i].IVAClass.replace(/[0-9]/g, '').toUpperCase().split('');
                    if (lettersFromIVAClass.length) {
                        for (var k = 0; k < lettersFromIVAClass.length; k++) {
                            if (arrTokensToValidate.indexOf(lettersFromIVAClass[k]) < 0) {
                                arrIndexTokensError.push(i);
                            }
                        }
                    }
                }
                if (inModelo.DocumentTypes[i].CostCenter) {
                    var lettersFromCostCenter = inModelo.DocumentTypes[i].CostCenter.replace(/[0-9]/g, '').toUpperCase().split('');
                    if (lettersFromCostCenter.length) {
                        for (var k = 0; k < lettersFromCostCenter.length; k++) {
                            if (arrTokensToValidate.indexOf(lettersFromCostCenter[k]) < 0) {
                                arrIndexTokensError.push(i);
                            }
                        }
                    }
                }
            }
        }

        if (arrIndexTokensError.length) {
            UtilsAlerta(base.constantes.tpalerta.i, "Insira um token válido por favor (A,E,F,G,I,L,M,N,P,T).");
        } else {
            GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso)
        }
    };

    /* @description Function that returns specific url to crud */
    self.GetSpecificUrl = function (model, oldUrl) {
        //get new start url
        var _newUrl = oldUrl.slice(0, oldUrl.lastIndexOf("/"));
        var tipo = (model['ModuleCode'] === '008') ? 'Accounts' : 'DocumentTypes';
        var accao = (model.ID == 0) ? 'Create' : 'Update';
        _newUrl = _newUrl + '/' + accao + 'With' + tipo + 'Async';
        return _newUrl;
    };

    /* @description Function that set lines to main model */
    self.SetLinesToModel = function (model) {
        var _lines = [];

        //get module code
        var _moduleCode = $accountingconfigconditions.ajax.GetModuleCode() || $('#ModuleCodeOnUpdate').val();

        if (_moduleCode) {
            switch (_moduleCode) {
                case '008': // entites
                    if (typeof $accountingconfigentities !== 'undefined') {
                        _lines = $accountingconfigentities.ajax.GetHTDataSource();
                    }

                    model['Entities'] = _lines;
                    break;

                default:
                    if (typeof $accountingconfigdocstypes !== 'undefined') {
                        _lines = $accountingconfigdocstypes.ajax.GetHTDataSource();
                        _lines = $.merge(_lines, $accountingconfigdocstypes.ajax.DocumentTypesToRemove);
                    }

                    model['DocumentTypes'] = _lines;
            }

            for (var i = 0; i < _lines.length; i++) {
                //set id
                _lines[i]['Id'] = _lines[i]['Id'] ? _lines[i]['Id'] : 0;
                //set id configuration
                _lines[i]['AccountingConfigurationId'] = _lines[i]['AccountingConfigurationId'] ? _lines[i]['AccountingConfigurationId'] : $('#' + constID).val();
                //set value id
                _lines[i]['ValueId'] = _lines[i]['ValueId'] ? _lines[i]['ValueId'] : 0;
                //set entity state
                _lines[i]['EntityState'] = _lines[i]['EntityState'] ? _lines[i]['EntityState'] : 0;
                //set marker
                if ($.isArray(_lines[i].F3MMarker)) {
                    _lines[i].F3MMarker = btoa(String.fromCharCode.apply(null, new Uint8Array(_lines[i].F3MMarker)));
                }
            }
        }
    };

    /* @description Function that returns if is on copy mode */
    self.IsOnCopyMode = function () {
        return $('#' + constCopyMode).val() === 'True' || $('#' + constCopyMode).val() === 'true' || $('#' + constCopyMode).val() === true;
    };

    return parent;

}($accountingconfig || {}, jQuery));

//this
var AccountingConfigInit = $accountingconfig.ajax.Init;
//crud
var AcoesRetornaModeloEspecifico = $accountingconfig.ajax.GetSpecificModel;
var ValidaGravaEspecifico = $accountingconfig.ajax.ValidaGravaEspecifico;
var AcoesRetornaURLEspecifico = $accountingconfig.ajax.GetSpecificUrl;

//doc ready
$(document).ready(() => AccountingConfigInit());