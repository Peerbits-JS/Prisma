'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $examesindex = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;
    var constsTiposComponentes = constsBase.tiposComponentes;

    //constantes grid
    var constComboVistas = 'tableheader'

    //constantes splitter
    var constPaneFormID = constsTiposComponentes.paneFormID, constSplitterID = constsTiposComponentes.splitterID;

    //constantes data
    var constData = 'data';

    //constantes botoes
    var constNovaConsulta = 'btnNovaConsulta', constRefresh = 'btnRefresh';
    var constAddGrid = 'F3MGrelhaFormExamesBtAdd', constRefreshGrid = 'F3MGrelhaFormExamesBtRefresh';

    var btIDAdd = constsBase.grelhaBotoesIDs.Adicionar;

    //
    self.JaPassouGridSelect = false;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //hide combo vistas
        $('.' + constComboVistas).hide();

        //instance date picker
        $('#' + constData).kendoDatePicker();

        //date event change
        $('#' + constData).on('change', function () {
            $('#' + constRefreshGrid).trigger('click');
        });

        //click to add new marcacao
        $('#' + constNovaConsulta).on('click', function (e) {
            self.AbreTabMarcacoes(e);
        });

        //click to refresh grid
        $('#' + constRefresh).on('click', function (e) {
            $('#' + constRefreshGrid).trigger('click');
        });

        //trata botoes de imprimir
        self.TrataBotoes();
    };

    //------------------------------------ 
    /* @description funcao que abre as marcacoes */
    self.AbreTabMarcacoes = function (inEvt) {
        //props UtilsAbreTab
        var _url = 'Agendamento/Agendamento';
        var _tabnome = resources['Marcacoes'], _tabicon = 'f3icon-calendar';
        //UtilsAbreTab
        UtilsAbreTab(_url, _tabnome, _tabicon, null, null, null);
    };

    //------------------------------------ A C O E S
    /* @description */
    self.AcoesAdicionarEspecifico = function (inGrid, inURL) {
        if (inURL.indexOf('FromMarcacoes') === -1) {
            inGrid.clearSelection();
            SplitterVisivel(false)
        }
        else {
            var _id = inURL.split("=")[1].split("&")[0]; //trust me i'm an engineer!
            var _uid = $.grep(inGrid.dataSource.data(), function (obj, i) {
                return obj['IDAgendamento'] == _id;
            })[0]['uid'];

            inGrid.select(inGrid.table.find('tr[data-uid="' + _uid + '"]'));
            SplitterColapsar(true);
        }

        $grelhaForm.ajax.BloqueiaPesquisa(true);
    };

    /* @description funcao */
    self.AcoesCancelarEspecifico = function (grid, gridID, modeloForm, modeloLinha, elemBtID) {
        var cssClassBts = constsTiposComponentes.grelhaBotoes;
        var cssClassGF = constsTiposComponentes.grelhaForm;
        var constBtsClass = base.constantes.grelhaBotoesCls;
        var spanSemRegistosID = 'spanSemRegistosForm';
        var btClassRefrescar = constBtsClass.Refrescar;

        var gBts = $('.' + cssClassGF + cssClassBts);
        var btsClassEdita = '.' + constBtsClass.GuardarFecha2 + ', .' + constBtsClass.Cancelar2;

        var gridID = grid.element.attr('id');
        var gfBtsElem = $('#' + gridID + cssClassBts);

        var btsGravar = gfBtsElem.find(btsClassEdita);
        var spanSemReg = $('#' + spanSemRegistosID);


        if (btsGravar.length) {
            UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_adicao_edicao_cancelar,
                function () {
                    GrelhaFormAction(grid, '');

                    if (!UtilsVerificaObjetoNotNullUndefinedVazio(grid.dataItem(grid.select()))) {
                        SplitterVisivel(true);

                        if (gBts.length) {
                            GrelhaFormMostraEscondeBotoesAcoes(false, false, grid);
                            gBts.find('.' + btClassRefrescar).click();
                        }
                    }
                    else {
                        if (grid.dataItem(grid.select())['ID'] == 0) {
                            GrelhaFormMostraEscondeBotoesAcoes(true, true, grid);
                        }
                        else {
                            GrelhaFormMostraEscondeBotoesAcoes(false, false, grid);
                        }
                    }
                },
                function () {
                    spanSemReg.hide();
                    return false;
                });
        }
    };

    /* @description */
    self.Imprimir = function (inButtonID) {
        var gridDS = $('.' + base.constantes.tiposComponentes.grelhaForm).data('kendoGrid').dataItem($('.' + base.constantes.tiposComponentes.grelhaForm).data('kendoGrid').select());

        var modelo = {};
        modelo['ID'] = UtilsVerificaObjetoNotNullUndefinedVazio(gridDS) ? gridDS['ID'] : 0;


        var objParam = $svcImprimir.ajax.PreecheObjImpParametros(inButtonID, modelo, null);

        $svcImprimir.ajax.AbreJanela(objParam, null);
    };

    //------------------------------------ G R I D
    /* @description funcao envia parametros para a grid */
    self.GridEnviaParams = function (inObjetoFiltro) {
        //set data to obj filtro
        var _currentData = $('#' + constData).val();
        GrelhaUtilsPreencheObjetoFiltroValor(inObjetoFiltro, true, 'Data', null, _currentData);

        //return obj filtro
        return inObjetoFiltro;
    };

    /* @description funcao */
    self.GridChange = function (inEvt) {
        //get grid
        var _grid = UtilsVerificaObjetoNotNullUndefinedVazio(this) ? this : inEvt.sender;
        //get grid id
        var _gridID = _grid.element.attr('id');
        //get url esp
        var _urlEsp = sessionStorage.getItem('AdicionaEsp');

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_urlEsp)) {
            //get id esp
            var _id = _urlEsp.split("=")[1].split("&")[0]; //trust me i'm an engineer!
            //get grid uid
            var _uid = $.grep(_grid.dataSource.data(), function (obj, i) {
                return obj['IDAgendamento'] == _id;
            })[0]['uid'];

            //select row
            if (!self.JaPassouGridSelect) {
                self.JaPassouGridSelect = true;
                _grid.select(_grid.table.find('tr[data-uid="' + _uid + '"]'));
            }
        }
        
        //get row model
        var _modeloLinha = _grid.dataItem(_grid.select());

        if (UtilsVerificaObjetoNotNullUndefined(_modeloLinha)) {
            var _valorID = _modeloLinha['ID'];
            
            $grelhaForm.ajax.TAB_ACT_INDEX = 0;

            var ELF = $grelhaForm.ajax.RetornaEstadoLayoutForm();

            $grelhaForm.ajax.SetEstadoLayoutForm(F3MFormulariosRefrescaEstadoForm(_gridID, ELF));

            $grelhaForm.ajax.AtivaDesativaBotoesCRUD(_grid);

            var splitterElem = $('#' + constSplitterID);
            var paneFormElem = splitterElem.find('#' + constPaneFormID);

            $grelhaForm.ajax.Acoes(_grid, '');

            if (!splitterPaneColapsado(paneFormElem)) {

                if (_valorID == 0) {

                    GrelhaFormMostraEscondeBotoesAcoes(true, true, _grid);
                }
                else {
                    GrelhaFormMostraEscondeBotoesAcoes(false, false, _grid);
                }
            }
            else {
                GrelhaFormMostraEscondeBotoesAcoes(false, false, _grid);
            }

            //}
            $grelhaForm.ajax.BloquearAcoesGrelhaForm(_grid);
        }
        else {
            SplitterAtualizaTexto('');
            //todo maf - bloquear botoes duplicar e remover
        }
        GrelhaUtilsAtribuiDuploClique(_grid);

        //remove label "Detalhe de"
        $('.mostra-detalhe-lista').remove();
    };

    /* @description funcao que retorna a altura extra para a grid (PDC & MAF)*/
    self.GridFormRetornaAlturaExtra = function () {
        return -52;
    }

    /* @description funcao que retorna a instancia da grelha do formulario */
    self.RetornaGridInstance = function () {
        return $('.' + constsTiposComponentes.grelhaForm).data('kendoGrid');
    };

    //------------------------------------ F U N C O E S     E S P E C I F I C A S
    /* @description funcao especifica que ativa ou desativa botões */
    self.AtivaDesativaBotoesAcoesEsp = function (inGridID, inBloqueia) {
        if (inBloqueia) {
            KendoDesativaElementos(['data', 'btnNovaConsulta', 'btnRefresh']);
        }
        else {
            KendoAtivaElementos(['data', 'btnNovaConsulta', 'btnRefresh']);
        }

        //maf - ver +
        $('#F3MGrelhaFormExamesBtRefresh').css('display', 'none');
    };

    /* @description funcao */
    self.ObjFiltroEspecifico = function (inElemBtID, inObjetoFiltro) {
        var gridDS = $('.' + base.constantes.tiposComponentes.grelhaForm).data('kendoGrid').dataItem($('.' + base.constantes.tiposComponentes.grelhaForm).data('kendoGrid').select());

        if (UtilsVerificaObjetoNotNullUndefinedVazio(gridDS)) {
            inObjetoFiltro['IDAgendamento'] = gridDS['IDAgendamento'];
        }

        return inObjetoFiltro;
    }

    /* @description funcao especifica de quando o splitter e colapsado*/
    self.SplitterCollapseEsp = function (inEvt) {
        var _grid = self.RetornaGridInstance();

        if (inEvt.pane.id === constPaneFormID) {
            GrelhaFormMostraEscondeBotoesAcoes(false, false, _grid);
        }
    };

    //------------------------------------ F U N C O E S     A U X L I A R E S
    /* @description funcao */
    self.TrataBotoes = function () {
        //
        var _strAttrDisabledImprimir = (self.RetornaAcessoImprimir()) ? '' : 'disabled';

        //remove buttons
        $('#F3MGrelhaFormExamesBtRepoe').remove();
        $('#F3MGrelhaFormExamesBtRefresh').css('display', 'none');
        $('#F3MGrelhaFormExamesBtPrint').remove();
        $('#F3MGrelhaFormExamesBtPrintMapa').remove();

        //set print buttons
        var str = '';
        str += '  <div class="dropdown grelha-bts permImpr btsCRUD">';
        str += '     <a class="dropdown-toggle f3mlink" type="button" id="printdropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">';
        str += '         <span class="fm f3icon-print"></span>';
        str += '         <span class="fm f3icon-chevron-down-2"></span>';
        str += '     </a>';
        str += '     <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="">';
        str += '        <a ' + _strAttrDisabledImprimir + ' href="#" class="dropdown-item CLSF3MImprimir" id="receita"><span class="fm f3icon-file-text-o mr-1"></span>' + resources['Receita'] + '</a>';
        str += '        <a ' + _strAttrDisabledImprimir + ' href="#" class="dropdown-item CLSF3MImprimir" id="relatorio"><span class="fm f3icon-ficha mr-1"></span>' + resources['Relatorio'] + '</a>';
        str += '     </ul>';
        str += '  </div>';

        //prepend print buttons
        $('#F3MGrelhaFormExamesBts').prepend(str);

        //bound imprimir click
        $('.CLSF3MImprimir').on('click', function (e) {
            //check if print access = true
            if (self.RetornaAcessoImprimir()) {
                //print
                self.Imprimir(e.target.id);
            }
            else {
                //set message
                UtilsNotifica(base.constantes.tpalerta['i'], resources['SemAcessoImprimir']); //Não tem permissão para imprimir
            }
        });
    };

    /* @description funcao */
    self.RetornaAcessoImprimir = function () {
        return ($('#TemAcessoImprimir').val() === 'True');
    };

    return parent;

}($examesindex || {}, jQuery));

//document ready
var ExamesIndexInit = $examesindex.ajax.Init;
//buttons
var ExamesIndexAbreTabMarcacoes = $examesindex.ajax.AbreTabMarcacoes;
//grid
var ExamesIndexGridEnviaParams = $examesindex.ajax.GridEnviaParams;
var ExamesIndexGridFormChange = $examesindex.ajax.GridChange;
var GravaRetornaObjFiltroEsp = $examesindex.ajax.GridEnviaParams;
var GridFormRetornaAlturaExtra = $examesindex.ajax.GridFormRetornaAlturaExtra;
//actions esp
var ObjFiltroEspecificoAction = $examesindex.ajax.ObjFiltroEspecifico;
var AtivaDesativaBotoesAcoesEsp = $examesindex.ajax.AtivaDesativaBotoesAcoesEsp;
var SplitterCollapseEsp = $examesindex.ajax.SplitterCollapseEsp;
var AcoesCancelarEspecifico = $examesindex.ajax.AcoesCancelarEspecifico;
var AcoesAdicionarEspecifico = $examesindex.ajax.AcoesAdicionarEspecifico;

$(document).ready(function (e) {
    //init on document ready
    ExamesIndexInit();
});