'use strict';

var $etiquetasartigos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    const constTipoCompoHT = base.constantes.ComponentesHT;
    const constSourceHT = base.constantes.SourceHT;

    const IDHDSN = 'hdsnArtigos';
    const hdsnColumns = { LinhaSelecionada: 'Selecionar', IDArtigo: 'IDArtigo', CodigoArtigo: 'CodigoArtigo', DescriaoArtigo: 'DescricaoArtigo', Quantidade: 'Quantidade', ValorComIVA: 'ValorComIva' };

    /*@description Funcao que retorna as colunas da HT */
    self.RetornaColunasHT = function () {
        var result = [
            {
                ID: hdsnColumns.LinhaSelecionada,
                Label: '<input id="checkBoxColumn" class="htCheckboxRendererInput" checked="checked" autocomplete="off" type="checkbox" onClick="EtiquetasHandsonTableClickHeader(this)">  ',
                TipoEditor: constTipoCompoHT.F3MCheckBox,
                width: 10
            },
            {
                ID: hdsnColumns.CodigoArtigo,
                Label: resources['CodigoArtigo'],
                TipoEditor: constTipoCompoHT.F3MLookup,
                Controlador: '../Artigos/Artigos/ListaComboCodigo',
                ControladorExtra: '../Artigos/Artigos/IndexGrelha',
                CampoTexto: "Codigo",
                ListaCamposPreencher: [{
                    'Coluna': hdsnColumns.DescriaoArtigo, 'Campo': 'Descricao',
                    'Coluna': 'CodigoFornecedor', 'Campo': 'CodigoFornecedor'
                }],
                width: 50
            },
            {
                ID: hdsnColumns.DescriaoArtigo,
                Label: resources['Descricao'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                width: 100,
                readOnly: true
            },
            {
                ID: hdsnColumns.Quantidade,
                Label: resources['Quantidade'],
                TipoEditor: constTipoCompoHT.F3MNumero,
                width: 20
            },
            {
                ID: hdsnColumns.ValorComIVA,
                Label: 'Valor c/ IVA',
                TipoEditor: constTipoCompoHT.F3MNumero,
                width: 25,
                CasasDecimais: parseInt(constRefCasasDecimaisTotais),
                readOnly: true
            }];

        return result;
    };

    /*@description Funcao quando é clicado na checkbox selecionar da HT (seleciona ou desseleciona todas as linhas)*/
    self.HandsonTableClickHeader = function (chkElem) {
        var colIndex = 0;
        var chkval = $(chkElem).is(':checked');
        var hdsn = self.RetornaHT();


        var newColHeaders = hdsn.getColHeader();
        chkval ? newColHeaders[colIndex] = self.AdicionaChecked(newColHeaders[colIndex], true) : newColHeaders[colIndex] = self.AdicionaChecked(newColHeaders[colIndex], false);
        hdsn.updateSettings({
            colHeaders: newColHeaders
        });

        var hdsnDS = hdsn.getSourceData();
        for (var i = 0, len = hdsnDS.length - 1; i < len; i++) {
            var row = hdsnDS[i];

            row[hdsnColumns.LinhaSelecionada] = chkval;
        }

        self.ConfiguraColunas(hdsn);
    };

    /*@description Funcao que verifica se estão todas as linhas piscadas e pisca ou não a coluna selecionar da HT */
    self.AdicionaChecked = function (inStr, inChecked) {
        if (inChecked) {
            return inStr.replace('type="checkbox"', 'type="checkbox" checked="checked" ');
        }
        else {
            return inStr.replace('checked="checked"', '');
        }
    };

    /*@description Funcao que configura colunas (readOnly)*/
    self.ConfiguraColunas = function (inHdsn) {
        for (var i = 0, len = inHdsn.countRows(); i < len; i++) {
            var linhaselecionada = inHdsn.getDataAtRowProp(i, hdsnColumns.LinhaSelecionada);
            var art = UtilsVerificaObjetoNotNullUndefinedVazio(inHdsn.getDataAtRowProp(i, hdsnColumns.CodigoArtigo));

            var cellMetaSelecionar = inHdsn.getCellMeta(i, 0);
            cellMetaSelecionar['readOnly'] = !art;

            var cellMetaQuantidade = inHdsn.getCellMeta(i, 3);
            cellMetaQuantidade['readOnly'] = !(linhaselecionada && art);
        }

        inHdsn.render();
    };

    /*@description Funcao de afterChange da HT */
    self.AfterChangeHT = function (inHdsn, inChanges, inSource) {
        if (inSource === constSourceHT.LoadData || !UtilsVerificaObjetoNotNullUndefined(inChanges)) {
            return;
        }

        switch (inChanges[0][1]) {
            case hdsnColumns.LinhaSelecionada:
                var newColHeaders = inHdsn.getColHeader();

                var aux = $.grep(inHdsn.getSourceData(), function (obj, i) {
                    return obj[hdsnColumns.LinhaSelecionada] === false || !UtilsVerificaObjetoNotNullUndefinedVazio(obj[hdsnColumns.LinhaSelecionada]);
                }).length;

                if (aux >= 2 && $('#checkBoxColumn').is(':checked')) {
                    newColHeaders[0] = self.AdicionaChecked(inHdsn.getColHeader()[0], false);
                }
                else if (aux < 2 && !$('#checkBoxColumn').is(':checked')) {
                    newColHeaders[0] = self.AdicionaChecked(inHdsn.getColHeader()[0], true);
                }

                inHdsn.updateSettings({
                    colHeaders: newColHeaders
                });
                break;

            case hdsnColumns.CodigoArtigo:
                if (UtilsVerificaObjetoNotNullUndefinedVazio(inChanges[0][3])) {
                    var art = HandsonTableVarGridHTF4DS()[0];

                    if (UtilsVerificaObjetoNotNullUndefinedVazio(art)) {
                        var hdsnDSLin = inHdsn.getSourceData()[inChanges[0][0]];

                        hdsnDSLin["CodigoArtigo"] = art['Codigo'];
                        hdsnDSLin["CodigoBarras"] = art['CodigoBarras'];
                        hdsnDSLin[hdsnColumns.LinhaSelecionada] = true;
                        hdsnDSLin[hdsnColumns.IDArtigo] = art['ID'];
                        hdsnDSLin[hdsnColumns.DescriaoArtigo] = art['Descricao'];
                        hdsnDSLin[hdsnColumns.Quantidade] = 1;
                        hdsnDSLin[hdsnColumns.ValorComIVA] = art['ValorComIva'];
                        hdsnDSLin["CodigoFornecedor"] = art['CodigoFornecedor'];
                        hdsnDSLin["DescricaoMarca"] = art['DescricaoMarca'];
                        hdsnDSLin['ValorComIva2'] = art['ValorComIva2'];
                        hdsnDSLin['CodigoBarrasFornecedor'] = art['CodigoBarrasFornecedor'];

                        //TODO
                        hdsnDSLin['ID'] = 0;
                        hdsnDSLin['Ativo'] = true;
                        hdsnDSLin['Sistema'] = true;
                        hdsnDSLin['AcaoFormulario'] = 0;
                        hdsnDSLin['Ordem'] = 0;
                        hdsnDSLin['Alterada'] = false;

                        inHdsn.getActiveEditor().cellProperties.valid = true; //retirar o erro
                    }
                }
                break;
        }

        self.ConfiguraColunas(inHdsn);
    };

    /*@description Funcao que constroi a HT */
    self.ConstroiHT = function (inData) {
        var modal = $('#Modal').val() == 'True';
        var hdsn = HandsonTableDesenhaNovo(IDHDSN, inData, 400, self.RetornaColunasHT(), !modal, null, null, null, null, null, false);

        hdsn.updateSettings({
            readOnly: modal,
            fillHandle: false,
            rowHeaders: true,
            afterChange: function (changes, source) {
                self.AfterChangeHT(this, changes, source);
            }
        });

        self.ConfiguraColunas(hdsn);
    };

    /*@description Funcao que retorna a instancia da HT */
    self.RetornaHT = function () {
        return window.HotRegisterer.bucket[IDHDSN];
    };

    return parent;

}($etiquetasartigos || {}, jQuery));

var EtiquetasConstroiHT = $etiquetasartigos.ajax.ConstroiHT;
var EtiquetasHandsonTableClickHeader = $etiquetasartigos.ajax.HandsonTableClickHeader;

$(document).ajaxSend(function (inEvent, jqxhr, inSettings) {
    var requestsBarLoding = ['Artigos/ListaComboCodigo'];
    KendoBarLoading(null, inSettings, requestsBarLoding);
}).ajaxStop(function () {
    var elem = $('#iframeBody');
    KendoLoading(elem, false, true);
});