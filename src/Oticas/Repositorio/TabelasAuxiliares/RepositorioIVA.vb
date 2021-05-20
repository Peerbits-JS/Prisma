Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.BD.Dinamica

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioIVA
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbIVA, IVA)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbIVA)) As IQueryable(Of IVA)
            Return F3M.Repositorio.Comum.RepositorioIVA.ListaCamposTodosComum(Of tbIVA, IVA)(BDContexto, query)
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbIVA)) As IQueryable(Of IVA)
            Return F3M.Repositorio.Comum.RepositorioIVA.ListaCamposComboComum(Of tbIVA, IVA)(BDContexto, query)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of IVA)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of IVA)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Function ListaComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of IVA)
            Return ListaCamposCombo(FiltraQueryCodigo(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbIVA)
            Dim query As IQueryable(Of tbIVA) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            ' --- ESPECIFICO ---
            Dim filtroIVARegiao As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDGrelhaIVARegiao", GetType(Long))
            If filtroIVARegiao > 0 Then
                query = query.Where(Function(w) w.ID <> filtroIVARegiao)
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

        ' FILTRA LISTA
        Protected Function FiltraQueryCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of tbIVA)
            Dim query As IQueryable(Of tbIVA) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Codigo.Contains(filtroTxt))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As IVA, inFiltro As ClsF3MFiltro)
            ValidarRegisto(o)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As IVA, inFiltro As ClsF3MFiltro)
            ValidarRegisto(o)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As IVA, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As IVA, e As tbIVA, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add("IDIva", e.ID)

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                GravaLinhas(Of tbIVARegioes, F3M.IVARegioes)(inCtx, e, o, dict)
            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                GravaLinhasEntidades(Of tbIVARegioes)(inCtx, e.tbIVARegioes.ToList, AcoesFormulario.Remover, Nothing)
            End If
        End Sub

        Public Sub ValidarRegisto(ByRef o As IVA)
            If (o.Taxa = 0 And o.Mencao = String.Empty) OrElse (o.Taxa <> 0 And o.Mencao <> String.Empty) Then
                Throw New Exception(Traducao.EstruturaIVA.Aviso_MotivoIsencao)
            End If
        End Sub
#End Region

#Region "IVA DESCONTOS"
        ''' <summary>
        ''' Funcao que retorna a lista de descontos do IVA
        ''' </summary>
        ''' <returns></returns>
        Public Function ListaDescontosIVA() As List(Of IVA)
            Return ListaDescontosIVA(BDContexto)
        End Function

        Public Function ListaDescontosIVA(ctx As Aplicacao) As List(Of IVA)
            Dim funcSel As Func(Of tbIVA, IVA) = Function(s)
                                                     Dim iva As New IVA

                                                     With iva
                                                         .IDIva = s.ID : .Codigo = s.Codigo : .Descricao = s.Descricao : .Taxa = s.Taxa

                                                         If Not s.tbIVADescontos?.FirstOrDefault Is Nothing Then
                                                             .ID = s.tbIVADescontos.FirstOrDefault.ID : .AcaoFormulario = AcoesFormulario.Alterar
                                                             .IDIVADesconto = s.tbIVADescontos.FirstOrDefault.ID
                                                             .Desconto = s.tbIVADescontos.FirstOrDefault.Desconto : .ValorMinimo = s.tbIVADescontos.FirstOrDefault.ValorMinimo : .PCM = s.tbIVADescontos.FirstOrDefault.PCM
                                                             .UtilizadorCriacao = s.UtilizadorCriacao : .DataCriacao = s.DataCriacao
                                                         Else
                                                             .ID = CLng(0) : .AcaoFormulario = AcoesFormulario.Adicionar
                                                             .IDIVADesconto = CLng(0) : .Desconto = CDbl(0) : .ValorMinimo = CDbl(0) : .PCM = CDbl(0)
                                                         End If
                                                     End With
                                                     Return iva
                                                 End Function

            Return ctx.tbIVA.AsNoTracking().Select(funcSel).ToList()
        End Function

        ''' <summary>
        ''' Funcao que grava a lista de descontos do IVA na tbIVADescontos
        ''' </summary>
        ''' <param name="inModelo"></param>
        Public Sub GravaObIVADescontos(inModelo As List(Of IVA))
            'iterar nas linhas todas
            For Each lin As IVA In inModelo
                'instance new tbIVADescontos object
                Dim newIVADescontos As New tbIVADescontos
                'map it
                Mapear(lin, newIVADescontos)
                'select new or update
                Select Case lin.AcaoFormulario
                    Case AcoesFormulario.Adicionar
                        'main props
                        With newIVADescontos
                            .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                            .DataCriacao = DateAndTime.Now()
                        End With
                        'entry set
                        With BDContexto
                            .tbIVADescontos.Add(newIVADescontos)
                            .Entry(newIVADescontos).State = Entity.EntityState.Added
                        End With

                    Case AcoesFormulario.Alterar
                        'main props
                        With newIVADescontos
                            .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome
                            .DataAlteracao = DateAndTime.Now()
                        End With
                        'entry set
                        With BDContexto
                            .tbIVADescontos.Add(newIVADescontos)
                            .Entry(newIVADescontos).State = Entity.EntityState.Modified
                            'no changes
                            .Entry(newIVADescontos).[Property](Function(x) x.UtilizadorCriacao).IsModified = False
                            .Entry(newIVADescontos).[Property](Function(x) x.DataCriacao).IsModified = False
                        End With
                End Select
            Next

            'save all on db
            With BDContexto
                .SaveChanges()
            End With
        End Sub

        ''' <summary>
        ''' Funcao que retorna se é utilizada a configuração de descontos
        ''' </summary>
        ''' <returns></returns>
        Public Function UtilizaConfigDescontos() As Boolean
            Return BDContexto.tbIVADescontos.Where(Function(w) w.Desconto <> 0).Count > 0
        End Function
#End Region
    End Class
End Namespace