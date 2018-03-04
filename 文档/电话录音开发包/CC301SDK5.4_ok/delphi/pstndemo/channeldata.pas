unit channeldata;

interface

type
  TChannel_Data = record
    lPlayFileID:longint;
    lRecFileID:longint;
  end;

const MaxChannelNumber = 16;//最多支持16路
var ChannelStatus : Array [0..MaxChannelNumber] of TChannel_Data;

implementation

end.
 