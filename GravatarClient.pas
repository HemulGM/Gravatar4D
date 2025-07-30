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

unit GravatarClient;

interface

uses
  System.SysUtils, System.Classes, System.Hash, System.Net.HttpClient,
  Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, System.NetEncoding;

type
  EGravatar = type Exception;

  TGravatarAccount = record
    Domain: String;
    Display: String;
    URL: String;
    IconUrl: String;
    IsHidden: Boolean;
    Username: String;
    Verified: Boolean;
    Name: String;
    ShortName: String;
  end;


  TGravatarProfile = record
    DisplayName: string;
    ThumbnailUrl: string;
    ProfileUrl: string;
    AboutMe: string;
    CurrentLocation: string;
    PreferredUsername: string;
    PrimaryEmail: string;
    Accounts: TArray<TGravatarAccount>;
  end;


  TGravatarClient = class
  private
    FHttpClient: THttpClient;
    function GetEmailHash(const Email: string): string;
    function BuildAvatarUrl(const EmailHash: string;
                           const Size: Integer = 80;
                           const DefaultImage: string = 'identicon'): string;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAvatarUrl(const Email: string;
                         const Size: Integer = 80;
                         const DefaultImage: string = 'identicon'): string;

    function LoadAvatar(const Email: string;
                       const Size: Integer = 80;
                       const DefaultImage: string = 'identicon'): TGraphic;

    function GetProfileUrl(const Email: string): String;
    function GetProfile(const Email: string; out Profile: TGravatarProfile): Boolean;
  end;

implementation

uses
  System.JSON, System.Generics.Collections, System.IOUtils;

function BytesToHexString(const Bytes: TBytes): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(Bytes) - 1 do
  begin
    Result := Result + IntToHex(Bytes[I], 2);
  end;
end;


{ TGravatarClient }

constructor TGravatarClient.Create;
begin
  inherited;
  FHttpClient := THttpClient.Create;
end;

destructor TGravatarClient.Destroy;
begin
  FHttpClient.Free;
  inherited;
end;

function TGravatarClient.GetEmailHash(const Email: string): string;
var
  lHash: THashSHA2;
  lHashBytes, lEmailBytes: TBytes;
  lProcessedEmail: String;
  lBytesStream: TBytesStream;
begin
  lProcessedEmail  := Trim(Email).ToLower;
  lEmailBytes := TEncoding.UTF8.GetBytes(lProcessedEmail);
  lHash := THashSHA2.Create(SHA256);
  lBytesStream := TBytesStream.Create(lEmailBytes);
  try
    lHashBytes := lHash.GetHashBytes(lBytesStream);
    Result := BytesToHexString(lHashBytes).ToLower;
  finally
    lBytesStream.Free;
  end;
end;


function TGravatarClient.GetProfile(const Email: string; out Profile: TGravatarProfile): Boolean;
var
  ProfileUrl: string;
  Response: IHTTPResponse;
  JSONObj, EntryObj, AccountObj: TJSONObject;
  EntryArr, AccountsArr: TJSONArray;
  I: Integer;
begin
  Result := False;
  ProfileUrl := GetProfileUrl(Email);
  try
    Response := FHttpClient.Get(ProfileUrl);
    if Response.StatusCode <> 200 then
    begin
      Exit(False);
    end;

    JSONObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
    try
      if JSONObj.TryGetValue<TJSONArray>('entry', EntryArr) and
         (EntryArr.Count > 0) and
         (EntryArr.Items[0] is TJSONObject) then
      begin
        EntryObj := TJSONObject(EntryArr.Items[0]);

        Profile.DisplayName := EntryObj.GetValue<string>('displayName');
        Profile.ThumbnailUrl := EntryObj.GetValue<string>('thumbnailUrl');
        Profile.ProfileUrl := EntryObj.GetValue<string>('profileUrl');

        if EntryObj.TryGetValue<string>('aboutMe', Profile.AboutMe) = False then
          Profile.AboutMe := '';

        if EntryObj.TryGetValue<string>('currentLocation', Profile.CurrentLocation) = False then
          Profile.CurrentLocation := '';

        if EntryObj.TryGetValue<string>('preferredUsername', Profile.PreferredUsername) = False then
          Profile.PreferredUsername := '';

        if EntryObj.TryGetValue<string>('primaryEmail', Profile.PrimaryEmail) = False then
          Profile.PrimaryEmail := '';

        if EntryObj.TryGetValue<TJSONArray>('accounts', AccountsArr) then
        begin
          SetLength(Profile.Accounts, AccountsArr.Count);
          for I := 0 to AccountsArr.Count - 1 do
          begin
            if AccountsArr.Items[I] is TJSONObject then
            begin
              AccountObj := TJSONObject(AccountsArr.Items[I]);
              Profile.Accounts[I].Domain := AccountObj.GetValue<string>('domain', '');
              Profile.Accounts[I].Display := AccountObj.GetValue<string>('display', '');
              Profile.Accounts[I].URL := AccountObj.GetValue<string>('url', '');
              Profile.Accounts[I].IconUrl := AccountObj.GetValue<string>('iconUrl', '');
              Profile.Accounts[I].IsHidden := AccountObj.GetValue<Boolean>('is_hidden', True);
              Profile.Accounts[I].Username := AccountObj.GetValue<string>('username','');
              Profile.Accounts[I].Verified := AccountObj.GetValue<boolean>('verified', False);
              Profile.Accounts[I].Name := AccountObj.GetValue<string>('name','');
              Profile.Accounts[I].ShortName := AccountObj.GetValue<string>('shortname','');
            end;
          end;
        end
        else
        begin
          Profile.Accounts := [];
        end;
        Result := True;
      end;
    finally
      JSONObj.Free;
    end;
  except
    on E: Exception do
    begin
      raise EGravatar.CreateFmt('Cannot retrieve profile: %s - %s', [E.ClassName, E.Message]);
    end;
  end;
end;

function TGravatarClient.GetProfileUrl(const Email: string): String;
var
  lEmailHash: string;
begin
  lEmailHash := GetEmailHash(Email);
  Result := Format('https://www.gravatar.com/%s.json', [lEmailHash]);
end;

function TGravatarClient.BuildAvatarUrl(const EmailHash: string;
  const Size: Integer; const DefaultImage: string): string;
begin
  Result := Format('https://www.gravatar.com/avatar/%s?s=%d&d=%s', [EmailHash, Size, DefaultImage]);
end;

function TGravatarClient.GetAvatarUrl(const Email: string;
  const Size: Integer; const DefaultImage: string): string;
var
  EmailHash: string;
begin
  EmailHash := GetEmailHash(Email);
  Result := BuildAvatarUrl(EmailHash, Size, DefaultImage);
end;

function TGravatarClient.LoadAvatar(const Email: string;
  const Size: Integer; const DefaultImage: string): TGraphic;
var
  AvatarUrl: string;
  Response: IHTTPResponse;
  Stream: TMemoryStream;
  ContentType: string;
begin
  AvatarUrl := GetAvatarUrl(Email, Size, DefaultImage);

  Stream := TMemoryStream.Create;
  try
    Response := FHttpClient.Get(AvatarUrl, Stream);
    if Response.StatusCode = 200 then
    begin
      Stream.Position := 0;
      ContentType := LowerCase(Response.HeaderValue['content-type']);
      if Pos('image/jpeg', ContentType) > 0 then
        Result := TJPEGImage.Create
      else if Pos('image/png', ContentType) > 0 then
        Result := TPNGImage.Create
      else
        Result := TBitmap.Create;
      Result.LoadFromStream(Stream);
    end
    else
    begin
      raise EGravatar.CreateFmt('Cannot load avatar - Status Code %d - Status Text %s',
        [Response.StatusCode, Response.StatusText]);
    end;
  finally
    Stream.Free;
  end;
end;

end.
