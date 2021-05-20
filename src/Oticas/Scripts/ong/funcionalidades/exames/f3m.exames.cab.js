'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $examescab = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    var elemMainContent = '#main-content';
    var constCabSemTexto = '---';
    var campoDataExame = 'DataExame', campoIDMedTecnico = 'IDMedicoTecnico', campoIDEspecialidade = 'IDEspecialidade';
    //constantes labels do cabecalho
    var campoIdade = 'CABIdade', campoDataHora = 'CABDataExame', campoTipo = 'CABTipoConsulta', campoEsp = 'CABEspecialidade', campoMedico = 'CABMedico';
    //hidden fields
    var hdfIDTemplate = 'IDTemplate', hdfCodigoTemplate = 'CodigoTemplate';

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //change data exame input
        $('#' + campoDataExame).on('change', function (e) {
            self.DataExameChange(e);
        });
    };

    //------------------------------------ C L I E N T E
    /* @description funcao change do cliente */
    self.ClienteChange = function (e) {
        var _currentValue = e.value();

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_currentValue)) {
            var _idade = e.dataItem()['Idade'];
            //from lookup
            if (!UtilsVerificaObjetoNotNullUndefined(_idade) && UtilsVerificaObjetoNotNullUndefined(e.dataItem()['DataNascimento'])) {
                _idade = UtilsCalculaIdade(e.dataItem()['DataNascimento']);
            }

            if (UtilsVerificaObjetoNotNullUndefinedVazio(_idade) && _idade !== 0) {
                //set hidden and span text
                $('#' + campoIdade).val(_idade);
                $('#F3MSpan_' + campoIdade).text(_idade);
            }
            else {
                //set hidden and span text
                $('#' + campoIdade).val(constCabSemTexto);
                $('#F3MSpan_' + campoIdade).text(constCabSemTexto);
            }
        }
        else {
            //set hidden and span text
            $('#' + campoIdade).val(constCabSemTexto);
            $('#F3MSpan_' + campoIdade).text(constCabSemTexto);
        }

        //get lado direito (history from cliente)
        ExamesLadoDireitoRetornaLadoDireitoCompleto(_currentValue);
    };

    //------------------------------------ D A T A     E X A M E
    /* @description funcao change da data do exame */
    self.DataExameChange = function (e) {
        $('#' + campoDataHora).val(e.target.value);
        $('#F3MSpan_' + campoDataHora).text(e.target.value);
    };

    //------------------------------------ T E M P L A T E
    /* @description funcao change do tipo de exame (carrega o template) */
    self.TiposExameChange = function (e) {
        var _url = rootDir + "Exames/Exames/RetornaViewTemplateByIDTemplate";
        //get current id
        var _currentID = UtilsVerificaObjetoNotNullUndefinedVazio(e.dataItem()) ? e.dataItem()['IDTemplate'] : 0;
        _currentID = UtilsVerificaObjetoNotNullUndefinedVazio(_currentID) ? _currentID : 0;
        //params to controller
        var _data = { IDTemplate: _currentID };

        UtilsChamadaAjax(_url, true, _data,
            function (res) {
                if (UtilsVerificaObjetoNotNullUndefined(res)) {
                    //set to main content
                    $(elemMainContent).html(res);

                    //set hidden and span text or reset
                    if (_currentID !== 0) {
                        $('#' + campoTipo).val(e.dataItem()['Descricao']);
                        $('#F3MSpan_' + campoTipo).text(e.dataItem()['Descricao']);
                        //set template
                        $('#' + hdfIDTemplate).val(e.dataItem()['IDTemplate']);
                        $('#' + hdfCodigoTemplate).val(e.dataItem()['CodigoTemplate']);

                        //
                        if (ExamesLadoDireitoRetornaIDDataExameSelecionado() === 0) {
                            ExamesLadoDireitoRetornaLadoDireitoCompleto(0);
                        }

                    }
                    else {
                        //set hidden and span text
                        $('#' + campoTipo).val(constCabSemTexto);
                        $('#F3MSpan_' + campoTipo).text(constCabSemTexto);
                        $('#' + hdfIDTemplate).val(0);
                        $('#' + hdfCodigoTemplate).val('CONS');
                    }
                }
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };

    //------------------------------------ E S P E C I A L I D A D E
    /* @description funcao envia params da especialidade (med tec) */
    self.EspecialidadeEnviaParams = function (inObjetoFiltro) {
        var elemAux = $('#' + campoIDMedTecnico);
        var elem = (elemAux.length) ? elemAux : window.parent.$('#' + campoIDMedTecnico);

        GrelhaUtilsPreencheObjetoFiltro(inObjetoFiltro, elem, true, campoIDMedTecnico);

        return inObjetoFiltro;
    };

    /* @description funcao change da especialidade */
    self.EspecialidadeChange = function (e) {
        var _currentValue = e.value();

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_currentValue)) {
            $('#' + campoEsp).val(e.dataItem()['Descricao']);
            $('#F3MSpan_' + campoEsp).text(e.dataItem()['Descricao']);
        }
        else {
            $('#' + campoEsp).val(constCabSemTexto);
            $('#F3MSpan_' + campoEsp).text(constCabSemTexto);
        }
    };

    //------------------------------------ M E D     T E C N I C O
    /* @description funcao  change do lookup medicotecnico */
    self.MedicoTecnicoChange = function (e) {
        var _currentValue = e.value();
        var _kendoElemEpecialidade = KendoRetornaElemento($('#' + campoIDEspecialidade))
        _kendoElemEpecialidade.text('');

        if (UtilsVerificaObjetoNotNullUndefinedVazio(_currentValue)) {
            //set hidden and span text
            $('#' + campoMedico).val(e.dataItem()['Nome']);
            $('#F3MSpan_' + campoMedico).text(e.dataItem()['Nome']);

            _kendoElemEpecialidade.dataSource.read().then(function () {
                var _dsEspecialidade = _kendoElemEpecialidade.dataSource.data();
                    
                if (_dsEspecialidade.length) {
                    _kendoElemEpecialidade.value(_dsEspecialidade[0]['ID']);

                    //set hidden and span text
                    $('#' + campoEsp).val(_dsEspecialidade[0]['Descricao']);
                    $('#F3MSpan_' + campoEsp).text(_dsEspecialidade[0]['Descricao']);
                }
                else {
                    //set hidden and span text
                    $('#' + campoEsp).val(constCabSemTexto);
                    $('#F3MSpan_' + campoEsp).text(constCabSemTexto);
                }

                KendoDesativaElemento(campoIDEspecialidade, false);
                KendoColocaElementoObrigatorio($('#' + campoIDEspecialidade), true);
            });
        }
        else {
            _kendoElemEpecialidade.value('');
            KendoDesativaElemento(campoIDEspecialidade, true);

            //set hidden and span text
            $('#' + campoMedico).val(constCabSemTexto);
            $('#F3MSpan_' + campoMedico).text(constCabSemTexto);
            //set hidden and span text
            $('#' + campoEsp).val(constCabSemTexto);
            $('#F3MSpan_' + campoEsp).text(constCabSemTexto);
        }
    };

    //------------------------------------ F U N C O E S     A U  X I L I A R E S

    return parent;

}($examescab || {}, jQuery));

//document ready
var ExamesCabInit = $examescab.ajax.Init;
//cliente
var ExamesCabClienteChange = $examescab.ajax.ClienteChange;
//especialidade
var ExamesCabEspecialidadeEnviaParams = $examescab.ajax.EspecialidadeEnviaParams;
var ExamesCabEspecialidadeChange = $examescab.ajax.EspecialidadeChange;
//medico tecnico
var ExamesCabMedicoTecnicoChange = $examescab.ajax.MedicoTecnicoChange;
//template
var ExamesCabTiposExameChange = $examescab.ajax.TiposExameChange;

//doc ready
$(document).ready(function (e) {
    $('#spanSemRegistosForm').css('display', 'none');
    $('#btnAddRegisto').css('display', 'none');
    ExamesCabInit();
});

//loading bar
//$(document).ajaxSend(function (inEvent, jqxhr, inSettings) {
//    var requestsBarLoding = ['RetornaViewTemplateByIDTemplate'];
//    KendoBarLoading(null, inSettings, requestsBarLoding);
//}).ajaxStop(function () {
//    var elem = $('#iframeBody');
//    KendoLoading(elem, false, true);
//});