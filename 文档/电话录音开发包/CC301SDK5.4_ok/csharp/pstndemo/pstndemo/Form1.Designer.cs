namespace pstndemo
{
    partial class Form1
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.opendev = new System.Windows.Forms.Button();
            this.msg = new System.Windows.Forms.TextBox();
            this.closedev = new System.Windows.Forms.Button();
            this.selchannel = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.dialcode = new System.Windows.Forms.TextBox();
            this.startdial = new System.Windows.Forms.Button();
            this.startplayfile = new System.Windows.Forms.Button();
            this.stopplayfile = new System.Windows.Forms.Button();
            this.pauseplayfile = new System.Windows.Forms.Button();
            this.resumeplayfile = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.recformat = new System.Windows.Forms.ComboBox();
            this.echoenable = new System.Windows.Forms.CheckBox();
            this.agcenable = new System.Windows.Forms.CheckBox();
            this.startrecfile = new System.Windows.Forms.Button();
            this.stoprecfile = new System.Windows.Forms.Button();
            this.pauserecfile = new System.Windows.Forms.Button();
            this.resumerecfile = new System.Windows.Forms.Button();
            this.refusecallin = new System.Windows.Forms.Button();
            this.startflash = new System.Windows.Forms.Button();
            this.dohook = new System.Windows.Forms.CheckBox();
            this.dophone = new System.Windows.Forms.CheckBox();
            this.doline2spk = new System.Windows.Forms.CheckBox();
            this.doplay2spk = new System.Windows.Forms.CheckBox();
            this.domic2line = new System.Windows.Forms.CheckBox();
            this.doplay = new System.Windows.Forms.CheckBox();
            this.comboBox2 = new System.Windows.Forms.ComboBox();
            this.spkam = new System.Windows.Forms.Label();
            this.spkamvalue = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.micamvalue = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // opendev
            // 
            this.opendev.Location = new System.Drawing.Point(12, 210);
            this.opendev.Name = "opendev";
            this.opendev.Size = new System.Drawing.Size(76, 35);
            this.opendev.TabIndex = 0;
            this.opendev.Text = "打开设备";
            this.opendev.UseVisualStyleBackColor = true;
            this.opendev.Click += new System.EventHandler(this.opendev_Click);
            // 
            // msg
            // 
            this.msg.Location = new System.Drawing.Point(12, 1);
            this.msg.Multiline = true;
            this.msg.Name = "msg";
            this.msg.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.msg.Size = new System.Drawing.Size(631, 203);
            this.msg.TabIndex = 3;
            // 
            // closedev
            // 
            this.closedev.Location = new System.Drawing.Point(94, 211);
            this.closedev.Name = "closedev";
            this.closedev.Size = new System.Drawing.Size(84, 34);
            this.closedev.TabIndex = 4;
            this.closedev.Text = "关闭设备";
            this.closedev.UseVisualStyleBackColor = true;
            this.closedev.Click += new System.EventHandler(this.closedev_Click);
            // 
            // selchannel
            // 
            this.selchannel.FormattingEnabled = true;
            this.selchannel.Location = new System.Drawing.Point(289, 219);
            this.selchannel.Name = "selchannel";
            this.selchannel.Size = new System.Drawing.Size(73, 20);
            this.selchannel.TabIndex = 5;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(196, 225);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(89, 12);
            this.label1.TabIndex = 6;
            this.label1.Text = "当前控制通道：";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(19, 273);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(41, 12);
            this.label2.TabIndex = 7;
            this.label2.Text = "号码：";
            // 
            // dialcode
            // 
            this.dialcode.Location = new System.Drawing.Point(66, 270);
            this.dialcode.Name = "dialcode";
            this.dialcode.Size = new System.Drawing.Size(149, 21);
            this.dialcode.TabIndex = 8;
            // 
            // startdial
            // 
            this.startdial.Location = new System.Drawing.Point(221, 268);
            this.startdial.Name = "startdial";
            this.startdial.Size = new System.Drawing.Size(75, 23);
            this.startdial.TabIndex = 9;
            this.startdial.Text = "开始拨号";
            this.startdial.UseVisualStyleBackColor = true;
            this.startdial.Click += new System.EventHandler(this.startdial_Click);
            // 
            // startplayfile
            // 
            this.startplayfile.Location = new System.Drawing.Point(14, 337);
            this.startplayfile.Name = "startplayfile";
            this.startplayfile.Size = new System.Drawing.Size(86, 23);
            this.startplayfile.TabIndex = 10;
            this.startplayfile.Text = "开始播放文件";
            this.startplayfile.UseVisualStyleBackColor = true;
            this.startplayfile.Click += new System.EventHandler(this.startplayfile_Click);
            // 
            // stopplayfile
            // 
            this.stopplayfile.Location = new System.Drawing.Point(106, 337);
            this.stopplayfile.Name = "stopplayfile";
            this.stopplayfile.Size = new System.Drawing.Size(72, 23);
            this.stopplayfile.TabIndex = 11;
            this.stopplayfile.Text = "停止播放文件";
            this.stopplayfile.UseVisualStyleBackColor = true;
            this.stopplayfile.Click += new System.EventHandler(this.stopplayfile_Click);
            // 
            // pauseplayfile
            // 
            this.pauseplayfile.Location = new System.Drawing.Point(184, 337);
            this.pauseplayfile.Name = "pauseplayfile";
            this.pauseplayfile.Size = new System.Drawing.Size(66, 23);
            this.pauseplayfile.TabIndex = 12;
            this.pauseplayfile.Text = "暂停播放";
            this.pauseplayfile.UseVisualStyleBackColor = true;
            this.pauseplayfile.Click += new System.EventHandler(this.pauseplayfile_Click);
            // 
            // resumeplayfile
            // 
            this.resumeplayfile.Location = new System.Drawing.Point(256, 337);
            this.resumeplayfile.Name = "resumeplayfile";
            this.resumeplayfile.Size = new System.Drawing.Size(67, 23);
            this.resumeplayfile.TabIndex = 13;
            this.resumeplayfile.Text = "恢复播放";
            this.resumeplayfile.UseVisualStyleBackColor = true;
            this.resumeplayfile.Click += new System.EventHandler(this.resumeplayfile_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(19, 398);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(113, 12);
            this.label3.TabIndex = 14;
            this.label3.Text = "录音文件压缩格式：";
            // 
            // recformat
            // 
            this.recformat.FormattingEnabled = true;
            this.recformat.Location = new System.Drawing.Point(140, 395);
            this.recformat.Name = "recformat";
            this.recformat.Size = new System.Drawing.Size(183, 20);
            this.recformat.TabIndex = 15;
            // 
            // echoenable
            // 
            this.echoenable.AutoSize = true;
            this.echoenable.Location = new System.Drawing.Point(140, 421);
            this.echoenable.Name = "echoenable";
            this.echoenable.Size = new System.Drawing.Size(72, 16);
            this.echoenable.TabIndex = 16;
            this.echoenable.Text = "回音抵消";
            this.echoenable.UseVisualStyleBackColor = true;
            // 
            // agcenable
            // 
            this.agcenable.AutoSize = true;
            this.agcenable.Location = new System.Drawing.Point(221, 421);
            this.agcenable.Name = "agcenable";
            this.agcenable.Size = new System.Drawing.Size(72, 16);
            this.agcenable.TabIndex = 17;
            this.agcenable.Text = "自动增益";
            this.agcenable.UseVisualStyleBackColor = true;
            // 
            // startrecfile
            // 
            this.startrecfile.Location = new System.Drawing.Point(12, 443);
            this.startrecfile.Name = "startrecfile";
            this.startrecfile.Size = new System.Drawing.Size(88, 23);
            this.startrecfile.TabIndex = 18;
            this.startrecfile.Text = "开始文件录音";
            this.startrecfile.UseVisualStyleBackColor = true;
            this.startrecfile.Click += new System.EventHandler(this.startrecfile_Click);
            // 
            // stoprecfile
            // 
            this.stoprecfile.Location = new System.Drawing.Point(103, 443);
            this.stoprecfile.Name = "stoprecfile";
            this.stoprecfile.Size = new System.Drawing.Size(86, 23);
            this.stoprecfile.TabIndex = 19;
            this.stoprecfile.Text = "停止文件录音";
            this.stoprecfile.UseVisualStyleBackColor = true;
            this.stoprecfile.Click += new System.EventHandler(this.stoprecfile_Click);
            // 
            // pauserecfile
            // 
            this.pauserecfile.Location = new System.Drawing.Point(195, 443);
            this.pauserecfile.Name = "pauserecfile";
            this.pauserecfile.Size = new System.Drawing.Size(67, 23);
            this.pauserecfile.TabIndex = 20;
            this.pauserecfile.Text = "暂停录音";
            this.pauserecfile.UseVisualStyleBackColor = true;
            this.pauserecfile.Click += new System.EventHandler(this.pauserecfile_Click);
            // 
            // resumerecfile
            // 
            this.resumerecfile.Location = new System.Drawing.Point(268, 443);
            this.resumerecfile.Name = "resumerecfile";
            this.resumerecfile.Size = new System.Drawing.Size(65, 23);
            this.resumerecfile.TabIndex = 21;
            this.resumerecfile.Text = "恢复录音";
            this.resumerecfile.UseVisualStyleBackColor = true;
            this.resumerecfile.Click += new System.EventHandler(this.resumerecfile_Click);
            // 
            // refusecallin
            // 
            this.refusecallin.Location = new System.Drawing.Point(21, 490);
            this.refusecallin.Name = "refusecallin";
            this.refusecallin.Size = new System.Drawing.Size(106, 23);
            this.refusecallin.TabIndex = 22;
            this.refusecallin.Text = "拒接来电";
            this.refusecallin.UseVisualStyleBackColor = true;
            this.refusecallin.Click += new System.EventHandler(this.refusecallin_Click);
            // 
            // startflash
            // 
            this.startflash.Location = new System.Drawing.Point(140, 490);
            this.startflash.Name = "startflash";
            this.startflash.Size = new System.Drawing.Size(101, 23);
            this.startflash.TabIndex = 23;
            this.startflash.Text = "拍插簧";
            this.startflash.UseVisualStyleBackColor = true;
            this.startflash.Click += new System.EventHandler(this.startflash_Click);
            // 
            // dohook
            // 
            this.dohook.AutoSize = true;
            this.dohook.Location = new System.Drawing.Point(456, 259);
            this.dohook.Name = "dohook";
            this.dohook.Size = new System.Drawing.Size(78, 16);
            this.dohook.TabIndex = 24;
            this.dohook.Text = "摘机/接听";
            this.dohook.UseVisualStyleBackColor = true;
            this.dohook.CheckedChanged += new System.EventHandler(this.dohook_CheckedChanged);
            // 
            // dophone
            // 
            this.dophone.AutoSize = true;
            this.dophone.Location = new System.Drawing.Point(456, 281);
            this.dophone.Name = "dophone";
            this.dophone.Size = new System.Drawing.Size(156, 16);
            this.dophone.TabIndex = 25;
            this.dophone.Text = "断开话机和PSTN线路连接";
            this.dophone.UseVisualStyleBackColor = true;
            this.dophone.CheckedChanged += new System.EventHandler(this.dophone_CheckedChanged);
            // 
            // doline2spk
            // 
            this.doline2spk.AutoSize = true;
            this.doline2spk.Location = new System.Drawing.Point(456, 303);
            this.doline2spk.Name = "doline2spk";
            this.doline2spk.Size = new System.Drawing.Size(132, 16);
            this.doline2spk.TabIndex = 26;
            this.doline2spk.Text = "打开线路声音到耳机";
            this.doline2spk.UseVisualStyleBackColor = true;
            this.doline2spk.CheckedChanged += new System.EventHandler(this.doline2spk_CheckedChanged);
            // 
            // doplay2spk
            // 
            this.doplay2spk.AutoSize = true;
            this.doplay2spk.Location = new System.Drawing.Point(456, 325);
            this.doplay2spk.Name = "doplay2spk";
            this.doplay2spk.Size = new System.Drawing.Size(120, 16);
            this.doplay2spk.TabIndex = 27;
            this.doplay2spk.Text = "播放的声音到耳机";
            this.doplay2spk.UseVisualStyleBackColor = true;
            this.doplay2spk.CheckedChanged += new System.EventHandler(this.doplay2spk_CheckedChanged);
            // 
            // domic2line
            // 
            this.domic2line.AutoSize = true;
            this.domic2line.Location = new System.Drawing.Point(456, 347);
            this.domic2line.Name = "domic2line";
            this.domic2line.Size = new System.Drawing.Size(120, 16);
            this.domic2line.TabIndex = 28;
            this.domic2line.Text = "麦克风声音到线路";
            this.domic2line.UseVisualStyleBackColor = true;
            this.domic2line.CheckedChanged += new System.EventHandler(this.domic2line_CheckedChanged);
            // 
            // doplay
            // 
            this.doplay.AutoSize = true;
            this.doplay.Location = new System.Drawing.Point(456, 371);
            this.doplay.Name = "doplay";
            this.doplay.Size = new System.Drawing.Size(72, 16);
            this.doplay.TabIndex = 29;
            this.doplay.Text = "打开喇叭";
            this.doplay.UseVisualStyleBackColor = true;
            this.doplay.CheckedChanged += new System.EventHandler(this.doplay_CheckedChanged);
            // 
            // comboBox2
            // 
            this.comboBox2.FormattingEnabled = true;
            this.comboBox2.Location = new System.Drawing.Point(530, 369);
            this.comboBox2.Name = "comboBox2";
            this.comboBox2.Size = new System.Drawing.Size(121, 20);
            this.comboBox2.TabIndex = 30;
            // 
            // spkam
            // 
            this.spkam.AutoSize = true;
            this.spkam.Location = new System.Drawing.Point(463, 421);
            this.spkam.Name = "spkam";
            this.spkam.Size = new System.Drawing.Size(65, 12);
            this.spkam.TabIndex = 31;
            this.spkam.Text = "耳机增益：";
            // 
            // spkamvalue
            // 
            this.spkamvalue.FormattingEnabled = true;
            this.spkamvalue.Location = new System.Drawing.Point(534, 419);
            this.spkamvalue.Name = "spkamvalue";
            this.spkamvalue.Size = new System.Drawing.Size(117, 20);
            this.spkamvalue.TabIndex = 32;
            this.spkamvalue.SelectedIndexChanged += new System.EventHandler(this.spkamvalue_SelectedIndexChanged);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(451, 454);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(77, 12);
            this.label4.TabIndex = 33;
            this.label4.Text = "麦克风增益：";
            // 
            // micamvalue
            // 
            this.micamvalue.FormattingEnabled = true;
            this.micamvalue.Location = new System.Drawing.Point(534, 451);
            this.micamvalue.Name = "micamvalue";
            this.micamvalue.Size = new System.Drawing.Size(117, 20);
            this.micamvalue.TabIndex = 34;
            this.micamvalue.SelectedIndexChanged += new System.EventHandler(this.micamvalue_SelectedIndexChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(655, 525);
            this.Controls.Add(this.micamvalue);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.spkamvalue);
            this.Controls.Add(this.spkam);
            this.Controls.Add(this.comboBox2);
            this.Controls.Add(this.doplay);
            this.Controls.Add(this.domic2line);
            this.Controls.Add(this.doplay2spk);
            this.Controls.Add(this.doline2spk);
            this.Controls.Add(this.dophone);
            this.Controls.Add(this.dohook);
            this.Controls.Add(this.startflash);
            this.Controls.Add(this.refusecallin);
            this.Controls.Add(this.resumerecfile);
            this.Controls.Add(this.pauserecfile);
            this.Controls.Add(this.stoprecfile);
            this.Controls.Add(this.startrecfile);
            this.Controls.Add(this.agcenable);
            this.Controls.Add(this.echoenable);
            this.Controls.Add(this.recformat);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.resumeplayfile);
            this.Controls.Add(this.pauseplayfile);
            this.Controls.Add(this.stopplayfile);
            this.Controls.Add(this.startplayfile);
            this.Controls.Add(this.startdial);
            this.Controls.Add(this.dialcode);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.selchannel);
            this.Controls.Add(this.closedev);
            this.Controls.Add(this.msg);
            this.Controls.Add(this.opendev);
            this.Name = "Form1";
            this.Text = "CC301设备控制基本功能演示 1.0";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button opendev;
        private System.Windows.Forms.TextBox msg;
        private System.Windows.Forms.Button closedev;
        private System.Windows.Forms.ComboBox selchannel;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox dialcode;
        private System.Windows.Forms.Button startdial;
        private System.Windows.Forms.Button startplayfile;
        private System.Windows.Forms.Button stopplayfile;
        private System.Windows.Forms.Button pauseplayfile;
        private System.Windows.Forms.Button resumeplayfile;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox recformat;
        private System.Windows.Forms.CheckBox echoenable;
        private System.Windows.Forms.CheckBox agcenable;
        private System.Windows.Forms.Button startrecfile;
        private System.Windows.Forms.Button stoprecfile;
        private System.Windows.Forms.Button pauserecfile;
        private System.Windows.Forms.Button resumerecfile;
        private System.Windows.Forms.Button refusecallin;
        private System.Windows.Forms.Button startflash;
        private System.Windows.Forms.CheckBox dohook;
        private System.Windows.Forms.CheckBox dophone;
        private System.Windows.Forms.CheckBox doline2spk;
        private System.Windows.Forms.CheckBox doplay2spk;
        private System.Windows.Forms.CheckBox domic2line;
        private System.Windows.Forms.CheckBox doplay;
        private System.Windows.Forms.ComboBox comboBox2;
        private System.Windows.Forms.Label spkam;
        private System.Windows.Forms.ComboBox spkamvalue;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox micamvalue;
    }
}

