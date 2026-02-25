program TextToDiphone;

uses
  Forms,
  SysUtils,
  main in 'main.pas' {Form1},
  Options in 'Options.pas' {Form2},
  Func in '..\Unit Test\Func.pas',
  Unit1 in 'Unit1.pas' {Form11},
  Unit2 in 'Unit2.pas' {Form22};

{$R *.res}


begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm22, Form22);
  programpath:=ExtractFilePath(Application.ExeName);
  Application.Run;
end.
