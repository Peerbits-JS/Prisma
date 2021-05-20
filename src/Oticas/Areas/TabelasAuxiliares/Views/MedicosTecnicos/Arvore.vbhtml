@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoTreeview

@Code
    If Model IsNot Nothing Then
        Dim btHTML As String =
            "<a class=""k-button"" onclick=""ArvoreExpandirColapsar(this)"">" &
                "<span id=""divExpCol"" name=""" & Model.Id & """ class=""fm f3icon-contract-vrt-2"" style=""font-size:14px""></span>" &
            "</a><label for=""check-all""> " & Traducao.EstruturaAplicacaoTermosBase.Especialidades & "</label>"
        Dim cbHeaderHTML As String =
            "<input type=""checkbox"" data-tpacess=""{0}"" id=""chk{0}"" onclick=""MedicosTecnicosClicaCBCabecalho(this)"" />" &
            "<label for=""check-all""> {1}</label>"
        Dim cbHeaderHTML_campoPrincipal As String =
            "<label for=""check-all""> {1}</label>"
        Dim cbHTML_campoSelecionado As String =
            "<input type=""checkbox"" data-tpacess=""{0}"" id=""#= id #"" #= {0} ? ""checked=checked"" : """" # #= Selecionado ? "" "" : """" # onclick=""MedicosTecnicosClicaCBSelecionado(this);"" />"
        Dim cbHTML_campoPrincipal As String =
            "<input type=""checkbox"" data-tpacess=""{0}"" id=""#= id #"" #= {0} ? ""checked=checked"" : """" # #= Selecionado ? "" "" : """" # onclick=""MedicosTecnicosClicaCBPrincipal(this);"" />"

        'Dim cbHTML As String =
        '    "<input type=""checkbox"" data-tpacess=""{0}"" id=""#= id #"" #= {0} ? ""checked=checked"" : """" # #= Selecionado ? "" "" : """" # onclick=""MedicosTecnicosClicaCB(this);"" />"
        'Dim cbHTML_auxPrincipal As String =
        '    "<input type=""checkbox"" data-tpacess=""{0}"" id=""#= id #"" #= {0} ? ""checked=checked"" : """" # #= Selecionado ? "" "" : """" # onclick=""MedicosTecnicosClicaCBRecursiva(this);"" />"
        
        Dim listaCol = New List(Of ClsF3MCampo)
        
        

        listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.ID,
            .EChavePrimaria = True,
            .Tipo = GetType(Long)})
        
        listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
            .TemplateCabecalhoColuna = btHTML,
            .LarguraColuna = 250,
            .Tipo = GetType(String)})
        
        listaCol.Add(New ClsF3MCampo With {.Id = "Selecionado",
            .Label = Traducao.EstruturaAplicacaoTermosBase.Selecionar,
            .TemplateCabecalhoColuna = cbHeaderHTML.Replace("{0}", .Id).Replace("{1}", .Label),
            .TemplateColuna = cbHTML_campoSelecionado.Replace("{0}", .Id),
            .LarguraColuna = 125,
            .Tipo = GetType(Boolean)})
        
        listaCol.Add(New ClsF3MCampo With {.Id = "Principal",
            .Label = Traducao.EstruturaAplicacaoTermosBase.Principal,
            .TemplateCabecalhoColuna = cbHeaderHTML_campoPrincipal.Replace("{0}", .Id).Replace("{1}", .Label),
            .TemplateColuna = cbHTML_campoPrincipal.Replace("{0}", .Id),
            .LarguraColuna = 125,
            .Tipo = GetType(Boolean)})

        Model.Campos = listaCol

        Html.F3M().TreeList(Of MedicosTecnicosEspecialidades)(Model).Render()
    End If
End Code

            @*.TemplateColuna = cbHTML.Replace("{0}", .Id),*@