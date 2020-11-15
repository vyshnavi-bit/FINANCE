using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;


public partial class SubReceiptsReport : System.Web.UI.Page
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
                lblTitle.Text = Session["TitleName"].ToString();
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
    protected void btnGenerate_Click(object sender, EventArgs e)
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
            Session["xporttype"] = "TallyBankSubPayments";
            string ledger = "";
            cmd = new SqlCommand("SELECT  branchid, branchname FROM branchmaster WHERE (branchid = @branchid)");
            cmd.Parameters.Add("@branchid", ddlbranchname.SelectedValue);
            DataTable dtledger = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT sno,  brach_ledger FROM bankaccountno_master WHERE (sno = @accountno)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            DataTable dtledger1 = vdm.SelectQuery(cmd).Tables[0];
            if (dtledger1.Rows.Count > 0)
            {
                ledger = dtledger1.Rows[0]["brach_ledger"].ToString();
            }

            cmd = new SqlCommand("SELECT  collections.sno, collections.accountno,collections.name, collections.remarks, CONVERT(VARCHAR(10), collections.receiptdate, 103) AS doe, collections.createdby, collections.approvedby, collections.status,headofaccounts_master.accountname, subaccount_collection.headofaccount, subaccount_collection.collectionrefno, subaccount_collection.amount, collections.subbranch FROM  collections INNER JOIN subaccount_collection ON collections.sno = subaccount_collection.collectionrefno INNER JOIN headofaccounts_master ON subaccount_collection.headofaccount = headofaccounts_master.sno WHERE  (collections.receiptdate BETWEEN @d1 AND @d2) AND (collections.accountno = @accno) AND (collections.subbranch = @branchid)");
            cmd.Parameters.Add("@accno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@branchid", ddlbranchname.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtsalescollection = vdm.SelectQuery(cmd).Tables[0];
            if (dtsalescollection.Rows.Count > 0)
            {
                dtReport = new DataTable();
                dtReport.Columns.Add("Voucher Date");
                dtReport.Columns.Add("Voucher No");
                dtReport.Columns.Add("Voucher Type");
                dtReport.Columns.Add("NAME");
                dtReport.Columns.Add("Head Of Account");
                dtReport.Columns.Add("Amount");
                dtReport.Columns.Add("Narration");
                int i = 1;
                foreach (DataRow branch in dtsalescollection.Rows)
                {
                    DataRow newrow = dtReport.NewRow();
                    newrow["Voucher Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow["Voucher No"] = "BANK_PAY" + branch["collectionrefno"].ToString();
                    newrow["Voucher Type"] = "Bank SubReceipt Import";
                    if (branch["accountname"].ToString() == "")
                    {
                    }
                    else
                    {
                        newrow["Head Of Account"] = branch["accountname"].ToString();
                        newrow["NAME"] = branch["name"].ToString();
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
}