
#addin "Cake.FileHelpers"
#addin "Cake.Npm"
#addin "Cake.Putty"
#addin nuget:?package=Cake.Git

var target = Argument("target", "");
var server = Argument("server", "prisma-lab-vm.westeurope.cloudapp.azure.com");
var user = Argument("user", "f3msa");
var password = Argument("password", "M!@dcSmj-6v4wm^u");

var f3mConfigSassPath = $"../F3M/sass/f3m/base/_config.scss";
var prismaSolution = "./Oticas.sln";
var environment = "";
var deployPath = "";
var releaseFile = "";

Task("Deploy-Dev")
  .IsDependentOn("Set-Dev-Environment")
  .IsDependentOn("Prisma-Publish")
  .IsDependentOn("Zip-Artifacts")
  .IsDependentOn("Copy-Artifacts")
  .IsDependentOn("Execute-Deploy")
  .Does(() => Information("Finished Deploy"));

Task("Deploy-App")
  .IsDependentOn("Set-App-Environment")
  .IsDependentOn("Prisma-Publish")
  .IsDependentOn("Zip-Artifacts")
  .IsDependentOn("Copy-Artifacts")
  .IsDependentOn("Execute-Deploy")
  .Does(() => Information("Finished Deploy"));

Task("Set-Dev-Environment")
  .Does(() => environment = "Dev")
  .Finally(() => SetVariablesWithEnvironment());

Task("Set-App-Environment")
  .Does(() => environment = "App")
  .Finally(() => SetVariablesWithEnvironment());

Task("Prisma-Publish")
  .IsDependentOn("Clean-Deploy")
  .IsDependentOn("F3M-Publish")
  .IsDependentOn("Clean-Prisma")
  .IsDependentOn("Prisma-Nuget-Restore")
  .Does(() => MSBuild(prismaSolution, new MSBuildSettings()
                .WithProperty("DeployOnBuild", "true")
                .WithProperty("Configuration", environment)
                .WithProperty("PublishProfile", $"Prisma{environment}")))
  .Finally(() => GitCheckout("../F3M"));

Task("Clean-Deploy")
  .Does(() =>
  {
    CleanDirectories("C:/deploy");    
  });

Task("F3M-Publish")
  .IsDependentOn("Clean-F3M")
  .IsDependentOn("F3M-Nuget-Restore")
  .IsDependentOn("Transform-Sass-Config")
  .IsDependentOn("Compile-Sass")
  .Does(() => MSBuild("../F3M/F3M.vbproj", new MSBuildSettings()
                .WithProperty("DeployOnBuild", "true")
                .WithProperty("Configuration",$"Prisma-{environment}")
                .WithProperty("PublishProfile", $"Prisma{environment}")));

Task("Clean-F3M")
  .Does(() =>
  {
    CleanDirectories("../F3M/bin");
    CleanDirectories($"../F3M/obj/Prisma-{environment}");
  });

Task("F3M-Nuget-Restore")
  .Does(() => NuGetRestore("../F3M/F3M.sln", new NuGetRestoreSettings { NoCache = true }));

Task("Transform-Sass-Config")
  .Does(() =>
  {
    var text = FileReadText(f3mConfigSassPath).Replace("$EmDesenvolvimento: true;", "$EmDesenvolvimento: false;").Replace("'/release'", $"'/{environment.ToLower()}'");
    FileWriteText(f3mConfigSassPath, text);
  });


Task("Compile-Sass")
  .Does(() => NpmRunScript("compile:sass"));


Task("Clean-Prisma")
  .Does(() =>
  {
    CleanDirectories("./src/Oticas/bin");
    CleanDirectories($"./src/Oticas/obj/{environment}");
  });

Task("Prisma-Nuget-Restore")
  .Does(() => NuGetRestore(prismaSolution, new NuGetRestoreSettings { NoCache = true }));

Task("Zip-Artifacts")
  .Does(() => Zip(deployPath, $"{deployPath}/{releaseFile}"));

Task("Copy-Artifacts")
  .IsDependentOn("Copy-Deploy-Script")
  .IsDependentOn("Create-Release-Folder")
  .Does(() =>
  {
    Pscp($"{deployPath}/{releaseFile}", $"{server}:release/{environment.ToLower()}/{releaseFile}", new PscpSettings { 
                                                                                            User = user, 
                                                                                            Password = password, 
                                                                                            SshVersion = SshVersion.V2 
                                                                                          });
  });

Task("Copy-Deploy-Script")
  .Does(() =>
  {
    Pscp("./deploy.ps1", $"{server}:c:/deploy.ps1", new PscpSettings  {
                                                                        User = user, 
                                                                        Password = password, 
                                                                        SshVersion = SshVersion.V2 
                                                                      });

    
  });

Task("Create-Release-Folder")
  .Does(() =>
  {
      Plink(server, $"if not exist release mkdir release && cd release && if not exist {environment.ToLower()} mkdir {environment.ToLower()}", new PlinkSettings  { 
                                                  User = user,
                                                  Password = password,
                                                  Protocol = PlinkProtocol.Ssh,
                                                  SshVersion = SshVersion.V2 
                                                });
  });

Task("Execute-Deploy")
  .Does(() =>
  {
    Plink(server, $"powershell -file c:/deploy.ps1 -appenv {environment.ToLower()}", new PlinkSettings  { 
                                                                                                          User = user, 
                                                                                                          Password = password, 
                                                                                                          Protocol = PlinkProtocol.Ssh, 
                                                                                                          SshVersion = SshVersion.V2 
                                                                                                        });
  });

RunTarget(target);


void SetVariablesWithEnvironment() 
{
  deployPath = $"C:/deploy/{environment.ToLower()}";
  releaseFile = $"{environment.ToLower()}-{DateTime.Now.ToString("dd-MM-yyyy-HH-mm")}.zip";
}