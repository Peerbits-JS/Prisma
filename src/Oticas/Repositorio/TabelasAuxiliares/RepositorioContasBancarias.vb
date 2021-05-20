Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Genericos
Imports System.Data.Entity
Imports F3M.Areas
Imports F3M.Modelos.BaseDados

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioContasBancarias
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbContasBancarias, ContasBancarias)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbContasBancarias)) As IQueryable(Of ContasBancarias)
            Return query.Select(Function(f) New ContasBancarias With {
                .ID = f.ID, .IDLoja = f.IDLoja, .Codigo = f.Codigo, .Descricao = f.Descricao, .IDBanco = f.IDBanco, .DescricaoBanco = f.tbBancos.Descricao, .IDMoeda = f.IDMoeda,
                .DescricaoMoeda = f.tbMoedas.Descricao, .Plafond = f.Plafond, .TaxaPlafond = f.TaxaPlafond, .PaisIban = f.PaisIban, .NIB = f.NIB, .SepaPrv = f.SepaPrv,
                .VariavelContabilidade = f.VariavelContabilidade, .ContaCaixa = f.ContaCaixa, .SaldoTotal = f.SaldoTotal, .SaldoReconciliado = f.SaldoReconciliado,
                .Observacoes = f.Observacoes, .Ativo = f.Ativo, .Sistema = f.Sistema, .DataCriacao = f.DataCriacao, .UtilizadorCriacao = f.UtilizadorCriacao,
                .DataAlteracao = f.DataAlteracao, .UtilizadorAlteracao = f.UtilizadorAlteracao, .F3MMarcador = f.F3MMarcador})
            '.DescricaoLoja = f.tbLojas.Codigo
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbContasBancarias)) As IQueryable(Of ContasBancarias)
            Return query.Select(Function(e) New ContasBancarias With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasBancarias)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasBancarias)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA

        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbContasBancarias)

            Dim query As IQueryable(Of tbContasBancarias) = tabela.AsNoTracking
            Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            If eLookup Then
                query = query.OrderBy(Function(o) o.Descricao)
            End If

            Return query
        End Function

#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As ContasBancarias, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As ContasBancarias, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As ContasBancarias, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As ContasBancarias,
                                                 e As tbContasBancarias, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add(CamposGenericos.IDContaBancaria, e.ID)

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                GravaLinhas(Of tbContasBancariasContatos, ContasBancariasContatos)(inCtx, e, o, dict)
                GravaLinhas(Of tbContasBancariasMoradas, ContasBancariasMoradas)(inCtx, e, o, dict)
            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                GravaLinhasEntidades(Of tbContasBancariasContatos)(inCtx, e.tbContasBancariasContatos.ToList, AcoesFormulario.Remover, Nothing)
                GravaLinhasEntidades(Of tbContasBancariasMoradas)(inCtx, e.tbContasBancariasMoradas.ToList, AcoesFormulario.Remover, Nothing)

            End If
        End Sub
#End Region

    End Class
End Namespace