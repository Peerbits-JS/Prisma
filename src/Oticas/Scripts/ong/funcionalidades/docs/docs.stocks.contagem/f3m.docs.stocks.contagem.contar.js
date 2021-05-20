'use strict';

var $docsstockscontagemcontar = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;
    // qtd ///artigo /// lote 
    var campoQtd = 'Quantidade', campoArtigo = 'IDArtigo', campoLote = 'IDLote', campoCodArtigo = 'CodigoArtigo';
    //buttons
    var btnConfirmarArtigo = 'btnConfirmarArtigo', btnSelecionarArtigos = 'btnSelecionarArtigos';
    //constantes handsontable
    var HDSNID = 'hdsnArtigosContar', constTipoCompoHT = constsBase.ComponentesHT, constSourceHT = constsBase.SourceHT, constColHT = constsBase.ColunasHT;
    //result req do artigo quando tem  mais que 1 lote
    self.ArtigoResRequest = null;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //bind ok button
        $('#' + btnConfirmarArtigo).click((e) => self.AdicionaArtigo(e));
        //bind select button
        $('#' + btnSelecionarArtigos).click((e) => self.SelecionarArtigos(e));
        //bind blur artigo
        $('#' + campoCodArtigo).blur((e) => self.ArtigoBlur(e));
        //bind blur lote
        $('#' + campoLote).blur((e) => self.LoteBlur(e));
        //on init focus on artigo
        $('#' + campoCodArtigo).focus();
    };

    //------------------------------------ A R T I G O S
    /* @description funcao blur do campo artigo */
    self.ArtigoBlur = function () {
        //get cod artigo
        var _codigoArtigo = $('#' + campoCodArtigo).val();

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_codigoArtigo)) {
            //set to hdsn or get lote
            self.ValidaArtigo(0, _codigoArtigo);
        }
    };

    //------------------------------------ L O T E S
    /* @description funcao change do lote */
    self.LoteChange = function (inCombo) {
        setTimeout(function () {
            //get data item
            var _comboDS = inCombo.dataItem();
            //verifica se existe algum selecionado
            if (UtilsVerificaObjetoNotNullUndefinedVazio(_comboDS) && UtilsVerificaObjetoNotNullUndefinedVazio(inCombo.value())) {
                //set props
                self.ArtigoResRequest['artigolotesres']['ID'] = _comboDS.ID;
                self.ArtigoResRequest['artigolotesres']['Codigo'] = _comboDS.Codigo;
                self.ArtigoResRequest['artigolotesres']['Descricao'] = _comboDS.Descricao;
                //add item
                self.SetArtigoValido(self.ArtigoResRequest);
            }
        }, 50);
    };

    /* @description funcao blur do campo lote */
    self.LoteBlur = function () {
        //get lote
        var _comboLote = KendoRetornaElemento($('#' + campoLote));
        //check if lote is empty
        if (UtilsVerificaObjetoNotNullUndefinedVazio(_comboLote.text())) {
            //get lote ds
            var _comboLoteDS = _comboLote.dataSource.data();
            //get lote from ds
            var _loteRead = $.grep(_comboLoteDS, (x) => x.Codigo === _comboLote.text())[0];

            if (!_loteRead) {
                //$.playSound("../../Content/f3m/erro2.wav");
                UtilsAlerta(base.constantes.tpalerta.i, 'Indique um lote válido para o artigo.', function () {
                    KendoRetornaElemento($('#' + campoLote)).value('');
                    KendoRetornaElemento($('#' + campoLote)).focus();
                }, function () { return false; });
            }
            else {
                self.KendoSetValue(campoLote, _loteRead['ID']);
                self.LoteChange(_comboLote);
            }
        }
    };

    /* @description funcao envia params do lote */
    self.LoteEnviaParams = function (inObjetoFiltro) {
        //get id artigo
        var _idArtigo = $('#' + campoArtigo).val();
        //set obj filtro
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'IDArtigo', '', _idArtigo);
        //return obj filtro
        return inObjetoFiltro;
    };

    //------------------------------------ B O T O E S     A C O E S
    /* @description funcao que  */ 
    self.AdicionaArtigo = function (e) {
        //get qtd
        var _qtd = KendoRetornaElemento($('#' + campoQtd)).value;

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(_qtd) || _qtd === 0) {
            return self.NotificaErroAdicionaArtigo();
        }

        //get id artigo
        var _idArtigo = $('#' + campoArtigo).val();

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(_idArtigo)) {
            return self.NotificaErroAdicionaArtigo();
        }

        if (KendoRetornaElemento($('#' + campoLote)).dataSource.data().length) {
            //get lote
            var idLote = KendoRetornaElemento($('#' + campoLote)).value();

            if (!UtilsVerificaObjetoNotNullUndefinedVazio(idLote)) {
                return self.NotificaErroAdicionaArtigo();
            }
        }
        //valida 
        self.ValidaArtigo(_idArtigo);
    };

    /* @description funcao que */
    self.SelecionarArtigos = function (e) {
        //get hdsn DS
        var _hdsnDS = $.grep(self.RetornaHTLinhas(), (x) => x.IDArtigo);
        //set to main ds
        window.parent.$docsstockscontagemgrelha.ajax.ConcatenaToData(_hdsnDS);
        //close modal window
        window.parent.$('#janelaMenu').data('kendoWindow').close();
    };

    //------------------------------------ H A N D S O N T A B L E
    //---------------- I N S T A N C E
    /* @description funcao que constroi a handsontable */
    self.ConstroiHT = function (inData) {
        //remove from dom
        $('#tempHdsnDS').remove();
        //get columns
        var _columns = self.RetornaColunasHT();
        //hdsn
        var _hdsn = HandsonTableDesenhaNovo(HDSNID,inData, 430, _columns, true);
        //update settings
        _hdsn.updateSettings({
            fillHandle: false,
            columnSorting: false
        }); 
        //redimensiona ht
        self.RedimensionaHT();
    };

    /* @description funcao que retorna a estancia de ski */
    self.RetornaHTInstance = function () {
        return HotRegisterer.bucket[HDSNID];
    };

    /* @description funcao que retorna as linhas da hdsn */
    self.RetornaHTLinhas = function () {
        return self.RetornaHTInstance().getSourceData();
    };

    /* @description funcao que redimensiona a handsontable */
    self.RedimensionaHT = function () {
        //get hdsn
        var _hdsn = self.RetornaHTInstance();
        //get height
        var _height = $('#iframeBody').height() - 130;
        //redimensiona hdsn
        _hdsn.updateSettings({
            height: _height
        });
    };

    //---------------- C O L U N A S
    /* @description funcao que retorna as colunas da handsontable */
    self.RetornaColunasHT = function () {
        var _columns = [
            {
                ID: "Codigo",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources["Artigo"],
                readOnly: true,
                width: 100
            }, {
                ID: 'Descricao',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Descricao'],
                readOnly: true,
                width: 200
            }, {
                ID: 'DescricaoLote',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: 'Lote',
                readOnly: true,
                width: 100
            }, {
                ID: 'DescricaoUnidade',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: 'Unidade',
                readOnly: true,
                width: 100
            },{
                ID: 'QuantidadeContada',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: 'Qtd. Contada',
                readOnly: true,
                width: 75
                }
            //, {
            //    ID: 'QuantidadeEmStock',
            //    TipoEditor: constTipoCompoHT.F3MNumeroInt,
            //    Label: 'Qtd. Stock',
            //    readOnly: true,
            //    width: 75
            //}, {
            //    ID: 'Diferenca',
            //    TipoEditor: constTipoCompoHT.F3MNumeroInt,
            //    Label: 'Diff',
            //    readOnly: true,
            //    width: 75
            //}
        ];

        return _columns;
    };

    //------------------------------------ V A L I D A C O E S
    /* @description funcao que verifca se o artigo respeita todas as condicoes */
    self.ValidaArtigo = function (inIDArtigo, Codigo) {
        window.parent.$docsstockscontagemgrelha.ajax.ReqValidaArtigo(inIDArtigo, function (res) {
            if (res.artigoValido) {
                //set artigo id
                $('#' + campoArtigo).val(res.artigores.ID);
                //
                self.ArtigoResRequest = res;
                //verifica o num de lotes do artigo
                switch (res.artigores.nLotes) {
                    case 0:
                    case 1:
                        //artigo valido
                        self.SetArtigoValido(res); //upate qtd contada or set artigo props
                        break;

                    default:
                        //$.playSound("../../Content/f3m/erro2.wav");
                        KendoRetornaElemento($('#' + campoLote)).dataSource.read().then(function () {
                            //activa
                            KendoDesativaElemento(campoLote, false);
                            //coloca obrigatorio
                            KendoColocaElementoObrigatorio($('#' + campoLote), true);
                            //focus
                            KendoRetornaElemento($('#' + campoLote)).focus();
                        });
                }
            }
            else {
                self.ArtigoResRequest = null;
                //$.playSound("../../Content/f3m/erro.wav");
                //notifica
                UtilsAlerta(base.constantes.tpalerta.i, resources['ArtigoNaoRespeitaCondicoes'], function () {
                    $('#' + campoCodArtigo).focus().select();
                }, function () { return false; }); //O artigo não respeita as condições definidas para esta contagem.
            }
            //reset id artigo
            $('#' + campoArtigo).val(null);
        }, Codigo);
    };

    /* @description funcao que adiciona o artigo à grelha */
    self.SetArtigoValido = function (inRes) {
        //get hdsn
        var _hdsn = self.RetornaHTInstance();
        //get hdsnDS
        var _hdsnDS = self.RetornaHTLinhas();
        //get qtd
        var _qtd = KendoRetornaElemento($('#' + campoQtd)).value();
        //get artigo
        var _dtItemArtigo = inRes.artigores;
        //get lote
        var _dtItemLote = inRes.artigolotesres;
        //get idlote
        var _idLote = _dtItemLote ? _dtItemLote.ID : null;
        //verifica se o artigo /// lote ja existe
        var _item = $.grep(_hdsnDS, (obj) => obj.IDArtigo === _dtItemArtigo.ID && obj.IDLote === _idLote)[0];
        //verifica se concatena para linha existente ou adiciona nova linha 
        var _concatenaToLinhaExistente = false; // [GN em 31 - 10 - 2018 decidiu adicionar linha]
        //check if item is on hdsn
        if (_item && _concatenaToLinhaExistente) {
            //set new qtd contada
            _item.QuantidadeContada += _qtd;
            //calc diff
            _item.Diferenca = _item.QuantidadeContada - _item.QuantidadeEmStock;
        }
        else {
            //instance new hdsn obj type
            var _obj = {
                //set artigo
                IDArtigo: _dtItemArtigo.ID,
                Codigo: _dtItemArtigo.Codigo,
                Descricao: _dtItemArtigo.Descricao,
                //set unidade
                IDUnidade: _dtItemArtigo.IDUnidade,
                CodigoUnidade: _dtItemArtigo.CodigoUnidade,
                DescricaoUnidade: _dtItemArtigo.DescricaoUnidade,
                //set gere lotes
                GereLotes: inRes.artigores.GereLotes,
                //set valor unitario
                ValorUnitario: inRes.artigores.Medio,
                //set lote
                IDLote: _dtItemLote ? _dtItemLote.ID : null,
                CodigoLote: _dtItemLote ? _dtItemLote.Codigo : '',
                DescricaoLote: _dtItemLote ? _dtItemLote.Descricao : '',
                //set calcs
                QuantidadeEmStock: inRes.quantidadeEmStock,
                QuantidadeContada: _qtd,
                Diferenca: _qtd - inRes.quantidadeEmStock
            };
            //set to last line
            _hdsnDS[_hdsnDS.length - 1] = _obj;
            //select row
            _hdsn.selectCell(_hdsnDS.length - 1, 0, _hdsnDS.length - 1, 4, true);
            //insert new line
            if (_hdsnDS[_hdsnDS.length - 1]['IDArtigo']) {
                _hdsn.alter('insert_row', _hdsnDS.length);
            }
            _hdsn.render();
        }
        //reset ds aux
        self.ArtigoResRequest = null;
        //reset qtd
        KendoRetornaElemento($('#' + campoQtd)).value(1);
        //reset lote
        self.KendoSetValue(campoLote, '');
        KendoDesativaElemento(campoLote, true);
        //reset artigo
        $('#' + campoCodArtigo).val(null).focus();
    };

    /* @description funcao que notifica quando o artigo nao e valido */
    self.NotificaErroAdicionaArtigo = function () {
        UtilsNotifica(base.constantes.tpalerta.warn, resources['PreencherTodosCampos']); //Tem que preencher todos os campos.
    };

    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /*@description Funcao que atribui o valor a um 'f' + parseInt(3 + 1) */
    self.KendoSetValue = function (inComboID, inValue) {
        var combo = KendoRetornaElemento($('#' + inComboID));
        combo.value(inValue);
        $($(combo.element).parent().find('.clsF3MInput:last')[0]).attr('value', inValue);
        ComboBoxAtivaDesativaDrillDown([$(combo.element).attr('id')]);
    };

    return parent;

}($docsstockscontagemcontar || {}, jQuery));
    
//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocsStocksContagemContarInit = $docsstockscontagemcontar.ajax.Init;
//artigos
var DocsStocksContagemContarEnviaParamsArtigo = $docsstockscontagemcontar.ajax.EnviaParamsArtigo;
var DocsStocksContagemContarChangeArtigo = $docsstockscontagemcontar.ajax.ChangeArtigo;
//lotes
var DocsStocksContagemContarLoteChange = $docsstockscontagemcontar.ajax.LoteChange;
var DocsStocksContagemContarLoteEnviaParams = $docsstockscontagemcontar.ajax.LoteEnviaParams;
//hdsn
var DocsStocksContagemContarConstroiHT = $docsstockscontagemcontar.ajax.ConstroiHT;

$(document).ready(function (e) {
    //init
    DocsStocksContagemContarInit();
}).ajaxSend(function (inEvent, jqxhr, inSettings) {
    //requests
    //  cab
    var _requestsBarLoding = ['Artigos/ListaComboCodigo', 'ArtigosLotes/ListaCombo'];
    //loading
    KendoBarLoading(null, inSettings, _requestsBarLoding);
    }).ajaxStop(function () {
        var elem = $('#iframeBody');
        KendoLoading(elem, false, true);
    });
//redimensiona ht
$(window).resize(function () {
    if (this.resizeTO) clearTimeout(this.resizeTO);
    this.resizeTO = setTimeout(function () {
        $docsstockscontagemcontar.ajax.RedimensionaHT();
    }, 100);
});