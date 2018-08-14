#include "stdafx.h"
//#include <Windows.h>
#include <atlbase.h>

#define GRIPBTN 0x0001
#define THUMBSTICKBTN 0x0002
#define MENUBTN 0x0004
#define SYSTEMBTN 0x0008

typedef struct _HMDData
{
	double	X;
	double	Y;
	double	Z;
	double	Yaw;
	double	Pitch;
	double	Roll;
} THMD, *PHMD;

typedef struct _Controller
{
	double	X;
	double	Y;
	double	Z;
	double	Yaw;
	double	Pitch;
	double	Roll;
	WORD	Buttons;
	BYTE	Trigger;
	SHORT	ThumbX;
	SHORT	ThumbY;
} TController, *PController;

typedef DWORD(__stdcall *_GetHMDData)(__out THMD* myHMD);
typedef DWORD(__stdcall *_GetControllersData)(__out TController *myController, __out TController *myController2);
typedef DWORD(__stdcall *_SetControllerData)(__in int dwIndex, __in WORD MotorSpeed);
typedef DWORD(__stdcall *_SetCentering)(__in int dwIndex);

int DisplayEnable(int dwIndex)
{
	DISPLAY_DEVICE Display;
	Display.cb = sizeof(DISPLAY_DEVICE);
	DEVMODE DevMode;
	ZeroMemory(&DevMode, sizeof(DEVMODE));
	if (EnumDisplayDevices(NULL, dwIndex, &Display, EDD_GET_DEVICE_INTERFACE_NAME) != 0) {
		EnumDisplaySettings((LPCTSTR)Display.DeviceName, ENUM_REGISTRY_SETTINGS, &DevMode);
		DevMode.dmFields = DM_BITSPERPEL | DM_PELSWIDTH | DM_PELSHEIGHT | DM_DISPLAYFREQUENCY | DM_DISPLAYFLAGS | DM_POSITION;
		if (!(Display.StateFlags & DISPLAY_DEVICE_PRIMARY_DEVICE) && (ChangeDisplaySettingsEx((LPCTSTR)Display.DeviceName, &DevMode, 0, CDS_UPDATEREGISTRY | CDS_NORESET, NULL) == DISP_CHANGE_SUCCESSFUL)) 
		{
			ChangeDisplaySettingsEx(NULL, NULL, NULL, NULL, NULL);
			return 1;
		}
		else { return 0; }
	}
	else { return 0; }
}

int DisplayDisable(int dwIndex)
{
	DISPLAY_DEVICE Display;
	Display.cb = sizeof(DISPLAY_DEVICE);
	DEVMODE DevMode;
	ZeroMemory(&DevMode, sizeof(DEVMODE));
	DevMode.dmSize = sizeof(DEVMODE);
	DevMode.dmBitsPerPel = 32;
	DevMode.dmFields = DM_BITSPERPEL | DM_PELSWIDTH | DM_PELSHEIGHT | DM_DISPLAYFREQUENCY | DM_DISPLAYFLAGS | DM_POSITION;
	if (EnumDisplayDevices(NULL, dwIndex, &Display, EDD_GET_DEVICE_INTERFACE_NAME) != 0) {
		if (!(Display.StateFlags & DISPLAY_DEVICE_PRIMARY_DEVICE) && (ChangeDisplaySettingsEx((LPCTSTR)Display.DeviceName, &DevMode, 0, CDS_UPDATEREGISTRY | CDS_NORESET, NULL) == DISP_CHANGE_SUCCESSFUL))
		{
			ChangeDisplaySettingsEx(NULL, NULL, NULL, NULL, NULL);
			return 1;
		}
		else { return 0; }
	}
	else { return 0; }
}

int main()
{
	SetConsoleTitle(_T("TrueOpenVR Get Data"));

	//Read parameters from registry
	CRegKey key;
	TCHAR libPath[MAX_PATH];
	DWORD ScreenIndex, ScreenControl, RenderWidth, RenderHeight;
	
	LONG status = key.Open(HKEY_CURRENT_USER, _T("Software\\TrueOpenVR"));
	if (status == ERROR_SUCCESS)
	{
		ULONG libPathSize = sizeof(libPath);
		
		#ifdef _WIN64
			status = key.QueryStringValue(_T("Library64"), libPath, &libPathSize);
		#else
			status = key.QueryStringValue(_T("Library"), libPath, &libPathSize);
		#endif

		if (status != ERROR_SUCCESS)
		{
			printf("ERROR: TrueOpenVR library path not found");
			return 1;
		}
		
		key.QueryDWORDValue(_T("ScreenIndex"), ScreenIndex);
		key.QueryDWORDValue(_T("ScreenControl"), ScreenControl);
		ScreenIndex -= 1;
		key.QueryDWORDValue(_T("RenderWidth"), RenderWidth);
		key.QueryDWORDValue(_T("RenderHeight"), RenderHeight);
	}
	else
	{
		printf("ERROR: TrueOpenVR registry path not found");
		return 1;
	}
	key.Close();


	//Load main library
	HMODULE hDll;

	_GetHMDData GetHMDData;
	_GetControllersData GetControllersData;
	_SetControllerData SetControllerData;
	_SetCentering SetCentering;

	if (PathFileExists(libPath)) {
		hDll = LoadLibrary(libPath);
		if (hDll != NULL) {
			printf("Loaded TrueOpenVR library\r\n\Please wait\r\n");
			//Load functions
			GetHMDData = (_GetHMDData)GetProcAddress(hDll, "GetHMDData");
			GetControllersData = (_GetControllersData)GetProcAddress(hDll, "GetControllersData");
			SetControllerData = (_SetControllerData)GetProcAddress(hDll, "SetControllerData");
			SetCentering = (_SetCentering)GetProcAddress(hDll, "SetCentering");
		}
		else {
			printf("ERROR: unable to load DLL\n");
			return 1;
		}
	}
	else { 
		printf("TrueOpenVR library not found");
	}


	//Check functions
	if (GetHMDData == NULL) {
		printf("ERROR: unable to find GetHMDData DLL function\n");
		return 1;
	}

	if (GetControllersData == NULL) {
		printf("ERROR: unable to find GetControllersData DLL function\n");
		return 1;
	}

	if (SetControllerData == NULL) {
		printf("ERROR: unable to find SetControllerData DLL function\n");
		return 1;
	}

	if (SetCentering == NULL) {
		printf("ERROR: unable to find SetCentering DLL function\n");
		return 1;
	}

	//Enable VR display
	if (ScreenControl)
		DisplayEnable(ScreenIndex);
	
	//Display settings for window parameters
	DISPLAY_DEVICE Display;
	Display.cb=sizeof(DISPLAY_DEVICE);
	DEVMODE DevMode;
	ZeroMemory(&DevMode, sizeof(DEVMODE));
	if (EnumDisplayDevices(NULL, ScreenIndex, &Display, EDD_GET_DEVICE_INTERFACE_NAME) != 0) {
		EnumDisplaySettings((LPCTSTR)Display.DeviceName, ENUM_REGISTRY_SETTINGS, &DevMode);
	}

	THMD myHMD;
	TController myController, myController2;

	DWORD Result;

	Sleep(100);

	//Get data
	while (true) {
		system("cls");

		printf("Window parameters\r\nWidth=%d, Height=%d, Left=%d, ", DevMode.dmPelsWidth, DevMode.dmPelsHeight, DevMode.dmPosition);
		printf("Refresh rate=%d\r\n", DevMode.dmDisplayFrequency);
		printf("RenderWidth=%d, RenderHeight=%d\r\n\r\n", RenderWidth, RenderHeight);
		
		
		Result = GetHMDData(&myHMD);
		if (Result) { 
			printf("HMD = on\r\n"); 
		} else { 
			printf("HMD = off\r\n"); 
		}
		
		printf("X=%5.2f, Y=%5.2f, Z=%5.2f, Yaw=%7.2f, Pitch=%7.2f, Roll=%7.2f\r\n\r\n", myHMD.X, myHMD.Y, myHMD.Z, myHMD.Yaw, myHMD.Pitch, myHMD.Roll);

		Result = GetControllersData(&myController, &myController2);
		if (Result) {
			printf("Controller 1, controllers on\r\n");
		}
		else {
			printf("Controller 1, controllers off\r\n");
		}
		printf("X=%5.2f, Y=%5.2f, Z=%5.2f, Yaw=%7.2f, Pitch=%7.2f, Roll=%7.2f,\r\n", myController.X, myController.Y, myController.Z, myController.Yaw, myController.Pitch, myController.Roll);
		printf("Buttons=%d, Trigger=%3d, ThumbX=%6d, ThumbY=%6d\r\n", myController.Buttons, myController.Trigger, myController.ThumbX, myController.ThumbY);

		if ((myController.Buttons & GRIPBTN) || (myController.Buttons & THUMBSTICKBTN) || (myController.Buttons & MENUBTN) || (myController.Buttons & SYSTEMBTN)) {
			printf("Buttons pressed: ");
			if (myController.Buttons & GRIPBTN) printf("GRIP ");
			if (myController.Buttons & THUMBSTICKBTN) printf("Thumbstick ");
			if (myController.Buttons & MENUBTN) printf("Menu ");
			if (myController.Buttons & SYSTEMBTN) printf("System ");
			printf("\r\n");
		} else printf("Buttons pressed: -\r\n");

		printf("\r\nController 2\r\n");
		printf("X=%5.2f, Y=%5.2f, Z=%5.2f, Yaw=%7.2f, Pitch=%7.2f, Roll=%7.2f,\r\n", myController2.X, myController2.Y, myController2.Z, myController2.Yaw, myController2.Pitch, myController2.Roll);
		printf("Buttons=%d, Trigger=%3d, ThumbX=%6d, ThumbY=%6d\r\n", myController2.Buttons, myController2.Trigger, myController2.ThumbX, myController2.ThumbY);

		if ((myController2.Buttons & GRIPBTN) || (myController2.Buttons & THUMBSTICKBTN) || (myController2.Buttons & MENUBTN) || (myController2.Buttons & SYSTEMBTN)) {
			printf("Buttons pressed: ");
			if (myController2.Buttons & GRIPBTN) printf("GRIP ");
			if (myController2.Buttons & THUMBSTICKBTN) printf("Thumbstick ");
			if (myController2.Buttons & MENUBTN) printf("Menu ");
			if (myController2.Buttons & SYSTEMBTN) printf("System ");
			printf("\r\n");
		}
		else printf("Buttons pressed: -\r\n");

		printf("\r\nHotkeys\r\n\HMD centring\t\tCTRL + ALT + R\r\nController 1 centring\tCTRL + ALT + 1\r\nController 2 centring\tCTRL + ALT + 2\r\nController feedback\tCTRL + ALT + 3\r\nExit\t\t\tESC\r\n");


		if ((GetAsyncKeyState(VK_ESCAPE) & 0x8000) != 0 || (GetAsyncKeyState(VK_RETURN) & 0x8000)) break;

		//Centring
		if ((GetAsyncKeyState(VK_CONTROL) & 0x8000) != 0 && (GetAsyncKeyState(VK_MENU) & 0x8000) != 0 && (GetAsyncKeyState(82) & 0x8000) != 0) //HMD - CTRL + ALT + R 
			SetCentering(0);

		if ((GetAsyncKeyState(VK_CONTROL) & 0x8000) != 0 && (GetAsyncKeyState(VK_MENU) & 0x8000) != 0 && (GetAsyncKeyState(49) & 0x8000) != 0) //Controller 1 - CTRL + ALT + 1 
			SetCentering(1);

		if ((GetAsyncKeyState(VK_CONTROL) & 0x8000) != 0 && (GetAsyncKeyState(VK_MENU) & 0x8000) != 0 && (GetAsyncKeyState(50) & 0x8000) != 0) //Controller 2 - CTRL + ALT + 2
			SetCentering(2);

		//Vibration
		if ((GetAsyncKeyState(VK_CONTROL) & 0x8000) != 0 && (GetAsyncKeyState(VK_MENU) & 0x8000) != 0 && (GetAsyncKeyState(51) & 0x8000) != 0) {//CTRL + ALT + 3
			SetControllerData(1, 12000);
			SetControllerData(2, 12000);
		}

	}

	//Disable VR display
	if (ScreenControl)
		DisplayDisable(ScreenIndex);

	FreeLibrary(hDll);
	hDll = nullptr;

	return 0;
}
