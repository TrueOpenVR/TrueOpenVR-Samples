unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, Registry;

type
  TMain = class(TForm)
    GetBtn: TButton;
    hmdGB: TGroupBox;
    XPManifest: TXPManifest;
    CtrlGB: TGroupBox;
    CloseBtn: TButton;
    hmdPositionGB: TGroupBox;
    hmdRotationGB: TGroupBox;
    hmdXLbl: TLabel;
    hmdYLbl: TLabel;
    hmdZlbl: TLabel;
    hmdYawLbl: TLabel;
    hmdPitchLbl: TLabel;
    hmdRollLbl: TLabel;
    ScrIndLbl: TLabel;
    IPDLbl: TLabel;
    CtrlXLbl: TLabel;
    CtrlYLbl: TLabel;
    CtrlZLbl: TLabel;
    CtrlYawLbl: TLabel;
    CtrlPitchLbl: TLabel;
    CtrlRollLbl: TLabel;
    CtrlBtnsLbl: TLabel;
    CtrlTrgLbl: TLabel;
    CtrlThXLbl: TLabel;
    CtrlThYLbl: TLabel;
    Ctrl2GB: TGroupBox;
    Ctrl2XLbl: TLabel;
    Ctrl2YLbl: TLabel;
    Ctrl2ZLbl: TLabel;
    Ctrl2YawLbl: TLabel;
    Ctrl2PitchLbl: TLabel;
    Ctrl2RollLbl: TLabel;
    Ctrl2BtnsLbl: TLabel;
    Ctrl2TrgLbl: TLabel;
    Ctrl2ThXLbl: TLabel;
    Ctrl2ThYLbl: TLabel;
    CentringBtn: TButton;
    FeedbackBtn: TButton;
    AboutLbl: TLabel;
    RndResLbl: TLabel;
    procedure GetBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CentringBtnClick(Sender: TObject);
    procedure FeedbackBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure GetRegValues;
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
    Buttons: word;
    Trigger: byte;
    ThumbX: smallint;
    ThumbY: smallint;
end;
  Controller = _Controller;
  TController = Controller;

const
  GRIPBTN = $0001;
  THUMBSTICKBTN = $0002;
  MENUBTN = $0004;
  SYSTEMBTN = $0008;

var
  Main: TMain;
  LibPath: string;
  DllHandle: HMODULE;
  GetHMDData: function(out myHMD: THMD): DWORD; stdcall;
  GetControllersData: function(out myController, myController2: TController): DWORD; stdcall;
  SetControllerData: function (dwIndex: integer; MotorSpeed: word): DWORD; stdcall;
  SetCentering: function (dwIndex: integer): DWORD; stdcall;
  ScreenControl: boolean;
  ScreenIndex: integer;

implementation

{$R *.dfm}

const
  EDD_GET_DEVICE_INTERFACE_NAME = 1;
  ENUM_REGISTRY_SETTINGS = DWORD(-2);

procedure DisplayEnable(dwIndex: integer);
var
  Display: TDisplayDevice;
  DevMode: TDevMode;
begin
  Display.cb:=SizeOf(TDisplayDevice);
  EnumDisplayDevices(nil, dwIndex, Display, EDD_GET_DEVICE_INTERFACE_NAME);
  EnumDisplaySettings(PChar(@Display.DeviceName[0]), ENUM_REGISTRY_SETTINGS, DevMode);
  DevMode.dmFields:=DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFREQUENCY or DM_DISPLAYFLAGS or DM_POSITION;
  if (Display.StateFlags and DISPLAY_DEVICE_PRIMARY_DEVICE) <> DISPLAY_DEVICE_PRIMARY_DEVICE then begin
    ChangeDisplaySettingsEx(PChar(@Display.DeviceName[0]), DevMode, 0, CDS_UPDATEREGISTRY or CDS_NORESET, nil);
    ChangeDisplaySettingsEx(nil, PDevMode(nil)^, 0, 0, nil);
  end;
end;

procedure DisplayDisable(dwIndex: integer);
var
  Display: TDisplayDevice;
  DevMode: TDevMode;
begin
  Display.cb:=SizeOf(TDisplayDevice);
  EnumDisplayDevices(nil, dwIndex, Display, EDD_GET_DEVICE_INTERFACE_NAME);
  ZeroMemory(@DevMode, SizeOf(TDevMode));
  DevMode.dmSize:=SizeOf(TDevMode);
  DevMode.dmBitsPerPel:=32;
  DevMode.dmFields:=DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFREQUENCY or DM_DISPLAYFLAGS or DM_POSITION;
  if (Display.StateFlags and DISPLAY_DEVICE_PRIMARY_DEVICE) <> DISPLAY_DEVICE_PRIMARY_DEVICE then begin
    ChangeDisplaySettingsEx(PChar(@Display.DeviceName[0]), DevMode, 0, CDS_UPDATEREGISTRY or CDS_NORESET, nil);
    ChangeDisplaySettingsEx(nil, PDevMode(nil)^, 0, 0, nil);
  end;
end;

procedure TMain.GetRegValues;
var
  Reg: TRegistry;
begin
  LibPath:='';
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\TrueOpenVR', false) = false then Exit;
  LibPath:=Reg.ReadString('Library');
  if FileExists(LibPath) = false then LibPath:='';

  try
    ScreenIndex:=Reg.ReadInteger('ScreenIndex');
    ScrIndLbl.Caption:='Screen index = ' + IntToStr(ScreenIndex);
    ScreenIndex:=ScreenIndex - 1;
    ScreenControl:=Reg.ReadBool('ScreenControl');
    IPDLbl.Caption:='IPD = ' + FloatToStr(Reg.ReadFloat('IPD'));
    RndResLbl.Caption:='Render resolution = ' + IntToStr(Reg.ReadInteger('RenderWidth')) + ' x ' + IntToStr(Reg.ReadInteger('RenderHeight'));
  except
  end;

  Reg.CloseKey;
  Reg.Free;
end;

procedure TMain.GetBtnClick(Sender: TObject);
var
  myHMD: THMD; myController, myController2: TController;
  keys: string;
  iResult: integer;
begin
  //HMD
  iResult:=GetHMDData(myHMD);
    if iResult = 0 then ShowMessage('HMD not found');
  hmdXLbl.Caption:='X = ' + FloatToStr(myHMD.X);
  hmdYLbl.Caption:='Y = ' + FloatToStr(myHMD.Y);
  hmdZLbl.Caption:='Z = ' + FloatToStr(myHMD.Z);
  hmdYawLbl.Caption:='Yaw = ' + FloatToStr(myHMD.Yaw);
  hmdPitchLbl.Caption:='Pitch = ' + FloatToStr(myHMD.Pitch);
  hmdRollLbl.Caption:='Roll = ' + FloatToStr(myHMD.Roll);

  //Controllers
  iResult:=GetControllersData(myController, myController2);
    if iResult = 0 then ShowMessage('Controllers not found');
  CtrlXLbl.Caption:='X = ' + FloatToStr(myController.X);
  CtrlYLbl.Caption:='Y = ' + FloatToStr(myController.Y);
  CtrlZLbl.Caption:='Z = ' + FloatToStr(myController.Z);

  CtrlYawLbl.Caption:='Yaw = ' + FloatToStr(myController.Yaw);
  CtrlPitchLbl.Caption:='Pitch = ' + FloatToStr(myController.Pitch);
  CtrlRollLbl.Caption:='Roll = ' + FloatToStr(myController.Roll);

  if (myController.Buttons and 1) <> 0 then keys:=keys + 'GP ';
  if (myController.Buttons and 2) <> 0 then keys:=keys + 'TS ';
  if (myController.Buttons and 4) <> 0 then keys:=keys + 'MN ';
  if (myController.Buttons and 8) <> 0 then keys:=keys + 'SM ';

  if keys <> '' then
    CtrlBtnsLbl.Caption:='Buttons = ' + keys;

  CtrlTrgLbl.Caption:='Trigger = ' + IntToStr(myController.Trigger);

  CtrlThXLbl.Caption:='ThumbX = ' + IntToStr(myController.ThumbX);
  CtrlThYLbl.Caption:='ThumbY = ' + IntToStr(myController.ThumbY);

  //Controller 2
  Ctrl2XLbl.Caption:='X = ' + FloatToStr(myController2.X);
  Ctrl2YLbl.Caption:='Y = ' + FloatToStr(myController2.Y);
  Ctrl2ZLbl.Caption:='Z = ' + FloatToStr(myController2.Z);

  Ctrl2YawLbl.Caption:='Yaw = ' + FloatToStr(myController2.Yaw);
  Ctrl2PitchLbl.Caption:='Pitch = ' + FloatToStr(myController2.Pitch);
  Ctrl2RollLbl.Caption:='Roll = ' + FloatToStr(myController2.Roll);

  keys:='';

  if (myController2.Buttons and GRIPBTN) <> 0 then keys:=keys + 'GP ';
  if (myController2.Buttons and THUMBSTICKBTN) <> 0 then keys:=keys + 'TS ';
  if (myController2.Buttons and MENUBTN) <> 0 then keys:=keys + 'MN ';
  if (myController2.Buttons and SYSTEMBTN) <> 0 then keys:=keys + 'SM ';

  if keys <> '' then
    Ctrl2BtnsLbl.Caption:='Buttons = ' + keys;


  Ctrl2TrgLbl.Caption:='Trigger = ' + IntToStr(myController2.Trigger);

  Ctrl2ThXLbl.Caption:='ThumbX = ' + IntToStr(myController2.ThumbX);
  Ctrl2ThYLbl.Caption:='ThumbY = ' + IntToStr(myController2.ThumbY);
end;

procedure TMain.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  AboutLbl.Caption:='TOVR - Open Source Virtual Reality' + #13#10 + 'standard for all devices';
  Application.Title:=Caption;

  GetRegValues;
  if LibPath <> '' then begin
    DllHandle:=LoadLibrary(PChar(LibPath));
    @GetHMDData:=GetProcAddress(DllHandle, 'GetHMDData');
    @GetControllersData:=GetProcAddress(DllHandle, 'GetControllersData');
    @SetControllerData:=GetProcAddress(DllHandle, 'SetControllerData');
    @SetCentering:=GetProcAddress(DllHandle, 'SetCentering');
    if ScreenControl then
      DisplayEnable(ScreenIndex);
  end else begin
    ShowMessage('TrueOpenVR not found');
    Halt;
  end;
end;

procedure TMain.CentringBtnClick(Sender: TObject);
begin
  if SetCentering(0) = 1 then
    ShowMessage('HMD centering success')
  else
    ShowMessage('HMD centering failure');

  if SetCentering(1) = 1 then
    ShowMessage('Controller 1 centering success')
  else
    ShowMessage('Controller 1 centering failure');

  if SetCentering(1) = 1 then
    ShowMessage('Controller 2 centering success')
  else
    ShowMessage('Controller 2 centering failure');
end;

procedure TMain.FeedbackBtnClick(Sender: TObject);
begin
  if SetControllerData(1, 12000) = 1 then
    ShowMessage('Controller 1 Feedback success')
  else
    ShowMessage('Controller 1 Feedback failure');

  if SetControllerData(2, 12000) = 1 then
    ShowMessage('Controller 2 Feedback success')
  else
    ShowMessage('Controller 2 Feedback failure');
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DllHandle <> 0 then begin
    FreeLibrary(DllHandle);
    if ScreenControl then
      DisplayDisable(ScreenIndex);
  end;
end;

end.
