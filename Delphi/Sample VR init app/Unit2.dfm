object AdditionalWindow: TAdditionalWindow
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Sample VR init app'
  ClientHeight = 145
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 101
    Top = 32
    Width = 68
    Height = 13
    Caption = 'GameWorking'
  end
  object Button1: TButton
    Left = 96
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 0
    OnClick = Button1Click
  end
end
