object Main: TMain
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TrueOpenVR sample with library use'
  ClientHeight = 153
  ClientWidth = 272
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
  object AboutLbl: TLabel
    Left = 48
    Top = 120
    Width = 30
    Height = 13
    Alignment = taCenter
    Caption = 'TOVR'
  end
  object hmdGB: TGroupBox
    Left = 8
    Top = 8
    Width = 257
    Height = 105
    Caption = 'HMD'
    TabOrder = 0
    object xlbl: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'X = 0'
    end
    object yLbl: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Y = 0'
    end
    object zLbl: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Z = 0'
    end
    object yawLbl: TLabel
      Left = 112
      Top = 24
      Width = 39
      Height = 13
      Caption = 'Yaw = 0'
    end
    object pitchLbl: TLabel
      Left = 112
      Top = 48
      Width = 42
      Height = 13
      Caption = 'Pitch = 0'
    end
    object rollLbl: TLabel
      Left = 112
      Top = 72
      Width = 36
      Height = 13
      Caption = 'Roll = 0'
    end
  end
  object XPManifest: TXPManifest
    Left = 224
    Top = 24
  end
end
