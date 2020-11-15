using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;


public partial class trailbalancereport : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    VehicleDBMgr vdm;
    private object ddlType;
    //private object lblmsg;
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
                Fillfinacialyeardetails();
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
    void Fillfinacialyeardetails()
    {
        vdm = new VehicleDBMgr();
        cmd = new SqlCommand("SELECT   sno, startdate, enddate, year, currentyear, acclosed, doe, createdby FROM  financialyeardetails");
        DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
        ddlfinanialyear.DataSource = dtPlant;
        ddlfinanialyear.DataTextField = "year";
        ddlfinanialyear.DataValueField = "sno";
        ddlfinanialyear.DataBind();
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
            pnlHide.Visible = true;
            vdm = new VehicleDBMgr();
            //lblmsg.Text = "";
            Report.Columns.Add("CreditEntryDate");
            Report.Columns.Add("CreditBranchName");
            Report.Columns.Add("CreditFinancialYear");
            Report.Columns.Add("CreditAccountNumber");
            //Report.Columns.Add("CreditAccountType");
            Report.Columns.Add("CreditAmount");
            DateTime fromdate = DateTime.Now;
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
            cmd = new SqlCommand("SELECT  credit_note_entry.sno, credit_note_entry.date, credit_note_entry.financialyear, credit_note_entry.branchcode, credit_note_entry.vouchertype, credit_note_entry.vouchersubtype, credit_note_entry.accountcode AS account_code, credit_note_entry.partytype, credit_note_entry.partycode AS party_code, credit_note_entry.remarks, credit_note_entry.doe, credit_voucher_details.refno, credit_voucher_details.amount, credit_voucher_details.name, credit_voucher_details.budgetcode, credit_voucher_details.costcentercode, credit_voucher_details.description, credit_voucher_details.accountcode, financialyeardetails.year, branchmaster.code, branchmaster.branchname, transactiontype.transactiontype, transactionsubtypes.subtype, bankaccountno_master.accountno, bankaccountno_master.accounttype, fam_party_type.party_tp, fam_party_type.short_desc, partymaster.partycode, bankaccountno_master_1.accountno AS accountid1, bankaccountno_master_1.accounttype AS accounttype1, costcenter_master.costcentercode AS costcodeid, costcenter_master.costcenterdesc, budgetmaster.budgetcode AS budgectcodeid FROM credit_note_entry LEFT OUTER JOIN credit_voucher_details ON credit_note_entry.sno = credit_voucher_details.refno LEFT OUTER JOIN financialyeardetails ON credit_note_entry.financialyear = financialyeardetails.sno LEFT OUTER JOIN branchmaster ON credit_note_entry.branchcode = branchmaster.branchid LEFT OUTER JOIN transactiontype ON credit_note_entry.vouchertype = transactiontype.sno LEFT OUTER JOIN transactionsubtypes ON credit_note_entry.vouchersubtype = transactionsubtypes.sno LEFT OUTER JOIN bankaccountno_master ON credit_note_entry.accountcode = bankaccountno_master.sno LEFT OUTER JOIN fam_party_type ON credit_note_entry.partytype = fam_party_type.sno LEFT OUTER JOIN partymaster ON credit_note_entry.partycode = partymaster.sno LEFT OUTER JOIN bankaccountno_master AS bankaccountno_master_1 ON credit_voucher_details.accountcode = bankaccountno_master_1.sno LEFT OUTER JOIN costcenter_master ON credit_voucher_details.costcentercode = costcenter_master.sno LEFT OUTER JOIN budgetmaster ON credit_voucher_details.budgetcode = budgetmaster.sno WHERE (credit_note_entry.date BETWEEN @d1 AND @d2) AND (credit_note_entry.branchcode = @branchcode) AND (credit_note_entry.financialyear = @financialyear)");
            cmd.Parameters.Add("@branchcode", ddlbranchname.SelectedValue);
            cmd.Parameters.Add("@financialyear", ddlfinanialyear.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtcollection = vdm.SelectQuery(cmd).Tables[0];
            double cradittotalamount = 0;
            foreach (DataRow dr in dtcollection.Rows)
            {
                DataRow newrow = Report.NewRow();
                newrow["CreditEntryDate"] = dr["date"].ToString();
                newrow["CreditBranchName"] = dr["branchname"].ToString();
                newrow["CreditFinancialYear"] = dr["year"].ToString();
                newrow["CreditAccountNumber"] = dr["accountid1"].ToString();
                //newrow["CreditAccountType"] = dr["accounttype1"].ToString();
                //newrow["CreditAmount"] = dr["amount"].ToString();
                double amount = 0;
                double.TryParse(dr["amount"].ToString(), out amount);
                newrow["CreditAmount"] = amount;
                cradittotalamount += amount;
                //newrow["CreditAmount"] = dr["amount"].ToString();
                Report.Rows.Add(newrow);
            }
            DataRow report = Report.NewRow();
            report["CreditAccountNumber"] = "Total";
            report["CreditAmount"] = cradittotalamount;
            Report.Rows.Add(report);
            grdcollections.DataSource = Report;
            grdcollections.DataBind();
            DataTable dtpayment = new DataTable();
            dtpayment.Columns.Add("DebitEntryDate");
            dtpayment.Columns.Add("DebitBranchName");
            dtpayment.Columns.Add("DebitFinancialYear");
            dtpayment.Columns.Add("DebitAccountNumber");
            //dtpayment.Columns.Add("DebitAccountType");
            dtpayment.Columns.Add("DebitAmount");

            cmd = new SqlCommand("SELECT  debit_note_entry.sno, debit_note_entry.date, debit_note_entry.financialyear, debit_note_entry.branchcode, debit_note_entry.vouchertype, debit_note_entry.vouchersubtype, debit_note_entry.accountcode, debit_note_entry.partytype, debit_note_entry.partycode, debit_note_entry.remarks, debit_voucher_details.accountcode AS Expr2, debit_voucher_details.description, debit_voucher_details.costcentercode, debit_voucher_details.budgetcode, debit_voucher_details.name, debit_voucher_details.amount, debit_voucher_details.refno, financialyeardetails.year, branchmaster.code, branchmaster.branchname, transactiontype.transactiontype, transactionsubtypes.subtype, bankaccountno_master_1.accountno, bankaccountno_master_1.accounttype, fam_party_type.party_tp, partymaster.partytype AS partytypeid, debit_voucher_details.sno AS sno1, bankaccountno_master.accounttype AS accounttype1,  bankaccountno_master.accountno AS accountid1, costcenter_master.costcentercode AS costcenterid, budgetmaster.budgetcode AS budgectid FROM  bankaccountno_master LEFT OUTER JOIN debit_voucher_details ON bankaccountno_master.sno = debit_voucher_details.sno LEFT OUTER JOIN costcenter_master ON debit_voucher_details.costcentercode = costcenter_master.sno LEFT OUTER JOIN budgetmaster ON debit_voucher_details.budgetcode = budgetmaster.sno RIGHT OUTER JOIN debit_note_entry LEFT OUTER JOIN financialyeardetails ON debit_note_entry.financialyear = financialyeardetails.sno LEFT OUTER JOIN branchmaster ON debit_note_entry.branchcode = branchmaster.branchid LEFT OUTER JOIN transactiontype ON debit_note_entry.sno = transactiontype.sno LEFT OUTER JOIN transactionsubtypes ON debit_note_entry.vouchersubtype = transactionsubtypes.sno LEFT OUTER JOIN bankaccountno_master AS bankaccountno_master_1 ON debit_note_entry.accountcode = bankaccountno_master_1.sno LEFT OUTER JOIN fam_party_type ON debit_note_entry.partytype = fam_party_type.sno LEFT OUTER JOIN partymaster ON debit_note_entry.partycode = partymaster.sno ON debit_voucher_details.sno = debit_note_entry.sno WHERE (debit_note_entry.date BETWEEN @d1 AND @d2) AND (debit_note_entry.financialyear = @financialyear) AND (debit_note_entry.branchcode = @branchcode)");
            cmd.Parameters.Add("@branchcode", ddlbranchname.SelectedValue);
            cmd.Parameters.Add("@financialyear", ddlfinanialyear.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque1 = vdm.SelectQuery(cmd).Tables[0];
            double debittotalamount = 0;
            foreach (DataRow dr in dtCheque1.Rows)
            {
                DataRow dtnewrow1 = dtpayment.NewRow();

                dtnewrow1["DebitEntryDate"] = dr["date"].ToString();
                dtnewrow1["DebitBranchName"] = dr["branchname"].ToString();
                dtnewrow1["DebitFinancialYear"] = dr["year"].ToString();
                dtnewrow1["DebitAccountNumber"] = dr["accountid1"].ToString();
                //dtnewrow1["DebitAccountType"] = dr["accounttype1"].ToString();
                //newrow["DebitAmount"] = dr["amount"].ToString();
                double amount1 = 0;
                double.TryParse(dr["amount"].ToString(), out amount1);
                dtnewrow1["DebitAmount"] = amount1;
                debittotalamount += amount1;

                dtpayment.Rows.Add(dtnewrow1);
            }
            double difference = 0;
            DataRow newvartical2 = dtpayment.NewRow();
            newvartical2["DebitAccountNumber"] = "Total";
            newvartical2["DebitAmount"] = debittotalamount;
            //DataRow newvartical3 = dtpayment.NewRow();
            difference = cradittotalamount - debittotalamount;
            //newvartical3["DebitAccountNumber"] = "Difference";
            //newvartical3["DebitAmount"] = difference;
            lblclosingbal.Text = difference.ToString();
            dtpayment.Rows.Add(newvartical2);
            //dtpayment.Rows.Add(newvartical3);
            grdpayments.DataSource = dtpayment;
            grdpayments.DataBind();

        }
        catch (Exception ex)
        {
            //lblbankmsg.Text = ex.Message;
        }
    }
}
