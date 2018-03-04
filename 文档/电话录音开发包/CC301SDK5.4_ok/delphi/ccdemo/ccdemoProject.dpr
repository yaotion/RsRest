program ccdemoProject;

uses
  Forms,
  ccctrl in 'ccctrl.pas' {Form1},
  brisdklib in '..\brisdklib.pas',
  brichiperr in '..\brichiperr.pas',
  msgform in 'msgform.pas' {ccmsgd},
  cmdform in 'cmdform.pas' {cccmdd},
  callform in 'callform.pas' {cccalld},
  logincc in 'logincc.pas' {Loginwin},
  regccform in 'regccform.pas' {regccd},
  inputsvrform in 'inputsvrform.pas' {inputsvrd},
  filetransform in 'filetransform.pas' {filetransd},
  QNVFILETRANSLib_TLB in 'C:\Program Files\Borland\Delphi6\Imports\QNVFILETRANSLib_TLB.pas',
  inputccform in 'inputccform.pas' {inputccd},
  sendfileform in 'sendfileform.pas' {sendfiled},
  contactform in 'contactform.pas' {cccontactd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tccmsgd, ccmsgd);
  Application.CreateForm(Tcccmdd, cccmdd);
  Application.CreateForm(Tcccalld, cccalld);
  Application.CreateForm(TLoginwin, Loginwin);
  Application.CreateForm(Tregccd, regccd);
  Application.CreateForm(Tinputsvrd, inputsvrd);
  Application.CreateForm(Tfiletransd, filetransd);
  Application.CreateForm(Tinputccd, inputccd);
  Application.CreateForm(Tsendfiled, sendfiled);
  Application.CreateForm(Tcccontactd, cccontactd);
  Application.Run;
end.
