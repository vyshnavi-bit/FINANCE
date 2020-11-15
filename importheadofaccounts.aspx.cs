using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class importheadofaccounts : System.Web.UI.Page
{

    SqlCommand cmd;
    string BranchID = "";
    VehicleDBMgr vdm;
    private object ddlType;
    private object lblmsg;
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
                Fillplantdetails();
                // Fillagentdetails();

            }
        }
    }
    void Fillplantdetails()
    {
        pdm = new ProcureDBmanager();
        cmd = new SqlCommand("SELECT Plant_Code, Plant_Name FROM Plant_Master where plant_code not in (150,139,160)");
        DataTable dtPlant = pdm.SelectQuery(cmd).Tables[0];
        ddlplantname.DataSource = dtPlant;
        ddlplantname.DataTextField = "Plant_Name";
        ddlplantname.DataValueField = "Plant_Code";
        ddlplantname.DataBind();
    }

    //protected void ddlplantname_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    pdm = new ProcureDBmanager();
    //    cmd = new SqlCommand("SELECT  Tid,Agent_Id,Agent_Name from Agent_Master where Plant_code=@plantcode");
    //    cmd.Parameters.Add("@plantcode", ddlplantname.SelectedValue);
    //    DataTable dtPlant = pdm.SelectQuery(cmd).Tables[0];
    //    ddlagentname.DataSource = dtPlant;
    //    ddlagentname.DataTextField = "Agent_Name";
    //    ddlagentname.DataValueField = "Agent_Id";
    //    ddlagentname.DataBind();
    //}
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        GetReport();
    }
    DataTable dtReport = new DataTable();
    void GetReport()
    {
        try
        {
            lbl_msg.Text = "";
            pnlHide.Visible = true;
            pdm = new ProcureDBmanager();
            DateTime fromdate = DateTime.Now;
            Session["xporttype"] = "TallyPayments";
            //
            cmd = new SqlCommand("Select Agent_id,Legdername,Amount,VendorCode from(Select agent_id,Legdername,Amount, plant_code, Frm_Date, To_date from TallyloanEntryJvpassAgentWsie  where plant_code=@plantcode  and Amount > 0  and Frm_Date='03-16-2017'   and To_date='03-31-2017') as tally  left join (Select  Agent_Id as amAgentId,Plant_code as Plantcode,VendorCode   from  Agent_Master   where Plant_code=@plantcode  group by Agent_Id,Plant_code,VendorCode) as am on tally.plant_code=am.Plantcode and tally.Agent_id=am.amAgentId");
            cmd.Parameters.Add("@plantcode", ddlplantname.SelectedValue);
            DataTable dtprocledgers = pdm.SelectQuery(cmd).Tables[0];
            dtReport.Columns.Add("Ledger Code");
            dtReport.Columns.Add("Ledger Name");
            int i = 1;
            foreach (DataRow branch in dtprocledgers.Rows)
            {
                DataRow newrow = dtReport.NewRow();
                newrow["Ledger Code"] = branch["VendorCode"].ToString();
                newrow["Ledger Name"] = branch["Legdername"].ToString();
                dtReport.Rows.Add(newrow);
            }
            grdReports.DataSource = dtReport;
            grdReports.DataBind();
            Session["xportdata"] = dtReport;
        }
        catch (Exception ex)
        {
            pnlHide.Visible = false;
            lbl_msg.Text = ex.Message;
        }
    }
    SqlCommand sqlcmd;
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime CreateDate = VehicleDBMgr.GetTime(vdm.conn);
            DateTime fromdate = DateTime.Now;
            DataTable dt = (DataTable)Session["xportdata"];
            int i = 1;
            foreach (DataRow dr in dt.Rows)
            {
                string Ledgername = dr["Ledger Name"].ToString();
                string Ledgercode = dr["Ledger Code"].ToString();
                if (Ledgername == "" || Ledgercode == "")
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("SELECT sno FROM  headofaccounts_master WHERE ((accountname = @accountname) OR  (accountcode = @accountcode))");
                    sqlcmd.Parameters.Add("@accountcode", dr["Ledger Code"].ToString());
                    sqlcmd.Parameters.Add("@accountname", dr["Ledger Name"].ToString());
                    DataTable dtledgers = vdm.SelectQuery(sqlcmd).Tables[0];
                    if (dtledgers.Rows.Count > 0)
                    {
                        string sno = dtledgers.Rows[0]["sno"].ToString();
                        sqlcmd = new SqlCommand("update headofaccounts_master set accountname=@accountname,accountcode=@accountcode where sno=@sno");
                        sqlcmd.Parameters.Add("@accountcode", dr["Ledger Code"].ToString());
                        sqlcmd.Parameters.Add("@accountname", dr["Ledger Name"].ToString());
                        sqlcmd.Parameters.Add("@doe", fromdate);
                        sqlcmd.Parameters.Add("@sno", sno);
                        vdm.Update(sqlcmd);
                    }
                    else
                    {
                        sqlcmd = new SqlCommand("Insert into headofaccounts_master (accountname, accountcode,doe) values (@accountname, @accountcode,@doe)");
                        sqlcmd.Parameters.Add("@accountcode", dr["Ledger Code"].ToString());
                        sqlcmd.Parameters.Add("@accountname", dr["Ledger Name"].ToString());
                        sqlcmd.Parameters.Add("@doe", fromdate);
                        vdm.insert(sqlcmd);
                    }
                }
            }
            pnlHide.Visible = false;
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
            lbl_msg.Text = "Successfully Saved";
        }
        catch (Exception ex)
        {
            lbl_msg.Text = ex.ToString();
        }
    }

}