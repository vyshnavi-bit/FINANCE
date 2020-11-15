using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Common;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Drawing;
using ClosedXML.Excel;

public partial class import : System.Web.UI.Page
{
    VehicleDBMgr vdm;
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Visible = false;
    }
    protected void btnImport_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string connString = "";
            string filePath = Server.MapPath("~/Files/") + Path.GetFileName(fileuploadExcel.PostedFile.FileName);
            fileuploadExcel.SaveAs(filePath);
            if (filePath.Trim() == ".xls")
            {
                connString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
            }
            else if (filePath.Trim() == ".xlsx")
            {
                connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
            }

            OleDbConnection OleDbcon = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=Excel 12.0;");

            OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Sheet1$]", OleDbcon);
            OleDbDataAdapter da = new OleDbDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            Session["btnImport"] = dt;
            grdReports.DataSource = dt;
            grdReports.DataBind();
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
            lblMessage.Visible = true;
        }
    }
    SqlCommand sqlcmd;
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dt = (DataTable)Session["btnImport"];

            vdm = new VehicleDBMgr();
            DateTime CreateDate = VehicleDBMgr.GetTime(vdm.conn);
            DateTime fromdate = DateTime.Now;
            int i = 1;
            foreach (DataRow dr in dt.Rows)
            {
                string Ledgername = dr["Account Name"].ToString();
                string Ledgercode = dr["Account Number"].ToString();
                if (Ledgername == "" || Ledgercode == "")
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("update headofaccounts_master set accountcode=@accountcode where accountname=@accountname");
                    sqlcmd.Parameters.Add("@accountcode", Ledgercode);
                    sqlcmd.Parameters.Add("@accountname", Ledgername);
                    vdm.Update(sqlcmd);
                    i++;
                }
            }
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
            lblMessage.Text = "Successfully Saved";
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
        }
    }
}

