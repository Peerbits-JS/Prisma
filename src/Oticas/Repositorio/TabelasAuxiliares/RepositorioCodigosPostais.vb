Imports System.Data.Entity
Imports System.Data.SqlClient
Imports System.IO
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioCodigosPostais
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbCodigosPostais, CodigosPostais)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbCodigosPostais)) As IQueryable(Of CodigosPostais)
            Return query.Select(Function(e) New CodigosPostais With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao,
                .IDConcelho = e.IDConcelho, .DescricaoConcelho = e.tbConcelhos.Descricao,
                .IDDistrito = e.tbConcelhos.IDDistrito, .DescricaoDistrito = e.tbConcelhos.tbDistritos.Descricao,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbCodigosPostais)) As IQueryable(Of CodigosPostais)
            Return query.Select(Function(e) New CodigosPostais With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo, .IDConcelho = e.IDConcelho, .DescricaoConcelho = e.tbConcelhos.Descricao,
                .IDDistrito = e.tbConcelhos.tbDistritos.ID, .DescricaoDistrito = e.tbConcelhos.tbDistritos.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo).OrderBy(Function(x) x.Codigo)
        End Function

        '' LISTA COMBO CODIGO
        Public Function ListaComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.CodigosPostais)
            Return ListaCamposCombo(FiltraQueryCodigo(inFiltro))
        End Function

        Public Function ListaCamposComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.CodigosPostais)
            Dim listaArts As List(Of Oticas.CodigosPostais) = ListaCamposCombo(FiltraQueryCodigo(inFiltro)).ToList

            Return listaArts.AsQueryable
        End Function

        Protected Function FiltraQueryCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of tbCodigosPostais)
            Dim query As IQueryable(Of tbCodigosPostais) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then query = query.Where(Function(w) w.Codigo.Contains(filtroTxt))

            'COD POSTAL
            Dim IDCodPostal As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDCodigoPostal, GetType(Long))
            If IDCodPostal <> 0 Then query = query.Where(Function(w) w.ID = IDCodPostal)

            'CONCELHO
            Dim IDConc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDConcelho, GetType(Long))
            If IDConc > 0 Then query = query.Where(Function(o) o.IDConcelho = IDConc)

            'DISTRITO
            Dim IDDist As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDDistrito, GetType(Long))
            If IDDist > 0 Then query = query.Where(Function(o) o.tbConcelhos.IDDistrito = IDDist)

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbCodigosPostais)
            Dim query As IQueryable(Of tbCodigosPostais) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDConc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDConcelho, GetType(Long))
            If IDConc > 0 Then
                query = query.Where(Function(o) o.IDConcelho = IDConc)
            End If

            Dim IDDist As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDDistrito, GetType(Long))
            If IDDist > 0 Then
                query = query.Where(Function(o) o.tbConcelhos.IDDistrito = IDDist)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
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

        Private Function ImportaFicheiro(ByVal modelo As F3M.Importacao) As F3M.Importacao
            Try
                Dim path = System.Web.HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath) & "\Importacao"
                Dim lines() As String = IO.File.ReadAllLines(path & "\" & modelo.NomeFicheiro.ToUpper)
                Dim campos() As String = lines(0).Split(";")

                Dim strTabela As String = modelo.NomeFicheiro.ToUpper.Replace(".CSV", String.Empty)
                ImportarBLK(path & "\" & modelo.NomeFicheiro.ToUpper, strTabela, campos)
                modelo.Estado = "Importado com sucesso!"

                'Using context As New Oticas.BD.Dinamica.Aplicacao
                '    If ImportarGeral(context, modelo.NomeFicheiro.ToUpper.Replace(".CSV", String.Empty), path & "\" & modelo.NomeFicheiro.ToUpper, values) Then
                '        modelo.Estado = "Importado com sucesso!"
                '    End If
                'End Using

                Return modelo
            Catch ex As Exception
                Throw
            End Try
        End Function

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

        Public Shared Function ImportarGeral(ByVal BD As DbContext, ByVal strTabela As String, ByVal strFile As String, ByVal Campos() As String) As Boolean
            Try

                Using transaction As DbContextTransaction = BD.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                    Try
                        Dim strCampos As String = String.Empty
                        Dim strValores As String = String.Empty
                        Dim strQry As String = String.Empty

                        Dim intI As Integer

                        strQry = "if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "_1]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "_1] "
                        BD.Database.ExecuteSqlCommand(strQry)

                        strCampos = ""
                        strValores = ""
                        strCamposIns = ""
                        For intI = 0 To Campos.Count - 1
                            If strCampos <> "" Then
                                strCampos = strCampos & ", "
                            End If
                            strCampos = strCampos & Campos(intI) & " nvarchar(1000) null"

                            If strValores <> "" Then
                                strValores = strValores & ", "
                            End If
                            strValores = strValores & " isnull( " & Campos(intI) & ",'') "

                            If strCamposIns <> "" Then
                                strCamposIns = strCamposIns & ", "
                            End If
                            strCamposIns = strCamposIns & Campos(intI)
                        Next


                        strQry = "if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tmp" & strTabela & "_1]') AND type in (N'U')) DROP TABLE [tmp" & strTabela & "_1] ;create table [tmp" & strTabela & "_1] (" & strCampos & ") bulk insert [tmp" & strTabela & "_1] from '" & strFile & "' with (codepage='ACP', firstrow = 2, fieldterminator=';', rowterminator='\n')"
                        BD.Database.ExecuteSqlCommand(strQry)

                        'campos por defeito
                        strValores = strValores & " , getdate(), 'F3M' "
                        strCamposIns = strCamposIns & " , DataCriacao, UtilizadorCriacao "

                        Select Case strTabela.ToLower
                            Case "tbdistritos", "tbconcelhos"
                                strValores = strValores & " , codigo"
                                strCamposIns = strCamposIns & " , id"

                                strQry = "SET IDENTITY_INSERT " & strTabela & " ON ; insert into [" & strTabela & "](" & strCamposIns & ") select " & strValores & " from [tmp" & strTabela & "_1] ; SET IDENTITY_INSERT " & strTabela & " OFF"
                                ClsBaseDados.ExecutaQueryeDevolveID(BD, strQry)

                            Case "tbcodigospostais"

                                strQry = "insert into [" & strTabela & "](" & strCamposIns & ") select " & strValores & " from [tmp" & strTabela & "_1]"
                                ClsBaseDados.ExecutaQueryeDevolveID(BD, strQry)
                        End Select

                        transaction.Commit()

                        Return True
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            Catch
                Throw
            End Try
        End Function

        Protected Sub ImportarBLK(strPath As String, strTabela As String, ByVal Campos() As String)

            Dim dt As New DataTable()

            dt.Columns.AddRange(New DataColumn(0) {New DataColumn("ID", GetType(String))})
            For intI = 0 To Campos.Count - 1
                dt.Columns.AddRange(New DataColumn(0) {New DataColumn(Campos(intI), GetType(String))})
            Next

            Dim csvData As String = IO.File.ReadAllText(strPath)
            Dim i As Integer = 0
            For Each row As String In csvData.Split(ControlChars.Lf)
                If Not String.IsNullOrEmpty(row) Then
                    If i <> 0 Then
                        Dim ro = dt.Rows.Add()
                        Dim linha = row.Replace(vbLf, "").Split(";")
                        With ro
                            .Item("ID") = i
                            For intI = 0 To Campos.Count - 1
                                .Item(Campos(intI)) = linha(intI)
                            Next
                        End With
                    End If
                End If
                i += 1
            Next

            Using con As New System.Data.SqlClient.SqlConnection(BDContexto.Database.Connection.ConnectionString)
                Using sqlBulkCopy As New System.Data.SqlClient.SqlBulkCopy(con, SqlBulkCopyOptions.KeepIdentity, Nothing)
                    sqlBulkCopy.DestinationTableName = strTabela
                    sqlBulkCopy.ColumnMappings.Add(New SqlClient.SqlBulkCopyColumnMapping("ID", "ID"))

                    For intI = 0 To Campos.Count - 1
                        sqlBulkCopy.ColumnMappings.Add(New SqlClient.SqlBulkCopyColumnMapping(Campos(intI), Campos(intI)))
                    Next
                    con.Open()
                    sqlBulkCopy.WriteToServer(dt)
                    con.Close()
                End Using
            End Using
        End Sub

#End Region

    End Class
End Namespace