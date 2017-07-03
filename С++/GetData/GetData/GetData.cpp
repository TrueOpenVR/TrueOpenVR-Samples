#include "stdafx.h"
#include <Windows.h>

typedef struct _HMDData
{
	double	X;
	double	Y;
	double	Z;
	double	Yaw;
	double	Pitch;
	double	Roll;
} THMD, *PHMD;

//Other typedef structs in Library https://github.com/TrueOpenVR/TrueOpenVR-Core/tree/master/Library/

typedef DWORD(_stdcall *_GetHMDData)(__out THMD* myHMD);


int main()
{
	//Path to "TOVR.dll" on Registry - "HKEY_CURRENT_USER\Software\TrueOpenVR" parameter "Library"
	HMODULE hDll = LoadLibrary(L"TOVR.dll");
	if (hDll == NULL) {
		printf("ERROR: unable to load DLL\n");
		return 1;
	}

	THMD myHMD;

	ZeroMemory(&myHMD, sizeof(THMD));

	_GetHMDData GetHMDData;

	GetHMDData = (_GetHMDData)GetProcAddress(hDll, "GetHMDData");

	if (GetHMDData == NULL) {
		printf("ERROR: unable to find DLL function\n");
		return 1;
	}

	DWORD iResult = GetHMDData(&myHMD);

	Sleep(300);

	GetHMDData(&myHMD);

	printf("Result = %d\n", iResult);

	printf("X = %f\nY = %f\nZ = %f\nYaw = %f\nPitch = %f\nRoll = %f\n\n", myHMD.X, myHMD.Y, myHMD.Z, myHMD.Yaw, myHMD.Pitch, myHMD.Roll);

	system("pause");
	FreeLibrary(hDll);
	hDll = nullptr;
	return 0;
}
