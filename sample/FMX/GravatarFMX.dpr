program GravatarFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit7 in 'Unit7.pas' {Form7},
  HGM.FastClientAPI in '..\..\FastClientAPI\HGM.FastClientAPI.pas',
  Gravatar.Profile in '..\..\Gravatar.Profile.pas',
  Gravatar.API in '..\..\Gravatar.API.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
