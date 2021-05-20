@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Oticas.DTO
@Imports F3M.Oticas.Translate
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Oticas.Translate
@Modeltype AccountingExportDto

<div class="row form-container">
    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "StoresId",
            .Label = AccountingExportResources.Store,
            .CampoTexto = CamposGenericos.Descricao,
            .CampoValor = CamposGenericos.ID,
            .TipoEditor = Mvc.Componentes.F3MMultiSelect,
            .Controlador = "../Admin/Lojas",
            .Accao = "ListaCombo",
            .Modelo = Model.Filter,
            .ClearButton = True,
            .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"},
            .OpcaoMenuDescAbrev = Menus.Lojas,
            .ViewClassesCSS = {ClassesCSS.XS5}})


        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "InitValue",
            .Label = AccountingExportResources.InitValue,
            .TipoEditor = Mvc.Componentes.F3MNumero,
            .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais,
            .Modelo = Model.Filter,
            .ViewClassesCSS = {ClassesCSS.XS2}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "EndValue",
            .Label = AccountingExportResources.EndValue,
            .TipoEditor = Mvc.Componentes.F3MNumero,
            .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais,
            .Modelo = Model.Filter,
            .ViewClassesCSS = {ClassesCSS.XS2}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ExportFormat",
            .Label = AccountingExportResources.ExportFormat,
            .TipoEditor = Mvc.Componentes.F3MDropDownList,
            .CampoTexto = "Description",
            .CampoValor = "Code",
            .Controlador = "../Accounting/AccountingExport",
            .Accao = "GetFormatsList",
            .Modelo = Model.Filter,
            .ViewClassesCSS = {ClassesCSS.XS2}})
    End Code
</div>

<div class="row form-container">
    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ModulesId",
            .Label = AccountingExportResources.Module,
            .CampoTexto = "Description",
            .CampoValor = "Id",
            .TipoEditor = Mvc.Componentes.F3MMultiSelect,
            .Controlador = "../Accounting/AccountingExport",
            .Accao = "GetModules",
            .Modelo = Model.Filter,
            .FuncaoJSDeselect = "accountingexportdeselectmodule",
            .FuncaoJSChange = "accountingexportchangemodule",
            .FuncaoJSEnviaParams = "accountingexportmodulesendparameter",
            .ClearButton = True,
            .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"},
            .OpcaoMenuDescAbrev = Menus.Lojas,
            .ViewClassesCSS = {ClassesCSS.XS5}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Generated",
            .Label = AccountingExportResources.GeneratedMovement,
            .TipoEditor = Mvc.Componentes.F3MDropDownList,
            .CampoTexto = "Description",
            .CampoValor = "Code",
            .Controlador = "../Accounting/AccountingExport",
            .Accao = "GetGeneratedList",
            .Modelo = Model.Filter,
            .ViewClassesCSS = {ClassesCSS.XS2}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Exported",
            .Label = AccountingExportResources.ExportedMovement,
            .TipoEditor = Mvc.Componentes.F3MDropDownList,
            .CampoTexto = "Description",
            .CampoValor = "Code",
            .Controlador = "../Accounting/AccountingExport",
            .Accao = "GetExportedList",
            .Modelo = Model.Filter,
            .ViewClassesCSS = {ClassesCSS.XS2}})
    End Code
</div>

<div class="row form-container">
    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DocumentTypesId",
            .Label = AccountingExportResources.DocumentTypes,
            .CampoTexto = "Description",
            .CampoValor = "Id",
            .TipoEditor = Mvc.Componentes.F3MMultiSelect,
            .Controlador = "../Accounting/AccountingExport",
            .Accao = "GetDocumentTypes",
            .Modelo = Model.Filter,
            .FuncaoJSEnviaParams = "accountingexportparametersend",
            .ClearButton = True,
            .FiltraNoServidor = False,
            .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"},
            .OpcaoMenuDescAbrev = Menus.Lojas,
            .ViewClassesCSS = {ClassesCSS.XS3}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DocumentSerie",
            .Label = AccountingExportResources.DocumentSerie,
            .Modelo = Model.Filter,
            .TipoEditor = Mvc.Componentes.F3MTexto,
            .ViewClassesCSS = {ClassesCSS.XS1}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DocumentNumber",
            .Label = AccountingExportResources.DocumentNumber,
            .Modelo = Model.Filter,
            .TipoEditor = Mvc.Componentes.F3MTexto,
            .ViewClassesCSS = {ClassesCSS.XS1}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "EntityType",
            .Label = AccountingExportResources.EntityType,
            .TipoEditor = Mvc.Componentes.F3MDropDownList,
            .CampoTexto = "Description",
            .CampoValor = "Code",
            .Modelo = Model.Filter,
            .Controlador = "../Accounting/AccountingExport",
            .Accao = "GetEntityTypesList",
            .ViewClassesCSS = {ClassesCSS.XS2}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Entity",
            .Label = AccountingExportResources.Entity,
            .Modelo = Model.Filter,
            .TipoEditor = Mvc.Componentes.F3MTexto,
            .ViewClassesCSS = {ClassesCSS.XS4}})
    End Code
</div>