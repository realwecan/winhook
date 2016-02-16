unit UnitHookDLL;

interface

uses Windows, Messages, Dialogs, SysUtils,UnitHookConst;


var
  hMappingFile : THandle;
  pShMem : PShareMem;
  FirstProcess : boolean;
  NextHook: HHook;

  function StartHook(sender : HWND;MessageID : WORD) : BOOL; stdcall;
  function StopHook: BOOL; stdcall;
  procedure GetRbutton; stdcall;

implementation

procedure GetRbutton; stdcall;
begin
   pShMem^.IfRbutton:=true;
end;

function HookHandler(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; export;
begin
  Result := 0;
  If iCode < 0 Then Result := CallNextHookEx(NextHook, iCode, wParam, lParam);

  case wparam of
  WM_LBUTTONDOWN:
    begin
    end;
  WM_LBUTTONUP:
    begin
    end;
  WM_LBUTTONDBLCLK:
    begin
    end;
  WM_RBUTTONDOWN:
    begin
      if pShMem^.IfRbutton then
      begin
         pShMem^.IfRbutton := false;
         pShMem^.data2:=pMOUSEHOOKSTRUCT(lparam)^;
         getwindowtext(pShMem^.data2.hwnd,pShMem^.buffer,1024);
         SendMessage(pShMem^.data1[1],pShMem^.data1[2]+1,wParam,integer(@(pShMem^.data2)) );
         //             窗口                   消息                        坐标
      end;
    end;
  WM_RBUTTONUP:
    begin
    end;
  WM_RBUTTONDBLCLK:
    begin
    end;
  WM_MBUTTONDOWN:
    begin
    end;
  WM_MBUTTONUP:
    begin
    end;
  WM_MBUTTONDBLCLK:
    begin
    end;
  WM_NCMouseMove, WM_MOUSEMOVE:
    begin
      pShMem^.data2:=pMOUSEHOOKSTRUCT(lparam)^;
      getwindowtext(pShMem^.data2.hwnd,pShMem^.buffer,1024);
      SendMessage(pShMem^.data1[1],pShMem^.data1[2],wParam,integer(@(pShMem^.data2)) );
      //             窗口                   消息                        坐标
    end;
  end;
end;

function StartHook(sender : HWND;MessageID : WORD) : BOOL;
  function GetModuleHandleFromInstance: THandle;
  var
    s: array[0..512] of char;
  begin
    GetModuleFileName(hInstance, s, sizeof(s)-1);
    Result := GetModuleHandle(s);
  end;
begin
  Result := False;
  if NextHook <> 0 then Exit;
  pShMem^.data1[1]:=sender;
  pShMem^.data1[2]:=messageid;
  NextHook :=
     SetWindowsHookEx(WH_mouse, HookHandler, HInstance, 0);  //全局
     //SetWindowsHookEx(WH_mouse, HookHandler, GetModuleHandleFromInstance, GetCurrentThreadID); //实例
  Result := NextHook <> 0;
end;

function StopHook: BOOL;
begin
  if NextHook <> 0 then
  begin
    UnhookWindowshookEx(NextHook);
    NextHook := 0;
    //SendMessage(HWND_BROADCAST,WM_SETTINGCHANGE,0,0);
  end;
  Result := NextHook = 0;
end;

initialization
        hMappingFile := OpenFileMapping(FILE_MAP_WRITE,False,MappingFileName);
        if hMappingFile=0 then
        begin
           hMappingFile := CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TShareMem),MappingFileName);
           FirstProcess:=true;
        end
        else FirstProcess:=false;
        if hMappingFile=0 then Exception.Create('不能建立共享内存!');

        pShMem :=  MapViewOfFile(hMappingFile,FILE_MAP_WRITE or FILE_MAP_READ,0,0,0);
        if pShMem = nil then
        begin
           CloseHandle(hMappingFile);
           Exception.Create('不能映射共享内存!');
        end;
        if FirstProcess then
        begin
           pShmem^.IfRbutton := false;
        end;
        NextHook:=0;
finalization
        UnMapViewOfFile(pShMem);
        CloseHandle(hMappingFile);

end.




