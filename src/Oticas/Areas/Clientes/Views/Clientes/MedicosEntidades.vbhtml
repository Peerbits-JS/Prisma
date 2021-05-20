@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas

<div class="@(ClassesCSS.XS12)">
    <fieldset class="fsStyle">
        <legend class="legendStyle">@OticasTraducao.EstruturaMedicosTecnicos.EntidadeMedicoTecnico</legend>

        <div class="row form-container">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDEntidade1",
                    .Label = OticasTraducao.EstruturaMedicosTecnicos.Entidade1,
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                    .Controlador = "../TabelasAuxiliares/Entidades",
                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                    .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.Entidades,
                    .Modelo = Model,
                    .ViewClassesCSS = {ClassesCSS.XS4}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NumeroBeneficiario1",
                    .Label = OticasTraducao.EstruturaMedicosTecnicos.NumeroBeneficiario1,
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
                    .Label = OticasTraducao.EstruturaMedicosTecnicos.Entidade2,
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                    .Controlador = "../TabelasAuxiliares/Entidades",
                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                    .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.Entidades,
                    .Modelo = Model,
                    .ViewClassesCSS = {ClassesCSS.XS4}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NumeroBeneficiario2",
                    .Label = OticasTraducao.EstruturaMedicosTecnicos.NumeroBeneficiario2,
                    .TipoEditor = Mvc.Componentes.F3MTexto,
                    .Modelo = Model,
                    .ViewClassesCSS = {ClassesCSS.XS4}})
                
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Parentesco2",
                    .Label = Traducao.EstruturaClientes.Parentesco2,
                    .TipoEditor = Mvc.Componentes.F3MTexto,
                    .Modelo = Model,
                    .ViewClassesCSS = {ClassesCSS.XS4}})
            End Code
        </div>
        <div class="row form-container">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMedicoTecnico",
                    .Label = OticasTraducao.EstruturaMedicosTecnicos.MedicoTecnico,
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                    .Controlador = "../TabelasAuxiliares/MedicosTecnicos",
                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                    .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.MedicosTecnicos,
                    .CampoTexto = CamposGenericos.Nome,
                    .Modelo = Model,
                    .ViewClassesCSS = {ClassesCSS.XS4}})
            End Code
        </div>
    </fieldset>
</div>
