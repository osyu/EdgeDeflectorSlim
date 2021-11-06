#pragma comment(linker, "/SUBSYSTEM:windows /ENTRY:wmainCRTStartup")
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "shell32.lib")
#pragma comment(lib, "shlwapi.lib")
#include <objbase.h>
#include <shellapi.h>
#include <shlwapi.h>
#include <string.h>
#include <wchar.h>

int wmain(int argc, wchar_t **argv)
{
    if (argc == 2)
    {
        wchar_t *uri = argv[1];

        if (wcsncmp(uri, L"microsoft-edge:", 15) == 0)
        {
            uri += 15;

            if (*uri == L'?')
            {
                uri = wcsstr(uri, L"url=");
            
                if (uri == NULL)
                {
                    return 0;
                }

                uri += 4;
                UrlUnescapeW(uri, NULL, NULL, URL_UNESCAPE_AS_UTF8 | URL_UNESCAPE_INPLACE);
            }

            if (*uri == L'\0')
            {
                return 0;
            }

            if (wcsncmp(uri, L"http://", 7) != 0 && wcsncmp(uri, L"https://", 8) != 0)
            {
                uri -= 7;
                wmemcpy(uri, L"http://", 7);
            }

            CoInitializeEx(NULL, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
            ShellExecuteW(NULL, L"open", uri, NULL, NULL, SW_SHOWNORMAL);
            CoUninitialize();
        }
    }

    return 0;
}
