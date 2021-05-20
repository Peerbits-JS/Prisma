Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports DDay.iCal

Namespace Repositorio.Planeamento
    Public Class RepositorioPlaneamento
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbPlaneamento, F3M.Planeamento)

        'Inherits F3M.Repositorio.Planeamento.RepositorioPlaneamento(Of BD.Dinamica.Aplicacao, tbPlaneamento, F3M.Planeamento)

        'Private Shared codigoAcesso As String = Generico.Constantes.AcessosEspecificos.PlaneamentoTodosProfissionais


#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbPlaneamento)) As IQueryable(Of F3M.Planeamento)
            Return query.Select(Function(e) New F3M.Planeamento With {
                .ID = e.ID,
                .Start = e.Start, .End = e.End, .IsAllDay = e.IsAllDay,
                .IDLoja = e.IDLoja, .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                .DescricaoLoja = e.tbLojas.Descricao,
                .RecurrenceRule = If(e.RecurrenceRule <> Nothing, e.RecurrenceRule, String.Empty),
                .RecurrenceException = If(e.RecurrenceException <> Nothing, e.RecurrenceException, String.Empty),
                .Title = e.tbMedicosTecnicos.Nome, .Description = "Sem Descrição",
                .Cor = e.tbMedicosTecnicos.Cor, .CorLoja = e.tbLojas.Cor,
                .StartTimezone = If(e.StartTimezone <> Nothing, e.StartTimezone, String.Empty),
                .EndTimezone = If(e.EndTimezone <> Nothing, e.EndTimezone, String.Empty), .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbPlaneamento)) As IQueryable(Of F3M.Planeamento)
            Return query.Select(Function(e) New F3M.Planeamento With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.Planeamento)
            Dim query As IQueryable(Of F3M.Planeamento) = AplicaQueryListaPersonalizada(inFiltro)

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query, True)

            Return query
        End Function


        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.Planeamento)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Public Overrides Function ObtemPorObjID(objID As Object) As F3M.Planeamento
            Dim lngObjID As Long = objID
            Dim query As IQueryable = tabela.AsNoTracking.Where(Function(a) a.ID.Equals(lngObjID))

            Dim res As F3M.Planeamento = ListaCamposTodos(query).FirstOrDefault

            Return res
        End Function


        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbPlaneamento)
            Dim query As IQueryable(Of tbPlaneamento) = tabela.AsNoTracking

            ' --- ESPECIFICO IDLoja---
            Dim lstIDLoja As New List(Of Long)
            For Each c As Long In ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDLoja", GetType(String))
                lstIDLoja.Add(c)
            Next
            If lstIDLoja.Count Then
                query = query.Where(Function(w) lstIDLoja.Contains(w.IDLoja))
            End If

            ' --- ESPECIFICO IDMedicoTecnico---
            Dim lstIDMedicoTecnico As New List(Of Long)
            For Each c As Long In ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMedicoTecnico", GetType(String))
                lstIDMedicoTecnico.Add(c)
            Next
            If lstIDMedicoTecnico.Count Then
                query = query.Where(Function(w) lstIDMedicoTecnico.Contains(w.IDMedicoTecnico))
            End If

            ' --- o Medico tem agenda definida
            query = query.Where(Function(f) f.tbMedicosTecnicos.TemAgenda)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES ESPECÍFICAS"
        Public Sub PreencheOcorrenciasPlaneamento(plan As IList(Of F3M.Planeamento), filtro As ClsF3MFiltro)
            For Each p In plan
                If p.RecurrenceRule IsNot Nothing AndAlso p.RecurrenceRule.Count Then
                    Dim res = RetornaOcorrenciasSeriesRecurrenceRuleLinhas(p, filtro)
                    p.ListaOcorrencias = res.Select(Function(s) New F3M.Planeamento With {
                        .Start = New Date(s.Period.StartTime.Value.Year, s.Period.StartTime.Value.Month, s.Period.StartTime.Value.Day, s.Period.StartTime.Value.Hour, s.Period.StartTime.Value.Minute, s.Period.StartTime.Value.Second),
                        .End = New Date(s.Period.EndTime.Value.Year, s.Period.EndTime.Value.Month, s.Period.EndTime.Value.Day, s.Period.EndTime.Value.Hour, s.Period.EndTime.Value.Minute, s.Period.EndTime.Value.Second),
                        .IDMedicoTecnico = p.IDMedicoTecnico,
                        .IDLoja = p.IDLoja
                    }).ToList()
                End If
            Next
        End Sub

        Private Function RetornaOcorrenciasSeriesRecurrenceRuleLinhas(inObjBDPlaneamento As F3M.Planeamento, inFiltro As ClsF3MFiltro) As List(Of Occurrence)
            Try
                Dim iCal As iCalendar = New iCalendar()
                Dim evtCalendar = iCal.Create(Of [Event])()
                evtCalendar.Start = New iCalDateTime(inObjBDPlaneamento.Start)
                evtCalendar.End = New iCalDateTime(inObjBDPlaneamento.End)
                evtCalendar.RecurrenceRules.Add(New RecurrencePattern(inObjBDPlaneamento.RecurrenceRule))
                evtCalendar.IsAllDay = inObjBDPlaneamento.IsAllDay

                Dim dtInicio As Date = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "startDate", GetType(Date))
                Dim dtFim As Date = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "endDate", GetType(Date))

                If Not String.IsNullOrWhiteSpace(inObjBDPlaneamento.RecurrenceException) Then
                    Dim periodList As New PeriodList
                    For Each dtString In inObjBDPlaneamento.RecurrenceException.Split(",")
                        If dtString.Length > 0 Then
                            Dim formatString As String = "yyyyMMddTHHmmssZ"
                            Dim dt As iCalDateTime = New iCalDateTime(DateTime.ParseExact(dtString, formatString, Nothing))
                            periodList.Add(dt)
                        End If
                    Next
                    If periodList.Count > 0 Then
                        evtCalendar.ExceptionDates.Add(periodList)
                    End If
                End If

                Dim lstHsDeOcorrencias As List(Of Occurrence) = evtCalendar.GetOccurrences(dtInicio, dtFim)

                Return lstHsDeOcorrencias
            Catch ex As Exception
                Throw
            End Try
        End Function

#End Region

    End Class
End Namespace