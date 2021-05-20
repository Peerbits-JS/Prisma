Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity
Imports F3M

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioModelosArtigos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbModelos, ModelosArtigos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbModelos)) As IQueryable(Of ModelosArtigos)
            Return query.Select(Function(entity) New ModelosArtigos With {
                .ID = entity.ID, .Codigo = entity.Codigo, .Descricao = entity.Descricao, .IDMarca = entity.IDMarca, .DescricaoMarca = entity.tbMarcas.Descricao,
                .IDTipoLente = entity.IDTipoLente, .DescricaoTipoLente = entity.tbSistemaTiposLentes.Descricao, .IDMateriaLente = entity.IDMateriaLente,
                .DescricaoMateriaLente = entity.tbSistemaMateriasLentes.Descricao,
                .IDSuperficieLente = entity.IDSuperficieLente, .DescricaoSuperficieLente = entity.tbSistemaSuperficiesLentes.Descricao,
                .IDTipoArtigo = entity.IDTipoArtigo, .DescricaoTipoArtigo = entity.tbTiposArtigos.Descricao,
                .Stock = entity.Stock, .Fotocromatica = entity.Fotocromatica, .IndiceRefracao = entity.IndiceRefracao,
                .NrABBE = entity.NrABBE, .TransmissaoLuz = entity.TransmissaoLuz,
                .Material = entity.Material, .UVA = entity.UVA, .UVB = entity.UVB, .Infravermelhos = entity.Infravermelhos, .CodForn = entity.CodForn,
                .Referencia = entity.Referencia, .ModeloForn = entity.ModeloForn, .CodCor = entity.CodCor,
                .CodTratamento = entity.CodTratamento, .CodInstrucao = entity.CodInstrucao, .Observacoes = entity.Observacoes,
                .Sistema = entity.Sistema, .Ativo = entity.Ativo, .DataCriacao = entity.DataCriacao, .UtilizadorCriacao = entity.UtilizadorCriacao,
                .DataAlteracao = entity.DataAlteracao, .UtilizadorAlteracao = entity.UtilizadorAlteracao, .F3MMarcador = entity.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbModelos)) As IQueryable(Of ModelosArtigos)
            Return query.
                Select(Function(entity) New ModelosArtigos With {.ID = entity.ID, .Descricao = entity.Descricao, .IDTipoLente = entity.IDTipoLente, .IDMateriaLente = entity.IDMateriaLente}).
                Take(TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ModelosArtigos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ModelosArtigos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbModelos)
            Dim query As IQueryable(Of tbModelos) = tabela.AsNoTracking
            Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
            Dim filtroTxt As String = inFiltro.FiltroTexto

            'Especifico -  Modelos catalogo lentes
            Dim blnCatalogoLentes As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "catalogolentes", GetType(Boolean))
            If blnCatalogoLentes Then
                Dim IDMarcaCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMarca", GetType(Long))
                Dim IDTipoLenteCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoLente", GetType(Long))
                Dim IDMateriaCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMateria", GetType(Long))

                Dim IndiceRefracao As Double? = Nothing
                Dim IndiceRefracaoAux As String = ClsUtilitarios.RetornaValorKeyDicionario(inFiltro.CamposFiltrar, "IndiceRefracao", CamposGenericos.CampoValor)
                If Not String.IsNullOrEmpty(IndiceRefracaoAux) Then
                    IndiceRefracao = CDbl(IndiceRefracaoAux)
                End If

                Dim Fotocromatica As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Fotocromatica", GetType(Boolean))

                Dim Tipo As String = If(ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "boolLentesOftalmicas", GetType(Boolean)), "LO", "LC")

                If Tipo = "LO" AndAlso IDMarcaCL <> 0 AndAlso IDTipoLenteCL <> 0 AndAlso IDMateriaCL <> 0 Then
                    query = query.Where(Function(x) x.IDMarca = IDMarcaCL AndAlso
                                            x.IDTipoLente = IDTipoLenteCL AndAlso
                                            x.IDMateriaLente = IDMateriaCL AndAlso
                                            x.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo = Tipo AndAlso
                                            If(IndiceRefracao Is Nothing, True, x.IndiceRefracao = IndiceRefracao) AndAlso
                                            x.Fotocromatica = Fotocromatica)

                ElseIf Tipo = "LC" AndAlso IDMarcaCL <> 0 AndAlso IDTipoLenteCL <> 0 Then
                    query = query.Where(Function(x) x.IDMarca = IDMarcaCL AndAlso
                                            x.IDTipoLente = IDTipoLenteCL AndAlso
                                            x.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo = Tipo AndAlso
                                            If(IndiceRefracao Is Nothing, True, x.IndiceRefracao = IndiceRefracao) AndAlso
                                            x.Fotocromatica = Fotocromatica)

                Else
                    query = query.Where(Function(x) x.ID = 0)
                End If

            Else
                ' --- GENERICO ---
                ' COMBO
                If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                    query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
                End If

                Dim IDMarca As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMarca", GetType(Long))
                If IDMarca <> 0 Then
                    query = query.Where(Function(x) x.IDMarca = IDMarca)
                End If


                Dim IDTipoArtigo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoArtigo", GetType(Long))
                If IDTipoArtigo <> 0 Then
                    query = query.Where(Function(x) x.IDTipoArtigo = IDTipoArtigo)
                End If

                Dim strView As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "View", GetType(String))
                If Not String.IsNullOrEmpty(strView) Then
                    query = query.Where(Function(x) x.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo = "LO")

                    Dim IDMateriaLente As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMateriaLente", GetType(Long))
                    If IDMateriaLente <> 0 Then
                        query = query.Where(Function(x) x.IDMateriaLente = IDMateriaLente)
                    End If

                    Dim IDTipoLente As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoLente", GetType(Long))
                    If IDTipoLente <> 0 Then
                        query = query.Where(Function(x) x.IDTipoLente = IDTipoLente)
                    End If
                End If
            End If

            Return query.OrderBy(Function(o) o.Descricao)
        End Function

        Public Function ListaModelos(LenteOftalmica As Boolean, IDMarca As Long, IDTipoLente As Long, IDMateriaLente As Long, Indice As Double?, Fotocromatica As Boolean) As List(Of ModelosArtigos)
            Dim t As New List(Of ModelosArtigos)

            If LenteOftalmica Then
                t = tabela.
                    AsNoTracking().
                    Where(Function(entity) entity.Ativo AndAlso
                    entity.IDTipoArtigo = 1 AndAlso
                    entity.IDMarca = IDMarca AndAlso
                    entity.IDTipoLente = IDTipoLente AndAlso
                    entity.IDMateriaLente = IDMateriaLente AndAlso
                    If(Indice Is Nothing, True, entity.IndiceRefracao = Indice) AndAlso
                    entity.Fotocromatica = Fotocromatica).
                    Select(Function(entity) New ModelosArtigos With {.ID = entity.ID, .Descricao = entity.Descricao, .IndiceRefracao = entity.IndiceRefracao, .Fotocromatica = entity.Fotocromatica}).
                    OrderBy(Function(dto) dto.Descricao).
                    ToList()

            Else
                t = tabela.AsNoTracking().
                    Where(Function(entity) entity.Ativo AndAlso
                    entity.IDTipoArtigo = 3 AndAlso
                    entity.IDMarca = IDMarca AndAlso
                    entity.IDTipoLente = IDTipoLente AndAlso
                    entity.Ativo = True AndAlso
                    If(Indice Is Nothing, True, entity.IndiceRefracao = Indice) AndAlso
                    entity.Fotocromatica = Fotocromatica).
                    Select(Function(entity) New ModelosArtigos With {.ID = entity.ID, .Descricao = entity.Descricao, .IndiceRefracao = entity.IndiceRefracao, .Fotocromatica = entity.Fotocromatica}).
                    OrderBy(Function(dto) dto.Descricao).
                    ToList()
            End If

            For Each e In t
                e.IndiceRefracaoAux = e.IndiceRefracao
                e.IndiceRefracao = Math.Round(e.IndiceRefracao, 3, MidpointRounding.AwayFromZero)
            Next

            Return t
        End Function

        Public Function ListaIndices(LenteOftalmica As Boolean, IDMarca As Long, IDTipoLente As Long, IDMateriaLente As Long, Fotocromatica As Boolean?) As List(Of ModelosArtigos)
            Dim result As New List(Of ModelosArtigos)

            If LenteOftalmica Then
                result = tabela.
                AsNoTracking().
                Where(Function(entity) entity.Ativo = True AndAlso
                entity.IDTipoArtigo = 1 AndAlso
                entity.IDMarca = IDMarca AndAlso
                entity.IDTipoLente = IDTipoLente AndAlso
                entity.IDMateriaLente = IDMateriaLente AndAlso
                entity.Fotocromatica = Fotocromatica).
                Select(Function(entity) New ModelosArtigos With {.IndiceRefracao = entity.IndiceRefracao}).
                Distinct().
                OrderBy(Function(dto) dto.IndiceRefracao).
                ToList()

            Else
                result = tabela.AsNoTracking().
                    Where(Function(entity) entity.Ativo = True AndAlso
                    entity.IDTipoArtigo = 3 AndAlso
                    entity.IDMarca = IDMarca AndAlso
                    entity.IDTipoLente = IDTipoLente AndAlso
                    entity.Fotocromatica = Fotocromatica).
                    Select(Function(entity) New ModelosArtigos With {.IndiceRefracao = entity.IndiceRefracao}).
                    Distinct().
                    OrderBy(Function(dto) dto.IndiceRefracao).
                    ToList()
            End If

            For Each item In result
                item.IndiceRefracaoAux = item.IndiceRefracao
                item.IndiceRefracao = Math.Round(item.IndiceRefracao, 3, MidpointRounding.AwayFromZero)
            Next

            Return result
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function getDescricaoModelo(ByVal IDModelo As Long) As String
            Return (From x In BDContexto.tbModelos Where x.ID = IDModelo Select x.Descricao).FirstOrDefault()
        End Function

        Public Function AtribuirCodigo() As String
            Return ClsUtilitarios.AtribuirCodigo(BDContexto, "tbModelos")
        End Function
#End Region
    End Class
End Namespace