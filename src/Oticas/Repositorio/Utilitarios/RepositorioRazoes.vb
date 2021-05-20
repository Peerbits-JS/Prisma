'Imports F3M.Modelos.Comunicacao
'Imports F3M.Modelos.Constantes
'Imports F3M.Modelos.Repositorio
'Imports F3M.Modelos.Autenticacao
'Imports F3M.Modelos.BaseDados

'Namespace Repositorio.Utilitarios
'    Public Class RepositorioRazoes
'        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbRazoes, Oticas.Razao)

'#Region "Construtores"
'        Sub New()
'            MyBase.New()
'        End Sub
'#End Region

'#Region "LEITURA"
'#End Region

'#Region "ESCRITA"
'        Public Overrides Sub AdicionaObj(ByRef inModelo As Razao, inObjFiltro As ClsF3MFiltro)
'            Dim Razao As New tbRazoes

'            Mapear(inModelo, Razao)

'            With Razao
'                .IDLoja = ClsF3MSessao.RetornaLojaID
'                .Data = DateAndTime.Now()
'                .Ativo = True
'            End With

'            GravaEntidadeLinha(Of tbRazoes)(BDContexto, Razao, AcoesFormulario.Adicionar, Nothing)
'            BDContexto.SaveChanges()

'            UpdateSegundaVia("tb" + Razao.Entidade.ToLower, Razao.RegistoID, IIf(Razao.Opcao.ToLower = "2via", 1, 0))
'        End Sub

'        Protected Friend Sub UpdateSegundaVia(Tabela As String, IDDocumento As Long, Valor As Integer)

'            Dim strQuery As String = "update " & Tabela & " set segundavia=" & Valor & " where id=" & IDDocumento
'            ClsBaseDados.ExecutaQueryDBContext(strQuery, BDContexto)
'        End Sub

'        ''' <summary>
'        ''' funcao que retorna se o documento e 2 via
'        ''' </summary>
'        ''' <param name="strTabela"></param>
'        ''' <param name="IDDocumento"></param>
'        ''' <returns></returns>
'        ''' <remarks></remarks>
'        Protected Friend Function DocumentoSegundaVia(ByVal strTabela As String, ByVal IDDocumento As Long) As Boolean
'            Select Case strTabela.ToLower
'                Case "tbrecibos"
'                    Return (From x In BDContexto.tbRecibos Where x.ID = IDDocumento Select If(x.SegundaVia Is Nothing, False, x.SegundaVia)).FirstOrDefault()
'                Case Else
'                    Return (From x In BDContexto.tbDocumentosVendas Where x.ID = IDDocumento Select If(x.SegundaVia Is Nothing, False, x.SegundaVia)).FirstOrDefault()
'            End Select
'        End Function


'#End Region

'    End Class
'End Namespace