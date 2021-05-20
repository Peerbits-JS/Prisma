Option Explicit On
Option Strict On
Option Compare Binary

Namespace Modelos.Constantes

    ''' <summary>
    ''' Tabela tbSistemaTiposServicos
    ''' </summary>
    ''' <remarks></remarks>
    Public Structure TipoServico
        Const LongePerto As Int64 = 1
        Const Longe As Int64 = 2
        Const Perto As Int64 = 3
        Const Bifocal As Int64 = 4
        Const Progressiva As Int64 = 5
        Const Contacto As Int64 = 6
        Const Ambos As Int64 = 7
        Const Direito As Int64 = 8
        Const Esquerdo As Int64 = 9
    End Structure

    ''' <summary>
    ''' Tabela tbSistemaTiposOlhos
    ''' </summary>
    ''' <remarks></remarks>
    Public Structure TipoOlho
        Const Direito As Int64 = 1
        Const Esquerdo As Int64 = 2
        Const Aro As Int64 = 3
        Const Diversos As Int64 = 4
    End Structure

    ''' <summary>
    ''' Tabela tbSistemaTiposGraduacoes
    ''' </summary>
    ''' <remarks></remarks>
    Public Structure TipoGraduacao
        Const Longe As Int64 = 1
        Const Intermedio As Int64 = 2
        Const Perto As Int64 = 3
        Const LentesContacto As Int64 = 4
    End Structure

    ''' <summary>
    ''' Tabela tbSistemaClassificacoesTiposArtigos
    ''' </summary>
    ''' <remarks></remarks>
    Public Structure TipoArtigo
        Const LentesOftalmicas As Int64 = 1
        Const Aros As Int64 = 2
        Const LentesContacto As Int64 = 3
        Const OculosSol As Int64 = 4
        Const Diversos As Int64 = 5
    End Structure



End Namespace
