@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDEntidadeF3M",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../Sistema/SistemaEntidadesF3M",
        .OpcaoMenuDescAbrev = Menus.Entidades,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDTipoExtensaoFicheiro",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../Sistema/SistemaTiposExtensoesFicheiros",
        .OpcaoMenuDescAbrev = Menus.TiposAnexos,
        .LarguraColuna = 300})

    Dim gf As New ClsMvcKendoGrid With {
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of SistemaTiposAnexos)(gf).ToHtmlString()
End Code

@Html.Partial(gf.PartialViewInterna, gf)