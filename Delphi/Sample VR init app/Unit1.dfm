object Main: TMain
  Left = 192
  Top = 124
  BorderStyle = bsNone
  Caption = 'Sample VR init app'
  ClientHeight = 375
  ClientWidth = 575
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object View: TImage
    Left = 0
    Top = 0
    Width = 569
    Height = 369
    Center = True
    Proportional = True
    Stretch = True
    OnMouseMove = ViewMouseMove
  end
end
