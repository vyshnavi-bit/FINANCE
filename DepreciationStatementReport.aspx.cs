using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class DepreciationStatementReport : System.Web.UI.Page
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

            }
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
            Session["filename"] = "DepreciationStatement Report";
            cmd = new SqlCommand("SELECT  DS.sno, DS.branchcode, DS.financialyear, DS.date, DSS.sno AS sno1, DSS.accountcode, DSS.groupcode, DSS.deprate, DSS.openingwdv, DSS.additions, DSS.purchasedate, DSS.sales, DSS.saledate,DSS.noofdays, DSS.depramount, DSS.closingwdv, DSS.soldwdv, DSS.profitloss, DSS.refno, FYD.year, BM.branchname, BM.code, DS.doe, GLM.groupcode AS groupid, BAM.accounttype, BAM.accountno FROM   depreciation_statement AS DS INNER JOIN  depreciation_sub_statement AS DSS ON DS.sno = DSS.refno LEFT OUTER JOIN   bankaccountno_master AS BAM ON DSS.accountcode = BAM.sno LEFT OUTER JOIN  financialyeardetails AS FYD ON DS.financialyear = FYD.sno LEFT OUTER JOIN  branchmaster AS BM ON DS.branchcode = BM.branchid LEFT OUTER JOIN  groupledgermaster AS GLM ON DSS.groupcode = GLM.sno WHERE (DS.date BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("Date");
            Report.Columns.Add("Branchcode");
            Report.Columns.Add("FinancialYear");
            Report.Columns.Add("GroupCode");
            Report.Columns.Add("Sales");
            Report.Columns.Add("OpeningWDV");
            Report.Columns.Add("ClosingWDV");
            Report.Columns.Add("SoldWDV");
            Report.Columns.Add("Profit/Loss");
            Report.Columns.Add("Dep.Amount").DataType = typeof(Double);
            Report.Columns.Add("Addition");
            if (dtCheque.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtCheque.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Date"] = dr["date"].ToString();
                    newrow["Branchcode"] = dr["code"].ToString();
                    newrow["FinancialYear"] = dr["year"].ToString();
                    newrow["GroupCode"] = dr["groupid"].ToString();
                    newrow["Sales"] = dr["sales"].ToString();
                    newrow["OpeningWDV"] = dr["openingwdv"].ToString();
                    newrow["ClosingWDV"] = dr["closingwdv"].ToString();
                    newrow["SoldWDV"] = dr["soldwdv"].ToString();
                    newrow["Profit/Loss"] = dr["profitloss"].ToString();
                    //double Amount = 0;
                    //double.TryParse(dr["amount"].ToString(), out Amount);
                    newrow["Dep.Amount"] = dr["depramount"].ToString();
                    newrow["Addition"] = dr["additions"].ToString();
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
                lblmsg.Text = "No DepreciationStatement were Found";
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