using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class procurementmainpayments : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    ProcureDBmanager vdm;
    private object ddlType;
    private object lblmsg;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["branch"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else
        {
            BranchID = Session["branch"].ToString();
        }
        if (!this.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                lblTitle.Text = Session["TitleName"].ToString();
                Fillbankdetails();
                Fillplantdetails();
            }
        }
    }
    void Fillbankdetails()
    {
        VehicleDBMgr vdmm = new VehicleDBMgr();
        cmd = new SqlCommand("SELECT sno, accountno FROM bankaccountno_master");
        DataTable dtac = vdmm.SelectQuery(cmd).Tables[0];
        ddlaccountno.DataSource = dtac;
        ddlaccountno.DataTextField = "accountno";
        ddlaccountno.DataValueField = "sno";
        ddlaccountno.DataBind();
    }

    void Fillplantdetails()
    {
        vdm = new ProcureDBmanager();
        cmd = new SqlCommand("SELECT Plant_Code, Plant_Name FROM Plant_Master where plant_code not in (150,139,160)");
        DataTable dtplant = vdm.SelectQuery(cmd).Tables[0];
        ddl_Plantname.DataSource = dtplant;
        ddl_Plantname.DataTextField = "Plant_Name";
        ddl_Plantname.DataValueField = "Plant_Code";
        ddl_Plantname.DataBind();
    }
    protected void ddl_Plantname_SelectedIndexChanged(object sender, EventArgs e)
    {
        billdate();
    }

    protected void ddl_BillDate_SelectedIndexChanged(object sender, EventArgs e)
    {
        billfillname();
    }

    public void billdate()
    {
        try
        {
            ddl_BillDate.Items.Clear();
            vdm = new ProcureDBmanager();
            cmd = new SqlCommand("SELECT  TID,Bill_frmdate,Bill_todate FROM Bill_date where  Plant_Code='" + ddl_Plantname.SelectedItem.Value + "'  order by  Bill_frmdate desc ");
            DataTable dtplant = vdm.SelectQuery(cmd).Tables[0];
            if (dtplant.Rows.Count > 0)
            {
                foreach (DataRow dr in dtplant.Rows)
                {
                    DateTime d1 = Convert.ToDateTime(dr["Bill_frmdate"].ToString());
                    DateTime d2 = Convert.ToDateTime(dr["Bill_todate"].ToString());
                    string frmdate = d1.ToString("dd/MM/yyy");
                    string Todate = d2.ToString("dd/MM/yyy");
                    ddl_BillDate.Items.Add(frmdate + "-" + Todate);
                }
            }
        }
        catch
        {

        }
    }


    public void billfillname()
    {
        try
        {
            ddlfilename.Items.Clear();
            vdm = new ProcureDBmanager();
            string date = ddl_BillDate.Text;
            string[] p = date.Split('/', '-');
            getvald = p[0];
            getvalm = p[1];
            getvaly = p[2];
            getvaldd = p[3];
            getvalmm = p[4];
            getvalyy = p[5];
            FDATE = getvalm + "/" + getvald + "/" + getvaly;
            TODATE = getvalmm + "/" + getvaldd + "/" + getvalyy;
            cmd = new SqlCommand("SELECT DISTINCT BankFileName, UpdatedTime FROM   BankPaymentllotment where Plant_Code='" + ddl_Plantname.SelectedItem.Value + "'  and    Billfrmdate='" + FDATE + "' and  Billtodate='" + TODATE + "'  and  FinanceStatus='1' ORDER BY UpdatedTime");
            DataTable dtfiles = vdm.SelectQuery(cmd).Tables[0];
            if (dtfiles.Rows.Count > 0)
            {
                ddlfilename.DataSource = dtfiles;
                ddlfilename.DataTextField = "BankFileName";
                ddlfilename.DataValueField = "BankFileName";
                ddlfilename.DataBind();
            }
        }
        catch
        {

        }
    }


    private DateTime GetLowDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        DT = dt;
        Hour = -dt.Hour;
        Min = -dt.Minute;
        Sec = -dt.Second;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    private DateTime GetHighDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        Hour = 23 - dt.Hour;
        Min = 59 - dt.Minute;
        Sec = 59 - dt.Second;
        DT = dt;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        getpaymentcompletedata();
    }
    DataTable dtReport = new DataTable();
    void GetReport()
    {
        try
        {
            lbl_msg.Text = "";
            pnlHide.Visible = true;
            Session["RouteName"] = ddlaccountno.SelectedItem.Text;
            Session["IDate"] = DateTime.Now.AddDays(1).ToString("dd/MM/yyyy");
            vdm = new ProcureDBmanager();
            DateTime fromdate = DateTime.Now;
            string[] dateFromstrig = txtFromdate.Text.Split(' ');
            if (dateFromstrig.Length > 1)
            {
                if (dateFromstrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateFromstrig[0].Split('-');
                    string[] times = dateFromstrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            lbl_selfromdate.Text = fromdate.ToString("dd/MM/yyyy");
            lblRoutName.Text = ddlaccountno.SelectedItem.Text;
            Session["xporttype"] = "TallyBankPayments";
            string ledger = "";
            cmd = new SqlCommand("SELECT sno,  ladger_dr FROM bankaccountno_master WHERE (sno = @accountno)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            DataTable dtledger = vdm.SelectQuery(cmd).Tables[0];
            if (dtledger.Rows.Count > 0)
            {
                ledger = dtledger.Rows[0]["ladger_dr"].ToString();
            }

            cmd = new SqlCommand("SELECT     p.remarks,  p.sno,  p.name, bam.accountno, ham.accountname, psd.amount,CONVERT(VARCHAR(10), p.doe, 103) AS doe FROM paymentdetails AS p INNER JOIN paymentsubdetails AS psd ON psd.paymentrefno = p.sno INNER JOIN bankaccountno_master AS bam ON bam.sno = p.accountno INNER JOIN headofaccounts_master AS ham ON ham.sno = psd.headofaccount WHERE (p.accountno = @accno) AND (p.paymentdate BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@accno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtsalescollection = vdm.SelectQuery(cmd).Tables[0];
            if (dtsalescollection.Rows.Count > 0)
            {
                dtReport = new DataTable();
                dtReport.Columns.Add("Voucher Date");
                dtReport.Columns.Add("Voucher No");
                dtReport.Columns.Add("Voucher Type");
                dtReport.Columns.Add("Ledger (Cr)");
                dtReport.Columns.Add("Ledger (Dr)");
                dtReport.Columns.Add("Amount");
                dtReport.Columns.Add("Narration");
                int i = 1;
                foreach (DataRow branch in dtsalescollection.Rows)
                {
                    DataRow newrow = dtReport.NewRow();
                    newrow["Voucher Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow["Voucher No"] = "BANK_PAY" + branch["sno"].ToString();
                    newrow["Voucher Type"] = "Bank Payment Import";
                    if (branch["accountname"].ToString() == "")
                    {
                    }
                    else
                    {
                        newrow["Ledger (Cr)"] = ledger;
                        newrow["Ledger (Dr)"] = branch["accountname"].ToString();
                        newrow["Amount"] = branch["amount"].ToString();
                        newrow["Narration"] = branch["Remarks"].ToString() + ",VoucherID  " + branch["sno"].ToString() + ",Emp Name  " + Session["EmpName"].ToString();
                        dtReport.Rows.Add(newrow);
                        i++;
                    }
                }
                grdReports.DataSource = dtReport;
                grdReports.DataBind();
                Session["xportdata"] = dtReport;
            }
            else
            {
                pnlHide.Visible = false;
                lbl_msg.Text = "No Indent Found";
                grdReports.DataSource = dtReport;
                grdReports.DataBind();
            }
        }
        catch (Exception ex)
        {
            pnlHide.Visible = false;
            lbl_msg.Text = ex.Message;
        }
    }
    string getvald;
    string getvalm;
    string getvaly;
    string getvaldd;
    string getvalmm;
    string getvalyy;
    string FDATE;
    string TODATE;
    double totamt;
    DataTable mainhead = new DataTable();
    public void getpaymentcompletedata()
    {
        try
        {
            lbl_msg.Text = "";
            pnlHide.Visible = true;
            DataTable Report = new DataTable();
            Report.Columns.Add("JV No");
            Report.Columns.Add("JV Date");
            Report.Columns.Add("Ledger Name");
            Report.Columns.Add("Amount");
            Report.Columns.Add("Narration");
            vdm = new ProcureDBmanager();
            mainhead.Columns.Add("ledgername");
            mainhead.Columns.Add("ledgerid");
            mainhead.Columns.Add("Amount");
            string date = ddl_BillDate.Text;
            string[] p = date.Split('/', '-');
            getvald = p[0];
            getvalm = p[1];
            getvaly = p[2];
            getvaldd = p[3];
            getvalmm = p[4];
            getvalyy = p[5];
            FDATE = getvalm + "/" + getvald + "/" + getvaly;
            TODATE = getvalmm + "/" + getvaldd + "/" + getvalyy;
            string plantcode = ddl_Plantname.SelectedItem.Value;
            string seplantname = ddl_Plantname.SelectedItem.Text;
            cmd = new SqlCommand("SELECT Tid, Plant_code, Agent_id, Frm_date, To_date, AddedDate, totfat_kg, Added_paise, TotAmount FROM   AgentExcesAmount  WHERE  (Plant_code = '" + ddl_Plantname.SelectedItem.Value + "') AND (Frm_date = '" + FDATE + "') AND (To_date = '" + TODATE + "')");
            DataTable dtexcesamount = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT DISTINCT BankFileName, UpdatedTime FROM   BankPaymentllotment where Plant_Code='" + ddl_Plantname.SelectedItem.Value + "'  and    BankFileName='" + ddlfilename.SelectedItem.Value + "'");
            DataTable dtfiles = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("select Tid,  Agent_Id,Agent_Name,Bank_Name,Ifsccode,Account_no,convert(decimal(18,2),NetAmount) as NetAmount,Remarks, UpdatedTime, BankFileName  from (select *  from (SELECT *   FROM (Select    Tid,   Agent_Id as bankagent,Agent_Name,BANK_ID as bankid,Ifsccode,Account_no,NetAmount,Plant_Code,Remarks, UpdatedTime, BankFileName    from  BankPaymentllotment where     Plant_Code='" + ddl_Plantname.SelectedItem.Value + "'  and    Billfrmdate='" + FDATE + "' and  Billtodate='" + TODATE + "'  and  FinanceStatus='1'   ) AS NEWS LEFT JOIN (SELECT Bank_id,Bank_Name   FROM Bank_Details GROUP BY  Bank_id,Bank_Name) AS BANK  ON NEWS.bankid= BANK.Bank_id) as news   left join (Select Agent_Id,Route_id   from Agent_Master   where Plant_code='" + ddl_Plantname.SelectedItem.Value + "'   group by  Agent_Id,Route_id ) as news1 on news.bankagent=news1.Agent_Id  ) as ff where Agent_Id is not null");
            DataTable report = vdm.SelectQuery(cmd).Tables[0];
            if (dtfiles.Rows.Count > 0)
            {
                string plantname = ddl_Plantname.SelectedItem.Text;
                int JV = 0;
                foreach (DataRow dr in dtfiles.Rows)
                {
                    double filetotalamount = 0;
                    double filetotalexcessamount = 0;
                    string jvnumber = "";
                    string jvvocherdate = "";
                    string jvnarration = "";
                    JV = JV + 1;
                    foreach (DataRow dra in report.Select("BankFileName='" + dr["BankFileName"].ToString() + "'"))
                    {
                        double excessamount = 0;
                        DataRow newrow = Report.NewRow();
                        string tid = dra["Tid"].ToString();
                        string agentname = dra["Agent_Name"].ToString();
                        string agentid = dra["Agent_Id"].ToString();
                        foreach (DataRow drexcess in dtexcesamount.Select("Agent_id='" + agentid + "'"))
                        {
                            double FEXAMT = 0;
                            double Texamt = Convert.ToDouble(drexcess["TotAmount"].ToString());
                            double roundexamt = Math.Round(Texamt, 0);
                            double examt = roundexamt - Texamt;
                            if (examt > 0)
                            {
                                FEXAMT = roundexamt - 1;
                            }
                            else
                            {
                                FEXAMT = roundexamt;
                            }
                            excessamount = FEXAMT;
                        }
                        string ledgername = agentid + "-" + agentname + "-" + plantname;
                        double amt = 0;
                        double.TryParse(dra["NetAmount"].ToString(), out amt);
                        double famt = Math.Round(amt + excessamount, 0);
                        filetotalamount += famt;

                        string vdate = dra["UpdatedTime"].ToString();
                        string vocherdate = "";
                        string cdate = "";
                        string cmonth = "";
                        if (vdate != "")
                        {
                            DateTime dtvocherdate = Convert.ToDateTime(vdate);
                            vocherdate = dtvocherdate.ToString("dd-MMM-yy");
                            cdate = dtvocherdate.ToString("dd");
                            cmonth = dtvocherdate.ToString("MMM");
                        }
                        jvvocherdate = vocherdate;
                        DateTime f = Convert.ToDateTime(FDATE);
                        DateTime t = Convert.ToDateTime(TODATE);
                        string narration = "Being the " + plantname + " CC Procurement Milk Bill Amount paid for the period of " + f.ToString("dd-MMM-yyyy") + " To " + t.ToString("dd-MMM-yyyy") + ", amount paid thru bank " + ddlaccountno.SelectedItem.Text + "  dt : " + vocherdate + "  .,Emp Name " + Session["EmpName"].ToString();
                        //string cdate = dtvocherdate.ToString("dd");
                        // string cmonth = dtvocherdate.ToString("MMM");
                        newrow["JV Date"] = vocherdate;
                        newrow["Ledger Name"] = ledgername;
                        newrow["Amount"] = famt;
                        newrow["Narration"] = narration;
                        jvnarration = narration;
                        newrow["JV No"] = "BANK_PAY" + "" + cdate + "" + cmonth + "" + tid;
                        jvnumber = "BANK_PAY" + "" + cdate + "" + cmonth + "" + tid;
                        Report.Rows.Add(newrow);
                    }
                    VehicleDBMgr fvdm = new VehicleDBMgr();
                    cmd = new SqlCommand("SELECT bankaccountno_master.ladger_dr,bankaccountno_master.brach_ledger,bankaccountno_master.ladger_dr_code,bankaccountno_master.brach_ledger_code, bankaccountno_master.branchname, bankmaster.bankname, bankaccountno_master.ifscid, bankaccountno_master.bankid, bankaccountno_master.sno, bankaccountno_master.accountno, bankaccountno_master.accounttype, ifscmaster.ifsccode FROM  bankaccountno_master INNER JOIN  bankmaster ON bankaccountno_master.bankid = bankmaster.sno INNER JOIN  ifscmaster ON bankaccountno_master.ifscid = ifscmaster.sno where bankaccountno_master.sno=@sno");
                    cmd.Parameters.Add("@sno", ddlaccountno.SelectedItem.Value);
                    DataTable routes = fvdm.SelectQuery(cmd).Tables[0];
                    if (routes.Rows.Count > 0)
                    {
                        foreach (DataRow drba in routes.Rows)
                        {
                            string branchledger = drba["brach_ledger"].ToString();
                            DataRow newrow1 = Report.NewRow();
                            newrow1["JV Date"] = jvvocherdate;
                            newrow1["Ledger Name"] = branchledger;
                            string neg = "-";
                            newrow1["Amount"] = neg + "" + filetotalamount;
                            newrow1["Narration"] = "Being the SVDS.P.LTD." + seplantname + " bill paid for the month of  " + txtFromdate.Text + "  .,Emp Name " + Session["EmpName"].ToString();
                            newrow1["JV No"] = jvnumber;
                            Report.Rows.Add(newrow1);
                        }
                    }
                    string mainledgername = "";
                    string mainfiletotalamount = filetotalamount.ToString();
                    if (plantname == "ARANI")
                    {
                        mainledgername = "SVDS.P.LTD ARANI";
                    }
                    if (plantname == "CSPURAM")
                    {
                        mainledgername = "Sri Vyshnavi Dairy Pvt Ltd-C.S.Puram(Kvl)";
                    }
                    if (plantname == "KONDEPI" || plantname == "Kondepi Cow")
                    {
                        mainledgername = "Sri Vyshnavi Dairy ( P ) Ltd., Kondapi(Kavali)";
                    }
                    if (plantname == "KALIGIRI")
                    {
                        mainledgername = "SVDS.P.LTD Kaligiri";
                    }
                    if (plantname == "ALAPATTI")
                    {
                        mainledgername = "SVDS.P.LTD.Alapatti";
                    }
                    if (plantname == "KAVALI")
                    {
                        mainledgername = "Sri Vyshnavi Dairy-B.R.Palem(Kavali)";
                    }
                    if (plantname == "GUDIPALLI PADU" || plantname == "GUDIPALLIPADU COW")
                    {
                        mainledgername = "Sri Vyshnavi Dairy ( P ) Ltd, Gudipallipadu(Kvl)";
                    }
                    if (plantname == "KAVERIPATNAM")
                    {
                        mainledgername = "SVDS.P.LTD KAVERIPATTINAM";
                    }
                    if (plantname == "GUDLUR")
                    {
                        mainledgername = "Sri Vyshnavi Dairy Pvt Ltd-Gudluru(Kvl)";
                    }
                    if (plantname == "WALAJA")
                    {
                        mainledgername = "SVDS.P.LTD WALAJA";
                    }
                    if (plantname == "V_KOTA")
                    {
                        mainledgername = "SVDS.P.LTD V.KOTA";
                    }
                    if (plantname == "RCPURAM")
                    {
                        mainledgername = "SVDS.P.LTD R.C.PURAM";
                    }
                    if (plantname == "BOMMASAMUTHIRAM")
                    {
                        mainledgername = "SVDS.P.LTD BOMMA";
                    }
                    if (plantname == "TARIGONDA")
                    {
                        mainledgername = "SVDS.P.LTD TARIGONDA";
                    }
                    if (plantname == "KALASTHIRI")
                    {
                        mainledgername = "";
                    }



                    DataRow mainrow = mainhead.NewRow();
                    mainrow["Amount"] = mainfiletotalamount;
                    mainrow["ledgername"] = mainledgername;
                    mainhead.Rows.Add(mainrow);

                    




                    Session["dtImport"] = Report;
                    Session["dtmainImport"] = mainhead;
                    Session["xportdata"] = Report;
                    totamt = filetotalamount;
                }
                if (mainhead.Rows.Count > 0)
                {
                    DataTable mainReport = new DataTable();
                    mainReport.Columns.Add("Voucher Date");
                    mainReport.Columns.Add("Voucher No");
                    mainReport.Columns.Add("Voucher Type");
                    mainReport.Columns.Add("Ledger (Cr)");
                    mainReport.Columns.Add("Ledger (Dr)");
                    mainReport.Columns.Add("Amount");
                    mainReport.Columns.Add("Narration");
                    string accno = ddlaccountno.SelectedItem.Value;
                    VehicleDBMgr fvdm = new VehicleDBMgr();
                    cmd = new SqlCommand("SELECT bankaccountno_master.ladger_dr,bankaccountno_master.brach_ledger,bankaccountno_master.ladger_dr_code,bankaccountno_master.brach_ledger_code, bankaccountno_master.branchname, bankmaster.bankname, bankaccountno_master.ifscid, bankaccountno_master.bankid, bankaccountno_master.sno, bankaccountno_master.accountno, bankaccountno_master.accounttype, ifscmaster.ifsccode FROM  bankaccountno_master INNER JOIN  bankmaster ON bankaccountno_master.bankid = bankmaster.sno INNER JOIN  ifscmaster ON bankaccountno_master.ifscid = ifscmaster.sno where bankaccountno_master.sno=@sno");
                    cmd.Parameters.Add("@sno", ddlaccountno.SelectedItem.Value);
                    DataTable acroutes = fvdm.SelectQuery(cmd).Tables[0];
                    string vdate = txtFromdate.Text;
                    string cdate = "";
                    string cmonth = "";
                    string cyear = "";
                    string vocherdate = "";
                    if (vdate != "")
                    {
                        string[] dta = vdate.Split(' ', '-');
                        vocherdate = vdate;
                        cdate = dta[0].ToString();
                        cmonth = dta[1].ToString();
                        cyear = dta[2].ToString();
                    }




                    DataRow mainReportrow = mainReport.NewRow();
                    mainReportrow["Voucher Date"] = vocherdate;
                    mainReportrow["Voucher No"] = "BANK_PAY" + "" + cdate + "" + cmonth + "" + cyear;
                    mainReportrow["Voucher Type"] = "Bank Payment Import";
                    if (acroutes.Rows.Count > 0)
                    {
                        mainReportrow["Ledger (Cr)"] = acroutes.Rows[0]["ladger_dr"].ToString();
                    }
                    foreach (DataRow drmr in mainhead.Rows)
                    {
                        mainReportrow["Ledger (Dr)"] = drmr["ledgername"].ToString();
                        mainReportrow["Amount"] = drmr["Amount"].ToString();
                        DateTime f = Convert.ToDateTime(FDATE);
                        DateTime t = Convert.ToDateTime(TODATE);
                        string narration = "Being the " + plantname + " CC Procurement Milk Bill Amount paid for the period of " + f.ToString("dd-MMM-yyyy") + " To " + t.ToString("dd-MMM-yyyy") + ", amount paid thru bank " + ddlaccountno.SelectedItem.Text + "  dt : " + vocherdate + "  .,Emp Name " + Session["EmpName"].ToString();
                        mainReportrow["Narration"] = narration;
                    }
                    mainReport.Rows.Add(mainReportrow);
                    grdReports.DataSource = mainReport;
                    grdReports.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
        }
    }


    DataTable dtmissing = new DataTable();
    public void save()
    {
        VehicleDBMgr vdm = new VehicleDBMgr();
        dtmissing.Columns.Add("Ledgername");
        DateTime CreateDate = VehicleDBMgr.GetTime(vdm.conn);
        DateTime fromdate = DateTime.Now;
        DataTable dtmainaccount = (DataTable)Session["dtmainImport"];
        DataTable dtsubaccount = (DataTable)Session["dtImport"];
        string UserName = Session["UserSno"].ToString();
        string branchname = "";
        string doe = txtFromdate.Text;
        DateTime paymentdate = Convert.ToDateTime(doe);
        string payto = "";
        string acno = ddlaccountno.SelectedItem.Value;
        string subbranch = "";
        string sapimport = "2";
        string remarks = "";
        string approvedby = "";
        double totalamount = 0;
        double totalsubamount = 0;
        cmd = new SqlCommand("insert into paymentdetails (name,accountno,remarks,approvedby,doe,createdby,status,paymentdate,branch,sub_branch,sapimport) values (@name,@accountno,@remarks,@approvedby,@doe,@createdby,'P',@paymentdate,@branch,@sub_branch,@sapimport)");
        cmd.Parameters.Add("@name", payto);
        cmd.Parameters.Add("@accountno", acno);
        //cmd.Parameters.Add("@totalamount", totalamount);
        cmd.Parameters.Add("@remarks", remarks);
        cmd.Parameters.Add("@approvedby", approvedby);
        cmd.Parameters.Add("@doe", CreateDate);
        cmd.Parameters.Add("@createdby", UserName);
        cmd.Parameters.Add("@paymentdate", doe);
        cmd.Parameters.Add("@branch", branchname);
        cmd.Parameters.Add("@sub_branch", subbranch);
        cmd.Parameters.Add("@sapimport", sapimport);
        vdm.insert(cmd);
        cmd = new SqlCommand("select MAX(sno) AS sno from paymentdetails ");
        DataTable routes = vdm.SelectQuery(cmd).Tables[0];
        string paymentrefno = routes.Rows[0]["sno"].ToString();
        //string paymentrefno = "7277";
        if (dtmainaccount != null && dtmainaccount.Rows.Count > 0)
        {
            try
            {
                foreach (DataRow drmain in dtmainaccount.Rows)
                {
                    double mainamount = 0;
                    string headofaccount = drmain["ledgername"].ToString();
                    cmd = new SqlCommand("SELECT sno FROM headofaccounts_master WHERE accountname=@acname");
                    cmd.Parameters.Add("@acname", headofaccount);
                    DataTable dtheadofaccount = vdm.SelectQuery(cmd).Tables[0];
                    if (dtheadofaccount.Rows.Count > 0)
                    {
                        string accountid = dtheadofaccount.Rows[0]["sno"].ToString();
                        string amount = drmain["amount"].ToString();
                        mainamount = Convert.ToDouble(amount);
                        totalamount += mainamount;
                        cmd = new SqlCommand("insert into paymentsubdetails (paymentrefno, headofaccount, amount) values (@paymentrefno, @headofaccount, @amount)");
                        cmd.Parameters.Add("@paymentrefno", paymentrefno);
                        cmd.Parameters.Add("@headofaccount", accountid);
                        cmd.Parameters.Add("@amount", amount);
                        vdm.insert(cmd);
                    }
                    else
                    {
                        DataRow newrow = dtmissing.NewRow();
                        newrow["Ledgername"] = headofaccount;
                        dtmissing.Rows.Add(newrow);
                    }
                }
                cmd = new SqlCommand("UPDATE paymentdetails SET totalamount=@totalamount WHERE sno=@refno");
                cmd.Parameters.Add("@totalamount", totalamount);
                cmd.Parameters.Add("@refno", paymentrefno);
                vdm.Update(cmd);
            }
            catch (Exception ex)
            {

            }
        }
        if (dtsubaccount != null && dtsubaccount.Rows.Count > 0)
        {
            try
            {
                foreach (DataRow dr in dtsubaccount.Rows)
                {
                    double subamount = 0;
                    string subheadofaccount = dr["ledgername"].ToString();
                    cmd = new SqlCommand("SELECT sno FROM headofaccounts_master WHERE accountname=@acname");
                    cmd.Parameters.Add("@acname", subheadofaccount);
                    DataTable dtsubheadofaccount = vdm.SelectQuery(cmd).Tables[0];
                    if (dtsubheadofaccount.Rows.Count > 0)
                    {
                        string subaccountid = dtsubheadofaccount.Rows[0]["sno"].ToString();
                        string amount = dr["amount"].ToString();
                        subamount = Convert.ToDouble(amount);
                        totalsubamount += subamount;
                        cmd = new SqlCommand("insert into subaccount_payment (paymentrefno, headofaccount, amount, branchid) values (@paymentrefno, @headofaccount, @amount,@branchid)");
                        cmd.Parameters.Add("@paymentrefno", paymentrefno);
                        cmd.Parameters.Add("@headofaccount", subaccountid);
                        cmd.Parameters.Add("@amount", amount);
                        cmd.Parameters.Add("@branchid", subbranch);
                        vdm.insert(cmd);
                    }
                    else
                    {
                        DataRow newrow = dtmissing.NewRow();
                        newrow["Ledgername"] = subheadofaccount;
                        dtmissing.Rows.Add(newrow);
                    }
                }
                cmd = new SqlCommand("UPDATE paymentdetails SET total_subamount=@total_subamount WHERE sno=@prefno");
                cmd.Parameters.Add("@total_subamount", totalsubamount);
                cmd.Parameters.Add("@prefno", paymentrefno);
                vdm.Update(cmd);
            }
            catch (Exception ex)
            {

            }
        }
    }
}