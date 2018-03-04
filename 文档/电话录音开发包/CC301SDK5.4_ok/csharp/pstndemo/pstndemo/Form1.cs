using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;


namespace pstndemo
{
    public partial class Form1 : Form
    {

        [StructLayout(LayoutKind.Sequential)]
        public struct tag_pstn_Data
        {
            public Int16 uChannelID;//设备通道
            public Int32 lPlayFileHandle;//播放句柄
            public Int32 lRecFileHandle;//录音句柄            
        }

        tag_pstn_Data[] m_tagpstnData = new tag_pstn_Data[BriSDKLib.MAX_CHANNEL_COUNT];


        public Form1()
        {
            InitializeComponent();
        }

        private void AppendStatus(string ms)
        {
            if (msg.Text.Length != 0) msg.Text += "\r\n";
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
            switch (m.Msg)
            {
                case BriSDKLib.BRI_EVENT_MESSAGE:
                    {
                        BriSDKLib.TBriEvent_Data EventData = (BriSDKLib.TBriEvent_Data)Marshal.PtrToStructure(m.LParam, typeof(BriSDKLib.TBriEvent_Data));
                        string strValue = "";
                        switch (EventData.lEventType)
                        {
                            case BriSDKLib.BriEvent_PhoneHook:
                                {
                                    strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：电话机摘机";
                                } break;
                            case BriSDKLib.BriEvent_PhoneHang:
                                {
                                    strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：电话机挂机";
                                } break;
                            case BriSDKLib.BriEvent_CallIn:
                                {////两声响铃结束后开始呼叫转移到CC
                                    strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：来电响铃";
                                } break;
                            case BriSDKLib.BriEvent_GetCallID:
                                {
                                    strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：接收到来电号码 " + FromASCIIByteArray(EventData.szData);
                                    
                                } break;
                            case BriSDKLib.BriEvent_StopCallIn:
                                {                                    
                                    strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：停止呼入，产生一个未接电话 ";
                                } break;
                            case BriSDKLib.BriEvent_GetDTMFChar: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：接收到按键 " + FromASCIIByteArray(EventData.szData); break;
                            case BriSDKLib.BriEvent_RemoteHang:
                                {                                  
                                    strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：远程挂机 ";
                                } break;
                            case BriSDKLib.BriEvent_Busy:
                                {
                                 
                                    strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：接收到忙音,线路已经断开 ";
                                } break;
                            case BriSDKLib.BriEvent_DialTone: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：检测到拨号音 "; break;
                            case BriSDKLib.BriEvent_PhoneDial: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：电话机拨号 " + FromASCIIByteArray(EventData.szData); break;
                            case BriSDKLib.BriEvent_RingBack: strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：拨号后接收到回铃音 "; break;
                            case BriSDKLib.BriEvent_DevErr:
                                {
                                    if (EventData.lResult == 3)
                                    {
                                        strValue = "通道" + (EventData.uChannelID + 1).ToString() + "：设备可能被移除 ";
                                    }
                                } break;
                            default: break;
                        }
                        if (strValue.Length > 0)
                        {
                            AppendStatus(strValue);
                        }
                    } break;
                default:
                    base.DefWndProc(ref m);
                    break;
            }
        }

        private void opendev_Click(object sender, EventArgs e)
        {
            if (BriSDKLib.QNV_OpenDevice(BriSDKLib.ODT_LBRIDGE, 0, "") <= 0 || BriSDKLib.QNV_DevInfo(0, BriSDKLib.QNV_DEVINFO_GETCHANNELS) <= 0)
            {
                AppendStatus("打开设备失败");
                MessageBox.Show("打开设备失败");
                return;
            }
            selchannel.Items.Clear();
            spkamvalue.Items.Clear();
            micamvalue.Items.Clear();

            for (Int16 i = 0; i < BriSDKLib.QNV_DevInfo(-1, BriSDKLib.QNV_DEVINFO_GETCHANNELS); i++)
            {//在windowproc处理接收到的消息
                BriSDKLib.QNV_Event(i, BriSDKLib.QNV_EVENT_REGWND, (Int32)this.Handle, "", new StringBuilder(0), 0);
                selchannel.Items.Add(i+1);               
            }
            selchannel.SelectedIndex = 0;

            for (int i = 0; i < 16; i++)
            {
                spkamvalue.Items.Add(i);
            }
            spkamvalue.SelectedIndex = 0;

            for (int i = 0; i < 7; i++)
            {
                micamvalue.Items.Add(i);
            }
            micamvalue.SelectedIndex = 0;

            AppendStatus("打开设备成功");
            return;
        }

        private void closedev_Click(object sender, EventArgs e)
        {
            BriSDKLib.QNV_CloseDevice(BriSDKLib.ODT_ALL, 0);
            selchannel.Items.Clear();
            AppendStatus("设备已关闭");
        }

        private void dohook_CheckedChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetDevCtrl((short)selchannel.SelectedIndex, BriSDKLib.QNV_CTRL_DOHOOK, dohook.Checked ? 1 : 0);
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            BriSDKLib.QNV_CloseDevice(BriSDKLib.ODT_ALL, 0);
        }

        private void dophone_CheckedChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetDevCtrl((short)selchannel.SelectedIndex, BriSDKLib.QNV_CTRL_DOPHONE, dophone.Checked ? 0 : 1);
        }

        private void doline2spk_CheckedChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetDevCtrl((short)selchannel.SelectedIndex, BriSDKLib.QNV_CTRL_DOLINETOSPK, doline2spk.Checked ? 1 : 0);
        }

        private void doplay2spk_CheckedChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetDevCtrl((short)selchannel.SelectedIndex, BriSDKLib.QNV_CTRL_DOPLAYTOSPK, doplay2spk.Checked ? 1 : 0);
        }

        private void domic2line_CheckedChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetDevCtrl((short)selchannel.SelectedIndex, BriSDKLib.QNV_CTRL_DOMICTOLINE, domic2line.Checked ? 1 : 0);
        }

        private void doplay_CheckedChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetDevCtrl((short)selchannel.SelectedIndex, BriSDKLib.QNV_CTRL_DOPLAY, doplay.Checked ? 1 : 0);
        }

        private void startdial_Click(object sender, EventArgs e)
        {
            if (dialcode.Text.Length <= 0)
            {
                AppendStatus("拨号号码不能为空");
            }
            else
            {
                AppendStatus("开始拨号:" + dialcode.Text);
                BriSDKLib.QNV_General((short)selchannel.SelectedIndex, BriSDKLib.QNV_GENERAL_STARTDIAL, 0, dialcode.Text);
                dohook.Checked = true;//拨好时系统会自动摘机,改变显示状态
            }
        }

        private void refusecallin_Click(object sender, EventArgs e)
        {
            BriSDKLib.QNV_General((short)selchannel.SelectedIndex, BriSDKLib.QNV_GENERAL_STARTREFUSE, BriSDKLib.REFUSE_ASYN, "");
        }

        private void startflash_Click(object sender, EventArgs e)
        {
            BriSDKLib.QNV_General((short)selchannel.SelectedIndex, BriSDKLib.QNV_GENERAL_STARTFLASH, BriSDKLib.FT_ALL, "");
        }

        private void stopplayfile_Click(object sender, EventArgs e)
        {
            if (m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle > 0)
            {
                BriSDKLib.QNV_PlayFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_PLAY_FILE_STOP, m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle, 0, "");
                m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle = 0;
                AppendStatus("停止播放文件");
            }
        }

        private void pauseplayfile_Click(object sender, EventArgs e)
        {
            if (m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle > 0)
            {
                BriSDKLib.QNV_PlayFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_PLAY_FILE_PAUSE, m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle, 0, "");
            }
        }

        private void resumeplayfile_Click(object sender, EventArgs e)
        {
            if (m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle > 0)
            {
                BriSDKLib.QNV_PlayFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_PLAY_FILE_RESUME, m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle, 0, "");
            }
        }

        private void stoprecfile_Click(object sender, EventArgs e)
        {
            if (m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle > 0)
            {
                AppendStatus("停止文件录音 ID:" + m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle);
                long lRet=BriSDKLib.QNV_RecordFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_RECORD_FILE_STOP, m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle, 0, "");
                m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle = 0;
                AppendStatus("停止文件录音 Ret:" + lRet);
            }
        }

        private void pauserecfile_Click(object sender, EventArgs e)
        {
            if (m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle > 0)
            {
                BriSDKLib.QNV_RecordFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_RECORD_FILE_PAUSE, m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle, 0, "");
            }
        }

        private void resumerecfile_Click(object sender, EventArgs e)
        {
            if (m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle > 0)
            {
                BriSDKLib.QNV_RecordFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_RECORD_FILE_RESUME, m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle, 0, "");
            }
        }

        private void startplayfile_Click(object sender, EventArgs e)
        {
            {
                OpenFileDialog dlg = new OpenFileDialog();
                if (dlg.ShowDialog() == DialogResult.OK)
                {
                    //this.textBox1.Text = dlg.FileName;
                    //PLAYFILE_MASK_REPEAT 使用重复播放
                    m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle = BriSDKLib.QNV_PlayFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_PLAY_FILE_START, 0, BriSDKLib.PLAYFILE_MASK_REPEAT, dlg.FileName);
                    if (m_tagpstnData[(short)selchannel.SelectedIndex].lPlayFileHandle <= 0)
                    {
                        AppendStatus("播放文件失败:" + dlg.FileName);
                    }
                    else
                    {
                        AppendStatus("开始播放文件:" + dlg.FileName);
                    }
                }
            }
        }

        private void startrecfile_Click(object sender, EventArgs e)
        {
             SaveFileDialog dlg = new SaveFileDialog();
             if (dlg.ShowDialog() == DialogResult.OK)
             {
                 Int32 dwmask = 0;
                 if (echoenable.Checked) dwmask |= BriSDKLib.RECORD_MASK_ECHO;
                 if (agcenable.Checked) dwmask |= BriSDKLib.RECORD_MASK_AGC;
                 m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle = BriSDKLib.QNV_RecordFile((short)selchannel.SelectedIndex, BriSDKLib.QNV_RECORD_FILE_START, recformat.SelectedIndex, dwmask, dlg.FileName);
                 if (m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle <= 0)
                 {
                     AppendStatus("文件录音失败:" + dlg.FileName);
                 }
                 else
                 {
                     AppendStatus("开始文件录音:" + dlg.FileName);
                     AppendStatus("录音ID:" + m_tagpstnData[(short)selchannel.SelectedIndex].lRecFileHandle);
                 }
             }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            recformat.Items.Add("BRI_WAV_FORMAT_DEFAULT (BRI_AUDIO_FORMAT_PCM8K16B)");
            recformat.Items.Add("BRI_WAV_FORMAT_ALAW8K	 (8k/s)");            
            recformat.Items.Add("BRI_WAV_FORMAT_ULAW8K (8k/s)");            
            recformat.Items.Add("BRI_WAV_FORMAT_IMAADPCM8K4B (4k/s)");
            recformat.Items.Add("BRI_WAV_FORMAT_PCM8K8B (8k/s)");
            recformat.Items.Add("BRI_WAV_FORMAT_PCM8K16B (16k/s)");
            recformat.Items.Add("BRI_WAV_FORMAT_MP38K8B (1.2k/s)");
            recformat.Items.Add("BRI_WAV_FORMAT_MP38K16B( 2.4k/s)");
            recformat.Items.Add("BRI_WAV_FORMAT_TM8K1B (1.5k/s)");
            recformat.Items.Add("BRI_WAV_FORMAT_GSM6108K(2.2k/s)");
            recformat.SelectedIndex = 0;
        }

        private void spkamvalue_SelectedIndexChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetParam((short)selchannel.SelectedIndex, BriSDKLib.QNV_PARAM_AM_SPKOUT, spkamvalue.SelectedIndex);
        }

        private void micamvalue_SelectedIndexChanged(object sender, EventArgs e)
        {
            BriSDKLib.QNV_SetParam((short)selchannel.SelectedIndex, BriSDKLib.QNV_PARAM_AM_MIC, micamvalue.SelectedIndex);
        }
    }
}
