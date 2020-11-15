using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.IO;
using System.Data.OleDb;


public partial class importhead : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    VehicleDBMgr vdm;
    ProcureDBmanager pdm;

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
               
            }
        }

    }
  

    protected void btn_import_click(object sender, EventArgs e)
    {
        try
        {
            string FilePath = ConfigurationManager.AppSettings["FilePath"].ToString();
            string filename = string.Empty;
            //To check whether file is selected or not to uplaod
            if (FileUploadToServer.HasFile)
            {
                try
                {
                    string[] allowdFile = { ".xls", ".xlsx" };
                    //Here we are allowing only excel file so verifying selected file pdf or not
                    string FileExt = System.IO.Path.GetExtension(FileUploadToServer.PostedFile.FileName);
                    //Check whether selected file is valid extension or not
                    bool isValidFile = allowdFile.Contains(FileExt);
                    if (!isValidFile)
                    {
                        lblmsg.ForeColor = System.Drawing.Color.Red;
                        lblmsg.Text = "Please upload only Excel";
                    }
                    else
                    {
                        // Get size of uploaded file, here restricting size of file
                        int FileSize = FileUploadToServer.PostedFile.ContentLength;
                        if (FileSize <= 1048576)//1048576 byte = 1MB
                        {
                            //Get file name of selected file
                            filename = Path.GetFileName(Server.MapPath(FileUploadToServer.FileName));

                            //Save selected file into server location
                            FileUploadToServer.SaveAs(Server.MapPath(FilePath) + filename);
                            //Get file path
                            string filePath = Server.MapPath(FilePath) + filename;
                            //Open the connection with excel file based on excel version
                            OleDbConnection con = null;
                            if (FileExt == ".xls")
                            {
                                con = new OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=Excel 8.0;");

                            }
                            else if (FileExt == ".xlsx")
                            {
                                con = new OleDbConnection(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=Excel 12.0;");
                            }

                            con.Close(); con.Open();
                            //Get the list of sheet available in excel sheet
                            DataTable dt = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                            //Get first sheet name
                            string getExcelSheetName = dt.Rows[0]["Table_Name"].ToString();
                            //Select rows from first sheet in excel sheet and fill into dataset "SELECT * FROM [Sheet1$]";  
                            OleDbCommand ExcelCommand = new OleDbCommand(@"SELECT * FROM [" + getExcelSheetName + @"]", con);
                            OleDbDataAdapter ExcelAdapter = new OleDbDataAdapter(ExcelCommand);
                            DataSet ExcelDataSet = new DataSet();
                            ExcelAdapter.Fill(ExcelDataSet);
                            //Bind the dataset into gridview to display excel contents
                            grdReports.DataSource = ExcelDataSet;
                            grdReports.DataBind();
                            Session["dtImport"] = ExcelDataSet.Tables[0];
                        }
                        else
                        {
                            lblmsg.Text = "Attachment file size should not be greater then 1 MB!";
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblmsg.Text = "Error occurred while uploading a file: " + ex.Message;
                }
            }
            else
            {
                lblmsg.Text = "Please select a file to upload.";
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.ToString();
            lblmsg.Visible = true;
        }
    }

    SqlCommand sqlcmd;
    protected void save_head_click(object sender, EventArgs e)
    {
        vdm = new VehicleDBMgr();
        DateTime CreateDate = VehicleDBMgr.GetTime(vdm.conn);
        DateTime fromdate = DateTime.Now;
        DataTable dtmainaccount = (DataTable)Session["dtImport"];
        foreach (DataRow dr in dtmainaccount.Rows)
        {
            string Ledgername = dr["ledgername"].ToString();
            string Ledgercode = dr["accountcode"].ToString();
            if (Ledgername == "" || Ledgercode == "")
            {
            }
            else
            {
                sqlcmd = new SqlCommand("SELECT sno FROM  headofaccounts_master WHERE (accountname = @accountname)");
                sqlcmd.Parameters.Add("@accountcode", Ledgercode);
                sqlcmd.Parameters.Add("@accountname", Ledgername);
                DataTable dtledgers = vdm.SelectQuery(sqlcmd).Tables[0];
                if (dtledgers.Rows.Count > 0)
                {
                    string sno = dtledgers.Rows[0]["sno"].ToString();
                    sqlcmd = new SqlCommand("update headofaccounts_master set accountname=@accountname,accountcode=@accountcode where sno=@sno");
                    sqlcmd.Parameters.Add("@accountcode", Ledgercode);
                    sqlcmd.Parameters.Add("@accountname", Ledgername);
                    sqlcmd.Parameters.Add("@doe", fromdate);
                    sqlcmd.Parameters.Add("@sno", sno);
                    vdm.Update(sqlcmd);
                }
                else
                {
                    sqlcmd = new SqlCommand("Insert into headofaccounts_master (accountname, accountcode,doe) values (@accountname, @accountcode,@doe)");
                    sqlcmd.Parameters.Add("@accountcode", Ledgercode);
                    sqlcmd.Parameters.Add("@accountname", Ledgername);
                    sqlcmd.Parameters.Add("@doe", fromdate);
                    vdm.insert(sqlcmd);
                }
            }
        }
        DataTable dtempty = new DataTable();
        grdReports.DataSource = dtempty;
        grdReports.DataBind();
        lblmsg.Text = "Successfully Saved";
    }
}