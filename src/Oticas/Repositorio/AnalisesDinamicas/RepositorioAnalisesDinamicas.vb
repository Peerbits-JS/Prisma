Imports System.Data.Entity
Imports F3M
Imports F3M.Areas.AnalisesDinamicasF3M.Models
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Excepcoes.Tipo

Public Class RepositorioAnalisesDinamicas
    Inherits F3M.Repositorio.AnalisesDinamicas.AnalisesDinamicasF3MRepositorio

    Public Overrides Sub CreateMapaVistas(entidade As String, nomeMapa As String, sqlQueryBase As String)
        Dim mapaVista As New MapasVistas
        Dim intOrdem As Integer = 0

        Using inCtx As New BD.Dinamica.Aplicacao
            Dim strQuery As String = "SELECT * From tbMapasVistas Where NomeMapa = 'F3MAnalisesDinamicasBaseF3M'"

            mapaVista = inCtx.Database.SqlQuery(Of MapasVistas)(strQuery).FirstOrDefault

            Dim strQueryOrdem As String = "SELECT Ordem From tbMapasVistas order by ID desc"
            intOrdem = inCtx.Database.SqlQuery(Of Integer)(strQueryOrdem).FirstOrDefault

            'Dim IDMapaVistas As Long = inCtx.Database.SqlQuery(Of Long)("select TOP 1 ID from tbMapasVistas order by ID desc").FirstOrDefault
            Dim IDListaPersonalizada As Long = BDContexto.tbListasPersonalizadas.Where(Function(s) s.Descricao = nomeMapa).Select(Function(i) i.ID).FirstOrDefault

            mapaVista.Entidade = (entidade + "#F3M#" + (IDListaPersonalizada).ToString).Replace(" ", "")
            mapaVista.Entidade = mapaVista.Entidade.Substring(2)
            mapaVista.Descricao = nomeMapa
            mapaVista.NomeMapa = nomeMapa
            mapaVista.MapaXML = mapaVista.MapaXML.Replace("F3MAnalisesDinamicasBaseF3M", nomeMapa)

            Dim mapaVistaAux As New tbMapasVistas With {
                    .Ativo = True, .Caminho = mapaVista.Caminho, .Certificado = mapaVista.Certificado,
                    .Descricao = mapaVista.Descricao,
                    .Entidade = mapaVista.Entidade, .IDLoja = mapaVista.IDLoja, .SQLQuery = sqlQueryBase,
                    .IDModulo = mapaVista.IDModulo, .IDSistemaTipoDoc = mapaVista.IDSistemaTipoDoc, .IDSistemaTipoDocFiscal = mapaVista.IDSistemaTipoDocFiscal,
                    .MapaBin = mapaVista.MapaBin, .MapaXML = mapaVista.MapaXML, .NomeMapa = mapaVista.NomeMapa, .Ordem = intOrdem + 1,
                    .PorDefeito = True, .Sistema = False, .SubReport = False, .Listagem = True,
                    .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome(), .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome(),
                    .DataCriacao = Now(), .DataAlteracao = Now()
                }

            inCtx.tbMapasVistas.Add(mapaVistaAux)
            inCtx.SaveChanges()
        End Using

    End Sub

    Public Overrides Function DeleteAnalysisInDB(model As AnalisesDinamicasF3M) As Boolean
        Try
            Dim IDLista = model.ID
            Dim listaPersonalizada As tbListasPersonalizadas = BDContexto.tbListasPersonalizadas.FirstOrDefault(Function(entity) entity.ID = IDLista)

            'Delete mapa vista 
            Dim strEntityMapaVista As String = (listaPersonalizada.TabelaPrincipal + "#F3M#" + model.ID.ToString).Substring(2)
            Dim lstmapaVista As New List(Of MapasVistas)

            Using inCtx As New BD.Dinamica.Aplicacao

                Dim strQuery As String = "SELECT * From tbMapasVistas Where Entidade = '" + strEntityMapaVista + "'"

                lstmapaVista = inCtx.Database.SqlQuery(Of MapasVistas)(strQuery).ToList

                For Each mapa In lstmapaVista
                    Dim mapaVistaAux As tbMapasVistas = inCtx.tbMapasVistas.Where(Function(m) m.ID = mapa.ID).FirstOrDefault

                    inCtx.tbMapasVistas.Add(mapaVistaAux)
                    inCtx.Entry(mapaVistaAux).State = EntityState.Deleted
                Next
                inCtx.SaveChanges()
            End Using

            Dim analysisConfig As tbConfiguracoesConsultas = BDContexto.tbConfiguracoesConsultas.FirstOrDefault(Function(w) w.IDListaPersonalizada = model.ID)
            If analysisConfig IsNot Nothing Then
                Dim deleteAggregatesQuery As String = String.Concat("DELETE FROM tbOpConsultasGruposPorDefeito WHERE IDConfiguracoesConsultas=", analysisConfig.ID, ";",
                                                                    "DELETE FROM tbOpConsultasTotaisRodape WHERE IDConfiguracoesConsultas=", analysisConfig.ID, ";",
                                                                    "DELETE FROM tbOpConsultasTotaisGrupo WHERE IDConfiguracoesConsultas=", analysisConfig.ID, ";",
                                                                    "DELETE FROM tbConfiguracoesConsultas WHERE IDListaPersonalizada=", IDLista, ";")

                BDContexto.Database.ExecuteSqlCommand(deleteAggregatesQuery)
            End If

            Dim deleteQuery As String = String.Concat("DELETE FROM tbCondicoesListasPersonalizadas WHERE IDListaPersonalizada=", IDLista, ";",
                                                      "DELETE FROM tbParametrosListasPersonalizadas WHERE IDListaPersonalizada=", IDLista, ";",
                                                      "DELETE FROM tbColunasListasPersonalizadas WHERE IDListaPersonalizada=", IDLista, ";",
                                                      "DELETE FROM tbListasPersonalizadas WHERE ID=", IDLista, ";")

            BDContexto.Database.ExecuteSqlCommand(deleteQuery)

        Catch
            Throw
        End Try

        Return True
    End Function



    Public Overrides Function Edit(model As AnalisesDinamicasF3M) As Long
        If model.ViewGrid Then
            Dim IDConfiguracaoConsulta As Long = SaveConfiguracoesConsulta(BDContexto, model, model.IDListaSelecionada)
            CreateGruposPorDefeito(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisGrupo(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisRodape(BDContexto, model, IDConfiguracaoConsulta)
            CreateColunas(BDContexto, model, model.IDListaSelecionada)
            BDContexto.SaveChanges()
        End If

        Dim analysisToEdit As tbListasPersonalizadas = BDContexto.tbListasPersonalizadas.FirstOrDefault(Function(w) w.ID = model.IDListaSelecionada)

        With analysisToEdit
            .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome : .DataAlteracao = Now()
        End With
        BDContexto.Entry(analysisToEdit).State = EntityState.Modified
        BDContexto.SaveChanges()

        Return model.ID
    End Function

    Public Overrides Function Create(model As AnalisesDinamicasF3M) As Long
        model.IDLstPersonalizadaReferencia = model.IDListaSelecionada

        Dim listaPersonalizada As tbListasPersonalizadas = CreateListaPersonalizadaByListaPersonalizada(BDContexto, model)
        Dim IDConfiguracaoConsultaOrigem As Long = BDContexto.tbConfiguracoesConsultas.FirstOrDefault(Function(entity) entity.IDListaPersonalizada = model.IDLstPersonalizadaReferencia)?.ID

        model.ID = listaPersonalizada.ID

        Dim IDConfiguracaoConsulta As Long = SaveConfiguracoesConsulta(BDContexto, model, listaPersonalizada.ID)
        If (model.ViewGrid) Then
            CreateGruposPorDefeito(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisGrupo(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisRodape(BDContexto, model, IDConfiguracaoConsulta)
            CreateColunas(BDContexto, model, listaPersonalizada.ID)
        Else
            CreateGruposByListaPersonalizada(BDContexto, IDConfiguracaoConsulta, IDConfiguracaoConsultaOrigem)
            CreateTotaisGrupoByListaPersonalizada(BDContexto, IDConfiguracaoConsulta, IDConfiguracaoConsultaOrigem)
            CreateTotaisRodapeByListaPersonalizada(BDContexto, IDConfiguracaoConsulta, IDConfiguracaoConsultaOrigem)
            CreateColunasByListaPersonalizada(BDContexto, listaPersonalizada.ID, model.IDLstPersonalizadaReferencia)
        End If

        CreateFiltersByListaPersonalizada(BDContexto, listaPersonalizada.ID, model.IDLstPersonalizadaReferencia)
        CreateParamsByListasPersonalizadas(BDContexto, listaPersonalizada.ID, model.IDLstPersonalizadaReferencia)
        CreateConditionsByListaPersonalizada(BDContexto, listaPersonalizada.ID, model.IDLstPersonalizadaReferencia)
        CreatePerfisAcessosAreasEmpresa(BDContexto, listaPersonalizada.ID)

        BDContexto.SaveChanges()

        CopyMapavistafromListaPersonalizada(model)

        Return listaPersonalizada.ID
    End Function

    Public Overrides Sub CopyMapavistafromListaPersonalizada(model As AnalisesDinamicasF3M)
        Dim strEntidadeRef As String = String.Empty
        Dim lstMapaVistas As New List(Of tbMapasVistas)
        Dim intOrdem As Long = 0

        If model.IDLstPersonalizadaReferencia IsNot Nothing AndAlso model.IDLstPersonalizadaReferencia > 0 Then
            strEntidadeRef = GetEntidadeListaPersonalizadaByID(model.IDLstPersonalizadaReferencia).Substring(2)
        End If

        If Not String.IsNullOrEmpty(strEntidadeRef) Then
            Using ctx As New BD.Dinamica.Aplicacao

                Dim strQuery As String = "SELECT * From tbMapasVistas Where Entidade = '" & strEntidadeRef & "'"
                lstMapaVistas = ctx.Database.SqlQuery(Of tbMapasVistas)(strQuery).ToList

                Dim strQueryOrdem As String = "SELECT Ordem From tbMapasVistas order by ID desc"
                intOrdem = ctx.Database.SqlQuery(Of Integer)(strQueryOrdem).FirstOrDefault

                Dim listaPersonalizada As tbListasPersonalizadas = BDContexto.tbListasPersonalizadas.FirstOrDefault(Function(s) s.Descricao = model.Descricao)

                For Each mapa In lstMapaVistas
                    intOrdem = intOrdem + 1
                    Dim mapaVistaAux As New tbMapasVistas

                    With mapaVistaAux
                        .Caminho = mapa.Caminho
                        .Ordem = intOrdem
                        .Certificado = mapa.Certificado
                        .Descricao = mapa.Descricao
                        .Entidade = (model.TabelaPrincipal + "#F3M#" + listaPersonalizada.ID.ToString).Substring(2)
                        .IDLoja = mapa.IDLoja
                        .SQLQuery = listaPersonalizada.Query
                        .IDModulo = mapa.IDModulo
                        .IDSistemaTipoDoc = mapa.IDSistemaTipoDoc
                        .IDSistemaTipoDocFiscal = mapa.IDSistemaTipoDocFiscal
                        .MapaBin = mapa.MapaBin
                        .MapaXML = mapa.MapaXML
                        .NomeMapa = mapa.NomeMapa
                        .PorDefeito = mapa.PorDefeito
                        .SubReport = False : .Listagem = True
                        .Ativo = mapa.Ativo : .Sistema = False
                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome : .DataCriacao = Now()
                    End With

                    GravaEntidadeLinha(Of tbMapasVistas)(ctx, mapaVistaAux, AcoesFormulario.Adicionar, Nothing)
                Next
                ctx.SaveChanges()
            End Using
        End If
    End Sub

    Public Overrides Function CreateFromManager(model As AnalisesDinamicasF3M) As Long
        model.IDLstPersonalizadaReferencia = model.IDListaSelecionada

        Dim listaPersonalizada As tbListasPersonalizadas = CreateListaPersonalizada(BDContexto, model)
        Dim IDConfiguracaoConsultaOrigem As Long? = BDContexto.tbConfiguracoesConsultas.FirstOrDefault(Function(entity) entity.IDListaPersonalizada = model.IDLstPersonalizadaReferencia)?.ID

        With model
            .ID = listaPersonalizada.ID : .IDListaSelecionada = listaPersonalizada.ID
        End With

        Dim IDConfiguracaoConsulta As Long = SaveConfiguracoesConsulta(BDContexto, model, model.IDListaSelecionada)
        If model.ViewGrid Then
            CreateGruposPorDefeito(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisGrupo(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisRodape(BDContexto, model, IDConfiguracaoConsulta)
            CreateColunas(BDContexto, model, model.IDListaSelecionada)

        Else
            If Not IDConfiguracaoConsultaOrigem Is Nothing AndAlso IDConfiguracaoConsultaOrigem <> 0 Then
                CreateGruposByListaPersonalizada(BDContexto, IDConfiguracaoConsulta, IDConfiguracaoConsultaOrigem)
                CreateTotaisGrupoByListaPersonalizada(BDContexto, IDConfiguracaoConsulta, IDConfiguracaoConsultaOrigem)
                CreateTotaisRodapeByListaPersonalizada(BDContexto, IDConfiguracaoConsulta, IDConfiguracaoConsultaOrigem)
                CreateColunasByListaPersonalizada(BDContexto, listaPersonalizada.ID, model.IDLstPersonalizadaReferencia)
            End If
        End If

        CreateFilters(BDContexto, model)
        CreateParams(BDContexto, model)
        CreateConditions(BDContexto, model)
        CreatePerfisAcessosAreasEmpresa(BDContexto, listaPersonalizada.ID)
        BDContexto.SaveChanges()

        If model.IDLstPersonalizadaReferencia IsNot Nothing AndAlso model.IDLstPersonalizadaReferencia > 0 Then
            CopyMapavistafromListaPersonalizada(model)
        Else
            CreateMapaVistas(model.TabelaPrincipal, model.Descricao, model.Query)
        End If

        Return listaPersonalizada.ID
    End Function

    Public Overrides Function EditFromManager(model As AnalisesDinamicasF3M) As Long
        If model.ViewGrid Then
            Dim IDConfiguracaoConsulta As Long = SaveConfiguracoesConsulta(BDContexto, model, model.IDListaSelecionada)
            CreateGruposPorDefeito(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisGrupo(BDContexto, model, IDConfiguracaoConsulta)
            CreateTotaisRodape(BDContexto, model, IDConfiguracaoConsulta)
            CreateColunas(BDContexto, model, model.IDListaSelecionada)
        End If
        CreateFilters(BDContexto, model)
        CreateParams(BDContexto, model)
        CreateConditions(BDContexto, model)

        BDContexto.SaveChanges()

        Dim analysisToEdit As tbListasPersonalizadas = BDContexto.tbListasPersonalizadas.FirstOrDefault(Function(w) w.ID = model.IDListaSelecionada)

        With analysisToEdit
            .Query = model.Query
            .Descricao = model.Descricao : .IDSistemaCategListasPers = model.IDSistemaCategListasPers
            .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome : .DataAlteracao = Now()
        End With
        BDContexto.Entry(analysisToEdit).State = EntityState.Modified
        BDContexto.SaveChanges()

        ChangeSqlQueryMapasVistas(model.ID, model.Query)

        Return model.ID
    End Function

    Public Overrides Sub ChangeSqlQueryMapasVistas(IDListaPerrsonalizada As Long, strSqlQuery As String)
        Using ctx As New BD.Dinamica.Aplicacao

            Dim strQuery = "Select * from tbMapasVistas WHERE Entidade LIKE ('%#F3M#" + IDListaPerrsonalizada.ToString + "')"

            Dim auxMapaVista As tbMapasVistas = ctx.Database.SqlQuery(Of tbMapasVistas)(strQuery).FirstOrDefault
            auxMapaVista.SQLQuery = strSqlQuery

            ctx.Entry(auxMapaVista).State = EntityState.Modified
            ctx.SaveChanges()
        End Using
    End Sub

End Class