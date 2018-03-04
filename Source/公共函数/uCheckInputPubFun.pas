unit uCheckInputPubFun;

interface
uses
  Classes,StdCtrls,SysUtils;
type
  //校验数据公共函数
  TCheckInputPF= class
  public
    //验空
    class function bEmpty(edt:TEdit):Boolean;
  end;

implementation

{ TCheckPubFun }

class function TCheckInputPF.bEmpty(edt:TEdit): Boolean;
begin
  result := False;
  if Trim(edt.Text) = ''  then
  begin
    edt.SetFocus;
    Exit;
  end;
  result := True;

end;

end.
