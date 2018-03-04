unit uDutyUser;

interface
uses
  InvokeRegistry,Classes,Contnrs;
type
  TRsDutyUser = class(TRemotable)
  private
    m_strDutyGUID : string;
    m_strDutyNumber : string;
    m_strDutyName : string;
    m_strPassword : string;
    m_strTokenID : string;
  published
    property strDutyGUID : string read m_strDutyGUID write m_strDutyGUID;
    property strDutyNumber : string read m_strDutyNumber write m_strDutyNumber;
    property strDutyName : string read m_strDutyName write m_strDutyName;
    property strPassword : string read m_strPassword write m_strPassword;
    property strTokenID : string read m_strTokenID write m_strTokenID;

  public
    procedure Copy(sUser:TRsDutyUser);
  end;
  //管理员列表
  TRsDutyUserList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsDutyUser;
    procedure SetItem(Index: Integer; AObject: TRsDutyUser);
  public
    function Add(AObject: TRsDutyUser): Integer;
    property Items[Index: Integer]: TRsDutyUser read GetItem write SetItem; default;
  end;


implementation

{ TRsDutyUserList }

function TRsDutyUserList.Add(AObject: TRsDutyUser): Integer;
begin
  result := inherited Add(AObject);
end;

function TRsDutyUserList.GetItem(Index: Integer): TRsDutyUser;
begin
  result := TRsDutyUser(inherited GetItem(Index));
end;

procedure TRsDutyUserList.SetItem(Index: Integer; AObject: TRsDutyUser);
begin
  inherited SetItem(Index,AObject);
end;

{ TRsDutyUser }

procedure TRsDutyUser.Copy(sUser: TRsDutyUser);
begin
  self.m_strDutyGUID := sUser.strDutyGUID;
  self.m_strDutyNumber := sUser.strDutyNumber;
  self.m_strDutyName := sUser.strDutyName;
  self.m_strPassword := sUser.strPassword;
  self.m_strTokenID := sUser.strTokenID;
end;

end.
