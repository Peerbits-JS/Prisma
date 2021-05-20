"use strict";

var $docsstockscontagemartigos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    //constantes base
    var constsBase = base.constantes;
    var constAlerta = base.constantes.tpalerta;
    var constError = constAlerta.error;
    var constSucess = constAlerta.s;

    //------------------------------------ D O C U M E N T     R E A D Y
    /* @description funcao document ready */
    self.Init = function () {
        $("#drag-and-drop-zone").dmUploader({
            maxFileSize: 100000000,
            onInit: function () { },
            onBeforeUpload: function (id) {
                $.danidemo.updateFileStatus(id, 'default', resources.importacao_carregar);
            },
            onNewFile: function (id, file) {
                $.danidemo.addFile('#demo-files', id, file);
            },
            onComplete: function (id) {
                if (!self.OnError) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(KendoRetornaElemento(window.parent.$('#janelaMenu')))) {
                        KendoRetornaElemento(window.parent.$('#janelaMenu')).close();
                    }
                }
                self.OnError = false;
            },
            onUploadProgress: function (id, percent) {
                var percentStr = percent + '%';
                $.danidemo.updateFileProgress(id, percentStr);
                $.danidemo.updateFileStatus(id, 'success', resources.importacao_importar);
            },
            onUploadSuccess: function (id, data) {
                self.UploaderSucesso(id, data);
                $('.clsCardAnexos').find('#demo-file' + id + ' [role=progressbar]').css({ 'background-color': 'green' });
            },
            onUploadError: function (id, message) {
                $.danidemo.updateFileStatus(id, constError, message);
                $('.clsCardAnexos').find('#demo-file' + id + ' [role=progressbar]').css({ 'background-color': 'rgba(255,0,0,0.50);' });
                // Mostra janela com erro
                UtilsAlertaStop(constError, message);
            },
            onFileTypeError: function (file) {
                var parts = file.name.split('.');
                var tipoF = parts[parts.length - 1];
                var erro = resources.erro_ficheiro_tipo.replace('{0}', tipoF);
                // Mostra janela com erro
                UtilsAlertaStop(constError, erro);
            },
            onFileSizeError: function (file) {
                var erro = resources.erro_ficheiro_tamanho_max.replace('{0}', '100MB');
                // Mostra janela com erro
                UtilsAlertaStop(constError, erro);
            },
            onFallbackMode: function (message) { }
        });

        $('#importar-artigos-contagem').click(function () {
            $("#ContagemUpload").trigger('click');
        });
    };

    self.IniciaUpload = function (t, n, i) {
        var urlNovo = window.location.pathname

        if (urlNovo.lastIndexOf("ImportarFicheiros") > 0) {
            urlNovo += "/Importa";
        }
        else {
            urlNovo = urlNovo.replace('/Importar', '') + '/Importa';
        }

        var reader = new FileReader();

        reader.onload = (function (theFile) {
            return function (e) {
                var FileName = n.queue[n.queuePos].name;
                var FileNameSplit = FileName.split('.');

                var filtro = $docsstockscontagemgrelha.ajax.PreencheFiltro();
                var data = filtro.DataDocumento.split("/")

                var ano = data[2]
                var mes = (data[1] - 1)
                var dia = data[0]

                filtro.DataDocumento = new Date(ano, mes, dia)
                delete filtro.InputsAlterados

                i.append("filter", JSON.stringify(filtro))
                i.append('FileUpload', n.queue[n.queuePos])

                t.ajax({
                    url: urlNovo,
                    type: n.settings.method,
                    dataType: n.settings.dataType,
                    data: i,
                    cache: false,
                    contentType: false,
                    processData: false,
                    forceSync: false,
                    xhr: function () {
                        var r = t.ajaxSettings.xhr();
                        if (r.upload) {
                            r.upload.addEventListener("progress", function (t) {
                                var r = 0;
                                var i = t.loaded || t.position;
                                var s = t.total || e.totalSize;
                                if (t.lengthComputable) {
                                    r = Math.ceil(i / s * 100);
                                }
                                n.settings.onUploadProgress.call(n.element, n.queuePos, r);
                            }, false);
                        }
                        return r;
                    },
                    success: function (e, t, r) {
                        n.settings.onUploadSuccess.call(n.element, n.queuePos, e);
                    },
                    error: function (e, t, r) {
                        n.settings.onUploadError.call(n.element, n.queuePos, r);
                    },
                    complete: function (e, t) {
                        n.processQueue();
                    }
                });
                e.stopImmediatePropagation();
            };
        })(n);
        reader.readAsDataURL(n.queue[n.queuePos]);
    };

    self.UploaderSucesso = function (id, result) {
        var erros = result.Errors;
        if (UtilsVerificaObjetoNotNullUndefined(erros) && typeof erros === "object") {
            self.OnError = true;
            $.danidemo.updateFileStatus(id, constError, "Erro: " + erros);
            $.danidemo.updateFileProgress(id, '0%');
            UtilsNotifica(constError, erros[0].Mensagem);
        } else if (UtilsVerificaObjetoNotNullUndefined(erros) && typeof erros === "string") {
            self.OnError = true;
            $.danidemo.updateFileStatus(id, constError, "Erro: " + erros);
            $.danidemo.updateFileProgress(id, '0%');
            UtilsNotifica(constError, erros);
        }
        else {
            self.OnError = false;
            $.danidemo.updateFileStatus(id, constSucess, resources.importacao_sucesso);
            $.danidemo.updateFileProgress(id, '100%');

            var artigos = result.Artigos;
            var quantidadeNaoImportados = result.QuantidadeDeNaoImportados

            if (quantidadeNaoImportados > 0) {
                UtilsNotifica(constAlerta.warn, resources.contagem_stock_arquivos_artigos_nao_importados.replace("<qtd>", quantidadeNaoImportados));
            } else {
                UtilsNotifica(constAlerta.s, resources.importacao_sucesso);
            }

            DocsStocksContagemGrelhaConcatenaToData(artigos);
        }
    };

    return parent;

}($docsstockscontagemartigos || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
//this
var DocsStocksContagemArtigosInit = $docsstockscontagemartigos.ajax.Init;
var ImportacaoInitUpload = $docsstockscontagemartigos.ajax.IniciaUpload;

$(document).ready(function (e) {
    DocsStocksContagemArtigosInit();
});

