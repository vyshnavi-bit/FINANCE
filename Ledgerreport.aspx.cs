using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class Ledgerreport : System.Web.UI.Page
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
    void GetReport()
    {
        try
        {
            pnlfoter.Visible = true;
            pnlHide.Visible = true;
            lblbank.Text = "";
            lblbankmsg.Text = "";
            vdm = new VehicleDBMgr();
            DataTable colection = new DataTable();
            DataTable payment = new DataTable();
            DataTable Report = new DataTable();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string ledgername = TextBox1.Text;
            lbl_ledger.Text = ledgername;
            Report.Columns.Add("Receipts");
            Report.Columns.Add("Amount");
            string[] fromdatestrig = txtFromdate.Text.Split(' ');
            if (fromdatestrig.Length > 1)
            {
                if (fromdatestrig[0].Split('-').Length > 0)
                {
                    string[] dates = fromdatestrig[0].Split('-');
                    string[] times = fromdatestrig[1].Split(':');
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
            Session["filename"] = "Ledger Report ->" + ledgername;
            string Status = ddlStatus.SelectedValue;
            cmd = new SqlCommand("SELECT        c.name, bam.accountno, ham.accountname, csd.amount, c.doe, c.sno, c.status, c.remarks, c.receiptdate FROM   collections AS c INNER JOIN  collectionsubdetails AS csd ON csd.collectionrefno = c.sno INNER JOIN  bankaccountno_master AS bam ON bam.sno = c.accountno INNER JOIN   headofaccounts_master AS ham ON ham.sno = csd.headofaccount WHERE        (ham.accountname = @accountname) AND (c.receiptdate BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@Status", 'P');
            cmd.Parameters.Add("@accountname", ledgername);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("ReceiptDate");
            Report.Columns.Add("ReceiptNo");
            Report.Columns.Add("Name");
            Report.Columns.Add("Status");
            Report.Columns.Add("Amount").DataType = typeof(Double);
            Report.Columns.Add("ApprovalRemarks");
            Report.Columns.Add("Head Of Account");
            if (dtCheque.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtCheque.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["ReceiptDate"] = dr["doe"].ToString();
                    newrow["ReceiptNo"] = dr["sno"].ToString();
                    newrow["Name"] = dr["name"].ToString();
                    string ColStatus = dr["status"].ToString();
                    string ChequeStatus = "";
                    if (ColStatus == "R")
                    {
                        ChequeStatus = "Raised";
                    }
                    if (ColStatus == "A")
                    {
                        ChequeStatus = "Approved";
                    }
                    if (ColStatus == "C")
                    {
                        ChequeStatus = "Rejected";
                    }
                    if (ColStatus == "P")
                    {
                        ChequeStatus = "Paid";
                    }
                    newrow["Status"] = ChequeStatus;
                    double Amount = 0;
                    double.TryParse(dr["amount"].ToString(), out Amount);
                    newrow["Amount"] = Amount;
                    newrow["ApprovalRemarks"] = dr["remarks"].ToString();
                    cmd = new SqlCommand("SELECT headofaccounts_master.accountname, collectionsubdetails.amount FROM collectionsubdetails INNER JOIN headofaccounts_master ON collectionsubdetails.headofaccount = headofaccounts_master.sno WHERE (collectionsubdetails.collectionrefno = @Refno)");
                    cmd.Parameters.Add("@Refno", dr["sno"].ToString());
                    DataTable dtheadacc = vdm.SelectQuery(cmd).Tables[0];
                    string head = "";
                    foreach (DataRow drhead in dtheadacc.Rows)
                    {
                        head += drhead["accountname"].ToString() + "-->" + drhead["amount"].ToString() + "\r\n";
                    }
                    newrow["Head Of Account"] = head;
                    Report.Rows.Add(newrow);
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Name"] = "Total Amount";
                double val = 0.0;
                foreach (DataColumn dc in Report.Columns)
                {
                    if (dc.DataType == typeof(Double))
                    {
                        val = 0.0;
                        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                        newTotal[dc.ToString()] = val;
                    }
                }
                Report.Rows.Add(newTotal);
                grdcollections.DataSource = Report;
                grdcollections.DataBind();
            }
            cmd = new SqlCommand("SELECT   p.name, bam.accountno, ham.accountname, psd.amount, p.doe, p.sno, p.status, p.remarks, employe_login.name AS approvedby FROM  paymentdetails AS p INNER JOIN    paymentsubdetails AS psd ON psd.paymentrefno = p.sno INNER JOIN   bankaccountno_master AS bam ON bam.sno = p.accountno INNER JOIN  headofaccounts_master AS ham ON ham.sno = psd.headofaccount INNER JOIN employe_login ON p.approvedby = employe_login.sno  WHERE  (ham.accountname = @accountname) AND (p.paymentdate BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@Status", 'P');
            cmd.Parameters.Add("@accountname", ledgername);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque1 = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("PaymentDate");
            Report.Columns.Add("PaymentID");
            Report.Columns.Add("Name");
            Report.Columns.Add("Status");
            Report.Columns.Add("Amount").DataType = typeof(Double);
            Report.Columns.Add("ApprovalRemarks");
            Report.Columns.Add("Head Of Account");
            if (dtCheque1.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtCheque1.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["PaymentDate"] = dr["doe"].ToString();
                    newrow["PaymentID"] = dr["sno"].ToString();
                    newrow["Name"] = dr["name"].ToString();
                    string ColStatus = dr["status"].ToString();
                    string ChequeStatus = "";
                    if (ColStatus == "R")
                    {
                        ChequeStatus = "Raised";
                    }
                    if (ColStatus == "A")
                    {
                        ChequeStatus = "Approved";
                    }
                    if (ColStatus == "C")
                    {
                        ChequeStatus = "Rejected";
                    }
                    if (ColStatus == "P")
                    {
                        ChequeStatus = "Paid";
                    }
                    newrow["Status"] = ChequeStatus;
                    double Amount = 0;
                    double.TryParse(dr["amount"].ToString(), out Amount);
                    newrow["Amount"] = Amount;
                    newrow["ApprovalRemarks"] = dr["remarks"].ToString();
                    cmd = new SqlCommand("SELECT headofaccounts_master.accountname, paymentsubdetails.amount FROM paymentsubdetails INNER JOIN headofaccounts_master ON paymentsubdetails.headofaccount = headofaccounts_master.sno WHERE (paymentsubdetails.paymentrefno = @Refno)");
                    cmd.Parameters.Add("@Refno", dr["sno"].ToString());
                    DataTable dtheadacc = vdm.SelectQuery(cmd).Tables[0];
                    string head = "";
                    foreach (DataRow drhead in dtheadacc.Rows)
                    {
                        head += drhead["accountname"].ToString() + "-->" + drhead["amount"].ToString() + "\r\n";
                    }
                    newrow["Head Of Account"] = head;
                    Report.Rows.Add(newrow);
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Name"] = "Total Amount";
                double val = 0.0;
                foreach (DataColumn dc in Report.Columns)
                {
                    if (dc.DataType == typeof(Double))
                    {
                        val = 0.0;
                        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                        newTotal[dc.ToString()] = val;
                    }
                }
                Report.Rows.Add(newTotal);
                grdpayments.DataSource = Report;
                grdpayments.DataBind();

            }
            cmd = new SqlCommand("SELECT journel_entry.sno, branchmaster.branchname,branchmaster.code, journel_entry.amount, journel_entry.remarks, CONVERT(VARCHAR(10), journel_entry.jvdate, 103) AS jvdate, journel_entry.createdby, journel_entry.status FROM journel_entry INNER JOIN branchmaster ON journel_entry.branchid = branchmaster.branchid WHERE (journel_entry.jvdate BETWEEN @d1 AND @d2) and (journel_entry.branchid=@BranchID) ORDER BY doe");
            cmd.Parameters.Add("@Status", 'P');
            cmd.Parameters.Add("@BranchID", ddlbranchname.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque2 = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("JV Date");
            Report.Columns.Add("JV No");
            Report.Columns.Add("Name");
            Report.Columns.Add("Status");
            Report.Columns.Add("Amount").DataType = typeof(Double);
            Report.Columns.Add("ApprovalRemarks");
            Report.Columns.Add("Debit Account");
            Report.Columns.Add("Credit Account");
            if (dtCheque2.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtCheque2.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["JV Date"] = dr["jvdate"].ToString();
                    newrow["JV No"] = dr["code"].ToString() + "_" + dr["sno"].ToString();
                    newrow["Name"] = dr["branchname"].ToString();
                    string ColStatus = dr["status"].ToString();
                    string ChequeStatus = "";
                    if (ColStatus == "R")
                    {
                        ChequeStatus = "Raised";
                    }
                    if (ColStatus == "A")
                    {
                        ChequeStatus = "Approved";
                    }
                    if (ColStatus == "C")
                    {
                        ChequeStatus = "Rejected";
                    }
                    if (ColStatus == "P")
                    {
                        ChequeStatus = "Paid";
                    }
                    newrow["Status"] = ChequeStatus;
                    double Amount = 0;
                    double.TryParse(dr["amount"].ToString(), out Amount);
                    newrow["Amount"] = Amount;
                    newrow["ApprovalRemarks"] = dr["remarks"].ToString();
                    cmd = new SqlCommand("SELECT subjournel_entry.amount, headofaccounts_master.accountname FROM subjournel_entry INNER JOIN headofaccounts_master ON subjournel_entry.headofaccount = headofaccounts_master.sno WHERE (subjournel_entry.refno = @Refno)");
                    cmd.Parameters.Add("@Refno", dr["sno"].ToString());
                    DataTable dtheadacc = vdm.SelectQuery(cmd).Tables[0];
                    string Debithead = "";
                    foreach (DataRow drhead in dtheadacc.Rows)
                    {
                        Debithead += drhead["accountname"].ToString() + "-->" + drhead["amount"].ToString() + "\r\n";
                    }
                    newrow["Debit Account"] = Debithead;
                    cmd = new SqlCommand("SELECT subjournel_credit_entry.amount, headofaccounts_master.accountname FROM subjournel_credit_entry INNER JOIN headofaccounts_master ON subjournel_credit_entry.headofaccount = headofaccounts_master.sno WHERE (subjournel_credit_entry.refno = @Refno)");
                    cmd.Parameters.Add("@Refno", dr["sno"].ToString());
                    DataTable dtCreditheadacc = vdm.SelectQuery(cmd).Tables[0];
                    string Credithead = "";
                    foreach (DataRow drhead in dtCreditheadacc.Rows)
                    {
                        Credithead += drhead["accountname"].ToString() + "-->" + drhead["amount"].ToString() + "\r\n";
                    }
                    newrow["Credit Account"] = Credithead;
                    Report.Rows.Add(newrow);
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Name"] = "Total Amount";
                double val = 0.0;
                foreach (DataColumn dc in Report.Columns)
                {
                    if (dc.DataType == typeof(Double))
                    {
                        val = 0.0;
                        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                        newTotal[dc.ToString()] = val;
                    }
                }
                Report.Rows.Add(newTotal);
                grdReports.DataSource = Report;
                grdReports.DataBind();
            }
        }
        catch (Exception ex)
        {
            //lblmsg.Text = ex.Message;
        }
    }

    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        GetReport();
        ScriptManager.RegisterStartupScript(Page, GetType(), "JsStatus", "get_headofaccount_details();", true);
    }
    
}