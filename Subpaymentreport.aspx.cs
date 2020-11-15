using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Subpaymentreport : System.Web.UI.Page
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
        //vdm = new VehicleDBMgr();
        if (!this.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                lblTitle.Text = Session["TitleName"].ToString();
                txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                //txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                Fillbankdetails();
                Fillbranchdetails();
                //btnGenerate.Visible = false;
                //txtpay.Visible = false;

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
    void FillPaymentName()
    {
        try
        {
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
            //DateTime todate = DateTime.Now;
            ////string[] Todatestrig = txtTodate.Text.Split(' ');
            //if (Todatestrig.Length > 1)
            //{
            //    if (Todatestrig[0].Split('-').Length > 0)
            //    {
            //        string[] dates = Todatestrig[0].Split('-');
            //        string[] times = Todatestrig[1].Split(':');
            //        todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
            //    }
            //}
            //lbl_selfromdate.Text = fromdate.ToString("dd/MM/yyyy");
            //lbl_selftodate.Text = todate.ToString("dd/MM/yyyy");
            //cmd = new SqlCommand("SELECT sno, name FROM paymentdetails WHERE (accountno = @accno) AND (paymentdate BETWEEN @d1 AND @d2)");
            //cmd.Parameters.Add("@accno", ddlaccountno.SelectedValue);
            //cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            //cmd.Parameters.Add("@d2", GetHighDate(todate));
            //DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
            //ddlname.DataSource = dtPlant;
            //ddlname.DataTextField = "name";
            //ddlname.DataValueField = "sno";
            //ddlname.DataBind();
        }
        catch
        {
        }
    }

    //protected void btnGet_Click(object sender, EventArgs e)
    //{
    //    FillPaymentName();
    //}
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
            lblmsg.Text = "";
            pnlHide.Visible = true;
            //Session["RouteName"] = ddlname.SelectedItem.Text;
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
            //DateTime todate = DateTime.Now;
            //string[] Todatestrig = txtTodate.Text.Split(' ');
            //if (Todatestrig.Length > 1)
            //{
            //    if (Todatestrig[0].Split('-').Length > 0)
            //    {
            //        string[] dates = Todatestrig[0].Split('-');
            //        string[] times = Todatestrig[1].Split(':');
            //        todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
            //    }
            //}
            //txtFromdate.Text = fromdate.ToString("dd/MM/yyyy");
            //txtTodate.Text = todate.ToString("dd/MM/yyyy");
            //ddlbranchname.Text = ddlbranchname.SelectedItem.Text;
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

            //cmd = new SqlCommand("SELECT paymentdetails.remarks,  paymentsubdetails.amount,CONVERT(VARCHAR(10), paymentdetails.paymentdate, 103) AS doe, headofaccounts_master.accountname, paymentdetails.sno, paymentdetails.accountno, paymentdetails.paymentdate FROM paymentdetails INNER JOIN paymentsubdetails ON paymentdetails.sno = paymentsubdetails.sno INNER JOIN headofaccounts_master ON paymentsubdetails.headofaccount = headofaccounts_master.sno WHERE (paymentdetails.paymentdate BETWEEN @d1 AND @d2) AND (paymentdetails.accountno = @accountno) ORDER BY doe");
            //cmd = new SqlCommand("SELECT     p.remarks,  psd.paymentrefno,p.sno,  p.name, bam.accountno,bam.ladger_dr, ham.accountname, psd.amount,CONVERT(VARCHAR(10), p.doe, 103) AS doe FROM paymentdetails AS p INNER JOIN subaccount_payment  AS psd ON psd.paymentrefno = p.sno INNER JOIN bankaccountno_master AS bam ON bam.sno = p.accountno INNER JOIN headofaccounts_master AS ham ON ham.sno = psd.headofaccount WHERE (p.accountno = @accno) AND (psd.branchid = @branchid) AND (p.paymentdate BETWEEN @d1 AND @d2)");
            cmd = new SqlCommand("SELECT p.remarks, p.sno, p.name,p.sub_branch, bam.accountno, bam.ladger_dr, ham.accountname as hoc, CONVERT(VARCHAR(10), p.doe, 103) AS doe, subaccount_payment.amount, subaccount_payment.headofaccount, subaccount_payment.paymentrefno, headofaccounts_master.accountname FROM   headofaccounts_master AS ham INNER JOIN subaccount_payment ON ham.sno = subaccount_payment.sno INNER JOIN paymentdetails AS p INNER JOIN bankaccountno_master AS bam ON bam.sno = p.accountno ON subaccount_payment.paymentrefno = p.sno INNER JOIN  headofaccounts_master ON subaccount_payment.headofaccount = headofaccounts_master.sno WHERE (p.accountno = @accno) AND (p.paymentdate BETWEEN @d1 AND @d2) and (p.sub_branch=@branchid)");
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
                    newrow["Voucher No"] = "BANK_PAY" + branch["paymentrefno"].ToString();
                    newrow["Voucher Type"] = "Bank SubPayment Import";
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
                lblmsg.Text = "No Indent Found";
                grdReports.DataSource = dtReport;
                grdReports.DataBind();
            }
        }
        catch (Exception ex)
        {
            pnlHide.Visible = false;
            lblmsg.Text = ex.Message;
        }
    }
}