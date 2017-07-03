unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TrueOpenVR, StdCtrls, XPMan;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  myHMD: THMD;
begin
  Application.Title:=Caption;
  Label7.Caption:='TOVR - Open Source Virtual Reality' + #13#10 + 'standard for all devices';
  if TOVR_Init = false then begin
    ShowMessage('TrueOpenVR not found');
    Halt;
  end;
  if GetHMDData(myHMD) <> 0 then begin
    Label1.Caption:='X = ' + FloatToStr(myHMD.X);
    Label2.Caption:='Y = ' + FloatToStr(myHMD.Y);
    Label3.Caption:='Z = ' + FloatToStr(myHMD.Z);
    Label4.Caption:='Yaw = ' + FloatToStr(myHMD.Yaw);
    Label5.Caption:='Pitch = ' + FloatToStr(myHMD.Pitch);
    Label6.Caption:='Roll = ' + FloatToStr(myHMD.Roll);
  end;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
  TOVR_Free;
end;

end.
