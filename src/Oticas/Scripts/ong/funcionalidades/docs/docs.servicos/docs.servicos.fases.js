//var ListaColunasFases = [];

//self.InitFolesServicos = function () {
//    try {
//        if (!$('#accordionFases').length) {
//            $('#tabHistorico').append('<div class="panel-group" id="accordionFases" role="tablist" aria-multiselectable="true"></div>');
//        }

//        if (!$('#accordionFases').children().length) {
//            $('#accordionFases').before('<div class="card-title"><span class="fm f3icon-list-ol"></span><h6>Fases Serviço</h6></div>');
//            $('#accordionFases').addClass('fases-servico clearfix')

//            if (ModeloServico.Servicos.length) {
//                var qHeader = '<div id="ServicosHistoricoExpandirColapsar" class="expand-colapse-holder float-right">' +
//                    '<div class="btn-group" role="group">' +
//                    '<a class="btn btn-line btn-sm" onclick="return ServicosHistoricoExpandeFoles(true);">Expandir todos</a>' +
//                    '<a class="btn btn-line btn-sm" onclick="return ServicosHistoricoExpandeFoles(false);">Colapsar todos</a>' +
//                    '</div>' +
//                    '</div>';
//                $('#accordionFases').append(qHeader);
//            }

//            for (var i = 0; i < ModeloServico.Servicos.length; i++) {
//                var IDNovaDiv = ModeloServico.Servicos[i].ID;
//                var DescNovaDiv = ModeloServico.Servicos[i].DescricaoServico;

//                var queue = '<div class="panel panel-default">'
//                    + '<div class="panel-heading">'
//                    + '<h4 class="panel-title">'
//                    + '<a data-toggle="collapse" data-parent="queues-accordion" href="#collapse' + IDNovaDiv + '">' + DescNovaDiv + '</a>'
//                    + '</h4>'
//                    + '</div>'
//                    + '<div id="collapse' + IDNovaDiv + '" class="panel-collapse collapse in">'
//                    + '<div class="panel-body">'
//                    + '<div class="handson-container">'
//                    + '<div id="IDHdsn' + IDNovaDiv + '" class=""></div>'
//                    + '</div>'
//                    + '</div>'
//                    + '</div>'
//                    + '</div>';

//                $('#accordionFases').append(queue);

//                $('#accordionFases').on('shown.bs.collapse', function () {
//                    HandsonTableStretchHTWidthToContainer();
//                });

//                for (var j = 0; j < ModeloServico.Servicos[i].Fases.length; j++) {
//                    if (UtilsVerificaObjetoNotNullUndefined(ModeloServico.Servicos[i].Fases[j].Data)) {
//                        ModeloServico.Servicos[i].Fases[j].Data = UtilsConverteJSONDate(ModeloServico.Servicos[i].Fases[j].Data, constJSONDates.ConvertToDDMMAAAAHHmm);
//                    }
//                    ModeloServico.Servicos[i].Fases[j].DataCriacao = UtilsConverteJSONDate(ModeloServico.Servicos[i].Fases[j].DataCriacao, constJSONDates.ConvertToDDMMAAAAHHmmSS);
//                }

//                self.InitHandsonTableFases('IDHdsn' + IDNovaDiv, ModeloServico.Servicos[i].Fases, null);
//            }
//        }
//    } catch (ex) {
//        throw ex;
//    }
//};

//self.InitHandsonTableFases = function (inHdsn, data, altura, arrMergeCells, boolDisableContextMenu, boolAddNewLines) {
//    try {
//        var inDadosHT = self.RetornaColunasHTFases();
//        if (inDadosHT !== undefined && inDadosHT.data !== null) {
//            var hdsn = HandsonTableDesenhaNovo(inHdsn, data, null, inDadosHT, boolAddNewLines, null, null, true, null, null, false, null, null, ListaColunasFases);
//            hdsn.updateSettings({
//                beforeChange: function (changes, source) {
//                    if (source == constSourceHT.Edit && (changes[0][1] == "Data")) {
//                        if (!UtilsVerificaObjetoNotNullUndefined(changes[0][2])) {
//                            if (changes[0][3] != "") {
//                                changes[0][3] = changes[0][3] + " 00:00";
//                            }
//                        } else if (UtilsVerificaObjetoNotNullUndefined(changes[0][2]) && UtilsVerificaObjetoNotNullUndefined(changes[0][2].split(" ")[1])) {
//                            changes[0][3] = changes[0][3].split(" ")[0];
//                            if (changes[0][3].split(" ").length > 1) {
//                                changes[0][3] = changes[0][3].split(" ")[0] + " " + changes[0][2].split(" ")[1]
//                            } else {
//                                changes[0][3] = changes[0][3] + " 00:00";
//                            }
//                        }
//                    }
//                },
//                afterChange: function (changes, source) {
//                    if (source === constSourceHT.LoadData) { return; }

//                    if (source == constSourceHT.Edit && (changes[0][1] == "Observacoes")) {
//                        var ColEditor = hdsn.getActiveEditor();
//                        var ColEditorProp = (ColEditor != undefined) ? ColEditor.prop : null;
//                        var ColEditorOpened = (ColEditor != undefined) ? ColEditor._opened : null;
//                        var ColEditorRow = (ColEditor != undefined) ? ColEditor.row : null;
//                        var ColEditorCol = (ColEditor != undefined) ? ColEditor.col : null;

//                        var ID = hdsn.getSourceDataAtRow(ColEditorRow).ID;
//                        var linha = hdsn.getSourceData().filter(function (f) {
//                            return f.ID == ID;
//                        })[0];

//                        var acao = (linha.ID === 0) ? constEstados.Adicionar : constEstados.Alterar;

//                        if (changes[0][3] === "") { acao = constEstados.Remover; }

//                        linha.AcaoCRUD = acao;
//                    }

//                    self.AtivaDirty();
//                },
//                readOnly: DisableViaEstado
//            });

//            var value = parseInt($('#' + inHdsn).find('.ht_master .wtHider').css('height').replace("px", ""));
//            hdsn.updateSettings({
//                height: value + 7
//            });
//        }
//    } catch (ex) {
//        throw ex;
//    }
//};

//self.RetornaColunasHTFases = function () {
//    try {
//        return [{
//            ID: "Descricao",
//            TipoEditor: constTipoCompoHT.F3MTexto,
//            Label: resources["Descricao"],
//            width: 150,
//            readOnly: DisableViaEstado || true
//        }, {
//            ID: "Data",
//            TipoEditor: constTipoCompoHT.F3MTexto,
//            Label: resources["Data"],
//            width: 150,
//            //validator: self.dateValidator,
//            //allowInvalid: true,
//            readOnly: true
//        }, {
//            ID: "UtilizadorCriacao",
//            TipoEditor: constTipoCompoHT.F3MTexto,
//            Label: resources["Utilizador"],
//            width: 100,
//            readOnly: DisableViaEstado || true
//        }, {
//            ID: "Observacoes",
//            TipoEditor: constTipoCompoHT.F3MTexto,
//            Label: resources["Observacoes"],
//            width: 500,
//            readOnly: false
//        }];
//    } catch (ex) {
//        throw ex;
//    }
//}

//self.ExpandeFoles = function (inExpande) {
//    try {
//        var folesElem = $('#accordionFases');
//        var foles = folesElem.find('.collapse');
//        (inExpande) ? foles.collapse('show') : foles.collapse('hide');
//    } catch (ex) {
//        throw ex;
//    }
//}