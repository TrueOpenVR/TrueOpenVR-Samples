unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, Registry;

type
  TMain = class(TForm)
    GetBtn: TButton;
    GroupBox1: TGroupBox;
    XPManifest1: TXPManifest;
    GroupBox2: TGroupBox;
    CloseBtn: TButton;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    GroupBox3: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label32: TLabel;
    Label18: TLabel;
    procedure GetBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  //HMD
  PHMD = ^THMD;
  _HMDData = record
    X: double;
    Y: double;
    Z: double;
    Yaw: double;
    Pitch: double;
    Roll: double;
end;
  HMD = _HMDData;
  THMD = HMD;

  //Controllers
  PController = ^TController;
  _Controller = record
    X: double;
    Y: double;
    Z: double;
    Yaw: double;
    Pitch: double;
    Roll: double;
    Buttons: dword;
    Trigger: byte;
    ThumbX: smallint;
    ThumbY: smallint;
end;
  Controller = _Controller;
  TController = Controller;

const
  IDHMD = 0;
  IDController = 1;
  IDController2 = 2;

var
  Main: TMain;

implementation

{$R *.dfm}

function GetHMDData(out myHMD: THMD): DWORD; stdcall; external 'TOVR.dll' name 'GetHMDData';
function GetControllersData(out myController, myContoller2: TController): DWORD; stdcall; external 'TOVR.dll' name 'GetControllersData';
function SetControllerData(dwIndex: integer; MotorSpeed: dword): DWORD; stdcall; external 'TOVR.dll' name 'SetControllerData';
function SetCentering(dwIndex: integer): DWORD; stdcall; external 'TOVR.dll' name 'SetCentering';

procedure TMain.GetBtnClick(Sender: TObject);
var
  myHMD: THMD; myController, myController2: TController;
  keys: string;
  iResult: integer;
  Reg: TRegistry;
begin
  //HMD
  iResult:=GetHMDData(myHMD);
    if iResult = 0 then ShowMessage('HMD not found');
  Label1.Caption:='X = ' + FloatToStr(myHMD.X);
  Label2.Caption:='Y = ' + FloatToStr(myHMD.Y);
  Label3.Caption:='Z = ' + FloatToStr(myHMD.Z);
  Label4.Caption:='Yaw = ' + FloatToStr(myHMD.Yaw);
  Label5.Caption:='Pitch = ' + FloatToStr(myHMD.Pitch);
  Label6.Caption:='Roll = ' + FloatToStr(myHMD.Roll);

  //VR Init info
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\TrueOpenVR', true) then begin
  try
  if Reg.ReadBool('Scale') = false then
    Label8.Caption:='Scale = false'
  else
    Label8.Caption:='Scale = true';
    Label7.Caption:='Screen index = ' + IntToStr(Reg.ReadInteger('ScreenIndex'));
    Label9.Caption:='User resolution = ' + IntToStr(Reg.ReadInteger('UserWidth')) + ' x ' + IntToStr(Reg.ReadInteger('UserHeight'));
    Label18.Caption:='Render resolution = ' + IntToStr(Reg.ReadInteger('RenderWidth')) + ' x ' + IntToStr(Reg.ReadInteger('RenderHeight'));
  except
    Label7.Caption:='Screen index = 1';
    Label8.Caption:='Scale = true';
    Label9.Caption:='User resolution = 1280 x 720';
    Label18.Caption:='Render resolution = 1280 x 720';
  end;
  Reg.CloseKey;
  end;
  Reg.Free;

  //Controllers
  iResult:=GetControllersData(myController, myController2);
    if iResult = 0 then ShowMessage('Controllers not found');
  Label10.Caption:='X = ' + FloatToStr(myController.X);
  Label11.Caption:='Y = ' + FloatToStr(myController.Y);
  Label12.Caption:='Z = ' + FloatToStr(myController.Z);

  Label13.Caption:='Yaw = ' + FloatToStr(myController.Yaw);
  Label14.Caption:='Pitch = ' + FloatToStr(myController.Pitch);
  Label15.Caption:='Roll = ' + FloatToStr(myController.Roll);

  if (myController.Buttons and 1) <> 0 then keys:=keys + '1 ';
  if (myController.Buttons and 2) <> 0 then keys:=keys + '2 ';
  if (myController.Buttons and 4) <> 0 then keys:=keys + '3 ';
  if (myController.Buttons and 8) <> 0 then keys:=keys + '4 ';

  if keys <> '' then
    Label16.Caption:='Buttons = ' + keys;

  Label17.Caption:='Trigger = ' + IntToStr(myController.Trigger);

  Label19.Caption:='ThumbX = ' + IntToStr(myController.ThumbX);
  Label20.Caption:='ThumbY = ' + IntToStr(myController.ThumbY);

  //Controller 2
  Label21.Caption:='X = ' + FloatToStr(myController2.X);
  Label22.Caption:='Y = ' + FloatToStr(myController2.Y);
  Label23.Caption:='Z = ' + FloatToStr(myController2.Z);

  Label24.Caption:='Yaw = ' + FloatToStr(myController2.Yaw);
  Label25.Caption:='Pitch = ' + FloatToStr(myController2.Pitch);
  Label26.Caption:='Roll = ' + FloatToStr(myController2.Roll);

  keys:='';

  if (myController2.Buttons and 1) <> 0 then keys:=keys + '1 ';
  if (myController2.Buttons and 2) <> 0 then keys:=keys + '2 ';
  if (myController2.Buttons and 4) <> 0 then keys:=keys + '3 ';
  if (myController2.Buttons and 8) <> 0 then keys:=keys + '4 ';

  if keys <> '' then
    Label27.Caption:='Buttons = ' + keys;


  Label28.Caption:='Trigger = ' + IntToStr(myController2.Trigger);

  Label30.Caption:='ThumbX = ' + IntToStr(myController2.ThumbX);
  Label31.Caption:='ThumbY = ' + IntToStr(myController2.ThumbY);
end;

procedure TMain.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  Label32.Caption:='TOVR - Open Source Virtual Reality' + #13#10 + 'standard for all devices';
  Application.Title:=Caption;
end;

procedure TMain.Button1Click(Sender: TObject);
var
  iResult: integer;
begin
  iResult:=SetCentering(IDHMD);
end;

procedure TMain.Button2Click(Sender: TObject);
begin
  SetControllerData(IDController, 12599);
  SetControllerData(IDController2, 42517);
end;

end.
