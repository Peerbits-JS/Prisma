'use strict';
/// <reference path="../base/f3m.base.constantes.js" />
/// <reference path="../base/f3m.base.utils.js" />

var $examesdetalhe = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
    }

    //------------------------------------ A C O E S     E S P
    /*@description Funcao especifica que preenche e retorna o modelo */
    self.RetornaModeloEspecifico = function (inModelo) {
        //TODO PDC - Funcao que envia o modelo para o servidor
        //copy without reference model
        var _modelCopy = $.extend(true, _modelCopy, inModelo);
        //reset byref model
        inModelo = {};
        //set model  copy to  inModelo['ExamesModel'] prop
        inModelo['ExamesModel'] = _modelCopy;
        //set inModelo['Exames] to new array
        inModelo['ExamesFotos'] = [];
        //get all dom fotos
        var _fotos = $('.clsF3MFotoGridInput');
        for (var i = 0; i < _fotos.length; i++) {
            var _item = _fotos[i];

            if (UtilsVerificaObjetoNotNullUndefinedVazio(_item.getAttribute(['value']))) {
                //set new objct
                var _newObj = {};
                //set props
                _newObj['ID'] = _item.getAttribute(['data-f3m-bd-id']);
                _newObj['AcaoFormulario'] = _item.getAttribute(['data-f3m-acao-form']);
                _newObj['Funcionalidade'] = _item.getAttribute(['data-f3m-funcionalidade']);
                _newObj['Foto'] = _item.getAttribute(['value']);
                _newObj['FotoCaminho'] = _item.getAttribute(['data-f3m-foto-cam']);
                _newObj['FotoCaminhoCompleto'] = _item.getAttribute(['data-f3m-foto-cam']) + _item.getAttribute(['value']);
                _newObj['FotoAnterior'] = _item.getAttribute(['data-f3m-foto-anterior']);
                _newObj['FotoCaminhoAnterior'] =  _item.getAttribute(['data-f3m-foto-cam-anterior']);
                _newObj['FotoCaminhoAnteriorCompleto'] =  _item.getAttribute(['data-f3m-cam-ant-completo']);
                //push to inModelo['Exames] array
                inModelo['ExamesFotos'].push(_newObj);
            }
        }

        //var t = '{"ID":"0","AcaoFormulario":"0","Funcionalidade":"Exames","Foto":"N1.jpg","FotoCaminho":"/Prisma/Temp/","FotoCaminhoCompleto":"/Prisma/Temp/N1.jpg","FotoAnterior":"","FotoCaminhoAnterior":"","FotoCaminhoAnteriorCompleto":""}';
        //inModelo['ExamesFotos'] = []
        //inModelo['ExamesFotos'][0] = JSON.parse(t);

        //return model
        return inModelo;
    };

    return parent;

}($examesdetalhe || {}, jQuery));

//document ready
var ExamesDetalheInit = $examesdetalhe.ajax.Init;
//actions esp
var AcoesRetornaModeloEspecifico = $examesdetalhe.ajax.RetornaModeloEspecifico;

$(document).ready(function (e) {
    ExamesDetalheInit();
});