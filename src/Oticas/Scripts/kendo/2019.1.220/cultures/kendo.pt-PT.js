/*
* Kendo UI Localization Project for v2012.3.1114 
* Copyright 2012 Telerik AD. All rights reserved.
* 
* Portugal Portuguese (pt-PT) Language Pack
*
* Project home  : https://github.com/loudenvier/kendo-global
* Kendo UI home : http://kendoui.com
* Author        : Pedro Carvalho  
*                 
*
* This project is released to the public domain, although one must abide to the 
* licensing terms set forth by Telerik to use Kendo UI, as shown bellow.
*
* Telerik's original licensing terms:
* -----------------------------------
* Kendo UI Web commercial licenses may be obtained at
* https://www.kendoui.com/purchase/license-agreement/kendo-ui-web-commercial.aspx
* If you do not own a commercial license, this file shall be governed by the
* GNU General Public License (GPL) version 3.
* For GPL requirements, please review: http://www.gnu.org/copyleft/gpl.html
*/

kendo.ui.Locale = "Português Portugal (pt-PT)";
kendo.ui.ColumnMenu.prototype.options.messages = $.extend(kendo.ui.ColumnMenu.prototype.options.messages, {
    sortAscending: "Ascendente",
    sortDescending: "Descendente",
    filter: "Filtro",
    columns: "Colunas"
});

kendo.ui.Groupable.prototype.options.messages = $.extend(kendo.ui.Groupable.prototype.options.messages, {
    empty: "Arraste colunas para esta área de forma a agrupar pelas mesmas"
});

kendo.ui.FilterMenu.prototype.options.messages = $.extend(kendo.ui.FilterMenu.prototype.options.messages, {
    info: "Filtrar por",        // sets the text on top of the filter menu
    filter: "Filtrar",      // sets the text for the "Filter" button
    clear: "Limpar",        // sets the text for the "Clear" button
    isTrue: "Verdadeiro", // sets the text for "isTrue" radio button
    isFalse: "Falso",     // sets the text for "isFalse" radio button
    and: "E",
    or: "Ou",
    selectValue: "-determine prioridade-"
});

kendo.ui.FilterMenu.prototype.options.operators = $.extend(kendo.ui.FilterMenu.prototype.options.operators, {
    string: {
        eq: "Igual a",
        neq: "Diferente de",
        startswith: "Come&ccedil;a com",
        contains: "Cont&eacute;m",
        doesnotcontain: "N&atilde;o cont&eacute;m",
        endswith: "Termina com",
        isempty: "&Eacute; vazio",
        isnotempty: "N&atilde;o &eacute; vazio",
        isnull: "&Eacute; nulo",
        isnotnull: "N&atilde;o &eacute; nulo"
    },
    number: {
        eq: "Igual a",
        neq: "Diferente de",
        gte: "Maior ou igual a",
        gt: "Maior que",
        lte: "Menor ou igual a",
        lt: "Menor que",
        isnull: "&Eacute; nulo",
        isnotnull: "N&atilde;o &eacute; nulo"
    },
    date: {
        eq: "Igual a",
        neq: "Diferente de",
        gte: "Igual ou mais recente que",
        gt: "Mais recente que",
        lte: "Igual ou mais antigo que",
        lt: "Mais antigo que",
        isnull: "&Eacute; nulo",
        isnotnull: "N&atilde;o &eacute; nulo"
    },
    enums: {
        eq: "Igual a",
        neq: "Diferente de",
        isnull: "&Eacute; nulo",
        isnotnull: "N&atilde;o &eacute; nulo"
    }
});

kendo.ui.Pager.prototype.options.messages = $.extend(kendo.ui.Pager.prototype.options.messages, {
    display: "{0} - {1} de {2} itens",
    empty: "Nada a exibir",
    page: "P&aacute;gina",
    of: "de {0}",
    itemsPerPage: "itens por p&aacute;gina",
    first: "Ir para a primeira p&aacute;gina",
    previous: "Ir para a p&aacute;gina anterior",
    next: "Ir para a p&aacute;gina seguinte",
    last: "Ir para a &uacute;ltima p&aacute;gina",
    refresh: "Atualizar"
});

kendo.ui.Validator.prototype.options.messages = $.extend(kendo.ui.Validator.prototype.options.messages, {
    required: "{0} &eacute; obrigat&oacute;rio",
    pattern: "{0} n&atilde;o &eacute; v&aacute;lido",
    min: "{0} deve ser maior ou igual a {1}",
    max: "{0} deve ser menor ou igual a {1}",
    step: "{0} n&atilde;o &eacute; v&aacute;lido",
    email: "{0} n&atilde;o &eacute; um email v&aacute;lido",
    url: "{0} n&atilde;o &eacute; uma URL v&aacute;lida",
    date: "{0} n&atilde;o &eacute; uma data v&aacute;lida"
});

kendo.ui.ImageBrowser.prototype.options.messages = $.extend(kendo.ui.ImageBrowser.prototype.options.messages, {
    uploadFile: "Enviar",
    orderBy: "Ordenar por",
    orderByName: "Nome",
    orderBySize: "Tamanho",
    directoryNotFound: "Uma pasta com este nome n&atilde;o foi encontrada.",
    emptyFolder: "Pasta Vazia",
    deleteFile: 'Tem a certeza que deseja eliminar "{0}"?',
    invalidFileType: "O arquivo selecionado \"{0}\" n&atilde;o &eacute; v&aacute;lido. Os tipos de arquivo suportados s&atilde;o {1}.",
    overwriteFile: "Um arquivo com o nome \"{0}\" j&aacute; existe na pasta atual. Deseja sobrepor?",
    dropFilesHere: "coloque aqui os arquivos para envi&aacute;-los"
});

kendo.ui.Editor.prototype.options.messages = $.extend(kendo.ui.Editor.prototype.options.messages, {
    bold: "Negrito",
    italic: "It&aacute;lico",
    underline: "Sublinhado",
    strikethrough: "Rasurado",
    superscript: "Sobrescrito",
    subscript: "Subscrito",
    justifyCenter: "Centrar texto",
    justifyLeft: "Alinhar texto &agrave; esquerda",
    justifyRight: "Alinhar texto &agrave; direita",
    justifyFull: "Justificar",
    insertUnorderedList: "Inserir lista n&atilde;o ordenada",
    insertOrderedList: "Inserir lista ordenada",
    indent: "Aumentar recuo",
    outdent: "Diminuir recuo",
    createLink: "Inserir ligação",
    unlink: "Remover ligação",
    insertImage: "Inserir imagem",
    insertHtml: "Inserir HTML",
    fontName: "Selecionar fam&iacute;lia da fonte",
    fontNameInherit: "(fonte herdada)",
    fontSize: "Selecionar tamanho da fonte",
    fontSizeInherit: "(tamanho herdado)",
    formatBlock: "Formatar",
    foreColor: "Cor",
    backColor: "Cor de fundo",
    style: "Estilos",
    emptyFolder: "Pasta Vazia",
    uploadFile: "Enviar",
    orderBy: "Ordenar por:",
    orderBySize: "Tamanho",
    orderByName: "Nome",
    invalidFileType: "O arquivo selecionado \"{0}\" n&atilde;o &eacute; v&aacute;lido. Os arquivos suportados s&atilde;o {1}.",
    deleteFile: 'Tem a certeza que deseja eliminar "{0}"?',
    overwriteFile: 'Um arquivo com o nome "{0}" j&aacute; existe na pasta atual. Deseja sobrepor?',
    directoryNotFound: "Uma pasta com este nome n&atilde;o foi encontrada.",
    imageWebAddress: "Endereço internet",
    imageAltText: "Texto alternativo",
    dialogInsert: "Inserir",
    dialogButtonSeparator: "ou",
    dialogCancel: "Cancelar",
    accessibilityTab: "Accessibilidade",
    alignCenter: "Alinhar ao centro",
    alignCenterBottom: "Alinhar ao centro e em baixo",
    alignCenterMiddle: "Alinhar ao centro e ao meio",
    alignCenterTop: "Alinhar ao centro e ao topo",
    alignLeft: "Alinhar à esquerda",
    alignLeftBottom: "Alinhar à esquerda e em baixo",
    alignLeftMiddle: "Alinhar à esquerda e ao meio",
    alignLeftTop: "Alinhar à esquerda e ao topo",
    alignRemove: "Remover Alinhamento",
    alignRight: "Alinhar à direita",
    alignRightBottom: "Alinhar à direita e em baixo",
    alignRightMiddle: "Alinhar à direita e ao meio",
    alignRightTop: "Alinhar à direita e ao topo",
    alignment: "Alinhamento",
    background: "Fundo",
    border: "Borda",
    borderStyle: "Estilo da borda",
    caption: "Título",
    cellMargin: "Margem",
    cellTab: "Célula",
    cleanFormatting: "Limpar formatação",
    columns: "Colunas",
    createTableHint: "Criar tabela {0} x {1}",
    cssClass: "Classe CSS",
    deleteColumn: "Eliminar coluna",
    dialogOk: "Ok",
    editAreaTitle: "Área editável. Pressione F10 para ferramentas.",
    exportAs: "Exportar para",
    fileText: "Texto",
    fileTitle: "Título",
    fileWebAddress: "Endereço Web",
    height: "Altura",
    id: "ID",
    imageHeight: "Altura (px)",
    imageWidth: "Largura (px)",
    import: "Importar",
    linkToolTip: "Sugestão de contexto",
    overflowAnchor: "Mais ferramentas",
    rows: "Linhas",
    selectAllCells: "Selecionar todas as células",
    summary: "Sumário",
    tableTab: "Tabela",
    tableWizard: "Propriedades da Tabela",
    units: "Unidades",
    width: "Largura",
    cellPadding: "Espaço interior",
    cellSpacing: "Espaçamento",
    collapseBorders: "Colapsar bordas",
    wrapText: "Partir texto",
    associateCellsWithHeaders: "Associar células com cabeçalho",
    clear: "Limpar"
});

kendo.ui.Scheduler.prototype.options.messages = $.extend(kendo.ui.Scheduler.prototype.options.messages, {
    allDay: "Durante o dia",
    cancel: "Cancelar",
    date: "Data",
    deleteWindowTitle: "Apagar tarefa",
    destroy: "Apagar",
    event: "Tarefa",
    save: "Guardar",
    showFullDay: "Hor&aacute;rio Completo",
    showWorkDay: "Hor&aacute;rio &Uacute;til",
    time: "Hora",
    today: "Hoje",
    ariaSlotLabel: "Seleccionado de {0:t} até {1:t}",
    next: "Seguinte",
    previous: "Anterior",
    pdf: "Exportar para PDF",
    editable: {
        confirmation: "Tem a certeza que pretende eliminar o evento"
    },
    editor: {
        allDayEvent: "Durante o dia",
        description: "Descri&ccedil;&aacute;o",
        editorTitle: "Tarefa",
        end: "Fim",
        endTimezone: "Fim (Fuso hor&aacute;rio)",
        repeat: "Repete",
        separateTimezones: "Hor&atilde;rio diferente no fuso hor&aacute;rio",
        start: "In&iacute;cio",
        timezone: "Fim (Fuso hor&aacute;rio)",
        timezoneEditorButton: "Alterar",
        timezoneEditorTitle: "Definir fuso hor&aacute;rio",
        title: "T&iacute;tulo"
    },
    recurrenceEditor: {
        daily: {
            // Não suporta acentos
            interval: "dia(s)",
            repeatEvery: "A cada"
        },
        end: {
            // Não suporta acentos
            after: "Ao fim de",
            occurrence: "vez(es)",
            label: "Fim",
            never: "Nunca",
            on: "Em",
            mobileLabel: "Label"
        },
        frequencies: {
            // Não suporta acentos
            daily: "Todos os dias",
            monthly: "Todos os meses",
            never: "Nunca",
            weekly: "Todas as semanas",
            yearly: "Todos os anos"
        },
        monthly: {
            day: "dia(s)",
            interval: "mes(es)",
            repeatEvery: "A cada",
            repeatOn: "No(s)"
        },
        offsetPositions: {
            // Não suporta acentos
            first: "primeiro(a)",
            second: "segundo(a)",
            third: "terceiro(a)",
            fourth: "quarto(a)",
            last: "último(a)"
        },
        weekly: {
            interval: "semana(s)",
            repeatEvery: "A cada",
            repeatOn: "Na(s)"
        },

        weekdays: {
            day: "dia",
            weekday: "dia de semana",
            weekend: "dia de fim-de-semana"
        },
        yearly: {
            day: "dia(s)",
            of: "de",
            interval: "ano(s)",
            repeatEvery: "A cada",
            repeatOn: "No(s)"
        }
    },
    recurrenceMessages: {
        deleteRecurring: "Deseja apagar apenas esta tarefa ou toda a série?",
        deleteWindowOccurrence: "Apagar tarefa",
        deleteWindowSeries: "Apagar série",
        deleteWindowTitle: "Apagar tarefa",
        editRecurring: "Deseja alterar apenas esta tarefa ou toda a série?",
        editWindowOccurrence: "Alterar tarefa",
        editWindowSeries: "Alterar série",
        editWindowTitle: "Detalhes tarefa"
    },
    views: {
        // Aqui não suporta os acentos!!
        day: "Dir&aacute;rio",
        week: "Semanal",
        month: "Mensal",
        agenda: "Agenda",
        workWeek: "Dias Trabalho"
    }
});

kendo.ui.ColorPicker.prototype.options.messages = $.extend(kendo.ui.ColorPicker.prototype.options.messages, {
    apply: "Aplicar",
    cancel: "Cancelar",
    clearColor: "Limpar cor",
    noColor: "Nenhuma cor",
    previewInput: "Código hexadecimal da cor"
});

kendo.ui.ComboBox.prototype.options.messages = $.extend(kendo.ui.ComboBox.prototype.options.messages, {
    clear: "Limpar"
});

kendo.ui.AutoComplete.prototype.options.messages = $.extend(kendo.ui.AutoComplete.prototype.options.messages, {
    clear: "Limpar"
});

kendo.ui.MultiColumnComboBox.prototype.options.messages = $.extend(kendo.ui.MultiColumnComboBox.prototype.options.messages, {
    clear: "Limpar"
});

kendo.ui.NumericTextBox.prototype.options = $.extend(kendo.ui.NumericTextBox.prototype.options, {
    upArrowText: "Aumentar valor",
    downArrowText: "Diminuir valor"
});

kendo.ui.FilterCell.prototype.options.messages = $.extend(kendo.ui.FilterCell.prototype.options.messages, {
    clear: "Limpar"
});
