@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Autenticacao
@Imports Traducao.Traducao

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/Entidades/DetalheComum.vbhtml", Model)

@Code
    Dim concorrencia As String = String.Empty
    Dim Ativo = True
    Dim AcaoForm As Int16 = Model.AcaoFormulario
    Dim strObs As String = If(Model IsNot Nothing, Model.Observacoes, String.Empty)

    If AcaoForm <> AcoesFormulario.Adicionar Then
        concorrencia = Model.Concorrencia
    End If

    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    Html.F3M().Hidden(CamposEspecificos.CodigoSistemaTipoEntidade, TiposEntidade.Entidades)
    Html.F3M().Hidden(CamposGenericos.Concorrencia, concorrencia, atrHTML)

End Code
<div class="container-fluid">
    <div class="row desContainer">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
                .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
                .Modelo = Model,
                .AtributosHtml = New With {.class = "textbox-titulo"},
                .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                .Modelo = Model,
                .AtributosHtml = New With {.class = "textbox-titulo"},
                .ViewClassesCSS = {ClassesCSS.XS5}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoEntidade",
                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                .Label = Traducao.EstruturaAplicacaoTermosBase.TipoEntidade,
                .Controlador = "../Sistema/SistemaEntidadeDescricao",
                .Modelo = Model,
                .AtributosHtml = New With {.class = "textbox-titulo"},
                .DesenhaBotaoLimpar = False,
                .ViewClassesCSS = {ClassesCSS.XS2}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                .Modelo = Model,
                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                .AtributosHtml = New With {.class = "textbox-titulo"},
                .ViewClassesCSS = {ClassesCSS.XS2}})
        End Code
    </div>
    <div role="tabpanel" class="f3m-tabs clsF3MTabs">
        <!--Nav tabs-->
        <ul class="nav nav-pills f3m-tabs__ul" role="tablist">
            <li role="presentation" class="nav-item"><a href="#tabHistorico" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaClientes.Historico</a></li>
            <li role="presentation" class="nav-item"><a href="#tabDados" class="nav-link"  role="tab" data-toggle="tab" aria-expanded="true">@Traducao.EstruturaAplicacaoTermosBase.Dados</a></li>
            <li role="presentation" class="nav-item"><a href="#tabMoradasContactos" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.MoradasContactos</a></li>
            <li role="presentation" class="nav-item"><a href="#tabComparticipacoes" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Comparticipacoes</a></li>
            <li role="presentation" class="nav-item"><a href="#tabLojas" role="tab" class="nav-link" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Lojas</a></li>
            <li role="presentation" class="nav-item"><a href="#tabObservacoes" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Observacoes</a></li>
        </ul>
        <div class="tab-content">
            @* HISTORICO *@
            @Html.Action(URLs.HistComumIndex, Menus.Historicos, New With {.Area = Menus.Historicos, .inModelo = Model})
            <div id="tabDados" role="tabpanel" class="tab-pane fade show">
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS3) text-center">
                        @Html.Partial(URLs.PartialFotosIndex, Model)
                    </div>
                    <div class="@(ClassesCSS.XS9)">
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Abreviatura,
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Abreviatura,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS4}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NContribuinte",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.NContribuinte,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS4}})

                                'Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Contabilidade",
                                '    .Label = Traducao.EstruturaAplicacaoTermosBase.Contabilidade,
                                '    .Modelo = Model,
                                '    .ViewClassesCSS = {ClassesCSS.XS4}})

                            End Code
                        </div>
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoDescricao",
                                                                                                    .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                                                                                    .Label = Traducao.EstruturaAplicacaoTermosBase.TipoDescricao,
                                                                                                    .Controlador = "../Sistema/SistemaEntidadeComparticipacao",
                                                                                                    .Modelo = Model,
                                                                                                    .ViewClassesCSS = {ClassesCSS.XS4}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDClienteEntidade",
                                    .Label = "Cliente",
                                    .Controlador = "../Clientes/Clientes",
                                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                                    .TipoEditor = Mvc.Componentes.F3MLookup,
                                    .Modelo = Model,
                                    .EEditavel = True,
                                    .CampoTexto = CamposGenericos.Nome,
                                    .OpcaoMenuDescAbrev = Menus.Clientes,
                                    .ViewClassesCSS = {ClassesCSS.XS4}})
                            End Code
                        </div>
                    </div>
                </div>
            </div>
            <div id="tabMoradasContactos" role="tabpanel" class="tab-pane in fade">
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS12)">
                        @Code
                            ViewBag.VistaParcial = True
                        End Code
                        @Html.Partial("~/Areas/TabelasAuxiliares/Views/EntidadesMoradas/Index.vbhtml")
                    </div>
                </div>
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS12) seguintesgrelhas">
                        @Code
                            ViewBag.VistaParcial = True
                        End Code
                        @Html.Partial("~/Areas/TabelasAuxiliares/Views/EntidadesContatos/Index.vbhtml")
                    </div>
                </div>
            </div>
            <div id="tabComparticipacoes" role="tabpanel" class="tab-pane fade">
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS12)">
                        @Code
                            ViewBag.VistaParcial = True
                        End Code
                        @Html.Partial("~/Areas/TabelasAuxiliares/Views/EntidadesComparticipacoes/Index.vbhtml")
                    </div>
                </div>
            </div>
            <div id="tabLojas" role="tabpanel" class="tab-pane fade">
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS12)">
                        @Code
                            ViewBag.VistaParcial = True
                        End Code
                        @Html.Partial("~/Areas/TabelasAuxiliares/Views/EntidadesLojas/Index.vbhtml")
                    </div>
                </div>
            </div>
            <div id="tabObservacoes" role="tabpanel" class="tab-pane fade show">
                <div class="obs-holder">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Observacoes,
                                        .Label = Traducao.EstruturaArtigos.Observacoes,
                                        .TipoEditor = Mvc.Componentes.F3MTextArea,
                                        .Modelo = Model,
                                        .ValorDescricao = strObs,
                                        .ControladorAccaoExtra = "../TabelasAuxiliares/" & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha",
                                        .CampoValor = "Texto"})
                    End code
                </div>
            </div>
        </div>
    </div>
</div>