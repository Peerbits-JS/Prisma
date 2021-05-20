Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class MedicosTecnicosEspecialidades
    Inherits F3M.MedicosTecnicosEspecialidades

    'ESPECIFICO TREEVIEW
    Public Property parentId As Nullable(Of Long)
    Public Property AcaoCRUD As Short
    Public Property IDAux As Nullable(Of Long)
End Class
