#include "stdafx.h"
#include <Windows.h>
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

//Other typedef structs in Library https://github.com/TrueOpenVR/TrueOpenVR-Core/tree/master/Library/

typedef DWORD(_stdcall *_GetHMDData)(__out THMD* myHMD);


int main()
{
	//Read main library path from registry
	CRegKey key;
	TCHAR libPath[MAX_PATH];
	
	LONG status = key.Open(HKEY_CURRENT_USER, _T("Software\\TrueOpenVR"));
	if (status == ERROR_SUCCESS)
	{
		ULONG libPathSize = sizeof(libPath);
		status = key.QueryStringValue(_T("Library"), libPath, &libPathSize);

		if (status != ERROR_SUCCESS)
		{
			printf("Error read library path\n");
			return 1;
		}
	}
	else
	{
		printf("Error open registry path TrueOpenVR");
		return 1;
	}
	key.Close();

	//Load main library
	HMODULE hDll = LoadLibrary(libPath);
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

	FreeLibrary(hDll);
	hDll = nullptr;

	system("pause");
	return 0;
}
