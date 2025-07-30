unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Winapi.ShellAPI;

type
  TMainForm = class(TForm)
    LabeledEdit1: TLabeledEdit;
    btnGrav: TButton;
    Panel1: TPanel;
    MemoRef: TMemo;
    Memo1: TMemo;
    Label1: TLabel;
    Panel2: TPanel;
    Image1: TImage;
    procedure btnGravClick(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses GravatarClient, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

procedure TMainForm.btnGravClick(Sender: TObject);
var
  lGravatar: TGravatarClient;
  lAvatar: TGraphic;
  lEmail: String;
  lAccount: TGravatarAccount;
  lProfile: TGravatarProfile;
  lImageType: TGravatarImageType;
begin
    // Email di esempio
    lEmail := LabeledEdit1.Text;

    // Crea il client (non è necessaria API key per gli avatar)
    lGravatar := TGravatarClient.Create;
    try
      // Ottieni l'URL dell'avatar
      MemoRef.Clear;
      MemoRef.Lines.Add(Format('URL Avatar per %s:', [lEmail]));
      MemoRef.Lines.Add(lGravatar.GetAvatarUrl(lEmail, Image1.Width, 'identicon'));

      lAvatar := lGravatar.LoadAvatar(lEmail, lImageType, Image1.Width, 'identicon');
      try
        Image1.Picture.Assign(lAvatar);

        //if you want to know file type, check lImageType
        case lImageType of
          gitPNG: lAvatar.SaveToFile('avatar.png');
          gitJPG: lAvatar.SaveToFile('avatar.jpg');
          else
            lAvatar.SaveToFile('avatar.bmp');
        end;
      finally
        lAvatar.Free;
      end;

      Memo1.Clear;
      if lGravatar.GetProfile(lEmail, lProfile) then
      begin
        Memo1.Lines.Add('Display Name: ' + lProfile.DisplayName);
        Memo1.Lines.Add('');
        Memo1.Lines.Add('Preferred Username: ' + lProfile.PreferredUsername);
        Memo1.Lines.Add('');
        Memo1.Lines.Add('Primary Email: ' + lProfile.PrimaryEmail);
        Memo1.Lines.Add('');
        Memo1.Lines.Add('Profile URL: ' + lProfile.ProfileUrl);
        Memo1.Lines.Add('');
        Memo1.Lines.Add('Thumbnail: ' + lProfile.ThumbnailUrl);
        Memo1.Lines.Add('');
        Memo1.Lines.Add('About Me: ' + lProfile.AboutMe);
        Memo1.Lines.Add('');
        Memo1.Lines.Add('Location: ' + lProfile.CurrentLocation);
        Memo1.Lines.Add('');
        Memo1.Lines.Add(Length(lProfile.Accounts).ToString + ' account/s found:');
        for lAccount in lProfile.Accounts do
        begin
          Memo1.Lines.Add('* Name     : ' + lAccount.Name);
          Memo1.Lines.Add('  Domain   : ' + lAccount.Domain);
          Memo1.Lines.Add('  Display  : ' + lAccount.Display);
          Memo1.Lines.Add('  URL      : ' + lAccount.URL);
          Memo1.Lines.Add('  IconURL  : ' + lAccount.IconUrl);
          Memo1.Lines.Add('  IsHidden : ' + lAccount.IsHidden.ToString(TUseBoolStrs.True));
          Memo1.Lines.Add('  Username : ' + lAccount.Username);
          Memo1.Lines.Add('  Verified : ' + lAccount.Verified.ToString(TUseBoolStrs.True));
          Memo1.Lines.Add('  ShortName: ' + lAccount.ShortName);
        end;
      end
      else
      begin
        Memo1.Lines.Add('Profile not found');
      end;

    finally
      lGravatar.Free;
    end;

    Memo1.SelStart := 0;
    Memo1.SelLength := 0;

end;

procedure TMainForm.Label1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://gravatar.com/',nil,nil, SW_SHOW);
end;

procedure TMainForm.Label1MouseEnter(Sender: TObject);
begin
  Label1.Font.Color := clNavy;
  Label1.Font.Style := [TFontStyle.fsUnderline];

end;

procedure TMainForm.Label1MouseLeave(Sender: TObject);
begin
  Label1.Font.Color := clWindowText;
  Label1.Font.Style := [];
end;

end.
