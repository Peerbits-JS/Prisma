@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios

@Code
    Dim AcaoForm As Int16 = Model.AcaoFormulario
    Dim ativo As Boolean = Model.AtivoSerie
    Dim EEditavel As Boolean = True

    If AcaoForm = AcoesFormulario.Adicionar Then
        ativo = True
    End If


    If Not ativo Then
        EEditavel = False
    End If

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CodigoSerie",
        .Label = Traducao.EstruturaTiposDocumento.Serie,
        .Modelo = Model,
        .EEditavel = IIf(AcaoForm <> AcoesFormulario.Adicionar, False, EEditavel),
        .ViewClassesCSS = {ClassesCSS.XS2}})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DescricaoSerie",
        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
        .Modelo = Model,
        .EEditavel = EEditavel,
        .ViewClassesCSS = {ClassesCSS.XS5}})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDLoja",
        .Label = Traducao.EstruturaAplicacaoTermosBase.LojaSede,
        .Modelo = Model,
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../Administracao/Lojas",
        .FuncaoJSEnviaParams = "TiposDocumentoLojasEnviaParams",
        .EEditavel = Model.AcaoFormulario = AcoesFormulario.Adicionar,
        .ViewClassesCSS = {ClassesCSS.XS3}})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "AtivoSerie",
        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
        .Modelo = Model,
        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
        .EEditavel = IIf(AcaoForm = AcoesFormulario.Adicionar, False, EEditavel),
        .ViewClassesCSS = {ClassesCSS.XS2}})
End Code