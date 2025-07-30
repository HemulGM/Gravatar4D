object MainForm: TMainForm
  AlignWithMargins = True
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Delphi Gravatar Client :: DEMO'
  ClientHeight = 605
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    920
    605)
  TextHeight = 21
  object Label1: TLabel
    Left = 8
    Top = 464
    Width = 300
    Height = 133
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Get your Gravatar global profile! Register on https://gravatar.c' +
      'om/'
    WordWrap = True
    OnClick = Label1Click
    OnMouseEnter = Label1MouseEnter
    OnMouseLeave = Label1MouseLeave
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 30
    Width = 736
    Height = 29
    EditLabel.Width = 38
    EditLabel.Height = 21
    EditLabel.Caption = 'EMail'
    TabOrder = 0
    Text = 'd.teti@bittime.it'
  end
  object btnGrav: TButton
    Left = 750
    Top = 32
    Width = 162
    Height = 25
    Caption = 'Get Gravatar Info'
    Default = True
    TabOrder = 1
    OnClick = btnGravClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 65
    Width = 904
    Height = 63
    BevelOuter = bvNone
    TabOrder = 2
    object MemoRef: TMemo
      Left = 0
      Top = 0
      Width = 904
      Height = 63
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object Memo1: TMemo
    Left = 314
    Top = 134
    Width = 598
    Height = 465
    Anchors = [akLeft, akTop, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Panel2: TPanel
    Left = 8
    Top = 134
    Width = 300
    Height = 300
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = '<Gravatar Profile Image>'
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 298
      Height = 298
      Align = alClient
      ExplicitLeft = 117
      ExplicitTop = -27
      ExplicitWidth = 300
      ExplicitHeight = 300
    end
  end
end
