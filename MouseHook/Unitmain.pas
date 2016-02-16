
unit Unitmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,UnitHookConst;

type
  TForm1 = class(TForm)
    capture: TButton;
    Panel1: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button1: TButton;
    procedure captureClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  procedure WndProc(var Messages: TMessage); override;
end;

var
  Form1: TForm1;
  hMappingFile : THandle;
  pShMem : PShareMem;
const MessageID = WM_User + 100;

implementation

  {$R *.DFM}
  function StartHook(sender : HWND;MessageID : WORD) : BOOL;stdcall; external 'DllMouse.DLL';
  function StopHook: BOOL;stdcall; external 'DllMouse.DLL';
  procedure GetRbutton; stdcall; external 'DllMouse.DLL';

procedure TForm1.captureClick(Sender: TObject);
begin
  if capture.caption='开始' then
  begin
     if StartHook(Form1.Handle,MessageID) then
       capture.caption:='停止';
  end
  else begin
    if StopHook then
       capture.caption:='开始';
  end;
end;

procedure TForm1.WndProc(var Messages: TMessage);
var
   x,y:integer;
   s:array[0..255]of char;
begin
   if pShMem = nil then
   begin
        hMappingFile := OpenFileMapping(FILE_MAP_WRITE,False,MappingFileName);
        if hMappingFile=0 then Exception.Create('不能建立共享内存!');
        pShMem :=  MapViewOfFile(hMappingFile,FILE_MAP_WRITE or FILE_MAP_READ,0,0,0);
        if pShMem = nil then
        begin
           CloseHandle(hMappingFile);
           Exception.Create('不能映射共享内存!');
        end;
   end;
   if pShMem = nil then exit;   
  if Messages.Msg = MessageID then
  begin
    x:=pShMem^.data2.pt.x;
    y:=pShMem^.data2.pt.y;
    edit3.text:='HWND:'+inttostr(pShMem^.data2.hwnd);
    panel1.caption:='x='+inttostr(x)+' y='+inttostr(y);
    edit2.text:='WindowsText:'+string(pShMem^.buffer);
    getClassName(pShMem^.data2.hwnd,s,255);
    edit1.text:='ClassName:"'+string(s)+'"';
  end
  else if Messages.Msg = MessageID+1 then
  begin
    edit4.text:=inttostr(pShMem^.data2.hwnd);
    edit5.text:='WindowsText:'+string(pShMem^.buffer);
    getClassName(pShMem^.data2.hwnd,s,255);
    edit6.text:='ClassName:"'+string(s)+'"';
  end
  else Inherited;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if capture.caption='开始' then
  begin
  end
  else begin
    if StopHook then
       capture.caption:='开始';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   if capture.caption<>'开始' then
   begin
      edit4.text:='';
      edit5.text:='';
      edit6.text:='';
      GetRbutton;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   pShMem := nil;
end;

end.



