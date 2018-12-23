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
    Trigger: single;
    AxisX: single;
    AxisY: single;
end;
  Controller = _Controller;
  TController = Controller;

const
  GRIPBTN = $0001;
  THUMBSTICKBTN = $0002;
  MENUBTN = $0004;
  SYSTEMBTN = $0008;

  TOVR_SUCCESS = 0;
  TOVR_FAILURE = 1;

  GRIP_BTN = $0001;
  THUMB_BTN = $0002;
  A_BTN = $0004;
  B_BTN = $0008;
  MENU_BTN = $0010;
  SYS_BTN = $0020;

var
  Main: TMain;
  LibPath: string;
  DllHandle: HMODULE;
  GetHMDData: function(out MyHMD: THMD): DWORD; stdcall;
  GetControllersData: function(out FirstController, SecondController: TController): DWORD; stdcall;
  SetControllerData: function (dwIndex: integer; MotorSpeed: byte): DWORD; stdcall;
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
  MyHMD: THMD; MyController, MyController2: TController;
  Buttons: string;
begin
  //HMD
  if GetHMDData(MyHMD) = TOVR_FAILURE then
    ShowMessage('HMD not found');
  HmdXLbl.Caption:='X = ' + FloatToStr(MyHMD.X);
  HmdYLbl.Caption:='Y = ' + FloatToStr(MyHMD.Y);
  HmdZLbl.Caption:='Z = ' + FloatToStr(MyHMD.Z);
  HmdYawLbl.Caption:='Yaw = ' + FloatToStr(MyHMD.Yaw);
  HmdPitchLbl.Caption:='Pitch = ' + FloatToStr(MyHMD.Pitch);
  HmdRollLbl.Caption:='Roll = ' + FloatToStr(MyHMD.Roll);

  //Controllers
  if GetControllersData(MyController, MyController2) = TOVR_FAILURE then
    ShowMessage('Controllers not found');
  CtrlXLbl.Caption:='X = ' + FloatToStr(MyController.X);
  CtrlYLbl.Caption:='Y = ' + FloatToStr(MyController.Y);
  CtrlZLbl.Caption:='Z = ' + FloatToStr(MyController.Z);

  CtrlYawLbl.Caption:='Yaw = ' + FloatToStr(MyController.Yaw);
  CtrlPitchLbl.Caption:='Pitch = ' + FloatToStr(MyController.Pitch);
  CtrlRollLbl.Caption:='Roll = ' + FloatToStr(MyController.Roll);

  Buttons:='';
  if (MyController.Buttons and GRIP_BTN) <> 0 then Buttons:=Buttons + 'GP ';
  if (MyController.Buttons and THUMB_BTN) <> 0 then Buttons:=Buttons + 'TS ';
  if (MyController.Buttons and A_BTN) <> 0 then Buttons:=Buttons + 'A ';
  if (MyController.Buttons and B_BTN) <> 0 then Buttons:=Buttons + 'B ';
  if (MyController.Buttons and MENU_BTN) <> 0 then Buttons:=Buttons + 'MN ';
  if (MyController.Buttons and SYS_BTN) <> 0 then Buttons:=Buttons + 'SM ';

  if Buttons <> '' then
    CtrlBtnsLbl.Caption:='Buttons = ' + Buttons
  else
    CtrlBtnsLbl.Caption:='Buttons = 0';

  CtrlTrgLbl.Caption:='Trigger = ' + FloatToStr(MyController.Trigger);

  CtrlThXLbl.Caption:='AxisX = ' + FloatToStr(MyController.AxisX);
  CtrlThYLbl.Caption:='AxisY = ' + FloatToStr(MyController.AxisY);

  //Controller 2
  Ctrl2XLbl.Caption:='X = ' + FloatToStr(MyController2.X);
  Ctrl2YLbl.Caption:='Y = ' + FloatToStr(MyController2.Y);
  Ctrl2ZLbl.Caption:='Z = ' + FloatToStr(MyController2.Z);

  Ctrl2YawLbl.Caption:='Yaw = ' + FloatToStr(MyController2.Yaw);
  Ctrl2PitchLbl.Caption:='Pitch = ' + FloatToStr(MyController2.Pitch);
  Ctrl2RollLbl.Caption:='Roll = ' + FloatToStr(MyController2.Roll);

  Buttons:='';
  if (MyController2.Buttons and GRIP_BTN) <> 0 then Buttons:=Buttons + 'GP ';
  if (MyController2.Buttons and THUMB_BTN) <> 0 then Buttons:=Buttons + 'TS ';
  if (MyController2.Buttons and A_BTN) <> 0 then Buttons:=Buttons + 'A ';
  if (MyController2.Buttons and B_BTN) <> 0 then Buttons:=Buttons + 'B ';
  if (MyController2.Buttons and MENU_BTN) <> 0 then Buttons:=Buttons + 'MN ';
  if (MyController2.Buttons and SYS_BTN) <> 0 then Buttons:=Buttons + 'SM ';

  if Buttons <> '' then
    Ctrl2BtnsLbl.Caption:='Buttons = ' + Buttons
  else
    Ctrl2BtnsLbl.Caption:='Buttons = 0';


  Ctrl2TrgLbl.Caption:='Trigger = ' + FloatToStr(MyController2.Trigger);

  Ctrl2ThXLbl.Caption:='AxisX = ' + FloatToStr(MyController2.AxisX);
  Ctrl2ThYLbl.Caption:='AxisY = ' + FloatToStr(MyController2.AxisY);
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
  if SetCentering(0) = TOVR_SUCCESS then
    ShowMessage('HMD centering success')
  else
    ShowMessage('HMD centering failure');

  if SetCentering(1) = TOVR_SUCCESS then
    ShowMessage('Controller 1 centering success')
  else
    ShowMessage('Controller 1 centering failure');

  if SetCentering(1) = TOVR_SUCCESS then
    ShowMessage('Controller 2 centering success')
  else
    ShowMessage('Controller 2 centering failure');
end;

procedure TMain.FeedbackBtnClick(Sender: TObject);
begin
  if SetControllerData(1, 100) = TOVR_SUCCESS then
    ShowMessage('Controller 1 Feedback success')
  else
    ShowMessage('Controller 1 Feedback failure');

  if SetControllerData(2, 100) = TOVR_SUCCESS then
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
