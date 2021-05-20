"use strict";

var $communicationtemplate = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    const _grupo = '.clsF3MQBGrupo', _regras = '.clsF3MQBListaRegras', _condicao_valor = '.clsF3MQBCondicaoValor';
    const _regra = '.clsF3MQBRegra', _remover_regra = '.clsF3MQBRemoverRegra'
    const _filtro = '.clsF3MQBFiltro', _condicao = '.clsF3MQBCondicao', _valor = '.clsF3MQBValor';

    self.Init = () => {
        self.TrataBotoesInit();

        self.AplicaDirtyEsp();

        $('#btnSave').off().on('click', () => self.Save());

        $('#btnRemove').off().on('click', () => self.AskDelete());

        $('#btnCancel').off().on('click', () => self.Cancel());

        $('#btnfilter').off().on('click', () => self.ShowFilters());

        $('#btnEdit').off().on('click', () => self.ShowFilters());

        $('#btnCopy').off().on('click', () => $communsetting.ajax.CopyTemplate());

        $('#btnDestinations').off().on('click', () => self.ShowRecipts());
    };

    self.ShowFilters = () => {
        $('.clsF3MTemplateFilters').removeClass('hidden');
        $('#template-recipts').addClass('hidden');
        $('#btnDestinations').toggleClass('main-btn f3m-btn-outline');

        KendoDesativaElemento('Nome', false);
        KendoColocaElementoObrigatorio($('#Nome'), true);
        KendoDesativaElemento('IDSistemaEnvio', false);
        KendoColocaElementoObrigatorio($('#IDSistemaEnvio'), true);
        KendoDesativaElemento('IDParametrizacaoConsentimentosPerguntas', false);
        KendoColocaElementoObrigatorio($('#IDParametrizacaoConsentimentosPerguntas'), true);

        $('#btnEdit').addClass('disabled');
    }

    self.ShowRecipts = () => {
        $('.clsF3MTemplateFilters').addClass('hidden');
        $('#template-recipts').removeClass('hidden');
        $('#btnDestinations').toggleClass('f3m-btn-outline main-btn');

        KendoDesativaElemento('Nome', true);
        KendoDesativaElemento('IDSistemaEnvio', true);
        KendoDesativaElemento('IDParametrizacaoConsentimentosPerguntas', true);

        $('#btnEdit').removeClass('disabled');
    }

    self.GetIdTemplate = () => parseInt($('#template').attr('data-bd-id'));

    self.TrataBotoesInit = () => {
        let id = self.GetIdTemplate();

        if (id === 0) {
            self.TrataBotoesInitAdicionar();
        }
        else {
            self.TrataBotoesInitEditar();
        }
    }

    self.TrataBotoesInitAdicionar = () => {
        //tree
        $('#arvoremenu').data('kendoTreeView').select(null);
        //historic
        $('#btnReset').addClass('hidden');
        $('#btnAdd').addClass('hidden');
        //template add || edit
        $('#btnSave').removeClass('hidden').removeClass('disabled');
        $('#btnCancel').removeClass('hidden').removeClass('disabled');
        //template edit
        $('#btnCopy').addClass('hidden').addClass('disabled');
        $('#btnRemove').addClass('hidden').addClass('disabled');
        $('#btnEdit').addClass('hidden').addClass('disabled');
        //grupo > regra
        $(_grupo + ':first').find('.clsF3MQBRemoverGrupo').addClass('hidden');
        $(_grupo + ':first').find(_remover_regra).addClass('hidden');
        //tree || historic button
    }

    self.TrataBotoesInitEditar = () => {
        //historic
        $('#btnReset').addClass('hidden');
        //historic || edit
        $('#btnAdd').removeClass('hidden').removeClass('disabled');
        //template add || edit
        $('#btnSave').removeClass('hidden').addClass('disabled');
        $('#btnCancel').removeClass('hidden').addClass('disabled');
        //template edit
        $('#btnCopy').removeClass('hidden').removeClass('disabled');
        $('#btnRemove').removeClass('hidden').removeClass('disabled');
        $('#btnEdit').removeClass('hidden').removeClass('disabled');
        //grupo > regra
        $(_grupo + ':first').find('.clsF3MQBRemoverGrupo:first').addClass('hidden');
        $(_grupo).find(_remover_regra + ':first').addClass('hidden');
    }

    self.TrataBotoesDirty = () => {
        //add || edit
        $('#btnSave').removeClass('disabled');
        $('#btnCancel').removeClass('disabled');

        //edit
        let id = self.GetIdTemplate();
        if (id !== 0) {
            $('#btnAdd').addClass('disabled');
            $('#btnCopy').addClass('disabled');
            $('#btnRemove').addClass('disabled');
            $('#btnDestinations').addClass('disabled');
        }
    }

    self.AplicaDirtyEsp = () => {
        $('#AreaGeral :input').off().on('keyup change', (e) => {
            if (e.currentTarget.id !== 'TexoMsgArea') {
                if (self.PopUpErrosVisivel()) {
                    let model = self.GetModel();
                    self.IsValid(model);
                }
                self.TrataBotoesDirty();
                $communsetting.ajax.IsDirtyActive = true;
            }
        });
    };

    self.PopUpErrosVisivel = function () {
        let msgErroID = base.constantes.janelasPopupIDs.Erro;
        let popUpErros = $('#' + msgErroID).data('kendoWindow');
        return popUpErros && popUpErros.options.visible;
    };

    self.RemoverGrupo = (e) => $(e).closest(_grupo).remove();

    self.RemoverRegra = (e) => $(e).closest('li').remove();

    self.NovaRegra = (e) => {
        KendoLoading($('#iframeBody'), true);
        $.get(rootDir + 'Communication/CommunicationSmsTemplates/Regra', (res) => {
            KendoLoading($('#iframeBody'), false);
            self.TrataBotoesDirty();
            $communsetting.ajax.IsDirtyActive = true;

            let grupoSelected = $(e).closest(_grupo);
            grupoSelected.find(_regras + ':first').append(res);
        });
    }

    self.NovoGrupo = (e) => {
        KendoLoading($('#iframeBody'), true);
        $.get(rootDir + 'Communication/CommunicationSmsTemplates/Grupo', (res) => {
            KendoLoading($('#iframeBody'), false);
            res = $(res);
            res.find(_remover_regra).addClass('hidden');

            self.TrataBotoesDirty();
            $communsetting.ajax.IsDirtyActive = true;

            $(e).closest(_grupo).children("ul").append(res);
        });
    }

    self.ChangeFiltro = (e) => {
        let row = $(e).closest(_regra);
        let selected = parseInt($(e).find('option:selected').attr('data-id'));

        if (selected === 0) {
            row.find(_condicao_valor).html('');
        }
        else {
            KendoLoading($('#iframeBody'), true);
            $.get(rootDir + 'Communication/CommunicationSmsTemplates/CondicaoValor', { idFiltro: selected }, (res) => {
                KendoLoading($('#iframeBody'), false);
                row.find(_condicao_valor).html(res);
                self.AplicaDirtyEsp();
                self.InitializeMultiSelects();
            });
        }
    }

    self.ChangeCondicao = (e) => {
        let row = $(e).closest(_regra);
        let selected = parseInt($(e).find('option:selected').attr('data-id'));

        if (selected === 0) {
            row.find(_valor).html('');
        }
        else {
            KendoLoading($('#iframeBody'), true);
            $.get(rootDir + 'Communication/CommunicationSmsTemplates/Valor', { idCondicao: selected }, (res) => {
                KendoLoading($('#iframeBody'), false);
                row.find(_valor).html(res);
                self.AplicaDirtyEsp();
                self.InitializeMultiSelects();
            });
        }
    }

    self.Save = () => {
        let model = self.GetModel();
        if (self.IsValid(model)) {
            let id = self.GetIdTemplate();
            if (id === 0) {
                self.Create(model);
            }
            else {
                self.Update(model);
            }
        }
    }

    self.Create = (model) => {
        KendoLoading($('#iframeBody'), true);
        $.post(rootDir + 'Communication/CommunicationSmsTemplates/Create', { model: model }, (res) => {
            if (res.Erros && res.Erros.length) {
                KendoLoading($('#iframeBody'), false);
                UtilsConfirma(base.constantes.tpalerta.error, res.Erros[0]['Mensagem'], () => false, () => false);
            }
            else {
                UtilsNotifica(base.constantes.tpalerta.s, "Adicionado com sucesso.");
                $communsetting.ajax.ReadTreeSelectNodeAndOpenTemplate(res['ID']);
            }
        });
    }

    self.Update = (model) => {
        KendoLoading($('#iframeBody'), true);
        $.post(rootDir + 'Communication/CommunicationSmsTemplates/Update', { model: model }, (res) => {
            if (res.Erros && res.Erros.length) {
                KendoLoading($('#iframeBody'), false);
                UtilsConfirma(base.constantes.tpalerta.error, res.Erros[0]['Mensagem'], () => false, () => false);
            }
            else {
                UtilsNotifica(base.constantes.tpalerta.s, "Atualizado com sucesso.");
                $communsetting.ajax.ReadTreeSelectNodeAndOpenTemplate(res['ID']);
            }
        });
    }

    self.Delete = () => {
        KendoLoading($('#iframeBody'), true);
        let id = self.GetIdTemplate();
        $.post(rootDir + 'Communication/CommunicationSmsTemplates/Delete', { idTemplate: id }, (res) => {
            if (res.Erros && res.Erros.length) {
                KendoLoading($('#iframeBody'), false);
                UtilsConfirma(base.constantes.tpalerta.error, res.Erros[0]['Mensagem'], () => false, () => false);
            }
            else {
                UtilsNotifica(base.constantes.tpalerta.s, "Removido com sucesso.");
                $communsetting.ajax.ReadTree();
                $communsetting.ajax.OpenHistoric();
            }
        });
    }

    self.AskDelete = () => UtilsConfirma(base.constantes.tpalerta.question, 'Tem a certeza que deseja remover este template?', self.Delete, () => false);

    self.Cancel = () => {
        let idTemplate = self.GetIdTemplate();

        UtilsConfirma(base.constantes.tpalerta.question, 'Tem alterações pendentes! Pretende continuar e perder a informação ?', () => {
            if (idTemplate === 0) {
                $communsetting.ajax.OpenHistoric();
            }
            else {
                $communsetting.ajax.OpenTemplate(idTemplate);
            }
            
        }, () => false);
    }

    //MODEL
    self.GetModel = () => {
        let model = GrelhaUtilsGetModeloForm(GrelhaFormDTO($('#AreaGeral')));
        model['ID'] = self.GetIdTemplate();
        model['Grupo'] = self.GetModelFromGrupos();

        return model;
    }

    self.GetModelFromGrupos = () => {
        let main_grupo = $(_grupo + ':first');
        var model = {
            Ordem :1
        };
        return self.GetModelGrupo(model, main_grupo);
    }

    self.GetModelGrupo = (model, elemGrupo) => {
        //id
        model['ID'] = elemGrupo.attr('data-bd-id');
        //ordem
        model['Ordem'] = model['Ordem'] || elemGrupo.parent().index();
        //e || ou
        model['MainCondition'] = self.GetMainCondition(elemGrupo);
        //regras
        model['Regras'] = [];
        for (let index = 0; index < $(elemGrupo).find('ul:first > li').length; index++) {
            let elemRegra = $(elemGrupo).find('ul:first > li')[index];
            let regra = {};
            //
            regra['ID'] = $(elemRegra).attr('data-bd-id');
            regra['Ordem'] = $(elemRegra).index() + 1;
            regra['IDFiltro'] = $(elemRegra).find(_filtro + ' option:selected').attr('data-id');
            regra['IDCondicao'] = $(elemRegra).find(_condicao + ' option:selected').attr('data-id');

            regra['Valores'] = [];
            let inputs = $(elemRegra).find('input.clsF3MQBInput' + ', select.clsF3MQBInput');
            for (var indexInputs = 0; indexInputs < inputs.length; indexInputs++) {
                let input = $(elemRegra).find('input.clsF3MQBInput' + ', select.clsF3MQBInput')[indexInputs];
                self.GetValores(regra, $(input), indexInputs);
            }
            model['Regras'].push(regra);
        }

        //grupos
        model['Grupos'] = [];
        for (let index = 0; index < $(elemGrupo).find('ul:first > div').children(_grupo).length; index++) {
            let elemSubGrupo = $(elemGrupo).find('ul:first > div').children(_grupo)[index];
            model['Grupos'].push({});
            self.GetModelGrupo(model['Grupos'][index], $(elemSubGrupo));
        }
        return model;
    }

    self.GetMainCondition = (elemGrupo) => {
        if (elemGrupo.find('.clsF3MQBOr:first').is(':checked')) {
            return 'OR';
        }
        return 'AND';
    }

    self.GetValores = (regra, input, indexInput) => {
        let value = null;
        switch (input.attr('type')) {
            case 'checkbox':
                value = input.is(':checked') ? 1 : 0;
                break;
            default:
                value = (input.val() === null || input.val() === '') ? '' :  input.val().toString();
                break;
        }

        return regra['Valores'].push({
            ID: input.attr('data-bd-id'),
            IDSistemaComunicacaoSmsTemplatesValores: input.attr('data-id'),
            Valor: value,
            SqlQueryWhere: input.attr('data-sql-query'),
            Ordem: indexInput + 1
        })
    }

    //VALIDATIONS
    self.IsValid = (model) => {
        let errors = self.ValidaForm();

        errors = self.ValidGrupos(model['Grupo'], errors);

        return !(errors && errors.length);
    }

    self.ValidaForm = () => {
        return GrelhaUtilsValida($('#AreaGeral'));
    }

    self.ValidGrupos = (grupos, errors) => {
        for (var indexRegra = 0; indexRegra < grupos['Regras'].length; indexRegra++) {
            let regra = grupos['Regras'][indexRegra];

            if (regra['IDFiltro'] === undefined || regra['IDFiltro'] === null || parseInt(regra['IDFiltro']) === 0) {
                errors = UtilsAdicionaRegistoArray(errors, 'A regra tem que ter 1 filtro.');
                UtilsJanelaRodape(base.constantes.tpalerta.error, errors, true);
            }
            else {
                if (regra['IDCondicao'] === undefined || regra['IDCondicao'] === null || parseInt(regra['IDCondicao']) === 0) {
                    errors = UtilsAdicionaRegistoArray(errors, 'A regra tem que ter 1 condição.');
                    UtilsJanelaRodape(base.constantes.tpalerta.error, errors, true);
                }
            }
        }

        if (grupos['Grupos'] && grupos['Grupos'].length > 0) {
            for (let indexGrupo = 0; indexGrupo < grupos['Grupos'].length; indexGrupo++) {
                let grupo = grupos['Grupos'][indexGrupo];
                return self.ValidGrupos(grupo);
            }
        }

        return errors;
    }

    self.InitializeMultiSelects = () => {
        $(".selectpicker").selectpicker({
            noneSelectedText: 'Selecionar',
            noneResultsText: 'Nenhum registo encontrado.',
            countSelectedText: '{0} selecionado(s) de {1}'
        });
    }

    return parent;

}($communicationtemplate || {}, jQuery));

$(document).ready(() => $communicationtemplate.ajax.Init());