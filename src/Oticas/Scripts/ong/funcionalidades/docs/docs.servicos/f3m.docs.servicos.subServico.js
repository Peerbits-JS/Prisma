"use strict";

var $subServicos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    //constantes tipos de servico
    var TipoServico = {
        LongePerto: 1,
        Longe: 2,
        Perto: 3,
        BifocalAmbos: 4,
        ProgressivaAmbos: 5,
        Contacto: 6,
        BifocalOlhoDireito: 7,
        BifocalOlhoEsquerdo: 8,
        ProgressivaOlhoDireito: 9,
        ProgressivaOlhoEsquerdo: 10
    };

    self.Init = function () {
        let addSubServico = document.getElementById("adicionaSubServico");
        let servicosBtAdd = document.getElementById("ServicosBtAdd");
        let divServicos = document.getElementById("divServicos");
        let closeModalSubServicos = document.getElementById("closeModalSubServicos");

        self.AppendIconModal();

        if ($("#ID").val() === '0' && $('#DocEstaEmDuplicacao').val() !==  'True') {
           
            divServicos.classList.add('hidden');

            self.ShowModal();
        }

        if (servicosBtAdd) {
            servicosBtAdd.onclick = function () {  
                self.ShowModal();
            };
        }

        self.ModalToggleServico();
        self.ModalRadioServico();

        addSubServico.onclick = function () {
            let tipoServicoCheck = self.VerificaTipoServico();
            let ulServicos = document.querySelectorAll("#ulServicos li");
            let ulServicoActivo = document.querySelectorAll("#ulServicos li.active");

            if (ulServicos.length >= 1 && ulServicoActivo.length === 1) {
                let byModel;
                $servicos.ajax.SubServicoAdiciona(byModel, tipoServicoCheck);
            } else {
                self.AppendSubServico();
                self.SubServicoAdiciona(tipoServicoCheck);

            }

            $("#modal-adiciona-subservico").modal("hide");
        };

        closeModalSubServicos.onclick = function () {

            let ulServicoActivo = document.querySelectorAll("#ulServicos li.active");

            if (ulServicoActivo.length === 0) {
                $("#F3MGrelhaFormDocumentosVendasServicosBtCancel").trigger("click");
            }
            
        };
        if ($('#NewUserOnFeature').val() == 'True') {
            $('#new-feature-modal').modal('show');
        }
    };

    self.AppendIconModal = function () {

        let newIcon = document.getElementById("newFeatureModal");

        if (!newIcon) {

            let listBts = document.getElementById("F3MGrelhaFormDocumentosVendasServicosBts");
            let linkIcon = document.createElement("a");
            let spanIcon = document.createElement("span");
            let spanBagde = document.createElement("span");

            spanIcon.classList.add("fm", "f3icon-question-circle");

            spanBagde.classList.add("badge", "badge-pill", "badge-danger", "f3m-badge");
            spanBagde.innerHTML = " ";

            linkIcon.id = "newFeatureModal";
            linkIcon.classList.add("f3mlink", "float-right", "f3m-new-feature-icon");
            linkIcon.appendChild(spanBagde);
            linkIcon.appendChild(spanIcon);

            listBts.after(linkIcon);

            linkIcon.onclick = function () {
                $('#new-feature-modal').modal('show');
            };
        }

    }

    self.ShowModal = function () {
        $('#modal-adiciona-subservico').modal('show');
    };

    self.ModalToggleServico = function () {

        $("#ServicoO, #ServicoLC").on("change", function (e) {
            let idElemento = e.currentTarget.id;
            let inputRadios = document.getElementById("radiosTipoServico").getElementsByTagName('input');
            let inputCheck = document.getElementById("CombinacaoDefeito");

            switch (idElemento) {
                case 'ServicoLC':
                    for (let input of inputRadios) {
                        input.disabled = true;
                        input.checked = false;
                        input.parentElement.classList.add('disabled');
                    }
                    inputCheck.classList.add('disabled');
                    inputCheck.checked = false;
                    $("#radiosTipoServico input").removeAttr('checked');

                    break;

                case 'ServicoO':
                    let inputTSUnifocal = document.getElementById("TSUnifocal");
                    let inputIDlongePerto = document.getElementById("IDLongePerto");

                    for (let input of inputRadios) {
                        if (input.id !== "IDAmbos" && input.id !== "IDOE" && input.id !== "IDOD") {
                            input.disabled = false;
                            input.parentElement.classList.remove('disabled');
                        }

                    }
                    inputCheck.classList.remove('disabled');
                    inputTSUnifocal.checked = true;
                    inputIDlongePerto.checked = true;

                    break;
            }
        });
    };

    self.ModalRadioServico = function (e) {
        var rdBtnTipo = "input[type='radio'][name='TipoServico']";
        var rdBtnTipo2 = "input[type='radio'][name='TipoServicoOlho']";
        /* @description quando o tipo de servico e alterado (UNIFOCAL || BIFOCAL || PROGRESSIVA) */
        $(rdBtnTipo).on("change", function (e) {
            var value = e.currentTarget.value;
            var arrTipo2 = $(rdBtnTipo2);

            if (value === "Unifocal") {
                let inputIDlongePerto = document.getElementById("IDLongePerto");
                inputIDlongePerto.checked = true;

                $.each(arrTipo2, function (index, value) {
                    if (value.value === "LongePerto" || value.value === "Longe" || value.value === "Perto") {
                        value.disabled = false;
                        value.parentElement.classList.remove('disabled');
                    }
                    else {
                        value.disabled = true;
                        value.parentElement.classList.add('disabled');
                    }
                });

            } else if (value === "Bifocal" || value === "Progressiva") {
                let inputIDlongePerto = document.getElementById("IDAmbos");

                inputIDlongePerto.checked = true;

                for (var i = 0, len = arrTipo2.length; i < len; i++) {
                    var item = arrTipo2[i];

                    if (item.value === "Ambos" || item.value === "OlhoEsquerdo" || item.value === "OlhoDireito") {
                        item.disabled = false;
                        item.parentElement.classList.remove('disabled');
                    }
                    else {
                        item.disabled = true;
                        item.parentElement.classList.add('disabled');
                    }
                }
            }
        });

    };

    self.VerificaTipoServico = function () {
        
        let radioTipoServico = $("input[type='radio'][name='TipoServico']:checked").val();
        let radioTipoServicoOlho = $("input[type='radio'][name='TipoServicoOlho']:checked").val();
        var tipoServicoCheck;

        if (radioTipoServico === "Unifocal") {

            if (radioTipoServicoOlho === "LongePerto") {
                tipoServicoCheck = TipoServico.LongePerto;
            } else if (radioTipoServicoOlho === "Longe") {
                tipoServicoCheck = TipoServico.Longe;
            } else {
                tipoServicoCheck = TipoServico.Perto;
            }

        } else if (radioTipoServico === "Bifocal") {

            if (radioTipoServicoOlho === "Ambos") {
                tipoServicoCheck = TipoServico.BifocalAmbos;
            } else if (radioTipoServicoOlho === "OlhoEsquerdo") {
                tipoServicoCheck = TipoServico.BifocalOlhoEsquerdo;
            } else {
                tipoServicoCheck = TipoServico.BifocalOlhoDireito;
            }

        } else if (radioTipoServico === "Progressiva") {

            if (radioTipoServicoOlho === "Ambos") {
                tipoServicoCheck = TipoServico.ProgressivaAmbos;
            } else if (radioTipoServicoOlho === "OlhoEsquerdo") {
                tipoServicoCheck = TipoServico.ProgressivaOlhoEsquerdo;
            } else {
                tipoServicoCheck = TipoServico.ProgressivaOlhoDireito;
            }

        } else {
            tipoServicoCheck = TipoServico.Contacto;
        }

        return tipoServicoCheck;

    };

    self.SubServicoAdiciona = function (tipoServicoCheck) {

        var urlAux = rootDir + "DocumentosVendasServicos/" + "/AddSubServico";
        var filtro = JSON.stringify({ modelo: null });
        var novoID = parseInt($("#ulServicos > li:first").attr("id").replace("liServico", ""));

        filtro = JSON.stringify({ modelo: null, IDTipoServico: tipoServicoCheck });
        UtilsChamadaAjax(urlAux, false, filtro,
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    divServicos.classList.remove('hidden');
                    res.ID = novoID;
                    if (UtilsVerificaObjetoNotNullUndefined(res.DataReceita)) {
                        res.DataReceita = UtilsConverteJSONDate(res.DataReceita, constJSONDates.ConvertToDDMMAAAA);
                    }
                    res.DocumentosVendasLinhas.map(function (data) {
                        return data.IDServico = res.ID;
                    });

                    $servicos.ajax.SetValorCampoObj(ModeloServico.Servicos, "IDTipoServico", tipoServicoCheck, res.ID);
                    $servicos.ajax.SetValorCampoObj(ModeloServico.Servicos, "IDTipoServicoAux", tipoServicoCheck, res.ID);
                    $servicos.ajax.SetValorCampoObj(ModeloServico.Servicos, "CombinacaoDefeito", $("#CombinacaoDefeito").prop("checked"), res.ID);

                    $servicos.ajax.CarregaSubServico(res.ID);
                    $servicos.ajax.EnableOrDisableBtRemoverServico();
                    $servicos.ajax.ConfiguraCliqueLinhasServicos();

                    
                }
            }, function (e) { }, 1, true);
        
    };

    self.AppendSubServico = function () {
        let li = document.createElement("li");
        let a = document.createElement("a");
        let divText = document.createElement("div");

        li.classList.add("nav-item", "animated", "fadeIn", "f3m-nav-servico__item", "active");
        li.id = "liServico0";

        divText.classList.add('clsF3MliServico');

        a.classList.add("nav-link");
        a.appendChild(divText);

        li.appendChild(a);

        $("#ulServicos").append(li);
    };



    return parent;

}($subServicos || {}, jQuery));

//------------------------------------ V A R I A V E I S     G L O B A I S
var Init = $subServicos.ajax.Init;

$(document).ready(function (e) {
    Init();
});
