﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class ReceiptReport : System.Web.UI.Page
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
            cmd = new SqlCommand("SELECT sno, accountno FROM bankaccountno_master");
            DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
            ddlaccountno.DataSource = dtPlant;
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
            Session["filename"] = "Payment Approval Report";
            string Status = ddlStatus.SelectedValue;
            cmd = new SqlCommand("SELECT sno, accountno, name, amount, remarks, CONVERT(VARCHAR(10),receiptdate,103) as doe, createdby, approvedby, status FROM collections WHERE (receiptdate BETWEEN @d1 AND @d2) AND (accountno = @accountno) ORDER BY doe");
            cmd.Parameters.Add("@Status", 'P');
            //cmd.Parameters.Add("@BranchID", Session["branch"]);
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtCheque = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("ReceiptDate");
            Report.Columns.Add("ReceiptNo");
            Report.Columns.Add("Name");
            Report.Columns.Add("Status");
            //Report.Columns.Add("Approval");
            Report.Columns.Add("Amount").DataType = typeof(Double);
            //Report.Columns.Add("Remarks");
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
                    //newrow["Approval"] = dr["EmpName"].ToString();
                    // newrow["Remarks"] = dr["Remarks"].ToString();
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
                grdReports.DataSource = Report;
                grdReports.DataBind();
            }
            else
            {
                lblmsg.Text = "No payments were Found";
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
