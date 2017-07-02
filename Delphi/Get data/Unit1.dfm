object Main: TMain
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = '[TrueOpenVR] Get data'
  ClientHeight = 345
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label32: TLabel
    Left = 400
    Top = 312
    Width = 30
    Height = 13
    Alignment = taCenter
    Caption = 'TOVR'
  end
  object GetBtn: TButton
    Left = 8
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Get'
    TabOrder = 0
    OnClick = GetBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 289
    Caption = 'HMD'
    TabOrder = 1
    object Label7: TLabel
      Left = 8
      Top = 192
      Width = 80
      Height = 13
      Caption = 'Screen index = 0'
    end
    object Label8: TLabel
      Left = 8
      Top = 216
      Width = 61
      Height = 13
      Caption = 'Scale = false'
    end
    object Label9: TLabel
      Left = 8
      Top = 240
      Width = 105
      Height = 13
      Caption = 'User resolution = 0 x 0'
    end
    object Label18: TLabel
      Left = 8
      Top = 264
      Width = 118
      Height = 13
      Caption = 'Render resolution = 0 x 0'
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 16
      Width = 169
      Height = 81
      Caption = 'Position'
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 25
        Height = 13
        Caption = 'X = 0'
      end
      object Label2: TLabel
        Left = 8
        Top = 40
        Width = 25
        Height = 13
        Caption = 'Y = 0'
      end
      object Label3: TLabel
        Left = 8
        Top = 64
        Width = 25
        Height = 13
        Caption = 'Z = 0'
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 104
      Width = 169
      Height = 81
      Caption = 'Rotation'
      TabOrder = 1
      object Label4: TLabel
        Left = 8
        Top = 16
        Width = 39
        Height = 13
        Caption = 'Yaw = 0'
      end
      object Label5: TLabel
        Left = 8
        Top = 40
        Width = 42
        Height = 13
        Caption = 'Pitch = 0'
      end
      object Label6: TLabel
        Left = 8
        Top = 64
        Width = 36
        Height = 13
        Caption = 'Roll = 0'
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 200
    Top = 8
    Width = 185
    Height = 289
    Caption = 'Controller 1'
    TabOrder = 2
    object Label10: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'X = 0'
    end
    object Label11: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Y = 0'
    end
    object Label12: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Z = 0'
    end
    object Label13: TLabel
      Left = 8
      Top = 96
      Width = 39
      Height = 13
      Caption = 'Yaw = 0'
    end
    object Label14: TLabel
      Left = 8
      Top = 120
      Width = 42
      Height = 13
      Caption = 'Pitch = 0'
    end
    object Label15: TLabel
      Left = 8
      Top = 144
      Width = 36
      Height = 13
      Caption = 'Roll = 0'
    end
    object Label16: TLabel
      Left = 8
      Top = 168
      Width = 54
      Height = 13
      Caption = 'Buttons = 0'
    end
    object Label17: TLabel
      Left = 8
      Top = 192
      Width = 51
      Height = 13
      Caption = 'Trigger = 0'
    end
    object Label19: TLabel
      Left = 8
      Top = 216
      Width = 58
      Height = 13
      Caption = 'ThumbX = 0'
    end
    object Label20: TLabel
      Left = 8
      Top = 240
      Width = 58
      Height = 13
      Caption = 'ThumbY = 0'
    end
  end
  object CloseBtn: TButton
    Left = 248
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = CloseBtnClick
  end
  object GroupBox3: TGroupBox
    Left = 392
    Top = 7
    Width = 185
    Height = 290
    Caption = 'Controller 2'
    TabOrder = 4
    object Label21: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'X = 0'
    end
    object Label22: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Y = 0'
    end
    object Label23: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Z = 0'
    end
    object Label24: TLabel
      Left = 8
      Top = 96
      Width = 39
      Height = 13
      Caption = 'Yaw = 0'
    end
    object Label25: TLabel
      Left = 8
      Top = 120
      Width = 42
      Height = 13
      Caption = 'Pitch = 0'
    end
    object Label26: TLabel
      Left = 8
      Top = 144
      Width = 36
      Height = 13
      Caption = 'Roll = 0'
    end
    object Label27: TLabel
      Left = 8
      Top = 168
      Width = 54
      Height = 13
      Caption = 'Buttons = 0'
    end
    object Label28: TLabel
      Left = 8
      Top = 192
      Width = 51
      Height = 13
      Caption = 'Trigger = 0'
    end
    object Label30: TLabel
      Left = 8
      Top = 216
      Width = 58
      Height = 13
      Caption = 'ThumbX = 0'
    end
    object Label31: TLabel
      Left = 8
      Top = 240
      Width = 58
      Height = 13
      Caption = 'ThumbY = 0'
    end
  end
  object Button1: TButton
    Left = 88
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Centring'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Feedback'
    TabOrder = 6
    OnClick = Button2Click
  end
  object XPManifest1: TXPManifest
    Left = 184
    Top = 184
  end
end
