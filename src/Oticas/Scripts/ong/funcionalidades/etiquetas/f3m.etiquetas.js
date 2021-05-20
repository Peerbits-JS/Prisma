'use strict';

var $etiquetas = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    const IDHDSN = 'hdsnArtigos';
    const hdsnColumns = { LinhaSelecionada: 'Selecionar', IDArtigo: 'IDArtigo', CodigoArtigo: 'CodigoArtigo', DescriaoArtigo: 'DescricaoArtigo', Quantidade: 'Quantidade', ValorComIVA: 'ValorComIva' };

    const modelos = { A4_2_Colunas: 'Etiquetas_A4_2_Colunas', A4_6_Colunas: 'Etiquetas_A4_6_Colunas', A4_5_Colunas: 'Etiquetas_A4_5_Colunas', Rolo: 'Etiquetas_Rolo' };

    const btnImprimir = 'EtiquetasBtPrintMapa';
    const campoEntidade = '#Entidade';
    const campoLinha = '#Linha';
    const campoOpcaoA4 = '#OpcaoA4';
    const campoColuna = '#Coluna';
    const campoImprimir = '#BtImprimir';

    /*@description Init function */
    self.Init = function () {
        var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;

        //imprimir
        $(campoImprimir).on('click', (e) => {
            e.preventDefault();

            self.Imprimir();

            e.stopImmediatePropagation();
            return false;
        });
        //change campos linhas e colunas (default 1)
        $(campoLinha + ',' + campoColuna).on('change', (e) => {
            if (!UtilsVerificaObjetoNotNullUndefinedVazio(e.currentTarget.value)) {
                e.currentTarget.value = 1;
            }
        });

        //change campo opcao
        $(campoEntidade).on('change', (e) => self.ChangeOpcao(e));

        //quando se faz resize à janela das etiquetas remove a class formul-group
        function removeFormulGroup() {
            if ($(window).width() < 796) {
                $(campoOpcaoA4).removeClass('formul-group');
            } else {
                $(campoOpcaoA4).addClass('formul-group');
            }
        }
        removeFormulGroup();
        $(window).resize(function () {
            removeFormulGroup();
        });

        FrontendGrelhaLoading();
        KendoLoading(window.parent.$('#' + janelaMenuLateral), false)

        $('#' + btnImprimir).unbind('click').click(e => {
            var opcaoSelecionada = $('#Entidade option:selected').attr('id');
            $gridutils.ajax.CliqueBotoes(e, opcaoSelecionada);
        });

        $('#lstDropPrintMapa').unbind('click').click(e => {
            let btnId = e.target.id;
            let btnType = e.target.type;

            if (btnType === 'radio' || btnId.indexOf('edita') > -1) {
                var opcaoSelecionada = $('#Entidade option:selected').attr('id');
                $gridutils.ajax.CliqueBotoes(e, opcaoSelecionada);
            } else {
                self.Imprimir(btnId.replace('Imprimir', ''));
            }
        });

    };

    /*@description Funcao quando é alterada a opcao (A4 ou rolo) esconde ou mostra os campos coluna / linha*/
    self.ChangeOpcao = function (inEvt) {
        switch (self.RetornaEntidadeSelecionada()) {
            case modelos.A4_2_Colunas:
                self.ChangeOpcaoTo_A4_2_Colunas();
                break;

            case modelos.A4_5_Colunas:
                self.ChangeOpcaoTo_A4_5_Colunas();
                break;

            case modelos.A4_6_Colunas:
                self.ChangeOpcaoTo_A4_6_Colunas();
                break;

            case modelos.Rolo:
                self.ChangeOpcaoTo_A4_Rolo();    
                break;
        }
    };

/*@description Funcao quando é alterada a opcao para A4 2 Colunas */
    self.ChangeOpcaoTo_A4_2_Colunas = () => {
        if (KendoRetornaElemento($(campoColuna)).value() > 2) {
            KendoRetornaElemento($(campoColuna)).value(1);
        }

        //KendoRetornaElemento($(campoLinha)).max(28);
        KendoRetornaElemento($(campoColuna)).max(2);
        $(campoOpcaoA4).show();
    };

    /*@description Funcao quando é alterada a opcao para A4 5 Colunas */
    self.ChangeOpcaoTo_A4_5_Colunas = () => {
        //if (KendoRetornaElemento($(campoLinha)).value() > 16) {
        //    KendoRetornaElemento($(campoLinha)).value(1);
        //}
        if (KendoRetornaElemento($(campoColuna)).value() > 5) {
            KendoRetornaElemento($(campoColuna)).value(1);
        }

        //KendoRetornaElemento($(campoLinha)).max(16);
        KendoRetornaElemento($(campoColuna)).max(5);
        $(campoOpcaoA4).show();
    };

    /*@description Funcao quando é alterada a opcao para A4 6 Colunas */
    self.ChangeOpcaoTo_A4_6_Colunas = () => {
        //if (KendoRetornaElemento($(campoLinha)).value() > 25) {
        //    KendoRetornaElemento($(campoLinha)).value(1);
        //}

        //KendoRetornaElemento($(campoLinha)).max(25);
        KendoRetornaElemento($(campoColuna)).max(6);
        $(campoOpcaoA4).show();
    };

    /*@description Funcao quando é alterada a opcao para Rolo */
    self.ChangeOpcaoTo_A4_Rolo = () => {
        $(campoOpcaoA4).hide();
        KendoRetornaElemento($(campoLinha)).value(1);
        KendoRetornaElemento($(campoColuna)).value(1);
    }

    /*@description Funcao que vai imprimir as etiquetas (valida e imprime) */
    self.Imprimir = function (idMapaVista) {
        //verifica erros
        if ($('#' + IDHDSN).find('.input-errorHT').length) {
            return UtilsAlerta(base.constantes.tpalerta.error, resources['ExistemArtigosInvalidos']); //Existem artigos inválidos.
        }

        var _url = rootDir + 'Etiquetas/Etiquetas/CriaTemp';
        var _modelo = self.PreencheModelo();

        //verifica se exsite pelo menos uma linha para imprimir
        if (_modelo['EtiquetasArtigos'].length === 0) {
            return UtilsAlerta(base.constantes.tpalerta.error, resources['SelecionarUmArtigo']); // Tem que selecionar pelo menos um artigo.
        }

        //compress model
        _modelo = LZString.compressToUTF16(JSON.stringify(_modelo));

        UtilsChamadaAjax(_url, true, JSON.stringify({ inModeloStr: _modelo }),
            function (res) {
                if (!UtilsChamadaAjaxTemErros(res)) {
                    var _modelo1 = {};
                    _modelo1.ID = 1;
                    _modelo1.SQLQuery = "select * from " + res.tempTableName;

                    var _paramsEsp = [];
                    _paramsEsp.push(
                        { Name: 'TabelaTemp', Value: res.tempTableName, Type: 'System.String' },
                        { Name: 'IDMapasVistas', Value: idMapaVista || res.IDMapaVistaPorDefeito, Type: 'System.String' },
                        { Name: 'MapaSelecionado', Value: true, Type: 'System.String' }
                    );

                    //get params
                    var params = $svcImprimir.ajax.PreecheObjImpParametros(self.RetornaEntidadeSelecionada(), _modelo1, _paramsEsp);
                    //print
                    $svcImprimir.ajax.AbreJanela(params, null, null);
                }
            }, function () { return false; }, 1, true);
    };

    /*@description Funcao que preenche o modelo a enviar para criar a tabela temporária para imprimir */
    self.PreencheModelo = function () {
        var _modelo = {};
        _modelo['Entidade'] = $('#Entidade option:selected').attr('id');
        _modelo['Linha'] = KendoRetornaElemento($(campoLinha)).value();
        _modelo['Coluna'] = KendoRetornaElemento($(campoColuna)).value();
        _modelo['EtiquetasArtigos'] = $.grep($etiquetasartigos.ajax.RetornaHT().getSourceData(), (obj, i) => {
            return obj[hdsnColumns.LinhaSelecionada] && UtilsVerificaObjetoNotNullUndefinedVazio(obj['IDArtigo']);
        });

        return _modelo;
    };

/*@description Funcao que retorna a entidade selecionada */
    self.RetornaEntidadeSelecionada = () => $('#Entidade option:selected').attr('id');

    return parent;

}($etiquetas || {}, jQuery));

$(document).ready(() => $etiquetas.ajax.Init());