object Main: TMain
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TrueOpenVR Get Data'
  ClientHeight = 322
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
  object AboutLbl: TLabel
    Left = 400
    Top = 288
    Width = 30
    Height = 13
    Alignment = taCenter
    Caption = 'TOVR'
  end
  object GetBtn: TButton
    Left = 8
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Get'
    TabOrder = 0
    OnClick = GetBtnClick
  end
  object hmdGB: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 265
    Caption = 'HMD'
    TabOrder = 4
    object ScrIndLbl: TLabel
      Left = 8
      Top = 192
      Width = 80
      Height = 13
      Caption = 'Screen index = 0'
    end
    object IPDLbl: TLabel
      Left = 8
      Top = 216
      Width = 36
      Height = 13
      Caption = 'IPD = 0'
    end
    object RndResLbl: TLabel
      Left = 8
      Top = 240
      Width = 118
      Height = 13
      Caption = 'Render resolution = 0 x 0'
    end
    object hmdPositionGB: TGroupBox
      Left = 8
      Top = 16
      Width = 169
      Height = 81
      Caption = 'Position'
      TabOrder = 0
      object hmdXLbl: TLabel
        Left = 8
        Top = 16
        Width = 25
        Height = 13
        Caption = 'X = 0'
      end
      object hmdYLbl: TLabel
        Left = 8
        Top = 40
        Width = 25
        Height = 13
        Caption = 'Y = 0'
      end
      object hmdZlbl: TLabel
        Left = 8
        Top = 64
        Width = 25
        Height = 13
        Caption = 'Z = 0'
      end
    end
    object hmdRotationGB: TGroupBox
      Left = 8
      Top = 104
      Width = 169
      Height = 81
      Caption = 'Rotation'
      TabOrder = 1
      object hmdYawLbl: TLabel
        Left = 8
        Top = 16
        Width = 39
        Height = 13
        Caption = 'Yaw = 0'
      end
      object hmdPitchLbl: TLabel
        Left = 8
        Top = 40
        Width = 42
        Height = 13
        Caption = 'Pitch = 0'
      end
      object hmdRollLbl: TLabel
        Left = 8
        Top = 64
        Width = 36
        Height = 13
        Caption = 'Roll = 0'
      end
    end
  end
  object CtrlGB: TGroupBox
    Left = 200
    Top = 8
    Width = 185
    Height = 265
    Caption = 'Controller 1'
    TabOrder = 5
    object CtrlXLbl: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'X = 0'
    end
    object CtrlYLbl: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Y = 0'
    end
    object CtrlZLbl: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Z = 0'
    end
    object CtrlYawLbl: TLabel
      Left = 8
      Top = 96
      Width = 39
      Height = 13
      Caption = 'Yaw = 0'
    end
    object CtrlPitchLbl: TLabel
      Left = 8
      Top = 120
      Width = 42
      Height = 13
      Caption = 'Pitch = 0'
    end
    object CtrlRollLbl: TLabel
      Left = 8
      Top = 144
      Width = 36
      Height = 13
      Caption = 'Roll = 0'
    end
    object CtrlBtnsLbl: TLabel
      Left = 8
      Top = 168
      Width = 54
      Height = 13
      Caption = 'Buttons = 0'
    end
    object CtrlTrgLbl: TLabel
      Left = 8
      Top = 192
      Width = 51
      Height = 13
      Caption = 'Trigger = 0'
    end
    object CtrlThXLbl: TLabel
      Left = 8
      Top = 216
      Width = 58
      Height = 13
      Caption = 'ThumbX = 0'
    end
    object CtrlThYLbl: TLabel
      Left = 8
      Top = 240
      Width = 58
      Height = 13
      Caption = 'ThumbY = 0'
    end
  end
  object CloseBtn: TButton
    Left = 248
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = CloseBtnClick
  end
  object Ctrl2GB: TGroupBox
    Left = 392
    Top = 7
    Width = 185
    Height = 266
    Caption = 'Controller 2'
    TabOrder = 6
    object Ctrl2XLbl: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'X = 0'
    end
    object Ctrl2YLbl: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Y = 0'
    end
    object Ctrl2ZLbl: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Z = 0'
    end
    object Ctrl2YawLbl: TLabel
      Left = 8
      Top = 96
      Width = 39
      Height = 13
      Caption = 'Yaw = 0'
    end
    object Ctrl2PitchLbl: TLabel
      Left = 8
      Top = 120
      Width = 42
      Height = 13
      Caption = 'Pitch = 0'
    end
    object Ctrl2RollLbl: TLabel
      Left = 8
      Top = 144
      Width = 36
      Height = 13
      Caption = 'Roll = 0'
    end
    object Ctrl2BtnsLbl: TLabel
      Left = 8
      Top = 168
      Width = 54
      Height = 13
      Caption = 'Buttons = 0'
    end
    object Ctrl2TrgLbl: TLabel
      Left = 8
      Top = 192
      Width = 51
      Height = 13
      Caption = 'Trigger = 0'
    end
    object Ctrl2ThXLbl: TLabel
      Left = 8
      Top = 216
      Width = 58
      Height = 13
      Caption = 'ThumbX = 0'
    end
    object Ctrl2ThYLbl: TLabel
      Left = 8
      Top = 240
      Width = 58
      Height = 13
      Caption = 'ThumbY = 0'
    end
  end
  object CentringBtn: TButton
    Left = 88
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Centring'
    TabOrder = 1
    OnClick = CentringBtnClick
  end
  object FeedbackBtn: TButton
    Left = 168
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Feedback'
    TabOrder = 2
    OnClick = FeedbackBtnClick
  end
  object XPManifest: TXPManifest
    Left = 544
    Top = 16
  end
end
