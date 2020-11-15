using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class PostdatedChequeStatus : System.Web.UI.Page
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
                FillACNo();
            }
        }
    }
    void FillACNo()
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  sno,accountno FROM bankaccountno_master");
            DataTable dtAC = vdm.SelectQuery(cmd).Tables[0];
            ddlaccountno.DataSource = dtAC;
            ddlaccountno.DataTextField = "accountno";
            ddlaccountno.DataValueField = "sno";
            ddlaccountno.DataBind();
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
            string dept = ddlaccountno.SelectedValue;
            cmd = new SqlCommand("SELECT  postdated_cheques_entry.partycode, postdated_cheques_entry.chequeno, postdated_cheques_entry.amount, postdated_cheques_entry.remarks,postdated_cheques_entry.status, partymaster.partyname FROM  postdated_cheques_entry INNER JOIN partymaster ON postdated_cheques_entry.partycode = partymaster.sno where (postdated_cheques_entry.accountcode=@accountno) and (postdated_cheques_entry.chequedate BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("PartyName");
            Report.Columns.Add("ChequeNo");
            Report.Columns.Add("Amount").DataType = typeof(Double);
            Report.Columns.Add("Remarks");
           // Report.Columns.Add("Credit");
            Report.Columns.Add("Status");
           // Report.Columns.Add("Particulars");
            if (dtCheque.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtCheque.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["PartyName"] = dr["partyname"].ToString();
                    newrow["ChequeNo"] = dr["chequeno"].ToString();
                    newrow["Amount"] = dr["amount"].ToString();
                    newrow["Remarks"] = dr["remarks"].ToString();
                   // newrow["Amount"] = dr["reqamount"].ToString();
                    //newrow["AvailableAmount"] = dr["availableamount"].ToString();
                   // newrow["Particulars"] = dr["particulars"].ToString();
                    string ColStatus = dr["status"].ToString();
                    string chequestatus = "";
                    if (ColStatus == "R")
                    {
                        chequestatus = "Raised";
                    }
                    if (ColStatus == "A")
                    {
                        chequestatus = "Approved";
                    }
                    if (ColStatus == "C")
                    {
                        chequestatus = "Rejected";
                    }
                    if (ColStatus == "P")
                    {
                        chequestatus = "Pending";
                    }
                    newrow["Status"] = chequestatus;
                    Report.Rows.Add(newrow);
                }
                grdReports.DataSource = Report;
                grdReports.DataBind();
            }
            else
            {
                lblmsg.Text = "No Data Found";
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