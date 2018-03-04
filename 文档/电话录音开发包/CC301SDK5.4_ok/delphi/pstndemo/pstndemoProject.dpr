program pstndemoProject;

uses
  Forms,
  pstndemo in 'pstndemo.pas' {Form1},
  channeldata in 'channeldata.pas',
  brichiperr in '..\brichiperr.pas',
  brisdklib in '..\brisdklib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
