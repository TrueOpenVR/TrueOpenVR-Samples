//#include <Windows.h>
#include <atlbase.h>

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
	unsigned short	Buttons;
	float	Trigger;
	float	AxisX;
	float	AxisY;
} TController, *PController;

#define TOVR_SUCCESS 0
#define TOVR_FAILURE 1

#define GRIP_BTN	0x0001
#define THUMB_BTN	0x0002
#define A_BTN		0x0004
#define B_BTN		0x0008
#define MENU_BTN	0x0010
#define SYS_BTN		0x0020

typedef DWORD(__stdcall *_GetHMDData)(__out THMD *HMD);
typedef DWORD(__stdcall *_GetControllersData)(__out TController *FirstController, __out TController *SecondController);
typedef DWORD(__stdcall *_SetControllerData)(__in int dwIndex, __in unsigned char MotorSpeed);
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

	THMD MyHMD;
	TController MyController, MyController2;

	DWORD Result;

	Sleep(100);

	//Get data
	while (true) {
		system("cls");

		printf("Window parameters\r\nWidth=%d, Height=%d, Left=%d, ", DevMode.dmPelsWidth, DevMode.dmPelsHeight, DevMode.dmPosition);
		printf("Refresh rate=%d\r\n", DevMode.dmDisplayFrequency);
		printf("RenderWidth=%d, RenderHeight=%d\r\n\r\n", RenderWidth, RenderHeight);
		
		
		Result = GetHMDData(&MyHMD);
		if (Result != TOVR_FAILURE) {
			printf("HMD = on\r\n"); 
		} else { 
			printf("HMD = off\r\n"); 
		}
		
		printf("X=%5.2f, Y=%5.2f, Z=%5.2f, Yaw=%7.2f, Pitch=%7.2f, Roll=%7.2f\r\n\r\n", MyHMD.X, MyHMD.Y, MyHMD.Z, MyHMD.Yaw, MyHMD.Pitch, MyHMD.Roll);

		Result = GetControllersData(&MyController, &MyController2);
		if (Result != TOVR_FAILURE) {
			printf("Controller 1, controllers on\r\n");
		}
		else {
			printf("Controller 1, controllers off\r\n");
		}
		printf("X=%5.2f, Y=%5.2f, Z=%5.2f, Yaw=%7.2f, Pitch=%7.2f, Roll=%7.2f,\r\n", MyController.X, MyController.Y, MyController.Z, MyController.Yaw, MyController.Pitch, MyController.Roll);
		printf("Buttons=%d, Trigger=%7.2f, AxisX=%7.2f, AxisY=%7.2f\r\n", MyController.Buttons, MyController.Trigger, MyController.AxisX, MyController.AxisY);

		if ((MyController.Buttons & GRIP_BTN) || (MyController.Buttons & THUMB_BTN) || (MyController.Buttons & A_BTN) ||
			(MyController.Buttons & B_BTN) || (MyController.Buttons & MENU_BTN) || (MyController.Buttons & SYS_BTN)) {
			printf("Buttons pressed: ");
			if (MyController.Buttons & GRIP_BTN) printf("GRIP ");
			if (MyController.Buttons & THUMB_BTN) printf("Thumbstick ");
			if (MyController.Buttons & A_BTN) printf("A ");
			if (MyController.Buttons & B_BTN) printf("B ");
			if (MyController.Buttons & MENU_BTN) printf("Menu ");
			if (MyController.Buttons & SYS_BTN) printf("System ");
			printf("\r\n");
		}
		else printf("Buttons pressed: -\r\n");

		printf("\r\nController 2\r\n");
		printf("X=%5.2f, Y=%5.2f, Z=%5.2f, Yaw=%7.2f, Pitch=%7.2f, Roll=%7.2f,\r\n", MyController2.X, MyController2.Y, MyController2.Z, MyController2.Yaw, MyController2.Pitch, MyController2.Roll);
		printf("Buttons=%d, Trigger=%7.2f, AxisX=%7.2f, AxisY=%7.2f\r\n", MyController2.Buttons, MyController2.Trigger, MyController2.AxisX, MyController2.AxisY);

		if ((MyController2.Buttons & GRIP_BTN) || (MyController2.Buttons & THUMB_BTN) || (MyController2.Buttons & A_BTN) ||
			(MyController2.Buttons & B_BTN) || (MyController2.Buttons & MENU_BTN) || (MyController2.Buttons & SYS_BTN)) {
			printf("Buttons pressed: ");
			if (MyController2.Buttons & GRIP_BTN) printf("GRIP ");
			if (MyController2.Buttons & THUMB_BTN) printf("Thumbstick ");
			if (MyController2.Buttons & A_BTN) printf("A ");
			if (MyController2.Buttons & B_BTN) printf("B ");
			if (MyController2.Buttons & MENU_BTN) printf("Menu ");
			if (MyController2.Buttons & SYS_BTN) printf("System ");
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
			SetControllerData(1, 100);
			SetControllerData(2, 100);
		}

	}

	//Disable VR display
	if (ScreenControl)
		DisplayDisable(ScreenIndex);

	FreeLibrary(hDll);
	hDll = nullptr;

	return 0;
}
