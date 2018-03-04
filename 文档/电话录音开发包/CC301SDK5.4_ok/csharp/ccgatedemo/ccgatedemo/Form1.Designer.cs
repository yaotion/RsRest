namespace ccgatedemo
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
            this.opendevice = new System.Windows.Forms.Button();
            this.CloseDevice = new System.Windows.Forms.Button();
            this.msg = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.ccsvraddr = new System.Windows.Forms.TextBox();
            this.setserver = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.cccode = new System.Windows.Forms.TextBox();
            this.labelpwd = new System.Windows.Forms.Label();
            this.ccpwd = new System.Windows.Forms.TextBox();
            this.logonbtn = new System.Windows.Forms.Button();
            this.logoutbtn = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.destcc = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // opendevice
            // 
            this.opendevice.Location = new System.Drawing.Point(23, 120);
            this.opendevice.Name = "opendevice";
            this.opendevice.Size = new System.Drawing.Size(75, 23);
            this.opendevice.TabIndex = 0;
            this.opendevice.Text = "打开设备";
            this.opendevice.UseVisualStyleBackColor = true;
            this.opendevice.Click += new System.EventHandler(this.opendevice_Click);
            // 
            // CloseDevice
            // 
            this.CloseDevice.Location = new System.Drawing.Point(104, 120);
            this.CloseDevice.Name = "CloseDevice";
            this.CloseDevice.Size = new System.Drawing.Size(75, 23);
            this.CloseDevice.TabIndex = 1;
            this.CloseDevice.Text = "关闭设备";
            this.CloseDevice.UseVisualStyleBackColor = true;
            this.CloseDevice.Click += new System.EventHandler(this.CloseDevice_Click);
            // 
            // msg
            // 
            this.msg.Location = new System.Drawing.Point(475, 23);
            this.msg.Multiline = true;
            this.msg.Name = "msg";
            this.msg.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.msg.Size = new System.Drawing.Size(269, 429);
            this.msg.TabIndex = 2;
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(10, 36);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(459, 16);
            this.label1.TabIndex = 3;
            this.label1.Text = "1.登陆CC ";
            this.label1.UseCompatibleTextRendering = true;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(19, 179);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(113, 12);
            this.label2.TabIndex = 4;
            this.label2.Text = "内网服务器IP地址：";
            // 
            // ccsvraddr
            // 
            this.ccsvraddr.Location = new System.Drawing.Point(138, 176);
            this.ccsvraddr.Name = "ccsvraddr";
            this.ccsvraddr.Size = new System.Drawing.Size(165, 21);
            this.ccsvraddr.TabIndex = 5;
            // 
            // setserver
            // 
            this.setserver.Location = new System.Drawing.Point(312, 174);
            this.setserver.Name = "setserver";
            this.setserver.Size = new System.Drawing.Size(72, 22);
            this.setserver.TabIndex = 6;
            this.setserver.Text = "设置";
            this.setserver.UseVisualStyleBackColor = true;
            this.setserver.Click += new System.EventHandler(this.setserver_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(79, 215);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(53, 12);
            this.label3.TabIndex = 7;
            this.label3.Text = "CC号码：";
            // 
            // cccode
            // 
            this.cccode.Location = new System.Drawing.Point(138, 212);
            this.cccode.Name = "cccode";
            this.cccode.Size = new System.Drawing.Size(166, 21);
            this.cccode.TabIndex = 8;
            // 
            // labelpwd
            // 
            this.labelpwd.AutoSize = true;
            this.labelpwd.Location = new System.Drawing.Point(79, 250);
            this.labelpwd.Name = "labelpwd";
            this.labelpwd.Size = new System.Drawing.Size(53, 12);
            this.labelpwd.TabIndex = 9;
            this.labelpwd.Text = "CC密码：";
            // 
            // ccpwd
            // 
            this.ccpwd.Location = new System.Drawing.Point(138, 247);
            this.ccpwd.Name = "ccpwd";
            this.ccpwd.PasswordChar = '*';
            this.ccpwd.Size = new System.Drawing.Size(165, 21);
            this.ccpwd.TabIndex = 10;
            this.ccpwd.TextChanged += new System.EventHandler(this.ccpwd_TextChanged);
            // 
            // logonbtn
            // 
            this.logonbtn.Location = new System.Drawing.Point(138, 284);
            this.logonbtn.Name = "logonbtn";
            this.logonbtn.Size = new System.Drawing.Size(71, 24);
            this.logonbtn.TabIndex = 11;
            this.logonbtn.Text = "登陆";
            this.logonbtn.UseVisualStyleBackColor = true;
            this.logonbtn.Click += new System.EventHandler(this.logonbtn_Click);
            // 
            // logoutbtn
            // 
            this.logoutbtn.Location = new System.Drawing.Point(222, 284);
            this.logoutbtn.Name = "logoutbtn";
            this.logoutbtn.Size = new System.Drawing.Size(82, 23);
            this.logoutbtn.TabIndex = 12;
            this.logoutbtn.Text = "离线";
            this.logoutbtn.UseVisualStyleBackColor = true;
            this.logoutbtn.Click += new System.EventHandler(this.logoutbtn_Click);
            // 
            // label4
            // 
            this.label4.Location = new System.Drawing.Point(310, 212);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(161, 52);
            this.label4.TabIndex = 13;
            this.label4.Text = "(如果使用公网测试，请先从本公司网站的数据中心下载CC商务终端注册CC号码)";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 356);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(173, 12);
            this.label5.TabIndex = 14;
            this.label5.Text = "PSTN线路呼入时转移到CC号码：";
            // 
            // destcc
            // 
            this.destcc.Location = new System.Drawing.Point(183, 353);
            this.destcc.MaxLength = 18;
            this.destcc.Name = "destcc";
            this.destcc.Size = new System.Drawing.Size(174, 21);
            this.destcc.TabIndex = 15;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(10, 52);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(113, 12);
            this.label6.TabIndex = 16;
            this.label6.Text = "2.设置转移的目标CC";
            // 
            // label7
            // 
            this.label7.Location = new System.Drawing.Point(9, 70);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(460, 31);
            this.label7.TabIndex = 17;
            this.label7.Text = "3.在其它电脑上使用目标CC登陆,可以使用本公司网站下载的CC商务终端或者开发包里的CCdemo例子";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(10, 101);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(347, 12);
            this.label8.TabIndex = 18;
            this.label8.Text = "4.使用其它电话呼入该设备的号码(如1099),在转移的目标CC接听";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(9, 3);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(641, 12);
            this.label9.TabIndex = 19;
            this.label9.Text = "如果提示不能加载qnviccub.dll,请从开发包的bin目录复制qnviccub.dll和bridge.dll到工程调试目录,如：bin/debug下";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(749, 453);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.destcc);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.logoutbtn);
            this.Controls.Add(this.logonbtn);
            this.Controls.Add(this.ccpwd);
            this.Controls.Add(this.labelpwd);
            this.Controls.Add(this.cccode);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.setserver);
            this.Controls.Add(this.ccsvraddr);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.msg);
            this.Controls.Add(this.CloseDevice);
            this.Controls.Add(this.opendevice);
            this.Name = "Form1";
            this.Text = "CC网关演示1.0";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_Close);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button opendevice;
        private System.Windows.Forms.Button CloseDevice;
        private System.Windows.Forms.TextBox msg;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox ccsvraddr;
        private System.Windows.Forms.Button setserver;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox cccode;
        private System.Windows.Forms.Label labelpwd;
        private System.Windows.Forms.TextBox ccpwd;
        private System.Windows.Forms.Button logonbtn;
        private System.Windows.Forms.Button logoutbtn;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox destcc;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
    }
}

