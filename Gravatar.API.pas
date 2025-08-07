unit Gravatar.API;

interface

uses
  System.SysUtils, System.Classes, System.Hash, HGM.FastClientAPI,
  Gravatar.Profile;

type
  TGravatarApi = class(TCustomAPI)
  public
    function GetEmailHash(const Email: string): string;
    function GetProfile(const Email: string): TGravatarProfile;
    function GetAvatar(const Email: string; Response: TStream; const Size: Integer = 80; const DefaultImage: string = 'identicon'): integer;
    function GetAvatarUrl(const Email: string; const Size: Integer = 80; const DefaultImage: string = 'identicon'): string;
    constructor Create; reintroduce;
  end;

implementation

function BytesToHexString(const Bytes: TBytes): string; inline;
begin
  Result := '';
  for var i := 0 to Length(Bytes) - 1 do
    Result := Result + IntToHex(Bytes[i], 2);
end;

{ TGravatarApi }

function TGravatarApi.GetEmailHash(const Email: string): string;
begin
  var BytesStream := TBytesStream.Create(TEncoding.UTF8.GetBytes(Trim(Email).ToLower));
  try
    Result := BytesToHexString(THashSHA2.Create(THashSHA2.TSHA2Version.SHA256).GetHashBytes(BytesStream)).ToLower;
  finally
    BytesStream.Free;
  end;
end;

function TGravatarApi.GetAvatarUrl(const Email: string; const Size: Integer; const DefaultImage: string): string;
begin
  Result := Format('%s/avatar/%s?s=%d&d=%s', [BaseUrl, GetEmailHash(Email), Size, DefaultImage]);
end;

function TGravatarApi.GetProfile(const Email: string): TGravatarProfile;
begin
  Result := Get<TGravatarProfile>(GetEmailHash(Email) + '.json');
end;

constructor TGravatarApi.Create;
begin
  inherited Create(TAuthorizationScheme.None);
  BaseUrl := 'https://www.gravatar.com';
end;

function TGravatarApi.GetAvatar(const Email: string; Response: TStream; const Size: Integer; const DefaultImage: string): integer;
begin
  Result := GetFile<TJSONParam>('avatar/' + GetEmailHash(Email),
    procedure(Params: TJSONParam)
    begin
      Params.Add('s', Size);
      Params.Add('d', DefaultImage);
    end,
      Response);
end;

end.

