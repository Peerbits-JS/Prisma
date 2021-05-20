@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid

<div class="grelha-agenda-diaria">
    @Code
        Dim listaCol = New List(Of ClsF3MCampo)
        With listaCol
            .Add(New ClsF3MCampo With {.Id = CamposGenericos.Ativo, .EVisivel = False})
            .Add(New ClsF3MCampo With {.Id = "Tipo", .LarguraColuna = 20, .EVisivel = False})
            .Add(New ClsF3MCampo With {.Id = "HoraExame", .LarguraColuna = 25, .TipoEditor = Mvc.Componentes.F3MTempo, .Formato = "{0:HH:mm}"})
            .Add(New ClsF3MCampo With {.Id = "DescricaoCliente"})
        End With

        'model 4 (taste) grid
        With Model
            .Tipo = GetType(Oticas.Exames)
            .Paginacao = False
            .DesenhaColunaExtra = False
            .AccaoCustomizavelAdicao = "AdicionaEsp"
            .AccaoCustomizavelEdicao = "EditaEsp"
            .URLPartialEspBeforeGrid = "CABIndex"
            .FuncaoJavascriptEnviaParams = "ExamesIndexGridEnviaParams"
            .FuncaoJavascriptGridChange = "ExamesIndexGridFormChange"
            .Campos = listaCol
        End With

        'get grid
        Dim grid As Fluent.GridBuilder(Of Oticas.Exames) = Html.F3M().GrelhaFormulario(Of Oticas.Exames)(Model)
        'set props
        With grid
            .Filterable(Function(f) f.Enabled(False))
            .Resizable(Function(f) f.Columns(False))
        End With
        'render grid
        grid.Render()
    End Code
</div>