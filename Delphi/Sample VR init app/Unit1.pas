unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Jpeg, StdCtrls, XPMan, Registry;

type
  TMain = class(TForm)
    View: TImage;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

uses Unit2;

{$R *.dfm}

procedure TMain.FormCreate(Sender: TObject);
var
  iResult: integer; Reg: TRegistry; ScreenIndex, UserWidth, UserHeight: integer; ScreenScale: boolean;
begin
  Application.Title:=Caption;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'VR-Quake-screenshot.jpg') then
    View.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'VR-Quake-screenshot.jpg');

  //VR Init info
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\TrueOpenVR', false) then begin
  try
    ScreenScale:=Reg.ReadBool('Scale');
    ScreenIndex:=Reg.ReadInteger('ScreenIndex');
    UserWidth:=Reg.ReadInteger('UserWidth');
    UserHeight:=Reg.ReadInteger('UserHeight');
  except
    ScreenScale:=false;
    ScreenIndex:=1;
    UserWidth:=1280;
    UserHeight:=720;
  end;
  Reg.CloseKey;
  end else begin
    ShowMessage('TrueOpenVR not found');
    Halt;
  end;
  Reg.Free;

  if ScreenIndex <= Screen.MonitorCount then begin

    Left:=Screen.Monitors[ScreenIndex - 1].Left;
    Top:=Screen.Monitors[ScreenIndex - 1].Top;

    if Screen.Monitors[ScreenIndex - 1].Width > UserWidth
      then begin
        //Image on center
        Width:=Screen.Monitors[ScreenIndex - 1].Width;
        View.Width:=UserWidth;
        View.Left:=Width div 2 - View.Width div 2;
      end else begin
        Width:=Screen.Monitors[ScreenIndex - 1].Width;
        View.Width:=Width;
      end;

    if Screen.Monitors[ScreenIndex - 1].Height > UserHeight
      then begin
        //Image on center
        Height:=Screen.Monitors[ScreenIndex - 1].Height;
        View.Height:=UserHeight;
        View.Top:=Height div 2 - View.Height div 2;
      end else begin
        Height:=Screen.Monitors[ScreenIndex - 1].Height;
        View.Height:=Height;
      end;

      //Scale
      if ScreenScale then begin
        View.Left:=0;
        View.Top:=0;
        View.Width:=Width;
        View.Height:=Height;
      end;
  end else begin
    ShowMessage('HMD not found');
    Halt;
  end;
end;

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    ShowCursor(True);
    Close;
  end;
end;

procedure TMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ShowCursor(False);
end;

procedure TMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShowCursor(True);
end;

procedure TMain.ViewMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ShowCursor(False);
end;

procedure TMain.FormShow(Sender: TObject);
begin
  AdditionalWindow.Show;
end;

end.
