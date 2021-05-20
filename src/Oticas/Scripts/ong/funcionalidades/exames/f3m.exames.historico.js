'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $examesladodireito = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes datas
    var constPreviousDate = 'btnPreviousDate', constNextDate = 'btnNextDate', constDataExame = 'IDDatasExames', constEditarExame = 'btnEditExame';
    //constantes accordions
    var constHistoricoCliente = 'historicocliente', constMainContent = 'accordions', constExpandAccordions = 'expandAccordions', constCollapseAccordions = 'collapseAccordions';
     
    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        //click show previous exame history
        $('#' + constPreviousDate).off().on('click', function (e) {
            self.PreviousDate(e);
        });
        //click show next exame history
        $('#' + constNextDate).off().on('click', function (e) {
            self.NextDate(e);
        });
        //change combo data exame
        $('#' + constDataExame).off().on('change', function (e) {
            self.ChangeExameDate(e);
        });
        //button open and edit exame
        $('#' + constEditarExame).off().on('click', function (e) {
            //self.EditExame(e);
        });
        //click to exapand all accordions
        $('#' + constExpandAccordions).off().on('click', function (e) {
            self.ExpandOrCollapseAccordions(true);
        });
        //click to  all accordions
        $('#' + constCollapseAccordions).off().on('click', function (e) {
            self.ExpandOrCollapseAccordions(false);
        });

        $('#btnVerConsulta').on('click', self.OpenConsulta);
    };

    //------------------------------------ E X A M E S     H I S T O R Y
    /* @description funcao que carrega o historico do exame anterior */
    self.PreviousDate = function (e) {
        //get component
        var _dtExame = document.getElementById(constDataExame);
        //get number of items
        var _dtExameLength = _dtExame.options.length - 1;
        //get selected index
        var _currentIndex = _dtExame.selectedIndex;
        //loop it or next
        if (_currentIndex === 0) {
            _dtExame.selectedIndex = _dtExameLength;
        }
        else {
            _dtExame.selectedIndex = _currentIndex - 1;
        }
        //get history from exame
        self.RetornaHistoricoExame();
    };

    /* @description funcao que carrega o historico do exame seguinte */
    self.NextDate = function (e) {
        //get component
        var _dtExame = document.getElementById(constDataExame);
        //get number of items
        var _dtExameLength = _dtExame.options.length - 1;
        //get selected index
        var _currentIndex = _dtExame.selectedIndex;
        //loop it or next
        if (_currentIndex === _dtExameLength) {
            _dtExame.selectedIndex = 0;
        }
        else {
            _dtExame.selectedIndex = _currentIndex + 1;
        }
        //get history from exame
        self.RetornaHistoricoExame();
    };

    /* @description funcao change da date de exame que carrega o historico do exame selecionado */
    self.ChangeExameDate = function (e) {
        //get history from exame
        self.RetornaHistoricoExame();
    };

    /* @description funcao que retorna o historico (html -> accordions) de consultas do cliente*/
    self.RetornaHistoricoExame = function (e) {
        //get url
        var _url = rootDir + 'Exames/Exames/RetornaHistoricoExame';
        //get selected exame
        var _IDDataExameSelecionado = self.RetornaIDDataExameSelecionado();
        //get params (IDExame)
        var _data = { IDExame: _IDDataExameSelecionado };
        //get history from exame
        UtilsChamadaAjax(_url, true, _data,
            function (res) {
                //set html to main content history div
                $('#' + constMainContent).html(res);
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };

    /* @description funcao que retorna */
    self.RetornaLadoDireitoCompleto = function (inIDCliente) {
        //get url
        var _url = rootDir + 'Exames/Exames/RetornaLadoDireitoCompleto';
        //get params (IDCliente)
        var _currentTemplateCode = $('#CodigoTemplate').val();
        var _data = { IDCliente: inIDCliente, CodigoTemplate: _currentTemplateCode};
        //get history from exame
        UtilsChamadaAjax(_url, true, _data,
            function (res) {
                //set html to main content history div
                $('#' + constHistoricoCliente).html(res);
                //set exames number
                var _numeroExames = $('#historicocliente').find('.numberOfExames').text();
                $('.numberOfExames').text(_numeroExames);
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };

    //------------------------------------ A C C O R D I O N S
    /* @description funcao que expande ou colapse os accordions */
    self.ExpandOrCollapseAccordions = function (inExpande) {
        //get all accordions
        var accordions = $('#accordions > .ClsF3MInputAccordion').find('.clsF3MCollapse.collapse');
        //expand or collapse
        (inExpande) ? accordions.collapse('show') : accordions.collapse('hide');
    };

    //------------------------------------ F U N C O E S     A U X L I A R E S
    /* @description funcao que retorna o id data do exame selecionado */
    self.RetornaIDDataExameSelecionado = function () {
        return parseInt($('#' + constDataExame + ' option:selected').attr('id'));
    };

    self.OpenConsulta = function () {
        var IDDataExameSelecionado = parseInt($('#' + constDataExame + ' option:selected').attr('id'));
        var DataSelecionada = $('#' + constDataExame + ' option:selected').val();

        let url = 'Exames/Exames?IDDrillDown=' + IDDataExameSelecionado + '&DataMarcacao=' + DataSelecionada
        let tabnome = resources['Consultorio'], tabicon = 'f3icon-exames';
        UtilsAbreTab(url, tabnome, tabicon, null, null, null);
    }

    return parent;

}($examesladodireito || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var ExamesLadoDireitoInit = $examesladodireito.ajax.Init;
//
var ExamesLadoDireitoRetornaIDDataExameSelecionado = $examesladodireito.ajax.RetornaIDDataExameSelecionado;
//actions
var ExamesLadoDireitoRetornaHistoricoExame = $examesladodireito.ajax.RetornaHistoricoExame;
var ExamesLadoDireitoRetornaLadoDireitoCompleto = $examesladodireito.ajax.RetornaLadoDireitoCompleto;

$(document).ready(function (e) {
    ExamesLadoDireitoInit();
});