using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class MiscellaneousBillvouchergeneration : System.Web.UI.Page
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
                cmd = new SqlCommand("SELECT   miscellaneous_billdetails.sno AS refno, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate,  financialyeardetails.year as financeyear, miscellaneous_billdetails.natureofwork, natureofwork.shortdescription, employe_login.name, miscellaneous_billdetails.status, Departmentdetails.DepartmentName,  miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount FROM  miscellaneous_billdetails INNER JOIN Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno LEFT OUTER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno LEFT OUTER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno LEFT OUTER JOIN  employe_login ON miscellaneous_billdetails.employeid = employe_login.sno WHERE  (miscellaneous_billdetails.doe BETWEEN @d1 AND @d2)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@BranchID", BranchID);
            }
            else
            {
                cmd = new SqlCommand("SELECT   miscellaneous_billdetails.sno AS refno, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate,  financialyeardetails.year as financeyear , miscellaneous_billdetails.natureofwork, natureofwork.shortdescription, employe_login.name, miscellaneous_billdetails.status, Departmentdetails.DepartmentName,  miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount FROM  miscellaneous_billdetails INNER JOIN Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno LEFT OUTER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno LEFT OUTER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno LEFT OUTER JOIN  employe_login ON miscellaneous_billdetails.employeid = employe_login.sno WHERE  (miscellaneous_billdetails.doe BETWEEN @d1 AND @d2)");
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
                cmd = new SqlCommand("SELECT  miscellaneous_billdetails.sno AS refrenceno, miscellaneous_billdetails.status, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear, miscellaneous_billdetails.natureofwork, miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate, miscellaneous_billdetails.deptid, miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_bill_subdetails.sno AS sno1, miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode, miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno, miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom, miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks, financialyeardetails.year, natureofwork.shortdescription, employe_login.name AS employname, Departmentdetails.DepartmentName, Departmentdetails.DepartmentCode, miscellaneous_billdetails.doe, budgetmaster.budgetcode AS budgectname, costcenter_master.costcentercode AS costcentername FROM  miscellaneous_billdetails INNER JOIN miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno INNER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno INNER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno INNER JOIN  employe_login ON miscellaneous_billdetails.employeid = employe_login.sno INNER JOIN Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno INNER JOIN costcenter_master ON miscellaneous_bill_subdetails.costcentercode = costcenter_master.sno INNER JOIN budgetmaster ON miscellaneous_bill_subdetails.budgetcode = budgetmaster.sno WHERE  (miscellaneous_billdetails.sno = @refrenceno)");
                cmd.Parameters.Add("@refrenceno", txtrefno.Text);
                cmd.Parameters.Add("@BranchID", BranchID);
            }
            else
            {
                //SELECT  miscellaneous_billdetails.sno AS refrenceno, miscellaneous_billdetails.status, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear,   miscellaneous_billdetails.natureofwork, miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate,  miscellaneous_billdetails.deptid, miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_bill_subdetails.sno AS sno1,  miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode,  miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno,   miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom,  miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks,  financialyeardetails.year, natureofwork.shortdescription, employe_login.name AS employname, Departmentdetails.DepartmentName,   Departmentdetails.DepartmentCode, costcenter_master.costcentercode AS costcenterid, budgetmaster.budgetcode AS budgectid, miscellaneous_billdetails.doe FROM miscellaneous_billdetails INNER JOIN miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno LEFT OUTER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno LEFT OUTER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno LEFT OUTER JOIN employe_login ON miscellaneous_billdetails.employeid = employe_login.sno LEFT OUTER JOIN Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno LEFT OUTER JOIN costcenter_master ON miscellaneous_bill_subdetails.costcentercode = costcenter_master.sno LEFT OUTER JOIN  budgetmaster ON miscellaneous_bill_subdetails.budgetcode = budgetmaster.sno WHERE   (miscellaneous_billdetails.sno = @refrenceno)
                //cmd = new SqlCommand("SELECT  miscellaneous_billdetails.sno AS refrenceno, miscellaneous_billdetails.status, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear, miscellaneous_billdetails.natureofwork, miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate, miscellaneous_billdetails.deptid, miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_bill_subdetails.sno AS sno1, miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode, miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno, miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom, miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks, financialyeardetails.year, natureofwork.shortdescription, employe_login.name AS employname, Departmentdetails.DepartmentName, Departmentdetails.DepartmentCode, miscellaneous_billdetails.doe FROM    miscellaneous_billdetails INNER JOIN miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno INNER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno INNER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno INNER JOIN employe_login ON miscellaneous_billdetails.employeid = employe_login.sno INNER JOIN Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno WHERE (miscellaneous_billdetails.sno = @refrenceno)");
                //cmd = new SqlCommand("SELECT   miscellaneous_billdetails.sno, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear, miscellaneous_billdetails.natureofwork, miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate, miscellaneous_billdetails.deptid, miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_billdetails.createdby, miscellaneous_billdetails.doe, miscellaneous_billdetails.modifiedby, miscellaneous_billdetails.modifieddate, miscellaneous_billdetails.status FROM  miscellaneous_billdetails INNER JOIN miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno WHERE (miscellaneous_billdetails.sno = @r)");
                cmd = new SqlCommand("SELECT  miscellaneous_billdetails.sno AS refrenceno, miscellaneous_billdetails.status, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear, miscellaneous_billdetails.natureofwork, miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate, miscellaneous_billdetails.deptid, miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_bill_subdetails.sno AS sno1, miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode, miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno, miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom, miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks, financialyeardetails.year, natureofwork.shortdescription, employe_login.name AS employname, Departmentdetails.DepartmentName, Departmentdetails.DepartmentCode, miscellaneous_billdetails.doe, budgetmaster.budgetcode AS budgectname, costcenter_master.costcentercode AS costcentername FROM  miscellaneous_billdetails INNER JOIN miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno INNER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno INNER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno INNER JOIN  employe_login ON miscellaneous_billdetails.employeid = employe_login.sno INNER JOIN Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno INNER JOIN costcenter_master ON miscellaneous_bill_subdetails.costcentercode = costcenter_master.sno INNER JOIN budgetmaster ON miscellaneous_bill_subdetails.budgetcode = budgetmaster.sno WHERE  (miscellaneous_billdetails.sno = @refrenceno)");
                cmd.Parameters.Add("@refrenceno", txtrefno.Text);
            }
            DataTable dtable = vdm.SelectQuery(cmd).Tables[0];
            if (dtable.Rows.Count > 0)
            {
                DataView view1 = new DataView(dtable);
                DataTable dtlblValues = view1.ToTable(true, "refrenceno", "transactiondate", "year", "natureofwork", "shortdescription", "employname", "advancereqno", "advreqdate", "DepartmentName", "DepartmentCode", "particulars", "totalamount", "status");
                DataTable dtgrdValues = view1.ToTable(true, "costcentername", "budgectname", "grnno", "vendorcode", "name", "billno", "billdate", "item", "description", "uom", "quantity", "rate", "amount", "remarks");
                if (dtlblValues.Rows.Count > 0)
                {
                    txttranactiondate.Text = dtlblValues.Rows[0]["transactiondate"].ToString();
                    txtfinacialyear.Text = dtlblValues.Rows[0]["year"].ToString();
                    txtnatureofwork.Text = dtlblValues.Rows[0]["natureofwork"].ToString();
                    txtnaturedescription.Text = dtlblValues.Rows[0]["shortdescription"].ToString();
                    txtempname.Text = dtlblValues.Rows[0]["employname"].ToString();
                    txtadvreqno.Text = dtlblValues.Rows[0]["advancereqno"].ToString();
                    txtadvreqdate.Text = dtlblValues.Rows[0]["advreqdate"].ToString();
                    txtdepartmentname.Text = dtlblValues.Rows[0]["DepartmentCode"].ToString();
                    txtdepartmentcode.Text = dtlblValues.Rows[0]["DepartmentName"].ToString();
                    txtparticulers.Text = dtlblValues.Rows[0]["particulars"].ToString();
                    txttotalammount.Text = dtlblValues.Rows[0]["totalamount"].ToString();
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