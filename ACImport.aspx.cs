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

public partial class ACImport : System.Web.UI.Page
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
            grvExcelData.DataSource = dt;
            grvExcelData.DataBind();
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
            lblMessage.Visible = true;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dt = (DataTable)Session["btnImport"];
            foreach (DataRow dr in dt.Rows)
            {
                vdm = new VehicleDBMgr();
                string groupcode = dr["groupcode"].ToString();
                string accountcode = dr["accountcode"].ToString();
                string description = dr["description"].ToString();
                cmd = new SqlCommand("SELECT sno FROM fixed_assets_groups WHERE (groupname=@groupname)");
                cmd.Parameters.Add("@groupname", groupcode);
                DataTable dtaccounts = vdm.SelectQuery(cmd).Tables[0];
                if (dtaccounts.Rows.Count > 0)
                {
                    cmd = new SqlCommand("insert into accountmaster(groupcode,accountcode,description,createdby,doe) values(@groupcode,@accountcode,@description,@createdby,@doe)");
                    cmd.Parameters.Add("@groupcode", dtaccounts.Rows[0]["sno"].ToString());
                    cmd.Parameters.Add("@accountcode", accountcode);
                    cmd.Parameters.Add("@doe", DateTime.Now);
                    cmd.Parameters.Add("@description", description);
                    cmd.Parameters.Add("@createdby", Session["UserSno"].ToString());
                    vdm.insert(cmd);
                }
            }

        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.ToString();
        }
         lblmsg.Text = "Records inserted successfully";
    }
}