@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim grid As Fluent.GridBuilder(Of ComunicacaoSms)
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo, .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao, .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDSistemaComunicacao",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = URLs.Areas.F3MSist & "SistemaComunicacaoSms",
        .DesenhaBotaoLimpar = False,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "Utilizador", .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.TipoEditor = Mvc.Componentes.F3MPassword, .Id = "Chave", .LarguraColuna = 150, .EPassword = True})

    listaCol.Add(New ClsF3MCampo With {.Id = "Remetente", .LarguraColuna = 150})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New ComunicacaoSms().GetType,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Codigo, "asc"}},
        .Campos = listaCol}

    grid = Html.F3M().Grelha(Of ComunicacaoSms)(gf)

    gf.GrelhaHTML = grid.ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code