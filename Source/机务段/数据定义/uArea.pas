unit uArea;

interface
type
  /////////////////////////////////////////////////////////////////////////////
  ///  ˵��:�������
  //////////////////////////////////////////////////////////////////////////////
  RRsArea = record
  public
    {����ID}
    strAreaGUID : String;
    {��������}
    strAreaName : String;
    {����κ�}
    strJWDNumber : String;
    {���������}
    strJWDName : String;
  end;

  TAreaArray = array of RRsArea;
implementation

end.
