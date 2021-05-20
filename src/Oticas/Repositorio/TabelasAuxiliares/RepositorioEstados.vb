Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioEstados
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbEstados, Estados)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Function ValoresPorDefeito(ByVal inTipoEstado As String) As F3M.Estados
            Return F3M.Repositorio.Comum.RepositorioEstados.ValoresPorDefeito(Of tbEstados)(BDContexto, inTipoEstado)
        End Function

        Public Function ValorInicial(ByVal inInicial As Boolean, ByVal EntidadeEstado As String) As F3M.Estados
            Return F3M.Repositorio.Comum.RepositorioEstados.ValorInicial(Of tbEstados)(BDContexto, inInicial, EntidadeEstado)
        End Function

        Public Function RetornaEstadoByEntidadeETipoEstado(ByVal inEntidadeEstado As String, ByVal inTipoEstado As String) As F3M.Estados
            Return F3M.Repositorio.Comum.RepositorioEstados.RetornaEstadoByEntidadeETipoEstado(Of tbEstados)(BDContexto, inEntidadeEstado, inTipoEstado)
        End Function

        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbEstados)) As IQueryable(Of Estados)
            Return query.Select(Function(s) New Estados With {
                                    .ID = s.ID, .Codigo = s.Codigo, .Descricao = s.Descricao,
                                    .IDEntidadeEstado = s.IDEntidadeEstado,
                                    .CodigoEntidadeEstado = If(s.tbSistemaEntidadesEstados IsNot Nothing, s.tbSistemaEntidadesEstados.Codigo, String.Empty),
                                    .DescricaoEntidadeEstado = If(s.tbSistemaEntidadesEstados IsNot Nothing, s.tbSistemaEntidadesEstados.Descricao, String.Empty),
                                    .IDTipoEstado = s.IDTipoEstado,
                                    .DescricaoTipoEstado = If(s.tbSistemaTiposEstados IsNot Nothing, s.tbSistemaTiposEstados.Descricao, String.Empty),
                                    .CodigoTipoEstado = If(s.tbSistemaTiposEstados IsNot Nothing, s.tbSistemaTiposEstados.Codigo, String.Empty),
                                    .Predefinido = s.Predefinido,
                                    .EstadoInicial = s.EstadoInicial,
                                    .Ativo = s.Ativo,
                                    .Sistema = s.Sistema,
                                    .DataCriacao = s.DataCriacao,
                                    .UtilizadorCriacao = s.UtilizadorCriacao,
                                    .DataAlteracao = s.DataAlteracao,
                                    .UtilizadorAlteracao = s.UtilizadorAlteracao,
                                    .F3MMarcador = s.F3MMarcador,
                                    .PredNovosDoc = s.EstadoInicial,
                                    .PredTransAuto = s.Predefinido})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbEstados)) As IQueryable(Of Estados)
            Return F3M.Repositorio.Comum.RepositorioEstados.ListaCamposComboDocs(Of tbEstados, Estados, tbControloDocumentos)(BDContexto, query)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Estados)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Estados)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbEstados)
            Dim query As IQueryable(Of tbEstados) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            '-- ESPECIFICO
            Dim strTipoEstados As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposEspecificos.tipoentidadeestado, GetType(String))
            Dim CodTipoEstadoRascunho As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodTipoEstadoRascunho", GetType(String))
            Dim CodTipoEstadoAberto As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodTipoEstadoAberto", GetType(String))
            Dim CodTipoEstadoAnulado As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodTipoEstadoAnulado", GetType(String))
            Dim CodTipoEstadoFaturado As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodTipoEstadoFaturado", GetType(String))
            Dim CodTipoEstadoFechado As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodTipoEstadoFechado", GetType(String))

            Dim CodTipoEstadoEfetivo As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodTipoEstadoEfetivo", GetType(String))

            If Not ClsTexto.ENuloOuVazio(strTipoEstados) Then
                query = query.Where(Function(w) w.tbSistemaEntidadesEstados.Codigo.Equals(strTipoEstados))
            End If

            'FILTRA PARA DV e SV'
            Dim array As New List(Of String)
            ' Se considera o filtro de rascunho
            If Not ClsTexto.ENuloOuVazio(CodTipoEstadoRascunho) Then
                array.Add(CodTipoEstadoRascunho)
            End If
            ' Se considera o filtro de Aberto
            If Not ClsTexto.ENuloOuVazio(CodTipoEstadoAberto) Then
                array.Add(CodTipoEstadoAberto)
            End If

            If Not ClsTexto.ENuloOuVazio(CodTipoEstadoFechado) Then
                array.Add(CodTipoEstadoFechado)
            End If

            If Not ClsTexto.ENuloOuVazio(CodTipoEstadoEfetivo) Then
                array.Add(CodTipoEstadoEfetivo)
            End If

            ' Se considera o filtro de anulados
            If strTipoEstados = TiposEntidadeEstados.DocumentosVenda OrElse
                strTipoEstados = TiposEntidadeEstados.Servicos OrElse
                strTipoEstados = TiposEntidadeEstados.DocumentosCompras OrElse
                strTipoEstados = TiposEntidadeEstados.DocumentosStock OrElse
                strTipoEstados = TiposEntidadeEstados.DocumentosPagamentosCompras Then

                If Not ClsTexto.ENuloOuVazio(CodTipoEstadoAnulado) Then
                    array.Add(CodTipoEstadoAnulado)
                End If

            End If
            If array.Count > 0 Then
                query = query.Where(Function(w) array.Contains(w.tbSistemaTiposEstados.Codigo) AndAlso w.Ativo = True)
            End If

            Return query.OrderBy(Function(o) o.Descricao)
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As Estados
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As Estados, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As Estados, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Estados, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Estados,
                                                 e As tbEstados, inAcao As AcoesFormulario)
            o.ID = e.ID
            F3M.Repositorio.Comum.RepositorioEstados.ValidaEstadosPredefinido(Of tbEstados)(inCtx, o)
        End Sub

#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function ValidaEstadosIniciais(IDEntidade As Integer, EstadoInicial As Boolean) As Boolean
            Return F3M.Repositorio.Comum.RepositorioEstados.ValidaEstadosIniciais(Of tbEstados)(BDContexto, IDEntidade, EstadoInicial)
        End Function

        Public Function ValidaEstadosIniciaisEdicao(ID As Long, IDEntidade As Integer, EstadoInicial As Boolean) As Boolean
            Return F3M.Repositorio.Comum.RepositorioEstados.ValidaEstadosIniciaisEdicao(Of tbEstados)(BDContexto, ID, IDEntidade, EstadoInicial)
        End Function

        Public Function TemDocumentos(id As Long) As Boolean
            Return BDContexto.tbControloDocumentos.Any(Function(a) a.IDEstado = id)
        End Function

        Public Function AtivaPredefinicaoNovosDocs(idTipoEstado As Long) As Boolean
            Dim estado As tbSistemaTiposEstados = BDContexto.tbSistemaTiposEstados.FirstOrDefault(Function(s) s.ID = idTipoEstado)
            If Not estado Is Nothing Then Return estado.AtivaPredefNovosDocs

            Return True
        End Function
#End Region

    End Class
End Namespace
