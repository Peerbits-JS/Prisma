Imports System.Reflection
Imports F3M.Areas.Licenciamento
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Excepcoes
Imports F3M.Modelos.Logging
Imports F3M.Modelos.Modulos
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao
Imports F3M.Modelos.BaseDados

Namespace Controllers.Base
    Public Class BaseController
        Inherits ClsF3MController(Of Oticas.BD.Dinamica.Aplicacao, Object, Object)

        ' GET: Base
        <F3MAcesso>
        Function Index() As ActionResult
            'MANIPULA WEBCONFIG APENAS EM AMBIENTE DE DESENVOLVIMENTO
            

            'VERIFICA SE TEM ACESSO
            'chegou aqui pois está autenticado (cookie de autenticação)
            'o que sem pretende verificar é se continua a ter condições de acesso
            'Ativo; IP;....
            'Caso não então deve fazer LogOff
            Using rep As New RepositorioAutenticacao
                If Not rep.TemAcessoApplication(Request) Then
                    LogOff()
                End If
            End Using

            ' Controlo de Bases de Dados
            Using rep As New ClsControloEstruturaBD
                rep.ControlaEstruturaGeral()
            End Using

            Using rep As New RepositorioEmpresas
                rep.AtualizaEstruturaTabelaGeral()
            End Using

            Using rep As New ClsControloBDLogs
                rep.ValidaECriaBDLogs()
            End Using

            TrataLicenciamento()

            CarregaDadosSessaoEspecificos()

            ViewBag.Footer = RetornaFooterOticas()

            Dim versaonova As String = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).ProductVersion

            ViewData("VersaoAtualizada") = ClsF3MSessao.NovaVersao(versaonova)
            ViewData("VersaoNova") = versaonova
            ViewData("Titulo") = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).ProductName
            Return View()
        End Function


        ''' <summary>
        ''' Adiciona valores especificos do prisma à sessão
        ''' </summary>
        Private Sub CarregaDadosSessaoEspecificos()
            Try
                'If Not ClsF3MSessao.TemSessao() Then
                Dim objSessao = ClsF3MSessao.VerificaSessaoObjeto()

                Dim Utilizador As New F3M.tbUtilizadores

                Using ctx As New F3M.F3MGeralEntities
                    Dim IDUtilizador As Long = ClsF3MSessao.RetornaUtilizadorID
                    Utilizador = ctx.tbUtilizadores.Where(Function(f) f.ID = IDUtilizador).FirstOrDefault
                End Using

                If Utilizador IsNot Nothing Then
                    If Not ClsF3MSessao.ListaPropriedadeStorage(Of String)("LimiteMaxDesconto", objSessao) IsNot Nothing Then
                        ClsF3MSessao.AdicionaPropriedadeStorage("LimiteMaxDesconto", Utilizador.LimiteMaxDesconto, objSessao)
                    End If

                    If Not ClsF3MSessao.ListaPropriedadeStorage(Of String)("TotalDocVenda", objSessao) IsNot Nothing Then
                        ClsF3MSessao.AdicionaPropriedadeStorage("TotalDocVenda", Utilizador.TotalDocVenda, objSessao)
                    End If

                    If Not ClsF3MSessao.ListaPropriedadeStorage(Of String)("VendaAbaixoCustoMedio", objSessao) IsNot Nothing Then
                        ClsF3MSessao.AdicionaPropriedadeStorage("VendaAbaixoCustoMedio", Utilizador.VendaAbaixoCustoMedio, objSessao)
                    End If
                End If
                'End If
            Catch ex As Exception
                Throw
            End Try
        End Sub


        ''' <summary>
        ''' ATUALIZA LICENCIAMENTO SE NECESSARIO
        ''' </summary>
        ''' <param name="inSessao"></param>
        Private Sub AtualizaLicenciamento(inSessao As ClsF3MSessaoObjeto)
            Try
                Dim credenciais As F3M.LicenciamentoCredenciaisPortal
                Using repCredenciais As New RepositorioLicenciamentoCredenciaisPortal
                    credenciais = repCredenciais.ObtemCredenciais()

                    If credenciais IsNot Nothing Then
                        If credenciais.ConectarPortal AndAlso Not String.IsNullOrWhiteSpace(credenciais.Utilizador) AndAlso Not String.IsNullOrWhiteSpace(credenciais.Senha) Then
                            Dim inNomeUtilizador As String = credenciais.Utilizador
                            Dim inSenha As String = credenciais.Senha
                            Dim inModulos As String = ModulosAplicacao.RetornaModulosParaPortal()
                            Dim nomeFicheiro = IIf(ChavesWebConfig.Projeto.ModoSAAS, ClsF3MSessao.RetornaCodClienteSAAS() + ".lic", ConstAplicacao.NomeFicheiroLicencimento)
                            Dim controladorLicenciamento As New LicenciamentoController

                            If controladorLicenciamento.AtualizaLicenciamento(inNomeUtilizador, inSenha, inModulos, nomeFicheiro) Then
                                inSessao.Licenciamento = controladorLicenciamento.LeFicheiroLicenciamento(nomeFicheiro)
                            End If
                        End If
                    End If
                End Using
            Catch ex As Exception

            End Try
        End Sub

        Private Function TemModulosAcabarValidade(inSessao As ClsF3MSessaoObjeto) As Boolean
            Dim controladorLicenciamento As New LicenciamentoController

            Return controladorLicenciamento.RetornaModulosAcabarValidade(inSessao.Licenciamento).Any()
        End Function

        Public Sub TrataLicenciamento()
            If Not ClsF3MSessao.TemSessao() Then
                Dim objSessao = ClsF3MSessao.VerificaSessaoObjeto()

                ' ATUALIZA LICENCIAMENTO
                AtualizaLicenciamento(objSessao)

                ' ALOCA SESSÕES 
                Dim modulosSemSessao As List(Of Modulo) = ModulosSessao.AlocaSessoes(ClsF3MSessao.RetornaChaveSessao, objSessao)
                ViewData("ModulosSemSessao") = modulosSemSessao

                ' MODULOS ACABAR VALIDADE
                ViewData("TemModulosAcabarValidade") = TemModulosAcabarValidade(objSessao)
            End If
        End Sub


        ' GET: Base
        <F3MAcesso>
        <HttpPost>
        Function Erros(modelo As F3M.Modelos.Excepcoes.ModeloError) As JsonResult
            Try
                Dim boolSucesso As Boolean = ClsLogging.LoggarJS(modelo.Erro, modelo.Ficheiro, modelo.Linha, modelo.Coluna, modelo.StackTrace)

                Return Json(boolSucesso, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Dim listaRMSC As List(Of ClsF3MRespostaMensagemServidorCliente) = ClsExcepcoes.VerificaModelState(ModelState, ex)

                Return Json(New With {.Errors = listaRMSC}, JsonRequestBehavior.AllowGet)
            End Try
        End Function

        Sub RedirecionaLogin()
            Dim path As String = ClsTexto.ConcatenaStrings(New String() {ClsF3MSessao.getURLLogin, URLs.Login, "?popuplogin=1"})
            HttpContext.Response.Redirect(path)
        End Sub

        <F3MAcesso>
        Sub MudaEmpresa()
            ClsF3MSessao.LimpaSessaoMudaEmpresa()
            Dim path As String = ClsTexto.ConcatenaStrings(New String() {ClsF3MSessao.getURLLogin, URLs.LogOffMudaEmpresa})
            HttpContext.Response.Redirect(path)
        End Sub

        <F3MAcesso>
        Sub LogOff()
            'penso que deve se postback
            ClsF3MSessao.LimpaSessao()
            Dim path As String = ClsTexto.ConcatenaStrings(New String() {ClsF3MSessao.getURLLogin, URLs.LogOff})
            HttpContext.Response.Redirect(path)
        End Sub

        ' <OutputCache(Duration:=3600, VaryByParam:="culture")> _
        Public Function GetResources(inControlo As String) As JsonResult
            'generico
            Dim colStrings As Dictionary(Of String, String) = GetType(Traducao.Cliente).GetProperties() _
                           .Where(Function(p) Not p.Name.Contains("ResourceManager") And Not p.Name.Contains("Culture")).ToDictionary(Function(p) p.Name, Function(p) TryCast(p.GetValue(Nothing), String))

            'especificos
            If inControlo IsNot Nothing Then
                Dim strControlo As String = "Traducao.Cliente" & inControlo & ", Traducao"
                Dim resman As Type = Type.GetType(strControlo)
                If resman IsNot Nothing Then
                    Dim colStringaux As Dictionary(Of String, String) = resman.GetProperties() _
                        .Where(Function(p) Not p.Name.Contains("ResourceManager") And Not p.Name.Contains("Culture")).ToDictionary(Function(p) p.Name, Function(p) TryCast(p.GetValue(Nothing), String)) '.Where(Function(x) x.Key <> "ResourceManager" And x.Key <> "Culture")

                    If colStringaux.ToList.Count > 0 Then
                        colStrings = colStrings.Concat(colStringaux).ToDictionary(Function(d) d.Key, Function(d) d.Value)
                    End If
                End If
            End If

            Return Json(colStrings, JsonRequestBehavior.AllowGet)
        End Function

#Region "Funções Auxiliares"
        Private Function RetornaFooterOticas() As String
            Dim attrs As FileVersionInfo = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location)
            Return "<a href = '" & ChavesWebConfig.Projeto.ProjCliente & "/TermosdeUso.pdf' target='_blank'> Termos de Uso  </a>  |    " &
                    attrs.LegalCopyright & " " & Now.Year & "  " &
                    "<a href='" & attrs.LegalTrademarks & "' target='_blank'>" & attrs.CompanyName & "</a> | V " & attrs.ProductVersion
        End Function
#End Region

    End Class
End Namespace