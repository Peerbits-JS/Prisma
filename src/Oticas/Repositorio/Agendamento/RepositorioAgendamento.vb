Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Agendamento
    Public Class RepositorioAgendamento
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbAgendamento, F3M.Agendamento)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbAgendamento)) As IQueryable(Of F3M.Agendamento)
            Return query.Select(Function(e) New F3M.Agendamento With {
                .ID = e.ID,
                .Start = e.Start, .End = e.End, .IsAllDay = e.IsAllDay,
                .IDLoja = e.IDLoja, .IDEspecialidade = e.IDEspecialidade, .IDMedicoTecnico = e.IDMedicoTecnico, .IDCliente = e.IDCliente,
                .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                .DescricaoCliente = If(Not e.tbClientes Is Nothing, e.tbClientes.Nome, String.Empty),
                .DescricaoLoja = e.tbLojas.Descricao,
                .IDSistemaAcaoMedico = e.tbMedicosTecnicos.IDSistemaAcoes,
                .Nome = e.Nome, .Contacto = e.Contacto, .Observacoes = e.Observacoes,
                .RecurrenceRule = If(e.RecurrenceRule <> Nothing, e.RecurrenceRule, String.Empty),
                .RecurrenceException = If(e.RecurrenceException <> Nothing, e.RecurrenceException, String.Empty),
                .Title = If(e.tbClientes IsNot Nothing, e.tbClientes.Nome, e.Nome), .Description = "Sem Descrição",
                .Cor = e.tbMedicosTecnicos.Cor, .CorLoja = e.tbLojas.Cor,
                .IDConsulta = e.tbExames.FirstOrDefault.ID,
                .StartTimezone = If(e.StartTimezone <> Nothing, e.StartTimezone, String.Empty),
                .EndTimezone = If(e.EndTimezone <> Nothing, e.EndTimezone, String.Empty), .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbAgendamento)) As IQueryable(Of F3M.Agendamento)
            Return query.Select(Function(e) New F3M.Agendamento With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.Agendamento)
            Dim query As IQueryable(Of F3M.Agendamento) = AplicaQueryListaPersonalizada(inFiltro)

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query, True)

            Return query
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.Agendamento)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Public Overrides Function ObtemPorObjID(objID As Object) As F3M.Agendamento
            Dim lngObjID As Long = objID
            Dim query As IQueryable = tabela.AsNoTracking.Where(Function(a) a.ID.Equals(lngObjID))
            Return ListaCamposTodos(query).FirstOrDefault
        End Function

        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbAgendamento)
            Dim query As IQueryable(Of tbAgendamento) = tabela.AsNoTracking

            ' --- ESPECIFICO IDLoja---
            Dim lstIDLoja As New List(Of Long)
            For Each c As Long In ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDLoja", GetType(String))
                lstIDLoja.Add(c)
            Next
            If lstIDLoja.Count Then
                query = query.Where(Function(w) lstIDLoja.Contains(w.IDLoja))
            End If

            ' --- ESPECIFICO IDEspecialidade---
            Dim lstIDEspecialidade As New List(Of Long)
            For Each c As Long In ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEspecialidade", GetType(String))
                lstIDEspecialidade.Add(c)
            Next
            If lstIDEspecialidade.Count Then
                query = query.Where(Function(w) lstIDEspecialidade.Contains(w.IDEspecialidade))
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

            ' --- filtro das datas
            Dim startDate As Date = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "startDate", GetType(Date))
            startDate = New DateTime(startDate.Year, startDate.Month, startDate.Day, 0, 0, 0)

            Dim endDate As Date = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "endDate", GetType(Date))
            endDate = New DateTime(endDate.Year, endDate.Month, endDate.Day, 23, 59, 59)

            query = query.Where(Function(w) w.Start >= startDate AndAlso w.End <= endDate)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES ESPECÍFICAS"
#End Region

    End Class
End Namespace