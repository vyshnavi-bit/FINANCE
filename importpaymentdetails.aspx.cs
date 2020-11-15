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

public partial class importpaymentdetails : System.Web.UI.Page
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
                fillbankaccountdetails();
                Fillbranchdetails();
                fillempdetails();
            }
        }
      
    }
    void Fillbranchdetails()
    {
        vdm = new VehicleDBMgr();
        cmd = new SqlCommand("SELECT branchid, branchname, address, phone, emailid, statename, branchtype, company_code FROM branchmaster");
        DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
        ddl_branch.DataSource = dtPlant;
        ddl_branch.DataTextField = "branchname";
        ddl_branch.DataValueField = "branchid";
        ddl_branch.DataBind();

        ddl_subbranch.DataSource = dtPlant;
        ddl_subbranch.DataTextField = "branchname";
        ddl_subbranch.DataValueField = "branchid";
        ddl_subbranch.DataBind();
    }
     void fillbankaccountdetails()
     {
         try
         {
             vdm = new VehicleDBMgr();
             cmd = new SqlCommand("SELECT bankaccountno_master.branchname, bankmaster.bankname, bankaccountno_master.ifscid, bankaccountno_master.bankid, bankaccountno_master.sno, bankaccountno_master.accountno, bankaccountno_master.accounttype, ifscmaster.ifsccode FROM  bankaccountno_master INNER JOIN  bankmaster ON bankaccountno_master.bankid = bankmaster.sno INNER JOIN  ifscmaster ON bankaccountno_master.ifscid = ifscmaster.sno");
             DataTable routes = vdm.SelectQuery(cmd).Tables[0];
             ddl_account.DataSource = routes;
             ddl_account.DataTextField = "accountno";
             ddl_account.DataValueField = "sno";
             ddl_account.DataBind();
         }
         catch (Exception ex)
         {
             
         }
     }
     void fillempdetails()
     {
         vdm = new VehicleDBMgr();
         cmd = new SqlCommand("SELECT el.sno,el.name,el.deptid,el.branchid,el.leveltype,el.username,el.passward,el.doe,el.createdby, branchmaster.branchname,dept.DepartmentName FROM  employe_login el INNER JOIN Departmentdetails dept ON el.deptid = dept.sno INNER JOIN branchmaster ON el.branchid = branchmaster.branchid");
         DataTable dtemp = vdm.SelectQuery(cmd).Tables[0];
         ddl_emp.DataSource = dtemp;
         ddl_emp.DataTextField = "username";
         ddl_emp.DataValueField = "sno";
         ddl_emp.DataBind();
     }

     protected void btn_import_click(object sender, EventArgs e)
     {
         try
         {
             pnlHide.Visible = false;
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

     protected void btnsubimport_click(object sender, EventArgs e)
     {
         try
         {
             string FilePath = ConfigurationManager.AppSettings["FilePath"].ToString();
             string filename = string.Empty;
             //To check whether file is selected or not to uplaod

             if (FileUploadTosubaccounts.HasFile)
             {
                 try
                 {
                     string[] allowdFile = { ".xls", ".xlsx" };
                     //Here we are allowing only excel file so verifying selected file pdf or not
                     string FileExt = System.IO.Path.GetExtension(FileUploadTosubaccounts.PostedFile.FileName);
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
                         int FileSize = FileUploadTosubaccounts.PostedFile.ContentLength;
                         if (FileSize <= 1048576)//1048576 byte = 1MB
                         {
                             //Get file name of selected file
                             filename = Path.GetFileName(Server.MapPath(FileUploadTosubaccounts.FileName));

                             //Save selected file into server location
                             FileUploadTosubaccounts.SaveAs(Server.MapPath(FilePath) + filename);
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
                             grdsubReports.DataSource = ExcelDataSet;
                             grdsubReports.DataBind();
                             Session["dtsubaccountsImport"] = ExcelDataSet.Tables[0];
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
     DataTable dtmissing = new DataTable();
     protected void save_payment_click(object sender, EventArgs e)
     {
         
         vdm = new VehicleDBMgr();
         dtmissing.Columns.Add("Ledgername");
         DateTime CreateDate = VehicleDBMgr.GetTime(vdm.conn);
         DateTime fromdate = DateTime.Now;
         DataTable dtmainaccount = (DataTable)Session["dtImport"];
         DataTable dtsubaccount = (DataTable)Session["dtsubaccountsImport"];
         string UserName = Session["UserSno"].ToString();
         string branchname = ddl_branch.SelectedItem.Value;
         string doe = txtdate.Text;
         DateTime paymentdate = Convert.ToDateTime(doe);
         string payto = txtname.Text;
         string acno = ddl_account.SelectedItem.Value;
         string subbranch = ddl_subbranch.SelectedItem.Value;
         string sapimport = ddl_sapimport.SelectedItem.Value;
         string remarks = txtremarks.Value;
         string approvedby = ddl_emp.SelectedItem.Value;
         double totalamount = 0;
         double totalsubamount = 0;
         cmd = new SqlCommand("insert into paymentdetails (name,accountno,remarks,approvedby,doe,createdby,status,paymentdate,branch,sub_branch,sapimport) values (@name,@accountno,@remarks,@approvedby,@doe,@createdby,'P',@paymentdate,@branch,@sub_branch,@sapimport)");
         cmd.Parameters.Add("@name", payto);
         cmd.Parameters.Add("@accountno", acno);
         //cmd.Parameters.Add("@totalamount", totalamount);
         cmd.Parameters.Add("@remarks", remarks);
         cmd.Parameters.Add("@approvedby", approvedby);
         cmd.Parameters.Add("@doe", CreateDate);
         cmd.Parameters.Add("@createdby", UserName);
         cmd.Parameters.Add("@paymentdate", doe);
         cmd.Parameters.Add("@branch", branchname);
         cmd.Parameters.Add("@sub_branch", subbranch);
         cmd.Parameters.Add("@sapimport", sapimport);
         vdm.insert(cmd);
         cmd = new SqlCommand("select MAX(sno) AS sno from paymentdetails ");
         DataTable routes = vdm.SelectQuery(cmd).Tables[0];
         string paymentrefno = routes.Rows[0]["sno"].ToString();
         //string paymentrefno = "7277";
         if (dtmainaccount != null && dtmainaccount.Rows.Count > 0)
         {
             try
             {
                 foreach (DataRow drmain in dtmainaccount.Rows)
                 {
                     double mainamount = 0;
                     string headofaccount = drmain["ledgername"].ToString();
                     cmd = new SqlCommand("SELECT sno FROM headofaccounts_master WHERE accountname=@acname");
                     cmd.Parameters.Add("@acname", headofaccount);
                     DataTable dtheadofaccount = vdm.SelectQuery(cmd).Tables[0];
                     if (dtheadofaccount.Rows.Count > 0)
                     {
                         string accountid = dtheadofaccount.Rows[0]["sno"].ToString();
                         string amount = drmain["amount"].ToString();
                         mainamount = Convert.ToDouble(amount);
                         totalamount += mainamount;
                         cmd = new SqlCommand("insert into paymentsubdetails (paymentrefno, headofaccount, amount) values (@paymentrefno, @headofaccount, @amount)");
                         cmd.Parameters.Add("@paymentrefno", paymentrefno);
                         cmd.Parameters.Add("@headofaccount", accountid);
                         cmd.Parameters.Add("@amount", amount);
                         vdm.insert(cmd);
                     }
                     else
                     {
                         DataRow newrow = dtmissing.NewRow();
                         newrow["Ledgername"] = headofaccount;
                         dtmissing.Rows.Add(newrow);
                     }
                 }
                 cmd = new SqlCommand("UPDATE paymentdetails SET totalamount=@totalamount WHERE sno=@refno");
                 cmd.Parameters.Add("@totalamount", totalamount);
                 cmd.Parameters.Add("@refno", paymentrefno);
                 vdm.Update(cmd);
             }
             catch (Exception ex)
             {

             }
         }
         if (dtsubaccount != null && dtsubaccount.Rows.Count > 0)
         {
             try
             {
                 foreach (DataRow dr in dtsubaccount.Rows)
                 {
                     double subamount = 0;
                     string subheadofaccount = dr["ledgername"].ToString();
                     cmd = new SqlCommand("SELECT sno FROM headofaccounts_master WHERE accountname=@acname");
                     cmd.Parameters.Add("@acname", subheadofaccount);
                     DataTable dtsubheadofaccount = vdm.SelectQuery(cmd).Tables[0];
                     if (dtsubheadofaccount.Rows.Count > 0)
                     {
                         string subaccountid = dtsubheadofaccount.Rows[0]["sno"].ToString();
                         string amount = dr["amount"].ToString();
                         subamount = Convert.ToDouble(amount);
                         totalsubamount += subamount;
                         cmd = new SqlCommand("insert into subaccount_payment (paymentrefno, headofaccount, amount, branchid) values (@paymentrefno, @headofaccount, @amount,@branchid)");
                         cmd.Parameters.Add("@paymentrefno", paymentrefno);
                         cmd.Parameters.Add("@headofaccount", subaccountid);
                         cmd.Parameters.Add("@amount", amount);
                         cmd.Parameters.Add("@branchid", subbranch);
                         vdm.insert(cmd);
                     }
                     else
                     {
                         DataRow newrow = dtmissing.NewRow();
                         newrow["Ledgername"] = subheadofaccount;
                         dtmissing.Rows.Add(newrow);
                     }
                 }
                 cmd = new SqlCommand("UPDATE paymentdetails SET total_subamount=@total_subamount WHERE sno=@prefno");
                 cmd.Parameters.Add("@total_subamount", totalsubamount);
                 cmd.Parameters.Add("@prefno", paymentrefno);
                 vdm.Update(cmd);
             }
             catch (Exception ex)
             {

             }
         }
         DataTable dtempty = new DataTable();
         grdReports.DataSource = dtempty;
         grdReports.DataBind();
         grdsubReports.DataSource = dtempty;
         grdsubReports.DataBind();
         pnlHide.Visible = true;
         grdmissing.DataSource = dtmissing;
         grdmissing.DataBind();
         lblmsg.Text = "Successfully Saved";
         ddl_branch.SelectedItem.Value = "1";
         txtdate.Text = string.Empty;
         txtname.Text = string.Empty;
         ddl_account.SelectedItem.Value = "0";
         ddl_subbranch.SelectedItem.Value = "1";
         ddl_sapimport.SelectedItem.Value = "1";
         txtremarks.Value = string.Empty;
         ddl_emp.SelectedItem.Value = "0";
     }
}