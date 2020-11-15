using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class SuspenseBillVoucher : System.Web.UI.Page
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
                txtfromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                txttodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                lblTitle.Text = Session["TitleName"].ToString();
            }
        }
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
    protected void btn_getdetails_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime fromdate = DateTime.Now;
            string[] dateFromstrig = txtfromdate.Text.Split(' ');
            if (dateFromstrig.Length > 1)
            {
                if (dateFromstrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateFromstrig[0].Split('-');
                    string[] times = dateFromstrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }

            DateTime todate = DateTime.Now;
            string[] Todatestrig = txttodate.Text.Split(' ');
            if (Todatestrig.Length > 1)
            {
                if (Todatestrig[0].Split('-').Length > 0)
                {
                    string[] dates = Todatestrig[0].Split('-');
                    string[] times = Todatestrig[1].Split(':');
                    todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            if (BranchID == "1")
            {
                cmd = new SqlCommand("SELECT suspense_bill_entry.sno AS refno, suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate, suspense_bill_entry.financialyear, suspense_bill_entry.reqdate, suspense_bill_entry.reqamount,suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses, suspense_bill_entry.balamount, suspense_bill_entry.status FROM suspense_bill_entry INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno where (suspense_bill_entry.doe BETWEEN @d1 AND @d2)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@BranchID", BranchID);
            }
            else
            {
                cmd = new SqlCommand("SELECT suspense_bill_entry.sno AS refno, suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate, suspense_bill_entry.financialyear, suspense_bill_entry.reqdate, suspense_bill_entry.reqamount,suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses, suspense_bill_entry.balamount, suspense_bill_entry.status FROM suspense_bill_entry INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno where (suspense_bill_entry.doe BETWEEN @d1 AND @d2)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            DataTable dtDispatch = vdm.SelectQuery(cmd).Tables[0];
            if (dtDispatch.Rows.Count > 0)
            {
                Gridcdata.DataSource = dtDispatch;
                Gridcdata.DataBind();
            }
            else
            {
                lbldateValidation.Text = "No data were found";
            }
        }
        catch (Exception ex)
        {
            lbldateValidation.Text = ex.Message;

        }
    }
    DataTable Report = new DataTable();
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            vdm = new VehicleDBMgr();
            if (BranchID == "1")
            {
                cmd = new SqlCommand("SELECT suspense_bill_entry.sno AS referenceno, suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate, suspense_bill_entry.financialyear, suspense_bill_entry.suspensereqno, suspense_bill_entry.reqdate, suspense_bill_entry.reqamount, suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses, suspense_bill_entry.balamount, suspense_bill_entry.status, suspense_bill_subentry.sno AS Expr1, suspense_bill_subentry.grnno, suspense_bill_subentry.billno, suspense_bill_subentry.billdate, suspense_bill_subentry.amount,suspense_bill_subentry.refno, suspense_bill_subentry.remarks, suspensecashrequisition.reqno FROM suspense_bill_entry INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno AND suspense_bill_entry.sno = suspense_bill_subentry.refno INNER JOIN suspensecashrequisition ON suspense_bill_entry.suspensereqno = suspensecashrequisition.sno  where (suspense_bill_entry.sno =@referenceno)");
                cmd.Parameters.Add("@referenceno", txtrefno.Text);
                cmd.Parameters.Add("@BranchID", BranchID);
            }
            else
            {
                cmd = new SqlCommand("SELECT suspense_bill_entry.sno AS referenceno, suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate, suspense_bill_entry.financialyear, suspense_bill_entry.suspensereqno, suspense_bill_entry.reqdate, suspense_bill_entry.reqamount, suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses, suspense_bill_entry.balamount, suspense_bill_entry.status, suspense_bill_subentry.sno AS Expr1, suspense_bill_subentry.grnno, suspense_bill_subentry.billno, suspense_bill_subentry.billdate, suspense_bill_subentry.amount,suspense_bill_subentry.refno, suspense_bill_subentry.remarks, suspensecashrequisition.reqno FROM suspense_bill_entry INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno AND suspense_bill_entry.sno = suspense_bill_subentry.refno INNER JOIN suspensecashrequisition ON suspense_bill_entry.suspensereqno = suspensecashrequisition.sno  where (suspense_bill_entry.sno =@referenceno)");
                cmd.Parameters.Add("@referenceno", txtrefno.Text);
            }
            DataTable dtable = vdm.SelectQuery(cmd).Tables[0];
            if (dtable.Rows.Count > 0)
            {
                DataView view1 = new DataView(dtable);
                DataTable dtlblValues = view1.ToTable(true, "referenceno", "transactionno", "transactiondate", "financialyear","reqno","suspensereqno", "reqdate", "reqamount","sectioncode", "particulars", "actualexpenses", "balamount", "status");
                DataTable dtgrdValues = view1.ToTable(true, "grnno","billno", "billdate","amount", "remarks");
                if (dtlblValues.Rows.Count > 0)
                {
                    txttxnno.Text = dtlblValues.Rows[0]["transactionno"].ToString();
                    txttranactiondate.Text = dtlblValues.Rows[0]["transactiondate"].ToString();
                    txtfinacialyear.Text = dtlblValues.Rows[0]["financialyear"].ToString();
                   // txtnatureofwork.Text = dtlblValues.Rows[0]["natureofwork"].ToString();
                  //  txtdesig.Text = dtlblValues.Rows[0]["designationcode"].ToString();
                   // txtempname.Text = dtlblValues.Rows[0]["empcode"].ToString();
                    txtsuspreqno.Text = dtlblValues.Rows[0]["reqno"].ToString();
                    txtsuspreqdate.Text = dtlblValues.Rows[0]["reqdate"].ToString();
                   // txtdepartmentname.Text = dtlblValues.Rows[0]["deptcode"].ToString();
                    txtreqamt.Text = dtlblValues.Rows[0]["reqamount"].ToString();
                    txtparticulars.Text = dtlblValues.Rows[0]["particulars"].ToString();
                    txtsectioncode.Text = dtlblValues.Rows[0]["sectioncode"].ToString();
                    txtactexpenses.Text = dtlblValues.Rows[0]["actualexpenses"].ToString();
                    txtbalamount.Text = dtlblValues.Rows[0]["balamount"].ToString();
                    string status = dtlblValues.Rows[0]["status"].ToString();
                    if (status == "P")
                    {
                        status = "Pending";
                    }
                    else
                    {
                        status = "Approval";
                    }
                    txtstatus.Text = status;
                }
                if (dtgrdValues.Rows.Count > 0)
                {
                    grdReports.DataSource = dtgrdValues;
                    grdReports.DataBind();
                }
                pnlHide.Visible = true;
            }
            else
            {
                lblmsg.Text = "No data were found";
                pnlHide.Visible = false;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            pnlHide.Visible = false;
        }
    }
}