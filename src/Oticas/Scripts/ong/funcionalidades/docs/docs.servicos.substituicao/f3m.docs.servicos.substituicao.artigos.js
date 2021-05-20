"use strict";

var $docsservicossubstituicaoartigos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T S
    //constantes base
    var constsBase = base.constantes;

    //constantes handsontable
    var HDSNID = 'hdsnArtigos', constTipoCompoHT = constsBase.ComponentesHT, constSourceHT = constsBase.SourceHT;

    //constantes tipos de olho
    var TipoOlho = {
        Direito: 1,
        Esquerdo: 2,
        Aro: 3
    };

    //constantes tipos de graduacao
    var TipoGraduacao = {
        Longe: 1,
        Intermedio: 2,
        Perto: 3,
        LentesContato: 4,
    }

    //------------------------------------ H A N D S O N T A B L E
    self.GetHdsnInstance = () => HotRegisterer.bucket[HDSNID];

    self.Hdsn = (data) => {
        // remove from dom
        $('#tempHdsnDS').remove();
        //get columns
        var _columns = self.GetColumns();
        //hdsn
        var hdsn = HandsonTableDesenhaNovo(HDSNID, data, null, _columns, false);
        //update settings
        hdsn.updateSettings({
            fillHandle: false,
            columnSorting: false,
            manualRowResize: false,
            rowHeaders: (index) => self.GetRowHeaders(hdsn, index),
            afterGetColHeader: (col, TH) => self.AfterGetColHeader(hdsn, col, TH),
            rowHeaderWidth: 100,
            afterChange: (changes, source) => self.AfterChange(hdsn, changes, source)
        });

        self.SetColumnsSettings(hdsn);
        self.SetHeight();
    };

    self.GetColumns = () => {
        var columns = [
            {
                ID: "DiametroOrigem",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: "Ø",
                renderer: "html",
                readOnly: true,
                className: "htRight",
                invalidCellClassName: "",
                width: 50
            },
            {
                ID: "CodigoArtigoOrigem",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources["Artigo"],
                readOnly: true,
                width: 100
            },
            {
                ID: 'DescricaoArtigoOrigem',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Descricao'],
                readOnly: true,
                width: 200
            },
            {
                ID: "DiametroDestino",
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: "Ø",
                renderer: "html",
                className: "htRight",
                invalidCellClassName: "",
                readOnly: false,
                width: 50
            },
            {
                ID: "CodigoArtigoDestino",
                TipoEditor: constTipoCompoHT.F3MLookup,
                CampoTexto: "Codigo",
                Label: 'Substituir por',
                Controlador: rootDir + "/DocumentosVendasServicos/ListaArtigosComboCodigo",
                ControladorExtra: rootDir + "/Artigos/Artigos/IndexGrelha",
                width: 100,
                readOnly: false,
                FuncaoEnviaParams: (objetoFiltro, hdsn, actCel, colunaAtual, props) => self.EnviaParametrosArtigos(objetoFiltro, hdsn, actCel, colunaAtual, props)
            },
            {
                ID: 'DescricaoArtigoDestino',
                TipoEditor: constTipoCompoHT.F3MTexto,
                Label: resources['Descricao'],
                readOnly: true,
                width: 200
            }];

        return columns;
    };

    self.GetRowHeaders = (hdsn, index) => {
        let idTipoServico = hdsn.getSourceDataAtRow(index).IDTipoServico;

        if (idTipoServico === 1) { //unifocal longe / perto
            let idTipoGraduacao = hdsn.getSourceDataAtRow(index).IDTipoGraduacao;

            switch (idTipoGraduacao) {
                case TipoGraduacao.Longe:
                    return self.GetRowHeadersWithPrefix(hdsn, index, 'Longe -');

                case TipoGraduacao.Perto:
                    return self.GetRowHeadersWithPrefix(hdsn, index, 'Perto -');

                default:
                    return self.GetRowHeadersWithPrefix(hdsn, index);
            }
        }
        return self.GetRowHeadersWithPrefix(hdsn, index);
    };

    self.GetRowHeadersWithPrefix = (hdsn, index, prefix) => {
        prefix = prefix || '';

        switch (hdsn.getSourceDataAtRow(index).IDTipoOlho) {
            case TipoOlho.Direito:
                return prefix + ' ' + resources.OD;
            case TipoOlho.Aro:
                return prefix + ' ' + resources.Aro;
            case TipoOlho.Esquerdo:
                return prefix + ' ' + resources.OE;
        }
        return '';
    };

    self.AfterGetColHeader = (hdsn, col, TH) => {
        if (col < 0) {
            TH.innerHTML = $('#DescricaoTipoServico').val()
        }
    }

    self.SetColumnsSettings = function (hdsn) {
        for (let index = 0; index < hdsn.countRows(); index++) {
            self.SetColumnCodigoArtigoDestino(hdsn, index);
            self.SetColumnDiametro(hdsn, index);
        }
        hdsn.render();
    };

    self.SetColumnDiametro = (hdsn, rowNumber) => {
        let indexColDiametroDestino = hdsn.propToCol('DiametroDestino');
        let cellDiametro = hdsn.getCellMeta(rowNumber, indexColDiametroDestino);
        let tipoOlho = hdsn.getDataAtRowProp(rowNumber, "IDTipoOlho");

        cellDiametro.readOnly = tipoOlho === TipoOlho.Aro;
    }

    self.SetColumnCodigoArtigoDestino = function (hdsn, rowNumber) {
        let indexColCodigoArtigoDestino = hdsn.propToCol('CodigoArtigoDestino');
        let cellCodigoArtigoDestino = hdsn.getCellMeta(rowNumber, indexColCodigoArtigoDestino);
        let tipoOlho = hdsn.getDataAtRowProp(rowNumber, "IDTipoOlho");

        if (tipoOlho !== TipoOlho.Aro) {
            cellCodigoArtigoDestino.Controlador = rootDir + "/Documentos/CatalogosLentesServicosSubstituicao";
            cellCodigoArtigoDestino.ControladorExtra = "";
        }
        else {
            cellCodigoArtigoDestino.Controlador = rootDir + "/DocumentosVendasServicos/ListaArtigosComboCodigo";
            cellCodigoArtigoDestino.ControladorExtra = rootDir + "/Artigos/Artigos/IndexGrelha";
        }
    };

    self.GetHdsnSourceData = () => self.GetHdsnInstance().getSourceData();

    //------------------------------------ H A N D S O N T A B L E     -     A F T E R     C H A N G E
    self.AfterChange = (hdsn, changes, source) => {
        if (source === constSourceHT.LoadData || source === constSourceHT.PopulateFromArray || source === constSourceHT.ObserveChangesChange) { return; }
        //set props
        let row = changes[0][0];
        let prop = changes[0][1];
        let oldValue = changes[0][2];
        let newValue = changes[0][3];
        //after change cols
        if (oldValue !== newValue) {
            switch (prop) {
                case 'DiametroDestino':
                    self.AfterChange_DiametroDestino(hdsn, row, oldValue, newValue);
                    break;

                case 'CodigoArtigoDestino':
                    self.AfterChange_CodigoArtigoDestino(hdsn, row, oldValue, newValue);
                    break;
            }
            //ativa dirty
            switch (prop) {
                case 'DiametroDestino':
                case 'CodigoArtigoDestino':
                    $docsservicossubstituicao.ajax.EnableDirty();
                    self.SetHeight();
                    break;
            }
        }
    }

    self.AfterChange_DiametroDestino = (hdsn, row, oldValue, newValue) => {
        if (newValue === '') {
            hdsn.getSourceDataAtRow(row)['DiametroDestino'] = hdsn.getSourceDataAtRow(row)['DiametroOrigem'];
        }

        $docsservicossubstituicaograds.ajax.ReqValidaExisteArtigo();
    }

    self.AfterChange_CodigoArtigoDestino = (hdsn, row, oldValue, newValue) => {
        let elemDS = HandsonTableVarGridHTF4DS()[0];

        if (elemDS && hdsn.getDataAtRowProp(row, 'CodigoArtigoDestino')) {
            self.SetArtigoValido(hdsn, row, elemDS);
        }
        else {
            self.SetArtigoInvalido(hdsn, row, oldValue, newValue);
        }

        hdsn.render();
    }

    self.SetHeight = () => self.GetHdsnInstance().updateSettings({ height: 250 });

    self.RedimensionaHT = () => {
        //redimensiona loading bar
        var grelha = '.grelha-loading', container = '.clsF3MTabs ';
        $(grelha).width($(container).width());
    };

    //------------------------------------ A R T I G O S
    self.EnviaParametrosArtigos = (objetoFiltro, hdsn, actCel, colunaAtual, row) => {
        let currentRowDS = hdsn.getSourceDataAtRow(row);

        if (currentRowDS.IDTipoOlho === TipoOlho.Aro) {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "IDSistemaClassificacao", '', 2);
        }
        else {
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDTipoServico', '', currentRowDS.IDTipoServico);
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDTipoOlho', '', currentRowDS.IDTipoOlho);
            GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "IDTipoArtigo", '', currentRowDS.IDTipoArtigo);
        }
        return objetoFiltro;
    }

    self.EnviaParametrosArtigosF4 = (objetoFiltro, grid) => {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, "IDSistemaClassificacao", '', 2);

        return objetoFiltro;
    }

    self.SetArtigoValido = (hdsn, row, elemDS) => {
        let currentRowDS = hdsn.getSourceDataAtRow(row);

        currentRowDS['DiametroDestino'] = elemDS['Diametro'];
        currentRowDS['IdArtigoDestino'] = elemDS['ID'];
        currentRowDS['CodigoArtigoDestino'] = elemDS['Codigo'];
        currentRowDS['CodigoBarrasArtigoDestino'] = elemDS['CodigoBarras'];
        currentRowDS['DescricaoArtigoDestino'] = elemDS['Descricao'];
        currentRowDS['IDModelo'] = elemDS['IDModelo'];
        currentRowDS['DescricaoModelo'] = elemDS['DescricaoModelo'];
        currentRowDS['IDMarca'] = elemDS['IDMarca'];
        currentRowDS['DescricaoMarca'] = elemDS['DescricaoMarca'];
        currentRowDS['IDTratamentoLente'] = elemDS['IDTratamentoLente'];
        currentRowDS['DescricaoTratamentoLente'] = elemDS['DescricaoTratamentoLente'];
        currentRowDS['IDCorLente'] = elemDS['IDCorLente'];
        currentRowDS['DescricaoCorLente'] = elemDS['DescricaoCorLente'];
        currentRowDS['IDTipoLente'] = elemDS['IDTipoLente'];
        currentRowDS['IDMateria'] = elemDS['IDMateriaLente'];
        currentRowDS['IndiceRefracao'] = elemDS['IndiceRefracao'];
        currentRowDS['Fotocromatica'] = elemDS['Fotocromatica'];
        currentRowDS['IDsSuplementos'] = elemDS['IDsSuplementos'];
        currentRowDS['PotenciaPrismatica'] = elemDS['PotenciaPrismatica'];
        currentRowDS['Preco'] = elemDS['ValorComIva'];
        currentRowDS['CustoMedioArtigoDestino'] = elemDS['Medio'] || 0;
        currentRowDS['TaxaIvaArtigoDestino'] = elemDS['Taxa'];

        if (currentRowDS['IDTipoOlho'] != TipoOlho.Aro) {
            $docsservicossubstituicaograds.ajax.SetGradByArtigo(currentRowDS, elemDS);
        }

        delete hdsn.getSourceDataAtRow(row)['IDArtigoDestino'];

        if (currentRowDS['CodigoArtigoOrigem'] === currentRowDS['CodigoArtigoDestino']) {
            UtilsNotifica(base.constantes.tpalerta.warn, "O artigo de substituição é o mesmo que o artigo a substituir."); //TODO resx
        }
    }

    self.SetArtigoInvalido = (hdsn, row, oldValue, newValue) => {
        let currentRowDS = hdsn.getSourceDataAtRow(row);

        currentRowDS['IdArtigoDestino'] = 0;
        currentRowDS['CodigoArtigoDestino'] = '';
        currentRowDS['CodigoBarrasArtigoDestino'] = '';
        currentRowDS['DescricaoArtigoDestino'] = '';
        currentRowDS['IDModelo'] = null;
        currentRowDS['DescricaoModelo'] = null;
        currentRowDS['IDMarca'] = null;
        currentRowDS['IDTratamentoLente'] = null;
        currentRowDS['DescricaoTratamentoLente'] = null;
        currentRowDS['IDCorLente'] = null;
        currentRowDS['DescricaoCorLente'] = null;
        currentRowDS['IDTipoLente'] = null;
        currentRowDS['IDMateria'] = null;
        currentRowDS['IndiceRefracao'] = null;
        currentRowDS['Fotocromatica'] = null;
        currentRowDS['IDsSuplementos'] = [];
        currentRowDS['PotenciaPrismatica'] = null;
        currentRowDS['Preco'] = 0;
        currentRowDS['CustoMedioArtigoDestino'] = 0;
        currentRowDS['TaxaIvaArtigoDestino'] = 0;

        if (newValue && newValue !== '') {
            UtilsNotifica(base.constantes.tpalerta.warn, "O artigo inserido é inválido."); //TODO resx
        }
    }

    return parent;

}($docsservicossubstituicaoartigos || {}, jQuery));

