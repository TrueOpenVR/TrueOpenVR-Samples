unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Jpeg, StdCtrls;

type
  TMain = class(TForm)
    View: TImage;
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

type
  //VR Init
  PVRInfo = ^TVRInfo;
  _VRInfo = record
    ScreenIndex: integer;
    Scale: boolean;
    UserWidth: integer;
    UserHeight: integer;
  end;
  VRInfo = _VRInfo;
  TVRInfo = VRInfo;

var
  Main: TMain;

implementation

uses Unit2;

{$R *.dfm}

function GetInfo(out myVRInfo: TVRInfo): DWORD; stdcall; external 'TOVR.dll' name 'GetInfo';

procedure TMain.FormCreate(Sender: TObject);
var
  iResult: integer; myVRInfo: TVRInfo;
begin
  Application.Title:=Caption;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'VR-Quake-screenshot.jpg') then
    View.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'VR-Quake-screenshot.jpg');
  //VR Init info
  iResult:=GetInfo(myVRInfo);
    if iResult = 0 then begin
      ShowMessage('Info not found');
      Exit;
    end;

  if myVRInfo.ScreenIndex <= Screen.MonitorCount then begin

    Left:=Screen.Monitors[myVRInfo.ScreenIndex - 1].Left;
    Top:=Screen.Monitors[myVRInfo.ScreenIndex - 1].Top;

    if Screen.Monitors[myVRInfo.ScreenIndex - 1].Width > myVRInfo.UserWidth
      then begin
        //Image on center
        Width:=Screen.Monitors[myVRInfo.ScreenIndex - 1].Width;
        View.Width:=myVRInfo.UserWidth;
        View.Left:=Width div 2 - View.Width div 2;
      end else begin
        Width:=Screen.Monitors[myVRInfo.ScreenIndex - 1].Width;
        View.Width:=Width;
      end;

    if Screen.Monitors[myVRInfo.ScreenIndex - 1].Height > myVRInfo.UserHeight
      then begin
        //Image on center
        Height:=Screen.Monitors[myVRInfo.ScreenIndex - 1].Height;
        View.Height:=myVRInfo.UserHeight;
        View.Top:=Height div 2 - View.Height div 2;
      end else begin
        Height:=Screen.Monitors[myVRInfo.ScreenIndex - 1].Height;
        View.Height:=Height;
      end;

      //Scale
      if myVRInfo.Scale then begin
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
