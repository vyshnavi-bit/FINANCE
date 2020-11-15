using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class BankPassbookUnmatchedEntryReport : System.Web.UI.Page
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
                txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                FillRouteName();

            }
        }

    }
    void FillRouteName()
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno, bankname FROM bankmaster");
            DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
            ddlbankname.DataSource = dtPlant;
            ddlbankname.DataTextField = "bankname";
            ddlbankname.DataValueField = "sno";
            ddlbankname.DataBind();
        }
        catch
        {
        }
    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        GetReport();
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
    DataTable Report = new DataTable();
    void GetReport()
    {
        try
        {
            pnlHide.Visible = true;
            vdm = new VehicleDBMgr();
            lblmsg.Text = "";
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
            Session["filename"] = "Unmatched Entry Report";
            cmd = new SqlCommand("SELECT brspassbook_unmatched_details.amounttranstype, brspassbook_unmatched_details.doe, brspassbook_unmatched_details.amount, brspassbook_unmatched_details.checkno, brspassbook_unmatched_details.remarks, brspassbook_unmatched_details.entrydate, brspassbook_unmatched_details.status, brspassbook_unmatched_details.ddno FROM  brspassbook_unmatched_details INNER JOIN bankmaster ON brspassbook_unmatched_details.bankid = bankmaster.sno WHERE (brspassbook_unmatched_details.bankid = @bankid) AND (brspassbook_unmatched_details.entrydate BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@bankid", ddlbankname.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("UnmatchedEntryDate");
            Report.Columns.Add("Checkno");
            Report.Columns.Add("DDno");
            Report.Columns.Add("AmountTransactionType");
            Report.Columns.Add("Status");
            Report.Columns.Add("Amount").DataType = typeof(Double);
            Report.Columns.Add("Remarks");
            if (dtCheque.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtCheque.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["UnmatchedEntryDate"] = dr["entrydate"].ToString();
                    newrow["Checkno"] = dr["checkno"].ToString();
                    newrow["DDno"] = dr["ddno"].ToString();
                    newrow["AmountTransactionType"] = dr["amounttranstype"].ToString();
                    newrow["Status"] = dr["status"].ToString();
                    //double Amount = 0;
                    //double.TryParse(dr["amount"].ToString(), out Amount);
                    newrow["Amount"] = dr["amount"].ToString();
                    newrow["Remarks"] = dr["remarks"].ToString();
                    Report.Rows.Add(newrow);
                }
                DataRow newTotal = Report.NewRow();
                //newTotal["Name"] = "Total Amount";
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
            else
            {
                lblmsg.Text = "No Unmatched Entry were Found";
                grdReports.DataSource = Report;
                grdReports.DataBind();
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            grdReports.DataSource = Report;
            grdReports.DataBind();
        }
    }
}
