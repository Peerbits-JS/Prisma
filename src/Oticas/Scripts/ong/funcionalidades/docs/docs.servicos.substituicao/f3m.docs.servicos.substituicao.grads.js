"use strict";

var $docsservicossubstituicaograds = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //------------------------------------ C O N S T A N T E S
    var campoTabOD = "TabOlhoDireito", clsTOD = "." + campoTabOD;
    var campoTabOE = "TabOlhoEsquerdo", clsTOE = "." + campoTabOE;

    var campoTabLonge = "TabLonge", clsTabLonge = "." + campoTabLonge, campoTabInt = "TabInt", clsTabInt = "." + campoTabInt, campoTabPerto = "TabPerto", clsTabPerto = "." + campoTabPerto;
    var campoTabLentes = "TabLentes";

    var spnCopiaEsquerdaLC = "#spnCopiaEsquerdaLC", spnCopiaDireitaLC = "#spnCopiaDireitaLC", spnCopiaEsquerdaO = "#spnCopiaEsquerdaO", spnCopiaDireitaO = "#spnCopiaDireitaO";

    //constantes tipos de graduacao
    var TipoGraduacao = {
        Longe: 1,
        Intermedio: 2,
        Perto: 3,
        LentesContato: 4,
    }

    //constantes tipos de olho
    var TipoOlho = {
        Direito: 1,
        Esquerdo: 2,
    };

    //------------------------------------ D O C U M E N T     R E A D Y
    self.Init = () => {
        $(spnCopiaEsquerdaLC + ", " + spnCopiaEsquerdaO + ", " + spnCopiaDireitaLC + ", " + spnCopiaDireitaO).on("click", (e) => self.CopyGrads(e));

        $(".input-dioptria").on("change", (e) => self.ChangeGrad(e));

        $(".input-dioptria").on("click", (e) => {
            e.target.select();
        });

        if ($('.LblLonge').length) {
            $('.LblPerto').addClass('invisible');
        }
    }

    self.ChangeGrad = (e) => {
        let currentValue = $(e.currentTarget).val();

        if (!currentValue && currentValue === '') {
            $(e.currentTarget).val('0');
        }

        //validate max and min value
        self.ValidataMaxAndMinValueGrad(e);

        //here request
        let gradType = e.target.classList[2];

        switch (gradType) {
            //lo
            case 'PotenciaEsferica':
            case 'PotenciaCilindrica':
            case 'Adicao':
            case 'PotenciaPrismatica':
            //lc
            case 'RaioCurvatura':
            case 'Eixo':
                self.DebounceReqValidaExisteArtigo();
                break;

            default:
                $docsservicossubstituicao.ajax.EnableDirty();
                break;
        }
    }

    self.DebounceReqValidaExisteArtigo = function() {
        var timer;

        return () => {
            clearTimeout(timer);

            timer = setTimeout(() => {
                console.log('here!');
                self.ReqValidaExisteArtigo();
                clearTimeout(timer);
            }, 1500);
        }
    }()

    self.ReqValidaExisteArtigo = () => {
        let url = rootDir + 'DocumentosVendasServicosSubstituicao/ValidaExisteArtigo';
        let model = self.ReqValidaExisteArtigoGetModel();

        UtilsChamadaAjax(url, true, JSON.stringify({ model: model }), self.ValidaExisteArtigoSuccessCallback , function (e) { throw e; }, 1, true);
    }


    self.ReqValidaExisteArtigoGetModel = () => {
        let form = $('#F3MGrelhaFormDocumentosVendasServicosSubstituicaoForm > form');
        let DTO = $grelhaForm.ajax.DTO(form);
        let model = $gridutils.ajax.GetModeloForm(DTO);
        model = $docsservicossubstituicao.ajax.GetModel(model);
        return model;
    }

    self.ValidaExisteArtigoSuccessCallback = (res) => {
        let artigos = $docsservicossubstituicaoartigos.ajax.GetHdsnSourceData();

        for (let index = 0; index < artigos.length; index++) {
            let artigo = artigos[index];

            let artigoFromRequest = $.grep(res.Servico.Artigos, (data) => data['IDTipoOlho'] === artigo['IDTipoOlho'] && data['IDTipoGraduacao'] === artigo['IDTipoGraduacao'])[0];
            if (artigoFromRequest) {
                artigo['IdArtigoDestino'] = artigoFromRequest['IdArtigoDestino'];
                artigo['CodigoArtigoDestino'] = artigoFromRequest['CodigoArtigoDestino'];
                artigo['DescricaoArtigoDestino'] = artigoFromRequest['DescricaoArtigoDestino'];
            }
        }
        $docsservicossubstituicaoartigos.ajax.GetHdsnInstance().render();
        $docsservicossubstituicao.ajax.EnableDirty();
    }

    self.ValidataMaxAndMinValueGrad = (e) => {
        let max = parseInt($(e.currentTarget).attr("max"));
        let min = parseInt($(e.currentTarget).attr("min"));
        let val = parseInt($(e.currentTarget).val());
        if (val > max || val < min) {
            $(e.currentTarget).val(val > max ? max : min);
        }
    }

    //------------------------------------ C O P Y
    self.CopyGrads = (e) => {
        let rows = $("#FoleGrelha table tr");

        $.each(rows, (rowIndex, row) => {
            if (e.currentTarget.id.indexOf("Esquerda") > -1) {
                self.CopyToLeft(rowIndex, row);
            }
            else {
                self.CopyToRight(rowIndex, row);
            }
        });
        self.ReqValidaExisteArtigo();
    }

    self.CopyToLeft = (rowIndex, row) => {
        let inputs = $(row).find("td input" + clsTOE);
        $.each(inputs, (inputIndex, input) => {
            $(input).val($(row).find("input." + $(input).attr("class").replace(campoTabOE, campoTabOD).replace(/\s+/g, ".")).val());
        });
    }

    self.CopyToRight = (rowIndex, row) => {
        let inputs = $(row).find("td input" + clsTOD);
        $.each(inputs, (inputIndex, input) => {
            $(input).val($(row).find("input." + $(input).attr("class").replace(campoTabOD, campoTabOE).replace(/\s+/g, ".")).val());
        });
    }

    //------------------------------------ M O D E L
    self.SetGradByArtigo = (hdsnRowDS, artigo) => {
        let seletor = self.GetSelector(hdsnRowDS['IDTipoGraduacao'], hdsnRowDS['IDTipoOlho']);

        if (hdsnRowDS['IDTipoServico'] === 6) {
            $(seletor + '.RaioCurvatura').val(artigo['RaioCurvatura']);
            $(seletor + '.PotenciaEsferica').val(artigo['PotenciaEsferica']);
            $(seletor + '.PotenciaCilindrica').val(artigo['PotenciaCilindrica']);
            $(seletor + '.Eixo').val(artigo['Eixo']);
            $(seletor + '.Adicao').val(artigo['Adicao']);
        }
        else {
            $(seletor + '.PotenciaEsferica').val(artigo['PotenciaEsferica']);
            $(seletor + '.PotenciaCilindrica').val(artigo['PotenciaCilindrica']);
            $(seletor + '.PotenciaPrismatica').val(artigo['PotenciaPrismatica']);
            $(seletor + '.Adicao').val(artigo['Adicao']);
        }
    }

    self.SetGrad = (grad) => {
        let seletor = self.GetSelector(grad['IDTipoGraduacao'], grad['IDTipoOlho']);
        let table = grad.IDTipoGraduacao == TipoGraduacao.LentesContato ? $("#tblLentes table") : $("#tblOculos table");

        //TODO MAF - ISTO VEIO DOS SERVICOS
        $.each(grad, function (j, n) {
            if (!j.startsWith("_") && j.charAt(0) == j.charAt(0).toUpperCase()) {
                var elem = table.find(seletor + "." + j);
                if (elem.length) {
                    if (UtilsVerificaObjetoNotNullUndefinedVazio(n)) {
                        n = n.toString().replace(',', '.');
                    }
                    $(elem).val(n);
                }
            }
        });
        //END TODO MAF
    }

    self.SetGrads = (data) => {
        for (let index = 0; index < data.length; index++) {
            let grad = data[index];
            self.SetGrad(grad);
        }
    }

    self.GetGrads = () => {
        let grads = [];
        let rows = $("#FoleGrelha table tr");

        $.each(rows, function (rowIndex, row) {
            let inputs = $(row).find("td input");

            $.each(inputs, function (inputIndex, input) {
                let eyeType = self.GetEyeType(input);
                let gragType = self.GetGradType(input);

                let gradExistent = $.grep(grads, (grad) => grad.IDTipoOlho === eyeType && grad.IDTipoGraduacao === gragType)[0];

                if (gradExistent) {
                    gradExistent[input.classList[2]] = parseFloat(input.value.toString().replace(",", "."));
                }
                else {
                    let grad = {
                        IDServico: $('#IDServico').val(),
                        IDTipoOlho: self.GetEyeType(input),
                        IDTipoGraduacao: self.GetGradType(input)
                    }
                    grad[input.classList[2]] = parseFloat(input.value.toString().replace(",", "."));
                    grads.push(grad)
                }
            });
        });
         return grads;
    }

    self.GetEyeType = (input) => {
        let eyeType = input.classList[1];
        switch (eyeType) {
            case campoTabOE:
                return TipoOlho.Esquerdo;
            case campoTabOD:
                return TipoOlho.Direito;
        }
        return "";
    }

    self.GetGradType = (input) => {
        let getTab = input.parentElement.parentElement.classList[0];

        switch (getTab) {
            case campoTabLonge:
                return TipoGraduacao.Longe;
            case campoTabPerto:
                return TipoGraduacao.Perto;
            case campoTabInt:
                return TipoGraduacao.Intermedio;
            case campoTabLentes:
                return TipoGraduacao.LentesContato;
        }
        return ""
    }

    self.GetSelector = (idTipoGraduacao, idTipoOlho) => {
        let seletor = '';

        switch (idTipoGraduacao) {
            case TipoGraduacao.Longe:
                seletor = "tr" + clsTabLonge;
                break;
            case TipoGraduacao.Intermedio:
                seletor = "tr" + clsTabInt;
                break;
            case TipoGraduacao.Perto:
                seletor = "tr" + clsTabPerto;
                break;
        }

        switch (idTipoOlho) {
            case TipoOlho.Direito:
                seletor = seletor + " " + clsTOD;
                break;
            case TipoOlho.Esquerdo:
                seletor = seletor + " " + clsTOE;
                break;
        }

        return seletor;
    }
    
    return parent;

}($docsservicossubstituicaograds || {}, jQuery));

$(document).ready(() => $docsservicossubstituicaograds.ajax.Init());