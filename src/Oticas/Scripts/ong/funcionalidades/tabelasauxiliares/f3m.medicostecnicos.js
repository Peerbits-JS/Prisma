"use strict";

var $medicostecnicos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constCamposGen = base.constantes.camposGenericos;
    var campoDistrito = "#" + constCamposGen.IDDistrito;
    var campoConcelho = "#" + constCamposGen.IDConcelho;
    var campoOrdem = constCamposGen.Ordem;

    var campoCodSistTipoEnt = 'CodigoSistemaTipoEntidade';

    var campoMedicoTecnicoID = "IDMedicoTecnico";
    var campoNContribuinte = "NContribuinte";
    var campoOrdemMaq = 'OrdemMorada';

    //para a ARVORE ------------------------------------
    var gridID = 'F3MGrelhaFormMedicosTecnicos';

    self.Init = function () {
        // Anexos
        $('#btnAnexos').on('click', () => self.CliqueAnexos());

        // Trata a indicação de conteúdo no campo de observações
        UtilsObservacoesTrataEspecifico("tabObservacoes", "Observacoes", "Avisos");
    };

    // CLIQUE NOS BOTOES LATERAIS
    self.CliqueAnexos = () => JanelaDesenha(base.constantes.janelasPopupIDs.Menu, {}, '../TabelasAuxiliares/MedicosTecnicosAnexos');

    self.EditaGrelhaMoradas = function (grid, e) {
        self.TrataValoresPorDefeito(grid, e.model);
    };

    // ENVIO DE IDARTIGO PARA O DATASOURCE DAS GRELHAS DE LINHAS NO ARTIGO
    self.EnviaParametros = function (objetoFiltro) {
        var elemAux = $('#' + campoCodSistTipoEnt);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoCodSistTipoEnt);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoCodSistTipoEnt);

        var elemAux = $('#' + campoMedicoTecnicoID);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoMedicoTecnicoID);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true, campoMedicoTecnicoID);

        //iddistrito
        var elemAux = $(campoDistrito);
        var elem = (elemAux.length) ? elemAux : window.parent.$(campoDistrito);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true);

        //idconcelho
        elemAux = $(campoConcelho);
        elem = (elemAux.length) ? elemAux : window.parent.$(campoConcelho);
        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elem, true);

        return objetoFiltro
    }

    //DATABOUND PARA GRELHA MORADAS
    self.DataBound = function (e) {
        var grid = this;

        if (UtilsVerificaObjetoNotNullUndefined(grid)) {
            grid.table.kendoSortable({
                filter: "> tbody > tr:not(.k-grid-edit-row)",
                hint: $.noop,
                cursor: "move",
                placeholder: function (element) {
                    return element.clone().addClass("k-state-selected").css("opacity", 0.65);
                },
                container: "#" + grid.element.attr('id') + " tbody",
                start: function (e) {
                    if (grid.element.find('.k-grid-edit-row').length) {
                        e.preventDefault();
                        return false;
                    }
                },
                end: function (e) {
                    var newIndex = e.newIndex;
                    var draggedItem = grid.dataSource.getByUid(e.item.data("uid"));
                    var targetRow = jQuery(this.items()[newIndex]);
                    var targetItem = grid.dataSource.getByUid(targetRow.data('uid'));
                    var ord = draggedItem[campoOrdemMaq];
                    var orddest = targetItem[campoOrdemMaq];

                    if (draggedItem[campoOrdemMaq] !== targetItem[campoOrdemMaq]) {
                        var sortable = this;
                        var dataSource = grid.dataSource;
                        var itemsInCategory = jQuery.grep(sortable.items().slice(0), function (item) {
                            var dataItem = dataSource.getByUid(jQuery(item).data("uid"));
                            return dataItem[campoOrdemMaq] === ord;
                        });
                        if (itemsInCategory.length >= 0) {
                            self.ReordenaGrelha(grid, ord, orddest - 1);
                            var item = itemsInCategory[0];
                            var dataItem = dataSource.getByUid(jQuery(item).data("uid"));
                            dataItem.set(campoOrdemMaq, orddest);
                            dataItem.set(campoOrdem, orddest);
                            dataItem.set("dirty", true);
                            GrelhaLinhasColocaLinhaNasLinhasAlteradas(grid.element.attr('id'), dataItem, estadoAdicionar);
                            var dsSort = []
                            dsSort.push({ field: campoOrdemMaq, dir: "asc" });
                            dataSource.sort(dsSort);
                            var gridcab = $('#' + gridID).data("kendoGrid");
                            var dsAtual = dataSource.view();
                            var gridIDAux = grid.element.attr('id')
                            GrelhaUtilsAtivaDesativaBotoesAcoes(gridcab, true);
                            GrelhaLinhasSetDataSourceNaHidden(dsAtual, gridIDAux);
                        }
                    }
                }
            });
        }
        GrelhaLinhasDataBound(e);
    }

    /* @desc 'função de databound das treelists' @author mjs */
    self.TreeListDataBound = function (e) {
        var arvore = this;
        var chkCabCon = true;
        var chkCabAdi = true;

        if (UtilsVerificaObjetoNotNullUndefined(arvore)) {
            var arvoreDS = arvore.dataSource.data();
            var arvoreElem = arvore.element;
            var arvoreDSLen = arvoreDS.length;

            if (arvoreDSLen > 0) {
                for (var i = 0; i < arvoreDSLen; i++) {
                    var DSLinha = arvoreDS[i];

                    if (DSLinha.ContextoConsultar && !DSLinha.Consultar) { chkCabCon = false; }
                    if (DSLinha.ContextoAdicionar && !DSLinha.Adicionar) { chkCabAdi = false; }

                    if (!chkCabCon && !chkCabAdi) { break; }
                }

                if (chkCabCon) { arvoreElem.find('#chkConsultar').prop('checked', true); }
                if (chkCabAdi) { arvoreElem.find('#chkAdicionar').prop('checked', true); }
            }
        }
        //Esconde filtros na treelist Especialidades
        $('#MedicosTecnicosEspecialidades .k-grid-filter').hide();
        $('#MedicosTecnicosEspecialidades .k-button').hide();
    }

    // ENVIA PARAMS DAS TREE LISTS
    self.TreeListEnviaParams = function (e) {
        var objetoFiltro = self.EnviaParametros(GrelhaUtilsObjetoFiltro());
        var elemMedicoTecnico = $('#' + campoMedicoTecnicoID);

        GrelhaUtilsPreencheObjetoFiltro(objetoFiltro, elemMedicoTecnico, true, campoMedicoTecnicoID);

        return objetoFiltro
    }

    // FUNCAO ESPECIFICA QUE COLOCA MODELO DA TREE MenusPerfisAcessos NO MODELO FORM
    self.GravaMedicosTecnicosEspecialidades = function (arvore, jsonData) {
        try {
            var arvoreID = arvore.element.attr('id');
            var arvoreDS = arvore.dataSource.data();
            var linhasAcessoEmp = [];

            for (var i = 0; i < arvoreDS.length; i++) {
                linhasAcessoEmp.push(arvoreDS[i]);
                linhasAcessoEmp[i].IDMedicoTecnico = $('#' + campoMedicoTecnicoID).val();
            }

            if (linhasAcessoEmp.length) {
                if (UtilsVerificaObjetoNotNullUndefined(jsonData)) {
                    jsonData[arvoreID] = linhasAcessoEmp;
                }
            }
        } catch (e) {
            throw e
        }
    }

    // VALIDACAO ESPECIFICA PARA Fornecedores
    self.ValidaEspecifica = function (grid, data, url) {
        var _options = grid.dataSource.transport.options, _erros = GrelhaUtilsValida(grid.element);

        if (_erros != null) {
            return null;
        }

        var _model = GrelhaRetornaModeloLinha(grid);
        var _boolModel = UtilsVerificaObjetoNotNullUndefined(_model);

        // VALIDA EXCEPTO SE FOR REMOVER REGISTO
        if (url !== _options.destroy.url) {
            if (_boolModel) {
                _erros = self.VerificaSequencia(grid, _erros);
            }
        }
        else {
            var orma = _model['OrdemMorada'];

            if (_boolModel) {
                //aqui alterar o modelo e grid
                var gridDS = grid.dataSource.view();

                for (var ii1 = 0; ii1 < gridDS.length; ii1++) {
                    if (gridDS[ii1]['OrdemMorada'] > orma) {
                        gridDS[ii1]['OrdemMorada'] = gridDS[ii1]['OrdemMorada'] - 1;
                        gridDS[ii1]['Ordem'] = gridDS[ii1]['OrdemMorada'];
                        gridDS[ii1].dirty = true;
                        GrelhaLinhasColocaLinhaNasLinhasAlteradas(grid.element.attr('id'), gridDS[ii1], '0');
                    }
                }
            }
        }

        return _erros;

    }

    /* @desc 'função para validar NContibuinte E tabela MedicosTecnicosEspecialidades ' @author: marcelo&pef */
    self.ValidaEspecificaForm = function (grid, data, url) {
        var options = grid.dataSource.transport.options;
        var gridID = grid.element.attr('id');
        var erros = GrelhaUtilsValida($('#' + gridID + 'Form'));

        if (erros != null) {
            return null;
        }

        // VALIDA EXCEPTO SE FOR REMOVER REGISTO
        if (url !== options.destroy.url) {
            var codigoS = "1";
            if (codigoS == "1") {//Nacional
                var Nif = $('#' + campoNContribuinte).val();
                if (!ValidaisValidNIF(Nif)) {
                    erros = UtilsAdicionaRegistoArray(erros, resources.ValidaNIF);
                    var link = $('.clsF3MTabs a[href=#tabDefinicoesFiscais]').click();
                    link.click();
                }
            }
        }

        return erros;
    };

    // REORDENAR COLUNA ORDEM DA GRELHA
    self.ReordenaGrelha = function (grid, inOrdemTarget, inOrdemDest) {
        if (inOrdemTarget == inOrdemDest) {
            return false;
        }
        var gridDS = grid.dataSource.view();
        if (inOrdemTarget > inOrdemDest) {
            //é para aumentar a partir da OrdemDest até à ordem target
            for (var cont = inOrdemDest; cont < inOrdemTarget; cont++) {
                gridDS[cont - 1].OrdemMorada = gridDS[cont - 1].OrdemMorada + 1;
                gridDS[cont - 1].Ordem = gridDS[cont - 1].OrdemMorada;
                gridDS[cont - 1].dirty = true;
                GrelhaLinhasColocaLinhaNasLinhasAlteradas(grid.element.attr('id'), gridDS[cont - 1], estadoAdicionar);
            }
        }
        else {
            //é para diminuir 1 a partir da inOrdemTarget + 1 até OrdemDest
            for (var cont = inOrdemDest; cont > inOrdemTarget; cont--) {
                gridDS[cont - 1].OrdemMorada = gridDS[cont - 1].OrdemMorada - 1;
                gridDS[cont - 1].Ordem = gridDS[cont - 1].OrdemMorada;
                gridDS[cont - 1].dirty = true;
                GrelhaLinhasColocaLinhaNasLinhasAlteradas(grid.element.attr('id'), gridDS[cont - 1], estadoAdicionar);
            }
        }
    };

    // Trata valores por defeito
    self.TrataValoresPorDefeito = function (grid, modelo) {
        if (UtilsVerificaObjetoNotNullUndefined(grid)) {
            var ordemm = 0;
            if (modelo[campoOrdemMaq] != null) {
                ordemm = modelo[campoOrdemMaq]
            }
            if (ordemm == 0) {
                var EntradaMaq = UtilsRetornaValorMaximoModelo(grid.dataSource.data(), campoOrdemMaq) + 1;

                var rowFicha = grid.tbody.find("tr[data-role='editable']").find("input#" + campoOrdemMaq)
                rowFicha.val(EntradaMaq);
                modelo[campoOrdem] = EntradaMaq;
            }
        }
    };

    /* @desc 'função clique nas checkbox principal que força uma única escolha e força o check na coluna selecionado' @21jun2016 pef */
    self.ClickCBPrincipal = function (cbElemAux) {
        var cbElem = $(cbElemAux);
        var cbElemID = cbElem.attr('id');
        var cbTipoAcesso = cbElem.attr('data-tpacess');
        var arvoreElem = cbElem.parents('[data-role=' + base.constantes.Kendo.treelist + ']');
        var arvore = KendoRetornaElemento(arvoreElem);

        if (UtilsVerificaObjetoNotNullUndefined(arvore)) {
            var arvoreDS = arvore.dataSource;
            var modeloLinha = arvoreDS.get(cbElemID);
            var arvoreDSData = arvore.dataSource.data();

            for (var i = 0; i < arvoreDSData.length; i++) {
                var linha = arvoreDSData[i];

                if (modeloLinha == linha) {
                    cbElemAux.checked = true;
                    linha.Principal = true;
                    linha.Selecionado = true;
                }
                else {
                    linha.Principal = false;
                }
            }

            arvore.refresh();
            GrelhaFormAtivaDesativaBotoesAcoes(gridID, true);
        }
    };

    /* @desc 'função clique nas checkboxs da treelist(cabeçalho)' @author mjs */
    /* alterado para que jogue com o campo Principal _@21jun2016_pef*/
    self.ClickCBHeader = function (cbElemAux) {
        var cbElem = $(cbElemAux);
        var cbTipoAcesso = cbElem.attr('data-tpacess');
        var arvoreElem = cbElem.parents('[data-role=' + base.constantes.Kendo.treelist + ']');
        var arvore = KendoRetornaElemento(arvoreElem);

        if (UtilsVerificaObjetoNotNullUndefined(arvore)) {
            var arvoreDSData = arvore.dataSource.data();

            for (var i = 0; i < arvoreDSData.length; i++) {
                var linha = arvoreDSData[i];

                if (linha.Principal != true) {
                    linha[cbTipoAcesso] = cbElem.prop('checked');
                }
            }

            arvore.refresh();
            GrelhaFormAtivaDesativaBotoesAcoes(gridID, true);
        }
    };

    self.ClickCBSelecionado = function (cbElemAux, pisco) {
        var cbElem = $(cbElemAux);
        var cbElemID = cbElem.attr('id');
        var cbTipoAcesso = cbElem.attr('data-tpacess');
        var arvoreElem = cbElem.parents('[data-role=' + base.constantes.Kendo.treelist + ']');
        var arvore = KendoRetornaElemento(arvoreElem);

        if (UtilsVerificaObjetoNotNullUndefined(arvore)) {
            var arvoreDS = arvore.dataSource;
            var modeloLinha = arvoreDS.get(cbElemID);

            //if (counterPrincipaisVazios != 0) {
            if (modeloLinha.Principal == true) {
                cbElemAux.checked = true;
            }
            else {
                ArvoreColocaModeloCheckBoxNaArvore(arvore.dataSource, cbElem, cbTipoAcesso);
            }

            arvore.refresh();
            GrelhaFormAtivaDesativaBotoesAcoes(gridID, true);

        }
    };

    /*@description Funcao que verifica a sequencia da orem na grelha de moradas */
    self.VerificaSequencia = function (grid, erros) {
        var _indexStart = 1;
        var gridDS = grid.dataSource.data();
        //verificar o ds
        if (UtilsVerificaObjetoNotNullUndefinedVazio(gridDS) && gridDS.length > 0) {
            var _arrOrdem = [];
            // colecionar as ordens todas
            for (var i = 0; i < gridDS.length; i++) {
                _arrOrdem.push(gridDS[i]['OrdemMorada']);
            }
            //verificar se existem linhas
            if (_arrOrdem.length) {
                //sortear a ordem
                _arrOrdem = _arrOrdem.sort();
                //ordem tem que começar em 2


                if (_arrOrdem[0] != _indexStart) {
                    erros = UtilsAdicionaRegistoArray(erros, resources.erro_CK_OrdemSequencialMorada);
                    return erros;
                }
                //verificar se a ordem é sequencial
                for (var i = _arrOrdem.length; i > 1; i--) {
                    var _item = _arrOrdem[i - 1], _itemMenosUm = _arrOrdem[i - 2];

                    if ((_item - _itemMenosUm) != 1) {
                        erros = UtilsAdicionaRegistoArray(erros, resources.erro_CK_OrdemSequencialMorada);
                        return erros;
                    }
                }
            }
        }
        return null;
    };

    return parent;

}($medicostecnicos || {}, jQuery));

var MedicosTecnicosEnviaParametros = $medicostecnicos.ajax.EnviaParametros;
var MedicosTecnicosDataBound = $medicostecnicos.ajax.DataBound;
var MedicosTecnicosEditaGrelhaMoradas = $medicostecnicos.ajax.EditaGrelhaMoradas;

//para ARVORE
var MedicosTecnicosTreeListDataBound = $medicostecnicos.ajax.TreeListDataBound;
var MedicosTecnicosTreeListEnviaParams = $medicostecnicos.ajax.TreeListEnviaParams;
var MedicosTecnicosClicaCBPrincipal = $medicostecnicos.ajax.ClickCBPrincipal;
var MedicosTecnicosClicaCBSelecionado = $medicostecnicos.ajax.ClickCBSelecionado;
var MedicosTecnicosClicaCB = $medicostecnicos.ajax.ClickCBContent;
var MedicosTecnicosClicaCBRecursiva = $medicostecnicos.ajax.ClickCBContentRecursiva;
var MedicosTecnicosClicaCBCabecalho = $medicostecnicos.ajax.ClickCBHeader;

var GravaMedicosTecnicosEspecialidades = $medicostecnicos.ajax.GravaMedicosTecnicosEspecialidades;
var MedicosTecnicosMoradasValidaEspecifica = $medicostecnicos.ajax.ValidaEspecifica;
var MedicosTecnicosValidaEspecifica = $medicostecnicos.ajax.ValidaEspecificaForm;

/* --------------- NECESSARIO EM CASO DE HAVER FOTO --------------- */
var MedicosTecnicosonSuccess = F3MFotoSucesso;
var MedicosTecnicosonUpload = F3MFotoUpload;
var MedicosTecnicosonSelect = F3MFotoSelect;
var MedicosTecnicosonRemove = F3MFotoRemove;
/* ---------------------------------------------------------------- */

$(document).ready(() => $medicostecnicos.ajax.Init());