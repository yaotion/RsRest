unit uArea;

interface
type
  /////////////////////////////////////////////////////////////////////////////
  ///  说明:区域对象
  //////////////////////////////////////////////////////////////////////////////
  RRsArea = record
  public
    {区域ID}
    strAreaGUID : String;
    {区域名称}
    strAreaName : String;
    {机务段号}
    strJWDNumber : String;
    {机务段名称}
    strJWDName : String;
  end;

  TAreaArray = array of RRsArea;
implementation

end.
