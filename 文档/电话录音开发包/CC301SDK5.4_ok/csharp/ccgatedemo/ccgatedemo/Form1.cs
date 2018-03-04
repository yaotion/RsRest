using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

/**/

namespace ccgatedemo
{
    public partial class Form1 : Form
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct tag_Gate_Data
        {
            public Int16 uChannelID;//设备通道
            public Int32 lCCHandle;//CC呼叫句柄
            //[MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            //public Byte[] szCC;            
            public string szCC;
        }

        tag_Gate_Data[] m_tagGateData = new tag_Gate_Data[BriSDKLib.MAX_CHANNEL_COUNT];

        public Form1()
        {
            InitializeComponent();
        }

        private Int32 GetCCHandleGateID(Int32 lCCHandle)//获取CC呼叫句柄所在的数据结构ID(m_tagGateData)
        {
            for (int i = 0; i < BriSDKLib.MAX_CHANNEL_COUNT; i++)
            {
                if (m_tagGateData[i].lCCHandle == lCCHandle) return i;
            }
            return -1;
        }
        private Int32 StopCallCC(Int16 uChannelID)//停止转移到该CC
        {
            if (m_tagGateData[uChannelID].lCCHandle > 0)
            {
                BriSDKLib.QNV_CCCtrl_Call(BriSDKLib.QNV_CCCTRL_CALL_STOP, m_tagGateData[uChannelID].lCCHandle, "", 0);
                m_tagGateData[uChannelID].lCCHandle = 0;
                AppendStatus("通道线路断开，停止转移到CC");
                return 1;
            }
            else
                return 0;
        }
        private Int32 StopChannel(Int32 lCCHandle)//CC呼叫停止，断开通道PSTN线路
        {
            long lID = GetCCHandleGateID(lCCHandle);
            if (lID >= 0)
            {//如果已经是接通了
                if (BriSDKLib.QNV_GetDevCtrl(m_tagGateData[lID].uChannelID, BriSDKLib.QNV_CTRL_DOHOOK) > 0)
                {
                    BriSDKLib.QNV_SetDevCtrl(m_tagGateData[lID].uChannelID, BriSDKLib.QNV_CTRL_DOHOOK, 0);
                }
                else//还没有接通，直接调用拒接
                {
                    BriSDKLib.QNV_General(m_tagGateData[lID].uChannelID, BriSDKLib.QNV_GENERAL_STARTREFUSE, 0, "");
                }
                AppendStatus("停止通道转移");
                m_tagGateData[lID].lCCHandle = 0;
                return 1;
            }
            else
                return 0;
        }
        private Int32 AnswerCCHandle(Int32 lCCHandle)//CC接通，同时接通PSTN
        {
            long lID = GetCCHandleGateID(lCCHandle);
            if (lID >= 0)
            {
                return AnswerChannel((Int16)lID);
            }
            else
                return 0;
        }
        private Int32 AnswerChannel(Int32 uChannelID)//接通PSTN
        {
            BriSDKLib.QNV_SetDevCtrl((Int16)uChannelID, BriSDKLib.QNV_CTRL_DOHOOK, 1);//接通PSTN
            AppendStatus("接通线路");
            return 1;
        }
        private Int32 StartCallCC(BriSDKLib.TBriEvent_Data EventData)
        {
            AppendStatus("启动呼叫转移到CC");
            string strDestCC = destcc.Text;
            if (strDestCC.Length == 0 || strDestCC.Length > 18)
            {
                AppendStatus("目标CC号错误:" + strDestCC);
                return 0;
            }
            else
            {//呼叫CC，使用 pEvent->uChannelID通道做为语音输入输出设备                
                string  strCallParam = strDestCC;
                string strData = FromASCIIByteArray(EventData.szData);
                if (strData.Length > 0)//","分隔参数
                {
                    strCallParam += ",";
                    strCallParam += "2 1 ";//发送PSTN号码过去,(使用该格式可以兼容CC商务终端,如果转移到的目标CC是使用CC商务终端登陆的话就可以在界面弹出接收到的来电号码)
                    strCallParam += strData;
                }
                m_tagGateData[EventData.uChannelID].lCCHandle = BriSDKLib.QNV_CCCtrl_Call(BriSDKLib.QNV_CCCTRL_CALL_START, 0, strCallParam, EventData.uChannelID);
                if (m_tagGateData[EventData.uChannelID].lCCHandle > 0)
                {
                    m_tagGateData[EventData.uChannelID].uChannelID = EventData.uChannelID;
                    m_tagGateData[EventData.uChannelID].szCC=strDestCC;
                    AppendStatus("启动呼叫转移成功 CC:" + strDestCC);
                    //----------
                    //如果直接先接通，因为正在转移CC，无任何声音，就需要考虑给对方播放等候提示音，等CC接通后停止播放提示音
                    //AnswerChannel(pEvent->uChannelID);
                    //
                    return 1;
                }
                else
                {
                    AppendStatus("呼叫CC失败:" + strDestCC);
                    return 0;
                }
            }            
        }

        private void AppendStatus(string ms)
        {
            if(msg.Text.Length != 0) msg.Text += "\r\n";
            msg.Text += ms;            
        }
        public static string FromUnicodeByteArray(byte[] characters)
        {            
            UnicodeEncoding u = new UnicodeEncoding();
            string ustring = u.GetString(characters);
            return ustring;            
        }
        public static string FromASCIIByteArray(byte[] characters)
        {
            ASCIIEncoding encoding = new ASCIIEncoding();
            string constructedString = encoding.GetString(characters);
            return (constructedString);      
        }
       
       protected override void DefWndProc(ref System.Windows.Forms.Message m)
       {
           switch(m.Msg)
           {
               case BriSDKLib.BRI_EVENT_MESSAGE:
                   {                       
                       BriSDKLib.TBriEvent_Data EventData = (BriSDKLib.TBriEvent_Data)Marshal.PtrToStructure(m.LParam, typeof(BriSDKLib.TBriEvent_Data));
                       string strValue="";
                       //AppendStatus("接收到消息:" + " type=" + EventData.lEventType.ToString() + " result=" + EventData.lResult + " data=" + FromASCIIByteArray(EventData.szData));
                       switch (EventData.lEventType)
                       {
                           case BriSDKLib.BriEvent_PhoneHook:
                               {
                                   strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：电话机摘机";
                               }break;
                           case BriSDKLib.BriEvent_PhoneHang:
                               {
                                   strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：电话机挂机";
                               } break;
                           case BriSDKLib.BriEvent_CallIn:
                               {////两声响铃结束后开始呼叫转移到CC
                                   if (EventData.lResult == 2
                                       && FromASCIIByteArray(EventData.szData) == BriSDKLib.RING_END_SIGN_CH
                                       && m_tagGateData[EventData.uChannelID].lCCHandle == 0)
                                   {
                                       StartCallCC(EventData);
                                       return;
                                   }
                                   else
                                   {
                                       strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：来电响铃";
                                   }
                               }break;
                           case BriSDKLib.BriEvent_GetCallID:
                               {
                                   strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：接收到来电号码 " + FromASCIIByteArray(EventData.szData);
                                   //如果接收到来电号码就立即开始呼叫转移到CC
                                   StartCallCC(EventData);
                                   //                                   
                               } break;
                           case BriSDKLib.BriEvent_StopCallIn:
                               {
                                   StopCallCC(EventData.uChannelID);
                                   strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：停止呼入，产生一个未接电话 ";
                               } break;
                           case BriSDKLib.BriEvent_GetDTMFChar: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：接收到按键 " + FromASCIIByteArray(EventData.szData); break;
                           case BriSDKLib.BriEvent_RemoteHang:
                               {
                                   StopCallCC(EventData.uChannelID);
                                   strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：远程挂机 ";                                   
                               } break;
                           case BriSDKLib.BriEvent_Busy:
                               {
                                   StopCallCC(EventData.uChannelID);
                                   strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：接收到忙音,线路已经断开 ";
                               } break;
                           case BriSDKLib.BriEvent_DialTone: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：检测到拨号音 "; break;
                           case BriSDKLib.BriEvent_PhoneDial: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：电话机拨号 "+ FromASCIIByteArray(EventData.szData); break;
                           case BriSDKLib.BriEvent_RingBack: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：拨号后接收到回铃音 "; break;
                           case BriSDKLib.BriEvent_CC_ConnectFailed: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：连接CC服务器失败 "; break;
                           case BriSDKLib.BriEvent_CC_LoginFailed://登陆失败
                               {
                                   strValue = "登陆失败 原因="+EventData.lResult.ToString();
                                   BriSDKLib.QNV_CCCtrl(BriSDKLib.QNV_CCCTRL_LOGOUT, "", 0);//释放资源
                                   MessageBox .Show("登陆失败");
                               } break;
                           case BriSDKLib.BriEvent_CC_CallOutSuccess: strValue = "正在呼叫"; break;
                           case BriSDKLib.BriEvent_CC_CallOutFailed:
                               {
                                   BriSDKLib.QNV_CCCtrl_Call(BriSDKLib.QNV_CCCTRL_CALL_STOP, EventData.lEventHandle, "", 0);//停止CC呼叫
                                   StopChannel(EventData.lEventHandle);//停止PSTN通道                                   
                                   strValue = "呼叫失败 原因="+EventData.lResult.ToString();
                               } break;
                           case BriSDKLib.BriEvent_CC_Connected:
                               {
                                   AnswerCCHandle(EventData.lEventHandle);
                                   strValue = "CC已经连通";
                               } break;
                           case BriSDKLib.BriEvent_CC_CallFinished:
                               {
                                   StopChannel(EventData.lEventHandle);
                                   strValue = "呼叫结束 原因="+EventData.lResult.ToString();
                               } break;
                           case BriSDKLib.BriEvent_CC_LoginSuccess: strValue = "CC登陆成功"; break;
                           case BriSDKLib.BriEvent_CC_CallIn: break;
                           case BriSDKLib.BriEvent_CC_ReplyBusy: strValue = "CC对方回复忙"; break;
                           case BriSDKLib.BriEvent_CC_RecvedMsg: strValue = "CC接收到消息"; break;
                           case BriSDKLib.BriEvent_CC_RecvedCmd: strValue = "CC接收到命令"; break;
                           default: break;
                       }
                       if (strValue.Length > 0)
                       {
                           AppendStatus(strValue);
                       }
                   }break;
                default:
                     base.DefWndProc(ref m);
                     break;
           }
        }

        private void opendevice_Click(object sender, EventArgs e)
        {
            if (BriSDKLib.QNV_OpenDevice(BriSDKLib.ODT_LBRIDGE, 0, "") <= 0 || BriSDKLib.QNV_DevInfo(0, BriSDKLib.QNV_DEVINFO_GETCHANNELS) <= 0)
            {
                AppendStatus("打开设备失败");
                MessageBox.Show("打开设备失败");
                return;
            }
            for (Int16 i = 0; i < BriSDKLib.QNV_DevInfo(-1, BriSDKLib.QNV_DEVINFO_GETCHANNELS); i++)
            {//在windowproc处理接收到的消息
                BriSDKLib.QNV_Event(i, BriSDKLib.QNV_EVENT_REGWND, (Int32)this.Handle, "", new StringBuilder(0), 0);
            }

            //打开CC模块
            if (BriSDKLib.QNV_OpenDevice(BriSDKLib.ODT_CC, 0, BriSDKLib.QNV_CC_LICENSE) <= 0)//加载CC模块
            {
                AppendStatus("加载CC模块失败");
                MessageBox.Show("加载CC模块失败");
                return ;
            }
            else
            {
                //注册本窗口接收CC模块的事件
                //在windowproc处理接收到的消息
                BriSDKLib.QNV_Event(BriSDKLib.CCCTRL_CHANNELID, BriSDKLib.QNV_EVENT_REGWND, (Int32)this.Handle, "", new StringBuilder(0), 0);
                AppendStatus("加载CC模块完成");
            }            
            AppendStatus("打开设备成功");
            return ;
        }

        private void CloseDevice_Click(object sender, EventArgs e)
        {
            BriSDKLib.QNV_CloseDevice(BriSDKLib.ODT_ALL, 0);
            AppendStatus("设备已关闭");
        }

        private void logoutbtn_Click(object sender, EventArgs e)
        {
            BriSDKLib.QNV_CCCtrl(BriSDKLib.QNV_CCCTRL_LOGOUT, "", 0);
            AppendStatus("CC已经离线");	
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void setserver_Click(object sender, EventArgs e)
        {
            if (BriSDKLib.QNV_CCCtrl(BriSDKLib.QNV_CCCTRL_SETSERVER, ccsvraddr.Text, 0) <= 0)
            {
                AppendStatus("修改服务器IP地址失败 " + ccsvraddr.Text);
            }
            else
                AppendStatus("修改服务器IP地址完成,可以重新登陆.. " + ccsvraddr.Text);
        }

        private void logonbtn_Click(object sender, EventArgs e)
        {
            if (BriSDKLib.QNV_CCCtrl(BriSDKLib.QNV_CCCTRL_ISLOGON, "", 0) > 0)
            {
                BriSDKLib.QNV_CCCtrl(BriSDKLib.QNV_CCCTRL_LOGOUT, "", 0);
                AppendStatus("已经在线,先离线.");
            }
            string strValue = cccode.Text + "," + ccpwd.Text;//','分隔
            if (BriSDKLib.QNV_CCCtrl(BriSDKLib.QNV_CCCTRL_LOGIN, strValue, 0) <= 0)//开始登陆
            {
                MessageBox.Show("登陆失败,CC:" + cccode.Text);
            }
            else
                AppendStatus("开始登陆,CC: " + cccode.Text);	
        }

        private void ccpwd_TextChanged(object sender, EventArgs e)
        {

        }

        private void Form1_Close(object sender, FormClosedEventArgs e)
        {
            BriSDKLib.QNV_CloseDevice(BriSDKLib.ODT_ALL, 0);
        }
    }
}
