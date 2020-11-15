using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Imprest_Suspense_RequisitionStatus : System.Web.UI.Page
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
                FillDeptName();
            }
        }
    }
    void FillDeptName()
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,DepartmentName,DepartmentCode,createdby FROM Departmentdetails");
            DataTable dtDept = vdm.SelectQuery(cmd).Tables[0];
            ddldeptcode.DataSource = dtDept;
            ddldeptcode.DataTextField = "DepartmentCode";
            ddldeptcode.DataValueField = "sno";
            ddldeptcode.DataBind();
        }
        catch
        {
        }
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
            lblmsg.Text = "";
            string dept = ddldeptcode.SelectedValue;
            cmd = new SqlCommand("SELECT suspensecashrequisition.sno, Departmentdetails.DepartmentName AS deptname,suspensecashrequisition.reqno, suspensecashrequisition.employeecode,suspensecashrequisition.reqdate, suspensecashrequisition.availableamount,suspensecashrequisition.reqamount, suspensecashrequisition.particulars, Departmentdetails.DepartmentCode, employe_login.name, suspense_bill_entry.status FROM suspensecashrequisition INNER JOIN Departmentdetails ON suspensecashrequisition.departmentcode = Departmentdetails.sno INNER JOIN employe_login ON suspensecashrequisition.employeecode = employe_login.sno INNER JOIN suspense_bill_entry ON suspensecashrequisition.sno = suspense_bill_entry.suspensereqno where (suspensecashrequisition.departmentcode=@deptid)");
            cmd.Parameters.Add("@deptid", ddldeptcode.SelectedValue);
            DataTable dtCheque = vdm.SelectQuery(cmd).Tables[0];
            Report = new DataTable();
            Report.Columns.Add("ReqNo");
            Report.Columns.Add("Date");
            Report.Columns.Add("EmployeeCode");
            Report.Columns.Add("Name");
            Report.Columns.Add("Amount").DataType = typeof(Double);
            Report.Columns.Add("AvailableAmount");
            Report.Columns.Add("Status");
            Report.Columns.Add("Particulars");
            if (dtCheque.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtCheque.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["ReqNo"] = dr["reqno"].ToString();
                    newrow["Date"] = dr["reqdate"].ToString();
                    newrow["EmployeeCode"] = dr["employeecode"].ToString();
                    newrow["Name"] = dr["name"].ToString();
                    newrow["Amount"] = dr["reqamount"].ToString();
                    newrow["AvailableAmount"] = dr["availableamount"].ToString();
                    newrow["Particulars"] = dr["particulars"].ToString();
                    string ColStatus = dr["status"].ToString();
                    string suspenseStatus = "";
                    if (ColStatus == "R")
                    {
                        suspenseStatus = "Raised";
                    }
                    if (ColStatus == "A")
                    {
                        suspenseStatus = "Approved";
                    }
                    if (ColStatus == "C")
                    {
                        suspenseStatus = "Rejected";
                    }
                    if (ColStatus == "P")
                    {
                        suspenseStatus = "Pending";
                    }
                    newrow["Status"] = suspenseStatus;
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