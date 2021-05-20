using System.Resources;

namespace F3M.Oticas.Component.Extensions
{
    public static class ResourceManagerExtencions
    {
        public static string GetValue(this ResourceManager resourceManager, string name) => resourceManager.GetString(name) ?? name;
    }
}