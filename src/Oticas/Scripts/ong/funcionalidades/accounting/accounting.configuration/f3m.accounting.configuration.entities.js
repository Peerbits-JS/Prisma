'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $accountingconfigentities= (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T S
    //base
    var constsBase = base.constantes; 

    //handsontable
    var HDSNID = 'hdsnEntities', constTipoCompoHT = constsBase.ComponentesHT, constSourceHT = constsBase.SourceHT;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description Document ready function */
    self.Init = function () {
        //bind search field
        $('#search_field').keyup((e) => self.DebounceSearchOnHT(e)); 
    };

    //------------------------------------ E N T I T I E S
    /* @description Request that get entities by type */
    self.ReqGetEntities = function (fnSuccessCallback) {
        //get url
        var _url = rootDir + 'Accounting/AccountingConfiguration/GetEntities';
        //get selected type
        var _type = $accountingconfigconditions.ajax.GetListViewDataItemSelectedByID('TypeDescription');

        if (_type) {
            //get params
            var _params = { model: _type };

            _params = JSON.stringify(_params);

            UtilsChamadaAjax(_url, true, _params,
                function (res) {
                    if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                        fnSuccessCallback(res);
                    }
                }, function (e) { throw e; }, 1, true);
        }
    };

    /* @description Get entities by type and load data */
    self.GetEntities = function () {
        self.ReqGetEntities((res) => self.SetHTDataSource(res));
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
        // objeto para passar parametros para a grelha HT
        var _objParamsHT = { pageable: true };
        //hdsn
        var _hdsn = HandsonTableDesenhaNovo(HDSNID, [], 250, _columns, true, null, null, null, null, null, null, null, null, null, null, null, _objParamsHT);
        //update settings
        _hdsn.updateSettings({
            fillHandle: false,
            columnSorting: false,
            afterChange: self.AfterChange,
            afterLoadData: function (initialLoad) {
                //configura colunas ht
                self.SetHTColumnsProps(_hdsn);
            }
        });
        //load hdsn
        self.SetHTDataSource(dataSource);
        //redimensiona HT
        self.RedimensionaHT();
    };

    /* @description Function that returns handsontable data source */
    self.GetHTDataSource = function () {
        //get hdsn
        var _hdsn = self.GetHT();
        //return datasource
        return $.grep(_hdsn.getSettings().F3MDataSource.data, (dataItem) => UtilsVerificaObjetoNotNullUndefined(dataItem['EntityCode']));
    };

    /* @description Function that set handsontable data source */
    self.SetHTDataSource = function (dataSource) {
        //get hdsn
        var _hdsn = self.GetHT();
        //set GUID
        for (var _i = 0; _i < dataSource.length; _i++) {
            var _item = dataSource[_i];
            _item['F3MGUID'] = self.GetGUID();
        }
        //reset hdsn ds => performance by pc [old but gold]
        _hdsn.loadData([]);
        //set new data
        _hdsn.loadData(dataSource);
        //config columns
        self.SetHTColumnsProps(_hdsn);
    };

    //---------------- C O L U M N S 
    /* @description Function that returns handsontable columns */
    self.GetHTColumns = function () {
        var _columns = [
            {
                ID: "EntityCode",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Codigo'],
                readOnly: true,
                width: 150
            },
            {
                ID: 'EntityDescription',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Descricao'],
                readOnly: true,
                width: 250
            }, {
                ID: 'AccountingVariable',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['VariavelContabiliade'],
                readOnly: true,
                width: 200
            },
            {
                ID: 'GoodsCostInPurchase',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                Label: resources['CustoMercadoriaCompras'],
                readOnly: true,
                width: 200
            }
        ];

        return _columns;
    };

    /* @description Function that set props on columns on all handsontable rows */
    self.SetHTColumnsProps = function (hdsn) {
        //all rows
        for (var _i = 0; _i < hdsn.countRows(); _i++) {
            self.SetHTColumnProps(hdsn, _i, false);
        }
        //render hdsn
        hdsn.render();
    };

    /* @description Function that set props on columns on one handsontable row */
    self.SetHTColumnProps = function (hdsn, row) {
        //col GoodsCostInPurchase
        var selected = $accountingconfigconditions.ajax.GetListViewDataItemSelectedByID('TypeDescription')['Code'];
        var _readOnlyGoodsCostInPurchase = selected !== 'TiposArtigo';
        var _cellMetaGoodsCostInPurchase = hdsn.getCellMeta(row, hdsn.propToCol('GoodsCostInPurchase'));
        _cellMetaGoodsCostInPurchase ? _cellMetaGoodsCostInPurchase['readOnly'] = _readOnlyGoodsCostInPurchase : false;
        //col AccountingVariable
        var _cellMetaAccountingVariable = hdsn.getCellMeta(row, hdsn.propToCol('AccountingVariable'));
        _cellMetaAccountingVariable ? _cellMetaAccountingVariable['readOnly'] = false : true;
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
                case 'AccountingVariable':
                case 'GoodsCostInPurchase':
                    //update TF3MDataSource
                    self.UpdateHTF3MDataSource (_hdsn, _row);
                    break;
            }
            //sets flag if has changes on container inputs to true
            $accountingconfigconditions.ajax.HasChangesOnContainerInputs = true;
            //set dirty
            var form = $('.' + base.constantes.tiposComponentes.grelhaForm).attr('id');
            GrelhaFormAtivaDesativaBotoesAcoes(form, true);
        }
    };

    //---------------- S E A R C H
    /* @description Function that search on handsontable */
    self.SearchOnHT = function () {
        //get hdsn
        var _hdsn = HotRegisterer.bucket[HDSNID];
        //get hdsn ds
        var _hdsnDSCopy = $.extend(true, [], _hdsn.getSettings().F3MDataSource.data);
        //get search value
        var _search = $('#search_field').val();

        if (_hdsnDSCopy.length && UtilsVerificaObjetoNotNullUndefinedVazio(_search)) {
            _hdsnDSCopy = $.grep(_hdsnDSCopy, (item) => {
                //set search to lower case
                _search = _search.toLowerCase();

                var bool = (UtilsVerificaObjetoNotNullUndefinedVazio(item.EntityCode) && item.EntityCode.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.EntityDescription) && item.EntityDescription.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.AccountingVariable) && item.AccountingVariable.toLowerCase().indexOf(_search) !== -1);

                return bool;
            });
        }

        //set new ds
        _hdsn.loadData(_hdsnDSCopy, true, true);
    };

    //------------------------------------ A U X     F U N C T I O N S
    /* @description Function that creates and return a GUID */
    self.GetGUID = function () {
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        }
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    };

    /* @description Function that updates F3MDataSource (global ds) on handsontable */
    self.UpdateHTF3MDataSource = function (hdsn, row) {
        //get guid
        var _guid = hdsn.getSourceDataAtRow(row)['F3MGUID'];

        if (UtilsVerificaObjetoNotNullUndefined(_guid)) {
            //get hdsn DS
            var _hdsnDS = hdsn.getSourceData(); // self.RetornaHTLinhas();
            //get global row ds
            var _rowGlobalDS = $.grep(hdsn.getSettings().F3MDataSource.data, (item) => item.F3MGUID === _guid)[0];
            //get hdsn row ds
            var _rowHdsnDS = $.grep(_hdsnDS, (item) => item.F3MGUID === _guid)[0];
            //set props to global ds
            var props = ['AccountingVariable', 'GoodsCostInPurchase'];
            for (var _i = 0; _i < props.length; _i++) {
                var _itemi = props[_i];

                _rowGlobalDS[_itemi] = _rowHdsnDS[_itemi];
            }
        }
    };

    /* @description Debounce to execute search on handsontable*/
    self.DebounceSearchOnHT = function (e) {
        var timer;

        return function (e) {
            //clear timeout
            clearTimeout(timer);

            timer = setTimeout(function () {
                //search on ht
                self.SearchOnHT(e);
                //clear timeout
                clearTimeout(timer);
            }, 350);
        };
    }();

    /* @description funcao que redimensiona a handsontable */
    self.RedimensionaHT = function () {
        //get hdsn
        var _hdsn = self.GetHT();
        var _height = $('#FormularioPrincipalOpcoes').height() - 105;
        //min height = 350
        _height = _height < 350 ? 350 : _height;
        //redimensiona hdsn
        _hdsn.updateSettings({
            height: _height
        });
    };

    return parent;

}($accountingconfigentities || {}, jQuery));

//doc ready
$(document).ready(() => $accountingconfigentities.ajax.Init());

$(window).resize(function () {
    if (this.resizeTO) clearTimeout(this.resizeTO);
    this.resizeTO = setTimeout(function () {
        $accountingconfigentities.ajax.RedimensionaHT();
    }, 100);
});