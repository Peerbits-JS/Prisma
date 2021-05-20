@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Oticas.Modelos.Constantes
@ModelType MedicosTecnicos

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/MedicosTecnicos/Detalhe.vbhtml", Model)

@Code
    'para filtro TipoEntidade ----
    Dim NumTipoEnt As Integer = ViewBag.NumTotalTipoEntidades
    Dim IDSistemaTiposEntidadeDefeito As Long = ViewBag.IDSistemaTiposEntidadeDefeito
    Dim TipoSistemaTiposEntidadeDefeito As String = ViewBag.TipoSistemaTiposEntidadeDefeito

    Dim TemAgenda As Boolean = 0
    Dim CorFundo As Long = 1
    Dim CorFundo1Vez As Long = 1
    Dim CorTexto As Long = 1
    Dim CorTexto1Vez As Long = 1
    Dim IDLoja As Long = 1
    Dim Tempoporconsulta As Long = 1

    Dim strObs As String = String.Empty
    If Model Is Nothing Then
        strObs = String.Empty
    Else
        strObs = Model.Observacoes
    End If

    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    Html.F3M().Hidden(CamposGenericos.IDMedicoTecnico, Model.ID, atrHTML)
    Html.F3M().Hidden(CamposGenericos.CorFundo, CorFundo, atrHTML)
    Html.F3M().Hidden(CamposGenericos.CorFundo1Vez, CorFundo1Vez, atrHTML)
    Html.F3M().Hidden(CamposGenericos.CorTexto, CorTexto, atrHTML)
    Html.F3M().Hidden(CamposGenericos.CorTexto1Vez, CorTexto1Vez, atrHTML)
    Html.F3M().Hidden(CamposEspecificos.CodigoSistemaTipoEntidade, TiposEntidade.MedicosTecnicos)

    ViewBag.VistaParcial = True

    ViewData("FazCropFotoPessoa") = True

    Dim URLUtilizadores As String = "/F3M/Administracao" & Operadores.Slash & Menus.Utilizadores & Operadores.Slash
    Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)

End Code
<div class="container-fluid">
    <div class="row desContainer">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
        .Modelo = Model,
        .AtributosHtml = New With {.class = "textbox-titulo"},
        .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Nome,
                .Label = Traducao.EstruturaAplicacaoTermosBase.Nome,
                .Modelo = Model,
                .AtributosHtml = New With {.class = "textbox-titulo"},
                .ViewClassesCSS = {ClassesCSS.XS5}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoEntidade",
                .CampoTexto = CamposGenericos.Tipo,
                .Label = Traducao.EstruturaAplicacaoTermosBase.Tipo,
                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                .Controlador = "../Sistema/SistemaTiposEntidade",
                .Modelo = Model,
                .FuncaoJSEnviaParams = "MedicosTecnicosEnviaParametros",
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
            <li role="presentation" class="nav-item"><a href="#tabDadosPessoais" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.DadosPessoais</a></li>
            <li role="presentation" class="nav-item"><a href="#tabMoradasContatos" class="nav-link" role="tab" data-toggle="tab" aria-expanded="true">@Traducao.EstruturaAplicacaoTermosBase.Moradas_Contatos</a></li>
            <li role="presentation" class="nav-item"><a href="#tabEspecialidade"  class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Especialidades</a></li>
            <li role="presentation" class="nav-item"><a href="#tabPlanificacao" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaEmpresas.Planificacao</a></li>
            <li role="presentation" class="nav-item"><a href="#tabObservacoes" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Observacoes</a></li>
        </ul>
        <div class="tab-content">
            @* HISTORICO *@
            @Html.Action(URLs.HistComumIndex, Menus.Historicos, New With {.Area = Menus.Historicos, .inModelo = Model})
            <div id="tabDadosPessoais" role="tabpanel" class="tab-pane fade show ">
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS3) text-center">
                        @Html.Partial(URLs.PartialFotosIndex, Model)
                    </div>
                    <div class="container @ClassesCSS.XS9">
                        <div class="row form-container ">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Abreviatura",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Abreviatura,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Apelido",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Apelido,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataNascimento",
                                    .TipoEditor = Mvc.Componentes.F3MData,
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.DataNascimento,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDSexo",
                                    .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                    .CampoTexto = CamposGenericos.Descricao,
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Sexo,
                                    .Modelo = Model,
                                    .Controlador = URLs.Areas.F3MSist & "SistemaSexo",
                                    .ViewClassesCSS = {ClassesCSS.XS3}})
                            End Code
                        </div>
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NContribuinte",
                                            .Label = Traducao.EstruturaAplicacaoTermosBase.NContribuinte,
                                            .Modelo = Model,
                                            .EObrigatorio = False,
                                            .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NCedula",
                                                    .Label = Traducao.EstruturaAplicacaoTermosBase.NCedula,
                                                    .Modelo = Model,
                                                    .EObrigatorio = False,
                                                    .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CartaoCidadao",
                                                    .Label = Traducao.EstruturaAplicacaoTermosBase.CartaoCidadao,
                                                    .Modelo = Model,
                                                    .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataValidade",
                                                        .TipoEditor = Mvc.Componentes.F3MData,
                                                        .Label = Traducao.EstruturaAplicacaoTermosBase.DataValidade,
                                                        .Modelo = Model,
                                                        .ViewClassesCSS = {ClassesCSS.XS3}})
                            End Code
                        </div>
                    </div>
                </div>
            </div>
            <div id="tabMoradasContatos" role="tabpanel" class="tab-pane fade show">
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS12)">
                        @Html.Partial("~/Areas/TabelasAuxiliares/Views/MedicosTecnicosMoradas/Index.vbhtml")
                    </div>
                </div>
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS12) seguintesgrelhas">
                        @Html.Partial("~/Areas/TabelasAuxiliares/Views/MedicosTecnicosContatos/Index.vbhtml")
                    </div>
                </div>
            </div>
            <div id="tabEspecialidade" role="tabpanel" class="tab-pane fade show">
                <div class="row form-container">
                    <div class="@(ClassesCSS.XS12)">
                        @Code
                            Dim arvore As New ClsMvcKendoTreeview With {
                                .Id = "MedicosTecnicosEspecialidades",
                                .Controlador = "../MedicosTecnicosEspecialidades",
                                .Acao = "ListaEspecialidades",
                                .FuncaoJavascriptEnviaParams = "MedicosTecnicosTreeListEnviaParams",
                                .FuncaoJavascriptDataBound = "MedicosTecnicosTreeListDataBound",
                                .Altura = 320,
                                .AtributosHtml = New With {.class = "grelhaperfis"}}

                            Html.RenderPartial("Arvore", arvore)
                        End Code
                    </div>
                </div>
            </div>
            <div id="tabPlanificacao" role="tabpanel" class="tab-pane fade show">
                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TemAgenda",
                                                            .Label = Traducao.EstruturaAplicacaoTermosBase.TemAgenda,
                                                            .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                                            .Modelo = Model,
                                                            .ViewClassesCSS = {ClassesCSS.XS2}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Cor",
                                                            .Label = Traducao.EstruturaAplicacaoTermosBase.Cor,
                                                            .Modelo = Model,
                                                            .TipoEditor = Mvc.Componentes.F3MColorPicker,
                                                            .ViewClassesCSS = {ClassesCSS.XS2}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoConsulta",
                                                            .Label = "Tipo",
                                                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                                            .Controlador = "../Exames/TiposConsultas/",
                                                            .Modelo = Model,
                                                            .ViewClassesCSS = {ClassesCSS.XS2}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Tempoconsulta",
                                                            .Label = Traducao.EstruturaAplicacaoTermosBase.Tempoporconsulta,
                                                            .Modelo = Model,
                                                            .ValorMaximo = 600,
                                                            .ViewClassesCSS = {ClassesCSS.XS2}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.IDUtilizador,
                                                            .CampoValor = CamposGenericos.ID,
                                                            .CampoTexto = CamposGenericos.UserName,
                                                            .Label = Traducao.EstruturaAplicacaoTermosBase.DescricaoUtilizador,
                                                            .TipoEditor = Mvc.Componentes.F3MLookup,
                                                            .Controlador = "../../" & strProjeto & URLUtilizadores,
                                                            .ControladorAccaoExtra = "../../../" & strProjeto & URLUtilizadores & URLs.ViewIndexGrelha,
                                                            .Modelo = Model,
                                                            .ViewClassesCSS = {ClassesCSS.XS2}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDSistemaAcoes",
                                                            .Label = "Disponibilidade",
                                                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                                            .Controlador = URLs.Areas.F3MSist & "SistemaAcoes",
                                                            .Modelo = Model,
                                                            .ViewClassesCSS = {ClassesCSS.XS2}})


                    End Code
                </div>
                 <div class="form-container">
                <div class="maisde1textarea">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Cabecalho",
                                                            .Label = "Cabeçalho de Receita / Relatório",
                                                            .TipoEditor = Mvc.Componentes.F3MTextArea,
                                                            .Modelo = Model})
                    End Code
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
                                                                .ControladorAccaoExtra = URLs.Areas.TabAux & Menus.TextosBase & "/IndexGrelha",
                                                                .CampoValor = "Texto"})
                        End Code
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>