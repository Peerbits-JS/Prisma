Imports System.Data.Entity
Imports System.Threading.Tasks
Imports F3M.F3MHubs
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Repositorio
Imports Newtonsoft.Json
Imports Oticas.Areas.Communication.Models
Imports Oticas.BD.Dinamica

Namespace Repositorio.Communication
    Public Class RepositorioComunicacaoSmsTemplates
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, Object, Object)

        ReadOnly _repositorioComunicacao As RepositorioComunicacao

#Region "ctor"
        Sub New()
            MyBase.New()

            _repositorioComunicacao = New RepositorioComunicacao
        End Sub
#End Region

        Public Function GetTemplates() As List(Of CommunicationSmsSettingsTemplates)
            Return BDContexto.
                tbComunicacaoSmsTemplates.
                AsNoTracking().
                Select(Function(entity) New CommunicationSmsSettingsTemplates With {.ID = entity.ID, .Descricao = entity.Nome}).
                OrderBy(Function(entity) entity.Descricao).
                ToList()
        End Function

#Region "default values"
        Public Function GetMsgSystemDefault() As Long?
            Return BDContexto.
                tbComunicacao.
                AsNoTracking().
                OrderBy(Function(entity) entity.Descricao).
                FirstOrDefault(Function(entity) entity.Ativo)?.ID
        End Function

        Public Function GetNovoGrupoDefaultValues() As CommunicationSmsTemplatesGrupos
            Return New CommunicationSmsTemplatesGrupos With {
                .Ordem = 1,
                .MainCondition = "AND",
                .Regras = New List(Of CommunicationSmsTemplatesRegras) From {New CommunicationSmsTemplatesRegras With {
                .Ordem = 1,
                .Filtros = GetFiltros()}}
            }
        End Function

#Region "   rules"
        Public Function GetFiltros() As List(Of CommunicationSmsTemplatesFiltros)
            Return BDContexto.
                tbSistemaComunicacaoSmsTemplatesFiltros.
                AsNoTracking().
                Where(Function(entity) entity.Ativo).
                Select(Function(entity) New CommunicationSmsTemplatesFiltros With {
                .ID = entity.ID, .Descricao = entity.Descricao, .Ordem = entity.Ordem}).
                OrderBy(Function(entity) entity.Descricao).
                ToList()
        End Function

        Public Function GetCondicoes(idFiltro As Long, Optional idCondicaoSelected As Long = 0) As List(Of CommunicationSmsTemplatesCondicoes)
            Return BDContexto.
                tbSistemaComunicacaoSmsTemplatesCondicoes.
                AsNoTracking().
                Include("tbSistemaComunicacaoSmsTemplatesFiltros").
                Where(Function(entity) entity.IDSistemaComunicacaoSmsTemplatesFiltros = idFiltro AndAlso entity.Ativo).
                Select(Function(entity) New CommunicationSmsTemplatesCondicoes With {
                .ID = entity.ID, .Descricao = entity.Descricao, .Ordem = entity.Ordem,
                .IDCondicaoSelected = idCondicaoSelected}).
                OrderBy(Function(entity) entity.Descricao).ThenBy(Function(entity) entity.Ordem).
                ToList()
        End Function

        Public Function GetValores(idCondicao As Long) As List(Of CommunicationSmsTemplatesValores)
            Return BDContexto.tbSistemaComunicacaoSmsTemplatesValores.
                AsNoTracking().
                Where(Function(entity) entity.IDSistemaComunicacaoSmsTemplatesCondicoes = idCondicao).
                Select(Function(entity) New CommunicationSmsTemplatesValores With {
                .IDSistemaComunicacaoSmsTemplatesValores = entity.ID, .TipoComponente = entity.TipoComponente,
                .MinValue = entity.MinValue, .MaxValue = entity.MaxValue, .DefaultValue = entity.DefaultValue, .Placeholder = entity.Placeholder,
                .CssClasses = entity.CssClasses, .SqlQueryWhere = entity.SqlQueryWhere, .Ordem = entity.Ordem}).
                OrderBy(Function(entity) entity.Ordem).
                ToList()
        End Function

        Public Function GetSqlQueryValores(idValor As Long) As List(Of SqlQuery)
            Dim query As String = BDContexto.tbSistemaComunicacaoSmsTemplatesValores.
                AsNoTracking().
                FirstOrDefault(Function(entity) entity.ID = idValor).SqlQuery
            If Not String.IsNullOrEmpty(query) Then
                Return BDContexto.Database.SqlQuery(Of SqlQuery)(query).ToList()
            End If
            Return New List(Of SqlQuery)
        End Function
#End Region
#End Region

#Region "crud"

#Region "   copy"
        Public Function Copy(idTemplate As Long) As CommunicationSmsTemplates
            Dim copyTemplate As CommunicationSmsTemplates = Read(idTemplate)

            With copyTemplate
                .ID = 0 : .Nome = String.Empty
                .Grupo.ID = 0
            End With

            For Each grupo In copyTemplate.Grupo.Grupos
                grupo.ID = 0

                For Each regra In grupo.Regras
                    regra.ID = 0

                    For Each valor In regra.Valores
                        valor.ID = 0
                    Next
                Next
            Next

            Return copyTemplate
        End Function
#End Region

#Region "   read"
        Public Function Read(idTemplate As Long) As CommunicationSmsTemplates
            'get template
            Dim entityTemplate As tbComunicacaoSmsTemplates = BDContexto.
                tbComunicacaoSmsTemplates.
                AsNoTracking().
                Include("tbComunicacaoSmsTemplatesGrupos").
                FirstOrDefault(Function(entity) entity.ID = idTemplate)

            Dim eg As tbComunicacaoSmsTemplatesGrupos = entityTemplate.
                tbComunicacaoSmsTemplatesGrupos.
                FirstOrDefault(Function(entity) entity.IDComunicacaoSmsTemplatesGrupos Is Nothing AndAlso entity.Ordem = 1)

            Dim template As CommunicationSmsTemplates = New CommunicationSmsTemplates With {
                .ID = entityTemplate.ID, .Nome = entityTemplate.Nome,
                .IDSistemaEnvio = entityTemplate.IDSistemaEnvio,
                .DescricaoSistemaEnvio = entityTemplate.tbComunicacao.Descricao,
                .IDParametrizacaoConsentimentosPerguntas = If(entityTemplate.IDParametrizacaoConsentimentosPerguntas Is Nothing, 0, entityTemplate.IDParametrizacaoConsentimentosPerguntas),
                .DescricaoParametrizacaoConsentimentosPerguntas = If(entityTemplate.IDParametrizacaoConsentimentosPerguntas Is Nothing, "Cliente Permite Comunicações", entityTemplate.tbParametrizacaoConsentimentosPerguntas.Descricao),
                .Grupo = New CommunicationSmsTemplatesGrupos With {.ID = eg.ID, .MainCondition = eg.MainCondition, .Ordem = eg.Ordem,
                .Regras = eg.tbComunicacaoSmsTemplatesRegras.
                Select(Function(entity) New CommunicationSmsTemplatesRegras With {
                .ID = entity.ID, .Ordem = entity.Ordem, .IDFiltro = entity.IDSistemaComunicacaoSmsTemplatesFiltros, .IDCondicao = entity.IDSistemaComunicacaoSmsTemplatesCondicoes,
                .Filtros = GetFiltros(), .Condicoes = GetCondicoes(.IDFiltro, .IDCondicao), .Valores = ReadValores(entity)}).ToList()}
            }

            ReadGrupos(template.Grupo, eg)


            With template.Recipts
                .AvailableCredits = _repositorioComunicacao.GetSmsBalance(template.IDSistemaEnvio)
            End With

            'get regras
            Return template
        End Function

        Public Sub ReadGrupos(grupo As CommunicationSmsTemplatesGrupos, entityGrupo As tbComunicacaoSmsTemplatesGrupos)
            For Each g In entityGrupo.tbComunicacaoSmsTemplatesGrupos1
                Dim g1 As CommunicationSmsTemplatesGrupos = New CommunicationSmsTemplatesGrupos With {
                    .ID = g.ID, .MainCondition = g.MainCondition, .Ordem = g.Ordem,
                    .Grupos = New List(Of CommunicationSmsTemplatesGrupos),
                    .Regras = g.tbComunicacaoSmsTemplatesRegras.
                    Select(Function(entity) New CommunicationSmsTemplatesRegras With {
                    .ID = entity.ID, .Ordem = entity.Ordem, .IDFiltro = entity.IDSistemaComunicacaoSmsTemplatesFiltros, .IDCondicao = entity.IDSistemaComunicacaoSmsTemplatesCondicoes,
                    .Filtros = GetFiltros(), .Condicoes = GetCondicoes(.IDFiltro, .IDCondicao), .Valores = ReadValores(entity)}).ToList()
                }
                grupo.Grupos.Add(g1)

                If g.tbComunicacaoSmsTemplatesGrupos1.Any() Then
                    ReadGrupos(g1, g)
                End If
            Next
        End Sub

        Private Function ReadValores(regra As tbComunicacaoSmsTemplatesRegras) As List(Of CommunicationSmsTemplatesValores)
            Dim lstOfValores As New List(Of CommunicationSmsTemplatesValores)

            For Each v In regra.tbComunicacaoSmsTemplatesValores
                Dim valor = New CommunicationSmsTemplatesValores With {
                .ID = v.ID, .IDSistemaComunicacaoSmsTemplatesValores = v.IDSistemaComunicacaoSmsTemplatesValores,
                .Valor = v.Valor,
                .TipoComponente = v.tbSistemaComunicacaoSmsTemplatesValores.TipoComponente,
                .MinValue = v.tbSistemaComunicacaoSmsTemplatesValores.MinValue, .MaxValue = v.tbSistemaComunicacaoSmsTemplatesValores.MaxValue,
                .DefaultValue = v.tbSistemaComunicacaoSmsTemplatesValores.DefaultValue, .Placeholder = v.tbSistemaComunicacaoSmsTemplatesValores.Placeholder,
                .CssClasses = v.tbSistemaComunicacaoSmsTemplatesValores.CssClasses, .SqlQueryWhere = v.tbSistemaComunicacaoSmsTemplatesValores.SqlQueryWhere}

                If valor.TipoComponente = "select" OrElse valor.TipoComponente = "multiselect" Then
                    valor.SqlQueryValores = GetSqlQueryValores(valor.IDSistemaComunicacaoSmsTemplatesValores)
                End If

                lstOfValores.Add(valor)
            Next

            Return lstOfValores
        End Function
#End Region

#Region "   create"
        Public Function Create(model As CommunicationSmsTemplates)
            Try
                Using ctx As New Aplicacao
                    'start transaction
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                        Try
                            Dim templateEntity As New tbComunicacaoSmsTemplates
                            With templateEntity
                                .Nome = model.Nome
                                .IDSistemaEnvio = model.IDSistemaEnvio
                                If model.IDParametrizacaoConsentimentosPerguntas = 0 Then
                                    .IDParametrizacaoConsentimentosPerguntas = Nothing
                                Else
                                    .IDParametrizacaoConsentimentosPerguntas = model.IDParametrizacaoConsentimentosPerguntas
                                End If
                                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome : .DataCriacao = DateTime.Now()
                            End With

                            AddGrupos(ctx, model.Grupo, templateEntity, Nothing, Nothing)

                            With ctx
                                .tbComunicacaoSmsTemplates.Add(templateEntity)
                                .Entry(templateEntity).State = EntityState.Added
                                .SaveChanges()
                            End With

                            model.ID = templateEntity.ID

                            'commit
                            trans.Commit()
                        Catch ex As Exception
                            'rollback it!
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                Throw
            End Try

            Return model
        End Function

        Public Function AddGrupos(ctx As Aplicacao,
                             grupo As CommunicationSmsTemplatesGrupos,
                             entity As tbComunicacaoSmsTemplates,
                             entityGrupo As tbComunicacaoSmsTemplatesGrupos,
                             IDComunicacaoSmsTemplates As Long) As tbComunicacaoSmsTemplatesGrupos

            Dim entityTemplateGrupo As New tbComunicacaoSmsTemplatesGrupos With {
                .ID = 0, .IDComunicacaoSmsTemplates = IDComunicacaoSmsTemplates, .IDComunicacaoSmsTemplatesGrupos = Nothing,
                .MainCondition = grupo.MainCondition,
                .Ordem = grupo.Ordem, .Ativo = True,
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome, .DataCriacao = DateAndTime.Now()}

            AddRegras(ctx, grupo, entityTemplateGrupo)

            If Not entity Is Nothing Then
                entity.tbComunicacaoSmsTemplatesGrupos.Add(entityTemplateGrupo)
            Else
                entityGrupo.tbComunicacaoSmsTemplatesGrupos1.Add(entityTemplateGrupo)
            End If

            If grupo.Grupos?.Any() Then
                For Each subgrupo As CommunicationSmsTemplatesGrupos In grupo.Grupos
                    AddGrupos(ctx, subgrupo, Nothing, entityTemplateGrupo, IDComunicacaoSmsTemplates)
                Next
            End If

            Return entityTemplateGrupo
        End Function

        Private Sub AddRegras(ctx As Aplicacao,
                               grupo As CommunicationSmsTemplatesGrupos,
                               entityGrupo As tbComunicacaoSmsTemplatesGrupos)

            For Each regra In grupo.Regras
                Dim en = New tbComunicacaoSmsTemplatesRegras With {
                                                                .ID = Nothing, .IDComunicacaoSmsTemplatesGrupos = Nothing,
                                                                .IDSistemaComunicacaoSmsTemplatesFiltros = regra.IDFiltro,
                                                                .IDSistemaComunicacaoSmsTemplatesCondicoes = regra.IDCondicao,
                                                                .Ordem = regra.Ordem,
                                                                .Ativo = True, .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome, .DataCriacao = DateAndTime.Now()}

                entityGrupo.tbComunicacaoSmsTemplatesRegras.Add(en)

                AddValores(ctx, regra, en)
            Next
        End Sub

        Private Sub AddValores(ctx As Aplicacao,
                               regra As CommunicationSmsTemplatesRegras,
                               entityRegra As tbComunicacaoSmsTemplatesRegras)

            For Each v In regra.Valores
                entityRegra.tbComunicacaoSmsTemplatesValores.Add(New tbComunicacaoSmsTemplatesValores With {
                    .ID = Nothing, .IDComunicacaoSmsTemplatesRegras = Nothing,
                    .Ordem = v.Ordem, .Valor = v.Valor,
                    .IDSistemaComunicacaoSmsTemplatesValores = v.IDSistemaComunicacaoSmsTemplatesValores,
                    .Ativo = True, .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome, .DataCriacao = DateAndTime.Now()
                })
            Next
        End Sub
#End Region

#Region "   update"
        Public Function Update(model As CommunicationSmsTemplates)
            Try
                Using ctx As New Aplicacao
                    'start transaction
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                        Try
                            Dim templateEntity As tbComunicacaoSmsTemplates = ctx.tbComunicacaoSmsTemplates.FirstOrDefault(Function(entity) entity.ID = model.ID)

                            With templateEntity
                                .Nome = model.Nome
                                .IDSistemaEnvio = model.IDSistemaEnvio
                                If model.IDParametrizacaoConsentimentosPerguntas = 0 Then
                                    .IDParametrizacaoConsentimentosPerguntas = Nothing
                                Else
                                    .IDParametrizacaoConsentimentosPerguntas = model.IDParametrizacaoConsentimentosPerguntas
                                End If
                                .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome() : .DataAlteracao = DateAndTime.Now()
                            End With

                            With ctx
                                .tbComunicacaoSmsTemplates.Add(templateEntity)
                                .Entry(templateEntity).State = EntityState.Modified
                                .SaveChanges()
                            End With

                            DeleteGruposRegrasValores(ctx, templateEntity)

                            Dim grupoEntity As tbComunicacaoSmsTemplatesGrupos = AddGrupos(ctx, model.Grupo, templateEntity, Nothing, templateEntity.ID)

                            With ctx
                                .tbComunicacaoSmsTemplatesGrupos.Add(grupoEntity)
                                .Entry(grupoEntity).State = EntityState.Added
                                .SaveChanges()
                            End With

                            'commit
                            trans.Commit()
                        Catch ex As Exception
                            'rollback it!
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                Throw
            End Try

            Return model
        End Function
#End Region

#Region "   delete"
        Public Function Delete(idTemplate As Long) As Boolean
            Try
                Using ctx As New Aplicacao
                    'start transaction
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                        Try
                            Dim entityToDelete As tbComunicacaoSmsTemplates = ctx.
                                tbComunicacaoSmsTemplates.
                                FirstOrDefault(Function(entity) entity.ID = idTemplate)

                            DeleteGruposRegrasValores(ctx, entityToDelete)

                            With ctx
                                .tbComunicacaoSmsTemplates.Remove(entityToDelete)
                                .Entry(entityToDelete).State = EntityState.Deleted
                                .SaveChanges()
                            End With

                            'commit
                            trans.Commit()
                        Catch ex As Exception
                            'rollback it!
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                Throw
            End Try

            Return True
        End Function

        Private Sub DeleteGruposRegrasValores(ctx As Aplicacao, entity As tbComunicacaoSmsTemplates)
            Dim lstGrupos As List(Of tbComunicacaoSmsTemplatesGrupos) = entity.tbComunicacaoSmsTemplatesGrupos.ToList()
            Dim lstRegras As New List(Of tbComunicacaoSmsTemplatesRegras)
            Dim lstValores As New List(Of tbComunicacaoSmsTemplatesValores)

            For Each grupo In entity.tbComunicacaoSmsTemplatesGrupos
                lstRegras.AddRange(grupo.tbComunicacaoSmsTemplatesRegras.ToList())
                For Each regra In grupo.tbComunicacaoSmsTemplatesRegras
                    lstValores.AddRange(regra.tbComunicacaoSmsTemplatesValores.ToList())
                Next
            Next

            With ctx
                .tbComunicacaoSmsTemplatesValores.RemoveRange(lstValores)
                lstValores.ForEach(Sub(f)
                                       .Entry(f).State = EntityState.Deleted
                                   End Sub)

                .tbComunicacaoSmsTemplatesRegras.RemoveRange(lstRegras)
                lstRegras.ForEach(Sub(f)
                                      .Entry(f).State = EntityState.Deleted
                                  End Sub)

                .tbComunicacaoSmsTemplatesGrupos.RemoveRange(lstGrupos)
                lstGrupos.ForEach(Sub(f)
                                      .Entry(f).State = EntityState.Deleted
                                  End Sub)

                .SaveChanges()
            End With
        End Sub
#End Region

#End Region

#Region "recipts"
        Public Function GetRecipts(idTemplate As Long) As List(Of ReciptsGrid)
            Return BDContexto.Database.SqlQuery(Of ReciptsGrid)(GetSqlQuery(idTemplate)).ToList()
        End Function

        Private Function GetSqlQuery(idTemplate As Long) As String
            Dim templateEntity As tbComunicacaoSmsTemplates = BDContexto.tbComunicacaoSmsTemplates.AsNoTracking().FirstOrDefault(Function(entity) entity.ID = idTemplate)
            Dim mainGrupo As tbComunicacaoSmsTemplatesGrupos = templateEntity.tbComunicacaoSmsTemplatesGrupos.FirstOrDefault(Function(entity) entity.IDComunicacaoSmsTemplatesGrupos Is Nothing)

            Dim strSql As String = ""
            If templateEntity.IDParametrizacaoConsentimentosPerguntas >0 then
                strSql &= " SELECT DISTINCT tbClientes.ID, tbClientes.Codigo, tbClientes.Nome, CLICONT.Telemovel "
                strSql &= " FROM tbClientes "
                strSql &= "     INNER JOIN"
                strSql &= "         (SELECT  IDCodigoEntidade, CodigoEntidade, r.IDParametrizacaoConsentimentoPerguntas, max(r.IDConsentimento) as IDConsentimento "
                strSql &= "         from tbConsentimentos c inner join tbRespostasConsentimentos r on c.id=r.IDConsentimento "
                strSql &= "         group by IDCodigoEntidade, CodigoEntidade, r.IDParametrizacaoConsentimentoPerguntas) "
                strSql &= "         AS CONS ON CONS.IDCodigoEntidade = tbClientes.ID "
                strSql &= "     INNER JOIN tbRespostasConsentimentos AS RESPCONS ON RESPCONS.IDConsentimento = CONS.IDConsentimento "
                strSql &= "     LEFT JOIN tbClientesContatos AS CLICONT ON CLICONT.IDCliente = tbClientes.ID AND CLICONT.Ordem = 1 "
                strSql &= "     LEFT JOIN tbDocumentosVendas AS VENDAS ON  VENDAS.IDEntidade = tbClientes.ID "
                strSql &= "     LEFT JOIN tbDocumentosVendasLinhas AS VENDASLINHAS ON VENDASLINHAS.IDDocumentoVenda = VENDAS.ID "
                strSql &= "     LEFT JOIN tbArtigos AS ART ON ART.ID = VENDASLINHAS.IDArtigo "
                strSql &= "     LEFT JOIN tbLentesOftalmicas AS LO ON LO.IDArtigo = ART.ID "
                strSql &= "     LEFT JOIN tbLentesContato AS LC ON LC.IDArtigo = ART.ID "
                strSql &= "     LEFT JOIN tbModelos AS MODELOS ON MODELOS.ID = LO.IDModelo "
                strSql &= "     LEFT JOIN tbModelos AS MODELOS_LC ON MODELOS.ID = LC.IDModelo "
                strSql &= "     LEFT JOIN tbEstados AS ESTADOS ON ESTADOS.ID = VENDAS.IDEstado "
                strSql &= "     LEFT JOIN tbSistemaTiposEstados AS SISTIPOSESTADOS ON SISTIPOSESTADOS.ID = ESTADOS.IDTipoEstado "
                strSql &= "     LEFT JOIN tbTiposDocumento AS TIPOSDOC ON TIPOSDOC.ID = VENDAS.IDTipoDocumento "
                strSql &= "     LEFT JOIN tbSistemaTiposDocumento AS SISTIPOSDOC ON SISTIPOSDOC.ID = TIPOSDOC.IDSistemaTiposDocumento "
                strSql &= "     LEFT JOIN tbSistemaModulos AS SISMODULOS ON SISMODULOS.ID = SISTIPOSDOC.IDModulo "
                strSql &= "     LEFT JOIN tbServicos AS SERVICOS ON SERVICOS.IDDocumentoVenda = VENDAS.ID "
                strSql &= "     LEFT JOIN tbSistemaTiposServicos AS TIPOSERVICO ON TIPOSERVICO.ID = SERVICOS.IDTipoServico "
                strSql &= "     LEFT JOIN tbExames AS EXAMES ON  EXAMES.IDCliente = tbClientes.ID "
                strSql &= " WHERE RESPCONS.IDParametrizacaoConsentimentoPerguntas = " & templateEntity.IDParametrizacaoConsentimentosPerguntas
            Else
                strSql = " SELECT DISTINCT tbClientes.ID, tbClientes.Codigo, tbClientes.Nome, CLICONT.Telemovel "
                strSql &= " FROM tbClientes "
                strSql &= "     LEFT JOIN tbClientesContatos AS CLICONT ON CLICONT.IDCliente = tbClientes.ID AND CLICONT.Ordem = 1 "
                strSql &= "     LEFT JOIN tbDocumentosVendas AS VENDAS ON  VENDAS.IDEntidade = tbClientes.ID "
                strSql &= "     LEFT JOIN tbDocumentosVendasLinhas AS VENDASLINHAS ON VENDASLINHAS.IDDocumentoVenda = VENDAS.ID "
                strSql &= "     LEFT JOIN tbArtigos AS ART ON ART.ID = VENDASLINHAS.IDArtigo "
                strSql &= "     LEFT JOIN tbLentesOftalmicas AS LO ON LO.IDArtigo = ART.ID "
                strSql &= "     LEFT JOIN tbLentesContato AS LC ON LC.IDArtigo = ART.ID "
                strSql &= "     LEFT JOIN tbModelos AS MODELOS ON MODELOS.ID = LO.IDModelo "
                strSql &= "     LEFT JOIN tbModelos AS MODELOS_LC ON MODELOS.ID = LC.IDModelo "
                strSql &= "     LEFT JOIN tbEstados AS ESTADOS ON ESTADOS.ID = VENDAS.IDEstado "
                strSql &= "     LEFT JOIN tbSistemaTiposEstados AS SISTIPOSESTADOS ON SISTIPOSESTADOS.ID = ESTADOS.IDTipoEstado "
                strSql &= "     LEFT JOIN tbTiposDocumento AS TIPOSDOC ON TIPOSDOC.ID = VENDAS.IDTipoDocumento "
                strSql &= "     LEFT JOIN tbSistemaTiposDocumento AS SISTIPOSDOC ON SISTIPOSDOC.ID = TIPOSDOC.IDSistemaTiposDocumento "
                strSql &= "     LEFT JOIN tbSistemaModulos AS SISMODULOS ON SISMODULOS.ID = SISTIPOSDOC.IDModulo "
                strSql &= "     LEFT JOIN tbServicos AS SERVICOS ON SERVICOS.IDDocumentoVenda = VENDAS.ID "
                strSql &= "     LEFT JOIN tbSistemaTiposServicos AS TIPOSERVICO ON TIPOSERVICO.ID = SERVICOS.IDTipoServico "
                strSql &= "     LEFT JOIN tbExames AS EXAMES ON  EXAMES.IDCliente = tbClientes.ID "
                strSql &= " WHERE isnull(tbClientes.permitecomunicacoes,0)=1 "
            End If

            Dim whereFilters As String = ReturnSqlFromGrupo(mainGrupo, String.Empty)

            strSql += If(String.IsNullOrEmpty(whereFilters), String.Empty, " AND " & whereFilters)

            strSql = strSql.Replace("AND   AND", " AND ").Replace("AND   OR", "AND")

            strSql += " ORDER BY tbClientes.Nome "

            Return strSql
        End Function

        Private Function ReturnSqlFromGrupo(grupoEntity As tbComunicacaoSmsTemplatesGrupos, query As String) As String
            Dim maincondition As String = grupoEntity.MainCondition

            Dim lstRegras As New List(Of String)

            For Each regra In grupoEntity.tbComunicacaoSmsTemplatesRegras
                Dim lstValores As New List(Of String)

                If regra.tbComunicacaoSmsTemplatesValores.Count > 1 Then
                    Dim valorAux As New List(Of String)

                    If regra.tbComunicacaoSmsTemplatesValores.Any(Function(entity) entity.tbSistemaComunicacaoSmsTemplatesValores.UnionSqlQueryWhere) Then
                        Dim queryAux As String = regra.tbComunicacaoSmsTemplatesValores.FirstOrDefault.tbSistemaComunicacaoSmsTemplatesValores.SqlQueryWhere

                        Dim index As Integer = 0
                        For Each v In regra.tbComunicacaoSmsTemplatesValores

                            If Not String.IsNullOrEmpty(v.Valor) Then
                                queryAux = queryAux.Replace("{" & index & "}", v.Valor)

                            Else
                                queryAux = queryAux.Replace("{" & index & "}", v.tbSistemaComunicacaoSmsTemplatesValores.DefaultValue)
                            End If
                            index = index + 1
                        Next

                        lstValores.Add("(" & queryAux & ")")

                    Else
                        For Each v In regra.tbComunicacaoSmsTemplatesValores
                            If Not String.IsNullOrEmpty(v.Valor) Then
                                valorAux.Add(v.tbSistemaComunicacaoSmsTemplatesValores.SqlQueryWhere.Replace("{0}", v.Valor))
                            End If
                        Next

                        If valorAux.Any Then
                            lstValores.Add("(" & String.Join(" AND ", valorAux) & ")")
                        End If
                    End If

                Else
                    For Each v In regra.tbComunicacaoSmsTemplatesValores
                        If Not String.IsNullOrEmpty(v.Valor) Then
                            lstValores.Add(v.tbSistemaComunicacaoSmsTemplatesValores.SqlQueryWhere.Replace("{0}", v.Valor))
                        End If
                    Next
                End If

                If lstValores.Any Then lstRegras.AddRange(lstValores)
            Next

            If lstRegras.Any Then
                query = query & "("
                query = query & String.Join(" " & maincondition & " ", lstRegras)
            End If

            For Each grupo In grupoEntity.tbComunicacaoSmsTemplatesGrupos1
                query = query & "  " & maincondition
                Return ReturnSqlFromGrupo(grupo, query) & If(lstRegras.Any(), ")", String.Empty)
            Next

            query = query & If(lstRegras.Any(), ")", String.Empty)

            Return query
        End Function

        Public Function SendTemplateSms(model As SendTemplateSms) As Boolean
            Dim pbHub As New BarraProgresso

            Dim ComunicacaoText As ComunicacaoModels = (From tComun In BDContexto.tbComunicacao.AsNoTracking()
                                                        Join tSysComun In BDContexto.tbSistemaComunicacao.AsNoTracking() On tComun.IDSistemaComunicacao Equals tSysComun.ID
                                                        Join tComunApi In BDContexto.tbComunicacaoApis.AsNoTracking() On tComun.IDSistemaComunicacao Equals tComunApi.IDSistemaComunicacao
                                                        Where tComun.ID = model.IDSistemaEnvio AndAlso tComunApi.TipoApi = "SendSMS"
                                                        Select New ComunicacaoModels With {
                                                            .Descricao = tComun.Descricao,
                                                            .Remetente = tComun.Remetente,
                                                            .Utilizador = tComun.Utilizador,
                                                            .Chave = tComun.Chave,
                                                            .APIURL = tSysComun.APIURL + tComunApi.API
                                                            }).FirstOrDefault()


            Dim index As Short = 1

            For Each recipt As ReciptsGrid In model.Recipts
                pbHub.EnviaNotificacao(model.IDConnection, (index * 80) / model.Recipts.Count, "A enviar para " & recipt.Nome)

                Dim SmsReqText As String = _repositorioComunicacao.getSmsRequest(recipt.Telemovel, model.Message, ComunicacaoText)
                '
                Dim Responsejson = _repositorioComunicacao.CallAPI(SmsReqText)
                '
                Dim SmsResponse As ComunResponceModels = JsonConvert.DeserializeObject(Of ComunResponceModels)(Responsejson)

                Dim t As tbMensagemregistro = New tbMensagemregistro With {
                .IDComunicacao = model.IDSistemaEnvio,
                .Request = SmsReqText, .Response = Responsejson,
                .Status = If(SmsResponse.Result = "OK", 1, 0),
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome, .DataCriacao = DateTime.Now,
                .tbComunicacaoregistro = New List(Of tbComunicacaoregistro) From {New tbComunicacaoregistro With {
                .IDChamada = recipt.ID,
                .TextoMensagem = model.Message,
                .TipoChamada = "Clientes",
                .Telemovel = recipt.Telemovel,
                .Documento = Nothing, .DocumentID = 0,
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome, .DataCriacao = DateTime.Now,
                .IDComunicacaoSmsTemplates = model.IDTemplate}}}

                With BDContexto
                    .tbMensagemregistro.Add(t)
                    .Entry(t).State = EntityState.Added
                End With

                index = index + 1
            Next

            pbHub.EnviaNotificacao(model.IDConnection, 80, "A atualizar... ")

            BDContexto.SaveChanges()

            pbHub.EnviaNotificacao(model.IDConnection, 100, "A atualizar... ")

            pbHub.Fechar(model.IDConnection)

            Return True
        End Function
#End Region
    End Class
End Namespace