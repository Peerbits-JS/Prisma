"use strict";

var $docsservicossubstituicaocatalogolentes = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    var constCamposGen = base.constantes.camposGenericos;
    var campoID = constCamposGen.ID;
    var campoDesc = constCamposGen.Descricao;
    var campoIDArt = constCamposGen.IDArtigo;
    var campoAcaoCRUD = constCamposGen.AcaoCRUD;

    var constCamposOF = base.constantes.camposObjetoFiltro;
    var camposFiltrarID = constCamposOF.CamposFiltrar;
    var campoValorID = constCamposOF.CampoValor;
    var campoTextoID = constCamposOF.CampoTexto;
    var constTipoCompoHT = base.constantes.ComponentesHT;
    var constEstados = base.constantes.EstadoFormEAcessos;

    var catalogoLentesPath = './CatalogosLentesServicosSubstituicao/';
    var tabelasAuxliaresPath = '../TabelasAuxiliares/';
    var numElementos = 3;
    var numRegistos = 1000;

    var BOOL_LENTES_OFTALMICAS = true;
    var LABEL_CLICKED = '';
    var FIRST = true;
    var modelo = [];

    var globalHT = null;
    var boolVemDaHT = false;
    var IDModeloDaHT = null;
    var IDTratamentoDaHT = null;
    var IDCorDaHT = null;

    var listView = {
        Marcas: 'F3MListViewMarcas',
        TiposLentes: 'F3MListViewTiposLentes',
        MateriasLentes: 'F3MListViewMateriasLentes',
        Modelos: 'F3MListViewModelosArtigos',
        Tratamentos: 'F3MListViewTratamentosLentes',
        Cores: 'F3MListViewCoresLentes',
        Suplementos: 'F3MListViewSuplementosLentes',
        Indices: 'F3MListViewIndices'
    };

    var servicoIDMarca = null;
    var servicoIDMateria = null;
    var servicoIDTipoLente = null;
    var servicoIDModelo = null;
    var servicoIDTratamento = null;
    var servicoIDCor = null;
    var servicoIDsSuplementos = [];

    var PotenciaEsfericaOE = 0;
    var PotenciaCilindricaOE = 0;
    var PotenciaEsfericaOD = 0;
    var PotenciaCilindricaOD = 0;
    var PotenciaPrismatica = 0;
    var Adicao = 0;
    var Eixo = 0;
    var Raio = 0;
    var IDTipoGraduacao = null;
    var IDTipoOlho = null;
    var IDTipoServico = null;

    var TipoDeLente = "LO"; //LENTES OFTÁLMICAS || LENTES DE CONTATO
    var GlobalSelectedRow = 0;
    //#endregion

    //constantes tipos de olho
    var TipoOlho = {
        Direito: 1,
        Esquerdo: 2,
    };

    var HDSNID = 'opcoesHT';

    //#region 'Init'
    self.Init = function () {
        if (window.parent.$docsservicossubstituicaoartigos) {
            self.BoundInit();
        }
    };

    self.BoundInit = () => {
        self.GetDataFromParent();

        let hdsn = window.parent.$docsservicossubstituicaoartigos.ajax.GetHdsnInstance();
        let data = hdsn.getSourceDataAtRow(hdsn.getSelected()[0][0]);

        var objetoFiltro = [];

        objetoFiltro['Diametro'] = data.DiametroDestino;
        $('#txtDiametro').val(data.DiametroDestino);

        objetoFiltro['IDMarca'] = data.IDMarca;
        servicoIDMarca = data.IDMarca;

        objetoFiltro['IDTipoLente'] = data.IDTipoLente;

        if (IDTipoServico == 6) {
            TipoDeLente = "LC"
        }
        objetoFiltro['TipoDeLente'] = TipoDeLente;

        servicoIDTipoLente = data.IDTipoLente;

        objetoFiltro['IDMateriaLente'] = BOOL_LENTES_OFTALMICAS ? data.IDMateria : null;
        servicoIDMateria = BOOL_LENTES_OFTALMICAS ? data.IDMateria : null;

        objetoFiltro['IndiceRefracao'] = data.IndiceRefracao;
        objetoFiltro['Fotocromatica'] = data.Fotocromatica;

        objetoFiltro['IDModelo'] = data.IDModelo;
        servicoIDModelo = data.IDModelo;

        objetoFiltro['IDTratamentoLente'] = BOOL_LENTES_OFTALMICAS ? data.IDTratamentoLente : null;
        servicoIDTratamento = BOOL_LENTES_OFTALMICAS ? data.IDTratamentoLente : null;

        objetoFiltro['IDCorLente'] = BOOL_LENTES_OFTALMICAS ? data.IDCorLente : null;
        servicoIDCor = BOOL_LENTES_OFTALMICAS ? data.IDCorLente : null;

        $('#fotocromatica').prop('checked', data.Fotocromatica);

        objetoFiltro['IDsSuplementos'] = BOOL_LENTES_OFTALMICAS && data.IDsSuplementos != null ? data.IDsSuplementos.join("-") : null;
        servicoIDsSuplementos = BOOL_LENTES_OFTALMICAS ? data.IDsSuplementos : [];

        //--
        objetoFiltro['PotenciaCilindricaOE'] = PotenciaCilindricaOE;
        objetoFiltro['PotenciaEsfericaOE'] = PotenciaEsfericaOE;
        objetoFiltro['PotenciaCilindricaOD'] = PotenciaCilindricaOD;
        objetoFiltro['PotenciaEsfericaOD'] = PotenciaEsfericaOD;


        //--
        objetoFiltro['IDTipoServico'] = IDTipoServico;
        objetoFiltro['IDTipoOlho'] = IDTipoOlho;
        objetoFiltro['IDTipoGraduacao'] = IDTipoGraduacao;

        //--
        objetoFiltro['PotenciaPrismatica'] = PotenciaPrismatica
        objetoFiltro['Adicao'] = Adicao;
        objetoFiltro['Eixo'] = Eixo;
        objetoFiltro['Raio'] = Raio;

        self.ConfiguraJanela(function () {
            if (UtilsVerificaObjetoNotNullUndefined(servicoIDModelo)) {
                boolVemDaHT = true;

                self.GetPrecosConstroiHT(objetoFiltro, true);
            }
            else {
                self.ConstroiHT();
                //self.ConfiguraJanela();
            }
        });

        FIRST = false;

        $('.search').on('input', function (e) {
            var filterType = $(e.currentTarget.parentElement).find('.active').attr('id').replace('op', '');
            self.Filter($(e.currentTarget).attr('id'), $(e.currentTarget).val(), filterType);

            return false;
        });

        $('#btnReset').on('click', function () {
            $('#marcas').val('');
            self.ControiListViews();
            self.gridHTDesseletRow();

            return false;
        });

        $('.menuMarcas').on('click', function (e) {
            self.Filter('marcas', $('#marcas').val(), self.MenuFilter(e));

            return false;
        });

        $('.menuModelos').on('click', function (e) {
            self.Filter('modelos', $('#modelos').val(), self.MenuFilter(e));

            return false;
        });

        $('.menuTratamentos').on('click', function (e) {
            self.Filter('tratamentos', $('#tratamentos').val(), self.MenuFilter(e));

            return false;
        });

        $('.menuCores').on('click', function (e) {
            self.Filter('cores', $('#cores').val(), self.MenuFilter(e));

            return false;
        });

        $('.menuSuplementos').on('click', function (e) {
            self.Filter('suplementos', $('#suplementos').val(), self.MenuFilter(e));

            return false;
        });

        $('#novaOpcao').on('click', function (e) {
            self.AddNewLine(true);

            return false;
        });

        $('#btConfirm').on('click', function (e) {
            self.PassaValores();

            return false;
        });

        $('#txtDiametro').bind('keyup input', function (e) {
            var msgErroID = base.constantes.janelasPopupIDs.Erro;
            var winErrors = $('#' + msgErroID).data('kendoWindow');

            if (UtilsVerificaObjetoNotNullUndefined(winErrors)) {
                if (winErrors.options.visible == true && $(e.currentTarget).val() != '') {
                    winErrors.close()
                    $('#txtDiametro').removeClass('input-error').addClass('obrigatorio');
                }
            }

            globalHT != null && globalHT != undefined ? globalHT.deselectCell() : false;
            boolVemDaHT = false;
            IDModeloDaHT = null;
            IDTratamentoDaHT = null;
            IDCorDaHT = null;
            GlobalSelectedRow = null;

            return false;
        });

        $('#txtDiametro').on('blur', function (e) {
            var max = parseInt($(e.currentTarget).attr('max'));
            var min = parseInt($(e.currentTarget).attr('min'));
            var val = parseInt($(e.currentTarget).val());
            if (val > max || val < min) {
                $(e.currentTarget).val((val > max) ? max : min)
            }

            return false;
        });

        //D I S A B L E   E N T E R   K E Y
        $('input').keydown(function (event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                return false;
            }
        });

        $('#fotocromatica').on('change', self.FotocromaticaChange);
    };

    //#endregion 

    //#region 'List Views (Controi // Change's // Clear)'
    self.ControiListViews = function (funcSuccessCallback) {
        $('#novaOpcao').attr('disabled', 'disabled');

        var paramsMarcas = { origem: BOOL_LENTES_OFTALMICAS ? 'lo' : 'lc' };
        listViewConstroi(listView.Marcas, catalogoLentesPath + 'LerMarcas', paramsMarcas, numRegistos, false, () => { }, boolVemDaHT, servicoIDMarca, true, null, function () {

            $("#" + listView.Marcas).undelegate().delegate('.items', 'click', function (e) {
                self.ClickOnListView(e, this, listView.Marcas);
                return false;
            });

            var paramsTiposLentes = {
                IDTipoLenteClassificacao: BOOL_LENTES_OFTALMICAS == true ? $('#IDTipoLenteOftalmica').val() : $('#IDTipoLenteContato').val(),
                IDTipoServico: BOOL_LENTES_OFTALMICAS == true ? IDTipoServico : 0,
                IDTipoOlho: BOOL_LENTES_OFTALMICAS === true ? IDTipoOlho : 0
            };

            listViewConstroi(listView.TiposLentes, catalogoLentesPath + 'LerTiposLentes', paramsTiposLentes, numRegistos, false, () => { }, boolVemDaHT, servicoIDTipoLente, true, null, function () {

                $("#" + listView.TiposLentes).undelegate().delegate('.items', 'click', function (e) {
                    self.ClickOnListView(e, this, listView.TiposLentes);
                    return false;
                });

                if (BOOL_LENTES_OFTALMICAS) {
                    listViewConstroi(listView.MateriasLentes, catalogoLentesPath + 'LerMateriasLentes', null, numRegistos, false, () => { }, boolVemDaHT, servicoIDMateria, true, null, function () {
                        $("#" + listView.MateriasLentes).undelegate().delegate('.items', 'click', function (e) {
                            self.ClickOnListView(e, this, listView.MateriasLentes);
                            return false;
                        });
                        self.ClearListViews(true);
                        if (typeof (funcSuccessCallback) === 'function') {
                            funcSuccessCallback();
                        }
                    });
                }
                else {
                    self.ClearListViews(true);
                    if (typeof (funcSuccessCallback) === 'function') {
                        funcSuccessCallback();
                    }
                }
            });
        });
    };

    self.MarcasChange = function (e) {
        $('#' + listView.Modelos).unbind();

        let IDMarcasSelected = listViewGetIDSelected(listView.Marcas);
        let IDTiposLentesSelected = listViewGetIDSelected(listView.TiposLentes);
        let indice = self.getDataItemSelected(listView.Indices, "IndiceRefracaoAux");
        let fotocromatica = $('#fotocromatica').is(':checked');

        if (BOOL_LENTES_OFTALMICAS) {
            var IDMateriasLentesSelected = listViewGetIDSelected(listView.MateriasLentes);

            if (IDMarcasSelected == 0 || IDTiposLentesSelected == 0 || IDMateriasLentesSelected == 0) {
                $('#lblModelos').attr('disabled', 'disabled');

                $('#modelos').val('');
                $('#modelos').attr('disabled', 'disabled');

            }
            else {
                $('#lblModelos').removeAttr('disabled');
                $('#modelos').removeAttr('disabled');
                $('#btModelos').removeAttr('disabled');
                $('#btModelos').removeAttr('disabled');
            }
        }
        else {
            if (IDMarcasSelected == 0 || IDTiposLentesSelected == 0) {
                $('#lblModelos').attr('disabled', 'disabled');

                $('#modelos').val('');
                $('#modelos').attr('disabled', 'disabled');
                $('#btModelos').attr('disabled', 'disabled');
            }
            else {
                $('#lblModelos').removeAttr('disabled');
                $('#modelos').removeAttr('disabled');
                $('#btModelos').removeAttr('disabled');
            }
        }

        self.gridHTDesseletRow();

        if (IDMarcasSelected != 0 && IDTiposLentesSelected != 0 && IDMateriasLentesSelected != 0) {
            self.Constroi();

            listViewConstroi(listView.Modelos, catalogoLentesPath + 'LerModelos', self.GetParamsListViewModelos(), numRegistos, false, () => { }, boolVemDaHT, servicoIDModelo, true, null, function () {
            });

            $("#" + listView.Modelos).undelegate().delegate('.items', 'click', function (e) {
                self.ClickOnListView(e, this, listView.Modelos);
                return false;
            });

            if (!boolVemDaHT) {
                var filterType = $('#modelos').parent().find('.active').attr('id').replace('op', '');
                self.Filter('modelos', $('#modelos').val(), filterType);
            }
        }

        self.ClearListViews(false);

        $('#hdfIDMarca').val(IDMarcasSelected);
        $('#hdfIDTipoLente').val(IDTiposLentesSelected);
        $('#hdfIDMateriaLente').val(IDMateriasLentesSelected);
    };

    self.ModelosChange = function (data) {
        if (BOOL_LENTES_OFTALMICAS) {
            var IDModeloSelected = listViewGetIDSelected(listView.Modelos);
            var IDMarcaSelected = listViewGetIDSelected(listView.Marcas)
            var IDTipoLenteSelected = listViewGetIDSelected(listView.TiposLentes);
            var IDMateriaSelected = listViewGetIDSelected(listView.MateriasLentes);

            var params = {
                IDModelo: parseInt(IDModeloSelected)
            }

            var paramsSuplementos = {
                IDModelo: IDModeloSelected,
                IDMarca: IDMarcaSelected,
                IDTiposLentes: IDTipoLenteSelected,
                IDMateriaLentes: IDMateriaSelected
            };

            if (IDModeloSelected != 0 && IDMarcaSelected != 0 && IDTipoLenteSelected != 0 && IDMateriaSelected != 0) {
                let IndiceRefracao = self.getDataItemSelected(listView.Modelos, "IndiceRefracao");
                self.setSelected(listView.Indices, "IndiceRefracao", IndiceRefracao);

                $('#novaOpcao').removeAttr('disabled');
                $('#btConfirm').removeAttr('disabled');
                $('#modelos').removeAttr('disabled');

                self.gridHTDesseletRow();

                listViewConstroi(listView.Cores, catalogoLentesPath + 'LerCores', paramsSuplementos, numRegistos, false, null, boolVemDaHT, servicoIDCor, true, null, function () {
                    if (data) {
                        self.setSelected(listView.Cores, "ID", data.IDCorLente);
                    }
                });

                if (!boolVemDaHT) {
                    var filterTypeCores = $('#cores').parent().find('.active').attr('id').replace('op', '');
                    self.Filter('cores', $('#cores').val(), filterTypeCores);
                }

                $("#" + listView.Cores).undelegate().delegate('.items', 'click', function (e) {
                    self.ClickOnListView(e, this, listView.Cores);
                    return false;
                });

                listViewConstroi(listView.Tratamentos, catalogoLentesPath + 'LerTratamentos', params, numRegistos, false, null, boolVemDaHT, servicoIDTratamento, true, null, function () {
                    if (data) {
                        self.setSelected(listView.Tratamentos, "ID", data.IDTratamentoLente);
                    }

                });

                if (!boolVemDaHT) {
                    var filterTypeTratamentos = $('#tratamentos').parent().find('.active').attr('id').replace('op', '');
                    self.Filter('tratamentos', $('#tratamentos').val(), filterTypeTratamentos);
                }

                $("#" + listView.Tratamentos).undelegate().delegate('.items', 'click', function (e) {
                    self.ClickOnListView(e, this, listView.Tratamentos);
                    return false;
                });

                listViewConstroi(listView.Suplementos, catalogoLentesPath + 'LerSuplementos', paramsSuplementos, numRegistos, true, null, boolVemDaHT, servicoIDsSuplementos, false, true, function () {
                    if (data) {
                        self.setSelected(listView.Suplementos, "ID", data.IDsSuplementos);
                    }
                });

                if (!boolVemDaHT) {
                    var filterTypeSuplementos = $('#suplementos').parent().find('.active').attr('id').replace('op', '');
                    self.Filter('suplementos', $('#suplementos').val(), filterTypeSuplementos);
                }

                $("#" + listView.Suplementos).undelegate().delegate('.items', 'click', function () {
                    $(this).toggleClass('k-state-selected');
                    self.ClickOnListViewDesselectRow(listView.Suplementos);
                    return false;
                });

                $('#lblCores').removeAttr('disabled');
                $('#lblTratamentos').removeAttr('disabled');
                $('#lblSuplementos').removeAttr('disabled');

                $('.btsLO').removeAttr('disabled');
            }
            else {
                $('#novaOpcao').attr('disabled', 'disabled');
                self.ClearListViews(false);
            }
        }
        else {
            $('#novaOpcao').removeAttr('disabled');
            $('#btConfirm').removeAttr('disabled');

            let IndiceRefracao = self.getDataItemSelected(listView.Modelos, "IndiceRefracao");
            self.setSelected(listView.Indices, "IndiceRefracao", IndiceRefracao);
        }
        $('#hdfIDModelo').val(IDModeloSelected);
        $('#hdfDescricaoModelo').val(self.GetDescricaoSelected(listView.Modelos));
    };

    self.ClearListViews = function (boolClearModelos) {
        listViewClearData(listView.Tratamentos);
        listViewClearData(listView.Cores);
        listViewClearData(listView.Suplementos);

        if (boolClearModelos === true) {
            listViewClearData(listView.Indices);
            listViewClearData(listView.Modelos);
            $('#lblModelos').attr('disabled', 'disabled');

            $('#modelos').val('');
            $('#modelos').attr('disabled', 'disabled');
            $('#btModelos').attr('disabled', 'disabled');
        }

        $('#lblCores').attr('disabled', 'disabled');
        $('#lblTratamentos').attr('disabled', 'disabled');
        $('#lblSuplementos').attr('disabled', 'disabled');

        $('#cores').val('');
        $('#cores').attr('disabled', 'disabled');

        $('#tratamentos').val('');
        $('#tratamentos').attr('disabled', 'disabled');

        $('#suplementos').val('');
        $('#suplementos').attr('disabled', 'disabled');

        $('.btsLO').attr('disabled', 'disabled');
    };
    //#endregion

    //#region 'Handsontable (Colunas / ContextMenu / DesenhaNovo)'
    self.ConstroiHT = function () {
        var gridHT = HandsonTableDesenhaNovo('opcoesHT', modelo, null, self.RetornaColunasHT(), false, null, null, true);

        gridHT.updateSettings({
            manualColumnResize: false,
            manualRowResize: false,
            columnSorting: false,
            afterOnCellMouseDown: function (e, coords, td) {
                if (coords.row != -1 && coords.row != GlobalSelectedRow) {
                    self.ClearFilters();

                    boolVemDaHT = true;
                    $('#txtDiametro').val(gridHT.getSourceData()[coords.row].Diametro);
                    servicoIDModelo = gridHT.getSourceData()[coords.row].IDModelo;
                    servicoIDTratamento = gridHT.getSourceData()[coords.row].IDTratamentoLente;
                    servicoIDCor = gridHT.getSourceData()[coords.row].IDCorLente;
                    servicoIDsSuplementos = gridHT.getSourceData()[coords.row].IDsSuplementos;

                    listViewSetIDSelected(listView.Marcas, gridHT.getSourceData()[coords.row].IDMarca);
                    listViewSetIDSelected(listView.TiposLentes, gridHT.getSourceData()[coords.row].IDTipoLenteSelected);
                    listViewSetIDSelected(listView.MateriasLentes, gridHT.getSourceData()[coords.row].IDMateriaLenteSelected);
                    $('#fotocromatica').prop('checked', gridHT.getSourceData()[coords.row].Fotocromatica);

                    debugger

                    self.Constroi(function () {
                        self.setSelected(listView.Indices, "IndiceRefracaoAux", gridHT.getSourceData()[coords.row].IndiceRefracao);

                        listViewConstroi(listView.Modelos, catalogoLentesPath + 'LerModelos', self.GetParamsListViewModelos(), numRegistos, false, () => { }, boolVemDaHT, servicoIDModelo, true, null, function () {
                            self.ModelosChange();
                            $('#btConfirm').removeAttr('disabled');
                        });
                    });

                    GlobalSelectedRow = coords.row;
                }
            }
        });

        HandsonTableStretchHTWidthToContainer();

        HandsonTableStretchHTHeight('opcoesHT', 50);


        globalHT = gridHT;
    };

    self.RetornaColunasHT = function () {
        return [
            {
                ID: 'Diametro',
                Label: 'Ø',
                TipoEditor: constTipoCompoHT.F3MNumero,
                CasasDecimais: 2,
                readOnly: true,
                width: 50
            },
            {
                ID: 'DescricaoMarca',
                Label: resources['Marca'],
                TipoEditor: constTipoCompoHT.F3MTexto,
                readOnly: true,
                width: 100
            },
            {
                ID: campoDesc,
                Label: resources[campoDesc],
                TipoEditor: constTipoCompoHT.F3MTexto,
                readOnly: true,
                width: 150
            }
        ]
    };
    //#endregion

    //#region 'Handsontable Functions'
    self.AddNewLine = function (boolControiHT) {
        var Diametro = $('#txtDiametro').val();

        var IDMarcaSelected = listViewGetIDSelected(listView.Marcas);
        var IDTipoLenteSelected = listViewGetIDSelected(listView.TiposLentes);
        var IDModeloSelected = listViewGetIDSelected(listView.Modelos);

        if (BOOL_LENTES_OFTALMICAS) {
            var IDMateriaLenteSelected = listViewGetIDSelected(listView.MateriasLentes);
            var IDTratamentoSelected = listViewGetIDSelected(listView.Tratamentos);
            var IDCorSelected = listViewGetIDSelected(listView.Cores);

            //SUPLEMENTOS
            var SelectedSups = $($('#' + listView.Suplementos).data('kendoListView').element[0]).find('.items.k-state-selected');
            var SupsDs = $('#' + listView.Suplementos).data('kendoListView').dataSource.view();
            var sups = [];
            var strSups = '';

            for (var i = 0; i < SelectedSups.length; i++) {
                var data = $.grep(SupsDs, function (obj, j) {
                    return obj.uid == $(SelectedSups[i]).attr('data-uid');
                })

                sups.push(data[0][campoID]);
            }

            strSups = sups.join('-');
        }

        if (Diametro != '' && IDModeloSelected != 0) {
            boolVemDaHT = true;

            var objetoFiltro = [];

            objetoFiltro['Diametro'] = Diametro;
            objetoFiltro['IDMarca'] = IDMarcaSelected;
            objetoFiltro['IDTipoLente'] = IDTipoLenteSelected;
            objetoFiltro['IDMateriaLente'] = BOOL_LENTES_OFTALMICAS ? IDMateriaLenteSelected : null;

            objetoFiltro['Fotocromatica'] = $('#fotocromatica').is(':checked');
            objetoFiltro['IndiceRefracao'] = self.getDataItemSelected(listView.Indices, "IndiceRefracaoAux");

            objetoFiltro['IDModelo'] = IDModeloSelected;
            objetoFiltro['IDTratamentoLente'] = BOOL_LENTES_OFTALMICAS ? IDTratamentoSelected : null;
            objetoFiltro['IDCorLente'] = BOOL_LENTES_OFTALMICAS ? IDCorSelected : null;
            objetoFiltro['IDsSuplementos'] = BOOL_LENTES_OFTALMICAS ? strSups : null;

            objetoFiltro['PotenciaCilindricaOE'] = PotenciaCilindricaOE;
            objetoFiltro['PotenciaEsfericaOE'] = PotenciaEsfericaOE;

            objetoFiltro['PotenciaCilindricaOD'] = PotenciaCilindricaOD;
            objetoFiltro['PotenciaEsfericaOD'] = PotenciaEsfericaOD;
            objetoFiltro['TipoDeLente'] = TipoDeLente;

            //--
            objetoFiltro['IDTipoOlho'] = IDTipoOlho;
            objetoFiltro['IDTipoGraduacao'] = IDTipoGraduacao;

            //--
            objetoFiltro['PotenciaPrismatica'] = PotenciaPrismatica
            objetoFiltro['Adicao'] = Adicao;
            objetoFiltro['Eixo'] = Eixo;
            objetoFiltro['Raio'] = Raio;
            //--
            self.GetPrecosConstroiHT(objetoFiltro, boolControiHT);
        }
        else {
            GrelhaUtilsValida($('#catalogoLentes'));
            $('#txtDiametro').removeClass('obrigatorio').addClass('input-error');
        }
    };

    self.GetPrecosConstroiHT = function (objetoFiltro, boolConstroiHT) {
        var UrlAux = window.location.pathname + '/GetPrecos';
        var dadosJSON = JSON.stringify(HandsonTableEnviaParamsHT(objetoFiltro));

        UtilsChamadaAjax(UrlAux, true, dadosJSON,
            function (res) {
                if (!UtilsVerificaObjetoNotNullUndefined(res.Errors)) {
                    modelo.unshift(res);

                    if (modelo.length > numElementos) {
                        modelo.pop();
                    }

                    if (boolConstroiHT == true) {
                        self.ConstroiHT();
                        globalHT.selectCell(0, 0);

                        $('#txtDiametro').val(globalHT.getSourceData()[0].Diametro);
                        servicoIDModelo = globalHT.getSourceData()[0].IDModelo;
                        servicoIDTratamento = globalHT.getSourceData()[0].IDTratamentoLente;
                        servicoIDCor = globalHT.getSourceData()[0].IDCorLente;
                        servicoIDsSuplementos = globalHT.getSourceData()[0].IDsSuplementos;

                        listViewSetIDSelected(listView.Marcas, globalHT.getSourceData()[0].IDMarca);
                        listViewSetIDSelected(listView.TiposLentes, globalHT.getSourceData()[0].IDTipoLenteSelected);
                        listViewSetIDSelected(listView.MateriasLentes, globalHT.getSourceData()[0].IDMateriaLenteSelected);
                        $('#fotocromatica').prop('checked', globalHT.getSourceData()[0].Fotocromatica);

                        self.Constroi(function () {
                            self.setSelected(listView.Indices, "IndiceRefracaoAux", globalHT.getSourceData()[0].IndiceRefracao);

                            listViewConstroi(listView.Modelos, catalogoLentesPath + 'LerModelos', self.GetParamsListViewModelos(), numRegistos, false, () => { }, true, servicoIDModelo, true, null, function () {
                                self.ModelosChange();

                                $('#btConfirm').removeAttr('disabled');
                            });
                        });
                    }
                    else {
                        self.SetValues(res);
                    }
                }
                else {
                    var msg = res.Errors[0].Mensagem;
                    UtilsAlerta(base.constantes.tpalerta.error, msg);
                }
            },
            function () { return false; }, 1, true);
    };

    self.gridHTDesseletRow = function () {
        if (!boolVemDaHT && globalHT != null && globalHT.getDataAtCell(0, 0) != null) {
            globalHT.deselectCell();
            //$('#btConfirm').attr('disabled', 'disabled');
        }
    };
    //#endregion

    //#region 'Envia Parametros // FuncEspAdicionaF4 // ValidaEGravaEspecificoListView'
    self.ModeloEnviaParams = function (objetoFiltro) {
        var IDMarca = window.parent.listViewGetIDSelected(listView.Marcas)
        var IDTipoLente = window.parent.listViewGetIDSelected(listView.TiposLentes);
        var IDMateria = window.parent.listViewGetIDSelected(listView.MateriasLentes);
        var IndiceRefracao = window.parent.$docsservicossubstituicaocatalogolentes.ajax.getDataItemSelected(listView.Indices, "IndiceRefracaoAux");
        var Fotocromatica = window.parent.$('#fotocromatica').is(':checked');

        var objAuxCatalogoLentes = {};
        var objAuxLenteOftalmica = {};
        var objAuxMarcas = {};
        var objAuxTiposLentes = {};
        var objAuxMateria = {};
        var objAuxIndiceRefracao = {};
        var objAuxFotocromatica = {};

        objAuxCatalogoLentes[campoValorID] = true;
        objAuxCatalogoLentes[campoTextoID] = true;
        objetoFiltro[camposFiltrarID]['catalogolentes'] = objAuxCatalogoLentes;

        objAuxLenteOftalmica[campoValorID] = window.parent.$docsservicossubstituicaocatalogolentes.ajax.GetTipoArtigo();
        objAuxLenteOftalmica[campoTextoID] = window.parent.$docsservicossubstituicaocatalogolentes.ajax.GetTipoArtigo();
        objetoFiltro[camposFiltrarID]['boolLentesOftalmicas'] = objAuxLenteOftalmica;

        objAuxMarcas[campoValorID] = IDMarca;
        objAuxMarcas[campoTextoID] = IDMarca;
        objetoFiltro[camposFiltrarID]['IDMarca'] = objAuxMarcas;

        objAuxTiposLentes[campoValorID] = IDTipoLente;
        objAuxTiposLentes[campoTextoID] = IDTipoLente;
        objetoFiltro[camposFiltrarID]['IDTipoLente'] = objAuxTiposLentes;

        objAuxMateria[campoValorID] = IDMateria;
        objAuxMateria[campoTextoID] = IDMateria;
        objetoFiltro[camposFiltrarID]['IDMateria'] = objAuxMateria;

        if (IndiceRefracao != null) {
            objAuxIndiceRefracao[campoValorID] = IndiceRefracao;
            objAuxIndiceRefracao[campoTextoID] = IndiceRefracao;
            objetoFiltro[camposFiltrarID]['IndiceRefracao'] = objAuxIndiceRefracao;
        }

        objAuxFotocromatica[campoValorID] = Fotocromatica;
        objAuxFotocromatica[campoTextoID] = Fotocromatica;
        objetoFiltro[camposFiltrarID]['Fotocromatica'] = objAuxFotocromatica;

        return objetoFiltro;
    };

    self.EnviaParamsIDModelo = function (objetoFiltro) {
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'catalogolentes', '', true);

        let IDModelo = listViewGetIDSelected(listView.Modelos);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDModelo', '', IDModelo);

        let IDMarca = listViewGetIDSelected(listView.Marcas);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDMarca', '', IDMarca);

        let IDTipoLente = listViewGetIDSelected(listView.TiposLentes);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDTipoLente', '', IDTipoLente);

        let IDMateriaLente = listViewGetIDSelected(listView.MateriasLentes);
        GrelhaUtilsPreencheObjetoFiltroValor(objetoFiltro, true, 'IDMateriaLente', '', IDMateriaLente);

        return objetoFiltro;
    };

    self.ValidaEGravaEspecificoListView = function (elem, url, model, elemID, combo, janela, tabID, iFrame, gridParameterObj) {
        var erros = GrelhaUtilsValida(elem);
        var iFrameAux;
        var lst = '';

        if (erros === null) {
            var ObjParameterMap = gridParameterObj;
            var data = JSON.stringify($.extend(ObjParameterMap, { modelo: model }))
            UtilsChamadaAjax(url, true, data,
                function (resultado) {
                    if (UtilsMostraListaErros(resultado) === null) {

                        F4ValidaEGravaSucesso(resultado.ResultDataSource.Data[0], url, elemID, combo, janela, tabID);
                        self.ClearFilters();

                        if (iFrame[0].contentWindow.$('#ServicosArtigos').val() == 'True') {
                            iFrameAux = iFrame[0].contentWindow.$('#janelaMenu').find('.k-content-frame')[0];
                            if (UtilsVerificaObjetoNotNullUndefined(iFrameAux)) {
                                lst = iFrameAux.contentWindow.$docsservicossubstituicaocatalogolentes.ajax.GetLabelClicked().replace('lbl', '');
                                iFrameAux.contentWindow.$('#janelaMenu').data('kendoWindow').close();
                            }
                        }
                        else {
                            iFrameAux = iFrame[0];
                            if (UtilsVerificaObjetoNotNullUndefined(iFrameAux)) {
                                iFrameAux.contentWindow.$('#janelaMenu').data('kendoWindow').close();
                                lst = iFrameAux.contentWindow.$docsservicossubstituicaocatalogolentes.ajax.GetLabelClicked().replace('lbl', '');
                            }
                        }

                        switch (lst) {
                            case 'Modelos':
                                var paramsModelos = {
                                    LenteOftalmica: self.GetTipoArtigo(),
                                    IDMarca: model.IDMarca,
                                    IDTiposLentes: model.IDTipoLente,
                                    IDMateriaLentes: model.IDMateriaLente,
                                    Fotocromatica: model.Fotocromatica,
                                    IndiceRefracao: model.IndiceRefracao
                                };

                                iFrameAux.contentWindow.listViewConstroi(listView.Modelos, catalogoLentesPath + 'LerModelos', paramsModelos, numRegistos, false, iFrameAux.contentWindow.$catalogolentes.ajax.ModelosChange, true, resultado.ResultDataSource.Data[0][campoID], true);
                                break;

                            case 'Tratamentos':
                                iFrameAux.contentWindow.listViewConstroi(listView.Tratamentos, catalogoLentesPath + 'LerTratamentos', { IDModelo: parseInt(model.IDModelo) }, numRegistos, false, null, true, resultado.ResultDataSource.Data[0][campoID], true);
                                break;

                            case 'Cores':
                                var paramsSuplementos = {
                                    IDModelo: model.IDModelo,
                                    IDMarca: model.IDMarca,
                                    IDTiposLentes: model.IDTipoLente,
                                    IDMateriaLentes: model.IDMateriaLente
                                };

                                iFrameAux.contentWindow.listViewConstroi(listView.Suplementos, catalogoLentesPath + 'LerCores', paramsSuplementos, numRegistos, true, null, true, resultado.ResultDataSource.Data[0][campoID], false);
                                break;

                            case 'Suplementos':
                                var paramsSuplementos = {
                                    IDModelo: model.IDModelo,
                                    IDMarca: model.IDMarca,
                                    IDTiposLentes: model.IDTipoLente,
                                    IDMateriaLentes: model.IDMateriaLente
                                };

                                iFrameAux.contentWindow.listViewConstroi(listView.Suplementos, catalogoLentesPath + 'LerSuplementos', paramsSuplementos, numRegistos, true, null, true, resultado.ResultDataSource.Data[0][campoID], false);
                                break;
                        }
                    }
                },
                function (f) { return false; }, 1, true, 'body');
        }
    };
    //#endregion

    //#region 'Funções Auxiliares'
    self.ChangeTiposLentes = function (bool, funcSuccessCallback) {
        var item = $('.optionLentes');

        if (bool) {
            $('.optionLentesOftalmicas').css('display', 'block');
            $('#F3MListViewIndices').removeClass('caixa-listview-meia');
            $('#F3MListViewIndices').addClass('caixa-listview-tres');
            $('#F3MListViewTiposLentes').removeClass('caixa-listview-meia');
            $('#F3MListViewTiposLentes').addClass('caixa-listview-tres');
            $('#hdfIDTipoArtigo').val($('#IDTipoLenteOftalmica').val());
            $('#hdfCodigoTipoArtigo').val('LO');
        }
        else {
            $('.optionLentesOftalmicas').css('display', 'none');
            $('#F3MListViewIndices').removeClass('caixa-listview-tres');
            $('#F3MListViewIndices').addClass('caixa-listview-meia');
            $('#F3MListViewTiposLentes').removeClass('caixa-listview-tres');
            $('#F3MListViewTiposLentes').addClass('caixa-listview-meia');
            $('#hdfIDTipoArtigo').val($('#IDTipoLenteContato').val());
            $('#hdfCodigoTipoArtigo').val('LC');
        }

        BOOL_LENTES_OFTALMICAS = bool;
        self.ControiListViews(funcSuccessCallback);
    };

    self.Filter = function (textFiler, filterValue, type) {
        var listViewFilter = '';

        switch (textFiler) {
            case 'marcas':
                listViewFilter = listView.Marcas;
                break;

            case 'modelos':
                listViewFilter = listView.Modelos;
                break;

            case 'tratamentos':
                listViewFilter = listView.Tratamentos;
                break;

            case 'cores':
                listViewFilter = listView.Cores;
                break;

            case 'suplementos':
                listViewFilter = listView.Suplementos;
                break;
        }

        listViewFilterOnDataSource(listViewFilter, campoDesc, type, filterValue);
    };

    self.LabelClick = function (e) {
        var janelaMenuLateral = base.constantes.janelasPopupIDs.Menu;
        var objData = {};
        var acao = '';

        switch ($(e).attr('id')) {
            case 'lblMarcas':
                acao = tabelasAuxliaresPath + 'Marcas';
                break;

            case 'lblModelos':
                acao = tabelasAuxliaresPath + 'ModelosArtigos/IndexGrelha'
                break;

            case 'lblTratamentos':
                acao = tabelasAuxliaresPath + 'TratamentosLentes/IndexGrelha';
                break;

            case 'lblCores':
                acao = tabelasAuxliaresPath + 'CoresLentes/IndexGrelha';
                break;

            case 'lblSuplementos':
                acao = tabelasAuxliaresPath + 'SuplementosLentes/IndexGrelha';
                break;
        }

        LABEL_CLICKED = $(e).attr('id');

        if (acao !== '') {
            JanelaDesenha(janelaMenuLateral, objData, acao, acao);
        }
    };

    self.GetTipoArtigo = function () {
        return BOOL_LENTES_OFTALMICAS;
    };

    self.GetLabelClicked = function () {
        return LABEL_CLICKED;
    };

    self.MenuFilter = function (e) {
        $(e.currentTarget.parentElement.parentElement).find('.active').removeClass('active');
        $(e.currentTarget).addClass('active');
        var filterType = $(e.currentTarget).attr('id').replace('op', '');

        return filterType;
    };

    self.GetDescricaoSelected = function (IDListView) {
        var listView = $('#' + IDListView).data('kendoListView');
        var selectedIndex = listView.select().index();
        var dataItem = listView.dataSource.view()[selectedIndex];

        return (selectedIndex == -1 || dataItem == undefined) ? '' : dataItem[campoDesc];
    };

    self.ClearFilters = function () {
        $('#marcas').val('');
        $('#modelos').val('');
        $('#tratamentos').val('');
        $('#cores').val('');
        $('#suplementos').val('');
    };

    self.ConfiguraJanela = function (funcSuccessCallback) {
            if (IDTipoServico != 6) { //!= LENTES DE CONTACTO
                $('#txtDiametro').attr('min', '0');
                $('#txtDiametro').attr('max', '100');

                self.ChangeTiposLentes(true, funcSuccessCallback);
            }
            else {
                //$('.clsF3MCatalogoLentes').addClass('lentes-contacto');
                $('#txtDiametro').attr('min', '0');
                $('#txtDiametro').attr('max', '30');

                self.ChangeTiposLentes(false, funcSuccessCallback);
            }

            //TipoDeLente = window.parent.$('#TipoDeLente').val();

        $('#btnsLentes').css('display', 'none');
            $('#spDiametro').css('visibility', 'visible');
            $('#spDiametroSymbol').css('visibility', 'visible');
            $('#htRow').css('display', 'flex');
            $('#btConfirm').css('display', 'block');
            $('#btConfirm').attr('disabled', 'disabled');
    };

    self.GetDataFromParent = () => {
        let hdsn = window.parent.$docsservicossubstituicaoartigos.ajax.GetHdsnInstance();
        let artigo = hdsn.getSourceDataAtRow(hdsn.getSelected()[0][0]);
        let grads = window.parent.$docsservicossubstituicaograds.ajax.GetGrads();
        let grad = $.grep(grads, (grad) => grad.IDTipoOlho === artigo.IDTipoOlho && grad.IDTipoGraduacao === artigo.IDTipoGraduacao)[0];

        let gradOD = $.grep(grads, (grad) => grad.IDTipoOlho === TipoOlho.Direito && grad.IDTipoGraduacao === artigo.IDTipoGraduacao)[0];
        let gradOE = $.grep(grads, (grad) => grad.IDTipoOlho === TipoOlho.Esquerdo && grad.IDTipoGraduacao === artigo.IDTipoGraduacao)[0];

        PotenciaCilindricaOD = gradOD.PotenciaCilindrica;
        PotenciaEsfericaOD = gradOD.PotenciaEsferica;

        PotenciaCilindricaOE = gradOE.PotenciaCilindrica;
        PotenciaEsfericaOE = gradOE.PotenciaEsferica;

        Adicao = grad.Adicao;
        PotenciaPrismatica = grad.PotenciaPrismatica;
        Eixo = grad.Eixo;
        Raio = grad.RaioCurvatura;

        IDTipoServico = artigo.IDTipoServico;
        IDTipoGraduacao = artigo.IDTipoGraduacao;
        IDTipoOlho = artigo.IDTipoOlho;
    };

    self.ClickOnListView = function (e, elem, LV) {
        $($(e.currentTarget.parentElement).find('.items.k-state-selected')[0]).removeClass('k-state-selected');
        $(elem).toggleClass('k-state-selected');

        self.ClickOnListViewDesselectRow(LV);
    };

    self.ClickOnListViewDesselectRow = function (LV) {
        globalHT != null && globalHT != undefined ? globalHT.deselectCell() : false;
        boolVemDaHT = false;
        IDTratamentoDaHT = null;
        IDCorDaHT = null;
        GlobalSelectedRow = null;

        switch (LV) {
            case listView.Marcas:
            case listView.TiposLentes:
            case listView.MateriasLentes:
                $('#btConfirm').attr('disabled', 'disabled');
                $('#novaOpcao').attr('disabled', 'disabled');
                self.MarcasChange();
                break;

            case listView.Modelos:
                self.ModelosChange();
                break;
        }
    };

    self.GetHdsnInstance = () => HotRegisterer.bucket[HDSNID];


    self.PassaValores = () => {
        let hdsn = self.GetHdsnInstance();
        let hdsnSelectedRow = hdsn.getSelected();

        if (hdsnSelectedRow) {
            self.SetValues(hdsn.getSourceDataAtRow(hdsnSelectedRow[0][0]));
        }
        else {
            self.AddNewLine(false);
        }
    };

    self.SetValues = (artigo) => {
        let hdsnSubstituicaoArtigos = window.parent.$docsservicossubstituicaoartigos.ajax.GetHdsnInstance();
        let artigoSubstituicaoArtigos = hdsnSubstituicaoArtigos.getSourceDataAtRow(hdsnSubstituicaoArtigos.getSelected()[0][0]);

        //set props
        artigoSubstituicaoArtigos['DiametroDestino'] = artigo['Diametro'];
        artigoSubstituicaoArtigos['IdArtigoDestino'] = artigo['IDArtigo'];

        if (artigo['CodigoArtigo'] === '') {
            artigoSubstituicaoArtigos['CodigoArtigoDestino'] = BOOL_LENTES_OFTALMICAS ? 'LO' : 'LC'
        }
        else {
            artigoSubstituicaoArtigos['CodigoArtigoDestino'] = artigo['CodigoArtigo'];
        }

        artigoSubstituicaoArtigos['CodigoBarrasArtigoDestino'] = artigo['CodigoBarrasArtigo'];
        artigoSubstituicaoArtigos['DescricaoArtigoDestino'] = artigo['Descricao'];
        artigoSubstituicaoArtigos['IDMarca'] = artigo['IDMarca'];
        artigoSubstituicaoArtigos['IDMateria'] = artigo['IDMateriaLenteSelected'];
        artigoSubstituicaoArtigos['IndiceRefracao'] = artigo['IndiceRefracao'];
        artigoSubstituicaoArtigos['Fotocromatica'] = $('#fotocromatica').is(':checked');
        artigoSubstituicaoArtigos['IDModelo'] = artigo['IDModelo'];
        artigoSubstituicaoArtigos['DescricaoModelo'] = artigo['DescricaoModelo'];
        artigoSubstituicaoArtigos['IDTipoLente'] = artigo['IDTipoLenteSelected'];
        artigoSubstituicaoArtigos['IDTratamentoLente'] = artigo['IDTratamentoLente'];
        artigoSubstituicaoArtigos['DescricaoTratamentoLente'] = artigo['DescricaoTratamentoLente'];
        artigoSubstituicaoArtigos['IDCorLente'] = artigo['IDCorLente'];
        artigoSubstituicaoArtigos['DescricaoCorLente'] = artigo['DescricaoCorLente'];
        artigoSubstituicaoArtigos['IDsSuplementos'] = artigo['IDsSuplementos'];
        artigoSubstituicaoArtigos['CustoMedioArtigoDestino'] = artigo['Medio'] || 0;
        artigoSubstituicaoArtigos['TaxaIvaArtigoDestino'] = artigo['Taxa'];

        switch (artigoSubstituicaoArtigos['IDTipoOlho']) {
            case TipoOlho.Esquerdo:
                artigoSubstituicaoArtigos['Preco'] = artigo['PrecoUnitOE'];
                break;

            case TipoOlho.Direito:
                artigoSubstituicaoArtigos['Preco'] = artigo['PrecoUnitOD'];
                break;
        }

        hdsnSubstituicaoArtigos.render();
        window.parent.$docsservicossubstituicao.ajax.EnableDirty()
        self.CloseModal();
    }

    self.CloseModal = () => {
        window.parent.$(".k-window .k-window-content").each(function (index, element) {
            window.parent.$(element).data("kendoWindow").close();
        });
    }

    self.Constroi = function (funcDataBound) {
        var dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: catalogoLentesPath + 'LerIndices',
                    dataType: "json",
                    data: self.GetParamsListViewIndices()
                }
            },
            pageSize: numRegistos
        });

        $('#' + listView.Indices).kendoListView({
            dataSource: dataSource,
            selectable: 'single',
            template: kendo.template($("#template-indice").html()),
            dataBound: function (e) {

                $("#" + listView.Indices).undelegate().delegate('.items', 'click', function (e) {
                    self.ClickOnListView(e, this, listView.Indices);

                    listViewConstroi(listView.Modelos, catalogoLentesPath + 'LerModelos', self.GetParamsListViewModelos(), numRegistos, false, () => { }, false, null, true);

                    $("#" + listView.Modelos).undelegate().delegate('.items', 'click', function (e) {
                        self.ClickOnListView(e, this, listView.Modelos);
                        return false;
                    });

                    self.ClearListViews(false);
                    return false;
                });

                if (typeof (funcDataBound) === 'function') {
                    funcDataBound(e);
                }
            },
            navigatable: false
        });
    }

    self.GetParamsListViewIndices = function () {
        let IDMarcasSelected = listViewGetIDSelected(listView.Marcas);
        let IDTiposLentesSelected = listViewGetIDSelected(listView.TiposLentes);
        let IDMateriasLentesSelected = listViewGetIDSelected(listView.MateriasLentes);
        let fotocromatica = $('#fotocromatica').is(':checked');

        return {
            LenteOftalmica: BOOL_LENTES_OFTALMICAS,
            IDMarca: IDMarcasSelected,
            IDTiposLentes: IDTiposLentesSelected,
            IDMateriaLentes: IDMateriasLentesSelected,
            Fotocromatica: fotocromatica
        };
    }

    self.GetParamsListViewModelos = function () {
        let IDMarcasSelected = listViewGetIDSelected(listView.Marcas);
        let IDTiposLentesSelected = listViewGetIDSelected(listView.TiposLentes);
        var IDMateriasLentesSelected = listViewGetIDSelected(listView.MateriasLentes);
        let indice = self.getDataItemSelected(listView.Indices, "IndiceRefracaoAux");
        let fotocromatica = $('#fotocromatica').is(':checked');

        return {
            LenteOftalmica: BOOL_LENTES_OFTALMICAS,
            IDMarca: IDMarcasSelected,
            IDTiposLentes: IDTiposLentesSelected,
            IDMateriaLentes: IDMateriasLentesSelected,
            Indice: indice,
            Fotocromatica: fotocromatica
        }
    }

    self.getDataItemSelected = function (listViewId, prop) {
        let listView = $('#' + listViewId).data('kendoListView');

        if (!UtilsVerificaObjetoNotNullUndefinedVazio(listView) || listView.dataSource.data().length === 0) {
            return null;
        }

        let selectedIndex = listView.select().index();
        let dataItem = listView.dataSource.view()[selectedIndex];

        return (selectedIndex == -1 || dataItem == undefined) ? null : dataItem[prop];
    };

    self.setSelected = function (IDListView, prop, propValue) {
        var listView = $('#' + IDListView).data('kendoListView');
        var elemListView = $('#' + IDListView);

        if (UtilsVerificaObjetoNotNullUndefinedVazio(listView) === false) {
            listView = window.parent.$('#' + IDListView).data('kendoListView');
            elemListView = window.parent.$('#' + IDListView);
        }

        if (UtilsVerificaObjetoNotNullUndefinedVazio(listView) === true) {
            for (var i = 0; i < listView.dataSource.data().length; i++) {
                if (propValue == listView.dataSource.data()[i][prop]) {

                    listView.select(listView.element.find('[data-uid="' + listView.dataSource.data()[i].uid + '"]'));

                    var row = $(listView.element.find('[data-uid="' + listView.dataSource.data()[i].uid + '"]').parent());

                    if (row.length == 0) {
                        row = window.parent.$(listView.element.find('#' + listView.dataSource.data()[i][prop]).parent());
                    }
                    if (row.length != 0) {
                        elemListView.scrollTop(0);
                        elemListView.animate({ scrollTop: (row.offset().top - elemListView.offset().top) });
                    }
                    break;
                }
            }
        }
    }

    self.FotocromaticaChange = function () {
        let IDMarcasSelected = listViewGetIDSelected(listView.Marcas);
        let IDTiposLentesSelected = listViewGetIDSelected(listView.TiposLentes);
        let IDMateriasLentesSelected = listViewGetIDSelected(listView.MateriasLentes);

        if (BOOL_LENTES_OFTALMICAS) {
            if (IDMarcasSelected != 0 && IDTiposLentesSelected != 0 && IDMateriasLentesSelected != 0) {
                self.Constroi(function () {
                    listViewConstroi(listView.Modelos, catalogoLentesPath + 'LerModelos', self.GetParamsListViewModelos(), numRegistos, false, () => { }, false, null, true);
                });
            }
        }
        else {
            if (IDMarcasSelected != 0 && IDTiposLentesSelected != 0) {
                self.Constroi(function () {
                    listViewConstroi(listView.Modelos, catalogoLentesPath + 'LerModelos', self.GetParamsListViewModelos(), numRegistos, false, () => { }, false, null, true);
                });
            }
        }

        self.ClearListViews(false);
    }

    return parent;

}($docsservicossubstituicaocatalogolentes || {}, jQuery));

$(document).ready((e) => $docsservicossubstituicaocatalogolentes.ajax.Init());

var CatalogoLentesChangeTiposLentes = $docsservicossubstituicaocatalogolentes.ajax.ChangeTiposLentes;
var CatalogoLentesLabelClick = $docsservicossubstituicaocatalogolentes.ajax.LabelClick;
var CatologoLentesModeloEnviaParams = $docsservicossubstituicaocatalogolentes.ajax.ModeloEnviaParams;
var CatologoLentesEnviaParamsIDModelo = $docsservicossubstituicaocatalogolentes.ajax.EnviaParamsIDModelo;
var CatalogoLentesGetLabelClicked = $docsservicossubstituicaocatalogolentes.ajax.GetLabelClicked;
var CatalogosLentesValidaEGravaEspecificoListView = $docsservicossubstituicaocatalogolentes.ajax.ValidaEGravaEspecificoListView;
var CatalogoLentesMarcasChange = $docsservicossubstituicaocatalogolentes.ajax.MarcasChange;
//#endregion