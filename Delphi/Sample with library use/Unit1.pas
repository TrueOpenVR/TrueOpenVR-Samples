unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TrueOpenVR, StdCtrls, XPMan;

type
  TMain = class(TForm)
    hmdGB: TGroupBox;
    xlbl: TLabel;
    yLbl: TLabel;
    zLbl: TLabel;
    yawLbl: TLabel;
    pitchLbl: TLabel;
    rollLbl: TLabel;
    AboutLbl: TLabel;
    XPManifest: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

procedure TMain.FormCreate(Sender: TObject);
var
  myHMD: THMD;
begin
  Application.Title:=Caption;
  AboutLbl.Caption:='TOVR - Open Source Virtual Reality' + #13#10 + 'standard for all vr devices';
  if TOVR_Init = false then begin
    ShowMessage('TrueOpenVR not found');
    Halt;
  end;
  if GetHMDData(myHMD) <> 0 then begin
    xLbl.Caption:='X = ' + FloatToStr(myHMD.X);
    yLbl.Caption:='Y = ' + FloatToStr(myHMD.Y);
    zLbl.Caption:='Z = ' + FloatToStr(myHMD.Z);
    yawLbl.Caption:='Yaw = ' + FloatToStr(myHMD.Yaw);
    pitchLbl.Caption:='Pitch = ' + FloatToStr(myHMD.Pitch);
    rollLbl.Caption:='Roll = ' + FloatToStr(myHMD.Roll);
  end;
end;

procedure TMain.FormClick(Sender: TObject);
begin
  TOVR_Free;
end;

end.
