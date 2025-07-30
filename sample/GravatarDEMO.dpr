// *************************************************************************** }
//
// Delphi Gravatar Client
//
// Copyright (c) 2025 Daniele Teti
//
// https://github.com/danieleteti/delphigravatar
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

program GravatarDemo;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Vcl.Graphics,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage,
  GravatarClient in '..\GravatarClient.pas';


var
  lGravatar: TGravatarClient;
  lAvatar: TGraphic;
  lEmail, lFName: String;
  lAccount: TGravatarAccount;
  lProfile: TGravatarProfile;
begin
  try
    Writeln('Gravatar Client Demo');
    Writeln('--------------------');

    // Sample email
    lEmail := 'd.teti@bittime.it';

    lGravatar := TGravatarClient.Create;
    try
      // Gets avatar URL
      Writeln(Format('URL Avatar per %s:', [lEmail]));
      Writeln(lGravatar.GetAvatarUrl(lEmail, 200, 'identicon'));
      Writeln;

      // Loading Avatar
      Writeln('Loading Avatar...');
      lAvatar := lGravatar.LoadAvatar(lEmail, 200, 'identicon');
      try
        // Save of disk if you want
        lFName := '';
        if lAvatar is TJPEGImage then
          lFName := 'avatar.jpg'
        else if lAvatar is TPNGImage then
          lFName := 'avatar.png'
        else
          lFName := 'avatar.bmp';
        lAvatar.SaveToFile(lFName);
        Writeln('Avatar saved as "' + lFName + '"');
      finally
        lAvatar.Free;
      end;

      Writeln;
      Writeln('PROFILE');
      Writeln('--------------------');
      if lGravatar.GetProfile(lEmail, lProfile) then
      begin
        Writeln('Display Name: ' + lProfile.DisplayName);
        Writeln('Preferred Username: ' + lProfile.PreferredUsername);
        Writeln('Primary Email: ' + lProfile.PrimaryEmail);
        Writeln('Profile URL: ' + lProfile.ProfileUrl);
        Writeln('Thumbnail: ' + lProfile.ThumbnailUrl);
        Writeln('About Me: ' + lProfile.AboutMe);
        Writeln('Location: ' + lProfile.CurrentLocation);
        Writeln('Accounts:');
        for lAccount in lProfile.Accounts do
        begin
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
      end
      else
      begin
        Writeln('Profile not found');
      end;

    finally
      lGravatar.Free;
    end;
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.