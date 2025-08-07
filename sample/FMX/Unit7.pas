unit Unit7;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Edit,
  Gravatar.API, FMX.Objects;

type
  TForm7 = class(TForm)
    EditEmail: TEdit;
    MemoResult: TMemo;
    ButtonGet: TButton;
    ImageAvatar: TImage;
    procedure ButtonGetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses
  REST.Json;

{$R *.fmx}

procedure TForm7.ButtonGetClick(Sender: TObject);
begin
  var API := TGravatarApi.Create;
  try
    var Profile := API.GetProfile(EditEmail.Text);
    try
      MemoResult.Text := TJson.ObjectToJsonString(Profile);
    finally
      Profile.Free;
    end;

    var Avatar := TMemoryStream.Create;
    try
      API.GetAvatar(EditEmail.Text, Avatar, Trunc(ImageAvatar.Width));
      ImageAvatar.Bitmap.LoadFromStream(Avatar);
    finally
      Avatar.Free;
    end;
  finally
    API.Free;
  end;
end;

end.

