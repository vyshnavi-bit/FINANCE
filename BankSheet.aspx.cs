using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class banksheetdetails : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    VehicleDBMgr vdm;
    private object ddlType;
    private object lblmsg;

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
                txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                lblTitle.Text = Session["TitleName"].ToString();
                Fillbankdetails();
            }
        }
    }
    void Fillbankdetails()
    {
        vdm = new VehicleDBMgr();
        cmd = new SqlCommand("SELECT sno, accountno FROM bankaccountno_master");
        DataTable dtPlant = vdm.SelectQuery(cmd).Tables[0];
        ddlaccountno.DataSource = dtPlant;
        ddlaccountno.DataTextField = "accountno";
        ddlaccountno.DataValueField = "sno";
        ddlaccountno.DataBind();
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
    void GetReport()
    {
        try
        {
            pnlfoter.Visible = true;
            pnlHide.Visible = true;
            lblbank.Text = "";
            lblbankmsg.Text = "";
            lblOppBal.Text = "";
            lblpreparedby.Text = "";
            lblclosingbal.Text = "";
            lblhidden.Text = "";
            vdm = new VehicleDBMgr();
            DataTable colection = new DataTable();
            DataTable payment = new DataTable();
            DataTable Report = new DataTable();
           
            DateTime todate = DateTime.Now;
            Report.Columns.Add("Receipts");
            Report.Columns.Add("Amount");
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
            Session["filename"] = "Bank Sheet ->" + ddlaccountno.SelectedItem.Text;
            lblbank.Text = ddlaccountno.SelectedItem.Text;
            lbl_fromDate.Text = txtFromdate.Text;
            string BranchID = ddlaccountno.SelectedValue;
            cmd = new SqlCommand("SELECT accounttype FROM bankaccountno_master WHERE (sno = @accountno)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            DataTable dtAccountType = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT accountid, amount FROM accountnowiseclosingdetails WHERE (accountid = @accountid) AND (doe BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@accountid", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate).AddDays(-1));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate).AddDays(-1));
            DataTable dtOpp = vdm.SelectQuery(cmd).Tables[0];
            if (dtOpp.Rows.Count > 0)
            {
                lblOppBal.Text = dtOpp.Rows[0]["Amount"].ToString();
            }
            cmd = new SqlCommand("select c.name, bam.accountno, ham.accountname,csd.amount from collections c inner join collectionsubdetails csd on csd.collectionrefno = c.sno inner join bankaccountno_master bam on bam.sno=c.accountno inner join headofaccounts_master ham on ham.sno=csd.headofaccount WHERE (c.accountno=@accno) AND (c.receiptdate BETWEEN @fromdate AND @todate)");
            cmd.Parameters.Add("@accno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(fromdate));
            DataTable dtcollection = vdm.SelectQuery(cmd).Tables[0];
            double AccouTotalamount = 0;
            double ctotalamount = 0;
            double ptotalamount = 0;
            double amount = 0;
            foreach (DataRow dr in dtcollection.Rows)
            {
                DataRow newrow = Report.NewRow();
                string Amount = dr["amount"].ToString();
                amount = Convert.ToDouble(Amount);
                newrow["Receipts"] = dr["name"].ToString();
                newrow["Amount"] = dr["amount"].ToString();
                ctotalamount += amount;
                Report.Rows.Add(newrow);
            }
            //
            //DataTable dtpostcheque = vdm.SelectQuery(cmd).Tables[0];
            //foreach (DataRow dr in dtpostcheque.Rows)
            //{
            //    DataRow newrow = Report.NewRow();
            //    string Amount = dr["amount"].ToString();
            //    amount = Convert.ToDouble(Amount);
            //    newrow["Receipts"] = dr["name"].ToString();
            //    newrow["Amount"] = dr["amount"].ToString();
            //    ctotalamount += amount;
            //    Report.Rows.Add(newrow);
            //}

            //
            DataRow report = Report.NewRow();
            report["Receipts"] = "totalamount";
            report["Amount"] = ctotalamount;
            Report.Rows.Add(report);
            grdcollections.DataSource = Report;
            grdcollections.DataBind();
            DataTable dtpayment = new DataTable();
            dtpayment.Columns.Add("Payments");
            dtpayment.Columns.Add("Amount");
            cmd = new SqlCommand("select p.name, bam.accountno, ham.accountname,psd.amount from paymentdetails p inner join paymentsubdetails psd on psd.paymentrefno = p.sno inner join bankaccountno_master bam on bam.sno=p.accountno inner join headofaccounts_master ham on ham.sno=psd.headofaccount WHERE (p.accountno=@accno) AND (p.paymentdate BETWEEN @fromdate AND @todate)");
            cmd.Parameters.Add("@accno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(fromdate));
            DataTable dtpayments = vdm.SelectQuery(cmd).Tables[0];
            foreach (DataRow dr in dtpayments.Rows)
            {
                DataRow dtnewrow1 = dtpayment.NewRow();
                string Amount = dr["amount"].ToString();
                double amt = Convert.ToDouble(Amount);
                dtnewrow1["Payments"] = dr["name"].ToString();
                dtnewrow1["Amount"] = dr["amount"].ToString();
                ptotalamount += amt;
                dtpayment.Rows.Add(dtnewrow1);
            }
            DataRow dtreport = dtpayment.NewRow();
            dtreport["Payments"] = "totalamount";
            dtreport["Amount"] = ptotalamount;
            dtpayment.Rows.Add(dtreport);
            grdpayments.DataSource = dtpayment;
            grdpayments.DataBind();
            cmd = new SqlCommand("SELECT accountnowiseclosingdetails.sno, accountnowiseclosingdetails.accountid, accountnowiseclosingdetails.amount, accountnowiseclosingdetails.closedby, accountnowiseclosingdetails.doe, employe_login.name FROM accountnowiseclosingdetails INNER JOIN employe_login ON accountnowiseclosingdetails.closedby = employe_login.sno WHERE (accountnowiseclosingdetails.doe BETWEEN @d1 AND @d2) AND (accountnowiseclosingdetails.accountid = @accountid)");
            cmd.Parameters.Add("@accountid", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtemp = vdm.SelectQuery(cmd).Tables[0];
            if (dtemp.Rows.Count > 0)
            {
                lblpreparedby.Text = dtemp.Rows[0]["name"].ToString();
            }
            if (dtAccountType.Rows.Count > 0)
            {
                string AccountType = dtAccountType.Rows[0]["accounttype"].ToString();
                if (AccountType == "currentaccount")
                {
                    double dtOpeningbl = Convert.ToDouble(lblOppBal.Text);
                    AccouTotalamount = dtOpeningbl + ctotalamount;
                    double ClosingBal = AccouTotalamount - ptotalamount;
                    lblclosingbal.Text = ClosingBal.ToString();
                }
                else
                {
                    double dtOpeningbl = Convert.ToDouble(lblOppBal.Text);
                    AccouTotalamount = dtOpeningbl - ctotalamount;
                    double ClosingBal = AccouTotalamount + ptotalamount;
                    lblclosingbal.Text = ClosingBal.ToString();
                }
            }
        }
        catch (Exception ex)
        {
            //lblmsg.Text = ex.Message;
        }
    }

    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        GetReport();
        //ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "getbank_Uploaded_Documents()", true);
    }
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string clobal = lblclosingbal.Text;
            DateTime fromdate = new DateTime();
            string[] datestrig = txtFromdate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            fromdate = fromdate;
            cmd = new SqlCommand("SELECT sno, accountid, amount, closedby, doe FROM accountnowiseclosingdetails WHERE (doe BETWEEN @d1 AND @d2) AND (accountid = @accountid)");
            cmd.Parameters.Add("@accountid", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
            string msg = "";
            if (dtroutes.Rows.Count > 0)
            {
                lblbankmsg.Text = "This account no already closed";
            }
            else
            {
                cmd = new SqlCommand("insert into accountnowiseclosingdetails (accountid, amount, doe, closedby) values (@accountid, @amount, @doe, @userid)");
                cmd.Parameters.Add("@accountid", ddlaccountno.SelectedValue);
                cmd.Parameters.Add("@userid", Session["UserSno"].ToString());
                cmd.Parameters.Add("@amount", clobal);
                cmd.Parameters.Add("@doe", fromdate);
                vdm.insert(cmd);
                GetReport();
                lblbankmsg.Text = "Banksheet saved successfully";
            }
        }
        catch (Exception ex)

        {
            lblbankmsg.Text = ex.Message;
        }
    }
}