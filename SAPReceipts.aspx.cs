using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class SAPReceipts : System.Web.UI.Page
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
            SAPdbmanger SAPvdm = new SAPdbmanger();
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
            Session["xporttype"] = "TallyReceipts";
            string ledger = "";
            string ledgercode = "";
            string WHcode = "";
            cmd = new SqlCommand("SELECT sno, ladger_dr, ladger_dr_code, brach_ledger, brach_ledger_code FROM bankaccountno_master WHERE (sno = @accountno)");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            DataTable dtledger = vdm.SelectQuery(cmd).Tables[0];
            if (dtledger.Rows.Count > 0)
            {
                ledger = dtledger.Rows[0]["ladger_dr"].ToString();
                ledgercode = dtledger.Rows[0]["ladger_dr_code"].ToString();
                WHcode = dtledger.Rows[0]["brach_ledger_code"].ToString();
            }
            cmd = new SqlCommand("SELECT company_master.sno as cmpcode, collections.sno, collectionsubdetails.sno as csno, collections.accountno, collections.remarks, CONVERT(VARCHAR(10), collections.receiptdate, 103) AS doe, headofaccounts_master.accountname,headofaccounts_master.accountcode, collectionsubdetails.headofaccount, collectionsubdetails.amount, collections.branch, branchmaster.receiptseries, branchmaster.whcode, collections.sapimport  FROM  collections INNER JOIN  collectionsubdetails ON collections.sno = collectionsubdetails.collectionrefno INNER JOIN headofaccounts_master ON collectionsubdetails.headofaccount = headofaccounts_master.sno INNER JOIN branchmaster ON collections.subbranch = branchmaster.branchid INNER JOIN company_master ON company_master.sno=branchmaster.company_code WHERE (collections.receiptdate BETWEEN @d1 AND @d2) AND (collections.accountno = @accountno) AND (collections.sapimport = '1')");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtsalescollection = vdm.SelectQuery(cmd).Tables[0];
            dtReport = new DataTable();
            dtReport.Columns.Add("Voucher Date");
            dtReport.Columns.Add("Voucher No");
            dtReport.Columns.Add("Voucher Type");
            dtReport.Columns.Add("WH Code");
            dtReport.Columns.Add("Debit Code");
            dtReport.Columns.Add("Ledger (Dr)");
            dtReport.Columns.Add("C WHCODE");
            dtReport.Columns.Add("Credit Code");
            dtReport.Columns.Add("Ledger (Cr)");
            dtReport.Columns.Add("Amount");
            dtReport.Columns.Add("Series");
            dtReport.Columns.Add("Narration");
            dtReport.Columns.Add("cmpcode");
            int i = 1;
            foreach (DataRow branch in dtsalescollection.Rows)
            {
                double num;
                string accode = branch["accountcode"].ToString();

                string amount = branch["amount"].ToString();
                sqlcmd = new SqlCommand("SELECT * FROM EMROJDTP WHERE AcctCode=@actcode AND Debit=@Debit AND CreateDate=@doe");
                sqlcmd.Parameters.Add("@doe", GetLowDate(fromdate));
                sqlcmd.Parameters.Add("@Debit", amount);
                sqlcmd.Parameters.Add("@actcode", ledgercode);
                DataTable dtJournelexist = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                if (dtJournelexist.Rows.Count > 0)
                {

                }
                else
                {
                    DataRow newrow = dtReport.NewRow();
                    newrow["Voucher Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow["Voucher No"] = "BANK_REC" + branch["csno"].ToString();
                    newrow["Voucher Type"] = "Bank Receipt Import";
                    newrow["Ledger (Dr)"] = ledger;
                    if (branch["accountname"].ToString() == "")
                    {
                    }
                    else
                    {
                        newrow["WH Code"] = WHcode;
                        newrow["Credit Code"] = branch["accountcode"].ToString();
                        newrow["Ledger (Cr)"] = branch["accountname"].ToString();
                        newrow["Debit Code"] = ledgercode;
                        newrow["Ledger (Dr)"] = ledger;
                        newrow["C WHCODE"] = branch["whcode"].ToString();
                        newrow["Series"] = branch["receiptseries"].ToString();
                        newrow["Amount"] = branch["amount"].ToString();
                        newrow["Narration"] = branch["remarks"].ToString() + " vide Receipt No " + branch["sno"].ToString() + ",Receipt Date " + fromdate.ToString("dd/MM/yyyy") + ",Emp Name " + Session["EmpName"].ToString();
                        newrow["cmpcode"] = branch["cmpcode"].ToString();
                        dtReport.Rows.Add(newrow);
                        i++;
                    }
                }
            }
            grdReports.DataSource = dtReport;
            grdReports.DataBind();
            Session["xportdata"] = dtReport;
            cmd = new SqlCommand("SELECT company_master.sno as cmpcode, collections.sno, subaccount_collection.sno AS CSCSNO, collections.accountno, collections.remarks, CONVERT(VARCHAR(10), collections.receiptdate, 103) AS doe, headofaccounts_master.accountname,headofaccounts_master.accountcode, collections.branch, collections.sapimport, subaccount_collection.headofaccount, subaccount_collection.amount, branchmaster.whcode, branchmaster.receiptseries FROM  collections INNER JOIN subaccount_collection ON collections.sno = subaccount_collection.collectionrefno INNER JOIN headofaccounts_master ON subaccount_collection.headofaccount = headofaccounts_master.sno INNER JOIN branchmaster ON collections.subbranch = branchmaster.branchid INNER JOIN company_master ON company_master.sno=branchmaster.company_code WHERE (collections.receiptdate BETWEEN @d1 AND @d2) AND (collections.accountno = @accountno) AND (collections.sapimport = '2')");
            cmd.Parameters.Add("@accountno", ddlaccountno.SelectedValue);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable dtsalessubcollection = vdm.SelectQuery(cmd).Tables[0];
            int j = 1;
            foreach (DataRow branch in dtsalessubcollection.Rows)
            {
                string amount = branch["amount"].ToString();
                string actcode = "";
                double num;
                string accode = branch["accountcode"].ToString();


                sqlcmd = new SqlCommand("SELECT * FROM EMROJDTP WHERE AcctCode=@actcode AND Debit=@Debit AND RefDate=@doe");
                sqlcmd.Parameters.Add("@doe", GetLowDate(fromdate));
                sqlcmd.Parameters.Add("@Debit", amount);
                sqlcmd.Parameters.Add("@actcode", ledgercode);

                DataTable dtJournelexist = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                if (dtJournelexist.Rows.Count > 0)
                {

                }
                else
                {
                    DataRow newrow = dtReport.NewRow();
                    newrow["Voucher Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow["Voucher No"] = "BANK_REC" + branch["CSCSNO"].ToString();
                    newrow["Voucher Type"] = "Bank Receipt Import";
                    newrow["Ledger (Dr)"] = ledger;
                    if (branch["accountname"].ToString() == "")
                    {
                    }
                    else
                    {
                        //newrow["WH Code"] = WHcode;
                        //newrow["Credit Code"] = ledgercode;
                        newrow["C WHCODE"] = branch["whcode"].ToString();
                        newrow["WH Code"] = WHcode;
                        newrow["Credit Code"] = branch["accountcode"].ToString();
                        newrow["Ledger (Cr)"] = branch["accountname"].ToString();
                        newrow["Debit Code"] = ledgercode;
                        newrow["Ledger (Dr)"] = ledger;
                        newrow["Amount"] = branch["amount"].ToString();
                        newrow["Narration"] = branch["remarks"].ToString() + " vide Receipt No " + branch["sno"].ToString() + ",Receipt Date " + fromdate.ToString("dd/MM/yyyy") + ",Emp Name " + Session["EmpName"].ToString();
                        newrow["Series"] = branch["receiptseries"].ToString();
                        newrow["cmpcode"] = branch["cmpcode"].ToString();
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
                        string debitcode = row.Cells[5].Text;
                        string debitledger = row.Cells[6].Text;
                        string creditcode = row.Cells[8].Text;
                        string AcctCode = row.Cells[8].Text;
                        string creditledger = row.Cells[9].Text;
                        string Amount = row.Cells[10].Text;
                        string Narration = row.Cells[12].Text;
                        string ser = row.Cells[11].Text;
                        string cmpnycode = row.Cells[13].Text;

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
                        if (AcctCode == "")
                        {
                        }
                        else
                        {
                            double num;
                            if (double.TryParse(creditcode, out num))
                            {
                                string PaymentMode = "BANK";
                                double amount = 0;
                                double.TryParse(Amount, out amount);
                                string B1Upload = "N";
                                string Processed = "N";
                                sqlcmd = new SqlCommand("SELECT CreateDate, RefDate, DocDate, Ref1, Ref2, Ref3 FROM EMROJDTP WHERE (RefDate BETWEEN @d1 AND @d2) AND (Ref1 = @Refno) AND (AcctCode=@AcctCode)");
                                sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                                sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                                sqlcmd.Parameters.Add("@AcctCode", AcctCode);
                                sqlcmd.Parameters.Add("@Refno", VoucherNo);
                                DataTable dtJournelPay = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                                if (dtJournelPay.Rows.Count > 0)
                                {
                                    lbl_msg.Text = "This Receipt Already Saved";
                                }
                                else
                                {
                                    if (creditcode != "")
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
                                        sqlcmd.Parameters.Add("@OcrCode", whcode);
                                        sqlcmd.Parameters.Add("@Remarks", Narration);
                                        string series = "";
                                        if (cmpnycode == "2")
                                        {
                                            series = "110";
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
                                    else
                                    {
                                        lbl_msg.Text = "Update the Credit Code";
                                    }
                                }
                            }
                            else
                            {
                                sqlcmd = new SqlCommand("SELECT CreateDate, PaymentDate, DOE FROM EMRORCT WHERE (PaymentDate BETWEEN @d1 AND @d2) AND (ReferenceNo = @TNo) AND (CardCode=@CardCode)");
                                sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                                sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                                sqlcmd.Parameters.Add("@TNo", VoucherNo);
                                sqlcmd.Parameters.Add("@CardCode", creditcode);
                                DataTable dtovpm = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                                if (dtovpm.Rows.Count > 0)
                                {
                                    lbl_msg.Text = "This Receipt Already Saved";
                                }
                                else
                                {
                                    if (creditcode != "")
                                    {
                                        sqlcmd = new SqlCommand("INSERT INTO EMRORCT(CreateDate, PaymentDate, DOE, ReferenceNo, CardCode, AcctNo, Remarks, PaymentMode, PaymentSum, OcrCode, B1Upload, Processed, Series) values (@CreateDate, @RefDate, @DocDate, @TransNo, @CardCode, @AcctCode, @Remarks, @PaymentMode, @PaymentSum, @OcrCode, @B1Upload, @Processed, @Series)");
                                        sqlcmd.Parameters.Add("@CreateDate", CreateDate);
                                        sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                                        sqlcmd.Parameters.Add("@VoucherNo", VoucherNo);
                                        sqlcmd.Parameters.Add("@TransNo", VoucherNo);
                                        sqlcmd.Parameters.Add("@OcrCode", whcode);
                                        sqlcmd.Parameters.Add("@CardCode", creditcode);
                                        sqlcmd.Parameters.Add("@AcctCode", debitcode);
                                        sqlcmd.Parameters.Add("@AcctName", creditledger);
                                        sqlcmd.Parameters.Add("@Series", ser);
                                        sqlcmd.Parameters.Add("@Remarks", Narration);
                                        sqlcmd.Parameters.Add("@PaymentMode", "BANK");
                                        sqlcmd.Parameters.Add("@PaymentSum", Amount);
                                        string B1Upload = "N";
                                        string Processed = "N";
                                        sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                                        sqlcmd.Parameters.Add("@Processed", Processed);
                                        SAPvdm.insert(sqlcmd);
                                    }
                                    else
                                    {
                                        lbl_msg.Text = "Update the Credit Code";
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
            if (lbl_msg.Text == "")
            {
                lbl_msg.Text = "SuccessFully Saved";
            }
            

            //foreach (DataRow dr in dt.Rows)
            //{
            //    string AcctCode = dr["Credit Code"].ToString();
            //    string VoucherNo = dr["Voucher No"].ToString();
            //    string vochertype = dr["Voucher Type"].ToString();
            //    string whcode = dr["WH Code"].ToString();
            //    string creditcode = dr["Credit Code"].ToString();
            //    string creditledger = dr["Ledger (Cr)"].ToString();
            //    string debitcode = dr["Debit Code"].ToString();
            //    string debitledger = dr["Ledger (Dr)"].ToString();
            //    string Amount = dr["Amount"].ToString();
            //    string Narration = dr["Narration"].ToString();
            //    if (AcctCode == "")
            //    {
            //    }
            //    else
            //    {
            //        double num;
            //        if (double.TryParse(creditcode, out num))
            //        {
            //            string PaymentMode = "BANK";
            //            double amount = 0; 
            //            double.TryParse(dr["Amount"].ToString(), out amount);
            //            string B1Upload = "N";
            //            string Processed = "N";

            //            sqlcmd = new SqlCommand("SELECT CreateDate, RefDate, DocDate, Ref1, Ref2, Ref3 FROM EMROJDTP WHERE (RefDate BETWEEN @d1 AND @d2) AND (Ref1 = @Refno) AND (AcctCode=@AcctCode)");
            //            sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
            //            sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
            //            sqlcmd.Parameters.Add("@AcctCode", dr["Credit Code"].ToString());
            //            sqlcmd.Parameters.Add("@Refno", dr["Voucher No"].ToString());
            //            DataTable dtJournelPay = SAPvdm.SelectQuery(sqlcmd).Tables[0];
            //            if (dtJournelPay.Rows.Count > 0)
            //            {

            //            }
            //            else
            //            {
            //                sqlcmd = new SqlCommand("Insert into EMROJDTP (CreateDate, RefDate, DocDate, TransNo, TransCode, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,Remarks,series) values (@CreateDate, @RefDate, @DocDate,@TransNo,@TransCode, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@Remarks,@series)");
            //                sqlcmd.Parameters.Add("@CreateDate", CreateDate);
            //                sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
            //                sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
            //                sqlcmd.Parameters.Add("@Ref1", dr["Voucher No"].ToString());
            //                string TransCode = "T1";
            //                sqlcmd.Parameters.Add("@TransNo", dr["Voucher No"].ToString());
            //                sqlcmd.Parameters.Add("@TransCode", TransCode);
            //                sqlcmd.Parameters.Add("@AcctCode", dr["Debit Code"].ToString());
            //                sqlcmd.Parameters.Add("@AcctName", dr["Ledger (Dr)"].ToString());
            //                double.TryParse(dr["Amount"].ToString(), out amount);
            //                sqlcmd.Parameters.Add("@Debit", amount);
            //                string Creditamount = "0";
            //                sqlcmd.Parameters.Add("@Credit", Creditamount);
            //                sqlcmd.Parameters.Add("@B1Upload", B1Upload);
            //                sqlcmd.Parameters.Add("@Processed", Processed);
            //                sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
            //                sqlcmd.Parameters.Add("@Remarks", dr["Narration"].ToString());
            //                string series = "134";
            //                sqlcmd.Parameters.Add("@series", series);
            //                SAPvdm.insert(sqlcmd);

            //                sqlcmd = new SqlCommand("Insert into EMROJDTP (CreateDate, RefDate, DocDate, TransNo,TransCode, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,Remarks,series) values (@CreateDate, @RefDate, @DocDate,@TransNo,@TransCode, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@Remarks,@series)");
            //                sqlcmd.Parameters.Add("@CreateDate", CreateDate);
            //                sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
            //                sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
            //                sqlcmd.Parameters.Add("@Ref1", dr["Voucher No"].ToString());
            //                sqlcmd.Parameters.Add("@TransNo", dr["Voucher No"].ToString());
            //                sqlcmd.Parameters.Add("@TransCode", TransCode);
            //                sqlcmd.Parameters.Add("@AcctCode", dr["Credit Code"].ToString());
            //                sqlcmd.Parameters.Add("@AcctName", dr["Ledger (Cr)"].ToString());
            //                string Debitamount = "0";
            //                sqlcmd.Parameters.Add("@Debit", Debitamount);
            //                sqlcmd.Parameters.Add("@Credit", amount);
            //                sqlcmd.Parameters.Add("@B1Upload", B1Upload);
            //                sqlcmd.Parameters.Add("@Processed", Processed);
            //                sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
            //                sqlcmd.Parameters.Add("@Remarks", dr["Narration"].ToString());
            //                sqlcmd.Parameters.Add("@series", series);
            //                SAPvdm.insert(sqlcmd);
            //            }
            //        }
            //        else
            //        {
            //            sqlcmd = new SqlCommand("SELECT CreateDate, PaymentDate, DOE FROM EMRORCT WHERE (PaymentDate BETWEEN @d1 AND @d2) AND (ReferenceNo = @TNo) AND (AcctNo=@AcctCode)");
            //            sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
            //            sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
            //            sqlcmd.Parameters.Add("@TNo", dr["Voucher No"].ToString());
            //            sqlcmd.Parameters.Add("@AcctCode", debitcode);
            //            DataTable dtovpm = SAPvdm.SelectQuery(sqlcmd).Tables[0];
            //            if (dtovpm.Rows.Count > 0)
            //            {
            //            }
            //            else
            //            {
            //                sqlcmd = new SqlCommand("INSERT INTO EMRORCT(CreateDate, PaymentDate, DOE, ReferenceNo, CardCode, AcctNo, Remarks, PaymentMode, PaymentSum, OcrCode, B1Upload, Processed, Series) values (@CreateDate, @RefDate, @DocDate, @TransNo, @CardCode, @AcctCode, @Remarks, @PaymentMode, @PaymentSum, @OcrCode, @B1Upload, @Processed, @Series)");
            //                sqlcmd.Parameters.Add("@CreateDate", CreateDate);
            //                sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
            //                sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
            //                sqlcmd.Parameters.Add("@VoucherNo", VoucherNo);
            //                sqlcmd.Parameters.Add("@TransNo", dr["Voucher No"].ToString());
            //                sqlcmd.Parameters.Add("@OcrCode", whcode);
            //                sqlcmd.Parameters.Add("@CardCode", creditcode);
            //                sqlcmd.Parameters.Add("@AcctCode", debitcode);
            //                sqlcmd.Parameters.Add("@AcctName", creditledger);
            //                sqlcmd.Parameters.Add("@Series", "15");
            //                sqlcmd.Parameters.Add("@Remarks", Narration);
            //                sqlcmd.Parameters.Add("@PaymentMode", "BANK");
            //                sqlcmd.Parameters.Add("@PaymentSum", Amount);
            //                string B1Upload = "N";
            //                string Processed = "N";
            //                sqlcmd.Parameters.Add("@B1Upload", B1Upload);
            //                sqlcmd.Parameters.Add("@Processed", Processed);
            //                SAPvdm.insert(sqlcmd);
            //            }
            //        }
            //    }
            //}
            //pnlHide.Visible = false;
            //DataTable dtempty = new DataTable();
            //grdReports.DataSource = dtempty;
            //grdReports.DataBind();
            //lbl_msg.Text = "Successfully Saved";
        }
        catch (Exception ex)
        {
            lbl_msg.Text = ex.ToString();
        }
    }
}