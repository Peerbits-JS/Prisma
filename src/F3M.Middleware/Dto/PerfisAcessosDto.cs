namespace F3M.Middleware.Dto
{
    public class PerfisAcessosDto
    {
        public bool Consultar { get; set; }
        public bool TemAcessoModulo { get; set; }
    }

    public class AccessDTO
    {
        public string Menu { get; set; }
        public bool Consultar { get; set; }
        public bool Adicionar { get; set; }
        public bool Alterar { get; set; }
        public bool Remover { get; set; }
    }
}

