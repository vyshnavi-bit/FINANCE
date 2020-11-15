using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class SAPSubPayments : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    VehicleDBMgr vdm;
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
                lblTitle.Text = Session["TitleName"].ToString();
                txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                Fillbankdetails();
                Fillbranchdetails();

            }
        }
    }
    void Fillbankdetails()
    {
        vdm = new VehicleDBMgr();
        cmd = new SqlCommand("SELECT sno, accountno FROM bankaccountno_master");
        DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
        ddlaccountno.DataSource = dtPlant;
        ddlaccountno.DataTextField = "accountno";
        ddlaccountno.DataValueField = "sno";
        ddlaccountno.DataBind();
    }
    void Fillbranchdetails()
    {
        vdm = new VehicleDBMgr();
        cmd = new SqlCommand("SELECT branchid, branchname FROM branchmaster");
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

    protected void btnGet_Click(object sender, EventArgs e)
    {
        GetReport();
    }
    DataTable dtReport = new DataTable();
    void GetReport()
    {
        try
        {
            lbl_msg.Text = "";
            pnlHide.Visible = true;
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

            lbl_selfromdate.Text = fromdate.ToString("dd/MM/yyyy");
            lblbranch.Text = ddlbranchname.SelectedItem.Text;
            Session["xporttype"] = "TallyBankSubPayments";
            string ledger = "";
            cmd = new SqlCommand("SELECT sno,  brach_ledger FROM bankaccountno_master WHERE (sno = @accountno)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            DataTable dtledger1 = vdm.SelectQuery(cmd).Tables[0];
            if (dtledger1.Rows.Count > 0)
            {
                ledger = dtledger1.Rows[0]["brach_ledger"].ToString();
            }

            cmd = new SqlCommand("SELECT subaccount_payment.amount, headofaccounts_master.accountname, paymentdetails.doe,paymentdetails.totalamount, paymentdetails.sno, paymentdetails.remarks, paymentdetails.paymentdate FROM paymentdetails INNER JOIN subaccount_payment ON paymentdetails.sno = subaccount_payment.paymentrefno INNER JOIN headofaccounts_master ON subaccount_payment.headofaccount = headofaccounts_master.sno WHERE (paymentdetails.paymentdate BETWEEN @D1 AND @D2) AND (paymentdetails.accountno = @accountno) and (subaccount_payment.branchid=@BranchID)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@BranchID", ddlbranchname.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtsalescollection = vdm.SelectQuery(cmd).Tables[0];
            double totamount = 0;
            if (dtsalescollection.Rows.Count > 0)
            {
                dtReport = new DataTable();
                dtReport.Columns.Add("JV No");
                dtReport.Columns.Add("JV Date");
                dtReport.Columns.Add("Ledger Code");
                dtReport.Columns.Add("Ledger Name");
                dtReport.Columns.Add("Amount");
                dtReport.Columns.Add("Narration");
                int i = 1;
                string jvno = "";

                DataView view = new DataView(dtsalescollection);
                DataTable distincttable = view.ToTable(true, "sno", "totalamount");
                foreach (DataRow dr in distincttable.Rows)
                {
                    foreach (DataRow branch in dtsalescollection.Select("sno='" + dr["sno"].ToString() + "'"))
                    {

                        DataRow newrow2 = dtReport.NewRow();
                        newrow2["JV No"] = "BANK_PAY" + branch["sno"].ToString();
                        jvno = branch["sno"].ToString();
                        newrow2["JV Date"] = fromdate.ToString("dd-MMM-yyyy");
                        newrow2["Ledger Name"] = branch["accountname"].ToString();
                        double amount = 0;
                        double.TryParse(branch["amount"].ToString(), out amount);
                        newrow2["Amount"] = amount;
                        newrow2["Narration"] = branch["Remarks"].ToString() + ",VoucherID  " + branch["sno"].ToString() + ",Emp Name  " + Session["EmpName"].ToString();
                        dtReport.Rows.Add(newrow2);
                    }
                    DataRow newrow3 = dtReport.NewRow();
                    newrow3["JV No"] = "BANK_PAY" + dr["sno"].ToString();
                    newrow3["JV Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow3["Ledger Name"] = ledger;
                    double totalamount = 0;
                    double.TryParse(dr["totalamount"].ToString(), out totalamount);
                    newrow3["Amount"] = "-" + totalamount;
                    newrow3["Narration"] = "Being the " + ledger + "bill paid for the month of " + fromdate.ToString("dd-MMM-yyyy") + ",Emp Name  " + Session["EmpName"].ToString();
                    dtReport.Rows.Add(newrow3);
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
    SqlCommand sqlcmd;
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new VehicleDBMgr();
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
                string jvcode = dr["JV Code"].ToString();
                if (AcctCode == "" || jvcode == "")
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1)");
                    sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@Ref1", dr["JV No"].ToString());
                    int TransNo = 1;
                    sqlcmd.Parameters.Add("@TransNo", TransNo);
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
                    SAPvdm.insert(sqlcmd);
                }
            }
            pnlHide.Visible = false;
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
            lbl_msg.Text = "Successfully Saved";
        }
        catch (Exception ex)
        {
            lbl_msg.Text = ex.ToString();
        }
    }
}