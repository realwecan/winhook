unit TestHookKey_Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
  WM_HOOKKEY= WM_USER + $1000;
  HookDLL       = 'Key.dll';
type
  THookProcedure=procedure; stdcall;
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FileMapHandle  : THandle;
    PMem     : ^Integer;
    HandleDLL      : THandle;
    HookOn,
    HookOff        : THookProcedure;
    procedure HookKey(var message: TMessage); message  WM_HOOKKEY;

  public
    { Public declarations }
  end;
var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.ReadOnly:=TRUE;
  Memo1.Clear;
  HandleDLL:=LoadLibrary( PChar(ExtractFilePath(Application.Exename)+
                                HookDll) );
  if HandleDLL = 0 then raise Exception.Create('未发现键盘钩子DLL');
  @HookOn :=GetProcAddress(HandleDLL, 'HookOn');
  @HookOff:=GetProcAddress(HandleDLL, 'HookOff');
  IF not assigned(HookOn) or
     not assigned(HookOff)  then
     raise Exception.Create('在给定的 DLL中'+#13+
                            '未发现所需的函数');

  FileMapHandle:=CreateFileMapping( $FFFFFFFF,
                              nil,
                              PAGE_READWRITE,
                              0,
                              SizeOf(Integer),
                              'TestHook');

   if FileMapHandle=0 then
     raise Exception.Create( '创建内存映射文件时出错');
   PMem:=MapViewOfFile(FileMapHandle,FILE_MAP_WRITE,0,0,0);
   PMem^:=Handle;
   HookOn;
end;
procedure TForm1.HookKey(var message: TMessage);
var
   KeyName : array[0..100] of char;
   Accion      : string;
begin
  GetKeyNameText(Message.LParam,@KeyName,100);
  if ((Message.lParam shr 31) and 1)=1
      then Accion:='Key Up'
  else
  if ((Message.lParam shr 30) and 1)=1
      then Accion:='ReKeyDown'
      else Accion:='KeyDown';
  Memo1.Lines.add( Accion+
                      ': '+
                      String(KeyName)) ;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 if Assigned(HookOff) then
     HookOff;
 if HandleDLL<>0 then
  FreeLibrary(HandleDLL);
  if FileMapHandle<>0 then
  begin
    UnmapViewOfFile(PMem);
    CloseHandle(FileMapHandle);
  end;

end;

end.
