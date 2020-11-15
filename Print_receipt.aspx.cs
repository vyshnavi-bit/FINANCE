using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class Print_receipt : System.Web.UI.Page
{
    SqlCommand cmd;
    string UserName = "";
    VehicleDBMgr vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["TitleName"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        if (!this.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                lblTitle.Text = Session["TitleName"].ToString();
                lblSignTitle.Text = Session["TitleName"].ToString();
                if (Session["ReceiptNo"] == null)
                {
                }
                else
                {
                    txtReceiptNo.Text = Session["ReceiptNo"].ToString();
                }
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
    void getdet()
    {
        try
        {
            vdm = new VehicleDBMgr();
            lblmsg.Text = "";
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            int currentyear = ServerDateCurrentdate.Year;
            int nextyear = ServerDateCurrentdate.Year + 1;
            int currntyearnum = 0;
            int nextyearnum = 0;
            if (ServerDateCurrentdate.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear;
                nextyearnum = nextyear;
            }
            if (ServerDateCurrentdate.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear - 1;
                nextyearnum = nextyear - 1;
            }
            cmd = new SqlCommand("SELECT sno, accountno, name, amount, remarks, CONVERT(VARCHAR(10),doe,103) as doe, createdby, approvedby, status FROM collections WHERE (sno = @Receipt)");
            cmd.Parameters.Add("@BranchID", Session["branch"]);
            cmd.Parameters.Add("@Receipt", txtReceiptNo.Text);
            DataTable dtReceiptBook = vdm.SelectQuery(cmd).Tables[0];
            if (dtReceiptBook.Rows.Count > 0)
            {
                string Receiptid = "SVDS/RCPT/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dtReceiptBook.Rows[0]["sno"].ToString();
                lblreceiptno.Text = Receiptid;
                lblDate.Text = dtReceiptBook.Rows[0]["doe"].ToString();
                string Branch = Session["branch"].ToString();
                lblCheque.Text = "Cash";
                lbltowards.Text = "Cash Deposit";
                lblAmount.Text = dtReceiptBook.Rows[0]["amount"].ToString();
                lblChequeDate.Text = dtReceiptBook.Rows[0]["doe"].ToString();
                lblRemarks.Text = dtReceiptBook.Rows[0]["remarks"].ToString();
            }
            string Amont = lblAmount.Text;
            string[] Ones = { "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Ninteen" };

            string[] Tens = { "Ten", "Twenty", "Thirty", "Fourty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninty" };

            int Num = int.Parse(Amont);
            lblRupess.Text = NumToWordBD(Num) + " Rupees Only";
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
    public static string NumToWordBD(Int64 Num)
    {
        string[] Below20 = { "", "One ", "Two ", "Three ", "Four ", 
      "Five ", "Six " , "Seven ", "Eight ", "Nine ", "Ten ", "Eleven ", 
    "Twelve " , "Thirteen ", "Fourteen ","Fifteen ", 
      "Sixteen " , "Seventeen ","Eighteen " , "Nineteen " };
        string[] Below100 = { "", "", "Twenty ", "Thirty ", 
      "Forty ", "Fifty ", "Sixty ", "Seventy ", "Eighty ", "Ninety " };
        string InWords = "";
        if (Num >= 1 && Num < 20)
            InWords += Below20[Num];
        if (Num >= 20 && Num <= 99)
            InWords += Below100[Num / 10] + Below20[Num % 10];
        if (Num >= 100 && Num <= 999)
            InWords += NumToWordBD(Num / 100) + " Hundred " + NumToWordBD(Num % 100);
        if (Num >= 1000 && Num <= 99999)
            InWords += NumToWordBD(Num / 1000) + " Thousand " + NumToWordBD(Num % 1000);
        if (Num >= 100000 && Num <= 9999999)
            InWords += NumToWordBD(Num / 100000) + " Lakh " + NumToWordBD(Num % 100000);
        if (Num >= 10000000)
            InWords += NumToWordBD(Num / 10000000) + " Crore " + NumToWordBD(Num % 10000000);
        return InWords;
    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        getdet();
    }
}