Imports System.IO
Imports System.Data.Entity
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Drawing.Drawing2D
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.ConstantesKendo
Imports System.Data.SqlClient
Imports F3M.Modelos.BaseDados

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioMarcas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbMarcas, Marcas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMarcas)) As IQueryable(Of Marcas)
            Return query.Select(Function(e) New Marcas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .VariavelContabilidade = e.VariavelContabilidade, .IDSegmentoMarca = e.IDSegmentoMarca,
                .DescricaoSegmentoMarca = If(e.tbSegmentosMarcas Is Nothing, String.Empty, e.tbSegmentosMarcas.Descricao),
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbMarcas)) As IQueryable(Of Marcas)
            Return query.Select(Function(e) New Marcas With {
                .ID = e.ID, .Descricao = e.Descricao
            }).OrderBy(Function(x) x.Descricao)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Marcas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Marcas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbMarcas)
            Dim query As IQueryable(Of tbMarcas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not String.IsNullOrEmpty(filtroTxt) Then
                If filtroTxt.ToLower = "lo" OrElse filtroTxt.ToLower = "lc" Then
                    query = query.Where(Function(w) w.tbModelos.Any(Function(a) a.tbMarcas.Ativo = True AndAlso a.tbTiposArtigos.Codigo = filtroTxt))
                Else
                    query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
                End If
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function

#End Region

#Region "ESCRITA"

        ''' <summary>
        ''' IMPORTA POR OBJETO
        ''' </summary>
        ''' <param name="o"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Public Function Importar(ByVal o As F3M.Importacao) As F3M.Importacao
            Try
                If Upload(o) Then
                    ImportaFicheiro(o)
                    RemoveFicheiro(o)
                End If
                Return o
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Throw ex
            Catch ex As Exception
                Throw
            End Try
        End Function

#End Region

#Region "Funções Auxiliares"

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="modelo"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Private Function Upload(modelo As F3M.Importacao) As Boolean
            Try
                Dim nome = modelo.NomeFicheiro
                Dim extensao As String = "." & modelo.Extensao
                If Not extensao.ToUpper.Equals(".CSV") Then
                    Throw New F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao("O tipo do ficheiro não está correto.")
                End If
                Dim jsonR As New JsonResult
                Dim novoCaminho As String = ClsTexto.ConcatenaStrings(New String() {System.Web.HttpContext.Current.Request.Path, URLs.Importacao, Operadores.Backslash})

                Dim novoCaminhoServidor As String = ClsTexto.ConcatenaStrings(New String() {
                                          HttpContext.Current.Server.MapPath("~/"),
                                          URLs.Importacao,
                                          Operadores.Backslash})

                Dim dataStr As String = DateTime.Now
                Dim novoNome As String = ClsTexto.ConcatenaStrings(New String() {modelo.NomeFicheiro, extensao})

                modelo.NomeFicheiro = novoNome
                modelo.Caminho = novoCaminhoServidor
                modelo.Ativo = True
                modelo.UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                modelo.DataCriacao = dataStr

                ' PARA CRIAR PASTA CASO NAO EXISTA
                If (Not Directory.Exists(novoCaminhoServidor)) Then
                    Directory.CreateDirectory(novoCaminhoServidor)
                End If

                Dim caminho As String = novoCaminhoServidor & modelo.NomeFicheiro
                Dim fileApagar As New FileInfo(caminho)
                If fileApagar.Exists Then
                    fileApagar.Delete()
                End If

                Dim data As Byte()
                Dim fs As New FileStream(novoCaminhoServidor & modelo.NomeFicheiro, FileMode.Create)
                Using fs
                    Using bw As New BinaryWriter(fs)
                        data = Convert.FromBase64String(modelo.strFicheiro)
                        bw.Write(data)
                        bw.Close()
                    End Using
                End Using

                Return True
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Throw ex
            Catch ex As Exception
                Throw
            End Try
        End Function

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="modelo"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Private Function ImportaFicheiro(ByVal modelo As F3M.Importacao) As F3M.Importacao
            Try
                Dim path = System.Web.HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath) & "\Importacao"
                Dim lines() As String = IO.File.ReadAllLines(path & "\" & modelo.NomeFicheiro.ToUpper)
                Dim values() As String = lines(0).Split(";")

                Using context As New Oticas.BD.Dinamica.Aplicacao
                    Dim oMarca = context.tbMarcas.Where(Function(f) f.Descricao.ToUpper.Equals(modelo.NomeFicheiro.Replace(".CSV", String.Empty).ToUpper)).FirstOrDefault
                    If oMarca IsNot Nothing Then
                        If ImportarCSV(context, modelo.NomeFicheiro.Replace(".CSV", String.Empty).ToUpper, path & "\" & modelo.NomeFicheiro.ToUpper, values.Count, oMarca.ID) Then
                            modelo.Estado = "Importado com sucesso!"
                        End If

                    ElseIf modelo.NomeFicheiro.ToLower = "tbmarcas.csv" Then
                        Using rep As New RepositorioClientes
                            rep.Importar(modelo)
                        End Using
                    Else
                        modelo.Estado = "O ficheiro não foi importado porque não existe nenhuma marca " & modelo.NomeFicheiro.Replace(".CSV", String.Empty).ToLower & "."
                    End If
                End Using

                Return modelo
            Catch ex As Exception
                Throw
            End Try
        End Function

        'Private Function ImportaGeral(ByVal modelo As F3M.Importacao) As F3M.Importacao
        '    Try
        '        Dim path = System.Web.HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath) & "\Importacao"
        '        Dim lines() As String = IO.File.ReadAllLines(path & "\" & modelo.NomeFicheiro.ToUpper)
        '        Dim values() As String = lines(0).Split(";")

        '        Using context As New Oticas.BD.Dinamica.Aplicacao
        '            Dim oMarca = context.tbMarcas.Where(Function(f) f.Descricao.ToUpper.Equals(modelo.NomeFicheiro.Replace(".CSV", String.Empty).ToUpper)).FirstOrDefault
        '            If oMarca IsNot Nothing Then
        '                If ImportarGeral(context, modelo.NomeFicheiro.Replace(".CSV", String.Empty).ToUpper, path & "\" & modelo.NomeFicheiro.ToUpper, values) Then
        '                    modelo.Estado = "Importado com sucesso!"
        '                End If

        '            Else
        '                modelo.Estado = "O ficheiro não foi importado porque não existe nenhuma marca " & modelo.NomeFicheiro.Replace(".CSV", String.Empty).ToLower & "."
        '            End If
        '        End Using

        '        Return modelo
        '    Catch ex As Exception
        '        Throw
        '    End Try
        'End Function

        'Public Shared Function ImportarCSV(ByVal BD As DbContext, ByVal strTabela As String, ByVal strFile As String, ByVal Campos() As String) As Boolean
        '    Try

        '        Using transaction As DbContextTransaction = BD.Database.BeginTransaction(IsolationLevel.ReadCommitted)
        '            Try
        '                Dim strCampos As String = String.Empty
        '                Dim strValores As String = String.Empty
        '                Dim strQry As String = String.Empty

        '                Dim intI As Integer

        '                strCampos = ""
        '                strValores = ""
        '                strCamposIns = ""
        '                For intI = 0 To Campos.Count - 1
        '                    If strCampos <> "" Then
        '                        strCampos = strCampos & ", "
        '                    End If
        '                    strCampos = strCampos & Campos(intI) & " nvarchar(1000) null"

        '                    If strValores <> "" Then
        '                        strValores = strValores & ", "
        '                    End If
        '                    strValores = strValores & " isnull( " & Campos(intI) & ",'') "

        '                    If strCamposIns <> "" Then
        '                        strCamposIns = strCamposIns & ", "
        '                    End If
        '                    strCamposIns = strCamposIns & Campos(intI)
        '                Next

        '                strQry = "if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "_1]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "_1] ;create table [tmp" & strTabela & "_1] (" & strCampos & ") bulk insert [tmp" & strTabela & "_1] from '" & strFile & "' with (codepage='ACP', firstrow = 2, fieldterminator=';', rowterminator='\n')"
        '                BD.Database.ExecuteSqlCommand(strQry)

        '                'AVALIAR: importar a tabela de acordo com o modelo EF
        '                'strQry = "select 0 as ID, " & strCamposIns & "  from [tmp" & strTabela & "_1]"
        '                'Dim tb As List(Of tbClientes) = BD.Database.SqlQuery(Of tbClientes)(strQry).ToList
        '                'Dim tb As List(Of Clientes) = BD.Database.SqlQuery(Of Clientes)(strQry).ToList
        '                'For Each reg In tb
        '                '    GravaEntidadeLinha(Of tbClientes)(BD, reg, AcoesFormulario.Adicionar, Nothing)
        '                'Next

        '                Select Case strTabela.ToLower
        '                    Case "tbclientes"
        '                        'campos por defeito
        '                        If Not Campos.Contains("IDTipoEntidade") Then
        '                            strValores = strValores & ", 2, 1, 1, 1, 184, 1, 1, 1, 1, 2, 999, 1, 0, 0, 0, 0, getdate(), 'F3M' "
        '                            strCamposIns = strCamposIns & ", IDTipoEntidade, IDMoeda, IDFormaPagamento, IDCondicaoPagamento, IDPais, IDLoja, IDPrecoSugerido, IDEspacoFiscal, IDRegimeIva, IDIDioma, Prioridade, IDLocalOperacao, Desconto1, Desconto2, Comissao1, Comissao2, DataCriacao, UtilizadorCriacao "
        '                        End If
        '                        'preencher moradas, buscar os ids pelos codigos das tabelas relacionada
        '                        'preencher contactos
        '                End Select

        '                strQry = "insert into [" & strTabela & "](" & strCamposIns & ") select " & strValores & " from [tmp" & strTabela & "_1]"
        '                ClsBaseDados.clsbasedados.ExecutaQueryeDevolveID(BD, strQry)

        '                transaction.Commit()

        '                strQry = "if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "_1]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "_1] "
        '                BD.Database.ExecuteSqlCommand(strQry)

        '                Return True
        '            Catch
        '                transaction.Rollback()
        '                Throw
        '            End Try
        '        End Using
        '    Catch
        '        Throw
        '    End Try
        'End Function


        Public Function LerPrecoVenda(ByVal strTipoArtigo As String,
                                      Optional ByVal lngIDModelo As Long = 0,
                                      Optional ByVal lngIDTratamentoLente As Nullable(Of Long) = 0,
                                      Optional ByVal lngIDCorLente As Nullable(Of Long) = 0,
                                      Optional ByVal Suplementos As String() = Nothing,
                                      Optional ByVal strDiam As String = "",
                                      Optional ByVal dblPotEsf As Double = 0,
                                      Optional ByVal dblPotCil As Double = 0,
                                      Optional ByVal strRaio As String = "",
                                      Optional ByVal strCodigo As String = "",
                                      Optional ByVal lngIDCliente As Long = 0) As Double
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim dblPreco As Double = 0
                Dim dblPrecoSuplemento As Double = 0
                Dim dblPrecoCor As Double = 0
                Dim dblPrecoTratamento As Double = 0
                Dim dblPrecoModelo As Double = 0

                Dim strQry As String = String.Empty
                Dim strQrySup As String = String.Empty
                Dim strQryCor As String = String.Empty
                Dim strCond As String = String.Empty

                Dim dsListaCores = New DataSet
                Dim dsListaSuplementos = New DataSet
                Dim dsListaTratamentos = New DataSet
                Dim dsListaModelos = New DataSet

                Using sqlcon As New SqlConnection(Me.STR_CONEXAO)
                    sqlcon.Open()

                    Select Case UCase(strTipoArtigo)
                        Case "LC"
                            'If strRaio <> "" Then
                            '    strCond = strCond & " and raio=" & ClsUtilitarios.EnvolveSQL(strRaio)
                            'End If

                            If Not IsNothing(dblPotEsf) Then
                                If dblPotCil < 0 Then
                                    strCond = strCond & " and " & (dblPotEsf + dblPotCil).ToString.Replace(",", ".") & " between PotEsfde and PotEsfate "
                                Else
                                    strCond = strCond & " and " & dblPotEsf.ToString.Replace(",", ".") & " between PotEsfde and PotEsfate "
                                End If
                            End If

                            If Not IsNothing(dblPotCil) Then
                                If dblPotCil <> 0 Then
                                    strCond = strCond & " and " & dblPotCil.ToString.Replace(",", ".") & " between Potcilde and Potcilate "
                                End If
                            End If

                            'strQry = "select * from tbprecoslentes where idmodelo=" & lngIDModelo & " and diamde=" & ClsUtilitarios.EnvolveSQL(strDiam) & " " & strCond
                            strQry = "select * from tbprecoslentes where idmodelo=" & lngIDModelo
                        Case "LO"
                            If lngIDCorLente > 0 Then
                                strQryCor = "select precovenda from tbcoreslentes where id=" & lngIDCorLente
                                Using sqlcmdVistas As New SqlCommand(strQryCor, sqlcon)
                                    sqlcmdVistas.CommandType = System.Data.CommandType.Text
                                    adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                                    adapterVistas.Fill(dsListaCores)
                                    If dsListaCores.Tables(0).Rows.Count > 0 Then
                                        Dim row As DataRow
                                        row = dsListaCores.Tables(0).Rows(0)
                                        If row!precovenda.ToString <> "" Then
                                            dblPrecoCor = dblPrecoCor + row!precovenda
                                        End If
                                    Else
                                        dblPrecoCor = 0
                                    End If
                                End Using
                            End If

                            If Not IsNothing(Suplementos) Then
                                For i As Integer = 1 To Suplementos.Count
                                    strQrySup = "select precovenda from tbsuplementoslentes where id=" & Suplementos(i - 1)

                                    Using sqlcmdVistas As New SqlCommand(strQrySup, sqlcon)
                                        sqlcmdVistas.CommandType = System.Data.CommandType.Text
                                        adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                                        dsListaSuplementos = New DataSet
                                        adapterVistas.Fill(dsListaSuplementos)
                                        If dsListaSuplementos.Tables(0).Rows.Count > 0 Then
                                            Dim row As DataRow
                                            row = dsListaSuplementos.Tables(0).Rows(0)
                                            If row!precovenda.ToString <> "" Then
                                                dblPrecoSuplemento += row!precovenda
                                            End If
                                        Else
                                            dblPrecoSuplemento += 0
                                        End If
                                    End Using
                                Next
                            End If

                            If Not IsNothing(dblPotEsf) Then
                                If dblPotCil < 0 Then
                                    strCond = strCond & " and abs(" & (dblPotEsf + dblPotCil).ToString.Replace(",", ".") & ") between PotEsfde and PotEsfate "
                                Else
                                    strCond = strCond & " and abs(" & dblPotEsf.ToString.Replace(",", ".") & ") between PotEsfde and PotEsfate "
                                End If
                            End If

                            If Not IsNothing(dblPotCil) Then
                                strCond = strCond & " and abs(" & dblPotCil.ToString.Replace(",", ".") & ") between Potcilde and Potcilate "
                            End If

                            If lngIDTratamentoLente > 0 Then
                                strQry = "select * from tbprecoslentes where idmodelo=" & lngIDModelo & " and idtratamentolente=" & lngIDTratamentoLente & " and " & ClsUtilitarios.EnvolveSQL(strDiam) & " between diamde and diamate" & strCond
                                Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                                    sqlcmdVistas.CommandType = System.Data.CommandType.Text
                                    adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                                    adapterVistas.Fill(dsListaTratamentos)
                                    If dsListaTratamentos.Tables(0).Rows.Count > 0 Then
                                        Dim row As DataRow
                                        row = dsListaTratamentos.Tables(0).Rows(0)
                                        If row!precovenda.ToString <> "" Then
                                            dblPrecoTratamento = dblPrecoTratamento + row!precovenda
                                        End If
                                    Else
                                        dblPrecoTratamento = 0
                                    End If
                                End Using
                            End If

                            strQry = "select * from tbprecoslentes where idmodelo=" & lngIDModelo & " and idtratamentolente Is null and " & ClsUtilitarios.EnvolveSQL(strDiam) & " between diamde and diamate" & strCond

                        Case Else
                            If lngIDCliente > 0 Then
                                Dim lngIdCodigoPreco As Long = 0
                                lngIdCodigoPreco = BDContexto.tbClientes.Where(Function(f) f.ID = lngIDCliente).FirstOrDefault.IDPrecoSugerido

                                strQry = "select ap.valorcomiva as precovenda from tbArtigosPrecos ap inner join tbartigos a on ap.idartigo=a.id where ap.idcodigopreco=" & lngIdCodigoPreco & " and a.codigo=" & ClsUtilitarios.EnvolveSQL(strCodigo)
                            Else
                                strQry = "select ap.valorcomiva as precovenda from tbArtigosPrecos ap inner join tbartigos a on ap.idartigo=a.id where ap.idcodigopreco=1 and a.codigo=" & ClsUtilitarios.EnvolveSQL(strCodigo)
                            End If
                    End Select

                    Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                        sqlcmdVistas.CommandType = System.Data.CommandType.Text
                        adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                        adapterVistas.Fill(dsListaModelos)
                        If dsListaModelos.Tables(0).Rows.Count > 0 Then
                            Dim row As DataRow
                            row = dsListaModelos.Tables(0).Rows(0)
                            If row!precovenda.ToString <> "" Then
                                dblPrecoModelo = row!precovenda
                            Else
                                dblPrecoModelo = 0
                            End If
                        Else
                            dblPrecoModelo = 0
                        End If
                    End Using

                    If dblPrecoTratamento < 100 Then 'preco tratamento isolado
                        dblPreco = dblPrecoModelo + dblPrecoTratamento
                    ElseIf dblPrecoTratamento > dblPrecoModelo Then
                        dblPreco = dblPrecoTratamento
                    Else
                        dblPreco = dblPrecoModelo
                    End If
                    dblPreco = dblPreco + dblPrecoSuplemento + dblPrecoCor
                    Return dblPreco
                End Using
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Function LerIDArtigo(ByVal strTipoArtigo As String, Optional ByVal lngIDModelo As Nullable(Of Long) = 0, Optional strDescricao As String = "",
                                        Optional ByVal strTamanho As String = "", Optional ByVal strCodCor As String = "", Optional ByVal strHastes As String = "",
                                        Optional ByVal lngIDTratamentoLente As Nullable(Of Long) = 0, Optional ByVal lngIDCorLente As Nullable(Of Long) = 0, Optional strCodigosSuplementos As String = "",
                                        Optional ByVal strDiam As String = "", Optional ByVal dblPotEsf As Double = 0, Optional ByVal dblPotCil As Double = 0,
                                        Optional ByVal dblPotPrism As Double = 0, Optional ByVal dblAdicao As Double = 0, Optional ByVal intEixo As Integer = 0, Optional ByVal strRaio As String = "") As String
            Try
                Dim adapterVistas As SqlDataAdapter

                Dim strQry As String = String.Empty
                Dim strCond As String = String.Empty
                Dim strIdArtigo As String = "0"
                Dim strGraduacao1 As String = String.Empty
                Dim strGraduacao2 As String = String.Empty

                ClsUtilitarios.CodeTrace("REC.log", "Func LerIDArtigo : 1 " & Now.ToString(“HH:mm:ss.fff”))

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(Me.STR_CONEXAO)
                        sqlcon.Open()

                        Select Case UCase(strTipoArtigo)
                            Case "LC"
                                strCond = " where idmodelo=" & ClsUtilitarios.EnvolveSQL(lngIDModelo)

                                If strRaio <> "" Then
                                    strCond = strCond & " and raio=" & ClsUtilitarios.EnvolveSQL(strRaio)
                                End If

                                strCond = strCond & " and adicao=" & dblAdicao.ToString.Replace(",", ".")

                                strGraduacao1 = " and PotenciaEsferica=" & dblPotEsf.ToString.Replace(",", ".")
                                strGraduacao1 = strGraduacao1 & " and PotenciaCilindrica=" & dblPotCil.ToString.Replace(",", ".")

                                strGraduacao2 = " and PotenciaEsferica=" & (dblPotEsf + dblPotCil).ToString.Replace(",", ".")
                                strGraduacao2 = strGraduacao2 & " and PotenciaCilindrica=-(" & dblPotCil.ToString.Replace(",", ".") & ")"

                                If Not IsNothing(intEixo) Then
                                    strCond = strCond & " and eixo=" & intEixo
                                End If

                                If Not IsNothing(strDiam) Then
                                    strCond = strCond & " and diametro=" & ClsUtilitarios.EnvolveSQL(strDiam)
                                End If

                                strQry = "select idartigo from tblentescontato with (nolock) " & strCond & strGraduacao1 &
                                        " union select idartigo from tblentescontato with (nolock) " & strCond & strGraduacao2

                            Case "LO"
                                strCond = " where idmodelo = " & ClsUtilitarios.EnvolveSQL(lngIDModelo)

                                If lngIDCorLente > 0 Then
                                    strCond = strCond & " and IDCorLente=" & lngIDCorLente
                                End If

                                If lngIDTratamentoLente = 0 OrElse lngIDTratamentoLente Is Nothing Then
                                    strCond = strCond & " and IDTratamentoLente is null "
                                Else
                                    strCond = strCond & " and IDTratamentoLente=" & lngIDTratamentoLente
                                End If

                                If strCodigosSuplementos = "0" Then
                                    strCond = strCond & " and codigossuplementos=''"
                                Else
                                    strCond = strCond & " and codigossuplementos=" & ClsUtilitarios.EnvolveSQL(strCodigosSuplementos)
                                End If

                                If Not IsNothing(strDiam) Then
                                    strCond = strCond & " and diametro=" & ClsUtilitarios.EnvolveSQL(strDiam)
                                End If

                                If Not IsNothing(dblPotPrism) Then
                                    strCond = strCond & " and PotenciaPrismatica=" & dblPotPrism.ToString.Replace(",", ".")
                                End If

                                strCond = strCond & " and adicao=" & dblAdicao.ToString.Replace(",", ".")

                                strGraduacao1 = " and PotenciaEsferica=" & dblPotEsf.ToString.Replace(",", ".")
                                strGraduacao1 = strGraduacao1 & " and PotenciaCilindrica=" & dblPotCil.ToString.Replace(",", ".")

                                strGraduacao2 = " and PotenciaEsferica=" & (dblPotEsf + dblPotCil).ToString.Replace(",", ".")
                                strGraduacao2 = strGraduacao2 & " and PotenciaCilindrica=-(" & dblPotCil.ToString.Replace(",", ".") & ")"

                                strQry = "select idartigo from tblentesoftalmicas with (nolock) " & strCond & strGraduacao1 &
                                        " union select idartigo from tblentesoftalmicas with (nolock) " & strCond & strGraduacao2

                            Case "AR"
                                strQry = "select a.id as idartigo from tbartigos a with (nolock) inner join tbaros ar with (nolock) on a.id=ar.IDArtigo inner join tbModelos m with (nolock) on ar.IDModelo=m.id where m.codigo=" & ClsUtilitarios.EnvolveSQL(lngIDModelo) & " and ar.CodigoCor=" & ClsUtilitarios.EnvolveSQL(strCodCor) &
                                            " and ar.Tamanho=" & ClsUtilitarios.EnvolveSQL(strTamanho) & " and ar.Hastes=" & ClsUtilitarios.EnvolveSQL(strHastes)
                            Case "OS"
                                strQry = "select a.id as idartigo from tbartigos a with (nolock) inner join tboculossol ar with (nolock) on a.id=ar.IDArtigo inner join tbModelos m with (nolock) on ar.IDModelo=m.id where m.codigo=" & ClsUtilitarios.EnvolveSQL(lngIDModelo) & " and ar.CodigoCor=" & ClsUtilitarios.EnvolveSQL(strCodCor) &
                                            " and ar.Tamanho=" & ClsUtilitarios.EnvolveSQL(strTamanho) & " and ar.Hastes=" & ClsUtilitarios.EnvolveSQL(strHastes)
                            Case Else
                                strQry = "select a.id as idartigo from tbartigos a with (nolock) inner join tbtiposartigos ta with (nolock) on a.idtipoartigo=ta.id where ta.codigo=" & ClsUtilitarios.EnvolveSQL(strTipoArtigo) & " and a.descricao=" & ClsUtilitarios.EnvolveSQL(strDescricao)
                        End Select

                        ClsUtilitarios.CodeTrace("REC.log", "Func LerIDArtigo : 2 " & Now.ToString(“HH:mm:ss.fff”))

                        Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            If dsListaVistas.Tables(0).Rows.Count > 0 Then
                                Dim row As DataRow
                                row = dsListaVistas.Tables(0).Rows(0)
                                If row!idartigo.ToString <> "" Then
                                    strIdArtigo = row!idartigo
                                End If
                            End If
                        End Using

                        ClsUtilitarios.CodeTrace("REC.log", "Func LerIDArtigo : 3 " & Now.ToString(“HH:mm:ss.fff”))

                        Return strIdArtigo
                    End Using
                End Using
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Function AtribuirCodigo(ByVal intModo As Integer, ByVal strTipoArtigo As String) As String
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim strCond As String = String.Empty
                Dim strQry As String = String.Empty
                Dim strCodigo As String = "1"
                Dim intTam As Integer = 3

                Select Case intModo
                    Case 1
                        If strTipoArtigo IsNot Nothing AndAlso strTipoArtigo.Length > 2 Then
                            intTam = strTipoArtigo.Length + 1
                        End If

                        Using dsListaVistas As New DataSet
                            Using sqlcon As New SqlConnection(Me.STR_CONEXAO)
                                sqlcon.Open()
                                strQry = "select max(cast(substring(a.codigo," & intTam & ",10) as bigint)) as codigo from tbartigos a inner join tbtiposartigos ta on a.idtipoartigo=ta.id " &
                                        "inner join tbSistemaClassificacoesTiposArtigos sta on ta.idsistemaclassificacao=sta.id " &
                                        "where ta.codigo like '%" & strTipoArtigo & "%' and substring(a.codigo," & intTam & ",10) not like '%[^0-9]%'"

                                Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                                    sqlcmdVistas.CommandType = System.Data.CommandType.Text
                                    adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                                    adapterVistas.Fill(dsListaVistas)
                                    If dsListaVistas.Tables(0).Rows.Count > 0 Then
                                        Dim row As DataRow
                                        row = dsListaVistas.Tables(0).Rows(0)
                                        If row!codigo.ToString <> "" Then
                                            strCodigo = row!codigo + 1
                                        End If
                                    End If
                                End Using
                            End Using
                            Return strTipoArtigo & strCodigo
                        End Using
                    Case Else
                        Return strTipoArtigo & strCodigo
                End Select
            Catch ex As Exception
                Throw
            End Try
        End Function

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="modelo"></param>
        ''' <remarks></remarks>
        Public Sub RemoveFicheiro(ByVal modelo As F3M.Importacao)
            Try
                Dim novoCaminhoServidor As String = ClsTexto.ConcatenaStrings(New String() {
                                          HttpContext.Current.Server.MapPath("~/"),
                                          URLs.Importacao,
                                          Operadores.Backslash})

                Dim caminho As String = novoCaminhoServidor & modelo.NomeFicheiro
                Dim fileApagar As New FileInfo(caminho)
                If fileApagar.Exists Then
                    fileApagar.Delete()
                End If
            Catch ex As Exception
            End Try
        End Sub

        Public Function getDescricaoMarca(ByVal IDMarca As Long) As String
            Return (From x In BDContexto.tbMarcas Where x.ID = IDMarca Select x.Descricao).FirstOrDefault()
        End Function

        Public Function ProximoCodigo() As String
            Try
                Return ClsUtilitarios.AtribuirCodigo(BDContexto, "tbmarcas")
            Catch
                Throw
            End Try
        End Function

#End Region

#Region "DATAIMPORT"

        ''' <summary>
        ''' Função para importação de ficheiro .csv
        ''' </summary>
        ''' <param name="BD"></param>
        ''' <param name="strTabela"></param>
        ''' <param name="strFile"></param>
        ''' <param name="intNumCampos"></param>
        ''' <remarks></remarks>
        Public Shared Function ImportarCSV(ByVal BD As DbContext, ByVal strTabela As String, ByVal strFile As String, ByVal intNumCampos As Integer, ByVal lngIDMarca As Long) As Boolean
            Try
                Dim blnAtualiza As Boolean

                If ClsF3MSessao.RetornaUtilizadorNome <> "F3M" Then
                    Return True
                End If

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : A " & Now.ToString(“HH:mm:ss.fff”))

                Dim strCampos As String = String.Empty
                Dim strQry As String = String.Empty

                Dim intI As Integer
                Dim intRes As Integer
                Dim intProtocolo As Integer

                strCampos = ""
                For intI = 1 To intNumCampos
                    If strCampos <> "" Then
                        strCampos = strCampos & ", "
                    End If
                    strCampos = strCampos & "c" & intI & " nvarchar(1000) "
                Next

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : B " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "If exists(Select * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "] ; create table [tmp" & strTabela & "] (id int identity(1,1), constraint [pk_tmp" & strTabela & "] primary key (id), tipo nvarchar(10) collate Latin1_General_CI_AS  not null, codforn nvarchar(100) collate Latin1_General_CI_AS not null, descricao nvarchar(100) collate Latin1_General_CI_AS not null, materia nvarchar(10) collate Latin1_General_CI_AS not null, tipolente nvarchar(10) collate Latin1_General_CI_AS not null, indice real not null, foto smallint not null, superficie smallint not null, gama smallint not null, cor smallint not null, diam_de nvarchar(10) collate Latin1_General_CI_AS not null, diam_ate nvarchar(10) collate Latin1_General_CI_AS not null, cil_de real not null, cil_ate real not null, esf_de real not null, esf_ate real not null, adi_de real not null, adi_ate real not null, raio nvarchar(1000) collate Latin1_General_CI_AS not null, preco money not null, precocusto money not null, modeloforn nvarchar(50) null, referencia nvarchar(50) null, codcor nvarchar(50) null, codtratamento nvarchar(50) null, codinstrucao nvarchar(50) null, requerido smallint null)"
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : C " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "_1]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "_1] ;create table [tmp" & strTabela & "_1] (" & strCampos & ") bulk insert [tmp" & strTabela & "_1] from '" & strFile & "' with (codepage='ACP', fieldterminator=';', rowterminator='\n')"
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : D " & intNumCampos.ToString & " " & Now.ToString(“HH:mm:ss.fff”))

                Select Case intNumCampos
                    Case 21
                        strQry = "insert into [tmp" & strTabela & "] (tipo,codforn,descricao,materia,tipolente,indice,foto,superficie,gama,cor,diam_de,diam_ate,cil_de,cil_ate,esf_de,esf_ate,adi_de,adi_ate,raio,preco,precocusto) " &
                                        "select isnull(c1,''), isnull(c2,''), isnull(c3,''), isnull(c4,1), isnull(c5,1), isnull(c6,1.500), isnull(c7,0), isnull(c8,0), isnull(c9,0), isnull(c10,0), isnull(c11,65), isnull(c12,80), isnull(replace(c13,',','.'),0), isnull(c14,30), isnull(c15,0), isnull(c16,30), isnull(c17,0), isnull(c18,30), isnull(c19,'0'), c20, c21  from [tmp" & strTabela & "_1] where 1=1 "
                        BD.Database.ExecuteSqlCommand(strQry)
                        intProtocolo = 1
                    Case 26
                        strQry = "insert into [tmp" & strTabela & "] (tipo,codforn,descricao,materia,tipolente,indice,foto,superficie,gama,cor,diam_de,diam_ate,cil_de,cil_ate,esf_de,esf_ate,adi_de,adi_ate,raio,preco,precocusto, modeloforn, referencia, codcor, codtratamento, codinstrucao) " &
                                            "select isnull(c1,''), isnull(c2,''), isnull(c3,''), isnull(c4,1), isnull(c5,1), isnull(c6,1.500), isnull(c7,0), isnull(c8,0), isnull(c9,0), isnull(c10,0), isnull(c11,65), isnull(c12,80), isnull(replace(c13,',','.'),0), isnull(c14,30), isnull(c15,0), isnull(c16,30), isnull(c17,0), isnull(c18,30), isnull(c19,'0'), c20, c21, isnull(c22,''), isnull(c23,''), isnull(c24,''), isnull(c25,''), isnull(c26,'') from [tmp" & strTabela & "_1]   where 1=1 "
                        BD.Database.ExecuteSqlCommand(strQry)
                        intProtocolo = 2
                    Case 27
                        strQry = "insert into [tmp" & strTabela & "] (tipo,codforn,descricao,materia,tipolente,indice,foto,superficie,gama,cor,diam_de,diam_ate,cil_de,cil_ate,esf_de,esf_ate,adi_de,adi_ate,raio,preco,precocusto, modeloforn, referencia, codcor, codtratamento, codinstrucao, requerido) " &
                                            "select isnull(c1,''), isnull(c2,''), isnull(c3,''), isnull(c4,1), isnull(c5,1), isnull(c6,1.500), isnull(c7,0), isnull(c8,0), isnull(c9,0), isnull(c10,0), isnull(c11,65), isnull(c12,80), isnull(replace(c13,',','.'),0), isnull(c14,30), isnull(c15,0), isnull(c16,30), isnull(c17,0), isnull(c18,30), isnull(c19,'0'), c20, c21, isnull(c22,''), isnull(c23,''), isnull(c24,''), isnull(c25,''), isnull(c26,''), isnull(c27,'')  from [tmp" & strTabela & "_1]   where 1=1 "
                        BD.Database.ExecuteSqlCommand(strQry)
                        intProtocolo = 3
                End Select

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : E " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "update [tmp" & strTabela & "] set materia=1 where isnumeric(materia)=0"
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : F " & Now.ToString(“HH:mm:ss.fff”))

                Dim lngIDTipoArtigo As Long
                intRes = ValidarDadosFicheiro(ClsBaseDados.RetornaConnectionString(BD), "tmp" & strTabela, strTabela, lngIDMarca, blnAtualiza, lngIDTipoArtigo)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : G " & Now.ToString(“HH:mm:ss.fff”))

                Dim lngRes As Long? = BD.Database.SqlQuery(Of Long?)("select top 1 cast(id as bigint) from tbModelos with (nolock) where idmarca=" & lngIDMarca & " and convert(nvarchar(10), DataCriacao, 105) = convert(nvarchar(10), getdate(), 105 ) and UtilizadorCriacao='F3M'").FirstOrDefault()
                If Not lngRes Is Nothing AndAlso lngRes > 0 Then
                    ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : H " & Now.ToString(“HH:mm:ss.fff”))
                    Throw New Exception("Atualização do catálogo em curso, aguarde por favor!")
                End If

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : IA " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "update b Set b.Ativo=0, b.codforn ='', b.modeloforn='' from tbmarcas a inner join tbmodelos b on a.id=b.idmarca where b.IDTipoArtigo=1 and a.descricao='" & strTabela & "'"
                BD.Database.ExecuteSqlCommand(strQry)
                strQry = "update b Set b.Ativo=0, b.codforn ='', b.modeloforn='' from tbmarcas a inner join tbTratamentosLentes b on a.id=b.idmarca where a.descricao='" & strTabela & "'"
                BD.Database.ExecuteSqlCommand(strQry)
                strQry = "update b Set b.Ativo=0, b.codforn ='', b.modeloforn='' from tbmarcas a inner join tbSuplementosLentes b on a.id=b.idmarca where a.descricao='" & strTabela & "'"
                BD.Database.ExecuteSqlCommand(strQry)
                strQry = "update b Set b.Ativo=0, b.codforn ='', b.modeloforn='' from tbmarcas a inner join tbCoresLentes b on a.id=b.idmarca where a.descricao='" & strTabela & "'"
                BD.Database.ExecuteSqlCommand(strQry)

                intRes = ImportarModelos(BD, "tmp" & strTabela, lngIDMarca, blnAtualiza, intProtocolo, lngIDTipoArtigo)

                If lngIDTipoArtigo = 1 Then
                    strQry = "update tbTratamentosLentes set ativo=0 where Idmarca=" & lngIDMarca
                    BD.Database.ExecuteSqlCommand(strQry)

                    ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : J " & Now.ToString(“HH:mm:ss.fff”))

                    intRes = ImportarTratamentos(BD, "tmp" & strTabela, lngIDMarca, blnAtualiza, intProtocolo)

                    strQry = "update tbSuplementosLentes set ativo=0 where Idmarca=" & lngIDMarca
                    BD.Database.ExecuteSqlCommand(strQry)

                    ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : K " & Now.ToString(“HH:mm:ss.fff”))
                    intRes = ImportarSuplementos(BD, "tmp" & strTabela, lngIDMarca, blnAtualiza, intProtocolo)

                    strQry = "update tbCoresLentes set ativo=0 where Idmarca=" & lngIDMarca
                    BD.Database.ExecuteSqlCommand(strQry)

                    ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : L " & Now.ToString(“HH:mm:ss.fff”))

                    intRes = ImportarCores(BD, "tmp" & strTabela, lngIDMarca, blnAtualiza, intProtocolo)
                End If

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : M " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "update b set b.ativo=0 from tbmodelos b inner join 
                            (select distinct isnull(a.atual,0) as actual,l.ativo, l.idmodelo, o.Descricao from tbArtigosStock a inner join tbLentesOftalmicas l on a.IDArtigo=l.IDArtigo 
                            inner join tbModelos o on l.IDModelo=o.id  inner join tbmarcas m on o.idmarca=m.id
                            where isnull(a.atual,0)>0 and m.Descricao='" & strTabela & "' and o.IDTipoArtigo=1) a on b.Descricao=a.Descricao "
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : N " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "update b set b.ativo=1 from tbmodelos b inner join 
                            (select distinct isnull(a.atual,0) as actual,l.ativo, l.idmodelo, o.Descricao from tbArtigosStock a inner join tbLentesOftalmicas l on a.IDArtigo=l.IDArtigo 
                            inner join tbModelos o on l.IDModelo=o.id inner join tbmarcas m on o.idmarca=m.id
                            where isnull(a.atual,0)>0 and m.Descricao='" & strTabela & "' and o.IDTipoArtigo=1) a on b.id=a.IDModelo"
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : O " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "update s set s.IDTipoLente=m.IDTipoLente from tbSuplementosLentes s inner join tbmodelos m on s.IDModelo=m.id where m.idmarca=" & lngIDMarca & " and s.IDTipoLente<>m.IDTipoLente"
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : P " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "update s set s.IDTipoLente=m.IDTipoLente from tbCoresLentes s inner join tbmodelos m on s.IDModelo=m.id where m.idmarca=" & lngIDMarca & " and s.IDTipoLente<>m.IDTipoLente"
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : Q " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "update m set m.indicerefracao=convert(money, m.indicerefracao) from tbmodelos m where m.idmarca=" & lngIDMarca
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : R " & Now.ToString(“HH:mm:ss.fff”))

                strQry = "if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "] "
                BD.Database.ExecuteSqlCommand(strQry)

                strQry = "if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "_1]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "_1] "
                BD.Database.ExecuteSqlCommand(strQry)

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : S " & Now.ToString(“HH:mm:ss.fff”))

                Return True

            Catch ex As Exception
                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : Z " & Now.ToString(“HH:mm:ss.fff”))
                Return True
            End Try
        End Function

        ''' <summary>
        ''' Função de validacao de dados do ficheiro
        ''' </summary>
        ''' <param name="strConnStr"></param>
        ''' <param name="strTabela"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Public Shared Function ValidarDadosFicheiro(strConnStr As String, ByVal strTabela As String, ByVal strMarca As String, ByVal lngIDMarca As Long, ByRef blnAtualiza As Boolean, ByRef lngIDTipoArtigo As Long) As Integer
            Try
                Dim intRes As Integer
                Dim adapterVistas As SqlDataAdapter

                blnAtualiza = False

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()
                        Using sqlcmdVistas As New SqlCommand("select min(isnull(id,0)) as lngid from " & strTabela, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            intRes = dsListaVistas.Tables(0).Rows.Count = 0
                        End Using

                        If intRes > 0 Then
                            Return 1
                            Exit Function
                        End If

                        Using sqlcmdVistas As New SqlCommand("select id from " & strTabela & " where tipo not in ('1', '2', '3', '4', '5', '6') ", sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            intRes = dsListaVistas.Tables(0).Rows.Count > 0
                        End Using

                        If intRes > 0 Then
                            Return 2
                            Exit Function
                        End If

                        Using sqlcmdVistas As New SqlCommand("select id from " & strTabela & " where tipo='1'", sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            If dsListaVistas.Tables(0).Rows.Count > 1 Then
                                lngIDTipoArtigo = 1 'LO
                            Else
                                lngIDTipoArtigo = 3 'LC
                            End If
                        End Using

                        Using sqlcmdVistas As New SqlCommand("select id from " & strTabela & " where tipo not in ('1', '2', '3', '4', '5', '6') ", sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            intRes = dsListaVistas.Tables(0).Rows.Count > 0
                        End Using

                        If intRes > 0 Then
                            Return 2
                            Exit Function
                        End If

                        Using sqlcmdVistas As New SqlCommand("select id from " & strTabela & " where isnull(descricao,'')='' or isnull(codforn,'')='' ", sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            intRes = dsListaVistas.Tables(0).Rows.Count > 0
                        End Using

                        If intRes > 0 Then
                            Return 3
                            Exit Function
                        End If

                        Using sqlcmdVistas As New SqlCommand("select codforn from " & strTabela & " where tipo='1' and diam_de>diam_ate or cil_de>cil_ate or esf_de>esf_ate or adi_de>adi_ate ", sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            intRes = dsListaVistas.Tables(0).Rows.Count > 0
                        End Using

                        If intRes > 0 Then
                            Return 4
                            Exit Function
                        End If

                        Using sqlcmdVistas As New SqlCommand("select codforn from " & strTabela & " where tipo='1' group by tipo,codforn,diam_de,diam_ate,cil_de,cil_ate,esf_de,esf_ate,adi_de,adi_ate,raio having count(id)>1", sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            intRes = dsListaVistas.Tables(0).Rows.Count > 0
                        End Using

                        If intRes > 0 Then
                            Return 5
                            Exit Function
                        End If

                        Using sqlcmdVistas As New SqlCommand("select * from tbmarcas where descricao='" & strMarca & "'", sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            If dsListaVistas.Tables(0).Rows.Count > 0 Then
                                Dim row As DataRow
                                row = dsListaVistas.Tables(0).Rows(0)
                                If row!atualizaprecos.ToString = "" Then
                                    blnAtualiza = True
                                Else
                                    blnAtualiza = row!atualizaprecos
                                End If
                            End If
                        End Using

                        Return 0
                    End Using
                End Using
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Shared Function ImportarModelos(ByVal BD As DbContext, ByVal strTmpRef As String, ByVal lngIDMarca As Long, ByVal blnActualizaPrecos As Boolean, ByVal intProtocolo As Integer, ByVal lngIDTipoArtigo As Long)
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim adModelo As SqlDataAdapter

                Dim rowTmp As DataRow
                Dim rowMod As DataRow

                Dim strConnStr As String
                Dim strDescricao As String
                Dim strCodMateria As String
                Dim strTipoLente As String
                Dim strCodForn As String
                Dim strQry As String
                Dim strModeloForn As String
                Dim strReferencia As String
                Dim strAct As String
                Dim strCodCor As String
                Dim strCodTratamento As String
                Dim strCodInstrucao As String
                Dim strValues As String
                Dim strInsert As String
                Dim strObservacoes As String

                Dim dblIndice As Double

                Dim lngID As Long
                Dim lngCodigo As Long
                Dim lngIdTipoLente As Long
                Dim lngIdMateriaLente As Long
                Dim lngIdSuperficieLente As Long
                Dim strTipo As String

                Dim intTipoFoto As Integer
                Dim intTipoSup As Integer
                Dim intStock As Integer

                Dim intRes As Integer

                intRes = 0
                Select Case lngIDTipoArtigo
                    Case 3
                        strTipo = "3"
                    Case Else
                        strTipo = "1"
                End Select

                strConnStr = ClsBaseDados.RetornaConnectionString(BD)

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()
                        strQry = "select distinct codforn, descricao, materia, tipolente, indice, foto, superficie, gama, modeloforn, referencia, codcor, codtratamento, codinstrucao from " & strTmpRef & " where tipo='" & strTipo & "' "
                        Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            For inti = 0 To dsListaVistas.Tables(0).Rows.Count - 1
                                rowTmp = dsListaVistas.Tables(0).Rows(inti)
                                With rowTmp
                                    strCodForn = !CodForn
                                    strDescricao = Left(Trim(!Descricao), 50)
                                    strCodMateria = !materia
                                    strTipoLente = !TipoLente
                                    dblIndice = !indice
                                    intTipoFoto = !Foto
                                    If intTipoSup = 2 Then
                                    Else
                                        intTipoSup = !Superficie + 1
                                    End If
                                    intStock = !gama
                                    strDescricao = Replace(strDescricao, "Ã¡", "a")
                                    strModeloForn = !Modeloforn.ToString
                                    strReferencia = !REFERENCIA.ToString
                                    strCodCor = !Codcor.ToString
                                    strCodTratamento = !CodTratamento.ToString
                                    strCodInstrucao = !Codinstrucao.ToString
                                    strObservacoes = ""

                                    strQry = "select * from tbmodelos where IDMarca=" & lngIDMarca & " and codforn=" & ClsUtilitarios.EnvolveSQL(strCodForn)
                                    If Trim(strModeloForn) <> "" Then
                                        strQry = strQry & " and modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn)
                                    End If

                                    Using dsModelo As New DataSet
                                        Using sqlcmdModelo As New SqlCommand(strQry, sqlcon)
                                            sqlcmdModelo.CommandType = System.Data.CommandType.Text
                                            adModelo = New SqlDataAdapter(sqlcmdModelo)
                                            adModelo.Fill(dsModelo)
                                            If dsModelo.Tables(0).Rows.Count = 0 Then
                                                lngCodigo = ProximoCodigo(strConnStr, "tbmodelos", "codigo")
                                                With rowTmp
                                                    strCodForn = !CodForn
                                                    lngIdTipoLente = strTipoLente
                                                    lngIdMateriaLente = strCodMateria
                                                    lngIdSuperficieLente = intTipoSup

                                                    strModeloForn = !Modeloforn.ToString
                                                    strReferencia = !REFERENCIA.ToString
                                                    strCodCor = !Codcor.ToString
                                                    strCodTratamento = !CodTratamento.ToString
                                                    strCodInstrucao = !Codinstrucao.ToString
                                                    strInsert = " insert into tbmodelos (ativo, codforn, modeloforn, codigo, idtipoartigo, idmarca, idtipolente, idmaterialente, idsuperficielente, descricao, stock, fotocromatica, indicerefracao, referencia, codcor, codtratamento, codinstrucao, observacoes, datacriacao, utilizadorcriacao) "
                                                    strValues = " values (1, " & ClsUtilitarios.EnvolveSQL(strCodForn) & "," & ClsUtilitarios.EnvolveSQL(strModeloForn) & "," & lngCodigo & "," & lngIDTipoArtigo & "," & lngIDMarca & ", " & lngIdTipoLente & ", " & lngIdMateriaLente & ", " & lngIdSuperficieLente & "," & ClsUtilitarios.EnvolveSQL(strDescricao) & "," & intStock & "," & intTipoFoto & ",replace('" & dblIndice & "', ',', '.') ," & ClsUtilitarios.EnvolveSQL(strReferencia) & "," & ClsUtilitarios.EnvolveSQL(strCodCor) & "," & ClsUtilitarios.EnvolveSQL(strCodTratamento) & "," & ClsUtilitarios.EnvolveSQL(strCodInstrucao) & "," & ClsUtilitarios.EnvolveSQL(strObservacoes) & ", getdate(), '" & ClsF3MSessao.RetornaUtilizadorNome & "') ; select id from tbmodelos where id=SCOPE_IDENTITY() ; "
                                                    strQry = strInsert & strValues
                                                    lngID = ClsBaseDados.ExecutaQueryeDevolveID(BD, strQry)
                                                End With
                                            Else
                                                rowMod = dsModelo.Tables(0).Rows(0)
                                                With rowMod
                                                    lngID = !id
                                                    lngIdTipoLente = !idtipolente
                                                    lngIdMateriaLente = !idmaterialente
                                                    lngIdSuperficieLente = !idsuperficielente

                                                    strModeloForn = !Modeloforn.ToString
                                                    strReferencia = !REFERENCIA.ToString
                                                    strCodCor = !Codcor.ToString
                                                    strCodTratamento = !CodTratamento.ToString
                                                    strCodInstrucao = !Codinstrucao.ToString

                                                    strAct = ", indicerefracao=replace('" & dblIndice & "',',','.'), IdTipoLente =" & lngIdTipoLente & ", IdMateriaLente=" & lngIdMateriaLente & ", IdSuperficieLente=" & lngIdSuperficieLente & ", referencia=" & ClsUtilitarios.EnvolveSQL(strReferencia) & ", modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn) &
                                                                ", codcor=" & ClsUtilitarios.EnvolveSQL(strCodCor) & ", codtratamento=" & ClsUtilitarios.EnvolveSQL(strCodTratamento) & ", codinstrucao=" & ClsUtilitarios.EnvolveSQL(strCodInstrucao)

                                                    strQry = "update tbmodelos set descricao=" & ClsUtilitarios.EnvolveSQL(strDescricao) & ", ativo=1, stock=" & intStock & strAct & " where id=" & lngID
                                                    BD.Database.ExecuteSqlCommand(strQry)
                                                End With
                                            End If

                                            If blnActualizaPrecos Then
                                                ApagarPrecos(BD, lngID)
                                                AdicionarPrecos(BD, strTmpRef, strCodForn, lngID, 0, lngIDTipoArtigo, "")
                                            End If
                                            'ApagarGamas(BD, lngID)
                                            'AdicionarGamas(BD, strTmpRef, lngIDTipoArtigo, lngID, strModeloForn, strCodForn)

                                            ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Modelo " & strModeloForn & " " & strCodForn & " " & Now.ToString(“HH:mm:ss.fff”))
                                        End Using
                                    End Using
                                End With
                            Next
                        End Using
                    End Using
                End Using
                Return 0
            Catch
                Throw
            End Try
        End Function

        Public Shared Function ImportarTratamentos(ByVal BD As DbContext, ByVal strTmpRef As String, ByVal lngIDMarca As Long, ByVal blnActualizaPrecos As Boolean, ByVal intProtocolo As Integer)
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim adModelo As SqlDataAdapter

                Dim rowTmp As DataRow
                Dim rowMod As DataRow

                Dim strConnStr As String = ClsBaseDados.RetornaConnectionString(BD)
                Dim strDescricao As String
                Dim strCodForn As String
                Dim strQry As String
                Dim strModeloForn As String
                Dim strReferencia As String
                Dim strValues As String
                Dim strInsert As String
                Dim strObservacoes As String

                Dim dblPrecoVenda As Double
                Dim dblPrecoCusto As Double

                Dim lngIDModelo As Long
                Dim lngID As Long
                Dim lngCodigo As Long
                Dim lngIdTipoLente As Long
                Dim lngIdMateriaLente As Long

                Dim intRes As Integer
                Dim IntCor As Integer

                intRes = 0

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Tratamentos Inicio " & Now.ToString(“HH:mm:ss.fff”))

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()
                        strQry = "select distinct tipo, codforn, descricao, materia, tipolente, cor, preco, precocusto, modeloforn, referencia from " & strTmpRef & " where tipo='5' order by tipo "
                        Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)

                            For inti = 0 To dsListaVistas.Tables(0).Rows.Count - 1
                                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Tratamentos " & inti.ToString)

                                rowTmp = dsListaVistas.Tables(0).Rows(inti)
                                With rowTmp
                                    strCodForn = !CodForn.ToString
                                    strModeloForn = !Modeloforn.ToString

                                    If strModeloForn = "" Then
                                        lngIDModelo = 0
                                    Else
                                        LerModelo(strConnStr, strModeloForn, lngIDModelo, lngIdMateriaLente, lngIdTipoLente, lngIDMarca)
                                    End If

                                    lngIdTipoLente = !tipolente
                                    lngIdMateriaLente = !materia

                                    strDescricao = Left(Trim(!Descricao), 50)
                                    strDescricao = Replace(strDescricao, "Ã¡", "a")
                                    strReferencia = !REFERENCIA.ToString
                                    IntCor = !cor
                                    dblPrecoVenda = !Preco
                                    dblPrecoCusto = !PrecoCusto
                                    strObservacoes = ""

                                    ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Tratamentos Inicio " & strCodForn & " " & strModeloForn & " " & Now.ToString(“HH:mm:ss.fff”))

                                    strQry = "select * from tbTratamentosLentes where IDMarca=" & lngIDMarca & " and IDModelo=" & lngIDModelo & " and codforn=" & ClsUtilitarios.EnvolveSQL(strCodForn) & " and modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn)
                                    Using dsModelo As New DataSet
                                        Using sqlcmdModelo As New SqlCommand(strQry, sqlcon)
                                            sqlcmdModelo.CommandType = System.Data.CommandType.Text
                                            adModelo = New SqlDataAdapter(sqlcmdModelo)
                                            adModelo.Fill(dsModelo)
                                            If dsModelo.Tables(0).Rows.Count = 0 Then
                                                lngCodigo = ProximoCodigo(strConnStr, "tbTratamentosLentes", "codigo")
                                                With rowTmp
                                                    strInsert = " insert into tbTratamentosLentes (ativo, codforn, codigo, cor, idmarca, idmodelo, descricao, modeloforn, referencia, observacoes, datacriacao, utilizadorcriacao)"
                                                    strValues = " values (1, " & ClsUtilitarios.EnvolveSQL(strCodForn) & "," & lngCodigo & "," & IntCor & "," & lngIDMarca & ", " & lngIDModelo & ", " & ClsUtilitarios.EnvolveSQL(strDescricao) & "," & ClsUtilitarios.EnvolveSQL(strModeloForn) & "," & ClsUtilitarios.EnvolveSQL(strReferencia) & "," & ClsUtilitarios.EnvolveSQL(strObservacoes) & ", getdate(), '" & ClsF3MSessao.RetornaUtilizadorNome & "') ; select id from tbTratamentosLentes where id=SCOPE_IDENTITY() ; "
                                                    strQry = strInsert & strValues
                                                    lngID = ClsBaseDados.ExecutaQueryeDevolveID(BD, strQry)
                                                End With
                                            Else
                                                rowMod = dsModelo.Tables(0).Rows(0)
                                                With rowMod
                                                    lngID = !id
                                                    lngIDModelo = !idmodelo
                                                    strModeloForn = !Modeloforn.ToString
                                                    strReferencia = !REFERENCIA.ToString
                                                    IntCor = !cor

                                                    strQry = "update tbTratamentosLentes set descricao=" & ClsUtilitarios.EnvolveSQL(strDescricao) & ", cor=" & IntCor & ", ativo=1, referencia=" & ClsUtilitarios.EnvolveSQL(strReferencia) & ", modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn) & " where Id=" & lngID
                                                    BD.Database.ExecuteSqlCommand(strQry)
                                                End With
                                            End If

                                            If blnActualizaPrecos Then
                                                AdicionarPrecos(BD, strTmpRef, strCodForn, lngIDModelo, lngID, 0, strModeloForn)
                                            End If

                                            ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Tratamentos Fim " & strCodForn & " " & strModeloForn & " " & Now.ToString(“HH:mm:ss.fff”))
                                        End Using
                                    End Using
                                End With
                            Next
                        End Using
                    End Using
                End Using

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV : Tratamentos Fim " & Now.ToString(“HH:mm:ss.fff”))
                Return 0
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Shared Function ImportarSuplementos(ByVal BD As DbContext, ByVal strTmpRef As String, ByVal lngIDMarca As Long, ByVal blnActualizaPrecos As Boolean, ByVal intProtocolo As Integer)
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim adModelo As SqlDataAdapter

                Dim rowTmp As DataRow
                Dim rowMod As DataRow

                Dim strConnStr As String = ClsBaseDados.RetornaConnectionString(BD)
                Dim strDescricao As String
                Dim strCodForn As String
                Dim strQry As String
                Dim strModeloForn As String
                Dim strReferencia As String
                Dim strValues As String
                Dim strInsert As String
                Dim strObservacoes As String

                Dim dblPrecoVenda As Double
                Dim dblPrecoCusto As Double

                Dim lngIDModelo As Long
                Dim lngID As Long
                Dim lngCodigo As Long
                Dim lngIdTipoLente As Long
                Dim lngIdMateriaLente As Long

                Dim intRes As Integer
                Dim IntCor As Integer

                intRes = 0

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Suplementos Inicio " & Now.ToString(“HH:mm:ss.fff”))

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()
                        strQry = "select distinct tipo, tipolente, materia, codforn, descricao, cor, modeloforn, referencia, preco, precocusto from " & strTmpRef & " where tipo in ('2') order by tipo "
                        Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            For inti = 0 To dsListaVistas.Tables(0).Rows.Count - 1
                                rowTmp = dsListaVistas.Tables(0).Rows(inti)
                                With rowTmp
                                    strCodForn = !CodForn.ToString
                                    strModeloForn = !Modeloforn.ToString
                                    If strModeloForn = "" Then
                                        lngIDModelo = 0
                                    Else
                                        LerModelo(strConnStr, strModeloForn, lngIDModelo, lngIdMateriaLente, lngIdTipoLente, lngIDMarca)
                                    End If
                                    lngIdTipoLente = !tipolente
                                    lngIdMateriaLente = !materia

                                    strDescricao = Left(Trim(!Descricao), 50)
                                    strDescricao = Replace(strDescricao, "Ã¡", "a")
                                    strReferencia = !REFERENCIA.ToString
                                    IntCor = !cor
                                    dblPrecoVenda = !Preco
                                    dblPrecoCusto = !PrecoCusto
                                    strObservacoes = ""

                                    strQry = "select * from tbSuplementosLentes where IDMarca=" & lngIDMarca & " and codforn=" & ClsUtilitarios.EnvolveSQL(strCodForn) & " and modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn)
                                    Using dsModelo As New DataSet
                                        Using sqlcmdModelo As New SqlCommand(strQry, sqlcon)
                                            sqlcmdModelo.CommandType = System.Data.CommandType.Text
                                            adModelo = New SqlDataAdapter(sqlcmdModelo)
                                            adModelo.Fill(dsModelo)
                                            If dsModelo.Tables(0).Rows.Count = 0 Then
                                                lngCodigo = ProximoCodigo(strConnStr, "tbSuplementosLentes", "codigo")
                                                With rowTmp
                                                    strInsert = " insert into tbSuplementosLentes (ativo, codforn, modeloforn, codigo, cor, idmarca, idmodelo, idtipolente, idmaterialente, descricao, referencia, observacoes, precovenda, precocusto, datacriacao, utilizadorcriacao)"
                                                    strValues = " values (1, " & ClsUtilitarios.EnvolveSQL(strCodForn) & "," & ClsUtilitarios.EnvolveSQL(strModeloForn) & "," & lngCodigo & "," & IntCor & "," & lngIDMarca & "," & IIf(lngIDModelo = 0, "null", lngIDModelo) & ", " & lngIdTipoLente & ", " & lngIdMateriaLente & ", " & ClsUtilitarios.EnvolveSQL(strDescricao) & "," & ClsUtilitarios.EnvolveSQL(strReferencia) & "," & ClsUtilitarios.EnvolveSQL(strObservacoes) & ", " & " replace('" & !preco & "', ',', '.') " & ", " & " replace('" & !precocusto & "', ',', '.') " & ", getdate(), '" & ClsF3MSessao.RetornaUtilizadorNome & "')"
                                                    strQry = strInsert & strValues
                                                    BD.Database.ExecuteSqlCommand(strQry)
                                                End With
                                            Else
                                                rowMod = dsModelo.Tables(0).Rows(0)
                                                With rowMod
                                                    lngID = !id
                                                    lngIdTipoLente = !idtipolente
                                                    lngIdMateriaLente = !idmaterialente
                                                    strModeloForn = !Modeloforn.ToString
                                                    strReferencia = !REFERENCIA.ToString
                                                    IntCor = !cor

                                                    strQry = "update tbSuplementosLentes set descricao=" & ClsUtilitarios.EnvolveSQL(strDescricao) & ", cor=" & IntCor & ", ativo=1, referencia=" & ClsUtilitarios.EnvolveSQL(strReferencia) & ", modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn) & " where Id=" & lngID
                                                    BD.Database.ExecuteSqlCommand(strQry)
                                                End With
                                            End If
                                            ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Suplementos " & strCodForn & " " & strModeloForn & " " & Now.ToString(“HH:mm:ss.fff”))

                                        End Using
                                    End Using
                                End With
                            Next
                        End Using
                    End Using
                End Using
                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Suplementos Fim " & Now.ToString(“HH:mm:ss.fff”))

                Return 0
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Shared Function ImportarCores(ByVal BD As DbContext, ByVal strTmpRef As String, ByVal lngIDMarca As Long, ByVal blnActualizaPrecos As Boolean, ByVal intProtocolo As Integer)
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim adModelo As SqlDataAdapter

                Dim rowTmp As DataRow
                Dim rowMod As DataRow

                Dim strConnStr As String = ClsBaseDados.RetornaConnectionString(BD)
                Dim strDescricao As String
                Dim strCodForn As String
                Dim strQry As String
                Dim strModeloForn As String
                Dim strReferencia As String
                Dim strValues As String
                Dim strInsert As String
                Dim strObservacoes As String

                Dim dblPrecoVenda As Double
                Dim dblPrecoCusto As Double

                Dim lngIDModelo As Long
                Dim lngID As Long
                Dim lngCodigo As Long
                Dim lngIdTipoLente As Long
                Dim lngIdMateriaLente As Long

                Dim intRes As Integer
                Dim IntCor As Integer

                intRes = 0

                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Cores Inicio " & Now.ToString(“HH:mm:ss.fff”))

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()
                        strQry = "select distinct tipo, tipolente, materia, codforn, descricao, cor, modeloforn, referencia, preco, precocusto from " & strTmpRef & " where tipo in ('4') order by tipo "
                        Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            For inti = 0 To dsListaVistas.Tables(0).Rows.Count - 1
                                rowTmp = dsListaVistas.Tables(0).Rows(inti)
                                With rowTmp
                                    strCodForn = !CodForn.ToString
                                    strModeloForn = !Modeloforn.ToString
                                    If strModeloForn = "" Then
                                        lngIDModelo = 0
                                    Else
                                        LerModelo(strConnStr, strModeloForn, lngIDModelo, lngIdMateriaLente, lngIdTipoLente, lngIDMarca)
                                    End If
                                    lngIdTipoLente = !tipolente
                                    lngIdMateriaLente = !materia

                                    strDescricao = Left(Trim(!Descricao), 50)
                                    strDescricao = Replace(strDescricao, "Ã¡", "a")
                                    strReferencia = !REFERENCIA.ToString
                                    IntCor = 1
                                    dblPrecoVenda = !Preco
                                    dblPrecoCusto = !PrecoCusto
                                    strObservacoes = ""

                                    strQry = "select * from tbCoresLentes where IDMarca=" & lngIDMarca & " and codforn=" & ClsUtilitarios.EnvolveSQL(strCodForn) & " and modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn)
                                    Using dsModelo As New DataSet
                                        Using sqlcmdModelo As New SqlCommand(strQry, sqlcon)
                                            sqlcmdModelo.CommandType = System.Data.CommandType.Text
                                            adModelo = New SqlDataAdapter(sqlcmdModelo)
                                            adModelo.Fill(dsModelo)
                                            If dsModelo.Tables(0).Rows.Count = 0 Then
                                                lngCodigo = ProximoCodigo(strConnStr, "tbCoresLentes", "codigo")
                                                With rowTmp
                                                    strInsert = " insert into tbCoresLentes (ativo, codforn, codigo, cor, idmarca, idmodelo, idtipolente, idmaterialente, descricao, modeloforn, referencia, observacoes, precovenda, precocusto, datacriacao, utilizadorcriacao)"
                                                    strValues = " values (1, " & ClsUtilitarios.EnvolveSQL(strCodForn) & "," & lngCodigo & "," & IntCor & "," & lngIDMarca & ", " & IIf(lngIDModelo = 0, "null", lngIDModelo) & ", " & lngIdTipoLente & ", " & lngIdMateriaLente & ", " & ClsUtilitarios.EnvolveSQL(strDescricao) & "," & ClsUtilitarios.EnvolveSQL(strModeloForn) & "," & ClsUtilitarios.EnvolveSQL(strReferencia) & "," & ClsUtilitarios.EnvolveSQL(strObservacoes) & ", " & " replace('" & !preco & "', ',', '.') " & ", " & " replace('" & !precocusto & "', ',', '.') " & ", getdate(), '" & ClsF3MSessao.RetornaUtilizadorNome & "')"
                                                    strQry = strInsert & strValues
                                                    BD.Database.ExecuteSqlCommand(strQry)
                                                End With
                                            Else
                                                rowMod = dsModelo.Tables(0).Rows(0)
                                                With rowMod
                                                    lngID = !id
                                                    lngIdTipoLente = !idtipolente
                                                    lngIdMateriaLente = !idmaterialente
                                                    strModeloForn = !Modeloforn.ToString
                                                    strReferencia = !REFERENCIA.ToString
                                                    IntCor = 1

                                                    strQry = "update tbCoresLentes set descricao=" & ClsUtilitarios.EnvolveSQL(strDescricao) & ", cor=" & IntCor & ", ativo=1, referencia=" & ClsUtilitarios.EnvolveSQL(strReferencia) & ", modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn) & " where Id=" & lngID
                                                    BD.Database.ExecuteSqlCommand(strQry)
                                                End With
                                            End If

                                            ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Cores " & strCodForn & " " & strModeloForn & " " & Now.ToString(“HH:mm:ss.fff”))

                                        End Using
                                    End Using
                                End With
                            Next
                        End Using
                    End Using
                End Using
                ClsUtilitarios.CodeTrace("REC.log", "ImportarCSV Cores Fim " & Now.ToString(“HH:mm:ss.fff”))
                Return 0
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Shared Function ProximoCodigo(ByVal strConnStr As String, ByVal strTabela As String, ByVal strCampo As String) As Long
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim lngCodigo As Long

                lngCodigo = 1
                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()

                        Using sqlcmdVistas As New SqlCommand("select isnull(max(case when isnumeric(" & strCampo & ")=0 then 0 else " & strCampo & " end),0) as ultimo from " & strTabela, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            If dsListaVistas.Tables(0).Rows.Count > 0 Then
                                lngCodigo = dsListaVistas.Tables(0).Rows(0)!Ultimo + 1
                            End If
                        End Using
                    End Using
                    Return lngCodigo
                End Using
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Shared Function LerModelo(ByVal strConnStr As String, ByVal strModeloforn As String, ByRef lngIDModelo As Long, ByRef lngIDTipoLente As Long, ByRef lngIDMateriaLente As Long, ByRef lngIDMarca As Long) As Long
            Try
                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()

                        Using sqlcmdVistas As New SqlCommand("select * from tbmodelos with (nolock) where codforn=" & ClsUtilitarios.EnvolveSQL(strModeloforn) & " and idmarca=" & lngIDMarca, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            Dim adapterVistas As New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            If dsListaVistas.Tables(0).Rows.Count > 0 Then
                                lngIDModelo = dsListaVistas.Tables(0).Rows(0)!Id
                                lngIDTipoLente = dsListaVistas.Tables(0).Rows(0)!IDTipolente
                                lngIDMateriaLente = dsListaVistas.Tables(0).Rows(0)!IDMateriaLente
                            End If
                        End Using
                    End Using
                    Return 0
                End Using
            Catch ex As Exception
                Throw
            End Try
        End Function

        Public Shared Sub ApagarPrecos(ByVal BD As DbContext, ByVal lngIDModelo As Long)
            Try
                Dim strQry As String

                strQry = "delete from tbprecoslentes where idmodelo=" & lngIDModelo
                BD.Database.ExecuteSqlCommand(strQry)
            Catch ex As Exception
                Throw
            End Try
        End Sub

        Public Shared Sub ApagarGamas(ByVal BD As DbContext, ByVal lngIDModelo As Long)
            Try
                Dim strQry As String

                strQry = "delete from tbgamaslentes where idmodelo=" & lngIDModelo
                BD.Database.ExecuteSqlCommand(strQry)
            Catch ex As Exception
                Throw
            End Try
        End Sub

        Public Shared Sub AdicionarPrecos(ByVal BD As DbContext, ByVal strTmpRef As String, ByVal strCodForn As String, ByVal lngIDModelo As Long, ByVal lngIDTratamentoLente As Long, ByVal lngIDTipoArtigo As Long, ByVal strModeloForn As String)
            Try
                Dim adapterVistas As SqlDataAdapter

                Dim rowTmp As DataRow

                Dim strConnStr As String = ClsBaseDados.RetornaConnectionString(BD)
                Dim strQry As String
                Dim strInsert As String
                Dim strValues As String
                Dim strTratamento As String

                strTratamento = ""
                If lngIDTratamentoLente > 0 Then
                    strTratamento = strTratamento & " and tipo='5'  "
                End If

                If strModeloForn <> String.Empty Then
                    strTratamento = strTratamento & " and modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn) & " "
                End If

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()
                        strQry = "select distinct tipo, codforn, descricao, materia, tipolente, cor, diam_de, diam_ate, cil_de, cil_ate, esf_de, esf_ate, adi_de, adi_ate, raio, preco, precocusto, modeloforn, referencia, gama from " & strTmpRef & " where codforn=" & ClsUtilitarios.EnvolveSQL(strCodForn) & strTratamento & " order by diam_de "
                        Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            For inti = 0 To dsListaVistas.Tables(0).Rows.Count - 1
                                rowTmp = dsListaVistas.Tables(0).Rows(inti)
                                With rowTmp
                                    strInsert = " insert into tbprecoslentes (IDModelo, IDTratamentoLente, DiamDe, DiamAte, PotEsfDe, PotEsfAte, PotCilDe, PotCilAte, Gamastock, Raio, Precovenda, Precocusto, datacriacao, utilizadorcriacao)"
                                    strValues = " values (" & lngIDModelo & "," & IIf(lngIDTratamentoLente = 0, "null", lngIDTratamentoLente) & "," & ClsUtilitarios.EnvolveSQL(!diam_de) & "," & ClsUtilitarios.EnvolveSQL(!diam_ate) & "," & " replace('" & !esf_de & "', ',', '.') " & ", " & " replace('" & !esf_ate & "', ',', '.') " & ", " & " replace('" & !cil_de & "', ',', '.') " & ", " & " replace('" & !cil_ate & "', ',', '.') " & ", " & !gama & ", " & ClsUtilitarios.EnvolveSQL(!raio) & ", " & " replace('" & !preco & "', ',', '.') " & ", " & " replace('" & !precocusto & "', ',', '.') " & ", getdate(), '" & ClsF3MSessao.RetornaUtilizadorNome & "') "
                                    strQry = strInsert & strValues
                                    BD.Database.ExecuteSqlCommand(strQry)
                                End With
                            Next
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                Throw
            End Try
        End Sub


        Public Shared Sub AdicionarGamas(ByVal BD As DbContext, ByVal strTmpRef As String, ByVal lngIDTipoArtigo As Long, ByVal lngIDModelo As Long, ByVal strModeloForn As String, ByVal strCodForn As String)
            Try
                Dim adapterVistas As SqlDataAdapter
                Dim rowTmp As DataRow
                Dim strConnStr As String = ClsBaseDados.RetornaConnectionString(BD)
                Dim strQry As String
                Dim strInsert As String
                Dim strValues As String
                Dim strWhere As String

                Select Case lngIDTipoArtigo
                    Case 4
                        strWhere = " WHERE codforn=" & ClsUtilitarios.EnvolveSQL(strCodForn)
                    Case Else
                        strWhere = " WHERE tipo='6' AND modeloforn=" & ClsUtilitarios.EnvolveSQL(strModeloForn)
                End Select

                Using dsListaVistas As New DataSet
                    Using sqlcon As New SqlConnection(strConnStr)
                        sqlcon.Open()
                        strQry = "SELECT DISTINCT tipo, codforn, descricao, materia, tipolente, cor, diam_de, diam_ate, cil_de, cil_ate, esf_de, esf_ate, adi_de, adi_ate, raio, preco, precocusto, modeloforn, referencia, gama from " & strTmpRef & strWhere & " order by modeloforn, diam_de,diam_ate,cil_de,cil_ate,esf_de,esf_ate,adi_de,adi_ate"
                        Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                            sqlcmdVistas.CommandType = System.Data.CommandType.Text
                            adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            For inti = 0 To dsListaVistas.Tables(0).Rows.Count - 1
                                rowTmp = dsListaVistas.Tables(0).Rows(inti)
                                With rowTmp
                                    strInsert = "INSERT INTO tbgamaslentes (IDModelo, IDTratamentoLente, DiamDe, DiamAte, Descentrado, PotEsfDe, PotEsfAte, PotCilDe, PotCilAte, AdicaoDe, AdicaoAte, Raio, datacriacao, utilizadorcriacao)"
                                    strValues = " VALUES (" & lngIDModelo & ",null," & ClsUtilitarios.EnvolveSQL(!diam_de) & "," & ClsUtilitarios.EnvolveSQL(!diam_ate) & ",0, " & " replace('" & !esf_de & "', ',', '.') " & ", " & " replace('" & !esf_ate & "', ',', '.') " & ", " & " replace('" & !cil_de & "', ',', '.') " & ", " & " replace('" & !cil_ate & "', ',', '.') " & ", " & " replace('" & !Adi_de & "', ',', '.') " & ", " & " replace('" & !Adi_ate & "', ',', '.') " & "," & ClsUtilitarios.EnvolveSQL(IIf(lngIDTipoArtigo = 4, !raio, "")) & ", getdate(), '" & ClsF3MSessao.RetornaUtilizadorNome & "') ; select id from tbprecoslentes where id=SCOPE_IDENTITY(); "
                                    strQry = strInsert & strValues
                                    BD.Database.ExecuteSqlCommand(strQry)
                                End With
                            Next
                        End Using
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub

#End Region
    End Class
End Namespace