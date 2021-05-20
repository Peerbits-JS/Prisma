Imports System.IO
Imports System.Data.Entity
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao
Imports F3M.Repositorios.Sistema

Namespace Repositorio.Exames
    Public Class RepositorioExames
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbExames, Oticas.Exames)

        Private Structure TiposExame
            Const Consulta = "CONS"
            Const Diagnostico = "DIAG"
        End Structure

        Dim IDUtilizador As Long = ClsF3MSessao.RetornaUtilizadorID

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ''' <summary>
        ''' overrides que executa a funcao especifica lista  
        ''' </summary>
        ''' <param name="inQuery"></param>
        ''' <returns></returns>
        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbExames)) As IQueryable(Of Oticas.Exames)
            'set new filtro
            Dim Data As DateTime = inQuery.FirstOrDefault().DataExame
            Dim objfiltro As New ClsF3MFiltro
            With objfiltro
                .AddCampoFiltrar("Data", Data, "Data")
            End With

            'return lista
            Return Me.Lista(objfiltro)
        End Function

        ''' <summary>
        ''' Funcao overrides que executa a funcao especifica lista 
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        Public Overrides Function Lista(inObjFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Exames)
            Return Me.ListaDadosEsp(inObjFiltro).AsQueryable()
        End Function

        ''' <summary>
        ''' Funcao overrides que executa a funcao especifica lista 
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        Public Function ListaDadosImportacao(inObjFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Exames)
            Return Me.ListaDadosImp(inObjFiltro).AsQueryable()
        End Function

        Public Function ListaDadosIDDrillDown(inObjFiltro As ClsF3MFiltro) As List(Of Oticas.Exames)
            Dim query As IQueryable(Of tbExames) = tabela.AsNoTracking

            Dim lst As New List(Of Oticas.Exames)
            'filter from interface
            Dim data As Date = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Data", GetType(Date))
            Dim IDDrillDown As Long? = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDDrillDown", GetType(Long))

            With lst
                .AddRange(RetornaConsultasAvulsoIDDrillDown(data, IDDrillDown))
                .AddRange(RetornaMarcacoesComConsultaIDDrillDown(data, IDDrillDown))
            End With

            Return lst.OrderBy(Function(o) o.DataExame).ToList()
        End Function

        ''' <summary>
        ''' Funcao especifica lista 
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        Public Function ListaDadosEsp(inObjFiltro As ClsF3MFiltro) As List(Of Oticas.Exames)
            Dim query As IQueryable(Of tbExames) = tabela.AsNoTracking
            Dim lst As New List(Of Oticas.Exames)
            'filter from interface
            Dim data As Date = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Data", GetType(Date))

            With lst
                'map and add consultas avulso
                .AddRange(RetornaConsultasAvulso(data))
                'map and add marcacoes sem consulta
                .AddRange(RetornaMarcacoesSemConsulta(data))
                'map and add marcacoes com consulta
                .AddRange(RetornaMarcacoesComConsulta(data))
            End With

            Return lst.OrderBy(Function(o) o.DataExame).ToList()
        End Function

        ''' <summary>
        ''' Funcao que retorna consultas avulso (sem marcacao associada)
        ''' </summary>
        ''' <param name="inData"></param>
        ''' <returns></returns>
        Private Function RetornaConsultasAvulso(ByVal inData As Date) As List(Of Oticas.Exames)
            Return (From e In BDContexto.tbExames
                    Join x In BDContexto.tbMedicosTecnicos On e.IDMedicoTecnico Equals x.ID
                    Where
                       e.IDAgendamento Is Nothing AndAlso
                       e.DataExame.Day = inData.Day AndAlso
                       e.DataExame.Month = inData.Month AndAlso
                       e.DataExame.Year = inData.Year AndAlso
                       x.IDUtilizador = IDUtilizador
                    Select New Oticas.Exames With {
                        .Tipo = "Avulso", .DescricaoSplitterLadoDireito = "Consulta de " & e.tbClientes.Nome,
                       .ID = e.ID, .IDAgendamento = e.IDAgendamento,
                        .Numero = e.Numero, .DataExame = e.DataExame, .HoraExame = e.DataExame,
                       .IDTemplate = e.IDTemplate, .DescricaoTemplate = e.tbTemplates.Descricao,
                       .IDCliente = e.ID, .DescricaoCliente = e.tbClientes.Nome,
                       .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                       .IDEspecialidade = e.IDEspecialidade, .DescricaoEspecialidade = e.tbEspecialidades.Descricao,
                       .IDLoja = e.IDLoja, .DescricaoLoja = e.tbLojas.Descricao,
                       .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                       .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador}).ToList()
        End Function

        ''' <summary>
        ''' Funcao que retorna consultas avulso (sem marcacao associada)
        ''' </summary>
        ''' <param name="inData"></param>
        ''' <returns></returns>
        Private Function RetornaConsultasAvulsoIDDrillDown(ByVal inData As Date, ByVal id As Long) As List(Of Oticas.Exames)
            Return (From e In BDContexto.tbExames
                    Where
                       e.IDAgendamento Is Nothing AndAlso
                       e.DataExame.Day = inData.Day AndAlso
                       e.DataExame.Month = inData.Month AndAlso
                       e.DataExame.Year = inData.Year AndAlso
                        e.ID = id
                    Select New Oticas.Exames With {
                        .Tipo = "Avulso", .DescricaoSplitterLadoDireito = "Consulta de " & e.tbClientes.Nome,
                       .ID = e.ID, .IDAgendamento = e.IDAgendamento,
                        .Numero = e.Numero, .DataExame = e.DataExame, .HoraExame = e.DataExame,
                       .IDTemplate = e.IDTemplate, .DescricaoTemplate = e.tbTemplates.Descricao,
                       .IDCliente = e.ID, .DescricaoCliente = e.tbClientes.Nome,
                       .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                       .IDEspecialidade = e.IDEspecialidade, .DescricaoEspecialidade = e.tbEspecialidades.Descricao,
                       .IDLoja = e.IDLoja, .DescricaoLoja = e.tbLojas.Descricao,
                       .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                       .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador}).ToList()
        End Function

        ''' <summary>
        ''' Funcao que retorna as marcacoes que ainda nao tem consulta
        ''' </summary>
        ''' <param name="inData"></param>
        ''' <returns></returns>
        Private Function RetornaMarcacoesSemConsulta(ByVal inData As Date) As List(Of Oticas.Exames)
            Dim getIDS As Long?() = (From e In BDContexto.tbExames
                                     Join x In BDContexto.tbMedicosTecnicos On e.IDMedicoTecnico Equals x.ID
                                     Where
                                       e.IDAgendamento IsNot Nothing AndAlso
                                       e.DataExame.Day = inData.Day AndAlso
                                       e.DataExame.Month = inData.Month AndAlso
                                       e.DataExame.Year = inData.Year AndAlso
                                       x.IDUtilizador = IDUtilizador
                                     Select e.IDAgendamento).ToArray()


            Return (From e In BDContexto.tbAgendamento
                    Join y In BDContexto.tbMedicosTecnicos On y.ID Equals e.IDMedicoTecnico
                    Where
                        e.Start.Day = inData.Day AndAlso
                        e.Start.Month = inData.Month AndAlso
                        e.Start.Year = inData.Year AndAlso
                        y.IDUtilizador = IDUtilizador AndAlso
                        Not getIDS.Contains(e.ID)
                    Select New Oticas.Exames With {
                        .Tipo = "Marcacao sem consulta", .DescricaoSplitterLadoDireito = "Iniciar consulta de " & e.Nome,
                       .ID = 0, .IDAgendamento = e.ID,
                        .DataExame = e.Start, .HoraExame = e.Start,
                       .IDTemplate = 1, .DescricaoTemplate = "Consulta",
                       .IDCliente = e.ID, .DescricaoCliente = e.Nome,
                       .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                       .IDEspecialidade = e.IDEspecialidade, .DescricaoEspecialidade = e.tbEspecialidades.Descricao,
                       .IDLoja = e.IDLoja, .DescricaoLoja = e.tbLojas.Descricao,
                       .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                       .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador}).ToList()
        End Function

        ''' <summary>
        ''' Funcao que retorna as marcacoes que ja tem consulta associada
        ''' </summary>
        ''' <param name="inData"></param>
        ''' <returns></returns>
        Private Function RetornaMarcacoesComConsulta(ByVal inData As Date) As List(Of Oticas.Exames)
            Return (From e In BDContexto.tbExames
                    Join x In BDContexto.tbMedicosTecnicos On e.IDMedicoTecnico Equals x.ID
                    Join y In BDContexto.tbAgendamento On y.ID Equals e.IDAgendamento
                    Where
                       e.DataExame.Day = inData.Day AndAlso
                       e.DataExame.Month = inData.Month AndAlso
                       e.DataExame.Year = inData.Year AndAlso
                       x.IDUtilizador = IDUtilizador
                    Select New Oticas.Exames With {
                        .Tipo = "Marcacao com consulta", .DescricaoSplitterLadoDireito = "Consulta de " & e.tbClientes.Nome,
                        .ID = e.ID, .IDAgendamento = e.IDAgendamento,
                        .Numero = e.Numero, .DataExame = e.DataExame, .HoraExame = e.DataExame,
                       .IDTemplate = e.IDTemplate, .DescricaoTemplate = e.tbTemplates.Descricao,
                       .IDCliente = e.ID, .DescricaoCliente = e.tbClientes.Nome,
                       .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                       .IDEspecialidade = e.IDEspecialidade, .DescricaoEspecialidade = e.tbEspecialidades.Descricao,
                       .IDLoja = e.IDLoja, .DescricaoLoja = e.tbLojas.Descricao,
                       .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                       .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador}).ToList()
        End Function

        ''' <summary>
        ''' Funcao que retorna as marcacoes que ja tem consulta associada
        ''' </summary>
        ''' <param name="inData"></param>
        ''' <returns></returns>
        Private Function RetornaMarcacoesComConsultaIDDrillDown(ByVal inData As Date, ByVal id As Long) As List(Of Oticas.Exames)
            Return (From e In BDContexto.tbExames
                    Join y In BDContexto.tbAgendamento On y.ID Equals e.IDAgendamento
                    Where
                       e.DataExame.Day = inData.Day AndAlso
                       e.DataExame.Month = inData.Month AndAlso
                       e.DataExame.Year = inData.Year AndAlso
                        e.ID = id
                    Select New Oticas.Exames With {
                        .Tipo = "Marcacao com consulta", .DescricaoSplitterLadoDireito = "Consulta de " & e.tbClientes.Nome,
                        .ID = e.ID, .IDAgendamento = e.IDAgendamento,
                        .Numero = e.Numero, .DataExame = e.DataExame, .HoraExame = e.DataExame,
                       .IDTemplate = e.IDTemplate, .DescricaoTemplate = e.tbTemplates.Descricao,
                       .IDCliente = e.ID, .DescricaoCliente = e.tbClientes.Nome,
                       .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                       .IDEspecialidade = e.IDEspecialidade, .DescricaoEspecialidade = e.tbEspecialidades.Descricao,
                       .IDLoja = e.IDLoja, .DescricaoLoja = e.tbLojas.Descricao,
                       .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                       .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador}).ToList()
        End Function

        ''' <summary>
        ''' Funcao especifica lista serviços
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        Public Function ListaDadosImp(inObjFiltro As ClsF3MFiltro) As List(Of Oticas.Exames)
            Dim IDCliente As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDCliente", GetType(Long))

            Dim res As List(Of Oticas.Exames) = (From e In BDContexto.tbExames
                                                 Where e.IDCliente = IDCliente
                                                 Select New Oticas.Exames With {
                                                     .ID = e.ID,
                                                     .Tipo = e.tbTemplates.tbTiposConsultas.FirstOrDefault.Descricao,
                                                     .DataExame = e.DataExame, .HoraExame = e.DataExame,
                                                     .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                                                     .IDEspecialidade = e.IDEspecialidade, .DescricaoEspecialidade = e.tbEspecialidades.Descricao,
                                                     .LOD_OBS = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("AO_OBS")).FirstOrDefault.ValorID,
                                                     .LOD_ADD = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOD_ADD")).FirstOrDefault.ValorID,
                                                     .LOD_AX = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOD_AX")).FirstOrDefault.ValorID,
                                                     .LOD_CIL = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOD_CIL")).FirstOrDefault.ValorID,
                                                     .LOD_DIAM = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOD_DIAM")).FirstOrDefault.ValorID,
                                                     .LOD_ESF = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOD_ESF")).FirstOrDefault.ValorID,
                                                     .LOD_PRISM = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOD_PRISM")).FirstOrDefault.ValorID,
                                                     .LOD_RAIO = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOD_RAIO")).FirstOrDefault.ValorID,
                                                     .LOE_ADD = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOE_ADD")).FirstOrDefault.ValorID,
                                                     .LOE_AX = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOE_AX")).FirstOrDefault.ValorID,
                                                     .LOE_CIL = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOE_CIL")).FirstOrDefault.ValorID,
                                                     .LOE_DIAM = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOE_DIAM")).FirstOrDefault.ValorID,
                                                     .LOE_ESF = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOE_ESF")).FirstOrDefault.ValorID,
                                                     .LOE_PRISM = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOE_PRISM")).FirstOrDefault.ValorID,
                                                     .LOE_RAIO = e.tbExamesProps.Where(Function(w) w.ComponentTag.Equals("LOE_RAIO")).FirstOrDefault.ValorID}).OrderBy(Function(o) o.DataExame).ToList()

            'MAF - se puser em cima o ToShortTimeString e o Date da erro
            For Each lin As Oticas.Exames In res
                With lin
                    .Hora = .DataExame.ToShortTimeString() : .DataExame = .DataExame.Date
                End With
            Next

            Return res
        End Function

#End Region

#Region "ADICIONAR"
        ''' <summary>
        ''' Funcao adiciona o registo
        ''' </summary>
        ''' <param name="inModelo"></param>
        Public Function AdicionaEsp(inModelo As ExamesCustomModel) As Oticas.Exames
            'instance new exame
            Dim newExame As New tbExames

            'set props
            With newExame
                'set main props in tbExames ()
                .IDLoja = CLng(ClsF3MSessao.RetornaLojaID)
                .Numero = RetornaProximoNumero() : .DataExame = inModelo.ExamesModel.Where(Function(w) w.Key = "DataExame").Select(Function(s) s.Value).FirstOrDefault()
                .IDCliente = inModelo.ExamesModel.Where(Function(w) w.Key = "IDCliente").Select(Function(s) s.Value).FirstOrDefault()
                .IDMedicoTecnico = inModelo.ExamesModel.Where(Function(w) w.Key = "IDMedicoTecnico").Select(Function(s) s.Value).FirstOrDefault()
                .IDEspecialidade = inModelo.ExamesModel.Where(Function(w) w.Key = "IDEspecialidade").Select(Function(s) s.Value).FirstOrDefault()
                .IDTemplate = inModelo.ExamesModel.Where(Function(w) w.Key = "IDTemplate").Select(Function(s) s.Value).FirstOrDefault()
                'from agendamento
                Dim IDAgendamentoAux As String = inModelo.ExamesModel.Where(Function(w) w.Key = "IDAgendamento").Select(Function(s) s.Value).FirstOrDefault()
                If Not String.IsNullOrEmpty(IDAgendamentoAux) AndAlso IDAgendamentoAux <> 0 Then
                    .IDAgendamento = CLng(IDAgendamentoAux)
                End If
                'If .IDAgendamento = 0 Then .IDAgendamento = Nothing
                .Sistema = False
                .Ativo = True 'inModelo.Where(Function(w) w.Key = "Ativo").Select(Function(s) s.Value).FirstOrDefault()
                'f3m props
                .DataCriacao = DateAndTime.Now() : .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                .Sistema = False
                'instance new props
                .tbExamesProps = New List(Of tbExamesProps)
            End With

            'get template from db
            Dim template As List(Of tbExamesTemplate) = BDContexto.tbExamesTemplate.ToList.Where(Function(w) w.IDTemplate = newExame.IDTemplate).ToList()

            'if template exists
            If Not template Is Nothing AndAlso template.Count Then
                For Each item As tbExamesTemplate In template.Where(Function(w) w.IDPai Is Nothing)
                    'instance new exame props
                    Dim pai As New tbExamesProps
                    'map it
                    Mapear(item, pai)
                    'map parent's sons
                    MapeiaFilhosAdicionar(pai, item, template, inModelo.ExamesModel)
                    'add parent to new model
                    newExame.tbExamesProps.Add(pai)
                Next
            End If

            'GRAVA FOTOS
            GravaFotos(inModelo, newExame)

            'save all on db
            With BDContexto
                .tbExames.Add(newExame)
                .Entry(newExame).State = Entity.EntityState.Added
                .SaveChanges()
            End With


            'set model to return
            Dim newModel As New Oticas.Exames
            With newModel
                .ID = newExame.ID
            End With

            'return this new model only with id
            Return newModel
        End Function

        ''' <summary>
        ''' Funcao que mapeia os filhos ao adicionar
        ''' </summary>
        ''' <param name="inPai"></param>
        ''' <param name="inItem"></param>
        ''' <param name="inTemplate"></param>
        ''' <param name="inModelo"></param>
        Private Sub MapeiaFilhosAdicionar(ByRef inPai As tbExamesProps, ByRef inItem As tbExamesTemplate, ByRef inTemplate As List(Of tbExamesTemplate), inModelo As Dictionary(Of String, String))
            'ger parent id
            Dim idPai As Long = inItem.ID
            'get parent's sons list
            Dim lst As List(Of tbExamesTemplate) = inTemplate.Where(Function(w) w.IDPai IsNot Nothing AndAlso w.IDPai = idPai).ToList()

            For Each filho As tbExamesTemplate In lst

                'instance new props
                Dim exameProps As New tbExamesProps
                'map item to new props
                Mapear(filho, exameProps)
                'if is component and has value save
                If Not String.IsNullOrEmpty(exameProps.ModelPropertyName) Then
                    'get value from model
                    Dim valorAux As String = inModelo.Where(Function(w) w.Key = exameProps.ModelPropertyName).Select(Function(s) s.Value).FirstOrDefault()
                    exameProps.ValorID = valorAux

                    If Not String.IsNullOrEmpty(exameProps.ValorID) AndAlso
                        (exameProps.TipoComponente = "F3MLookup" OrElse exameProps.TipoComponente = "F3MDropDownList") Then

                        'get field to show on lookup or ddl
                        Dim campoDesc As String = CamposGenericos.Descricao
                        If Not String.IsNullOrEmpty(exameProps.CampoTexto) Then campoDesc = exameProps.CampoTexto

                        'get value to show on lookup or ddl
                        Dim strSql As String = "SELECT " & campoDesc & " FROM " & exameProps.TabelaBD & " WHERE ID = " & exameProps.ValorID
                        'set value to show on lookup or ddl
                        exameProps.ValorDescricao = BDContexto.Database.SqlQuery(Of String)(strSql).DefaultIfEmpty(String.Empty).FirstOrDefault
                    End If
                End If

                'set valor id to label
                Dim lstLabels As New List(Of String) From {"Label_OD", "Label_OE", "Label_DIA", "Label_RC", "Label_ESF", "Label_CIL", "Label_AX", "Label_ADD", "Label_PRISM"}
                If lstLabels.Contains(exameProps.ComponentTag) Then
                    exameProps.ValorID = exameProps.Label
                End If

                'set to parent
                inPai.tbExamesProps1.Add(exameProps)
                'map sons
                MapeiaFilhosAdicionar(exameProps, filho, inTemplate, inModelo)
            Next
        End Sub
#End Region

#Region "EDITAR"
        ''' <summary>
        ''' Função que retorna o modelo para o template dos exames
        ''' </summary>
        ''' <returns></returns>
        Public Function RetornaModelEditar(inIDExame As Long) As Oticas.Exames
            'instance new model with main props
            Dim ModelTemplate As Oticas.Exames = (From x In BDContexto.tbExames
                                                  Where x.ID = inIDExame
                                                  Select New Oticas.Exames With {
                                                      .ID = x.ID,
                                                      .Numero = x.Numero, .DataExame = x.DataExame,
                                                      .IDCliente = x.IDCliente, .DescricaoCliente = x.tbClientes.Nome,
                                                      .IDTemplate = x.IDTemplate, .DescricaoTemplate = x.tbTemplates.Descricao,
                                                      .IDMedicoTecnico = x.IDMedicoTecnico, .DescricaoMedicoTecnico = x.tbMedicosTecnicos.Nome,
                                                      .IDEspecialidade = x.IDEspecialidade, .DescricaoEspecialidade = x.tbEspecialidades.Descricao,
                                                      .Ativo = x.Ativo}).FirstOrDefault()

            'carrega os pais "principais"
            ModelTemplate.ExamesCustomizacaoComponents = (From s In BDContexto.tbExamesProps
                                                          Where s.IDExame = inIDExame AndAlso s.IDPai Is Nothing AndAlso s.Ativo
                                                          Order By s.StartRow, s.StartCol, s.Ordem
                                                          Select New Components With {
                                                              .ID = s.ID, .F3MBDID = s.ID, .IDPai = s.IDPai,
                                                              .Ordem = s.Ordem,
                                                              .TipoComponente = s.TipoComponente,
                                                              .Label = s.Label,
                                                              .ViewClassesCSS = s.ViewClassesCSS, .DesenhaBotaoLimpar = s.DesenhaBotaoLimpar,
                                                              .FuncaoJSOnClick = s.FuncaoJSOnClick, .IDElemento = s.IDElemento,
                                                              .ECabecalho = s.ECabecalho,
                                                              .StartRow = s.StartRow, .EndRow = s.EndRow, .StartCol = s.StartCol, .EndCol = s.EndCol}).OrderBy(Function(o) o.Ordem).ToList()

            'retorna os filhos
            For Each component As Components In ModelTemplate.ExamesCustomizacaoComponents
                RetornaFilhosEditar(component, inIDExame)
            Next


            With ModelTemplate
                .HistoricoExames = RetornaHistoricoExamesByIDCliente(.IDCliente)
                'AQUI MAPEIA AS FOTOS
                .ExamesFotos = (From x In BDContexto.tbExamesPropsFotos
                                Where x.IDExame = inIDExame
                                Select New FotosGrid With {.ID = x.ID, .AcaoFormulario = 1,
                                    .Foto = x.Foto, .FotoCaminho = x.FotoCaminho, .FotoCaminhoCompleto = x.FotoCaminho & x.Foto,
                                    .FotoAnterior = x.Foto, .FotoCaminhoAnterior = x.FotoCaminho, .FotoCaminhoAnteriorCompleto = x.FotoCaminho & x.Foto}).ToList()
            End With

            'return model
            Return ModelTemplate
        End Function

        ''' <summary>
        ''' Função recursiva que retorna os filhos
        ''' </summary>
        ''' <param name="inComponent"></param>
        Private Sub RetornaFilhosEditar(ByRef inComponent As Components, ByVal inIDExame As Long)
            Dim IDPai As Long = inComponent.ID

            Dim ListOfComponentesFilhos As List(Of Components) = (From s In BDContexto.tbExamesProps
                                                                  Where s.IDExame = inIDExame AndAlso s.IDPai = IDPai AndAlso s.Ativo
                                                                  Order By s.StartRow, s.StartCol, s.Ordem
                                                                  Select New Components With {
                                                                      .ID = s.ID, .F3MBDID = s.ID, .IDPai = s.IDPai,
                                                                      .AcaoFormulario = AcoesFormulario.Alterar,
                                                                      .Ordem = s.Ordem,
                                                                      .TipoComponente = s.TipoComponente,
                                                                      .Label = s.Label,
                                                                      .IDElemento = s.IDElemento,
                                                                      .StartRow = s.StartRow, .EndRow = s.EndRow, .StartCol = s.StartCol, .EndCol = s.EndCol,
                                                                      .ModelPropertyName = s.ModelPropertyName, .ModelPropertyType = s.ModelPropertyType,
                                                                      .EObrigatorio = s.EObrigatorio, .EEditavel = If(s.EEditavelEdicao Is Nothing, True, s.EEditavelEdicao), .EEditavelEdicao = s.EEditavelEdicao,
                                                                      .ValorPorDefeito = s.ValorPorDefeito, .NumCasasDecimais = s.NumCasasDecimais,
                                                                      .AtributosHtml = s.AtributosHtml, .ViewClassesCSS = s.ViewClassesCSS,
                                                                      .Controlador = s.Controlador, .ControladorAcaoExtra = s.ControladorAcaoExtra, .CampoTexto = s.CampoTexto,
                                                                      .ValorID = s.ValorID, .ValorDescricao = s.ValorDescricao,
                                                                      .ECabecalho = s.ECabecalho,
                                                                      .FuncaoJSChange = s.FuncaoJSChange, .FuncaoJSEnviaParametros = s.FuncaoJSEnviaParametros, .FuncaoJSOnClick = s.FuncaoJSOnClick, .DesenhaBotaoLimpar = s.DesenhaBotaoLimpar,
                                                                      .Steps = s.Steps, .ValorMaximo = s.ValorMaximo, .ValorMinimo = s.ValorMinimo}).OrderBy(Function(o) o.Ordem).ToList()

            inComponent.ListOfComponentesFilhos = ListOfComponentesFilhos

            For Each filho As Components In inComponent.ListOfComponentesFilhos
                RetornaFilhosEditar(filho, inIDExame)
            Next
        End Sub

        ''' <summary>
        ''' Funcao edita o registo
        ''' </summary>
        ''' <param name="inModelo"></param>
        ''' <returns></returns>
        Public Function EditaEsp(inModelo As ExamesCustomModel) As Oticas.Exames
            'get exame id
            Dim IDExame As Long = inModelo.ExamesModel.Where(Function(w) w.Key = "ID").Select(Function(s) s.Value).FirstOrDefault()
            'get exame db set
            Dim exame As tbExames = BDContexto.tbExames.Where(Function(w) w.ID = IDExame).FirstOrDefault()
            'set new props
            With exame
                .DataExame = inModelo.ExamesModel.Where(Function(w) w.Key = "DataExame").Select(Function(s) s.Value).FirstOrDefault()
                '.IDCliente = inModelo.Where(Function(w) w.Key = "IDCliente").Select(Function(s) s.Value).FirstOrDefault()
                .IDMedicoTecnico = inModelo.ExamesModel.Where(Function(w) w.Key = "IDMedicoTecnico").Select(Function(s) s.Value).FirstOrDefault()
                .IDEspecialidade = inModelo.ExamesModel.Where(Function(w) w.Key = "IDEspecialidade").Select(Function(s) s.Value).FirstOrDefault()
                '.Ativo = inModelo.Where(Function(w) w.Key = "Ativo").Select(Function(s) s.Value).FirstOrDefault()
                'f3m props
                .DataAlteracao = DateAndTime.Now() : .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome
            End With

            'get all props
            Dim lst As List(Of tbExamesProps) = exame.tbExamesProps.ToList()

            If Not lst Is Nothing AndAlso lst.Count Then
                For Each lin As tbExamesProps In lst
                    If Not String.IsNullOrEmpty(lin.ModelPropertyName) Then
                        'get value from model
                        Dim valorAux As String = inModelo.ExamesModel.Where(Function(w) w.Key = lin.ModelPropertyName).Select(Function(s) s.Value).FirstOrDefault()
                        lin.ValorID = valorAux

                        If Not String.IsNullOrEmpty(lin.ValorID) AndAlso
                            (lin.TipoComponente = "F3MLookup" OrElse lin.TipoComponente = "F3MDropDownList") Then

                            'get field to show on lookup or ddl
                            Dim campoDesc As String = "Descricao"
                            If Not String.IsNullOrEmpty(lin.CampoTexto) Then campoDesc = lin.CampoTexto

                            'get value to show on lookup or ddl
                            Dim strSql As String = "SELECT " & campoDesc & " FROM " & lin.TabelaBD & " WHERE ID = " & lin.ValorID
                            'set value to show on lookup or ddl
                            lin.ValorDescricao = BDContexto.Database.SqlQuery(Of String)(strSql).DefaultIfEmpty(String.Empty).FirstOrDefault
                        End If
                    End If

                    'set comum props
                    With lin
                        'f3m props
                        .DataAlteracao = DateAndTime.Now() : .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome
                    End With
                Next
            End If

            'save pics 
            GravaFotos(inModelo, exame)

            'save all on db
            With BDContexto
                .tbExames.Add(exame)
                .Entry(exame).State = Entity.EntityState.Modified
                .SaveChanges()
            End With

            'set model to return
            Dim newModel As New Oticas.Exames
            With newModel
                .ID = IDExame
            End With

            'return this new model only with id
            Return newModel
        End Function
#End Region

#Region "REMOVER"
        ''' <summary>
        ''' Funcao que remove a consulta
        ''' </summary>
        ''' <param name="inModelo"></param>
        ''' <param name="inObjFiltro"></param>
        Public Overrides Sub RemoveObj(ByRef inModelo As Oticas.Exames, inObjFiltro As ClsF3MFiltro)
            Try
                'get context
                Using ctx As New BD.Dinamica.Aplicacao
                    'start transaction
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                        Try
                            'get exame id
                            Dim IDExame As Long = inModelo.ID
                            'remove exame props
                            Dim lst As List(Of tbExamesProps) = ctx.tbExamesProps.Where(Function(w) w.IDExame = IDExame).ToList()
                            With ctx
                                'remove all lines
                                .tbExamesProps.RemoveRange(lst)
                                'set state of all lines to deleted
                                lst.ForEach(Sub(f)
                                                .Entry(f).State = Entity.EntityState.Deleted
                                            End Sub)
                                'save it
                                .SaveChanges()
                            End With

                            'remove fotos
                            Dim lstFotos As List(Of tbExamesPropsFotos) = ctx.tbExamesPropsFotos.Where(Function(w) w.IDExame = IDExame).ToList()
                            Dim lstFotosNome As String() = lstFotos.Select(Function(s) s.FotoCaminho & s.Foto).ToArray()


                            With ctx
                                'remove all lines
                                .tbExamesPropsFotos.RemoveRange(lstFotos)
                                'set state of all lines to deleted
                                lstFotos.ForEach(Sub(f)
                                                     .Entry(f).State = EntityState.Deleted
                                                 End Sub)
                                'save it
                                .SaveChanges()
                            End With

                            'remove exame
                            Dim exame As tbExames = ctx.tbExames.Where(Function(w) w.ID = IDExame).FirstOrDefault()
                            With ctx
                                'remove all lines
                                .tbExames.Remove(exame)
                                'set state of all lines to deleted
                                .Entry(exame).State = Entity.EntityState.Deleted
                                'save it
                                .SaveChanges()
                            End With

                            'lets commit it!
                            trans.Commit()

                            'delete fotos from folder
                            For Each foto In lstFotosNome
                                ClsUploadFicheiros.ApagaFicheiro(Hosting.HostingEnvironment.MapPath(foto))
                            Next

                        Catch
                            'rollback it!
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub
#End Region

#Region "TEMPLATE"
        ''' <summary>
        ''' 
        ''' </summary>
        ''' <returns></returns>
        Public Function RetornaModelAdicionar() As Oticas.Exames
            'get current med tec
            Dim MedTec As MedicosTecnicos = RetornaMedicoTecnicoUtilizadorSessao()

            'get default template
            Dim TemplateDefault As TiposConsultas = (From x In BDContexto.tbTiposConsultas
                                                     Where x.ID = MedTec.IDTipoConsulta
                                                     Select New TiposConsultas With {.ID = x.ID, .Descricao = x.Descricao, .IDTemplate = x.IDTemplate}).FirstOrDefault()


            If TemplateDefault Is Nothing Then
                TemplateDefault = (From x In BDContexto.tbTiposConsultas
                                   Where x.tbTemplates.Codigo = TiposExame.Consulta
                                   Select New TiposConsultas With {.ID = x.ID, .Descricao = x.Descricao, .IDTemplate = x.IDTemplate}).FirstOrDefault()
            End If

            'get model
            Dim ModelTemplate As Oticas.Exames = RetornaModelTemplateByIDTemplate(False, TemplateDefault.IDTemplate)

            'set default template
            With ModelTemplate
                .IDTemplate = TemplateDefault.IDTemplate
                .IDTipoConsulta = TemplateDefault.ID : .DescricaoTipoConsulta = TemplateDefault.Descricao
            End With

            'return model
            Return ModelTemplate
        End Function

        ''' <summary>
        ''' Função que retorna o modelo para o template dos exames
        ''' </summary>
        ''' <returns></returns>
        Public Function RetornaModelTemplateByIDTemplate(inECustomizacao As Boolean, inIDTemplate As Long) As Oticas.Exames
            'instance new model
            Dim ModelTemplate As New Oticas.Exames

            'carrega os pais "principais"
            ModelTemplate.ExamesCustomizacaoComponents = (From s In BDContexto.tbExamesTemplate
                                                          Where s.IDPai Is Nothing AndAlso s.Ativo AndAlso s.IDTemplate = inIDTemplate
                                                          Order By s.StartRow, s.StartCol, s.Ordem
                                                          Select New Components With {
                                                              .F3MBDID = s.ID,
                                                             .ID = s.ID, .IDPai = s.IDPai, .IDTemplate = s.IDTemplate,
                                                             .Ordem = s.Ordem,
                                                             .TipoComponente = s.TipoComponente,
                                                             .Label = s.Label,
                                                              .IDElemento = s.IDElemento,
                                                              .ViewClassesCSS = s.ViewClassesCSS,
                                                              .FuncaoJSOnClick = s.FuncaoJSOnClick,
                                                              .ECabecalho = s.ECabecalho,
                                                             .StartRow = s.StartRow, .EndRow = s.EndRow, .StartCol = s.StartCol, .EndCol = s.EndCol}).OrderBy(Function(o) o.Ordem).ToList()

            'retorna os filhos
            For Each component As Components In ModelTemplate.ExamesCustomizacaoComponents
                RetornaFilhos(component, inECustomizacao, component.IDTemplate)
            Next

            'return model
            Return ModelTemplate
        End Function

        ''' <summary>
        ''' Função recursiva que retorna os filhos
        ''' </summary>
        ''' <param name="inComponent"></param>
        Private Sub RetornaFilhos(ByRef inComponent As Components, ByVal inECustomizacao As Boolean, ByVal inIDTemplate As Long)
            Dim IDPai As Long = inComponent.ID

            Dim ListOfComponentesFilhos As List(Of Components) = (From s In BDContexto.tbExamesTemplate
                                                                  Where s.IDPai = IDPai AndAlso s.Ativo AndAlso s.IDTemplate = inIDTemplate
                                                                  Order By s.StartRow, s.StartCol, s.Ordem
                                                                  Select New Components With {
                                                                      .F3MBDID = s.ID,
                                                                      .ECustomizacao = inECustomizacao,
                                                                      .ID = s.ID, .IDPai = s.IDPai, .IDTemplate = s.IDTemplate, .AcaoFormulario = AcoesFormulario.Adicionar,
                                                                      .Ordem = s.Ordem,
                                                                      .TipoComponente = s.TipoComponente,
                                                                      .Label = s.Label,
                                                                      .IDElemento = s.IDElemento,
                                                                      .StartRow = s.StartRow, .EndRow = s.EndRow, .StartCol = s.StartCol, .EndCol = s.EndCol,
                                                                      .ModelPropertyName = s.ModelPropertyName, .ModelPropertyType = s.ModelPropertyType,
                                                                      .EObrigatorio = s.EObrigatorio, .EEditavel = s.EEditavel,
                                                                      .ValorPorDefeito = s.ValorPorDefeito, .NumCasasDecimais = s.NumCasasDecimais,
                                                                      .AtributosHtml = s.AtributosHtml, .ViewClassesCSS = s.ViewClassesCSS,
                                                                      .DesenhaBotaoLimpar = s.DesenhaBotaoLimpar,
                                                                      .Controlador = s.Controlador, .ControladorAcaoExtra = s.ControladorAcaoExtra, .CampoTexto = s.CampoTexto,
                                                                      .ValorMinimo = s.ValorMinimo, .ValorMaximo = s.ValorMaximo, .Steps = s.Steps,
                                                                      .FuncaoJSChange = s.FuncaoJSChange, .FuncaoJSEnviaParametros = s.FuncaoJSEnviaParametros, .FuncaoJSOnClick = s.FuncaoJSOnClick,
                                                                      .ECabecalho = s.ECabecalho}).OrderBy(Function(o) o.Ordem).ToList()

            inComponent.ListOfComponentesFilhos = ListOfComponentesFilhos

            For Each filho As Components In inComponent.ListOfComponentesFilhos
                RetornaFilhos(filho, inECustomizacao, filho.IDTemplate)
            Next
        End Sub
#End Region

#Region "FUNCOES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna o proximo numero do exame (max + 1)
        ''' </summary>
        ''' <returns></returns>
        Public Function RetornaProximoNumero() As Long
            Return BDContexto.tbExames.Select(Function(s) s.Numero).DefaultIfEmpty(0).Max() + 1
        End Function

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="inModelo"></param>
        ''' <param name="inIDCliente"></param>
        ''' <param name="inIDMedicoTecnico"></param>
        ''' <param name="inIDEspecialidade"></param>
        ''' <param name="inIDAgendamento"></param>
        ''' <returns></returns>
        Public Function PreencheModelFromAgendamento(inModelo As Oticas.Exames,
                                                     inIDCliente As Nullable(Of Long), inIDMedicoTecnico As Long, inIDEspecialidade As Long, inIDAgendamento As Long, inData As DateTime) As Oticas.Exames

            'set date to now if not from marcacao
            If inIDAgendamento = 0 Then inData = DateAndTime.Now()


            'get and set cliente
            If Not inIDCliente Is Nothing AndAlso inIDCliente <> 0 Then
                'get cliente
                Dim Cliente As Clientes = (From x In BDContexto.tbClientes
                                           Where x.ID = inIDCliente
                                           Select New Clientes With {.ID = x.ID, .Nome = x.Nome, .DataNascimento = x.DataNascimento}).FirstOrDefault()

                If Not Cliente Is Nothing Then
                    'set age prop
                    Cliente.Idade = ClsUtilitarios.CalculaIdade(Cliente.DataNascimento)

                    'set cliente
                    With inModelo
                        .IDCliente = Cliente.ID : .DescricaoCliente = Cliente.Nome

                        Dim compIDCliente As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "ModelPropertyName", "IDCliente")
                        If Not compIDCliente Is Nothing Then
                            With compIDCliente
                                .ValorID = Cliente.ID : .ValorDescricao = Cliente.Nome
                            End With
                        End If

                        Dim compIdade As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABIdade")
                        If Not compIdade Is Nothing Then
                            With compIdade
                                .ValorID = If(Cliente.Idade <> 0, Cliente.Idade, "---")
                            End With
                        End If
                    End With
                End If

            Else
                Dim compIdade As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABIdade")
                If Not compIdade Is Nothing Then
                    With compIdade
                        .ValorID = "---"
                    End With
                End If
            End If

            'set data exame
            With inModelo
                .DataExame = inData
            End With

            Dim compCabDataExame As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABDataExame")
            If Not compCabDataExame Is Nothing Then
                With compCabDataExame
                    .ValorID = inData.ToString("dd/MM/yyyy HH:mm")
                End With
            End If

            Dim compDataExame As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "ModelPropertyName", "DataExame")
            If Not compDataExame Is Nothing Then
                With compDataExame
                    .ValorID = inData.ToString("dd/MM/yyyy HH:mm")
                End With
            End If

            'set tipo de exame
            Dim compTemplate As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "ModelPropertyName", "IDTipoConsulta")
            If Not compTemplate Is Nothing Then
                With compTemplate
                    .ValorID = inModelo.IDTipoConsulta : .ValorDescricao = inModelo.DescricaoTipoConsulta
                End With
            End If

            Dim compCabTemplate As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABTipoConsulta")
            If Not compCabTemplate Is Nothing Then
                With compCabTemplate
                    .ValorID = inModelo.DescricaoTipoConsulta
                End With
            End If

            'get and set especialidade
            If inIDEspecialidade <> 0 Then
                'get medico tecnico
                Dim Especialidade As Especialidades = (From x In BDContexto.tbEspecialidades
                                                       Where x.ID = inIDEspecialidade
                                                       Select New Especialidades With {.ID = x.ID, .Descricao = x.Descricao}).FirstOrDefault()

                If Not Especialidade Is Nothing Then
                    'set especialidade
                    With inModelo
                        .IDEspecialidade = Especialidade.ID : .DescricaoEspecialidade = Especialidade.Descricao

                        Dim campoIDEspecialidade As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "ModelPropertyName", "IDEspecialidade")
                        If Not campoIDEspecialidade Is Nothing Then
                            With campoIDEspecialidade
                                .ValorID = Especialidade.ID : .ValorDescricao = Especialidade.Descricao
                            End With
                        End If

                        Dim compCabEspecialidade As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABEspecialidade")
                        If Not compCabEspecialidade Is Nothing Then
                            With compCabEspecialidade
                                .ValorID = Especialidade.Descricao
                            End With
                        End If

                    End With
                End If

            Else
                Dim compIDMedico As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABEspecialidade")
                If Not compIDMedico Is Nothing Then
                    With compIDMedico
                        .ValorID = "---"
                    End With
                End If
            End If

            'get and set medico tecnico
            If inIDMedicoTecnico <> 0 Then
                'get medico tecnico
                Dim MedicoTecnico As MedicosTecnicos = (From x In BDContexto.tbMedicosTecnicos
                                                        Where x.ID = inIDMedicoTecnico
                                                        Select New MedicosTecnicos With {.ID = x.ID, .Nome = x.Nome}).FirstOrDefault()

                If Not MedicoTecnico Is Nothing Then
                    'set medico tecnico
                    With inModelo
                        .IDMedicoTecnico = MedicoTecnico.ID : .DescricaoMedicoTecnico = MedicoTecnico.Nome

                        Dim compIDMedico As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABMedico")
                        If Not compIDMedico Is Nothing Then
                            With compIDMedico
                                .ValorID = MedicoTecnico.Nome
                            End With
                        End If
                    End With
                End If
            Else
                Dim MedicoTecnico As MedicosTecnicos = RetornaMedicoTecnicoUtilizadorSessao()

                If Not MedicoTecnico Is Nothing Then
                    'set medico tecnico
                    With inModelo
                        .IDMedicoTecnico = MedicoTecnico.ID : .DescricaoMedicoTecnico = MedicoTecnico.Nome

                        'Dim campoIDMedicoTecnico As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "ModelPropertyName", "IDMedicoTecnico")
                        'If Not campoIDMedicoTecnico Is Nothing Then
                        '    With campoIDMedicoTecnico
                        '        .ValorID = MedicoTecnico.ID : .ValorDescricao = MedicoTecnico.Nome
                        '    End With
                        'End If

                        Dim compIDMedico As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABMedico")
                        If Not compIDMedico Is Nothing Then
                            With compIDMedico
                                .ValorID = MedicoTecnico.Nome
                            End With
                        End If
                    End With

                Else
                    Dim compIDMedico As Components = EncontraRetornaElemento(inModelo.ExamesCustomizacaoComponents, "IDElemento", "CABMedico")
                    If Not compIDMedico Is Nothing Then
                        With compIDMedico
                            .ValorID = "---"
                        End With
                    End If
                End If
            End If

            'set agendamento
            If inIDAgendamento <> 0 Then
                With inModelo
                    .IDAgendamento = inIDAgendamento
                End With
            End If

            'return model with default props
            Return inModelo
        End Function

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="inIDAgendamento"></param>
        ''' <returns></returns>
        Public Function RetornaModelFromAgendamento(ByVal inIDAgendamento As Long) As Oticas.Exames
            Dim Model As Oticas.Exames = Nothing

            Dim IDExame As Long = (From x In BDContexto.tbExames
                                   Where x.IDAgendamento = inIDAgendamento
                                   Select x.ID).FirstOrDefault()

            If IDExame <> 0 Then
                Model = RetornaModelEditar(IDExame)
            End If

            Return Model
        End Function

        ''' <summary>
        ''' Funcao que retorna a o nodulo em que uma determinada prop tenha um determinado valor
        ''' </summary>
        ''' <param name="inList"></param>
        ''' <param name="inModelPropertyName"></param>
        ''' <param name="inSearchValue"></param>
        ''' <returns></returns>
        Private Function EncontraRetornaElemento(inList As List(Of Components), inModelPropertyName As String, inSearchValue As String) As Components
            Dim comp As Components = Nothing

            For Each component As Components In inList
                If component.GetType().GetProperty(inModelPropertyName).GetValue(component) = inSearchValue Then
                    comp = component
                    Exit For
                ElseIf component.ListOfComponentesFilhos.Count > 0 Then
                    comp = EncontraRetornaElemento(component.ListOfComponentesFilhos, inModelPropertyName, inSearchValue)

                    If comp IsNot Nothing Then Return comp
                End If
            Next

            Return comp
        End Function

        ''' <summary>
        ''' Funcao que retorna o medico tecnico associado ao utilizador que está em sessão
        ''' </summary>
        ''' <returns></returns>
        Public Function RetornaMedicoTecnicoUtilizadorSessao() As MedicosTecnicos
            Return (From x In BDContexto.tbMedicosTecnicos
                    Where x.IDUtilizador = IDUtilizador
                    Select New MedicosTecnicos With {.ID = x.ID, .Nome = x.Nome, .IDTipoConsulta = x.IDTipoConsulta, .CodigoTemplate = x.tbTiposConsultas.tbTemplates.Codigo}).FirstOrDefault()
        End Function
#End Region

#Region "HISTORICO"
        ''' <summary>
        ''' Funcao que retorna o historico completo by id cliente  (1 exame selecionado e info carregada para os accordions)
        ''' </summary>
        ''' <param name="inIDCliente"></param>
        ''' <returns></returns>
        Public Function RetornaHistoricoExamesByIDCliente(inIDCliente As Long?) As HistoricoExames
            Dim Model As New HistoricoExames

            If Not inIDCliente Is Nothing Then
                'get exames from idcliente
                Dim _exames = BDContexto.tbExames.Where(Function(w) w.IDCliente = inIDCliente).OrderByDescending(Function(o) o.DataExame).ToList()

                For Each _exame As tbExames In _exames
                    Dim _examesData As New HistoricoExamesDatas

                    With _examesData
                        .IDExame = _exame.ID : .DataExame = _exame.DataExame
                    End With

                    'set datas to model
                    Model.ListOfExamesDatas.Add(_examesData)
                Next

                'set info and id selected to model
                With Model
                    .IDExameSelecionado = _exames?.FirstOrDefault?.ID : .CodigoTemplate = _exames?.FirstOrDefault?.tbTemplates.Codigo

                    'get historico list
                    Dim hist As List(Of tbExamesProps) = _exames?.FirstOrDefault?.tbExamesProps?.Where(Function(w)
                                                                                                           Return w.Ativo
                                                                                                       End Function).ToList()

                    .ExamesAccordions.ListOfExamesAccordionsInfo = RetornaHistoricoInfo(hist)
                End With
            End If

            'return model
            Return Model
        End Function

        ''' <summary>
        ''' Funcao que retorna a informacao do historico by id exame
        ''' </summary>
        ''' <param name="inIDExame"></param>
        ''' <returns></returns>
        Public Function RetornaHistoricoByIDExame(inIDExame As Long) As HistoricoExames
            Dim Model As New HistoricoExames

            Dim _exame As tbExames = BDContexto.tbExames.Where(Function(w) w.ID = inIDExame).FirstOrDefault()
            Dim _examesProps As List(Of tbExamesProps) = _exame?.tbExamesProps?.ToList()

            If Not _exame Is Nothing Then
                Select Case _exame.tbTemplates.Codigo
                    Case TiposExame.Consulta
                        With Model.ExamesAccordions
                            .CodigoTemplate = TiposExame.Consulta : .ViewName = "AccordionsConsulta"
                            .ListOfExamesAccordionsInfo = RetornaHistoricoInfo(_examesProps)
                        End With

                    Case TiposExame.Diagnostico
                        With Model.ExamesAccordions
                            .CodigoTemplate = TiposExame.Diagnostico : .ViewName = "AccordionsDiagnostico"
                            .ListOfExamesAccordionsInfo = RetornaHistoricoInfo(_examesProps)
                        End With
                End Select

                'set idexame to model
                With Model
                    .IDExameSelecionado = _exame.ID
                End With
            End If

            'return model
            Return Model
        End Function

        ''' <summary>
        ''' Funcao que mapeia e retorna a lista de info para o historico
        ''' </summary>
        ''' <param name="inList"></param>
        ''' <returns></returns>
        Private Function RetornaHistoricoInfo(inList As List(Of tbExamesProps)) As List(Of HistoricoExamesAccordionsInfo)
            Return inList?.Select(Function(s)
                                      Dim _info As New HistoricoExamesAccordionsInfo

                                      With _info
                                          .IDElemento = s.IDElemento
                                          .Label = s.Label
                                          .ModelPropertyName = s.ModelPropertyName
                                          .ModelPropertyType = s.ModelPropertyType
                                          .ValorID = s.ValorID
                                          .ValorDescricao = s.ValorDescricao
                                          .Ordem = s.Ordem
                                          .ViewClassesCSS = s.ViewClassesCSS
                                      End With

                                      Return _info
                                  End Function).ToList()
        End Function
#End Region

#Region "FOTOS"
        ''' <summary>
        ''' Funcao que guarda / edita / remove as fotos na BD e na pasta correcta
        ''' </summary>
        ''' <param name="inModelo"></param>
        ''' <param name="intbExame"></param>
        Private Sub GravaFotos(inModelo As ExamesCustomModel, intbExame As tbExames)
            'AQUI GRAVA FOTOS AO EDITAR
            Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)
            Dim CaminhoTemp As String = ClsUploadFicheiros.CaminhoFisicoTemp
            Dim maxOrdem As Integer = 0

            For Each foto As FotosGrid In inModelo.ExamesFotos
                Select Case foto.AcaoFormulario
                    Case AcoesFormulario.Adicionar

                        If foto.ID = 0 Then
                            'Dim maxOrdem As Integer? = intbExame?.tbExamesPropsFotos.Select(Function(s) s.Ordem IsNot Nothing AndAlso s.Ordem)?.Max()
                            'maxOrdem = If(maxOrdem Is Nothing, 0, maxOrdem)

                            maxOrdem = maxOrdem + 1
                            Dim examePropFoto As New tbExamesPropsFotos
                            With examePropFoto
                                .Foto = foto.Foto : .FotoCaminho = foto.FotoCaminho & "Exames/" : .Ordem = maxOrdem : foto.FotoCaminhoCompleto = CaminhoTemp & foto.Foto
                                .Ativo = True : .Sistema = False : .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome : .DataCriacao = DateAndTime.Now()
                            End With

                            intbExame.tbExamesPropsFotos.Add(examePropFoto)

                            ClsUploadFicheiros.GravaFicheiro(foto.Foto, examePropFoto.FotoCaminho, String.Empty, String.Empty, foto.FotoCaminhoCompleto, AcoesFormulario.Adicionar)
                        End If

                    Case AcoesFormulario.Alterar
                        If foto.ID <> 0 Then
                            maxOrdem = maxOrdem + 1

                            Dim examePropFoto As tbExamesPropsFotos = intbExame.tbExamesPropsFotos.Where(Function(w) w.ID = foto.ID).FirstOrDefault()
                            With examePropFoto
                                .Foto = foto.Foto : .FotoCaminho = foto.FotoCaminho : .Ordem = maxOrdem : foto.FotoCaminhoCompleto = CaminhoTemp & foto.Foto
                                .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome : .DataAlteracao = DateAndTime.Now()
                            End With

                            ClsUploadFicheiros.GravaFicheiro(foto.Foto, foto.FotoCaminho, foto.FotoAnterior, foto.FotoCaminhoAnterior, foto.FotoCaminhoCompleto, AcoesFormulario.Alterar)
                        End If

                    Case AcoesFormulario.Remover
                        ClsUploadFicheiros.ApagaFicheiro(Hosting.HostingEnvironment.MapPath(foto.FotoCaminhoAnteriorCompleto))

                        If foto.ID <> 0 Then
                            Dim exameFoto As tbExamesPropsFotos = intbExame.tbExamesPropsFotos.Where(Function(w) w.ID = foto.ID).FirstOrDefault()

                            intbExame.tbExamesPropsFotos.Remove(exameFoto)
                            BDContexto.Entry(exameFoto).State = EntityState.Deleted

                            ClsUploadFicheiros.ApagaFicheiro(Hosting.HostingEnvironment.MapPath(foto.FotoCaminhoAnteriorCompleto))
                        End If
                End Select
            Next
        End Sub
#End Region
    End Class
End Namespace