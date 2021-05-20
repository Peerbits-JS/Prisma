"use strict";

var $inventarioat = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    var constsBase = base.constantes;
    var constTipoCompoHT = constsBase.ComponentesHT;

    var HDSNID = 'hdsnArtigos';
    var container = 'condicoes';
    var btnAnexos = 'btnAnexos';
    var badges = {
        FilterDate: 'CLSF3MLadoEsqFilterDate',
        WareHouses: 'CLSF3MLadoEsqWareHouses'
    };

    self.MainDS = [];

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //bind anexos 
        $('#' + btnAnexos).click((e) => self.AbreAnexos(e));
        //bind aplicar filtros
        $('#btnAplicarFiltros').off().on('click', function (e) {
            e.preventDefault();
            //bloqueia /// 
            self.ObtemArtigos();
            this.blur();
            e.stopImmediatePropagation();
            return false;
        });

        //bind search field
        $('#search_field').keyup((e) => self.DebouncerFiltroHdsn(e));

        //after shown tabs
        $(".clsF3MTabs a[role=tab]").on("shown.bs.tab", (e) => self.ShownTabs(e));
        //trata observacoes - badge
        UtilsObservacoesTrataEspecifico("tabObservacoes", 'Observations');
    };

    //------------------------------------ T A B S
    /* @description funcao after shown tabs */
    self.ShownTabs = function (e) {
        var _tab = e.currentTarget.hash.replace("#", "");

        switch (_tab) {
            case 'tabArtigos':
                //get hdsn
                var _hdsn = HotRegisterer.bucket[HDSNID];

                if (_hdsn) {
                    _hdsn.render();
                }
                break;
        }
    };

    //------------------------------------ C O N D I C O E S
    /* @description funcao change da data */
    self.ChangeFilterDate = function (event) {
        //update badge
        $('.' + badges.FilterDate).text(event.sender._oldText);
        //clear hdsn
        self.LoadDataHT([]);
    };

    /* @description funcao change dos armazens */
    self.ChangeWareHouse = function (inMultiSelect) {
        //update badge
        $('.' + badges.WareHouses).text(inMultiSelect.value().length);
        //clear hdsn
        self.LoadDataHT([]);
    };

    //------------------------------------ B A R R A     B O T O E S     L A D O     D I R E I T O
    /* @description funcao que abre os anexos */
    self.AbreAnexos = function (e) {
        var _janelaMenuLateral = constsBase.janelasPopupIDs.Menu;
        var _url = rootDir + "/Utilitarios/InventarioATAnexos";
        JanelaDesenha(_janelaMenuLateral, { 'IDEntidade': $("#ID").val(), 'Modo': '0' }, _url);
    };

    //------------------------------------ H A N D S O N T A B L E
    /* @description funcao que constroi a handsontable */
    self.ConstroiHT = function (inData) {
        //remove from dom
        $('#tempHdsnDS').remove();
        //get columns
        var _columns = self.RetornaColunasHT();
        //hdsn
        var _hdsn = HandsonTableDesenhaNovo(HDSNID, [], 0, _columns, true, null, null, null, null, null, null, null, null, null, null, null);
        //update settings
        _hdsn.updateSettings({
            fillHandle: false,
            columnSorting: false,
            afterChange: self.AfterChangeHT
        });

        //set data
        self.LoadDataHT(inData);
        //redimensiona HT
        self.RedimensionaHT();
    };

    /* @description funcao que popula a handsontable by data*/
    self.LoadDataHT = function (inData) { 
        //get hdsn
        var _hdsn = HotRegisterer.bucket[HDSNID];
        //set GUID
        for (var _i = 0; _i < inData.length; _i++) {
            var _item = inData[_i];
            _item['F3MGUID'] = self.RetornaGUID();
        }
        //reset hdsn ds => performance by pc [old but gold]
        _hdsn.loadData([]);
        //set new data
        _hdsn.loadData(inData);
        //atualiza ds global
        self.MainDS = inData;
    };

    /* @description funcao que retorna as colunas da handsontable */
    self.RetornaColunasHT = function () {
        var _columns = [
            {
                ID: "Category",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources["Categoria"],
                readOnly: true,
                width: 50
            }, {
                ID: "ProductCode",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources["Codigo"],
                readOnly: true,
                width: 100
            }, {
                ID: "ProductDescription",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources["Descricao"],
                readOnly: true,
                width: 150
            }, {
                ID: "BarCode",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: 'Código de barras',
                readOnly: true,
                width: 100
            }, {
                ID: 'StockQuantity',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: 'Qtd. Stock',
                readOnly: true,
                width: 50
            }, {
                ID: 'UnitCode',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: 'Unidade',
                readOnly: true,
                width: 50
            }, {
                ID: 'StockValue',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: 'Val. Stock',
                readOnly: true,
                width: 50
            }
        ];

        return _columns;
    };

    /* @description funcao que redimensiona a handsontable */
    self.RedimensionaHT = function () {
        //redimensiona loading bar
        var _grelha = '.grelha-loading', _container = '.clsF3MTabs ';
        $(_grelha).width($(_container).width());
        //get hdsn
        var _hdsn = HotRegisterer.bucket[HDSNID];
        var _height = $('#FormularioPrincipalOpcoes').height() - 120;
        //min height = 350
        _height = _height < 350 ? 350 : _height;
        //redimensiona hdsn
        _hdsn.updateSettings({
            height: _height
        });
    };

    /* @description funcao que pequisa nos registos da handsontable */
    self.PesquisaHT = function () {
        //get hdsn
        var _hdsn = HotRegisterer.bucket[HDSNID];
        //get hdsn ds
        var _hdsnDSCopy = $.extend(true, [], self.MainDS);
        //get search value
        var _search = $('#search_field').val();

        if (_hdsnDSCopy.length && UtilsVerificaObjetoNotNullUndefinedVazio(_search)) {
            _hdsnDSCopy = $.grep(_hdsnDSCopy, (item) => {
                //set search to lower case
                _search = _search.toLowerCase();

                var bool = (UtilsVerificaObjetoNotNullUndefinedVazio(item.Category) && item.Category.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.ProductCode) && item.ProductCode.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.ProductDescription) && item.ProductDescription.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.BarCode) && item.BarCode.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.StockQuantity) && (item.StockQuantity).toString().toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.UnitCode) && (item.UnitCode).toString().toLowerCase().indexOf(_search) !== -1)

                return bool;
            });
        }

        //set new ds
        _hdsn.loadData(_hdsnDSCopy);
    };

    //------------------------------------ R E Q U E S T S
    /* @description funcao que obtem os artigos que satisfazem ;) as condicoes*/
    self.ObtemArtigos = function () {
        self.ReqObtemArtigos((inRes) => self.LoadDataHT(inRes));
    };

    /* @description funcao que obtem os artigos que satisfazem ;) as condicoes e executa o callback de sucesso */
    self.ReqObtemArtigos = function (fnSuccessCallback) {
        //get url
        var _url = rootDir + 'InventarioAT/PesquisaArtigosAsync';
        //get filtro
        var _filtro = self.PreencheFiltro();
        //set warehouses prop
        _filtro['Warehouses'] = KendoRetornaElemento($('#Warehouses')).dataItems().map(function (obj) {
            return { Id: obj.ID, Code: obj.Codigo, Description: obj.Descricao };
        });
        //request
        UtilsChamadaAjax(_url, true, JSON.stringify({ filtro: _filtro }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    //execute success calback
                    fnSuccessCallback(res);
                }
            }, function (e) { }, 1, true);
    };

    //------------------------------------ C R U D
    /* @description funcao que  retorna o modelo esp para gravar*/
    self.RetornaModeloEspecifico = function (inModel) {
        //get armazens
        var warehouses = KendoRetornaElemento($('#Warehouses')).dataItems().map(function (obj) { return { Id: obj.ID, Code: obj.Codigo, Description: obj.Descricao }; });
        //set filter prop
        inModel['Filter'] = { FilterDate: inModel.FilterDate, Warehouses: warehouses };
        //set products prop
        inModel['Products'] = $.grep(self.MainDS, (data) => data.hasOwnProperty('Id') && UtilsVerificaObjetoNotNullUndefined(data['Id']));
        //delete from main model
        delete inModel.FilterDate;
        delete inModel.Warehouses;
        //return model
        return inModel;
    };

    /* @description funcao especifica que valida antes de gravar */
    self.ValidaGravaEspecifico = function (evt, inArrTabelas, inGrelha, inFormulario, inURL, inModelo, inElemBtID) {
        //verifica se existem linhas
        if (inModelo['Products'].length === 0 && inGrelha.dataSource.transport.options.destroy.url !== inURL) {
         //pergunta
            UtilsConfirma(base.constantes.tpalerta.question, "O inventário não tem linhas. Deseja continuar?", function () {
                //grava gen
                GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso);
            }, function () { return false; });
        }
        else {
            //grava gen
            GrelhaUtilsValidaEGrava(inGrelha, inFormulario, inURL, inModelo, inElemBtID, GrelhaFormValidaEGravaSucesso);
        }
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /* @description funcao aux que retorna um guid */
    self.RetornaGUID = function () {
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        }
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    };

    /* @description funcao que retorna o filtro para o request PesquisaArtigosAsync */
    self.PreencheFiltro = function () {
        return GrelhaUtilsGetModeloForm(GrelhaFormDTO($('#' + container)));
    };

    /* @description funcao que excuta a fn de pesquisa com um db de 350 ms */
    self.DebouncerFiltroHdsn = function (e) {
        var timer;

        return function (e) {
            clearTimeout(timer);

            timer = setTimeout(function () {
                self.PesquisaHT(e);
                clearTimeout(timer);
            }, 350);
        };
    }();

    return parent;

}($inventarioat || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var InventarioATInit = $inventarioat.ajax.Init;
//condicoes
var InventarioATChangeFilterDate = $inventarioat.ajax.ChangeFilterDate;
var InventarioATChangeWareHouse = $inventarioat.ajax.ChangeWareHouse;
//hdsn
var InventarioATGrelhaConstroiHT = $inventarioat.ajax.ConstroiHT;
//actions
var AcoesRetornaModeloEspecifico = $inventarioat.ajax.RetornaModeloEspecifico;
var ValidaGravaEspecifico = $inventarioat.ajax.ValidaGravaEspecifico;

//doc ready - init
$(document).ready(function (e) {
    //remove label adicionar registo
    $('#spanSemRegistosForm').remove();
    //init
    InventarioATInit();
}).ajaxSend(function (inEvent, jqxhr, inSettings) {
    //requests
    //  lado esq
    var _requestsBarLoding = ['Armazens/ListaCombo'];
    //  gets
    _requestsBarLoding.push('InventarioAT/PesquisaArtigosAsync');

    KendoBarLoading(null, inSettings, _requestsBarLoding);
}).ajaxStop(function () {
    var elem = $('#iframeBody');
    KendoLoading(elem, false, true);
    });

//resize
$(window).resize(function () {
    if (this.resizeTO) clearTimeout(this.resizeTO);
    this.resizeTO = setTimeout(function () {
        $inventarioat.ajax.RedimensionaHT();
    }, 100);
});