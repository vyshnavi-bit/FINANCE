using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class SAPPayments : System.Web.UI.Page
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
            Session["RouteName"] = ddlaccountno.SelectedItem.Text;
            Session["IDate"] = DateTime.Now.AddDays(1).ToString("dd/MM/yyyy");
            vdm = new VehicleDBMgr();
            DateTime fromdate = DateTime.Now;
            string[] dateFromstrig = txtFromdate.Text.Split(' ');
            if (dateFromstrig.Length > 1)
            {
                if (dateFromstrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateFromstrig[0].Split('-');
                    string[] times = dateFromstrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            lbl_selfromdate.Text = fromdate.ToString("dd/MM/yyyy");
            lblRoutName.Text = ddlaccountno.SelectedItem.Text;
            Session["xporttype"] = "TallyBankPayments";
            string ledger = "";
            string ledgercode = "";
            string WHcode = "";
            string dwhcoe = "";
            cmd = new SqlCommand("SELECT sno, ladger_dr, ladger_dr_code, brach_ledger, brach_ledger_code FROM bankaccountno_master WHERE (sno = @accountno)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            DataTable dtledger = vdm.SelectQuery(cmd).Tables[0];
            if (dtledger.Rows.Count > 0)
            {
                ledger = dtledger.Rows[0]["ladger_dr"].ToString();
                ledgercode = dtledger.Rows[0]["ladger_dr_code"].ToString();
                WHcode = dtledger.Rows[0]["brach_ledger_code"].ToString();
            }
            cmd = new SqlCommand("SELECT company_master.sno,paymentsubdetails.headofaccount, paymentsubdetails.sno AS PSNO, paymentdetails.accountno, paymentdetails.sno, paymentdetails.remarks, paymentdetails.totalamount, paymentdetails.paymentdate, paymentdetails.sapimport, paymentsubdetails.amount, headofaccounts_master.accountname,headofaccounts_master.accountcode, branchmaster.series, branchmaster.whcode FROM  paymentsubdetails INNER JOIN paymentdetails ON paymentsubdetails.paymentrefno = paymentdetails.sno INNER JOIN  headofaccounts_master ON paymentsubdetails.headofaccount = headofaccounts_master.sno INNER JOIN branchmaster ON paymentdetails.sub_branch = branchmaster.branchid INNER JOIN company_master ON company_master.sno=branchmaster.company_code WHERE (paymentdetails.accountno = @accno) AND (paymentdetails.paymentdate BETWEEN @d1 AND @d2) and   (paymentdetails.sapimport = '1')");
            cmd.Parameters.Add("@accno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtsalescollection = vdm.SelectQuery(cmd).Tables[0];
            dtReport = new DataTable();
            dtReport.Columns.Add("Voucher Date");
            dtReport.Columns.Add("Voucher No");
            dtReport.Columns.Add("Voucher Type");
            dtReport.Columns.Add("WH Code");
            dtReport.Columns.Add("Credit Code");
            dtReport.Columns.Add("Ledger (Cr)");
            dtReport.Columns.Add("D WHCode");
            dtReport.Columns.Add("Debit Code");
            dtReport.Columns.Add("Ledger (Dr)");
            dtReport.Columns.Add("Amount");
            dtReport.Columns.Add("Series");
            dtReport.Columns.Add("Narration");
            dtReport.Columns.Add("cmpcode");
            int i = 1;
            foreach (DataRow branch in dtsalescollection.Rows)
            {
                string amt = branch["amount"].ToString();
                if (amt == "0")
                {
                }
                else
                {
                    DataRow newrow = dtReport.NewRow();
                    newrow["Voucher Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow["Voucher No"] = "BANK_PAY" + branch["PSNO"].ToString();
                    newrow["Voucher Type"] = "BANK";
                    if (branch["accountname"].ToString() == "")
                    {
                    }
                    else
                    {
                        newrow["WH Code"] = WHcode;
                        newrow["Credit Code"] = ledgercode;
                        newrow["Ledger (Cr)"] = ledger;
                        newrow["D WHCode"] = branch["whcode"].ToString();
                        newrow["Debit Code"] = branch["accountcode"].ToString();
                        newrow["Ledger (Dr)"] = branch["accountname"].ToString();
                        newrow["Amount"] = branch["amount"].ToString();
                        newrow["Narration"] = branch["Remarks"].ToString() + ",VoucherID  " + branch["sno"].ToString() + ",Emp Name  " + Session["EmpName"].ToString();
                        newrow["Series"] = branch["series"].ToString();
                        newrow["cmpcode"] = branch["sno"].ToString();
                        dtReport.Rows.Add(newrow);
                        i++;
                    }
                }
            }
            grdReports.DataSource = dtReport;
            grdReports.DataBind();
            Session["xportdata"] = dtReport;
            cmd = new SqlCommand("SELECT company_master.sno, paymentdetails.accountno, subaccount_payment.sno AS ssno, paymentdetails.sno, paymentdetails.remarks, paymentdetails.paymentdate, paymentdetails.sapimport, headofaccounts_master.accountname, headofaccounts_master.accountcode, subaccount_payment.amount,  subaccount_payment.headofaccount, branchmaster.series, branchmaster.whcode FROM  paymentdetails INNER JOIN subaccount_payment ON paymentdetails.sno = subaccount_payment.paymentrefno INNER JOIN headofaccounts_master ON subaccount_payment.headofaccount = headofaccounts_master.sno INNER JOIN branchmaster ON paymentdetails.sub_branch = branchmaster.branchid INNER JOIN company_master ON company_master.sno=branchmaster.company_code WHERE (paymentdetails.accountno = @accno) AND (paymentdetails.paymentdate BETWEEN @d1 AND @d2) and   (paymentdetails.sapimport = '2')");
            int j = 1;
            cmd.Parameters.Add("@accno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtsalessubcollection = vdm.SelectQuery(cmd).Tables[0];
            foreach (DataRow subhoc in dtsalessubcollection.Rows)
            {
                string amt = subhoc["amount"].ToString();
                if (amt == "0")
                {
                }
                else
                {
                    DataRow newrow = dtReport.NewRow();
                    newrow["Voucher Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow["Voucher No"] = "BANK_PAY" + subhoc["ssno"].ToString();
                    newrow["Voucher Type"] = "BANK";
                    if (subhoc["accountname"].ToString() == "")
                    {
                    }
                    else
                    {
                        newrow["WH Code"] = WHcode;
                        newrow["Credit Code"] = ledgercode;
                        newrow["Ledger (Cr)"] = ledger;
                        newrow["D WHCode"] = subhoc["whcode"].ToString();

                        newrow["Debit Code"] = subhoc["accountcode"].ToString();
                        newrow["Ledger (Dr)"] = subhoc["accountname"].ToString();
                        newrow["Amount"] = subhoc["amount"].ToString();
                        newrow["Narration"] = subhoc["Remarks"].ToString() + ",VoucherID  " + subhoc["sno"].ToString() + ",Emp Name  " + Session["EmpName"].ToString();
                        newrow["Series"] = subhoc["series"].ToString();
                        newrow["cmpcode"] = subhoc["sno"].ToString();
                        dtReport.Rows.Add(newrow);
                        j++;
                    }
                }
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
            DataTable dtdoublevendor = new DataTable();
            dtdoublevendor.Columns.Add("ledgername");
            
            DateTime CreateDate = VehicleDBMgr.GetTime(vdm.conn);
            SAPdbmanger SAPvdm = new SAPdbmanger();
            DateTime fromdate = DateTime.Now;
            DataTable dt = (DataTable)Session["xportdata"];
            string[] dateFromstrig = txtFromdate.Text.Split(' ');
            if (dateFromstrig.Length > 1)
            {
                if (dateFromstrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateFromstrig[0].Split('-');
                    string[] times = dateFromstrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            foreach (GridViewRow row in grdReports.Rows)
            {
                //string PaymentMode = "CASH";
                //string B1Upload = "N";
                //string Processed = "N";
                if (row.RowType == DataControlRowType.DataRow)
                {
                    CheckBox chkRow = (row.Cells[0].FindControl("chkRow") as CheckBox);
                    if (chkRow.Checked)
                    {
                        string VoucherDate = row.Cells[1].Text;
                        string VoucherNo = row.Cells[2].Text;
                        string VoucherType = row.Cells[3].Text;
                        string whcode = row.Cells[4].Text;
                        string creditcode = row.Cells[5].Text;
                        string creditledger = row.Cells[6].Text;
                        string AcctCode = row.Cells[5].Text;
                        string dwhcode = row.Cells[7].Text;
                        string debitcode = row.Cells[8].Text;
                        string debitledger = row.Cells[9].Text;

                        string Amount = row.Cells[10].Text;
                        string Narration = row.Cells[12].Text;
                        string ser = row.Cells[11].Text;
                        string cmpcode = row.Cells[13].Text;
                        
                        //string AcctCode = dr["Credit Code"].ToString();
                        //string VoucherNo = dr["Voucher No"].ToString();
                        //string vochertype = dr["Voucher Type"].ToString();
                        //string whcode = dr["WH Code"].ToString();
                        //string creditcode = dr["Credit Code"].ToString();
                        //string creditledger = dr["Ledger (Cr)"].ToString();
                        //string debitcode = dr["Debit Code"].ToString();
                        //string debitledger = dr["Ledger (Dr)"].ToString();
                        //string Amount = dr["Amount"].ToString();
                        //string Narration = dr["Narration"].ToString();
                        //string dwhcode = dr["D WHCode"].ToString();
                        if (AcctCode == "")
                        {
                        }
                        else
                        {
                            double num;
                            string candidate = "1";
                            if (double.TryParse(debitcode, out num))
                            {
                                string PaymentMode = "BANK";
                                double amount = 0;
                                double.TryParse(Amount, out amount);
                                string B1Upload = "N";
                                string Processed = "N";
                                sqlcmd = new SqlCommand("SELECT CreateDate, RefDate, DocDate, Ref1, Ref2, Ref3 FROM EMROJDTP WHERE (RefDate BETWEEN @d1 AND @d2) AND (Ref1 = @Refno) AND (AcctCode=@AcctCode)");
                                sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                                sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                                sqlcmd.Parameters.Add("@Refno", VoucherNo);
                                sqlcmd.Parameters.Add("@AcctCode", debitcode);
                                DataTable dtJournelPay = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                                if (dtJournelPay.Rows.Count > 0)
                                {
                                    DataRow newrow = dtdoublevendor.NewRow();
                                    newrow["ledgername"] = debitcode;
                                    dtdoublevendor.Rows.Add(newrow);
                                    lbl_msg.Text = "This Payment already Saved";
                                }
                                else
                                {
                                    if (debitcode != "")
                                    {
                                        sqlcmd = new SqlCommand("Insert into EMROJDTP (CreateDate, RefDate, DocDate, TransNo, TransCode, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,Remarks,series) values (@CreateDate, @RefDate, @DocDate,@TransNo,@TransCode, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@Remarks,@series)");
                                        sqlcmd.Parameters.Add("@CreateDate", CreateDate);
                                        sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@Ref1", VoucherNo);
                                        string TransCode = "T1";
                                        sqlcmd.Parameters.Add("@TransNo", VoucherNo);
                                        sqlcmd.Parameters.Add("@TransCode", TransCode);
                                        sqlcmd.Parameters.Add("@AcctCode", debitcode);
                                        sqlcmd.Parameters.Add("@AcctName", debitledger);
                                        double.TryParse(Amount, out amount);
                                        sqlcmd.Parameters.Add("@Debit", amount);
                                        string Creditamount = "0";
                                        sqlcmd.Parameters.Add("@Credit", Creditamount);
                                        sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                                        sqlcmd.Parameters.Add("@Processed", Processed);
                                        sqlcmd.Parameters.Add("@OcrCode", dwhcode);
                                        sqlcmd.Parameters.Add("@Remarks", Narration);
                                        string series = "";
                                        if (cmpcode == "2")
                                        {
                                            series = "111";
                                        }
                                        else
                                        {
                                            series = "134";
                                        }
                                        sqlcmd.Parameters.Add("@series", series);
                                        SAPvdm.insert(sqlcmd);

                                        sqlcmd = new SqlCommand("Insert into EMROJDTP (CreateDate, RefDate, DocDate, TransNo,TransCode, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,Remarks,series) values (@CreateDate, @RefDate, @DocDate,@TransNo,@TransCode, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@Remarks,@series)");
                                        sqlcmd.Parameters.Add("@CreateDate", CreateDate);
                                        sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@Ref1", VoucherNo);
                                        sqlcmd.Parameters.Add("@TransNo", VoucherNo);
                                        sqlcmd.Parameters.Add("@TransCode", TransCode);
                                        sqlcmd.Parameters.Add("@AcctCode", creditcode);
                                        sqlcmd.Parameters.Add("@AcctName", creditledger);
                                        string Debitamount = "0";
                                        sqlcmd.Parameters.Add("@Debit", Debitamount);
                                        sqlcmd.Parameters.Add("@Credit", amount);
                                        sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                                        sqlcmd.Parameters.Add("@Processed", Processed);
                                        sqlcmd.Parameters.Add("@OcrCode", whcode);
                                        sqlcmd.Parameters.Add("@Remarks", Narration);
                                        sqlcmd.Parameters.Add("@series", series);
                                        SAPvdm.insert(sqlcmd);
                                    }
                                }
                            }
                            else
                            {

                                sqlcmd = new SqlCommand("SELECT CreateDate, PaymentDate, DOE FROM EMROVPM WHERE (PaymentDate BETWEEN @d1 AND @d2) AND (ReferenceNo = @TNo) AND (CardCode = @CardCode)");
                                sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                                sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                                sqlcmd.Parameters.Add("@TNo", VoucherNo);
                                sqlcmd.Parameters.Add("@CardCode", debitcode);
                                DataTable dtovpm = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                                if (dtovpm.Rows.Count > 0)
                                {
                                    DataRow newrow = dtdoublevendor.NewRow();
                                    newrow["ledgername"] = debitcode;
                                    dtdoublevendor.Rows.Add(newrow);
                                    lbl_msg.Text = "This Payment already Saved";
                                }
                                else
                                {
                                    if (debitcode != "")
                                    {
                                        sqlcmd = new SqlCommand("Insert into EMROVPM (CreateDate, PaymentDate, DOE, ReferenceNo, CardCode, Remarks, AcctNo,  PaymentMode, PaymentSum, OcrCode, B1Upload, Processed, Series) values (@CreateDate, @RefDate, @docdate,@VoucherNo, @CardCode, @Remarks, @AcctCode, @PaymentMode, @PaymentSum, @OcrCode, @B1Upload, @Processed, @Series)");
                                        sqlcmd.Parameters.Add("@CreateDate", CreateDate);
                                        sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@VoucherNo", VoucherNo);
                                        sqlcmd.Parameters.Add("@OcrCode", dwhcode);
                                        sqlcmd.Parameters.Add("@CardCode", debitcode);
                                        sqlcmd.Parameters.Add("@AcctCode", creditcode);
                                        sqlcmd.Parameters.Add("@AcctName", debitledger);
                                        sqlcmd.Parameters.Add("@Series", ser);
                                        sqlcmd.Parameters.Add("@Remarks", Narration);
                                        sqlcmd.Parameters.Add("@PaymentMode", VoucherType);
                                        sqlcmd.Parameters.Add("@PaymentSum", Amount);
                                        string B1Upload = "N";
                                        string Processed = "N";
                                        sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                                        sqlcmd.Parameters.Add("@Processed", Processed);
                                        SAPvdm.insert(sqlcmd);
                                    }
                                    else
                                    {

                                    }
                                }
                            }
                        }
                    }
                }
            }
            pnlHide.Visible = false;
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
            grdReports.DataSource = dtdoublevendor;
            grdReports.DataBind();
            if (lbl_msg.Text == "")
            {
                lbl_msg.Text = "SuccessFully Saved";
            }
        }
        catch (Exception ex)
        {
            lbl_msg.Text = ex.ToString();
        }
    }
}