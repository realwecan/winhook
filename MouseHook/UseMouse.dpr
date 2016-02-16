program UseMouse;

uses
  Forms,
  Unitmain in 'Unitmain.pas' {Form1},
  UnitHookConst in 'UnitHookConst.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
