object Form1: TForm1
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = '[TrueOpenVR] Sample with library use'
  ClientHeight = 185
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClick = FormClick
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 216
    Top = 72
    Width = 30
    Height = 13
    Alignment = taCenter
    Caption = 'TOVR'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 169
    Caption = 'HMD'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'X = 0'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Y = 0'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Z = 0'
    end
    object Label4: TLabel
      Left = 8
      Top = 96
      Width = 39
      Height = 13
      Caption = 'Yaw = 0'
    end
    object Label5: TLabel
      Left = 8
      Top = 120
      Width = 42
      Height = 13
      Caption = 'Pitch = 0'
    end
    object Label6: TLabel
      Left = 8
      Top = 144
      Width = 36
      Height = 13
      Caption = 'Roll = 0'
    end
  end
  object XPManifest1: TXPManifest
    Left = 392
    Top = 8
  end
end
