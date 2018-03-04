unit uDBStation;

interface
uses
  ADODB,Classes,uTFSystem,uStation,SysUtils;
type
  //��վ���ݿ����
  TRSDBStation = class(TDBOperate)
  public
    //���Ӽ�¼
    procedure Add(station :RRsStation);
    //ͬ����¼
    procedure Sync(stationAry: TRsStationArray);

  public
    //ado������
     procedure Ado2Obj(qry:TADOQuery;station:RRsStation);
    //����ado
     procedure Obj2Ado(station:RRsStation;qry:TADOQuery);
  end; 

implementation

{ TDBStation }

procedure TRSDBStation.Add(station: RRsStation);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_Station where strStationGUID = :strStationGUID';
    qry.Parameters.ParamByName('strStationGUID').Value := station.strStationGUID;
    qry.Open;
    if qry.RecordCount =0 then
      qry.Append
    else
      qry.Edit;
    Obj2Ado(station,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRSDBStation.Ado2Obj(qry: TADOQuery; station: RRsStation);
begin
  station.strStationGUID := qry.FieldByName('strStationGUID').Value;
  station.strStationNumber := qry.FieldByName('strStationNumber').Value;
  station.strStationName := qry.FieldByName('strStationName').Value;
  station.strWorkShopGUID := qry.FieldByName('strWorkShopGUID').Value;
  station.strStationPY := qry.FieldByName('strStationPY').Value;
end;

procedure TRSDBStation.Obj2Ado(station: RRsStation; qry: TADOQuery);
begin
  qry.FieldByName('strStationGUID').Value := station.strStationGUID;
  qry.FieldByName('strStationNumber').Value := station.strStationNumber;
  qry.FieldByName('strStationName').Value := station.strStationName;
  qry.FieldByName('strWorkShopGUID').Value := station.strWorkShopGUID;
  qry.FieldByName('strStationPY').Value := station.strStationPY;
end;

procedure TRSDBStation.Sync(stationAry: TRsStationArray);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry:= NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_base_station';
      qry.ExecSQL;
      for i := 0 to Length(stationAry) - 1 do
      begin
        self.Add(stationAry[i]);
      end;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

end.
