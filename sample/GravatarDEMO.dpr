program GravatarDemo;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Gravatar.API in '..\Gravatar.API.pas',
  Gravatar.Profile in '..\Gravatar.Profile.pas',
  HGM.FastClientAPI in '..\FastClientAPI\HGM.FastClientAPI.pas';

begin
  try
    Writeln('Gravatar Client Demo');
    Writeln('--------------------');

    // Sample email
    var lEmail := 'd.teti@bittime.it';

    var lGravatar := TGravatarAPI.Create;
    try
      // Gets avatar URL
      Writeln(Format('URL Avatar per %s:', [lEmail]));
      Writeln(lGravatar.GetAvatarUrl(lEmail, 200, 'identicon'));
      Writeln;

      Writeln;
      Writeln('PROFILE');
      Writeln('--------------------');
      var lProfiles := lGravatar.GetProfile(lEmail);
      try
        if Length(lProfiles.Entry) < 1 then
          raise Exception.Create('Profile not found');
        var lProfile := lProfiles.Entry[0];
        Writeln('Display Name: ' + lProfile.DisplayName);
        Writeln('Preferred Username: ' + lProfile.PreferredUsername);
        Writeln('Primary Email: ' + lProfile.PrimaryEmail);
        Writeln('Profile URL: ' + lProfile.ProfileUrl);
        Writeln('Thumbnail: ' + lProfile.ThumbnailUrl);
        Writeln('About Me: ' + lProfile.AboutMe);
        Writeln('Location: ' + lProfile.CurrentLocation);
        Writeln('Accounts:');
        for var lAccount in lProfile.Accounts do
        begin
          WriteLn;
          WriteLn('* Name     : ' + lAccount.Name);
          WriteLn('  Domain   : ' + lAccount.Domain);
          WriteLn('  Display  : ' + lAccount.Display);
          WriteLn('  URL      : ' + lAccount.URL);
          WriteLn('  IconURL  : ' + lAccount.IconUrl);
          WriteLn('  IsHidden : ' + lAccount.IsHidden.ToString(TUseBoolStrs.True));
          WriteLn('  Username : ' + lAccount.Username);
          WriteLn('  Verified : ' + lAccount.Verified.ToString(TUseBoolStrs.True));
          WriteLn('  ShortName: ' + lAccount.ShortName);
        end;
      finally
        lProfiles.Free;
      end;
    finally
      lGravatar.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

