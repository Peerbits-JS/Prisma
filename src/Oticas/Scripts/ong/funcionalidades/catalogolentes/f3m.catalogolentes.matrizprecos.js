"use strict";
var $catalogolentesmatrizprecos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};


    var modeloMatrizPrecoOriginal = [];

    var diametroDeBackup = null;
    var diametroAteBackup = null;
    var raioBackup = null;


    self.Init = function () {
        ConfiguraJanelaMatrizPrecos();

        ApresentaGrelhaValoresPotencia('grelhaValoresPotenciaEsferica');
        ApresentaGrelhaValoresPotencia('grelhaValoresPotenciaCilindrica');

        $('#txtDiametroDe, #txtDiametroAte, #txtRaioCurvatura').on('change', () => {
            if (!$('#btnGuardarAlteracoes').hasClass('disabled')) {
                UtilsConfirma(
                    base.constantes.tpalerta.question,
                    resources.confirmacao_altera_parametros_matriz_precos,
                    AlteraParametrosMatriz,
                    CancelaAlteraParametrosMatriz
                );
            } else {
                AlteraParametrosMatriz();
            }
        });

        $('#btnGuardarAlteracoes').on('click', () => {
            if (VerificaTodosIntervalosPotenciaUtilizados()) {
                GuardaAlteracoesMatrizPrecos();
            } else {
                UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_guardar_matriz_precos, GuardaAlteracoesMatrizPrecos);
            }
        });

        $('#btnCancelarAlteracoes').on('click', () =>
            UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_cancelar_alteracoes, CancelarAlteracoesMatrizPrecos)
        );

        $('#btnApagar').on('click', () =>
            UtilsConfirma(base.constantes.tpalerta.question, resources.confirmacao_remover_matriz_precos, RemoveMatrizPrecos)
        );

        $('#btnAtualizarValoresPotencia').on('click', AtualizaValoresPotencia);
    };

    function SaoLentesContacto() {
        let janelaMatrizPrecos = window.parent.$('#' + base.constantes.janelasPopupIDs.Menu).data('kendoWindow');
        let lentesContacto = false;

        if (janelaMatrizPrecos) {
            let dadosJanelaMatrisPrecos = janelaMatrizPrecos.options.data;

            if (dadosJanelaMatrisPrecos && dadosJanelaMatrisPrecos.LentesContacto) {
                lentesContacto = true;
            }
        }

        return lentesContacto;
    }

    function ConfiguraJanelaMatrizPrecos() {
        let lentesContacto = SaoLentesContacto();

        if (lentesContacto) {
            $('#AreaRaioCurvatura').removeClass('hidden');
            $('#MsgParamsMatrizLentesContacto').removeClass('hidden');
            AlteraParametrosMatriz();
        } else {
            $('#DescricaoTratamento').removeClass('hidden');
            $('#MsgParamsMatrizLentesOftalmicas').removeClass('hidden');
        }
    }

    function AlteraParametrosMatriz() {
        LimpaJanelaErros();

        $('#btnAtualizarValoresPotencia').addClass('disabled');
        $('#btnGuardarAlteracoes').addClass('disabled');
        $('#btnCancelarAlteracoes').addClass('disabled');
        $('#btnApagar').addClass('disabled');

        let lentesContacto = SaoLentesContacto();

        if (lentesContacto) {
            $('#txtDiametroDe').val(14);
            $('#txtDiametroAte').val(14);
            $('#txtRaioCurvatura').val(8.6);
        };

        diametroDeBackup = $('#txtDiametroDe').val();
        diametroAteBackup = $('#txtDiametroAte').val();
        raioBackup = $('#txtRaioCurvatura').val();

        if (ValidaParametrosMatriz()) {
            KendoLoading($('#catalogos-lentes-matriz-precos'), true);
            KendoLoading($('#AreaColapseDireita'), true);

            let idModeloSelecionado = $('#IDModelo').val();
            let idTratamentoSelecionado = $('#IDTratamento').val();
            let diametroDe = $('#txtDiametroDe').val();
            let diametroAte = $('#txtDiametroAte').val();
            let raio = $('#txtRaioCurvatura').val();

            let urlValoresMatrizPrecos = '../CatalogosLentes/MatrizPrecosPorModeloTratamento?' +
                'idModelo=' + idModeloSelecionado +
                '&idTratamento=' + idTratamentoSelecionado +
                '&diametroDe=' + diametroDe +
                '&diametroAte=' + diametroAte +
                '&raio=' + raio;
            
            UtilsChamadaAjax(urlValoresMatrizPrecos, true, {},
                function (valoresPrecos) {
                    if (!valoresPrecos.Erros) {
                        if (ExistemPrecosDefinidosIntervalo(valoresPrecos) && !lentesContacto) {
                            LimpaDadosMatrizPrecos();
                            LimpaDadosGrelhasPotencia();

                            let linhaPreco = valoresPrecos[0];
                            let mensagem = `Já existem preços definidos para o intervalo pretendido (diâmetro de: ${linhaPreco.DiamDe}; diâmetro até: ${linhaPreco.DiamAte}).`;

                            UtilsAlerta(base.constantes.tpalerta.i, mensagem);
                        } else {
                            modeloMatrizPrecoOriginal = $.extend(true, [], valoresPrecos);
                            CarregaValoresMatrizPrecos(valoresPrecos);
                        }
                    }

                    KendoLoading($('#catalogos-lentes-matriz-precos'), false);
                    KendoLoading($('#AreaColapseDireita'), false);
                },
                function () {
                    KendoLoading($('#catalogos-lentes-matriz-precos'), false);
                    KendoLoading($('#AreaColapseDireita'), false);
                }, 1, true);
        } else {
            LimpaDadosMatrizPrecos();
            LimpaDadosGrelhasPotencia();

            ApresentaErrosParametrosMatriz();
        }
    }

    function ExistemPrecosDefinidosIntervalo(linhasPrecos) {
        let existemPrecosDefinidos = false;

        let valorDiametroDe = parseFloat($('#txtDiametroDe').val());
        let valorDiametroAte = parseFloat($('#txtDiametroAte').val());

        if (linhasPrecos.length > 0) {
            let linhaPreco = linhasPrecos[0];

            if (valorDiametroDe !== linhaPreco.DiamDe || valorDiametroAte !== linhaPreco.DiamAte) {
                existemPrecosDefinidos = true;
            }
        }

        return existemPrecosDefinidos;
    }

    function CancelaAlteraParametrosMatriz() {
        $('#txtDiametroDe').val(diametroDeBackup);
        $('#txtDiametroAte').val(diametroAteBackup);
        $('#txtRaioCurvatura').val(raioBackup);
    }

    function ValidaParametrosMatriz() {
        let valido = true;
        let validaDiametroDe = true;
        let validaDiametroAte = true;
        let validaRaio = true;

        let valorDiametroDe = $('#txtDiametroDe').val();
        let valorDiametroAte = $('#txtDiametroAte').val();
        let valorRaioCurvatura = $('#txtRaioCurvatura').val();

        let lentesContacto = SaoLentesContacto();

        if (valorDiametroDe && valorDiametroAte && valorDiametroDe > valorDiametroAte) {
            validaDiametroDe = false;
            validaDiametroAte = false;
        }

        if (valorDiametroDe && (valorDiametroDe <= 0 || valorDiametroDe >= 100)) {
            validaDiametroDe = false;
        }

        if (valorDiametroAte && (valorDiametroAte <= 0 || valorDiametroAte >= 100)) {
            validaDiametroAte = false;
        }

        if (lentesContacto && valorRaioCurvatura && (valorRaioCurvatura <= 0 || valorRaioCurvatura >= 100)) {
            validaRaio = false;
        }

        if (!validaDiametroDe) {
            $('#txtDiametroDe').addClass('input-error').removeClass('obrigatorio');
        } else {
            $('#txtDiametroDe').addClass('obrigatorio').removeClass('input-error');
        }

        if (!validaDiametroAte) {
            $('#txtDiametroAte').addClass('input-error').removeClass('obrigatorio');
        } else {
            $('#txtDiametroAte').addClass('obrigatorio').removeClass('input-error');
        }

        if (!validaRaio) {
            $('#txtRaioCurvatura').addClass('input-error').removeClass('obrigatorio');
        } else {
            $('#txtRaioCurvatura').addClass('obrigatorio').removeClass('input-error');
        }

        if (!validaDiametroDe || !validaDiametroAte || !validaRaio ||
            !valorDiametroDe || !valorDiametroAte || (lentesContacto && !valorRaioCurvatura))
        {
            valido = false;
        }

        if (lentesContacto) {
            valido = true;
        }
        return valido;
    }

    function ApresentaErrosParametrosMatriz() {
        let valorDiametroDe = $('#txtDiametroDe').val();
        let valorDiametroAte = $('#txtDiametroAte').val();
        let valorRaioCurvatura = $('#txtRaioCurvatura').val();

        let lentesContacto = SaoLentesContacto();

        let errosParametros = [];

        if (valorDiametroDe && valorDiametroAte && valorDiametroDe > valorDiametroAte) {
            errosParametros.push({
                CampoID: "ParametroDiametroSuperior",
                Mensagem: "O diâmetro inicial não pode ser superior ao diâmetro final."
            });
        }

        if ((valorDiametroDe && (valorDiametroDe <= 0 || valorDiametroDe >= 100)) || (valorDiametroAte && (valorDiametroAte <= 0 || valorDiametroAte >= 100))) {
            errosParametros.push({
                CampoID: "ParametroDiametro",
                Mensagem: "O valor do diâmetro deve ser superior a 0 e inferior a 100."
            });
        }

        if (lentesContacto && valorRaioCurvatura && (valorRaioCurvatura <= 0 || valorRaioCurvatura >= 100)) {
            errosParametros.push({
                CampoID: "ParametroRaio",
                Mensagem: "O valor do raio deve ser superior a 0 e inferior a 100."
            });
        }

        if (errosParametros.length > 0) {
            UtilsJanelaRodape(base.constantes.tpalerta.error, errosParametros, false, 'Erro(s)');
        }
    }

    function LimpaDadosMatrizPrecos() {
        let lentesContacto = SaoLentesContacto();

        HandsonTableDestroi('grelhaMatrizPrecos');

        if (lentesContacto) {
            $('#MsgParamsMatrizLentesContacto').removeClass('hidden');
        } else {
            $('#MsgParamsMatrizLentesOftalmicas').removeClass('hidden');
        }
    }

    function LimpaDadosGrelhasPotencia() {
        AtribuiValoresGrelhaPotencia('grelhaValoresPotenciaEsferica', [], false);
        AtribuiValoresGrelhaPotencia('grelhaValoresPotenciaCilindrica', [], false);

        $('#btnAtualizarValoresPotencia').addClass('disabled');
    }

    function CarregaValoresMatrizPrecos(precosMatriz) {
        $('#MsgParamsMatrizLentesOftalmicas').addClass('hidden');
        $('#MsgParamsMatrizLentesContacto').addClass('hidden');

        if (precosMatriz && precosMatriz.length > 0) {
            let dadosMatrizPrecos = PreparaDadosMatrizPrecos(precosMatriz);

            let linhasMatrizPrecos = dadosMatrizPrecos.Linhas;
            let colunasMatrizPrecos = dadosMatrizPrecos.Colunas;

            colunasMatrizPrecos = ObtemColunasMatrizPrecos(colunasMatrizPrecos);

            ApresentaMatrizPrecos(linhasMatrizPrecos, colunasMatrizPrecos);

            let dadosPotenciaEsferica = dadosMatrizPrecos.PotenciaEsferica;
            let dadosPotenciaCilindrica = dadosMatrizPrecos.PotenciaCilindrica;

            AtribuiValoresGrelhaPotencia('grelhaValoresPotenciaEsferica', dadosPotenciaEsferica);
            AtribuiValoresGrelhaPotencia('grelhaValoresPotenciaCilindrica', dadosPotenciaCilindrica);

            $('#btnApagar').removeClass('disabled');
        } else {
            $('#btnApagar').addClass('disabled');

            AtribuiValoresDefeitoGrelhas();
        }
    }

    function ApresentaGrelhaValoresPotencia(idGrelha) {
        let colunasGrelhaPotencia = [
            {
                ID: "ValorInicial",
                TipoEditor: base.constantes.ComponentesHT.F3MNumero,
                CasasDecimais: 2,
                Label: resources.De,
                width: 100
            },
            {
                ID: "ValorFinal",
                TipoEditor: base.constantes.ComponentesHT.F3MNumero,
                CasasDecimais: 2,
                Label: resources.Ate,
                width: 100
            }
        ];

        let grelhaPotencia = HandsonTableDesenhaNovo(idGrelha, [], 200, colunasGrelhaPotencia, true);

        grelhaPotencia.updateSettings({
            fillHandle: false,
            columnSorting: false,
            manualColumnResize: false,
            outsideClickDeselects: true,
            readOnly: true,
            afterChange: DepoisAlterarGrelhaPotencias,
            contextMenu: {
                items: {
                    'remove_row': {
                        name: resources.RemoverLinhaHT,
                        disabled: DesativaEliminaLinhaGrelhaPotencia,
                        callback: RemoveLinhaGrelhaPotencia
                    }
                }
            }
        });
    }

    function DepoisAlterarGrelhaPotencias(_, source) {
        if (source !== base.constantes.SourceHT.LoadData && source !== base.constantes.SourceHT.PopulateFromArray) {
            $('#btnAtualizarValoresPotencia').removeClass('disabled');
        }
    }

    function DesativaEliminaLinhaGrelhaPotencia() {
        var desativaRemover = true;
        var selecao = this.getSelectedRange()[0];

        if (selecao) {
            var linhaInicio = selecao['from']['row'];
            var linhaFim = selecao['to']['row'];

            var numLinhas = this.countRows();

            // Não pode remover a última linha
            if (linhaInicio < numLinhas - 1 && linhaFim < numLinhas - 1)
                desativaRemover = false;
        }

        return desativaRemover;
    }

    function RemoveLinhaGrelhaPotencia(_, selecao) {
        var numLinhas = selecao[0].end.row - selecao[0].start.row + 1;

        this.alter('remove_row', selecao[0].start.row, numLinhas);

        $('#btnAtualizarValoresPotencia').removeClass('disabled');
    };

    function AtribuiValoresDefeitoGrelhas() {
        let dadosPotenciaEsferica = [
            { ValorInicial: 0.00, ValorFinal: 0.00 },
            { ValorInicial: 0.25, ValorFinal: 2.00 },
            { ValorInicial: 2.25, ValorFinal: 4.00 },
            { ValorInicial: 4.25, ValorFinal: 6.00 },
            { ValorInicial: 6.25, ValorFinal: 8.00 },
            { ValorInicial: 8.25, ValorFinal: 10.00 }
        ];

        let dadosPotenciaCilindrica = [
            { ValorInicial: 0.00, ValorFinal: 0.00 },
            { ValorInicial: 0.25, ValorFinal: 2.00 },
            { ValorInicial: 2.25, ValorFinal: 4.00 }
        ];

        let linhasMatrizPrecos = [];
        let colunasMatrizPrecos = [];

        for (let i = 0, len = dadosPotenciaEsferica.length; i < len; i++) {
            let potEsferica = dadosPotenciaEsferica[i];

            let linhaMatriz = {
                PotEsfDe: potEsferica.ValorInicial,
                PotEsfAte: potEsferica.ValorFinal,
                PotenciaEsferica: potEsferica.ValorInicial.toFixed(2) + ' - ' + potEsferica.ValorFinal.toFixed(2)
            };

            linhasMatrizPrecos.push(linhaMatriz);
        }

        for (let i = 0, len = dadosPotenciaCilindrica.length; i < len; i++) {
            let potCilindrica = dadosPotenciaCilindrica[i];

            let idColunaMatriz = 'PotCil-' + potCilindrica.ValorInicial + '-' + potCilindrica.ValorFinal;
            idColunaMatriz = idColunaMatriz.replace('.', ',');

            let labelColuna = potCilindrica.ValorInicial.toFixed(2) + ' - ' + potCilindrica.ValorFinal.toFixed(2);

            colunasMatrizPrecos.push({
                ID: idColunaMatriz,
                Label: labelColuna
            });
        }

        colunasMatrizPrecos = ObtemColunasMatrizPrecos(colunasMatrizPrecos);

        ApresentaMatrizPrecos(linhasMatrizPrecos, colunasMatrizPrecos);

        AtribuiValoresGrelhaPotencia('grelhaValoresPotenciaEsferica', dadosPotenciaEsferica);
        AtribuiValoresGrelhaPotencia('grelhaValoresPotenciaCilindrica', dadosPotenciaCilindrica);
    }

    function AtribuiValoresGrelhaPotencia(idGrelha, dadosPotencia, permiteEditar = true) {
        let grelhaPotencia = HotRegisterer.getInstance(idGrelha);

        if (grelhaPotencia) {
            grelhaPotencia.loadData(dadosPotencia);
            grelhaPotencia.updateSettings({ readOnly: !permiteEditar });
        }
    }

    function PreparaDadosMatrizPrecos(precosMatriz) {
        let idsLinhasPrecosMatriz = [];
        let idsColunasMatrizPrecos = [];

        let linhasPrecosMatriz = [];
        let colunasMatrizPrecos = [];

        let dadosPotenciaEsferica = [];
        let dadosPotenciaCilindrica = [];

        let verPrecoCusto = $('#VerPrecoCusto').val().toLowerCase() === 'true';

        for (let i = 0, len = precosMatriz.length; i < len; i++) {
            let linhaPreco = precosMatriz[i];

            let idColunaMatriz = 'PotCil-' + linhaPreco.PotCilDe + '-' + linhaPreco.PotCilAte;
            idColunaMatriz = idColunaMatriz.replace('.', ',');

            if (idsColunasMatrizPrecos.indexOf(idColunaMatriz) === -1) {
                let labelColunaCilindrica = linhaPreco.PotCilDe.toFixed(2) + ' - ' + linhaPreco.PotCilAte.toFixed(2);

                idsColunasMatrizPrecos.push(idColunaMatriz);

                colunasMatrizPrecos.push({
                    ID: idColunaMatriz,
                    Label: labelColunaCilindrica,
                    ValorInicial: linhaPreco.PotCilDe
                });

                dadosPotenciaCilindrica.push({ ValorInicial: linhaPreco.PotCilDe, ValorFinal: linhaPreco.PotCilAte });
            }

            let descricaoLinha = linhaPreco.PotEsfDe.toFixed(2) + ' - ' + linhaPreco.PotEsfAte.toFixed(2);
            let linhaExistente = null;

            if (idsLinhasPrecosMatriz.indexOf(descricaoLinha) === -1) {
                idsLinhasPrecosMatriz.push(descricaoLinha);

                linhaExistente = {
                    PotEsfDe: linhaPreco.PotEsfDe,
                    PotEsfAte: linhaPreco.PotEsfAte,
                    PotenciaEsferica: descricaoLinha
                };

                linhasPrecosMatriz.push(linhaExistente);

                dadosPotenciaEsferica.push({ ValorInicial: linhaPreco.PotEsfDe, ValorFinal: linhaPreco.PotEsfAte });
            } else {
                for (let j = 0, lenLinhas = linhasPrecosMatriz.length; j < lenLinhas; j++) {
                    let linhaAtual = linhasPrecosMatriz[j];

                    if (linhaAtual.PotEsfDe === linhaPreco.PotEsfDe && linhaAtual.PotEsfAte === linhaPreco.PotEsfAte) {
                        linhaExistente = linhaAtual;
                    }
                }
            }

            if (verPrecoCusto) {
                linhaExistente[idColunaMatriz + '-PrecoCusto'] = linhaPreco.PrecoCusto;
            }

            linhaExistente[idColunaMatriz] = linhaPreco.PrecoVenda;
        }

        return {
            Linhas: linhasPrecosMatriz.sort((a, b) => a.PotEsfDe > b.PotEsfDe ? 1 : -1),
            Colunas: colunasMatrizPrecos.sort((a, b) => a.ValorInicial > b.ValorInicial ? 1 : -1),
            PotenciaEsferica: dadosPotenciaEsferica.sort((a, b) => a.ValorInicial > b.ValorInicial ? 1 : -1),
            PotenciaCilindrica: dadosPotenciaCilindrica.sort((a, b) => a.ValorInicial > b.ValorInicial ? 1 : -1)
        };
    }

    function ObtemColunasMatrizPrecos(colunasPotenciaCilindrica) {
        let verPrecoCusto = $('#VerPrecoCusto').val().toLowerCase() === 'true';

        let colunas = [
            {
                ID: "PotenciaEsferica",
                TipoEditor: base.constantes.ComponentesHT.F3MTexto,
                Label: 'Potência Esférica / Cilíndrica',
                readOnly: true,
                width: 200
            }
        ];

        for (let i = 0, len = colunasPotenciaCilindrica.length; i < len; i++) {
            let colunaCilindrica = colunasPotenciaCilindrica[i];

            if (verPrecoCusto) {
                let dadosColuna = {};
                
                dadosColuna.ID = colunaCilindrica.ID + '-PrecoCusto';
                dadosColuna.TipoEditor = base.constantes.ComponentesHT.F3MNumero;
                dadosColuna.Label = 'P.Custo (' + colunaCilindrica.Label + ')';
                dadosColuna.CasasDecimais = 2;
                dadosColuna.width = 150;

                colunas.push(dadosColuna);
            }

            let dadosColuna = {};

            dadosColuna.ID = colunaCilindrica.ID;
            dadosColuna.TipoEditor = base.constantes.ComponentesHT.F3MNumero;
            dadosColuna.Label = 'P.Venda (' + colunaCilindrica.Label + ')';
            dadosColuna.CasasDecimais = 2;
            dadosColuna.width = 150;

            colunas.push(dadosColuna);
        }

        return colunas;
    }

    function ApresentaMatrizPrecos(dadosMatrizPrecos, colunas) {
        let matrizPrecos = HandsonTableDesenhaNovo('grelhaMatrizPrecos', dadosMatrizPrecos, null, colunas, false);

        matrizPrecos.updateSettings({
            fillHandle: false,
            columnSorting: false,
            manualColumnResize: false,
            outsideClickDeselects: true,
            afterChange: DepoisAlterarMatrizPrecos
        });

        HandsonTableAjustaAltura('grelhaMatrizPrecos', 30);
    }

    function DepoisAlterarMatrizPrecos(_, source) {
        if (source !== base.constantes.SourceHT.LoadData && source !== base.constantes.SourceHT.PopulateFromArray) {
            $('#btnCancelarAlteracoes').removeClass('disabled');
            $('#btnGuardarAlteracoes').removeClass('disabled');
        }
    }

    function VerificaTodosIntervalosPotenciaUtilizados() {
        let todasPotenciasUtilizadas = true;
        let grelhaPrecos = HotRegisterer.getInstance('grelhaMatrizPrecos');

        if (grelhaPrecos) {
            let linhasGrelhaPrecos = grelhaPrecos.getSourceData();

            let colunasMatrizPrecos = grelhaPrecos.getSettings().columns;
            let potsCli = colunasMatrizPrecos
                .filter(lp => lp.ID.startsWith('PotCil-'))
                .map(lp => lp.ID);

            // Verificar as linhas (intervalos potência esférica)
            for (let i = 0, len = linhasGrelhaPrecos.length; todasPotenciasUtilizadas && i < len; i++) {
                let linhaPreco = linhasGrelhaPrecos[i];
                let intervaloUtilizado = false;

                for (let j = 0, lenPot = potsCli.length; !intervaloUtilizado && j < lenPot; j++) {
                    let idPotencia = potsCli[j];
                    let precoVenda = linhaPreco[idPotencia];

                    if (precoVenda && precoVenda > 0.0) {
                        intervaloUtilizado = true;
                    }
                }

                todasPotenciasUtilizadas = intervaloUtilizado;
            }

            // Verificar as colunas (intervalos potência cilindrica)
            for (let i = 0, len = potsCli.length; todasPotenciasUtilizadas && i < len; i++) {
                let idPotencia = potsCli[i];
                let intervaloUtilizado = false;

                for (let j = 0, lenLinhas = linhasGrelhaPrecos.length; !intervaloUtilizado && j < lenLinhas; j++) {
                    let linhaPreco = linhasGrelhaPrecos[j];
                    let precoVenda = linhaPreco[idPotencia];

                    if (precoVenda && precoVenda > 0.0) {
                        intervaloUtilizado = true;
                    }
                }

                todasPotenciasUtilizadas = intervaloUtilizado;
            }
        }

        return todasPotenciasUtilizadas;
    }

    function GuardaAlteracoesMatrizPrecos() {
        KendoLoading($('#catalogos-lentes-matriz-precos'), true);
        KendoLoading($('#AreaColapseDireita'), true);

        let linhasMatrizPrecos = ObtemLinhasModeloMatrizPrecos();

        let url = '../CatalogosLentes/GravaMatrizPrecos';

        let dadosMatriz = {
            IDModelo: $('#IDModelo').val(),
            IDTratamento: $('#IDTratamento').val(),
            DiametroDe: $('#txtDiametroDe').val().replace('.', ','),
            DiametroAte: $('#txtDiametroAte').val().replace('.', ','),
            Raio: $('#txtRaioCurvatura').val().replace('.', ','),
            LinhasMatrizPrecos: linhasMatrizPrecos
        };

        UtilsChamadaAjax(url, false, JSON.stringify({ matrizPrecos: dadosMatriz}),
            function (res) {
                if (!res.Erros) {
                    modeloMatrizPrecoOriginal = $.extend(true, [], linhasMatrizPrecos);

                    $('#btnGuardarAlteracoes').addClass('disabled');
                    $('#btnCancelarAlteracoes').addClass('disabled');
                    $('#btnApagar').removeClass('disabled');

                    UtilsNotifica(base.constantes.tpalerta.s, "As alterações foram gravadas com sucesso.");
                } else {
                    UtilsNotifica(base.constantes.tpalerta.error, "Não foi possível guardar as alterações.");
                }

                KendoLoading($('#catalogos-lentes-matriz-precos'), false);
                KendoLoading($('#AreaColapseDireita'), false);
            },
            function () {
                UtilsNotifica(base.constantes.tpalerta.error, "Não foi possível guardar as alterações.");

                KendoLoading($('#catalogos-lentes-matriz-precos'), true);
                KendoLoading($('#AreaColapseDireita'), true);
            }, 1, true);
    }

    function CancelarAlteracoesMatrizPrecos() {
        KendoLoading($('#catalogos-lentes-matriz-precos'), true);
        KendoLoading($('#AreaColapseDireita'), true);

        LimpaJanelaErros();

        let copiaModeloOriginal = $.extend(true, [], modeloMatrizPrecoOriginal);
        CarregaValoresMatrizPrecos(copiaModeloOriginal);

        $('#btnAtualizarValoresPotencia').addClass('disabled');
        $('#btnGuardarAlteracoes').addClass('disabled');
        $('#btnCancelarAlteracoes').addClass('disabled');

        KendoLoading($('#catalogos-lentes-matriz-precos'), false);
        KendoLoading($('#AreaColapseDireita'), false);
    }

    function ObtemLinhasModeloMatrizPrecos() {
        let linhasModeloPrecos = [];
        let grelhaPrecos = HotRegisterer.getInstance('grelhaMatrizPrecos');

        if (grelhaMatrizPrecos) {
            let linhasGrelhaPrecos = grelhaPrecos.getSourceData();

            let colunasMatrizPrecos = grelhaPrecos.getSettings().columns;
            let potsCli = colunasMatrizPrecos
                .filter(lp => lp.ID.startsWith('PotCil-') && !lp.ID.endsWith('-PrecoCusto'))
                .map(lp => lp.ID);

            for (let i = 0, len = linhasGrelhaPrecos.length; i < len; i++) {
                let linhaPreco = linhasGrelhaPrecos[i];

                for (let j = 0, lenPotCli = potsCli.length; j < lenPotCli; j++) {
                    let propPotCli = potsCli[j];
                    let precoVenda = linhaPreco[propPotCli];

                    if (precoVenda && precoVenda > 0.0) {
                        let precoCusto = linhaPreco[propPotCli + '-PrecoCusto'];
                        let potCil = propPotCli.split('-');

                        let potCilDe = parseFloat(potCil[1].replace(',', '.'));
                        let potCilAte = parseFloat(potCil[2].replace(',', '.'));

                        let novaLinhaModelo = {
                            PotEsfDe: linhaPreco.PotEsfDe,
                            PotEsfAte: linhaPreco.PotEsfAte,
                            PotCilDe: potCilDe,
                            PotCilAte: potCilAte,
                            PrecoVenda: precoVenda,
                            PrecoCusto: precoCusto
                        }

                        linhasModeloPrecos.push(novaLinhaModelo);
                    }
                }
            }
        }

        return linhasModeloPrecos;
    }

    function RemoveMatrizPrecos() {
        KendoLoading($('#catalogos-lentes-matriz-precos'), true);
        KendoLoading($('#AreaColapseDireita'), true);

        let idModeloSelecionado = $('#IDModelo').val();
        let idTratamentoSelecionado = $('#IDTratamento').val();
        let diametroDe = $('#txtDiametroDe').val();
        let diametroAte = $('#txtDiametroAte').val();
        let raio = $('#txtRaioCurvatura').val();

        let urlValoresMatrizPrecos = '../CatalogosLentes/RemoveMatrizPrecosPorModeloTratamento?' +
            'idModelo=' + idModeloSelecionado +
            '&idTratamento=' + idTratamentoSelecionado +
            '&diametroDe=' + diametroDe +
            '&diametroAte=' + diametroAte +
            '&raio=' + raio;

        UtilsChamadaAjax(urlValoresMatrizPrecos, true, {},
            function (res) {
                if (!res.Erros) {
                    LimpaJanelaErros();

                    $('#btnApagar').addClass('disabled');
                    $('#btnAtualizarValoresPotencia').addClass('disabled');

                    modeloMatrizPrecoOriginal = [];
                    CarregaValoresMatrizPrecos([]);

                    UtilsNotifica(base.constantes.tpalerta.s, "A matriz de preços foi removida com sucesso.");
                } else {
                    UtilsNotifica(base.constantes.tpalerta.error, "Não foi possível remover a matriz de preços.");
                }

                KendoLoading($('#catalogos-lentes-matriz-precos'), false);
                KendoLoading($('#AreaColapseDireita'), false);
            },
            function () {
                UtilsNotifica(base.constantes.tpalerta.error, "Não foi possível remover a matriz de preços.");

                KendoLoading($('#catalogos-lentes-matriz-precos'), false);
                KendoLoading($('#AreaColapseDireita'), false);
            }, 1, true);
    }

    function AtualizaValoresPotencia(evt) {
        evt.preventDefault();
        evt.stopImmediatePropagation();

        KendoLoading($('#catalogos-lentes-matriz-precos'), true);
        KendoLoading($('#AreaColapseDireita'), true);
        
        let validaGrelhaPotenciaEsferica = ValidaGrelhaPotencia('grelhaValoresPotenciaEsferica');
        let validaGrelhaPotenciaCilindrica = ValidaGrelhaPotencia('grelhaValoresPotenciaCilindrica');

        if (validaGrelhaPotenciaEsferica && validaGrelhaPotenciaCilindrica) {
            LimpaJanelaErros();

            $('#btnAtualizarValoresPotencia').addClass('disabled');

            let grelhaMatrizPrecos = HotRegisterer.getInstance('grelhaMatrizPrecos');

            if (grelhaMatrizPrecos) {
                let linhasMatrizPrecos = grelhaMatrizPrecos.getSourceData();

                let novasLinhas = AtualizaValoresPotenciaEsferica(linhasMatrizPrecos);
                let colunasCampos = AtualizaValoresPotenciaCilindrica();
                let colunasHeaders = [];

                let colunas = HandsonTableConfiguraColunas(colunasCampos, colunasHeaders);

                grelhaMatrizPrecos.updateSettings({
                    data: novasLinhas,
                    colHeaders: colunasHeaders,
                    columns: colunas,
                    minRows: novasLinhas.length,
                    maxRows: novasLinhas.length
                });

                HandsonTableAjustaAltura('grelhaMatrizPrecos', 30);
            }

            $('#btnGuardarAlteracoes').removeClass('disabled');
            $('#btnCancelarAlteracoes').removeClass('disabled');
        } else {
            ApresentaErrosGrelhasPotencias(validaGrelhaPotenciaEsferica, validaGrelhaPotenciaCilindrica);
        }

        KendoLoading($('#catalogos-lentes-matriz-precos'), false);
        KendoLoading($('#AreaColapseDireita'), false);
    }

    function ApresentaErrosGrelhasPotencias(validaGrelhaPotenciaEsferica, validaGrelhaPotenciaCilindrica) {
        let errosPotencias = [];

        if (!validaGrelhaPotenciaEsferica) {
            errosPotencias.push({
                CampoID: "ValoresPotenciaEsferica",
                Mensagem: "O intervalo de valores da potência esférica devem ser sequenciais."
            });
        }

        if (!validaGrelhaPotenciaCilindrica) {
            errosPotencias.push({
                CampoID: "ValoresPotenciaCilindrica",
                Mensagem: "O intervalo de valores da potência cilíndrica devem ser sequenciais."
            });
        }

        if (errosPotencias.length > 0) {
            UtilsJanelaRodape(base.constantes.tpalerta.error, errosPotencias, false, 'Erro(s)');
        }
    }

    function AtualizaValoresPotenciaEsferica(linhasMatrizPrecos) {
        let novasLinhasMatrizPrecos = [];
        let grelhaPotenciaEsferica = HotRegisterer.getInstance('grelhaValoresPotenciaEsferica');

        if (grelhaPotenciaEsferica) {
            let valoresGrelhaPotEsf = grelhaPotenciaEsferica.getSourceData();

            for (let i = 0, len = valoresGrelhaPotEsf.length; i < len; i++) {
                let linhaPotEsf = valoresGrelhaPotEsf[i];

                if (linhaPotEsf.ValorInicial !== null && linhaPotEsf.ValorInicial !== '' && !isNaN(linhaPotEsf.ValorInicial) &&
                    linhaPotEsf.ValorFinal !== null && linhaPotEsf.ValorFinal !== '' && !isNaN(linhaPotEsf.ValorFinal))
                {
                    let linhaExistente = linhasMatrizPrecos.find(lp => lp.PotEsfDe === linhaPotEsf.ValorInicial && lp.PotEsfAte === linhaPotEsf.ValorFinal);

                    if (linhaExistente === undefined) {
                        let descricaoLinha = linhaPotEsf.ValorInicial.toFixed(2) + ' - ' + linhaPotEsf.ValorFinal.toFixed(2);

                        novasLinhasMatrizPrecos.push({
                            PotEsfDe: linhaPotEsf.ValorInicial,
                            PotEsfAte: linhaPotEsf.ValorFinal,
                            PotenciaEsferica: descricaoLinha
                        });
                    } else {
                        novasLinhasMatrizPrecos.push(linhaExistente);
                    }
                }
            }
        }

        novasLinhasMatrizPrecos.sort((a, b) => a.PotEsfDe > b.PotEsfDe ? 1 : -1);

        return novasLinhasMatrizPrecos;
    }

    function AtualizaValoresPotenciaCilindrica() {
        let colunasMatrizPrecos = [];

        let grelhaPotenciaCilindrica = HotRegisterer.getInstance('grelhaValoresPotenciaCilindrica');

        if (grelhaPotenciaCilindrica) {
            let valoresGrelhaPotCil = grelhaPotenciaCilindrica.getSourceData();

            const valoresPotCil = $.extend(true, [], valoresGrelhaPotCil);
            valoresPotCil.sort((a, b) => a.ValorInicial > b.ValorInicial ? 1 : -1)

            for (let i = 0, len = valoresPotCil.length; i < len; i++) {
                let linhaPotCil = valoresPotCil[i];

                if (linhaPotCil.ValorInicial !== null && linhaPotCil.ValorInicial !== '' && !isNaN(linhaPotCil.ValorInicial) &&
                    linhaPotCil.ValorFinal !== null && linhaPotCil.ValorFinal !== '' && !isNaN(linhaPotCil.ValorFinal))
                {
                    let idColunaMatriz = 'PotCil-' + linhaPotCil.ValorInicial + '-' + linhaPotCil.ValorFinal;
                    idColunaMatriz = idColunaMatriz.replace('.', ',');

                    let labelColunaMatriz = linhaPotCil.ValorInicial.toFixed(2) + ' - ' + linhaPotCil.ValorFinal.toFixed(2);

                    colunasMatrizPrecos.push({
                        ID: idColunaMatriz,
                        Label: labelColunaMatriz
                    });
                }
            }
        }

        return ObtemColunasMatrizPrecos(colunasMatrizPrecos);
    }

    function ValidaGrelhaPotencia(idGrelha) {
        let grelhaPotencia = HotRegisterer.getInstance(idGrelha);
        let valido = true;

        if (grelhaPotencia) {
            let valoresPotencia = grelhaPotencia.getSourceData();

            let intervalosPotencia =
                valoresPotencia
                    .filter(p => p.ValorInicial !== null && p.ValorInicial !== undefined && !isNaN(p.ValorInicial))
                    .sort((a, b) => a.ValorInicial > b.ValorInicial ? 1 : -1);

            if (intervalosPotencia.length > 0) {
                let intervaloAnterior = intervalosPotencia[0];

                if (intervaloAnterior.ValorInicial > intervaloAnterior.ValorFinal) {
                    valido = false;
                }

                for (let i = 1, len = intervalosPotencia.length; valido && i < len; i++) {
                    intervaloAnterior = intervalosPotencia[i-1];
                    let intervaloAtual = intervalosPotencia[i];

                    if (intervaloAtual.ValorInicial > intervaloAtual.ValorFinal ||
                        intervaloAtual.ValorInicial <= intervaloAnterior.ValorFinal) {
                        valido = false
                    }
                }
            } else {
                valido = false;
            }
        }

        return valido;
    }

    function LimpaJanelaErros() {
        UtilsJanelaRodape(base.constantes.tpalerta.error, null, false);
    }


    return parent;
}($catalogolentesmatrizprecos || {}, jQuery));

var CatalogoLentesMatrizPrecosInit = $catalogolentesmatrizprecos.ajax.Init;


$(document).ready(CatalogoLentesMatrizPrecosInit);
