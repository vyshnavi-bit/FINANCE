using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CollectionandPaymentReport : System.Web.UI.Page
{
    SqlCommand cmd;
    VehicleDBMgr vdm;
    protected void Page_Load(object sender, EventArgs e)
    {

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
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            //Report.Columns.Add("Sno");
            Report.Columns.Add("Name");
            Report.Columns.Add("Accountno");
            Report.Columns.Add("HeadofAccountName");
            Report.Columns.Add("Amount");
            //Report.Columns.Add("TotalAmount");
            //Report.Columns.Add("Approvedby");
            lblmsg.Text = "";
            VehicleDBMgr VehicleDB = new VehicleDBMgr();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string[] datestrig = dtp_FromDate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            datestrig = dtp_Todate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            lblFromDate.Text = fromdate.ToString("dd/MM/yyyy");
            lbltodate.Text = todate.ToString("dd/MM/yyyy");
            if (ddlType.SelectedItem.Value == "Collections")
            {
                cmd = new SqlCommand("select c.name, bam.accountno, ham.accountname,csd.amount from collections c inner join collectionsubdetails csd on csd.collectionrefno = c.sno inner join bankaccountno_master bam on bam.sno=c.accountno inner join headofaccounts_master ham on ham.sno=csd.headofaccount");


            }
            else
            {
                cmd = new SqlCommand("select p.name, bam.accountno, ham.accountname,psd.amount from paymentdetails p inner join paymentsubdetails psd on psd.paymentrefno = p.sno inner join bankaccountno_master bam on bam.sno=p.accountno inner join headofaccounts_master ham on ham.sno=psd.headofaccount ");

            }
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            DataTable tabledetails = VehicleDB.SelectQuery(cmd).Tables[0];
            if (tabledetails.Rows.Count > 0)
            {
                double totalamount = 0;
                double amount = 0;
                foreach (DataRow dr in tabledetails.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    //double.TryParse(dr["amount"].ToString(), out amount);
                    string Amount = dr["amount"].ToString();
                    amount = Convert.ToDouble(Amount);
                    // newrow["sno"] = dr["sno"].ToString();
                    newrow["Name"] = dr["name"].ToString();
                    newrow["Accountno"] = dr["accountno"].ToString();
                    newrow["HeadofAccountName"] = dr["accountname"].ToString();
                    newrow["Amount"] = dr["amount"].ToString();
                    //newrow["Approvedby"] = dr["username"].ToString();
                    totalamount += amount;
                    //newrow["TotalAmount"] = dr["amount"].ToString();
                    Report.Rows.Add(newrow);
                }
                DataRow report = Report.NewRow();
                report["HeadofAccountName"] = "totalamount";
                report["Amount"] = totalamount;
                Report.Rows.Add(report);
                grdReports.DataSource = Report;
                grdReports.DataBind();
                hidepanel.Visible = true;
            }
            else
            {
                lblmsg.Text = "No data were found";
                hidepanel.Visible = false;
            }

        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;

        }

    }
}