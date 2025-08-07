unit Gravatar.Profile;

interface

uses
  Rest.Json, Rest.Json.Types;

type
  TProfileBackground = class
  private
    [JsonNameAttribute('opacity')]
    FOpacity: Extended;
  public
    property Opacity: Extended read FOpacity write FOpacity;
  end;

  TAccounts = class
  private
    [JsonNameAttribute('domain')]
    FDomain: string;
    [JsonNameAttribute('display')]
    FDisplay: string;
    [JsonNameAttribute('url')]
    FUrl: string;
    [JsonNameAttribute('iconUrl')]
    FIconUrl: string;
    [JsonNameAttribute('is_hidden')]
    FIsHidden: Boolean;
    [JsonNameAttribute('username')]
    FUsername: string;
    [JsonNameAttribute('verified')]
    FVerified: Boolean;
    [JsonNameAttribute('name')]
    FName: string;
    [JsonNameAttribute('shortname')]
    FShortname: string;
  public
    property Domain: string read FDomain write FDomain;
    property Display: string read FDisplay write FDisplay;
    property Url: string read FUrl write FUrl;
    property IconUrl: string read FIconUrl write FIconUrl;
    property IsHidden: Boolean read FIsHidden write FIsHidden;
    property Username: string read FUsername write FUsername;
    property Verified: Boolean read FVerified write FVerified;
    property Name: string read FName write FName;
    property Shortname: string read FShortname write FShortname;
  end;

  TPhotos = class
  private
    [JsonNameAttribute('value')]
    FValue: string;
    [JsonNameAttribute('type')]
    FType: string;
  public
    property Value: string read FValue write FValue;
    property &Type: string read FType write FType;
  end;

  TEntry = class
  private
    [JsonNameAttribute('hash')]
    FHash: string;
    [JsonNameAttribute('requestHash')]
    FRequestHash: string;
    [JsonNameAttribute('profileUrl')]
    FProfileUrl: string;
    [JsonNameAttribute('preferredUsername')]
    FPreferredUsername: string;
    [JsonNameAttribute('thumbnailUrl')]
    FThumbnailUrl: string;
    [JsonNameAttribute('photos')]
    FPhotos: TArray<TPhotos>;
    [JsonNameAttribute('displayName')]
    FDisplayName: string;
    [JsonNameAttribute('aboutMe')]
    FAboutMe: string;
    [JsonNameAttribute('currentLocation')]
    FCurrentLocation: string;
    [JsonNameAttribute('job_title')]
    FJobTitle: string;
    [JsonNameAttribute('company')]
    FCompany: string;
    [JsonNameAttribute('accounts')]
    FAccounts: TArray<TAccounts>;
    [JsonNameAttribute('profileBackground')]
    FProfileBackground: TProfileBackground;
    [JsonNameAttribute('primaryEmail')]
    FPrimaryEmail: string;
  public
    property Hash: string read FHash write FHash;
    property RequestHash: string read FRequestHash write FRequestHash;
    property ProfileUrl: string read FProfileUrl write FProfileUrl;
    property PrimaryEmail: string read FPrimaryEmail write FPrimaryEmail;
    property PreferredUsername: string read FPreferredUsername write FPreferredUsername;
    property ThumbnailUrl: string read FThumbnailUrl write FThumbnailUrl;
    property Photos: TArray<TPhotos> read FPhotos write FPhotos;
    property DisplayName: string read FDisplayName write FDisplayName;
    property AboutMe: string read FAboutMe write FAboutMe;
    property CurrentLocation: string read FCurrentLocation write FCurrentLocation;
    property JobTitle: string read FJobTitle write FJobTitle;
    property Company: string read FCompany write FCompany;
    property Accounts: TArray<TAccounts> read FAccounts write FAccounts;
    property ProfileBackground: TProfileBackground read FProfileBackground write FProfileBackground;
    destructor Destroy; override;
  end;

  TGravatarProfile = class
  private
    [JsonNameAttribute('entry')]
    FEntry: TArray<TEntry>;
  public
    property Entry: TArray<TEntry> read FEntry write FEntry;
    destructor Destroy; override;
  end;

implementation

{ TEntry }

destructor TEntry.Destroy;
begin
  for var Item in FPhotos do
    Item.Free;
  for var Item in FAccounts do
    Item.Free;
  FProfileBackground.Free;
  inherited;
end;

{ TGravatarProfile }

destructor TGravatarProfile.Destroy;
begin
  for var Item in FEntry do
    Item.Free;
  inherited;
end;

end.

