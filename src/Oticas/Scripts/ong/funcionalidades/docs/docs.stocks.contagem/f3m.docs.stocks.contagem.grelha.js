'use strict';

var $docsstockscontagemgrelha = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;

    //constantes form
    var constAcaoForm = 'EmExecucao', constsAcoes = constsBase.EstadoFormEAcessos;

    //data /// arm /// localizacao
    var campoData = 'DataDocumento', campoArmazem = 'IDArmazem', campoLocalizacao = 'IDLocalizacao';

    //constantes handsontable
    var HDSNID = 'hdsnArtigos', constTipoCompoHT = constsBase.ComponentesHT, constSourceHT = constsBase.SourceHT;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //bind change dos filtros 
        $('input:radio[name=optionsArtigos]').change((e) => self.ChangeOpArtigos(e));
        //bind search field
        $('#search_field').keyup((e) => self.DebouncerOpArtigos(e));
        //bind btn contar
        $('#btnContar').click((e) => self.AbreModalContar(e));
        //bind btn atualizar
        $('#btnAtualizar').click((e) => self.AtualizaQtdStock(e));
    };

    //------------------------------------ H A N D S O N T A B L E
    //---------------- I N S T A N C E
    /* @description funcao que constroi a handsontable */
    self.ConstroiHT = function (inData) {
        //remove from dom
        $('#tempHdsnDS').remove();
        //get columns
        var _columns = self.RetornaColunasHT();
        // objeto para passar parametros para a grelha HT
        var _objParamsHT = { pageable: true };
        //hdsn
        var _hdsn = HandsonTableDesenhaNovo(HDSNID, [], 0, _columns, true, null, null, null, null, null, null, null, null, null, null, null, _objParamsHT);
        //update settings
        _hdsn.updateSettings({
            fillHandle: true,
            columnSorting: {
                sortEmptyCells: false,
                initialConfig: {
                    column: 1,
                    sortOrder: 'asc'
                }
            },
            minSpareRows: 1,
            afterChange: self.AfterChangeHT,
            afterLoadData: function (initialLoad) {
                //configura colunas ht
                self.ConfiguraColunasHT(_hdsn);
                //erros ht 
                self.ErrosHT(_hdsn);
            }
        });

        //set data
        self.LoadDataHT(inData);
        //redimensiona HT
        self.RedimensionaHT();
    };

    /* @description funcao que popula a handsontable by data*/
    self.LoadDataHT = function (inData) {
        //get hdsn
        var _hdsn = self.RetornaHTInstance();
        //set GUID
        for (var _i = 0; _i < inData.length; _i++) {
            var _item = inData[_i];
            _item['F3MGUID'] = self.RetornaGUID();
        }
        //reset hdsn ds => performance by pc [old but gold]
        _hdsn.loadData([]);
        //set new data
        _hdsn.loadData(inData);
        //config columns
        self.ConfiguraColunasHT(_hdsn);
        //set totais
        self.TrataTotaisArtigos();
    };

    /* @description funcao que concatena o novo ds ao ds existente */
    self.ConcatenaToData = function (inData) {
        var _hdsn = self.RetornaHTInstance();

        for (var _i = 0; _i < inData.length; _i++) {
            //get ds item
            var _itemi = inData[_i];
            //get global ds item
            var _itemDS = $.grep(_hdsn.getSettings().F3MDataSource.data, (obj) => obj.IDArtigo === _itemi.IDArtigo && obj.IDLote === _itemi.IDLote)[0];
            //check if item is not on global ds
            if (_itemDS) {
                //set qtd contada
                _itemDS.QuantidadeContada += _itemi.QuantidadeContada;
                //set diff
                _itemDS.Diferenca = _itemDS.QuantidadeContada - _itemDS.QuantidadeEmStock;
            }
            else {
                //push to global ds
                _hdsn.getSettings().F3MDataSource.data.push(_itemi);
            }
        }
        //load ht with new ds
        self.LoadDataHT(_hdsn.getSettings().F3MDataSource.data);

        if (inData && inData.length) {
            //bloqueia tudo pqe tem pelo menos 1 artigo valido
            DocsStocksContagemBloqueiaOuDesbloqueiaTudo(true);
        }
        //set dirty
        GrelhaFormAtivaDesativaBotoesAcoes("F3MGrelhaFormDocumentosStockContagem", true);
    };

    /* @description funcao que retorna a estancia de ski */
    self.RetornaHTInstance = function () {
        return HotRegisterer.bucket[HDSNID];
    };

    /* @description funcao que retorna as linhas da handsontable */
    self.RetornaHTLinhas = function () {
        //get hdsn
        var _hdsn = self.RetornaHTInstance();
        //get hdsn DS
        var _hdsnDS = $.grep(_hdsn.getSettings().F3MDataSource.data, (obj) => UtilsVerificaObjetoNotNullUndefinedVazio(obj['Codigo']));
        //set data criacao
        for (var _i = 0; _i < _hdsnDS.length; _i++) {
            var _itemi = _hdsnDS[_i];
            _itemi['DataCriacao'] = new Date();
        }

        //return ds
        return _hdsnDS;
    };

    /* @description funcao que limpa os dados da linha */
    self.LimpaLinha = function (inHdsn, inRow) {
        //reset artigo
        inHdsn.getSourceDataAtRow(inRow)['IDArtigo'] = null;
        inHdsn.getSourceDataAtRow(inRow)['Descricao'] = null;
        //reset lote
        inHdsn.getSourceDataAtRow(inRow)['IDLote'] = null;
        inHdsn.getSourceDataAtRow(inRow)['DescricaoLote'] = null;
        //reset unidade
        inHdsn.getSourceDataAtRow(inRow)['IDUnidade'] = null;
        inHdsn.getSourceDataAtRow(inRow)['DescricaoUnidade'] = null;
        //reset calcs
        inHdsn.getSourceDataAtRow(inRow)['QuantidadeEmStock'] = null;
        inHdsn.getSourceDataAtRow(inRow)['QuantidadeContada'] = null;
        inHdsn.getSourceDataAtRow(inRow)['Diferenca'] = null;
        //update global ds
        self.AtualizaDS(inHdsn, inRow);
        //calcula totais
        self.TrataTotaisArtigos();
    };

    /* @description funcao que redimensiona a handsontable */
    self.RedimensionaHT = function () {
        //redimensiona loading bar
        var _grelha = '.grelha-loading', _container = '.clsF3MTabs ';
        $(_grelha).width($(_container).width());
        //get hdsn
        var _hdsn = self.RetornaHTInstance();
        var _height = $('#FormularioPrincipalOpcoes').height() - 250;
        //min height = 350
        _height = _height < 350 ? 350 : _height;
        //redimensiona hdsn
        _hdsn.updateSettings({
            height: _height
        });
    };

    //---------------- A F T E R     C H A N G E
    /* @description funcao after change gen da handsontable */
    self.AfterChangeHT = function (inChanges, inSource) {
        if (inSource === constSourceHT.LoadData || inSource === constSourceHT.PopulateFromArray) { return; }
        //set props
        var _hdsn = this;
        var _row = inChanges[0][0];
        var _prop = inChanges[0][1];
        var _oldValue = inChanges[0][2];
        var _newValue = inChanges[0][3];
        //after change cols
        if (_oldValue !== _newValue) {
            switch (_prop) {
                case 'Codigo':
                    self.AfterChangeHT_Codigo(_hdsn, _row);
                    break;

                case 'DescricaoLote':
                    self.AfterChangeHT_Lote(_hdsn, _row);
                    break;

                case 'QuantidadeContada':
                    self.AfterChangeHT_QuantidadeContada(_hdsn, _row);
                    break;
            }
            //ativa dirty
            switch (_prop) {
                case 'Codigo':
                case 'DescricaoLote':
                case 'QuantidadeContada':
                    GrelhaFormAtivaDesativaBotoesAcoes("F3MGrelhaFormDocumentosStockContagem", true);
                    break;
            }
        }
    };

    /* @description funcao after change da coluna codigo */
    self.AfterChangeHT_Codigo = function (inHdsn, inRow) {
        var _elemDS = HandsonTableVarGridHTF4DS()[0];

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_elemDS) && inHdsn.getDataAtRowProp(inRow, 'Codigo')) {
            self.ValidaArtigo(inHdsn, inRow, _elemDS);
        }
        else {
            self.SetArtigoInvalido(inHdsn, inRow);
        }
    };

    /* @description funcao after change da coluna descricaolote*/
    self.AfterChangeHT_Lote = function (inHdsn, inRow) {
        //get F4 ds
        var _elemDS = HandsonTableVarGridHTF4DS()[0];

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_elemDS) && inHdsn.getDataAtRowProp(inRow, 'DescricaoLote')) {
            //valida
            self.ValidaLote(inHdsn, inRow, _elemDS);
        }
        else {
            //reset
            inHdsn.getSourceDataAtRow(inRow)['IDLote'] = null;
            //posiciona na coluna do lote
            self.PosicionaColunaLote(inHdsn, inRow);
        }
        //render hdsn
        inHdsn.render();
        //update global ds
        self.AtualizaDS(inHdsn, inRow);
    };

    /* @description funcao after change da coluna quantidadecontada*/
    self.AfterChangeHT_QuantidadeContada = function (inHdsn, inRow) {
        if (inHdsn.getSourceDataAtRow(inRow)) {
            //get qtd stock
            var _qtdStock = inHdsn.getSourceDataAtRow(inRow)['QuantidadeEmStock'];
            //get qtd contada
            var _qtdContada = inHdsn.getSourceDataAtRow(inRow)['QuantidadeContada'];
            //check if empty
            if (!UtilsVerificaObjetoNotNullUndefinedVazio(_qtdContada)) {
                inHdsn.getSourceDataAtRow(inRow)['QuantidadeContada'] = 0;
                _qtdContada = 0;
            }
            //posciona na proxima coluna a preencher
            self.PosicionaProximaColunaArtigo(inHdsn, inRow + 1);
            //get diferenca
            var _diff = _qtdContada - _qtdStock;
            //set prop
            inHdsn.getSourceDataAtRow(inRow)['Diferenca'] = _diff;
            //render 
            inHdsn.render();
            //update global ds
            self.AtualizaDS(inHdsn, inRow);
            //calcula totais
            self.TrataTotaisArtigos();
        }
    };

    //---------------- C O L U N A S
    /* @description funcao que retorna as colunas da handsontable */
    self.RetornaColunasHT = function () {
        var _columns = [
            //{
            //    ID: "Btns",
            //    renderer: safeHtmlRenderer,
            //    readOnly: true,
            //    width: 50
            //},  
            {
                ID: "Codigo",
                TipoEditor: constTipoCompoHT.F3MLookup,
                Label: resources["Artigo"],
                Controlador: rootDir + "Artigos/Artigos/ListaComboCodigo",
                ControladorExtra: rootDir + "/Artigos/Artigos/IndexGrelha",
                CampoTexto: "Codigo",
                width: 100
            }, {
                ID: 'Descricao',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Descricao'],
                readOnly: true,
                width: 200
            }, {
                ID: 'DescricaoLote',
                TipoEditor: constTipoCompoHT.F3MLookup,
                Label: 'Lote',
                Controlador: rootDir + '/Artigos/ArtigosLotes',
                ControladorExtra: rootDir + '/Artigos/ArtigosLotes/IndexGrelha',
                FuncaoEnviaParams: self.EnviaParamsLote,
                readOnly: true,
                width: 100
            }, {
                ID: 'DescricaoUnidade',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: 'Unidade',
                readOnly: true,
                width: 100
            }, {
                ID: 'QuantidadeEmStock',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: 'Qtd. Stock',
                readOnly: true,
                width: 75
            }, {
                ID: 'QuantidadeContada',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: 'Qtd. Contada',
                readOnly: true,
                width: 75
            }, {
                ID: 'Diferenca',
                TipoEditor: constTipoCompoHT.F3MNumero,
                Label: 'Diferença',
                readOnly: true,
                width: 75
            }
            //,{
            //    ID: 'F3MGUID',
            //    Label: 'GUID',
            //    readOnly: true,
            //    width: 200
            //}
        ];

        return _columns;
    };

    /* @description funcao que configura as colunas da handsontable */
    self.ConfiguraColunasHT = function (inHdsn) {
        //all rows
        for (var _i = 0; _i < inHdsn.countRows(); _i++) {
            self.ConfiguraColunaHT(inHdsn, _i, false);
        }

        //render hdsn
        inHdsn.render();
    };

    /* @description funcao que configura uma determinada coluna da handsontable */
    self.ConfiguraColunaHT = function (inHdsn, inRow, boolRender) {
        //row
        var _item = inHdsn.getSourceDataAtRow(inRow);
        //get col is read only artigo
        var _readOnlyArtigo = $('#' + constAcaoForm).val() === constsAcoes.Alterar && $('#EstadoInicialAux').val() === 'EFT';
        //artigo
        var _cellMetaArtigo = inHdsn.getCellMeta(inRow, inHdsn.propToCol('Codigo'));
        _cellMetaArtigo ? _cellMetaArtigo['readOnly'] = _readOnlyArtigo : false;
        // get col is read only lote /// qtd contada
        var _readOnly = _readOnlyArtigo || !UtilsVerificaObjetoNotNullUndefinedVazio(_item['IDArtigo']);
        //lote
        var _cellMetaLote = inHdsn.getCellMeta(inRow, inHdsn.propToCol('DescricaoLote'));
        var _gereLotes = inHdsn.getDataAtRowProp(inRow, 'GereLotes');
        _cellMetaLote ? _cellMetaLote['readOnly'] = _readOnly || !_gereLotes : false;
        //qtd contada
        var _cellMetaQtdContada = inHdsn.getCellMeta(inRow, inHdsn.propToCol('QuantidadeContada'));
        _cellMetaQtdContada ? _cellMetaQtdContada['readOnly'] = _readOnly : false;

        if (boolRender) {
            //render
            inHdsn.render();
        }
    };

    //---------------- E N V I A     P A R A M S     C O L U N A S
    /* @description funcao que envia params da coluna lotes (idartigo) */
    self.EnviaParamsLote = function (inObjetoFiltro, inHdsn, inElem, inColuna) {
        //get hdsn
        var _hdsn = self.RetornaHTInstance();
        //get selected row
        var _selectedRow = _hdsn.getSelected()[0][0];
        //get id artigo
        var _idArtigo = _hdsn.getSourceDataAtRow(_selectedRow)['IDArtigo'];
        //set obj filtro
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'IDArtigo', '', _idArtigo);
        //return obj filtro
        return inObjetoFiltro;
    };

    //---------------- V A L I D A C O E S
    /* @description funcao que verifica se o artigo e valido (conforme condicoes)*/
    self.ReqValidaArtigo = function (inIDArtigo, fnSuccessCallback, Codigo) {
        //get url
        var _url = rootDir + 'Documentos/DocumentosStockContagem/ValidaArtigo';
        //get params
        var _params = { IDArtigo: inIDArtigo, Filtro: self.PreencheFiltro() };
        if (UtilsVerificaObjetoNotNullUndefinedVazio(Codigo)) {
            _params['Codigo'] = Codigo;
        }

        _params = JSON.stringify(_params);

        UtilsChamadaAjax(_url, true, _params,
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                    fnSuccessCallback(res);
                }
            }, function (e) { throw e; }, 1, true);
    };

    /* @description funcao que verifica se o artigo e valido (conforme condicoes)*/
    self.ValidaArtigo = function (inHdsn, inRow, inElemDS) {
        //get id artigo
        var _idArtigo = inElemDS['ID'];

        self.ReqValidaArtigo(_idArtigo, function (res) {
            if (res.artigoValido) {
                //artigo valido
                self.SetArtigoValido(inHdsn, inRow, inElemDS, res); //set artigo props
                self.ConfiguraColunaHT(inHdsn, inRow, true);
            }
            else {
                //artigo ivalido => O artigo não respeita as condições definidas para esta contagem.
                self.SetArtigoInvalido(inHdsn, inRow);
            }
            //update global ds
            self.AtualizaDS(inHdsn, inRow);
            //calcula totais
            self.TrataTotaisArtigos();
        });
    };

    /* @description funcao que atribui os dados do artigo à linha */
    self.SetArtigoValido = function (inHdsn, inRow, inElemDS, inRes) {
        var _nArtigos = 0;
        var _item = $.grep(inHdsn.getSettings().F3MDataSource.data, (obj) => obj.IDArtigo === inElemDS['ID'])[0];
        //
        if (inElemDS['NLotes'] !== 1) {
            _item = $.grep(inHdsn.getSettings().F3MDataSource.data, (obj) => obj.IDArtigo === inElemDS['ID'] && !UtilsVerificaObjetoNotNullUndefinedVazio(obj.IDLote))[0];
            _nArtigos = $.grep(inHdsn.getSettings().F3MDataSource.data, (obj) => obj.IDArtigo === inElemDS['ID']).length;
        }
        else {
            //_item 
        }
        //check if item is on hdsn
        if ((inElemDS['NLotes'] > 0 && (_item || _nArtigos === inElemDS['NLotes']) || inElemDS['NLotes'] === 0 && _item)) {
            //notifica O Artigo {artigo} / Lote {lote} já existe na contagem de stock.
            UtilsNotifica(base.constantes.tpalerta.warn, resources['ArtigoLoteExistente'].replace('{artigo}', inElemDS['Codigo']).replace('{lote}', inElemDS['CodigoLote']));
            //remove row
            inHdsn.alter('remove_row', inRow);
            //select on first cell by row
            inHdsn.selectCell(inRow, 0);
        }
        else {
            //artigo
            inHdsn.getSourceDataAtRow(inRow)['IDArtigo'] = inElemDS['ID'];
            inHdsn.getSourceDataAtRow(inRow)['Descricao'] = inElemDS['Descricao'];
            //lote
            if (inElemDS['NLotes'] === 1) {
                inHdsn.getSourceDataAtRow(inRow)['IDLote'] = inElemDS['IDLote'];
                inHdsn.getSourceDataAtRow(inRow)['CodigoLote'] = inElemDS['CodigoLote'];
                inHdsn.getSourceDataAtRow(inRow)['DescricaoLote'] = inElemDS['DescricaoLote'];
            }
            else {
                inHdsn.getSourceDataAtRow(inRow)['IDLote'] = null;
                inHdsn.getSourceDataAtRow(inRow)['CodigoLote'] = null;
                inHdsn.getSourceDataAtRow(inRow)['DescricaoLote'] = null;
            }
            //set flag gere lotes
            inHdsn.getSourceDataAtRow(inRow)['GereLotes'] = inElemDS['GereLotes'];
            //set valor unitario
            inHdsn.getSourceDataAtRow(inRow)['ValorUnitario'] = inElemDS['Medio'];
            //unidade
            inHdsn.getSourceDataAtRow(inRow)['IDUnidade'] = inElemDS['IDUnidade'];
            inHdsn.getSourceDataAtRow(inRow)['CodigoUnidade'] = inElemDS['CodigoUnidade'];
            inHdsn.getSourceDataAtRow(inRow)['DescricaoUnidade'] = inElemDS['DescricaoUnidade'];
            //quantidades
            inHdsn.getSourceDataAtRow(inRow)['QuantidadeEmStock'] = inRes['quantidadeEmStock'];
            inHdsn.getSourceDataAtRow(inRow)['QuantidadeContada'] = 0;
            inHdsn.getSourceDataAtRow(inRow)['Diferenca'] = inRes['quantidadeEmStock'];
            //set guid
            self.AtribuiLinhaGUID(inHdsn, inRow);
            //posiciona na proxima coluna a preencher
            switch (inElemDS['NLotes']) {
                case 0:
                case 1:
                    //posiciona coluna qtd contada
                    self.PosicionaColunaQtdContada(inHdsn, inRow);
                    break;

                default:
                    //posiciona coluna lote
                    self.PosicionaColunaLote(inHdsn, inRow);
            }
        }
        //bloqueia tudo pqe tem pelo menos 1 artigo valido
        DocsStocksContagemBloqueiaOuDesbloqueiaTudo(true);
    };

    /* @description funcao que limpa a linha */
    self.SetArtigoInvalido = function (inHdsn, inRow) {
        //notifica
        UtilsNotifica(base.constantes.tpalerta.warn, resources['ArtigoNaoRespeitaCondicoes']); //O artigo não respeita as condições definidas para esta contagem.
        //clear line
        self.LimpaLinha(inHdsn, inRow);
        //set guid
        self.AtribuiLinhaGUID(inHdsn, inRow);
        //set erros
        self.ErroHT(inHdsn, inRow);
        //config columns
        self.ConfiguraColunaHT(inHdsn, inRow, true);
        //verifica se tem algum artigo valido
        var _isArtigoValido = $.grep(inHdsn.getSettings().F3MDataSource.data, (x) => x.IDArtigo).length;
        //bloqueia tudo pqe tem pelo menos 1 artigo valido
        DocsStocksContagemBloqueiaOuDesbloqueiaTudo(_isArtigoValido);
        //posociona na coluna artigo em erro
        self.PosicionaProximaColunaArtigo(inHdsn, inRow);
    };

    /* @description funcao que verifica se o lote e valido (ja esta inserido)*/
    self.ValidaLote = function (inHdsn, inRow, inElemDS) {
        //get item
        var _item = $.grep(inHdsn.getSettings().F3MDataSource.data, (obj) => obj.IDArtigo === inElemDS['IDArtigo'] && obj.IDLote === inElemDS['ID'])[0];
        //verifica se o lote ja existe
        if (_item) {
            //reset
            inHdsn.getSourceDataAtRow(inRow)['DescricaoLote'] = null;
            inHdsn.getSourceDataAtRow(inRow)['IDLote'] = null;

            //notifica O Artigo {artigo} / Lote {lote} já existe na contagem de stock.
            UtilsNotifica(base.constantes.tpalerta.warn, resources['ArtigoLoteExistente'].replace('{artigo}', inElemDS['CodigoArtigo']).replace('{lote}', inElemDS['Codigo']));
            //posiciona na coluna lote
            self.PosicionaColunaLote(inHdsn, inRow);
        }
        else {
            //set
            inHdsn.getSourceDataAtRow(inRow)['IDLote'] = inElemDS['ID'];
            //posiciona na coluna qtd contada
            self.PosicionaColunaQtdContada(inHdsn, inRow);
        }
    };

    /* @description funcao que posciona na coluna da qtd contada */
    self.PosicionaProximaColunaArtigo = function (inHdsn, inRow) {
        var _colIndexArtigo = inHdsn.propToCol('Codigo');
        inHdsn.selectCell(inRow, _colIndexArtigo);
    };

    /* @description funcao que posciona na coluna do lote */
    self.PosicionaColunaLote = function (inHdsn, inRow) {
        var _colIndexLote = inHdsn.propToCol('DescricaoLote');
        inHdsn.selectCell(inRow, _colIndexLote);
    };

    /* @description funcao que posciona na coluna da qtd contada */
    self.PosicionaColunaQtdContada = function (inHdsn, inRow) {
        var _colIndexQtdContada = inHdsn.propToCol('QuantidadeContada');
        inHdsn.selectCell(inRow, _colIndexQtdContada);
    };

    //---------------- E R R O S
    /* @description funcao que verifica os erros da hansontable */
    self.ErrosHT = function (inHdsn) {
        for (var _j = 0; _j < inHdsn.countRows() - 1; _j++) {
            self.ErroHT(inHdsn, _j);
        }
    };

    /* @description funcao que verifica os erros de uma determinada linha da hansontable */
    self.ErroHT = function (inHdsn, inRow) {
        var _idArtigo = inHdsn.getSourceDataAtRow(inRow)['IDArtigo'];
        var _descricaoArtigo = inHdsn.getSourceDataAtRow(inRow)['Codigo'];
        var _colArtigo = inHdsn.propToCol('Codigo');

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(_idArtigo) && UtilsVerificaObjetoNotNullUndefinedVazio(_descricaoArtigo)) {
            inHdsn.getCellMeta(inRow, _colArtigo).valid = false;
        }
        else {
            inHdsn.getCellMeta(inRow, _colArtigo).valid = true;
        }

        var _idLote = inHdsn.getSourceDataAtRow(inRow)['IDLote'];
        var _descricaoLote = inHdsn.getSourceDataAtRow(inRow)['DescricaoLote'];
        var _colLote = inHdsn.propToCol('DescricaoLote');

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(_idLote) && UtilsVerificaObjetoNotNullUndefinedVazio(_descricaoLote)) {
            inHdsn.getCellMeta(inRow, _colLote).valid = false;
        }
        else {
            inHdsn.getCellMeta(inRow, _colLote).valid = true;
        }
    };

    //---------------- R E Q U E S T
    /* @description funcao que obtem os artigos que satisfazem ;) as condicoes e executa o callback de sucesso */
    self.ReqObtemArtigos = function (fnSuccessCallback) {
        //get url
        var _url = rootDir + 'Documentos/DocumentosStockContagem/ObtemArtigos';
        //get filtro
        var _filtro = self.PreencheFiltro();

        UtilsChamadaAjax(_url, true, JSON.stringify({ filtro: _filtro }),
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    //execute success calback
                    fnSuccessCallback(res);
                }
            }, function (e) { }, 1, true);
    };

    /* @description funcao que obtem os artigos que satisfazem ;) as condcoes*/
    self.ObtemArtigos = function () {
        self.ReqObtemArtigos((inRes) => self.LoadDataHT(inRes));
    };

    /* @description funcao que preenche o filtro para obter artigos*/
    self.PreencheFiltro = function () {
        //condicoes
        var _filtro = DocsStockContagemCondicoesRetornaModel();
        //cabecalho
        _filtro[campoArmazem] = KendoRetornaElemento($('#' + campoArmazem)).value();
        _filtro[campoLocalizacao] = KendoRetornaElemento($('#' + campoLocalizacao)).value();
        _filtro[campoData] = $('#' + campoData).val();
        //return
        return _filtro;
    };

    //------------------------------------ F I L T R O S
    /* @description funcao change no filtro de artigos */
    self.ChangeOpArtigos = function (inEvt) {
        //get selected option
        var _opcaoArtigo = $('input:radio[name=optionsArtigos]:checked').attr('id');
        //get hdsn
        var _hdsn = self.RetornaHTInstance();
        let temVistaAplicada = false;

        //get hdsn ds
        var _hdsnDSCopy = $.extend(true, [], _hdsn.getSettings().F3MDataSource.data);

        switch (_opcaoArtigo) {
            case 'opContados':
                _hdsnDSCopy = $.grep(_hdsnDSCopy, (item) => item.QuantidadeContada !== 0);
                temVistaAplicada = true;
                break;

            case 'opComDiferencas':
                _hdsnDSCopy = $.grep(_hdsnDSCopy, (item) => item.Diferenca !== 0);
                temVistaAplicada = true;
                break;
        }

        var _search = $('#search_field').val();
        var temFiltroAplicado = UtilsVerificaObjetoNotNullUndefinedVazio(_search);

        if (_hdsnDSCopy.length && UtilsVerificaObjetoNotNullUndefinedVazio(_search)) {
            _hdsnDSCopy = $.grep(_hdsnDSCopy, (item) => {
                //set search to lower case
                _search = _search.toLowerCase();

                var bool = (UtilsVerificaObjetoNotNullUndefinedVazio(item.Codigo) && item.Codigo.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.Descricao) && item.Descricao.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.DescricaoLote) && item.DescricaoLote.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.DescricaoUnidade) && item.DescricaoUnidade.toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.QuantidadeEmStock) && (item.QuantidadeEmStock).toString().toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.QuantidadeContada) && (item.QuantidadeContada).toString().toLowerCase().indexOf(_search) !== -1) ||
                    (UtilsVerificaObjetoNotNullUndefinedVazio(item.Diferenca) && (item.Diferenca).toString().toLowerCase().indexOf(_search) !== -1);

                return bool;
            });
        }
        //set new ds
        _hdsn.loadData(_hdsnDSCopy, temFiltroAplicado, temVistaAplicada);
        //errors
        self.ErrosHT(_hdsn);
        //config columns
        self.ConfiguraColunasHT(_hdsn);
    };

    //------------------------------------ C A L C U L O S     L A D O     D I R E I T O
    /* @description funcao que calcula os artigos que faltam /// contados /// diferencas */
    self.TrataTotaisArtigos = function () {
        var _hdsn = self.RetornaHTInstance();
        //get hdsn
        var _hdsnDS = _hdsn.getSettings().F3MDataSource.data;
        //calculo dos que faltam
        var _faltam = $.grep(_hdsnDS, (x) => x.QuantidadeContada === 0).length;
        $('.CLSF3MLadoDirFaltam').text(_faltam).val(_faltam);
        //calculo dos contados
        var _contados = $.grep(_hdsnDS, (x) => x.QuantidadeContada !== 0).length;
        $('.CLSF3MLadoDirContados').text(_contados).val(_contados);
        //calculo das diferencas
        var _diferenca = $.grep(_hdsnDS, (x) => x.Diferenca !== 0).length;
        $('.CLSF3MLadoDirDiferencas').text(_diferenca).val(_diferenca);
    };

    //------------------------------------ B O T O E S     A C O E S
    /* @description funcao que abre a modal para contar */
    self.AbreModalContar = function (e) {
        //get janela id
        var _janelaMenuLateral = constsBase.janelasPopupIDs.Menu;
        //get url
        var _url = rootDir + "/Documentos/DocumentosStockContagem/DocumentosStockContagemContar";
        //desenha janela
        JanelaDesenha(_janelaMenuLateral, {}, _url);
    };

    /* @description funcao que atualzia a qto stock /// diferenca */
    self.AtualizaQtdStock = function (e) {
        //get artigos
        self.ReqObtemArtigos(function (inRes) {

            var _hdsn = self.RetornaHTInstance();

            for (var _i = 0; _i < _hdsn.getSettings().F3MDataSource.data.length; _i++) {
                var _item = _hdsn.getSettings().F3MDataSource.data[_i];
                _item.QuantidadeEmStock = 0;
                _item.Diferenca = _item.QuantidadeContada - _item.QuantidadeEmStock;
            }

            for (var _i = 0; _i < _hdsn.getSettings().F3MDataSource.data.length; _i++) {
                var _item = _hdsn.getSettings().F3MDataSource.data[_i];
                //get item
                var _gridItem = $.grep(inRes, (x) => x.IDArtigo === _item.IDArtigo)[0];

                if (_gridItem) {
                    //set qtd em stock
                    _item.QuantidadeEmStock = _gridItem.QuantidadeEmStock;
                    //calc diferenca
                    _item.Diferenca = _item.QuantidadeContada - _item.QuantidadeEmStock;
                }
            }
            // --?
            for (var j = 0; j < inRes.length - 1; j++) {
                let artigoGrelha = $.grep(_hdsn.getSettings().F3MDataSource.data, (dataItem) => dataItem.IDArtigo == inRes[j].IDArtigo)[0];

                if (artigoGrelha) {
                }
                else {
                    _hdsn.getSettings().F3MDataSource.data.push(inRes[j]);
                }
            }

            //load data
            self.LoadDataHT(_hdsn.getSettings().F3MDataSource.data);
        });
    };
    //------------------------------------ F U N C O E S     A U X I L I A R E S
    /* @description funcao aux que retorna um guid */
    self.RetornaGUID = function () {
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        }
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    };

    /* @description funcao que atribui um GUID a uma linha da handsontable*/
    self.AtribuiLinhaGUID = function (inHdsn, inRow) {
        var _guid = inHdsn.getSourceDataAtRow(inRow)['F3MGUID'];

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(_guid)) {
            inHdsn.getSourceDataAtRow(inRow)['F3MGUID'] = self.RetornaGUID();
            inHdsn.getSourceDataAtRow(inRow)['ID'] = null;
            inHdsn.getSettings().F3MDataSource.data.push(inHdsn.getSourceDataAtRow(inRow));
        }
    };

    /* @description funcao que atualiza o ds global*/
    self.AtualizaDS = function (inHdsn, inRow) {
        //get guid
        var _guid = inHdsn.getSourceDataAtRow(inRow)['F3MGUID'];

        if (UtilsVerificaObjetoNotNullUndefined(_guid)) {
            //get hdsn DS
            var _hdsnDS = inHdsn.getSourceData(); // self.RetornaHTLinhas();
            //get global row ds
            var _rowGlobalDS = $.grep(inHdsn.getSettings().F3MDataSource.data, (item) => item.F3MGUID === _guid)[0];
            //get hdsn row ds
            var _rowHdsnDS = $.grep(_hdsnDS, (item) => item.F3MGUID === _guid)[0];
            //set props to global ds
            var props = ['IDArtigo', 'IDLote', 'IDUnidade', 'Codigo', 'Descricao', 'DescricaoLote', 'DescricaoUnidade', 'QuantidadeEmStock', 'QuantidadeContada', 'Diferenca'];
            for (var _i = 0; _i < props.length; _i++) {
                var _itemi = props[_i];

                _rowGlobalDS[_itemi] = _rowHdsnDS[_itemi];
            }
        }
    };

    /* @description Função que vai ao servidor de 350 em 350 ms */
    self.DebouncerOpArtigos = function (e) {
        var timer;

        return function (e) {
            clearTimeout(timer);

            timer = setTimeout(function () {
                self.ChangeOpArtigos(e);
                clearTimeout(timer);
            }, 350);
        };
    }();

    function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {

        $(td).css('text-align', 'center');

        Handsontable.cellTypes.text.renderer.apply(this, arguments);

        var grelhaHTID = instance.rootElement.id;

        var spanL = $('<span>').attr({
            id: grelhaHTID + 'span_row_' + row + 'col_' + col
        });

        var spanButton = $("<button type='button' class='btn btn-sm btn-danger'><span class='fm f3icon-close-2'></span></button>");


        Handsontable.dom.addEvent(spanL[0], 'mousedown', function (e) {
            console.log('mousedown');

            instance.deselectCell();

            instance.alter('remove_row', row);
        });

        Handsontable.dom.addEvent(spanL[0], 'touchstart', function (e) {
            console.log('touchstart');
            //self.EventoCliqueTextoComBotao(e, instance, row, col);
        });

        spanL.append(spanButton);
        Handsontable.dom.empty(td);
        td.appendChild(spanL[0]);

        return td;

    }

    return parent;

}($docsstockscontagemgrelha || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocsStocksContagemGrelhaInit = $docsstockscontagemgrelha.ajax.Init;

var DocsStocksContagemGrelhaObtemArtigos = $docsstockscontagemgrelha.ajax.ObtemArtigos;
//hdsn
var DocsStocksContagemGrelhaConstroiHT = $docsstockscontagemgrelha.ajax.ConstroiHT;
var DocsStocksContagemGrelhaLoadDataHT = $docsstockscontagemgrelha.ajax.LoadDataHT;
var DocsStocksContagemGrelhaConcatenaToData = $docsstockscontagemgrelha.ajax.ConcatenaToData;
var DocsStocksContagemGrelhaRetornaHTInstance = $docsstockscontagemgrelha.ajax.RetornaHTInstance;
var DocsStocksContagemGrelhaRetornaHTLinhas = $docsstockscontagemgrelha.ajax.RetornaHTLinhas;
var DocsStocksContagemGrelhaConfiguraColunasHT = $docsstockscontagemgrelha.ajax.ConfiguraColunasHT;

var DocsStocksContagemGrelhaReqValidaArtigo = $docsstockscontagemgrelha.ajax.ReqValidaArtigo;

$(document).ready(function (e) {
    //init
    DocsStocksContagemGrelhaInit();
});

$(window).resize(function () {
    if (this.resizeTO) clearTimeout(this.resizeTO);
    this.resizeTO = setTimeout(function () {
        $docsstockscontagemgrelha.ajax.RedimensionaHT();
    }, 100);
});