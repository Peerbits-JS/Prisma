@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype DocumentosVendas
@Code
    Dim blnEEditavelEntidade2 As Boolean = True

    If Not ViewBag.EEditavelEntidade2 Is Nothing Then
        'blnEEditavelEntidade2 = ViewBag.EEditavelEntidade2
    End If
End Code
<div role="tabpanel" class="tab-pane fade" id="tabComparticipacao">
    <div class="row form-container">
        <div class="col-3">
            <label>@Traducao.EstruturaClientes.Entidade1</label>
            <div class="arrayChecks">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Entidade1Automatica,
                                .Label = Traducao.EstruturaAplicacaoTermosBase.Automatica,
                                .Modelo = Model,
                                .EEditavel = Model.flgEEditavelEntidade1Automatica,
                                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                .ViewClassesCSS = {"f3m-checkbox-sem-top"}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.SegundaVia,
                                                .Label = Traducao.EstruturaAplicacaoTermosBase.SegundaVia,
                                                .Modelo = Model,
                                                .EVisivel = False,
                                                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                                .IgnoraBloqueioAssinatura = True,
                                                .ViewClassesCSS = {"f3m-checkbox-sem-top"}})
                End Code
            </div>
        </div>
        <div class="@ClassesCSS.SoXS9">
            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDEntidade1",
                        .Label = Traducao.EstruturaClientes.Entidade1,
                        .TipoEditor = Mvc.Componentes.F3MLookup,
                        .Controlador = URLs.Areas.TabAux & "Entidades",
                        .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
                        .Modelo = Model,
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NumeroBeneficiario1",
                        .Label = Traducao.EstruturaClientes.NumeroBeneficiario1,
                        .TipoEditor = Mvc.Componentes.F3MTexto,
                        .Modelo = Model,
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Parentesco1",
                        .Label = Traducao.EstruturaClientes.Parentesco1,
                        .TipoEditor = Mvc.Componentes.F3MTexto,
                        .Modelo = Model,
                        .ViewClassesCSS = {ClassesCSS.XS4}})
                End Code
            </div>
            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDEntidade2",
                .Label = Traducao.EstruturaClientes.Entidade2,
                .TipoEditor = Mvc.Componentes.F3MLookup,
                .Controlador = URLs.Areas.TabAux & "Entidades",
                .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                .Modelo = Model,
                .EEditavel = blnEEditavelEntidade2,
                .ViewClassesCSS = {ClassesCSS.XS4}})


                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NumeroBeneficiario2",
                        .Label = Traducao.EstruturaClientes.NumeroBeneficiario2,
                        .TipoEditor = Mvc.Componentes.F3MTexto,
                        .Modelo = Model,
                        .EEditavel = blnEEditavelEntidade2,
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Parentesco2",
                        .Label = Traducao.EstruturaClientes.Parentesco2,
                        .TipoEditor = Mvc.Componentes.F3MTexto,
                        .Modelo = Model,
                        .EEditavel = blnEEditavelEntidade2,
                        .ViewClassesCSS = {ClassesCSS.XS4}})
                End Code
            </div>
        </div>
    </div>
</div>