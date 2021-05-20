Namespace Areas.AnalisesDinamicas.Controllers
    Public Class AnalisesDinamicasController
        Inherits F3M.Areas.AnalisesDinamicasF3M.Controllers.AnalisesDinamicasF3MController

        Sub New()
            MyBase.New(New RepositorioAnalisesDinamicas)
        End Sub
    End Class
End Namespace