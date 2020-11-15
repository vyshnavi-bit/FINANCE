using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class SAP_jv_report : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    VehicleDBMgr vdm;
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
                txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                lblTitle.Text = Session["TitleName"].ToString();
                Fillbranchdetails();

            }
        }
    }
    void Fillbranchdetails()
    {
        vdm = new VehicleDBMgr();
        cmd = new SqlCommand("SELECT branchid, branchname, address, phone, emailid, statename, branchtype, company_code FROM branchmaster");
        DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
        ddlbranchname.DataSource = dtPlant;
        ddlbranchname.DataTextField = "branchname";
        ddlbranchname.DataValueField = "branchid";
        ddlbranchname.DataBind();
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
        GetReport();
    }
    DataTable Report = new DataTable();
    void GetReport()
    {
        try
        {
            lbl_msg.Text = "";
            pnlHide.Visible = true;
            Session["RouteName"] = ddlbranchname.SelectedItem.Text;
            Session["IDate"] = DateTime.Now.AddDays(1).ToString("dd/MM/yyyy");
            vdm = new VehicleDBMgr();
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

            DateTime Todate = DateTime.Now;
            string[] Todatestrig = txtTodate.Text.Split(' ');
            if (Todatestrig.Length > 1)
            {
                if (Todatestrig[0].Split('-').Length > 0)
                {
                    string[] dates = Todatestrig[0].Split('-');
                    string[] times = Todatestrig[1].Split(':');
                    Todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            lbl_selfromdate.Text = fromdate.ToString("dd/MM/yyyy");
            lblRoutName.Text = ddlbranchname.SelectedItem.Text;
            Session["xporttype"] = "TallyJV";
            string ledger = "";
            Report.Columns.Add("JV No");
            Report.Columns.Add("JV Date");
            Report.Columns.Add("WH Code");
            Report.Columns.Add("Ledger Code");
            Report.Columns.Add("Ledger Name");
            Report.Columns.Add("Amount");
            Report.Columns.Add("Series");
            Report.Columns.Add("Narration");
            Session["filename"] = ddlbranchname.SelectedItem.Text + " Tally JV" + fromdate.ToString("dd/MM/yyyy");

            cmd = new SqlCommand("SELECT branchid, branchname, whcode, ledger_jv_code, ledger_jv_name FROM branchmaster WHERE (branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranchname.SelectedValue);
            DataTable dtincetivename = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT  journel_entry.sno, journel_entry.branchid,journel_entry.jvdate, journel_entry.amount, journel_entry.remarks, journel_entry.doe, journel_entry.createdby, journel_entry.status, journel_entry.debitname,branchmaster.code, branchmaster.branchname FROM  journel_entry INNER JOIN branchmaster ON journel_entry.branchid = branchmaster.branchid WHERE (journel_entry.jvdate BETWEEN @d1 AND @d2) AND (journel_entry.branchid = @BranchID) ORDER BY journel_entry.doe");
            cmd.Parameters.Add("@BranchID", ddlbranchname.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtble = vdm.SelectQuery(cmd).Tables[0];
            double totamount = 0;
            fromdate = fromdate.AddDays(-1);
            string frmdate = fromdate.ToString("dd-MM-yyyy");
            string[] strjv = frmdate.Split('-');
            foreach (DataRow branch in dtble.Rows)
            {
                cmd = new SqlCommand("SELECT headofaccounts_master.accountname,headofaccounts_master.accountcode, subjournel_entry.amount FROM subjournel_entry INNER JOIN headofaccounts_master ON subjournel_entry.headofaccount = headofaccounts_master.sno WHERE (subjournel_entry.refno = @RefNo)");
                cmd.Parameters.Add("@RefNo", branch["sno"].ToString());
                DataTable dtdebit = vdm.SelectQuery(cmd).Tables[0];
                foreach (DataRow drdebit in dtdebit.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["JV No"] = branch["code"].ToString() + "_" + branch["sno"].ToString();
                    string strdate = branch["jvdate"].ToString();
                    DateTime dtjv = Convert.ToDateTime(strdate);
                    newrow["JV Date"] = dtjv.ToString("dd-MMM-yyyy");
                    newrow["WH Code"] = dtincetivename.Rows[0]["whcode"].ToString();
                    newrow["Ledger Code"] = drdebit["accountcode"].ToString();
                    newrow["Ledger Name"] = drdebit["accountname"].ToString();
                    double amount = 0;
                    double.TryParse(drdebit["amount"].ToString(), out amount);
                    totamount += amount;
                    newrow["Amount"] = amount;
                    string Series = "17";
                    newrow["Series"] = Series;
                    string remarks = branch["remarks"].ToString();
                    if (remarks.Length <= 25)
                    {
                        newrow["Narration"] = "Being the " + drdebit["accountname"].ToString() + " for the month of " + fromdate.ToString("MMM-yyyy") + " Total Amount " + drdebit["amount"].ToString() + ",Emp Name  " + Session["EmpName"].ToString();
                    }
                    else
                    {
                        newrow["Narration"] = remarks + ",Emp Name  " + Session["EmpName"].ToString();
                    }
                    Report.Rows.Add(newrow);
                }
                cmd = new SqlCommand("SELECT headofaccounts_master.accountname, headofaccounts_master.accountcode,subjournel_credit_entry.amount, subjournel_credit_entry.sno FROM headofaccounts_master INNER JOIN subjournel_credit_entry ON headofaccounts_master.sno = subjournel_credit_entry.headofaccount WHERE (subjournel_credit_entry.refno = @refno)");
                cmd.Parameters.Add("@RefNo", branch["sno"].ToString());
                DataTable dtcredit = vdm.SelectQuery(cmd).Tables[0];
                foreach (DataRow drcredit in dtcredit.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["JV No"] = branch["code"].ToString() + "_" + branch["sno"].ToString();
                    string strdate = branch["jvdate"].ToString();
                    DateTime dtjv = Convert.ToDateTime(strdate);
                    newrow["WH Code"] = dtincetivename.Rows[0]["whcode"].ToString();
                    newrow["Ledger Code"] = drcredit["accountcode"].ToString();
                    newrow["JV Date"] = dtjv.ToString("dd-MMM-yyyy");
                    newrow["Ledger Name"] = drcredit["accountname"].ToString();
                    double amount = 0;
                    double.TryParse(drcredit["amount"].ToString(), out amount);
                    totamount += amount;
                    newrow["Amount"] = "-" + amount;
                    string Series = "17";
                    newrow["Series"] = Series;
                    string remarks = branch["remarks"].ToString();
                    if (remarks.Length <= 25)
                    {
                        newrow["Narration"] = "Being the " + drcredit["accountname"].ToString() + " for the month of " + fromdate.ToString("MMM-yyyy") + " Total Amount " + drcredit["amount"].ToString() + ",Emp Name  " + Session["EmpName"].ToString();
                    }
                    else
                    {
                        newrow["Narration"] = remarks + ",Emp Name  " + Session["EmpName"].ToString();
                    }
                    Report.Rows.Add(newrow);
                }
            }
            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["xportdata"] = Report;
        }
        catch (Exception ex)
        {
            lbl_msg.Text = ex.Message;
            grdReports.DataSource = Report;
            grdReports.DataBind();
        }
    }
    SqlCommand sqlcmd;
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new VehicleDBMgr();
            lbl_msg.Text = "";
            DateTime CreateDate = VehicleDBMgr.GetTime(vdm.conn);
            SAPdbmanger SAPvdm = new SAPdbmanger();
            DateTime fromdate = DateTime.Now;
            DataTable dt = (DataTable)Session["xportdata"];
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
            foreach (DataRow dr in dt.Rows)
            {
                string AcctCode = dr["Ledger Code"].ToString();
                if (AcctCode == "")
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("SELECT CreateDate, RefDate, DocDate FROM EMROJDT WHERE (RefDate BETWEEN @d1 AND @d2) AND (TransNo = @TNo) AND (AcctCode=@acccode)");
                    sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                    sqlcmd.Parameters.Add("@TNo", dr["JV No"].ToString());
                    sqlcmd.Parameters.Add("@acccode", AcctCode);
                    DataTable dtjv = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                    if (dtjv.Rows.Count > 0)
                    {
                        lbl_msg.Text = "This Date Data already Saved";
                    }
                    else
                    {
                        sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,series) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@Series)");
                        sqlcmd.Parameters.Add("@CreateDate", CreateDate);
                        sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@Ref1", dr["JV No"].ToString());
                        sqlcmd.Parameters.Add("@TransNo", dr["JV No"].ToString());
                        sqlcmd.Parameters.Add("@AcctCode", dr["Ledger Code"].ToString());
                        sqlcmd.Parameters.Add("@AcctName", dr["Ledger Name"].ToString());
                        double amount = 0;
                        double.TryParse(dr["Amount"].ToString(), out amount);
                        if (amount < 0)
                        {
                            amount = Math.Abs(amount);
                            double Debit = 0;
                            sqlcmd.Parameters.Add("@Debit", Debit);
                            sqlcmd.Parameters.Add("@Credit", amount);
                        }
                        else
                        {
                            amount = Math.Abs(amount);
                            double Credit = 0;
                            sqlcmd.Parameters.Add("@Debit", amount);
                            sqlcmd.Parameters.Add("@Credit", Credit);
                        }
                        string B1Upload = "N";
                        string Processed = "N";
                        sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                        sqlcmd.Parameters.Add("@Processed", Processed);
                        sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                        sqlcmd.Parameters.Add("@series", dr["Series"].ToString());
                        if (amount == 0.0)
                        {
                        }
                        else
                        {
                            SAPvdm.insert(sqlcmd);
                        }
                    }
                }
            }
            pnlHide.Visible = false;
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
            if (lbl_msg.Text == "")
            {
                lbl_msg.Text = "Successfully Saved";
            }
        }
        catch (Exception ex)
        {
            msglbl.Text = ex.ToString();
        }
    }
}