program faxdemoProject;

uses
  Forms,
  faxmain in 'faxmain.pas' {Form1},
  sendfax in 'sendfax.pas' {sendfaxform},
  recvfax in 'recvfax.pas' {recvfaxform},
  brisdklib in '..\brisdklib.pas',
  brichiperr in '..\brichiperr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tsendfaxform, sendfaxform);
  Application.CreateForm(Trecvfaxform, recvfaxform);
  Application.Run;
end.
