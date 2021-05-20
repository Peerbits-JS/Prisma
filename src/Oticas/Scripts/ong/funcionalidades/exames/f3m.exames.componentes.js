'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $examescomponentes = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    var constValorPorDefeito = 0, constValorMinDef = -999, constValorMaxDef = 999, constStepDef = 1, constDecPlacesDef = 0;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {

        $('.btnDown').off().on('click', function (evt) {
            self.Decrementa(this, evt)
        });

        $('.btnUp').off().on('click', function (evt) {
            self.Incrementa(this, evt);
        });

        $('.clsF3MGroupNum').off().on('keydown', function (evt) {
            self.ValidaCarateres(this, evt);
        });

        $('.clsF3MGroupNum').off().on('change', function (evt) {
            self.OnChange(this, evt);
        });
    };

    //------------------------------------ N U M B E R     G R O U P
    /* @description */
    self.Decrementa = function (inElement, inEvt) {
        //get current input element
        var _currentelem = $('#' + inElement.attributes['f3m-numeric'].nodeValue);
        //set new value
        _currentelem.val(function (i, oldval) {
            //get steps
            var _step = UtilsVerificaObjetoNotNullUndefinedVazio(this.step) ? parseFloat(this.step.replace(',', '.')) : parseFloat(constStepDef);
            //get new value
            oldval = UtilsVerificaObjetoNotNullUndefinedVazio(oldval) ? parseFloat(oldval) : parseFloat(this.getAttribute('f3m-defaultvalue'));
            var _newValue = parseFloat(oldval - _step);
            //get min element value
            var _minValue = UtilsVerificaObjetoNotNullUndefinedVazio(this.min) ? parseFloat(this.min) : parseFloat(constValorMinDef);
            //check if new value is lower than min value
            _newValue = (_newValue < _minValue) ? _minValue : _newValue;
            //get decimal places
            var _decimalPlaces = UtilsVerificaObjetoNotNullUndefinedVazio(this.getAttribute('f3m-decimalplaces')) ? parseFloat(this.getAttribute('f3m-decimalplaces')) : constDecPlacesDef;
            //_decimalPlaces = UtilsVerificaObjetoNotNullUndefinedVazio()
            return _newValue.toFixed(_decimalPlaces);
        });
        //set dirty
        _currentelem.change();
    };

    /* @description */
    self.Incrementa = function (inElement, inEvt) {
        //get current input element
        var _currentelem = $('#' + inElement.attributes['f3m-numeric'].nodeValue);
        //set new value
        _currentelem.val(function (i, oldval) {
            //get steps
            var _step = UtilsVerificaObjetoNotNullUndefinedVazio(this.step) ? parseFloat(this.step.replace(',', '.')) : parseFloat(constStepDef);
            //get new value
            oldval = UtilsVerificaObjetoNotNullUndefinedVazio(oldval) ? parseFloat(oldval) : parseFloat(this.getAttribute('f3m-defaultvalue'));
            var _newValue = parseFloat(oldval + _step);
            //get max element value
            var _maxValue = UtilsVerificaObjetoNotNullUndefinedVazio(this.max) ? parseFloat(this.max) : parseFloat(constValorMaxDef);
            //check if new value is bigger than min value
            _newValue = (_newValue > _maxValue) ? _maxValue : _newValue;
            //get decimal places
            var _decimalPlaces = UtilsVerificaObjetoNotNullUndefinedVazio(this.getAttribute('f3m-decimalplaces')) ? parseFloat(this.getAttribute('f3m-decimalplaces')) : constDecPlacesDef;
            //_decimalPlaces = UtilsVerificaObjetoNotNullUndefinedVazio()
            return _newValue.toFixed(_decimalPlaces);
        });
        //set dirty
        _currentelem.change();
    };

    /* @description */
    self.ValidaCarateres = function (inElement, inEvt) {
        //list of invalid carateres
        var _invalidCarateres = ['e'];
        //get key down
        var _key = inEvt.key;
        //check if key is on list of invalid carateres
        if (_invalidCarateres.includes(_key)) {
            inEvt.preventDefault();
        }
    };

    /* @description */
    self.OnChange = function (inElement, inEtv) {
        //get value from input
        var _Value = inElement.value;
        //check if new value is lower than min value
        var _newValue = UtilsVerificaObjetoNotNullUndefinedVazio(_Value) ? parseFloat(_Value) : parseFloat(constValorPorDefeito);
        //check if value is diferent from 0 (valid min and max value)
        if (_newValue !== 0) {
            //check valor min
            //  get min element value
            var _minValue = parseFloat(inElement.min);
            //  check if new value is bigger than min value
            _newValue = (_newValue < _minValue) ? _minValue : _newValue;

            //check valor max
            //  get max element value
            var _maxValue = parseFloat(inElement.max);
            //  check if new value is bigger than min value
            _newValue = (_newValue > _maxValue) ? _maxValue : _newValue;
        }

        //  get decimal places
        var _decimalPlaces = UtilsVerificaObjetoNotNullUndefinedVazio(inElement.getAttribute('f3m-decimalplaces')) ? parseFloat(inElement.getAttribute('f3m-decimalplaces')) : constDecPlacesDef;
        //  _decimalPlaces = UtilsVerificaObjetoNotNullUndefinedVazio()
        inElement.value = _newValue.toFixed(_decimalPlaces);
    };

    //------------------------------------ E D I T O R     W Y S I N G
    /* @description */
    self.ChangeWYSING = function (inEvt) {
        inEvt.sender.element.trigger('change');
    };

    return parent;

}($examescomponentes || {}, jQuery));

//document ready
var ExamesComponentesInit = $examescomponentes.ajax.Init;
//editor wysing
var ExamesChangeWYSING = $examescomponentes.ajax.ChangeWYSING;

//doc ready
$(document).ready(function (e) {
    ExamesComponentesInit();
});