"use strict";
var $docsvendasimprimir = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};
    var constElemOpcao = 'IDOpcao';
    var constElemTxtRazao = 'txtRazao';
    var clsConfirma = '.Confirma';
    var constTipoCompo = base.constantes.tiposComponentes;
    var cssClassGF = constTipoCompo.grelhaForm;
    var RazaoImprimirModel = new Object(); //modelo para a impressão de 2ª Via ou original

    /* funcao quando é aberto o pop up de escolher 2ª via ou original (bind events) */
    self.Open = function (e) {
        self.ChangeOpcao();
        $('#' + constElemOpcao).change(function (e) {
            self.ChangeOpcao();
            return false;
        });
        $('#' + constElemTxtRazao).bind('keyup input', function (e) {
            if ($(e.currentTarget).val() != '') {
                $(clsConfirma).removeClass('disabled');
            }
            else {
                $(clsConfirma).addClass('disabled');
            }
            return false;
        });
        $('#' + constElemTxtRazao).on('change', function (e) {
            RazaoImprimirModel['Razao'] = $('#' + constElemTxtRazao).val();
            return false;
        });
    };
    /* funcao quando e alterada a opcao - 2ª via ou original */
    self.ChangeOpcao = function () {
        var opcaoSelecionada = $('#IDOpcao option:selected').attr('id');
        switch (opcaoSelecionada) {
            case '2via':
                $('#' + constElemTxtRazao).val('');
                $('#divRazao').hide();
                $(clsConfirma).removeClass('disabled');
                break;
            case 'original':
                $('#' + constElemTxtRazao).val('');
                $('#divRazao').show();
                $(clsConfirma).addClass('disabled');
                break;
        }
        RazaoImprimirModel['Opcao'] = opcaoSelecionada;
        RazaoImprimirModel['Razao'] = '';
    };
    /* funcao imprimir */
    self.Imprimir = function (inGrid, inModeloLinha, inEntidade, inController, objParam) {
        objParam = objParam || $svcImprimir.ajax.PreecheObjImpParametros(inEntidade, inModeloLinha);

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(inEntidade)) {
            if (inGrid !== undefined) {
                if (inGrid.select().length > 0) {
                    inEntidade = inGrid.element[0].id.replace(cssClassGF, '');
                }
            }
        }
        inController = UtilsVerificaObjetoNotNullUndefinedVazio(inController) ? inController : inEntidade;
        var urlVerificaSegundaVia = rootDir + inController + '/DocumentoSegundaVia';
        var objdata = { IDDocumento: inModeloLinha.ID };
        UtilsChamadaAjax(urlVerificaSegundaVia, true, JSON.stringify(objdata), function (res) {
            if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                if (res == true) {
                    //POP UP!
                    self.ChamaRazaoImprimir(inModeloLinha, inEntidade, "Utilitarios/RazaoImprimir", null,  objParam);
                }
                else {
                    self.Print(inModeloLinha, inEntidade, objParam);
                }
            }
            else {
                UtilsAlerta(base.constantes.tpalerta.error, res.Erros[0].Mensagem);
            }
        }, function (e) { throw e; }, 1, true);
    };

    /*@description  */
    self.ChamaRazaoImprimir = function (inModelo, inEntidade, inView, inUrlAcao, objParam) {
        var urlAux = rootDir + (inView || "Utilitarios/RazaoImprimir");
        UtilsChamadaAjax(urlAux, true, ({ 'opcao': 'imprimir' }),
            function (res) {
                UtilsAlerta(base.constantes.tpalerta.question, res, function () {
                    RazaoImprimirModel['Entidade'] = inEntidade
                    RazaoImprimirModel['RegistoID'] = inModelo.ID;
                    UtilsChamadaAjax((inUrlAcao ? rootDir + inUrlAcao : urlAux + '/Adiciona'), true, JSON.stringify({ inModelo: RazaoImprimirModel }), function (res) {
                        if (!UtilsVerificaObjetoNotNullUndefined(res.Erros)) {
                            self.Print(inModelo, inEntidade, objParam);
                        }
                        else {
                            UtilsAlerta(base.constantes.tpalerta.error, res.Erros[0].Mensagem);
                        }
                    }, function (e) { throw e; }, 1, true);
                }, function () { }, null, null, null, null, resources['Impressao'], true, null, null, resources['Imprimir'], resources['Cancelar'], true, self.Open);
            }, function (fv) { }, 1, true, null, null, 'html', 'GET');
    };
    /*@description  */
    self.Print = function (documentSale, entity, objParam) {
        self.GetIdNCA(documentSale['ID'], function (documenSaleNca) {
            if (documenSaleNca && documenSaleNca !== 0) {
                self.PrintWithNca(documentSale, entity, documenSaleNca, objParam);
            }
            else {
                ImprimirAbreJanela(objParam, null);
            }
        });
    }
    /*@description  */
    self.GetIdNCA = function (documentSaleId, successCallbackFn) {
        var url = rootDir + "Documentos/DocumentosVendas/GetDocumentSaleNcaId";
        var params = { documentSaleId: documentSaleId };
        $.post(url, params, (documentSaleId) => successCallbackFn(documentSaleId));
    };
    /*@description  */
    self.PrintWithNca = function (modelo, entidade, documenSaleNca, objParam) {
        var objParams = [];
        objParams.push(objParam);
        var modelNca = $.extend(true, [], modelo);
        modelNca['ID'] = documenSaleNca
        objParams.push($svcImprimir.ajax.PreecheObjImpParametros(entidade, modelNca));
        $svcImprimir.ajax.AbreJanela(objParams, null, '/Reporting/ReportsBase/MultiPrint')
    };

    return parent;

}($docsvendasimprimir || {}, jQuery));

var AcoesImprimirEspecifico = $docsvendasimprimir.ajax.Imprimir;
var AcoesImprimirChamaRazaoImprimir = $docsvendasimprimir.ajax.ChamaRazaoImprimir;