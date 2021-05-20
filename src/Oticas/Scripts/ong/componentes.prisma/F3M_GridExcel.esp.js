'use strict';

var $gridexcelesp = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var formulario = '#FormularioPrincipalOpcoes';
    var cabecalho = '#containerCabecalho';
    var hdsnContainer = '.handson-container';

    self.Init = function () {
        //$(hdsnContainer).css('border', '0.1px solid #ccc');
        ////after shown tabs
        //$(".clsF3MTabs a[role=tab]").on("shown.bs.tab", function (e) {
        //    var _tab = $(e.currentTarget).attr('href');

        //    self.RedimensionaHTS(_tab);
        //});
    };

    self.RedimensionaHTS = function (inTab) {
        
        //var htsByTab = self.RetornaHTSByTab(inTab);

        //if (htsByTab.length) {

        //    for (var i = 0; i < htsByTab.length; i++) {

        //        var ht = htsByTab[i];

        //        self.RedimensionaHT(ht);

        //    }
        //}

    };

    self.RetornaHTSByTab = function (inTab) {
        //var htsByTab = [];
        ////get func hts
        //var _hdsnFunc = HotRegisterer.bucket;
        ////get visible hts
        //for (var _hdsn in _hdsnFunc) {

        //    var Is = $(inTab + ' ' + '#' + _hdsn);

        //    if (Is.length) {

        //        var _hdsnT = HotRegisterer.bucket[_hdsn];

        //        if (_hdsnT) {
        //            htsByTab.push(_hdsnT);
        //        }
        //    }
        //}
        //return htsByTab;
    };

    self.WindowResize = function () {

        //var getTabAtiva;

        //if ($('.tab-pane.active').find(hdsnContainer).length) {
        //    getTabAtiva = '.tab-pane.active'; // $('.tab-pane.active').find(hdsnContainer)[0].firstElementChild.id;
        //    self.RedimensionaHTS(getTabAtiva);
        //} else {
        //    var _hdsn = $(hdsnContainer).length ? HotRegisterer.bucket[$(hdsnContainer)[0].firstElementChild.id] : '';
        //    self.RedimensionaHT(_hdsn);
        //}

    };

    //------------------------------------ R E D I M E N S I O N A
    /* @description funcao que redimensiona a handsontable */
    self.RedimensionaHT = function (inHdsn) {
        //if (inHdsn) {
        //    //get id
        //    var _id = inHdsn.rootElement.id;

        //    if (self.VerificaSeHdsnEstaRegistada(_id)) {

        //        var _isPageable = UtilsVerificaObjetoNotNullUndefined(inHdsn.getSettings().F3MDataSource) ? inHdsn.getSettings().F3MDataSource.isPageable : false;
        //        //PARA SABER SE PERMITE ADICIONAR LINHAS
        //        //HotRegisterer.bucket.hdsnArtigos.getSettings().minSpareRows

        //        //redimensiona loading bar
        //        self.RedimensionaLoadingBar();

        //        var _height = 0;
        //        // ALTURA = ROWS
        //        var _innerHT = inHdsn.countRows() * 32 + 28;
        //        // GRELHA COM PAGINACAO
        //        if (_isPageable) {
        //            $(hdsnContainer).css({ 'border': '0.1px solid rgb(204, 204, 204)', 'padding': '0' });
        //            _isPageable ? _height += ($('.tab-pane.active').length ? 36 : 16) : 0;
        //            self.SetHeight(inHdsn, _height, _isPageable);
        //        } else {
        //            if ($('#' + _id).height() > _innerHT) {
        //                _height = _innerHT;
        //                self.UpdateHTHeight(inHdsn, _height);
        //                $(hdsnContainer).css('border-bottom', '0.1px solid rgb(204, 204, 204)');
        //            } else {
        //                self.SetHeight(inHdsn, _innerHT);
        //            }
        //        }
        //    }
        //}
    };

    self.RedimensionaLoadingBar = function () {
        //var _grelha = '.grelha-loading', _container = '.clsF3MTabs', _containerFluid = '.container-fluid-window';
        //if ($(_container).length) {
        //    $(_grelha).width($(_container).width());
        //} else if ($(_containerFluid).length) {
        //    $(_grelha).width($(_containerFluid).width());
        //}

    };

    self.SetHeight = function (inHdsn, inHeight, inPageable) {
        //var h = inPageable ? inHeight : 0;
        //var _siblings = $('#' + inHdsn.rootElement.id).parent().parent().children().not($(hdsnContainer));
        //for (var i = 0; i < _siblings.length; i++) {
        //    h += $(_siblings[i]).outerHeight();
        //}
        //var _formulario = $(formulario).outerHeight();
        //var _cabecalho = !_siblings.parent().find('#containerCabecalho').length ? ($(cabecalho).length ? $(cabecalho).outerHeight() + 38 : 50) : 25;
        //var _navbar = $('.nav.nav-pills').length ? $('.nav.nav-pills').outerHeight() : 0;
        //var newHeight = _formulario - _cabecalho - _navbar - h;

        //inHeight = inHeight >= 60 && inHeight < newHeight ? inHeight : newHeight;
        //if (inHeight === newHeight && !inPageable) {
        //    $(hdsnContainer).css({ 'border': '0', 'border-bottom': '.1px solid rgb(204, 204, 204)' });
        //}
        //self.UpdateHTHeight(inHdsn, inHeight);
    };

    self.UpdateHTHeight = function (inHdsn, inHeight) {
        //if (inHeight < 60) inHeight = 60;
        //inHeight = Math.ceil($(hdsnContainer).width()) < $(hdsnContainer + ' .wtHider').width() ? inHeight + 7 : inHeight;
        ////redimensiona hdsn
        //if (UtilsVerificaObjetoNotNullUndefinedVazio(inHdsn)) {
        //    inHdsn.updateSettings({
        //        height: inHeight
        //    });
        //}



    };


    self.VerificaSeHdsnEstaRegistada = inHdsnID => HotRegisterer.bucket.hasOwnProperty(inHdsnID);
    

    return parent;

}($gridexcelesp || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
var GridExcelEspRedimensionaHTInit = $gridexcelesp.ajax.Init;
var GridExcelEspRedimensionaHT = $gridexcelesp.ajax.RedimensionaHT;

$(document).ready(function (e) {
    GridExcelEspRedimensionaHTInit();
});

//resize
$(window).resize(function () {
    setTimeout(function () {
        $gridexcelesp.ajax.WindowResize();
    }, 100);
});