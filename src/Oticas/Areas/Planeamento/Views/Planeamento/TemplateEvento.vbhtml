@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
<!-- DEFAULT TEMPlATE -->
@*@Html.Partial("~/F3M/Views/Genericas/TemplateSchedulerEvent.vbhtml", New With {.Modelo = Model})*@

<!-- TODO -->
<style>
    .k-scheduler-edit-form label + input {
        margin-left: 0;
    }

    .k-scheduler-edit-form .k-edit-form-container,
    .k-edit-form-container {
        width: auto;
    }
</style>

@Code
    Dim NovoModelo As New F3M.Agendamento

    Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)
End Code

<div class="container-fluid">
    <div class="row form-container">
        <div class="col-9 ValidaForm">
            <div data-bind="invisible: isAllDay" class="row">
                <div class="col-6 col-f3m divLookup alinhamentoesquerda clsF3MCampo">
                    <div>Início<input id="Start" data-role="datetimepicker" data-bind="value: start" class="obrigatorio" /></div>
                </div>
                <div class="col-6 col-f3m divLookup alinhamentoesquerda clsF3MCampo">
                    <div>Fim<input id="End" data-role="datetimepicker" data-bind="value: end" class="obrigatorio" /></div>
                </div>
            </div>
            <div data-bind="visible: isAllDay" class="row">
                <div class="col-6 col-f3m divLookup alinhamentoesquerda clsF3MCampo">
                    <div>Início<input id="Start" data-role="datepicker" data-bind="value: start" class="obrigatorio" /></div>
                </div>
                <div class="col-6 col-f3m divLookup alinhamentoesquerda clsF3MCampo">
                    <div>Fim<input id="End" data-role="datepicker" data-bind="value: end" class="obrigatorio" /></div>
                </div>
            </div>
        </div>
        <div class="col-3 col-f3m divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo p-0 mt-4">
            <div class="checkbox">
                <label class="checkbox-label">
                    Todo o dia
                    <input type="checkbox" class="clsF3MInput k-valid" name="isAllDay" id="isAllDay" data-bind="checked: isAllDay">
                    <span class="checkbox-custom"></span>
                </label>
            </div>
        </div>
    </div>

    @*<div class="row form-container">
            <div class="k-edit-label"><label for="recurrenceRule">Repetir</label></div>
            <div data-container-for="recurrenceRule" class="k-edit-field">
                <div id="recurrenceEditor"></div>
            </div>
        </div>*@

    <div class="row form-container">
        <div class="col-12">
            <div>
                Repete<div data-container-for="recurrenceRule">
                    <div class="ocorrencia-tempo" data-bind="value:recurrenceRule" name="recurrenceRule" data-role="recurrenceeditor"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="row form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDLoja",
        .Label = Traducao.EstruturaAplicacaoTermosBase.Loja,
        .Controlador = "../../" & strProjeto & "/F3M/Administracao/Lojas",
        .OpcaoMenuDescAbrev = Menus.Lojas,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .FuncaoJSEnviaParams = "KendoSchedulerLojasEnviaParams",
        .Modelo = NovoModelo,
        .ECampoKendoTemplate = True,
        .ViewClassesCSS = {ClassesCSS.XS6}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMedicoTecnico",
        .Label = OticasTraducao.EstruturaMedicosTecnicos.MedicoTecnico,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/MedicosTecnicos",
        .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
        .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.MedicosTecnicos,
        .FuncaoJSEnviaParams = "KendoSchedulerMedicoTecnicoEnviaParams",
        .CampoTexto = CamposGenericos.Nome,
        .Modelo = NovoModelo,
        .ECampoKendoTemplate = True,
        .ViewClassesCSS = {ClassesCSS.XS6}})
        End Code
    </div>
</div>
<!-- TODO -->
<script>
    $(document).ready(function () {
        ComboBoxAbrePopup();
    });
</script>