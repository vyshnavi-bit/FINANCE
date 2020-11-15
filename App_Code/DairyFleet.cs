using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using System.Net.Mime;
using System.Collections;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Data.SqlClient;
using System.Reflection;

//using System.Security.Authentication;
/// <summary>
/// Summary description for DairyFleet
/// </summary>
public class DairyFleet : IHttpHandler, IRequiresSessionState
{
    SqlCommand cmd;
    VehicleDBMgr vdm;
    public DairyFleet()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public bool IsReusable
    {
        get { return true; }
    }
   

    class GetJsonData
    {
        public string op { set; get; }
    }
    public object BankName { get; private set; }

    class Orders
    {
        public string operation { set; get; }
        public string BranchID { set; get; }
        public string imagecode { set; get; }
    }
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string operation = context.Request["op"];
            switch (operation)
            {
                case "save_bank_click":
                    save_bank_click(context);
                    break;
                case "get_bank_details":
                    get_bank_details(context);
                    break;
                case "save_BankIfsc_Details":
                    save_BankIfsc_Details(context);
                    break;
                case "get_bankifsc_details":
                    get_bankifsc_details(context);
                    break;
                case "get_bankwiseifsc_details":
                    get_bankwiseifsc_details(context);
                    break;
                case "get_ifscwisebranch_details":
                    get_ifscwisebranch_details(context);
                    break;
                case "get_branchwiseifsc_details":
                    get_branchwiseifsc_details(context);
                    break;
                case "save_BankAccount_Details":
                    save_BankAccount_Details(context);
                    break;
                case "get_bankaccount_details":
                    get_bankaccount_details(context);
                    break;
                case "saveheadofaccountsDetails":
                    saveheadofaccountsDetails(context);
                    break;
                case "get_headofaccount_details":
                    get_headofaccount_details(context);
                    break;
                 case "get_primarywise_groupledger":
                    get_primarywise_groupledger(context);
                    break;
                case "get_subgroup_ledgercode":
                    get_subgroup_ledgercode(context);
                    break;
                case "get_payments_details":
                    get_payments_details(context);
                    break;
                case "get_paymentsub_details":
                    get_paymentsub_details(context);
                    break;
                case "save_Department_Details":
                    save_Department_Details(context);
                    break;
                case "get_dept_details":
                    get_dept_details(context);
                    break;
                case "save_employee_details":
                    save_employee_details(context);
                    break;
                case "get_employee_details":
                    get_employee_details(context);
                    break;
                case "updtae_approvalpayment_click":
                    updtae_approvalpayment_click(context);
                    break;
                case "get_bankamount_details":
                    get_bankamount_details(context);
                    break;
                case "get_collections_details":
                    get_collections_details(context);
                    break;
                case "get_collectionssubdetails":
                    get_collectionssubdetails(context);
                    break;
                case "get_subaccount_collectiondetails":
                    get_subaccount_collectiondetails(context);
                    break;
                case "get_payment_details":
                    get_payment_details(context);
                    break;
                case "get_paymentsubdetails":
                    get_paymentsubdetails(context);
                    break;
                case "get_subaccount_paymentdetails":
                    get_subaccount_paymentdetails(context);
                    break;
                case "get_SubHeadofAccount_details":
                    get_SubHeadofAccount_details(context);
                    break;
                case "btnReceiptPrintClick":
                    btnReceiptPrintClick(context);
                    break;
                case "btnPaymentPrintClick":
                    btnPaymentPrintClick(context);
                    break;
                case "GetSubPaybleValues":
                    GetSubPaybleValues(context);
                    break;
                case "get_Journel_entry_details":
                    get_Journel_entry_details(context);
                    break;
                case "get_journelsubdetails":
                    get_journelsubdetails(context);
                    break;
                case "saveCompanyMasterdetails":
                    saveCompanyMasterdetails(context);
                    break;
                case "get_CompanyMaster_details":
                    get_CompanyMaster_details(context);
                    break;
                case "get_Branch_details":
                    get_Branch_details(context);
                    break;
                case "saveBranchDetails":
                    saveBranchDetails(context);
                    break;
                //sai
                case "save_control_types":
                    save_control_types(context);
                    break;
                case "save_Transaction_SubTypes":
                    save_Transaction_SubTypes(context);
                    break;
                case "get_control_types":
                    get_control_types(context);
                    break;
                case "get_transsub_type":
                    get_transsub_type(context);
                    break;
                case "get_subjv_creditdetails":
                    get_subjv_creditdetails(context);
                    break;
                case "get_subaccountentry_paymentdetails":
                    get_subaccountentry_paymentdetails(context);
                    break;
                case "get_paymentsubentry_details":
                    get_paymentsubentry_details(context);
                    break;
                case "get_paymentsubview_details":
                    get_paymentsubview_details(context);
                    break;

                //Mounika Srinivas

                case "save_transaction_type":
                    save_transaction_type(context);
                    break;
                case "get_transaction_type":
                    get_transaction_type(context);
                    break;
                case "save_primarygroup_details":
                    save_primarygroup_details(context);
                    break;
                case "get_primary_group":
                    get_primary_group(context);
                    break;
                case "get_primary_group_details":
                    get_primary_group_details(context);
                    break;
                case "save_financial_year":
                    save_financial_year(context);
                    break;
                case "get_financial_year":
                    get_financial_year(context);
                    break;
                case "save_voucherseries_click":
                    save_voucherseries_click(context);
                    break;
                case "get_voucher_series":
                    get_voucher_series(context);
                    break;
                case "save_month_master":
                    save_month_master(context);
                    break;
                case "get_month_master":
                    get_month_master(context);
                    break;
                case "get_group_ledger":
                    get_group_ledger(context);
                    break;
                case "save_group_ledger":
                    save_group_ledger(context);
                    break;
                case "save_reason_click":
                    save_reason_click(context);
                    break;
                case "get_reason_details":
                    get_reason_details(context);
                    break;
                case "save_norms_entry":
                    save_norms_entry(context);
                    break;
                case "get_suspensenorms_entry":
                    get_suspensenorms_entry(context);
                    break;
                case "save_cash_requisition":
                    save_cash_requisition(context);
                    break;
                case "get_suspensecash_requisition":
                    get_suspensecash_requisition(context);
                    break;
                case "get_available_amount":
                    get_available_amount(context);
                    break;
                case "get_suspense_billentry":
                    get_suspense_billentry(context);
                    break;
                case "update_suspensebill_click":
                    update_suspensebill_click(context);
                    break;
                case "get_suspensesub_details":
                    get_suspensesub_details(context);
                    break;
                case "save_subgroup_ledger":
                    save_subgroup_ledger(context);
                    break;
                case "get_subgroup_ledger":
                    get_subgroup_ledger(context);
                    break;
                case "save_designation_details":
                    save_designation_details(context);
                    break;
                case "get_designation_details":
                    get_designation_details(context);
                    break;
                case "savegroupdetailes":
                    savegroupdetailes(context);
                    break;
                case "get_glgroup_details":
                    get_glgroup_details(context);
                    break;
                case "save_party_type_details":
                    save_party_type_details(context);
                    break;
                case "get_party_type_details":
                    get_party_type_details(context);
                    break;
                case "get_party_type1_details":
                    get_party_type1_details(context);
                    break;
                case "save_tax_type_details":
                    save_tax_type_details(context);
                    break;
                case "get_tax_type_details":
                    get_tax_type_details(context);
                    break;
                case "get_tax_details":
                    get_tax_details(context);
                    break;
                case "get_voucher_no":
                    get_voucher_no(context);
                    break;
                case "get_account_code":
                    get_account_code(context);
                    break;
                case "get_cheque_status":
                    get_cheque_status(context);
                    break;
                 case "save_budget_code":
                    save_budget_code(context);
                    break;
                case "get_budget_details":
                    get_budget_details(context);
                    break;
                case "save_cost_center":
                    save_cost_center(context);
                    break;
                case "get_costcenter_details":
                    get_costcenter_details(context);
                    break;
                //sai

                case "get_party_typebg_details":
                    get_party_typebg_details(context);
                    break;

                case "get_party_typebank_details":
                    get_party_typebank_details(context);
                    break;

                case "get_chequeprinting_click":
                    get_chequeprinting_click(context);
                    break;

                case "get_partywisetds_click":
                    get_partywisetds_click(context);
                    break;

                case "save_post_datedcheques":
                    save_post_datedcheques(context);
                    break;

                case "get_post_datedcheques":
                    get_post_datedcheques(context);
                    break;

                case "save_fixedassets_group":
                    save_fixedassets_group(context);
                    break;

                case "get_fixedassets_group":
                    get_fixedassets_group(context);
                    break;

                case "save_natureof_work":
                    save_natureof_work(context);
                    break;

                case "get_depreciation_statement":
                    get_depreciation_statement(context);
                    break;

                case "get_natureof_work":
                    get_natureof_work(context);
                    break;

                case "get_fixed_assets":
                    get_fixed_assets(context);
                    break;

                case "save_cashadvance_requisition":
                    save_cashadvance_requisition(context);
                    break;

                case "get_cashadvance_requisition":
                    get_cashadvance_requisition(context);
                    break;

                case "save_cattlefeed_sales":
                    save_cattlefeed_sales(context);
                    break;

                case "get_cattlefeed_sales":
                    get_cattlefeed_sales(context);
                    break;

                case "get_miscellaneousbillentry_click":
                    get_miscellaneousbillentry_click(context);
                    break;

                case "updtae_approvalmiscellaneousbill_click":
                    updtae_approvalmiscellaneousbill_click(context);
                    break;

                case "get_appmiscellaneousbillentry_click":
                    get_appmiscellaneousbillentry_click(context);
                    break;

                case "save_passbookclosing_entry":
                    save_passbookclosing_entry(context);
                    break;

                case "get_passbookclosing_entry":
                    get_passbookclosing_entry(context);
                    break;

                case "get_openingbalance_entry":
                    get_openingbalance_entry(context);
                    break;

                case "get_profitandlossbalance_sheet":
                    get_profitandlossbalance_sheet(context);
                    break;

                case "save_bankpassbookunmatched_entry":
                    save_bankpassbookunmatched_entry(context);
                    break;

                    case "get_bankpassbookunmatched_entry":
                    get_bankpassbookunmatched_entry(context);
                    break;

                //veer

                case "get_trans_details":
                    get_trans_details(context);
                    break;

                case "get_trans_sub_details":
                    get_trans_sub_details(context);
                    break;

                case "get_code_det":
                    get_code_det(context);
                    break;

                case "get_creditnote_details":
                    get_creditnote_details(context);
                    break;

                case "get_creditnote_details1":
                    get_creditnote_details1(context);
                    break;
                case "get_party_master":
                    get_party_master(context);
                    break;

                case "get_partycode_det":
                    get_partycode_det(context);
                    break;

                case "get_post_cheque":
                    get_post_cheque(context);
                    break;

                case "get_match_unmatch_det":
                    get_match_unmatch_det(context);
                    break;
                     case "get_voucher_details":
                    get_voucher_details(context);
                    break;

                    case "get_invoice_details":
                    get_invoice_details(context);
                    break;

                     case "get_debitnote_details":
                    get_debitnote_details(context);
                    break;

                    case "get_debit_voucher_details":
                    get_debit_voucher_details(context);
                    break;

                    case "get_debitnote_details1":
                    get_debitnote_details1(context);
                    break;

                case "get_debit_invoice_details":
                    get_debit_invoice_details(context);
                    break;

                    case "save_tds_acknowledge_details":
                    save_tds_acknowledge_details(context);
                    break;

                case "get_tds_acknowledge_details":
                    get_tds_acknowledge_details(context);     
                    break;

                    case "save_accountmaster_click":
                    save_accountmaster_click(context);
                    break;

                    case "get_accountmaster_click":
                    get_accountmaster_click(context);
                    break;
                case "save_credit_entry_details":
                    save_credit_entry_details(context);
                    break;

                case "get_credit_entry_details":
                    get_credit_entry_details(context);
                    break;

                case "save_debit_entry_details":
                    save_debit_entry_details(context);
                    break;

                case "get_debit_entry_details":
                    get_debit_entry_details(context);
                    break;
                
                case "get_plant_names":
                    get_plant_names(context);
                    break;
                case "get_bill_dates":
                    get_bill_dates(context);
                    break;
                case "view_jvagent_details":
                    view_jvagent_details(context);
                    break;
                case "get_jvagent":
                    get_jvagent(context);
                    break;
                case "get_jv_details":
                    get_jv_details(context);
                    break;
                case "save_bank_Document_Info":
                    save_bank_Document_Info(context);
                    break;
                case "getbank_Uploaded_Documents":
                    getbank_Uploaded_Documents(context);
                    break;

                    //sai 

                case "get_employee_detail_login":
                    get_employee_detail_login(context);
                    break;
                case "btn_getlogininfoemployee_details":
                    btn_getlogininfoemployee_details(context);
                    break;

                default:

                    var jsonString = String.Empty;
                    context.Request.InputStream.Position = 0;
                    using (var inputStream = new StreamReader(context.Request.InputStream))
                    {
                        jsonString = HttpUtility.UrlDecode(inputStream.ReadToEnd());
                    }
                    if (jsonString != "")
                    {
                        var js = new JavaScriptSerializer();
                        GetJsonData obj = js.Deserialize<GetJsonData>(jsonString);
                        switch (obj.op)
                        {
                            case "save_paymententrys_click":
                                save_paymententrys_click(jsonString, context);
                                break;
                            //case "bank_files_upload":
                            //    bank_files_upload(jsonString, context);
                            //    break;
                        }
                    }
                    else
                    {
                        var js = new JavaScriptSerializer();
                        var title1 = context.Request.Params[1];
                        GetJsonData obj = js.Deserialize<GetJsonData>(title1);
                        switch (obj.op)
                        {
                            case "save_collections_click":
                                save_collections_click(context);
                                break;
                           
                            case "save_jounel_voucher_click":
                                save_jounel_voucher_click(context);
                                break;
                            case "save_SubHeadofAccount_click":
                                save_SubHeadofAccount_click(context);
                                break;
                            case "save_paymentsubentrys_click":
                                save_paymentsubentrys_click(context);
                                break;
                            case "save_tax_percent_details":
                                save_tax_percent_details(context);
                                break;
                            case "save_bg_click":
                                save_bg_click(context);
                                break;

                            case "save_Bank_Details":
                                save_Bank_Details(context);
                                break;

                            case "save_chequeprinting_click":
                                save_chequeprinting_click(context);
                                break;

                            case "save_partywisetds_click":
                                save_partywisetds_click(context);
                                break;

                            case "save_depreciation_statement":
                                save_depreciation_statement(context);
                                break;

                            case "save_fixed_assets":
                                save_fixed_assets(context);
                                break;

                            case "save_miscellaneousbillentry_click":
                                save_miscellaneousbillentry_click(context);
                                break;

                            case "save_openingbalance_entry":
                                save_openingbalance_entry(context);
                                break;

                            case "save_profitandlossbalance_sheet":
                                save_profitandlossbalance_sheet(context);
                                break;

                            case "save_voucher_details":
                                save_voucher_details(context);
                                break;
                            case "save_invoice_details":
                                save_invoice_details(context);
                                break;
                            case "save_party_master":
                                save_party_master(context);
                                break;
                            case "save_debit_voucher_details":
                                save_debit_voucher_details(context);
                                break;

                            case "save_debit_invoice_details":
                                save_debit_invoice_details(context);
                                break;
                            case "save_suspense_billentry":
                                save_suspense_billentry(context);
                                break;

                           
                        }
                    }
                    break;
            }
        }
        catch (Exception ex)
        {
            string response = GetJson(ex.ToString());
            context.Response.Write(response);
        }
    }
    private void saveBranchDetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string branchname = context.Request["branchname"];
            string statename = context.Request["statename"];
            string emailid = context.Request["emailid"];
            string Phone = context.Request["Phone"];
            string address = context.Request["address"];
            //string fromdate = context.Request["fromdate"];
            //string todate = context.Request["todate"];
            string type = context.Request["type"];
            //string nightallowance = context.Request["nightallowance"];
            string branchtype = context.Request["branchtype"];
            string CompanyName = context.Request["CompanyName"];
            string btnSave = context.Request["btnVal"];
            string code = context.Request["code"];
            //string bankcode = context.Request["bankcode"];
            string bankname = context.Request["bankname"];
            string pin = context.Request["pin"];
            string fax = context.Request["fax"];
            //string gl = context.Request["gl"];
            //string desc = context.Request["desc"];


            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into branchmaster (branchname,statename,emailid,phone,address,branchtype,company_code,code,bankid,pincode,fax) values (@branchname,@statename,@emailid,@phone,@address,@branchtype,@company_code,@code,@bankid,@pincode,@fax )");
                cmd.Parameters.Add("@branchname", branchname);
                cmd.Parameters.Add("@statename", statename);
                cmd.Parameters.Add("@emailid", emailid);
                cmd.Parameters.Add("@phone", Phone);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@branchtype", branchtype);
                cmd.Parameters.Add("@company_code", CompanyName);
                cmd.Parameters.Add("@code", code);
                //cmd.Parameters.Add("@bankcode", bankcode);
                cmd.Parameters.Add("@bankid", bankname);
                cmd.Parameters.Add("@pincode", pin);
                cmd.Parameters.Add("@fax", fax);
                //cmd.Parameters.Add("@gl", gl);
                //cmd.Parameters.Add("@desc", desc);
                vdm.insert(cmd);
                string Response = GetJson("Insert Successfull");
                context.Response.Write(Response);
            }
            else
            {
                string branchid = context.Request["branchid"];
                cmd = new SqlCommand("Update branchmaster set code=@code, company_code=@company_code, branchname=@branchname,statename=@statename,emailid=@emailid,phone=@phone,address=@address,branchtype=@branchtype,bankid=@bankid,pincode=@pincode,fax=@fax where branchid=@branchid ");
                cmd.Parameters.Add("@branchname", branchname);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@statename", statename);
                cmd.Parameters.Add("@emailid", emailid);
                cmd.Parameters.Add("@phone", Phone);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@branchtype", branchtype);
                cmd.Parameters.Add("@company_code", CompanyName);
                cmd.Parameters.Add("@code", code);
                //cmd.Parameters.Add("@bankcode", bankcode);
                cmd.Parameters.Add("@bankid", bankname);
                cmd.Parameters.Add("@pincode", pin);
                cmd.Parameters.Add("@fax", fax);
                //cmd.Parameters.Add("@gl", gl);
                //cmd.Parameters.Add("@desc", desc);
                vdm.Update(cmd);
                string response = GetJson("updated successfully");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_control_types(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string controltype = context.Request["controltype"];
            string description = context.Request["description"];
            string createdby = context.Session["UserSno"].ToString();
            string groupcode = context.Request["grid"];
            string glcode = context.Request["glid"];
            string departmentcode = context.Request["depid"];
            string name = context.Request["name"];
            string btnSave = context.Request["btnval"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into controltype (controltype,description,groupcode,glcode,deptcode,name,doe,createdby) values (@controltype,@description,@groupcode,@glcode,@deptcode,@name,@doe,@createdby)");
                cmd.Parameters.Add("@controltype", controltype);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@deptcode", departmentcode);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);
                string Response = GetJson("Insert Successfull");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"].ToString();
                cmd = new SqlCommand("Update controltype set controltype=@controltype, description=@description, groupcode=@groupcode,glcode=@glcode,deptcode=@deptcode,name=@name,doe=@doe,createdby=@createdby where sno=@sno ");
                cmd.Parameters.Add("@controltype", controltype);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@deptcode", departmentcode);
                cmd.Parameters.Add("@name", name);

                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("updated successfully");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class controltypes
    {
        public string controltype { get; set; }
        public string description { get; set; }
        public string groupcode { get; set; }
        public string glcode { get; set; }
        public string deptcode { get; set; }
        public string name { get; set; }
        public string sno { get; set; }
        public string groupid { get; set; }
        public string glid { get; set; }
        public string DepartmentCode { get; set; }
    }

    private void get_control_types(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT controltype.sno, controltype.controltype, controltype.description,controltype.glcode as glid,controltype.groupcode as groupid, controltype.deptcode, controltype.name, groupledgermaster.groupcode as glcode, primarygroup.shortdesc,primarygroup.groupcode,Departmentdetails.DepartmentName FROM controltype INNER JOIN primarygroup ON controltype.groupcode = primarygroup.sno INNER JOIN groupledgermaster ON controltype.glcode = groupledgermaster.sno INNER JOIN Departmentdetails ON controltype.deptcode = Departmentdetails.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<controltypes> EmployeDetalis = new List<controltypes>();
            foreach (DataRow dr in routes.Rows)
            {
                controltypes getbrcdetails = new controltypes();
                getbrcdetails.sno = dr["sno"].ToString();
                getbrcdetails.controltype = dr["controltype"].ToString();
                getbrcdetails.description = dr["description"].ToString();
                getbrcdetails.groupcode = dr["shortdesc"].ToString();
                getbrcdetails.groupid = dr["groupid"].ToString();
                getbrcdetails.glcode = dr["glcode"].ToString();
                getbrcdetails.glid = dr["glid"].ToString();
                getbrcdetails.deptcode = dr["deptcode"].ToString();
                getbrcdetails.DepartmentCode = dr["DepartmentName"].ToString();
                getbrcdetails.name = dr["name"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_Transaction_SubTypes(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string transtype = context.Request["transid"];
            string subtype = context.Request["subtype"];
            string createdby = context.Session["UserSno"].ToString();
            string description = context.Request["description"];
            string glcode = context.Request["glid"];
            string btnsave = context.Request["btnsave"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btnsave == "save")
            {
                cmd = new SqlCommand("insert into transactionsubtypes (transactiontype,subtype,description,glcode,doe,createdby) values (@transactiontype,@subtype,@description,@glcode,@doe,@createdby)");
                cmd.Parameters.Add("@transactiontype", transtype);
                cmd.Parameters.Add("@subtype", subtype);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
               vdm.insert(cmd);
                string Response = GetJson("Insert Successfull");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"].ToString();
                cmd = new SqlCommand("Update transactionsubtypes set transactiontype=@transactiontype, subtype=@subtype, description=@description,glcode=@glcode,doe=@doe,createdby=@createdby where sno=@sno ");
                cmd.Parameters.Add("@transactiontype", transtype);
                cmd.Parameters.Add("@subtype", subtype);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("updated successfully");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class transsub
    {
        public string subtype { get; set; }
        public string description { get; set; }
        public string transactiontype { get; set; }
        public string glcode { get; set; }
        public string short_desc { get; set; }
        public string sno { get; set; }
        public string transactionid { get; set; }
        public string glid { get; set; }
    }
    private void get_transsub_type(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT transactionsubtypes.sno, transactionsubtypes.transactiontype, transactionsubtypes.subtype, transactionsubtypes.description, transactionsubtypes.glcode, transactiontype.transactiontype AS transactionid, groupledgermaster.groupshortdesc, groupledgermaster.groupcode FROM transactionsubtypes INNER JOIN transactiontype ON transactionsubtypes.transactiontype = transactiontype.sno INNER JOIN groupledgermaster ON transactionsubtypes.glcode = groupledgermaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<transsub> ledgerlist = new List<transsub>();
            foreach (DataRow dr in routes.Rows)
            {
                transsub getgroupledger = new transsub();
                getgroupledger.subtype = dr["subtype"].ToString();
                getgroupledger.description = dr["description"].ToString();
                getgroupledger.transactiontype = dr["transactiontype"].ToString();
                getgroupledger.transactionid = dr["transactionid"].ToString();
                getgroupledger.glcode = dr["glcode"].ToString();
                getgroupledger.glid = dr["groupcode"].ToString();
                getgroupledger.short_desc = dr["groupshortdesc"].ToString();
                getgroupledger.sno = dr["sno"].ToString();
                ledgerlist.Add(getgroupledger);
            }
            string response = GetJson(ledgerlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class BranchDetalis
    {
        public string branchname { get; set; }
        public string branchid { get; set; }
        public string statename { get; set; }
        public string emailid { get; set; }
        public string Phone { get; set; }
        public string address { get; set; }
        public string branchtype { get; set; }
        public string company_code { get; set; }
        public string companyname { get; set; }
        public string btnVal { get; set; }
        public string code { get; set; }
        public string pincode { get; set; }
        public string fax { get; set; }

    }
    private void get_Branch_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT branchmaster.code, branchmaster.branchname, branchmaster.company_code,branchmaster.branchid, branchmaster.statename, branchmaster.emailid, branchmaster.phone, branchmaster.address,   branchmaster.branchtype,branchmaster.pincode,branchmaster.fax,  company_master.companyname FROM  branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno ORDER BY branchmaster.branchname");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BranchDetalis> EmployeDetalis = new List<BranchDetalis>();
            foreach (DataRow dr in routes.Rows)
            {
                BranchDetalis getbrcdetails = new BranchDetalis();
                getbrcdetails.branchname = dr["branchname"].ToString();
                getbrcdetails.companyname = dr["companyname"].ToString();
                getbrcdetails.company_code = dr["company_code"].ToString();
                getbrcdetails.branchid = dr["branchid"].ToString();
                getbrcdetails.statename = dr["statename"].ToString();
                getbrcdetails.emailid = dr["emailid"].ToString();
                getbrcdetails.Phone = dr["phone"].ToString();
                getbrcdetails.address = dr["address"].ToString();
                getbrcdetails.branchtype = dr["branchtype"].ToString();
                getbrcdetails.code = dr["code"].ToString();
                getbrcdetails.pincode = dr["pincode"].ToString();
                getbrcdetails.fax = dr["fax"].ToString();
                getbrcdetails.branchid = dr["branchid"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class CompanyMaster
    {
        public string CompanyCode { get; set; }
        public string CompanyName { get; set; }
        public string Add { get; set; }
        public string PhoneNo { get; set; }
        public string mailId { get; set; }
        public string TINNo { get; set; }
    }
    private void get_CompanyMaster_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,companyname,address,phoneno,mailid,tinno FROM company_master");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<CompanyMaster> companyMasterlist = new List<CompanyMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                CompanyMaster getcompanydetails = new CompanyMaster();
                getcompanydetails.CompanyCode = dr["sno"].ToString();
                getcompanydetails.CompanyName = dr["companyname"].ToString();
                getcompanydetails.Add = dr["address"].ToString();
                getcompanydetails.PhoneNo = dr["phoneno"].ToString();
                getcompanydetails.mailId = dr["mailid"].ToString();
                getcompanydetails.TINNo = dr["tinno"].ToString();
                companyMasterlist.Add(getcompanydetails);
            }
            string response = GetJson(companyMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void saveCompanyMasterdetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string CompanyName = context.Request["CompanyName"];
            string Add = context.Request["Add"];
            string PhoneNo = context.Request["PhoneNo"];
            string mailId = context.Request["mailId"];
            string TINNo = context.Request["TINNo"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into company_master (companyname,address,phoneno,mailid,tinno) values (@company_name,@address,@phoneno,@mailid,@tinno)");
                cmd.Parameters.Add("@company_name", CompanyName);
                cmd.Parameters.Add("@address", Add);
                cmd.Parameters.Add("@phoneno", PhoneNo);
                cmd.Parameters.Add("@tinno", TINNo);
                cmd.Parameters.Add("@mailid", mailId);
                vdm.insert(cmd);
                string msg = "Company detailes successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string CompanyCode = context.Request["CompanyCode"];
                cmd = new SqlCommand("Update company_master set companyname=@company_name,address=@address,phoneno=@phoneno,mailid=@mailid,tinno=@tinno where sno=@company_code");
                cmd.Parameters.Add("@company_name", CompanyName);
                cmd.Parameters.Add("@address", Add);
                cmd.Parameters.Add("@phoneno", PhoneNo);
                cmd.Parameters.Add("@tinno", TINNo);
                cmd.Parameters.Add("@mailid", mailId);
                cmd.Parameters.Add("@company_code", CompanyCode);
                vdm.Update(cmd);
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class SubPaybleValues
    {
        public string accountname { get; set; }
        public string amount { get; set; }
    }
    private void GetSubPaybleValues(HttpContext context)
    {
        try
        {
            string VoucherID = context.Request["VoucherID"];
            cmd = new SqlCommand("SELECT headofaccounts_master.accountname, paymentsubdetails.amount FROM paymentsubdetails INNER JOIN headofaccounts_master ON paymentsubdetails.headofaccount = headofaccounts_master.sno WHERE (paymentsubdetails.paymentrefno = @Refno)");
            cmd.Parameters.Add("@Refno", VoucherID);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<SubPaybleValues> bankMasterlist = new List<SubPaybleValues>();
            foreach (DataRow dr in routes.Rows)
            {
                SubPaybleValues getbankdetails = new SubPaybleValues();
                getbankdetails.accountname = dr["accountname"].ToString();
                getbankdetails.amount = dr["amount"].ToString();
                bankMasterlist.Add(getbankdetails);
            }
            string response = GetJson(bankMasterlist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void btnPaymentPrintClick(HttpContext context)
    {
        try
        {
            context.Session["VoucherID"] = context.Request["voucherno"];
            string msg = "Success";
            string response = GetJson(msg);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }
    private void btnReceiptPrintClick(HttpContext context)
    {
        try
        {
            context.Session["ReceiptNo"] = context.Request["Receiptno"];
            string msg = "Success";
            string response = GetJson(msg);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }
    private static string GetJson(object obj)
    {
        JavaScriptSerializer jsonserializer = new JavaScriptSerializer();
        jsonserializer.MaxJsonLength = 2147483647;
        return jsonserializer.Serialize(obj);
    }

    private static object GetUnJson(string obj)
    {
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        return jsonSerializer.Deserialize(obj, Type.GetType("System.Object"));
    }

    public class empdetails
    {
        public string username { get; set; }
        public string sno { get; set; }
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

    public void save_bank_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string BankName = context.Request["BankName"];
            string bankcode = context.Request["bankcode"];
            string status = context.Request["status"];
            string cashbookcode = context.Request["cashbookcode"];
            string UserName = context.Session["UserSno"].ToString();
            string btn_save = context.Request["btnVal"];
            if (btn_save == "save")
            {
                cmd = new SqlCommand("insert into bankmaster (bankname, code, status, doe, createdby,cashbookcode) values (@bankname, @bankcode, @status, @doe, @createdby, @cashbookcode)");
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@bankname", BankName);
                cmd.Parameters.Add("@bankcode", bankcode);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@cashbookcode", cashbookcode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Detailes successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update bankmaster set bankname=@bankname, code=@code, status=@status, doe=@doe , cashbookcode=@cashbookcode where sno=@sno");
                cmd.Parameters.Add("@bankname", BankName);
                cmd.Parameters.Add("@code", bankcode);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@cashbookcode", cashbookcode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class bankdetailes
    {
        public string code { get; set; }
        public string name { get; set; }
        public string sno { get; set; }
        public string amount { get; set; }
        public string bankname { get; set; }
        public List<banksubdetails> bankamountdetails { get; set; }
    }
    public class banksubdetails
    {
        public string bankid { get; set; }
        public string amount { get; set; }
    }

    private void get_bank_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,bankname,code FROM bankmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<bankdetailes> bankMasterlist = new List<bankdetailes>();
            foreach (DataRow dr in routes.Rows)
            {
                bankdetailes getbankdetails = new bankdetailes();
                getbankdetails.name = dr["bankname"].ToString();
                getbankdetails.code = dr["code"].ToString();
                getbankdetails.sno = dr["sno"].ToString();
                bankMasterlist.Add(getbankdetails);
            }
            string response = GetJson(bankMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class bankaccmasterdetails
    {
        public string bankname { get; set; }
        public string branchcode { get; set; }
        public string AccountNumber { get; set; }
        public string Accounttype { get; set; }
        public string Ifsccode { get; set; }
        public string Status { get; set; }
        public string bank_id { get; set; }

    }
    public void save_BankAccount_Details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);

            string BankName = context.Request["BankName"];
            string BranchName = context.Request["BranchName"];
            string IFSCCode = context.Request["IFSCCode"];
            string AccountNumber = context.Request["AccountNumber"];
            string Accounttype = context.Request["Accounttype"];
            string Status = context.Request["Status"];
            string btn_save = context.Request["btnVal"];
            string UserName = context.Session["UserSno"].ToString();
            string ledgercode = context.Request["ledgercode"];
            string ledgername = context.Request["ledgername"];
            string barcnhledgercode = context.Request["barcnhledgercode"];
            string branchledgername = context.Request["branchledgername"];

            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into bankaccountno_master (bankid,ifscid,branchname,accountno,accounttype,status,doe,ladger_dr,brach_ledger,ladger_dr_code,brach_ledger_code) values (@bankid,@ifscid,@branchname,@accountno,@accounttype,@status,@doe,@ladger_dr,@brach_ledger,@ladger_dr_code,@brach_ledger_code)");
                cmd.Parameters.Add("@bankid", BankName);
                cmd.Parameters.Add("@branchname", BranchName);
                cmd.Parameters.Add("@ifscid", IFSCCode);
                cmd.Parameters.Add("@accountno", AccountNumber);
                cmd.Parameters.Add("@accounttype", Accounttype);
                cmd.Parameters.Add("@status", Status);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@ladger_dr", ledgername);
                cmd.Parameters.Add("@brach_ledger", branchledgername);
                cmd.Parameters.Add("@ladger_dr_code", ledgercode);
                cmd.Parameters.Add("@brach_ledger_code", barcnhledgercode);
                vdm.insert(cmd);
                string msg = "Detailes successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update bankaccountno_master set ladger_dr=@ladger_dr,brach_ledger=@brach_ledger,ladger_dr_code=@ladger_dr_code,brach_ledger_code=@brach_ledger_code, bankid=@bankid, ifscid=@ifscid,branchname=@branchname,accountno=@accountno,accounttype=@accounttype, status=@status, doe=@doe where sno=@sno");
                cmd.Parameters.Add("@bankid", BankName);
                cmd.Parameters.Add("@branchname", BranchName);
                cmd.Parameters.Add("@ifscid", IFSCCode);
                cmd.Parameters.Add("@accountno", AccountNumber);
                cmd.Parameters.Add("@accounttype", Accounttype);
                cmd.Parameters.Add("@status", Status);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@ladger_dr", ledgername);
                cmd.Parameters.Add("@brach_ledger", branchledgername);
                cmd.Parameters.Add("@ladger_dr_code", ledgercode);
                cmd.Parameters.Add("@brach_ledger_code", barcnhledgercode);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class bankaccdetails
    {
        public string bankname { get; set; }
        public string amount { get; set; }
        public string accountno { get; set; }
        public string branchcode { get; set; }
        public string AccountNumber { get; set; }
        public string Accounttype { get; set; }
        public string Ifsccode { get; set; }
        public string Status { get; set; }
        public string bankid { get; set; }
        public string ifscid { get; set; }
        public string branchid { get; set; }
        public string ledgercode { get; set; }
        public string ledgername { get; set; }
        public string barcnhledgercode { get; set; }
        public string branchledgername { get; set; }
        public string sno { get; set; }
        public List<bankaccsubdetails> Accountdetails { get; set; }
    }

    public class bankaccsubdetails
    {
        public string accountid { get; set; }
        public string amount { get; set; }
    }

    private void get_bankaccount_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT bankaccountno_master.ladger_dr,bankaccountno_master.brach_ledger,bankaccountno_master.ladger_dr_code,bankaccountno_master.brach_ledger_code, bankaccountno_master.branchname, bankmaster.bankname, bankaccountno_master.ifscid, bankaccountno_master.bankid, bankaccountno_master.sno, bankaccountno_master.accountno, bankaccountno_master.accounttype, ifscmaster.ifsccode FROM  bankaccountno_master INNER JOIN  bankmaster ON bankaccountno_master.bankid = bankmaster.sno INNER JOIN  ifscmaster ON bankaccountno_master.ifscid = ifscmaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<bankaccdetails> bankaccMasterlist = new List<bankaccdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                bankaccdetails getbankaccdetails = new bankaccdetails();
                getbankaccdetails.bankname = dr["bankname"].ToString();
                getbankaccdetails.bankid = dr["bankid"].ToString();
                getbankaccdetails.branchcode = dr["branchname"].ToString();
                getbankaccdetails.AccountNumber = dr["accountno"].ToString();
                getbankaccdetails.Accounttype = dr["accounttype"].ToString();
                getbankaccdetails.Ifsccode = dr["ifsccode"].ToString();
                getbankaccdetails.ifscid = dr["ifscid"].ToString();
                getbankaccdetails.branchid = dr["ifscid"].ToString();
                getbankaccdetails.ledgername = dr["ladger_dr"].ToString();
                getbankaccdetails.branchledgername = dr["brach_ledger"].ToString();
                getbankaccdetails.ledgercode = dr["ladger_dr_code"].ToString();
                getbankaccdetails.barcnhledgercode = dr["brach_ledger_code"].ToString();
                getbankaccdetails.sno = dr["sno"].ToString();
                bankaccMasterlist.Add(getbankaccdetails);
            }
            string response = GetJson(bankaccMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class BankIfscMaster
    {
        public string branchname { get; set; }
        public string bankname { get; set; }
        public string Ifsccode { get; set; }
        public string bank_id { get; set; }
        public string sno { get; set; }
        public string status { get; set; }
    }

    private void get_bankifsc_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT im.sno, im.bankid, bm.bankname, im.branchname, im.ifsccode, im.status FROM ifscmaster im INNER JOIN bankmaster bm ON bm.sno=im.bankid");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BankIfscMaster> BankIfscMasterlist = new List<BankIfscMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                BankIfscMaster BankIfscMasterdetails = new BankIfscMaster();
                BankIfscMasterdetails.branchname = dr["branchname"].ToString();
                BankIfscMasterdetails.bank_id = dr["bankid"].ToString();
                BankIfscMasterdetails.Ifsccode = dr["ifsccode"].ToString();
                BankIfscMasterdetails.bankname = dr["bankname"].ToString();
                BankIfscMasterdetails.status = dr["status"].ToString();
                BankIfscMasterdetails.sno = dr["sno"].ToString();
                BankIfscMasterlist.Add(BankIfscMasterdetails);
            }
            string response = GetJson(BankIfscMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_bankwiseifsc_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string bankid = context.Request["bankid"];
            cmd = new SqlCommand("SELECT im.sno, im.bankid, bm.bankname, im.branchname, im.ifsccode, im.status FROM ifscmaster im INNER JOIN bankmaster bm ON bm.sno=im.bankid WHERE im.bankid=@bankid");
            cmd.Parameters.Add("@bankid", bankid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BankIfscMaster> BankIfscMasterlist = new List<BankIfscMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                BankIfscMaster BankIfscMasterdetails = new BankIfscMaster();
                BankIfscMasterdetails.branchname = dr["branchname"].ToString();
                BankIfscMasterdetails.bank_id = dr["bankid"].ToString();
                BankIfscMasterdetails.Ifsccode = dr["ifsccode"].ToString();
                BankIfscMasterdetails.bankname = dr["bankname"].ToString();
                BankIfscMasterdetails.status = dr["status"].ToString();
                BankIfscMasterdetails.sno = dr["sno"].ToString();
                BankIfscMasterlist.Add(BankIfscMasterdetails);
            }
            string response = GetJson(BankIfscMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_ifscwisebranch_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string ifscid = context.Request["ifscid"];
            cmd = new SqlCommand("SELECT sno, bankid, branchname, ifsccode, status FROM ifscmaster WHERE sno=@ifscid");
            cmd.Parameters.Add("@ifscid", ifscid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BankIfscMaster> BankIfscMasterlist = new List<BankIfscMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                BankIfscMaster BankIfscMasterdetails = new BankIfscMaster();
                BankIfscMasterdetails.branchname = dr["branchname"].ToString();
                BankIfscMasterdetails.sno = dr["sno"].ToString();
                BankIfscMasterlist.Add(BankIfscMasterdetails);
            }
            string response = GetJson(BankIfscMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_branchwiseifsc_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string branchid = context.Request["branchid"];
            cmd = new SqlCommand("SELECT sno, bankid, branchname, ifsccode, status FROM ifscmaster WHERE sno=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BankIfscMaster> BankIfscMasterlist = new List<BankIfscMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                BankIfscMaster BankIfscMasterdetails = new BankIfscMaster();
                BankIfscMasterdetails.Ifsccode = dr["ifsccode"].ToString();
                BankIfscMasterdetails.sno = dr["sno"].ToString();
                BankIfscMasterlist.Add(BankIfscMasterdetails);
            }
            string response = GetJson(BankIfscMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    public class IfscMaster
    {
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public string IFSCCode { get; set; }

    }

    public void save_BankIfsc_Details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string BankName = context.Request["BankName"];
            string BranchName = context.Request["BranchName"];
            string IFSCCode = context.Request["IFSCCode"];
            string status = context.Request["status"];
            string UserName = context.Session["UserSno"].ToString();
            string btn_save = context.Request["btnVal"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into ifscmaster (bankid, ifsccode, branchname, doe, status, createdby ) values (@bankid, @ifsccode, @branchname, @doe, @status, @createdby)");
                cmd.Parameters.Add("@bankid", BankName);
                cmd.Parameters.Add("@branchname", BranchName);
                cmd.Parameters.Add("@ifsccode", IFSCCode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                string msg = "Detailes successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update ifscmaster set bankid=@bankid, ifsccode=@ifsccode, branchname=@branchname, doe=@doe, status=@status where sno=@sno");
                cmd.Parameters.Add("@bankid", BankName);
                cmd.Parameters.Add("@branchname", BranchName);
                cmd.Parameters.Add("@ifsccode", IFSCCode);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class headofaccountMaster
    {
        public string AccountName { get; set; }
        public string Limit { get; set; }
    }

    public void saveheadofaccountsDetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string AccountName = context.Request["AccountName"];
            string Accountcode = context.Request["Accountcode"];
            string Limit = context.Request["Limit"];
            string primarygroup = context.Request["primarygroup"];
            string groupledger = context.Request["groupledger"];
            string subgroupledger = context.Request["subgroupledger"];
            string btn_save = context.Request["btnval"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);

            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into headofaccounts_master (accountname,limit,primarygroupid,groupledgerid,subgroupledgerid,accountcode,doe) values (@accountname,@limit,@primarygroupid,@groupledgerid,@subgroupledgerid,@accountcode,@doe)");
                cmd.Parameters.Add("@accountname", AccountName);
                cmd.Parameters.Add("@limit", Limit);
                cmd.Parameters.Add("@primarygroupid", primarygroup);
                cmd.Parameters.Add("@groupledgerid", groupledger);
                cmd.Parameters.Add("@subgroupledgerid", subgroupledger);
                cmd.Parameters.Add("@accountcode", Accountcode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Detailes successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                    string sno = context.Request["sno"];
                    cmd = new SqlCommand("Update headofaccounts_master set accountname=@accountname,limit=@limit,primarygroupid=@primarygroupid,groupledgerid=@groupledgerid,subgroupledgerid=@subgroupledgerid,accountcode=@accountcode,doe=@doe where sno=@sno");
                    cmd.Parameters.Add("@accountname", AccountName);
                    cmd.Parameters.Add("@limit", Limit);
                    cmd.Parameters.Add("@primarygroupid", primarygroup);
                    cmd.Parameters.Add("@groupledgerid", groupledger);
                    cmd.Parameters.Add("@subgroupledgerid", subgroupledger);
                    cmd.Parameters.Add("@accountcode", Accountcode);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", sno);
                    vdm.Update(cmd);
              
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class HeadOfAccountMaster
    {
        public string AccountName { get; set; }
        public string Limit { get; set; }
        public string accountcode { get; set; }
        public string sno { get; set; }
        public string primarygroupid { get; set; }
        public string groupledgerid { get; set; }
        public string subgroupledger { get; set; }
    }

    private void get_headofaccount_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,accountname,accountcode,limit, primarygroupid, groupledgerid, subgroupledgerid FROM headofaccounts_master");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<HeadOfAccountMaster> headofaccountMasterlist = new List<HeadOfAccountMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                HeadOfAccountMaster getheadofaccountdetails = new HeadOfAccountMaster();
                getheadofaccountdetails.AccountName = dr["accountname"].ToString();
                getheadofaccountdetails.accountcode = dr["accountcode"].ToString();
                getheadofaccountdetails.Limit = dr["limit"].ToString();
                getheadofaccountdetails.sno = dr["sno"].ToString();
                getheadofaccountdetails.primarygroupid = dr["primarygroupid"].ToString();
                getheadofaccountdetails.groupledgerid = dr["groupledgerid"].ToString();
                getheadofaccountdetails.subgroupledger = dr["subgroupledgerid"].ToString();
                headofaccountMasterlist.Add(getheadofaccountdetails);
            }
            string response = GetJson(headofaccountMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_primarywise_groupledger(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
           // string pgroup = context.Request["pgroup"];
            cmd = new SqlCommand("SELECT sno, primarygroupcode, groupcode,groupshortdesc,grouplongdesc,subgroupcode,schedule,orders,addless from groupledgermaster");
            //cmd.Parameters.Add("@primary", pgroup);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<groupledger> primarylist = new List<groupledger>();
            if (primarylist != null)
            {
                foreach (DataRow dr in routes.Rows)
                {
                    groupledger pgledgerdetails = new groupledger();
                    pgledgerdetails.groupledgercode = dr["groupshortdesc"].ToString();
                    pgledgerdetails.sno = dr["sno"].ToString();
                    primarylist.Add(pgledgerdetails);
                }
            }
            else
            {
            }
            string response = GetJson(primarylist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    public class CollectionMaster
    {
        public string Name { get; set; }
        public string accountno { get; set; }
        public string refno { get; set; }
        public string headid { get; set; }
        public string accountid { get; set; }
        public string totalamount { get; set; }
        public string UserName { get; set; }
        public string btnval { get; set; }
        public string Remarks { get; set; }
        public string ApprovedBy { get; set; }
        public string doe { get; set; }
        public string accounttype { get; set; }
        public string receiptdate { get; set; }
        public string sno { get; set; }
        public List<Collectionsubdetails> colleciondetails { get; set; }
        public List<Collectionsubdetails> subcollectionentry { get; set; }
        public string branch { get; set; }
        public string sapimport { get; set; }
        public string subbranch { get; set; }
        public string totalamountsub { get; set; }
    }

    public class Collectionsubdetails
    {
        public string SNo { get; set; }
        public string Account { get; set; }
        public string amount { get; set; }
        public string subsno { get; set; }
    }

    public class Collections
    {
        public string Name { get; set; }
        public string accountno { get; set; }
        public string refno { get; set; }
        public string headid { get; set; }
        public string accountid { get; set; }
        public string totalamount { get; set; }
        public string UserName { get; set; }
        public string btnval { get; set; }
        public string Remarks { get; set; }
        public string ApprovedBy { get; set; }
        public string doe { get; set; }
        public string accounttype { get; set; }
        public string sno { get; set; }
        public string remarks { get; set; }

        public string subbranchname { get; set; }

        public string branchname { get; set; }

        public string subbranchid { get; set; }

        public string branchid { get; set; }

        public string sapimport { get; set; }

        public string receiptdate { get; set; }

        public string totalsubamount { get; set; }
    }

    public class Collectiondetails
    {
        public string SNo { get; set; }
        public string Account { get; set; }
        public string amount { get; set; }
        public string subsno { get; set; }
    }

    private void save_collections_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            CollectionMaster obj = js.Deserialize<CollectionMaster>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string name = obj.Name;
            string accountno = obj.accountno;
            string totalamount = obj.totalamount;
            string Remarks = obj.Remarks;
            string strdate = obj.receiptdate;
            DateTime dtreceipt = Convert.ToDateTime(strdate);
            // string ApprovedBy = obj.ApprovedBy;
            string branch = obj.branch;
            string sapimport = obj.sapimport;
            string subbranch = obj.subbranch;
            string totalamountsub = obj.totalamountsub;

            string btn_save = obj.btnval;
            string sno = obj.sno;
            cmd = new SqlCommand("SELECT sno, accountid, amount, closedby, doe FROM accountnowiseclosingdetails WHERE (doe BETWEEN @d1 AND @d2) AND (accountid = @accountid)");
            cmd.Parameters.Add("@accountid", accountno);
            cmd.Parameters.Add("@d1", GetLowDate(dtreceipt));
            cmd.Parameters.Add("@d2", GetHighDate(dtreceipt));
            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
            //if (dtroutes.Rows.Count > 0)
            //{
            //    cmd = new SqlCommand("UPDATE collections SET name=@name  WHERE sno=@sno");
            //    cmd.Parameters.Add("@name", name);
            //    cmd.Parameters.Add("@sno", sno);
            //    vdm.Update(cmd);
            //    string msg = "This account no closed & name updated successfully";
            //    string Response = GetJson(msg);
            //    context.Response.Write(Response);
            //}
            //else
            //{
                if (btn_save == "Save")
                {
                    cmd = new SqlCommand("insert into collections (name, accountno, amount, remarks,sub_amount,sapimport,branch,subbranch, doe, createdby, status,receiptdate) values (@name, @accountno, @amount, @remarks,@sub_amount,@sapimport,@branch,@subbranch, @doe, @createdby, 'P',@receiptdate)");
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@accountno", accountno);
                    cmd.Parameters.Add("@amount", totalamount);
                    cmd.Parameters.Add("@remarks", Remarks);
                    cmd.Parameters.Add("@branch", branch);
                    cmd.Parameters.Add("@subbranch", subbranch);
                    cmd.Parameters.Add("@sub_amount", totalamountsub);
                    cmd.Parameters.Add("@sapimport", sapimport);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@receiptdate", dtreceipt);
                    cmd.Parameters.Add("@createdby", UserName);
                    vdm.insert(cmd);
                    cmd = new SqlCommand("Select max(sno) as sno From collections");
                    DataTable dtcollection = vdm.SelectQuery(cmd).Tables[0];
                    string refsno = dtcollection.Rows[0]["sno"].ToString();
                    foreach (Collectionsubdetails si in obj.colleciondetails)
                    {
                        cmd = new SqlCommand("insert into collectionsubdetails (collectionrefno, headofaccount, amount) values (@refno, @headaccount, @amount)");
                        cmd.Parameters.Add("@refno", refsno);
                        cmd.Parameters.Add("@headaccount", si.SNo);
                        cmd.Parameters.Add("@amount", si.amount);
                        vdm.insert(cmd);
                    }
                    foreach (Collectionsubdetails se in obj.subcollectionentry)
                    {
                        cmd = new SqlCommand("insert into subaccount_collection (collectionrefno, headofaccount, amount) values (@refno, @headofaccount, @amount)");
                        cmd.Parameters.Add("@refno", refsno);
                        cmd.Parameters.Add("@headofaccount", se.SNo);
                        cmd.Parameters.Add("@amount", se.amount);
                        vdm.insert(cmd);
                    }
                    string msg = "successfully Inserted";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
                else
                {
                    cmd = new SqlCommand("UPDATE collections SET name=@name, accountno=@accountno, amount=@amount, remarks=@remarks, createdby=@createdby,sub_amount=@sub_amount,sapimport=@sapimport,branch=@branch,subbranch=@subbranch,modifieddate=@modifieddate,modifiedby=@modifiedby WHERE sno=@sno");
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@accountno", accountno);
                    cmd.Parameters.Add("@amount", totalamount);
                    cmd.Parameters.Add("@remarks", Remarks);
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@sub_amount", totalamountsub);
                    cmd.Parameters.Add("@sapimport",sapimport);
                    cmd.Parameters.Add("@branch", branch);
                    cmd.Parameters.Add("@subbranch", subbranch);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@modifieddate", ServerDateCurrentdate);
                    cmd.Parameters.Add("@modifiedby", UserName);
                    vdm.Update(cmd);
                    cmd = new SqlCommand("delete from collectionsubdetails where collectionrefno=@Refno");
                    cmd.Parameters.Add("@refno", sno);
                    vdm.Delete(cmd);
                    foreach (Collectionsubdetails si in obj.colleciondetails)
                    {
                        cmd = new SqlCommand("insert into collectionsubdetails (collectionrefno, headofaccount, amount) values (@refno, @headaccount, @amount)");
                        cmd.Parameters.Add("@refno", sno);
                        cmd.Parameters.Add("@headaccount", si.SNo);
                        cmd.Parameters.Add("@amount", si.amount);
                        vdm.insert(cmd);
                    }
                    cmd = new SqlCommand("delete from subaccount_collection where collectionrefno=@Refno");
                    cmd.Parameters.Add("@refno", sno);
                    vdm.Delete(cmd);
                    foreach (Collectionsubdetails se in obj.subcollectionentry)
                    {
                        cmd = new SqlCommand("insert into subaccount_collection (collectionrefno, headofaccount, amount) values (@refno, @headofaccount, @amount)");
                        cmd.Parameters.Add("@refno", sno);
                        cmd.Parameters.Add("@headofaccount", se.SNo);
                        cmd.Parameters.Add("@amount", se.amount);
                        vdm.insert(cmd);
                    }
                    string msg = "updated successfully";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
           // }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class paymentdetails
    {
        public string sno { get; set; }
        public string accounttype { get; set; }
        public string status { get; set; }
        public string name { get; set; }
        public string accountno { get; set; }
        public string accountid { get; set; }
        public string totalamount { get; set; }
        public string Remarks { get; set; }
        public string UserName { get; set; }
        public string doe { get; set; }
        public string approvedby { get; set; }
        public string btnval { get; set; }
        public string debitname { get; set; }
        public string headofaccount { get; set; }
        public string headid { get; set; }
        public string refno { get; set; }
        public string paymentdate { get; set; }
        public string branchname { get; set; }
        public string branchid { get; set; }
        public string jvdate { get; set; }
        public List<paymentsubdetails> paymententry { get; set; }
        public List<paymentsubdetails> subpaymententry { get; set; }

        public string sapimport { get; set; }

        public string subbranch { get; set; }

        public string subheadofaccount { get; set; }

        public string totalamountsub { get; set; }

        public string branch { get; set; }

        public string subbranchid { get; set; }

        public string totalsubamount { get; set; }
    }

    public class paymentsubdetails
    {

        public string Account { get; set; }
        public string amount { get; set; }
        public string SNo { get; set; }

    }
    private void save_jounel_voucher_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            paymentdetails obj = js.Deserialize<paymentdetails>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string branchid = obj.branchid;
            string sno = obj.sno;
            string totalamount = obj.totalamount;
            if (totalamount == null)
            {
                totalamount = "0";
            }
            string Remarks = obj.Remarks;
            string btn_save = obj.btnval;
            string strdate = obj.jvdate;
            DateTime jvdate = Convert.ToDateTime(strdate);
            //string debitname = obj.debitname;
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into journel_entry (branchid,amount,remarks,doe,createdby,status,jvdate) values (@branchid,@amount,@remarks,@doe,@createdby,'P',@jvdate)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@amount", totalamount);
                cmd.Parameters.Add("@remarks", Remarks);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@jvdate", jvdate);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from journel_entry ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string paymentrefno = routes.Rows[0]["sno"].ToString();
                foreach (paymentsubdetails si in obj.paymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into subjournel_entry (refno, headofaccount, amount) values (@refno, @headofaccount, @amount)");
                    cmd.Parameters.Add("@refno", paymentrefno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    vdm.insert(cmd);
                }
                foreach (paymentsubdetails si in obj.subpaymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into subjournel_credit_entry (refno, headofaccount, amount) values (@refno, @headofaccount, @amount)");
                    cmd.Parameters.Add("@refno", paymentrefno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("UPDATE journel_entry SET branchid=@branchid,amount=@amount,remarks=@remarks, status=@status,jvdate=@jvdate WHERE sno=@sno");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@amount", totalamount);
                cmd.Parameters.Add("@remarks", Remarks);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@status", 'P');
                cmd.Parameters.Add("@jvdate", jvdate);
                vdm.Update(cmd);
                cmd = new SqlCommand("delete from subjournel_entry where refno=@Refno");
                cmd.Parameters.Add("@Refno", sno);
                vdm.Delete(cmd);
                cmd = new SqlCommand("delete from subjournel_credit_entry where refno=@Refno");
                cmd.Parameters.Add("@Refno", sno);
                vdm.Delete(cmd);
                foreach (paymentsubdetails si in obj.paymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into subjournel_entry (refno, headofaccount, amount) values (@refno, @headofaccount, @amount)");
                    cmd.Parameters.Add("@refno", sno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    vdm.insert(cmd);
                }
                foreach (paymentsubdetails si in obj.subpaymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into subjournel_credit_entry (refno, headofaccount, amount) values (@refno, @headofaccount, @amount)");
                    cmd.Parameters.Add("@refno", sno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    vdm.insert(cmd);
                }
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void save_paymententrys_click(string jsonString, HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            paymentdetails obj = js.Deserialize<paymentdetails>(jsonString);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string Name = obj.name;
            string sno = obj.sno;
            string accountno = obj.accountno;
            string totalamount = obj.totalamount;
            string Remarks = obj.Remarks;
            string strdate = obj.paymentdate;
            string branchname = obj.branchname;
            string sapimport = obj.sapimport;
            DateTime dtpaymnet = Convert.ToDateTime(strdate);
            string approvedby = obj.approvedby;
            string subbranch = obj.subbranch;
            string totalamountsub = obj.totalamountsub;
            string btn_save = obj.btnval;
           
            cmd = new SqlCommand("SELECT sno, accountid, amount, closedby, doe FROM accountnowiseclosingdetails WHERE (doe BETWEEN @d1 AND @d2) AND (accountid = @accountid)");
            cmd.Parameters.Add("@accountid", accountno);
            cmd.Parameters.Add("@d1", GetLowDate(dtpaymnet));
            cmd.Parameters.Add("@d2", GetHighDate(dtpaymnet));
            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
            //if (dtroutes.Rows.Count > 0)
            //{
            //    string msg = "This account no already closed";
            //    string Response = GetJson(msg);
            //    context.Response.Write(Response);
            //}
            //else
            //{
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into paymentdetails (name,accountno,totalamount,remarks,approvedby,doe,createdby,status,paymentdate,branch,sub_branch,sapimport,total_subamount) values (@name,@accountno,@totalamount,@remarks,@approvedby,@doe,@createdby,'P',@paymentdate,@branch,@sub_branch,@sapimport,@total_subamount)");
                cmd.Parameters.Add("@name", Name);
                cmd.Parameters.Add("@accountno", accountno);
                cmd.Parameters.Add("@totalamount", totalamount);
                cmd.Parameters.Add("@remarks", Remarks);
                cmd.Parameters.Add("@approvedby", approvedby);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@paymentdate", dtpaymnet);
                cmd.Parameters.Add("@branch", branchname);
                cmd.Parameters.Add("@sub_branch", subbranch);
                cmd.Parameters.Add("@sapimport", sapimport);
                cmd.Parameters.Add("@total_subamount", totalamountsub);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from paymentdetails ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string paymentrefno = routes.Rows[0]["sno"].ToString();
                foreach (paymentsubdetails si in obj.paymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into paymentsubdetails (paymentrefno, headofaccount, amount) values (@paymentrefno, @headofaccount, @amount)");
                    cmd.Parameters.Add("@paymentrefno", paymentrefno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    vdm.insert(cmd);
                }
                foreach (paymentsubdetails si in obj.subpaymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into subaccount_payment (paymentrefno, headofaccount, amount,branchid) values (@paymentrefno, @headofaccount, @amount,@branchid)");
                    cmd.Parameters.Add("@paymentrefno", paymentrefno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    cmd.Parameters.Add("@branchid", subbranch);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("UPDATE paymentdetails SET name=@name,accountno=@accountno,totalamount=@totalamount,remarks=@remarks,approvedby=@approvedby, status=@status,branch=@branch,sub_branch=@sub_branch,sapimport=@sapimport,total_subamount=@total_subamount,modifiedby=@modifiedby,modifieddate=@modifieddate  WHERE sno=@sno");
                cmd.Parameters.Add("@name", Name);
                cmd.Parameters.Add("@accountno", accountno);
                cmd.Parameters.Add("@totalamount", totalamount);
                cmd.Parameters.Add("@remarks", Remarks);
                cmd.Parameters.Add("@approvedby", approvedby);
                cmd.Parameters.Add("@branch", branchname);
                cmd.Parameters.Add("@sub_branch", subbranch);
                cmd.Parameters.Add("@sapimport", sapimport);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@status", 'P');
                cmd.Parameters.Add("@modifieddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@modifiedby", UserName);
                cmd.Parameters.Add("@total_subamount", totalamountsub);
                vdm.Update(cmd);
                cmd = new SqlCommand("delete from paymentsubdetails where paymentrefno=@Refno");
                cmd.Parameters.Add("@Refno", sno);
                vdm.Delete(cmd);
                foreach (paymentsubdetails si in obj.paymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into paymentsubdetails (paymentrefno, headofaccount, amount) values (@paymentrefno, @headofaccount, @amount)");
                    cmd.Parameters.Add("@paymentrefno", sno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    vdm.insert(cmd);
                }
                cmd = new SqlCommand("delete from subaccount_payment where paymentrefno=@Refno");
                cmd.Parameters.Add("@Refno", sno);
                vdm.Delete(cmd);
                foreach (paymentsubdetails si in obj.subpaymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    if (headofaccount != null || headofaccount != "")
                    {
                        cmd = new SqlCommand("insert into subaccount_payment (paymentrefno, headofaccount, amount,branchid) values (@paymentrefno, @headofaccount, @amount,@branchid)");
                        cmd.Parameters.Add("@paymentrefno", sno);
                        cmd.Parameters.Add("@headofaccount", headofaccount);
                        cmd.Parameters.Add("@amount", amount);
                        cmd.Parameters.Add("@branchid", subbranch);
                        vdm.insert(cmd);
                    }
                }
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            //}
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_payments_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            int currentyear = ServerDateCurrentdate.Year;
            int nextyear = ServerDateCurrentdate.Year + 1;
            if (ServerDateCurrentdate.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
            }
            if (ServerDateCurrentdate.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
            }
            cmd = new SqlCommand("SELECT pmd.sno, pmd.name, pmd.totalamount, bam.accountno, bam.accounttype, pmd.remarks, pmd.doe, pmd.createdby, pmd.status, pmd.approvedby FROM   paymentdetails AS pmd INNER JOIN  bankaccountno_master AS bam ON bam.sno = pmd.accountno WHERE pmd.status='P'");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> paymentdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getpaymentdetails = new paymentdetails();
                getpaymentdetails.name = dr["name"].ToString();
                getpaymentdetails.totalamount = dr["totalamount"].ToString();
                getpaymentdetails.accountno = dr["accountno"].ToString();
                getpaymentdetails.accounttype = dr["accounttype"].ToString();
                getpaymentdetails.doe = dr["doe"].ToString();
                string status = dr["status"].ToString();
                if (status == "P")
                {
                    getpaymentdetails.status = "Pending";
                }
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_paymentsub_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string sno = context.Request["sno"];
            cmd = new SqlCommand("SELECT psd.sno, psd.paymentrefno, psd.headofaccount, psd.amount, ham.accountname FROM   paymentsubdetails AS psd INNER JOIN headofaccounts_master AS ham ON psd.headofaccount = ham.sno where psd.paymentrefno=@sno");
            cmd.Parameters.Add("@sno", sno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> paymentdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getpaymentdetails = new paymentdetails();
                getpaymentdetails.headofaccount = dr["accountname"].ToString();
                getpaymentdetails.totalamount = dr["amount"].ToString();
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }


    private void updtae_approvalpayment_click(HttpContext context)
    {
        vdm = new VehicleDBMgr();
        string sno = context.Request["sno"];
        string btnvalue = context.Request["btnval"];
        string msg = "";
        if (btnvalue == "Approve")
        {
            cmd = new SqlCommand("UPDATE paymentdetails SET status='A' Where sno=@sno");
            msg = "Approved successfully";
        }
        else
        {
            cmd = new SqlCommand("UPDATE paymentdetails SET status='R' Where sno=@sno");
            msg = "successfully Rejectd";
        }
        cmd.Parameters.Add("@sno", sno);
        vdm.Update(cmd);
        string Response = GetJson(msg);
        context.Response.Write(Response);
    }

    private void get_bankamount_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT bankcashdetails.bankid, bankcashdetails.amount, bankmaster.bankname from bankcashdetails INNER JOIN bankmaster ON bankmaster.sno=bankcashdetails.bankid");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<bankdetailes> bankdetailslist = new List<bankdetailes>();
            foreach (DataRow dr in routes.Rows)
            {
                bankdetailes getbankdetails = new bankdetailes();
                getbankdetails.bankname = dr["bankname"].ToString();
                getbankdetails.amount = dr["amount"].ToString();
                getbankdetails.sno = dr["bankid"].ToString();
                bankdetailslist.Add(getbankdetails);
            }
            string response = GetJson(bankdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_collections_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            //cmd = new SqlCommand("SELECT  bankaccountno_master.accountno as accountid, collections.sno, collections.accountno, collections.name, collections.amount, collections.remarks, collections.doe, collections.createdby, collections.approvedby, collections.status, bankaccountno_master.branchname FROM bankaccountno_master INNER JOIN collections ON bankaccountno_master.sno = collections.accountno where (collections.receiptdate between @d1 and @d2)");
            cmd = new SqlCommand("SELECT bankaccountno_master.accountno AS accountid, collections.sno, collections.accountno,collections.sub_amount, collections.name, collections.amount, collections.remarks,collections.sapimport, collections.doe, collections.approvedby, collections.status, bankaccountno_master.branchname, branchmaster_1.branchname AS subbranch, branchmaster.branchname AS brnch, collections.receiptdate, collections.subbranch as subbranchid, collections.branch AS branchid FROM  bankaccountno_master INNER JOIN collections ON bankaccountno_master.sno = collections.accountno LEFT OUTER JOIN branchmaster AS branchmaster_1 ON collections.branch = branchmaster_1.branchid LEFT OUTER JOIN branchmaster ON collections.subbranch = branchmaster.branchid WHERE (collections.receiptdate BETWEEN @d1 AND @d2) order by collections.receiptdate");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate.AddDays(-90)));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Collections> accountdetailslist = new List<Collections>();
            foreach (DataRow dr in routes.Rows)
            {
                Collections getaccountdetails = new Collections();
                getaccountdetails.accountid = dr["accountid"].ToString();
                getaccountdetails.accountno = dr["accountno"].ToString();
                getaccountdetails.branchname = dr["brnch"].ToString();
                getaccountdetails.subbranchname = dr["subbranch"].ToString();
                getaccountdetails.branchid= dr["branchid"].ToString();
                getaccountdetails.subbranchid = dr["subbranchid"].ToString();
                getaccountdetails.sapimport = dr["sapimport"].ToString();
                getaccountdetails.receiptdate = ((DateTime)dr["receiptdate"]).ToString("yyyy-MM-dd");//dr["doe"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.totalsubamount = dr["sub_amount"].ToString();
                getaccountdetails.Name = dr["name"].ToString();
                getaccountdetails.doe = ((DateTime)dr["doe"]).ToString("yyyy-MM-dd");//dr["doe"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                getaccountdetails.remarks = dr["remarks"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_collectionssubdetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string collectionno = context.Request["sno"];
            cmd = new SqlCommand("SELECT collectionsubdetails.collectionrefno, collectionsubdetails.sno, collectionsubdetails.amount, headofaccounts_master.accountname, collectionsubdetails.headofaccount  FROM     collectionsubdetails INNER JOIN  headofaccounts_master ON collectionsubdetails.headofaccount = headofaccounts_master.sno WHERE collectionsubdetails.collectionrefno=@collectionno");
            cmd.Parameters.Add("@collectionno", collectionno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Collections> accountdetailslist = new List<Collections>();
            foreach (DataRow dr in routes.Rows)
            {
                Collections getaccountdetails = new Collections();
                getaccountdetails.refno = dr["collectionrefno"].ToString();
                getaccountdetails.accountno = dr["accountname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_subaccount_collectiondetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string collectionno = context.Request["sno"];
            cmd = new SqlCommand("SELECT subaccount_collection.collectionrefno, subaccount_collection.sno, subaccount_collection.amount, headofaccounts_master.accountname, subaccount_collection.headofaccount  FROM     subaccount_collection INNER JOIN  headofaccounts_master ON subaccount_collection.headofaccount = headofaccounts_master.sno WHERE subaccount_collection.collectionrefno=@collectionno");
            cmd.Parameters.Add("@collectionno", collectionno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Collections> accountdetailslist = new List<Collections>();
            foreach (DataRow dr in routes.Rows)
            {
                Collections getaccountdetails = new Collections();
                getaccountdetails.refno = dr["collectionrefno"].ToString();
                getaccountdetails.accountno = dr["accountname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Journel_entry_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT journel_entry.sno, journel_entry.branchid,journel_entry.jvdate, journel_entry.amount, journel_entry.doe, journel_entry.remarks, journel_entry.status, employe_login.name AS empname, branchmaster.branchname FROM journel_entry INNER JOIN employe_login ON journel_entry.createdby = employe_login.sno INNER JOIN branchmaster ON journel_entry.branchid = branchmaster.branchid where (journel_entry.doe between @d1 and @d2)");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate.AddDays(-3)));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.branchid = dr["branchid"].ToString();
                getaccountdetails.branchname = dr["branchname"].ToString();
                getaccountdetails.doe = dr["doe"].ToString();
                getaccountdetails.jvdate = dr["jvdate"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                getaccountdetails.Remarks = dr["remarks"].ToString();
                getaccountdetails.approvedby = dr["empname"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_payment_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
           // cmd = new SqlCommand("SELECT paymentdetails.sno, paymentdetails.name, paymentdetails.accountno AS accountid, paymentdetails.totalamount, paymentdetails.remarks,  paymentdetails.approvedby, paymentdetails.doe, paymentdetails.status, bankaccountno_master.accountno, bankaccountno_master.accounttype FROM  paymentdetails INNER JOIN bankaccountno_master ON paymentdetails.accountno = bankaccountno_master.sno where (paymentdetails.paymentdate between @d1 and @d2)");
            cmd = new SqlCommand("SELECT  paymentdetails.sno, paymentdetails.name,paymentdetails.sapimport,paymentdetails.total_subamount, paymentdetails.paymentdate,paymentdetails.accountno AS accountid, paymentdetails.totalamount, paymentdetails.remarks, paymentdetails.approvedby, paymentdetails.doe, paymentdetails.status, bankaccountno_master.accountno, bankaccountno_master.accounttype, branchmaster.branchname, paymentdetails.branch, branchmaster_1.branchname AS branchsub,paymentdetails.sub_branch FROM paymentdetails INNER JOIN bankaccountno_master ON paymentdetails.accountno = bankaccountno_master.sno LEFT OUTER JOIN branchmaster ON paymentdetails.branch = branchmaster.branchid LEFT OUTER JOIN branchmaster AS branchmaster_1 ON paymentdetails.sub_branch = branchmaster_1.branchid WHERE  (paymentdetails.paymentdate BETWEEN @d1 AND @d2) order by paymentdetails.paymentdate ");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate.AddDays(-90)));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.accountid = dr["accountid"].ToString();
                getaccountdetails.accountno = dr["accountno"].ToString();
                getaccountdetails.accounttype = dr["accounttype"].ToString();
                getaccountdetails.totalamount = dr["totalamount"].ToString();
                getaccountdetails.name = dr["name"].ToString();
                getaccountdetails.doe = ((DateTime)dr["doe"]).ToString("yyyy-MM-dd");
                getaccountdetails.sno = dr["sno"].ToString();
                getaccountdetails.Remarks = dr["remarks"].ToString();
                getaccountdetails.approvedby = dr["approvedby"].ToString();
                getaccountdetails.branch = dr["branchname"].ToString();
                getaccountdetails.subbranch = dr["branchsub"].ToString();
                getaccountdetails.sapimport = dr["sapimport"].ToString();
                getaccountdetails.branchid = dr["branch"].ToString();
                getaccountdetails.subbranchid = dr["sub_branch"].ToString();
                getaccountdetails.totalsubamount = dr["total_subamount"].ToString();
                getaccountdetails.paymentdate = ((DateTime)dr["paymentdate"]).ToString("yyyy-MM-dd");
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_subjv_creditdetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string refno = context.Request["sno"];
            cmd = new SqlCommand("SELECT headofaccounts_master.accountname,  subjournel_credit_entry.sno,  subjournel_credit_entry.refno,  subjournel_credit_entry.headofaccount,  subjournel_credit_entry.amount FROM   subjournel_credit_entry INNER JOIN headofaccounts_master ON  subjournel_credit_entry.headofaccount = headofaccounts_master.sno WHERE ( subjournel_credit_entry.refno = @refno)");
            cmd.Parameters.Add("@refno", refno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.refno = dr["refno"].ToString();
                getaccountdetails.accountno = dr["accountname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_journelsubdetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string refno = context.Request["sno"];
            cmd = new SqlCommand("SELECT headofaccounts_master.accountname, subjournel_entry.sno, subjournel_entry.refno, subjournel_entry.headofaccount, subjournel_entry.amount FROM  subjournel_entry INNER JOIN headofaccounts_master ON subjournel_entry.headofaccount = headofaccounts_master.sno WHERE (subjournel_entry.refno = @refno)");
            cmd.Parameters.Add("@refno", refno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.refno = dr["refno"].ToString();
                getaccountdetails.accountno = dr["accountname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_subaccount_paymentdetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string paymentno = context.Request["sno"];
            cmd = new SqlCommand("SELECT subaccount_payment.sno, subaccount_payment.paymentrefno, subaccount_payment.headofaccount, subaccount_payment.amount,  headofaccounts_master.accountname FROM subaccount_payment INNER JOIN headofaccounts_master ON subaccount_payment.headofaccount = headofaccounts_master.sno WHERE subaccount_payment.paymentrefno=@paymentno");
            cmd.Parameters.Add("@paymentno", paymentno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.refno = dr["paymentrefno"].ToString();
                getaccountdetails.accountno = dr["accountname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_paymentsubdetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string paymentno = context.Request["sno"];
            cmd = new SqlCommand("SELECT paymentsubdetails.sno, paymentsubdetails.paymentrefno, paymentsubdetails.headofaccount, paymentsubdetails.amount,  headofaccounts_master.accountname FROM paymentsubdetails INNER JOIN headofaccounts_master ON paymentsubdetails.headofaccount = headofaccounts_master.sno WHERE paymentsubdetails.paymentrefno=@paymentno");
            cmd.Parameters.Add("@paymentno", paymentno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.refno = dr["paymentrefno"].ToString();
                getaccountdetails.accountno = dr["accountname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class departmentMaster
    {
        public string DepartmentName { get; set; }
        public string DepartmentCode { get; set; }
        public string sno { get; set; }
    }


    public void save_Department_Details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string DepartmentName = context.Request["DepartmentName"];
            string DepartmentCode = context.Request["DepartmentCode"];
            string btn_save = context.Request["btnval"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();

            if (btn_save == "save")
            {
                cmd = new SqlCommand("insert into Departmentdetails (DepartmentName,DepartmentCode,doe,createdby) values (@DepartmentName,@DepartmentCode,@doe,@createdby)");
                cmd.Parameters.Add("@DepartmentName", DepartmentName);
                cmd.Parameters.Add("@DepartmentCode", DepartmentCode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update Departmentdetails set DepartmentName=@DepartmentName,DepartmentCode=@DepartmentCode,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@DepartmentName", DepartmentName);
                cmd.Parameters.Add("@DepartmentCode", DepartmentCode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Updated Successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_dept_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,DepartmentName,DepartmentCode,createdby FROM Departmentdetails");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<departmentMaster> departmentMasterlist = new List<departmentMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                departmentMaster getdeptdetails = new departmentMaster();
                getdeptdetails.DepartmentName = dr["DepartmentName"].ToString();
                getdeptdetails.DepartmentCode = dr["DepartmentCode"].ToString();
                getdeptdetails.sno = dr["sno"].ToString();
                departmentMasterlist.Add(getdeptdetails);
            }
            string response = GetJson(departmentMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class EmployeeDetails
    {
        public string name { get; set; }
        public string deptid { get; set; }
        public string deptname { get; set; }
        public string username { get; set; }
        public string passward { get; set; }
        public string sno { get; set; }
        public string leveltype { get; set; }
        public string branchid { get; set; }
        public string branchname { get; set; }
    }

    public void save_employee_details(HttpContext context)
    {
        try
        {
            
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string name = context.Request["name"];
            string DeCode = context.Request["deptid"];
            string branchid = context.Request["branchname"];
            string leveltype = context.Request["leveltype"];
            string username = context.Request["username"];
            string passward = context.Request["passward"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into employe_login (name,deptid,username,passward,branchid,leveltype,doe,createdby) values (@name,@deptid,@username,@passward,@branchid,@leveltype,@doe,@createdby)");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@deptid", DeCode);
                cmd.Parameters.Add("@username", username);
                cmd.Parameters.Add("@passward", passward);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@leveltype", leveltype);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update employe_login set name=@name,deptid=@deptid,username=@username,passward=@passward,branchid=@branchid,leveltype=@leveltype,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@deptid", DeCode);
                cmd.Parameters.Add("@username", username);
                cmd.Parameters.Add("@passward", passward);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@leveltype", leveltype);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_employee_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT el.sno,el.name,el.deptid,el.branchid,el.leveltype,el.username,el.passward,el.doe,el.createdby, branchmaster.branchname,dept.DepartmentName FROM  employe_login el INNER JOIN Departmentdetails dept ON el.deptid = dept.sno INNER JOIN branchmaster ON el.branchid = branchmaster.branchid");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<EmployeeDetails> EmployeeDetailslist = new List<EmployeeDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                EmployeeDetails getempdetail = new EmployeeDetails();
                getempdetail.name = dr["name"].ToString();
                getempdetail.deptid = dr["deptid"].ToString();
                getempdetail.deptname = dr["DepartmentName"].ToString();
                getempdetail.branchid = dr["branchid"].ToString();
                getempdetail.branchname = dr["branchname"].ToString();
                getempdetail.leveltype = dr["leveltype"].ToString();
                getempdetail.username = dr["username"].ToString();
                getempdetail.passward = dr["passward"].ToString();
                getempdetail.sno = dr["sno"].ToString();
                EmployeeDetailslist.Add(getempdetail);
            }
            string response = GetJson(EmployeeDetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_subgroup_ledgercode(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
           // string glcode = context.Request["glcode"].ToString();
            cmd = new SqlCommand("SELECT sno,groupledgerid,subgroupcode,subgroup from subgroup_ledgerdetails");
           // cmd.Parameters.Add("@glcode", glcode);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<groupledger> ledgerlist = new List<groupledger>();
            if (ledgerlist != null)
            {
                foreach (DataRow dr in routes.Rows)
                {
                    groupledger getgroupledger = new groupledger();

                    getgroupledger.groupledgerid = dr["groupledgerid"].ToString();
                    getgroupledger.subgroupcode = dr["subgroupcode"].ToString();
                    getgroupledger.subgroup = dr["subgroup"].ToString();
                    getgroupledger.sno = dr["sno"].ToString();
                    ledgerlist.Add(getgroupledger);
                }
            }
            else
            {
            }
            string response = GetJson(ledgerlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Subheadofaccount
    {
        public string HeadOfAccount { get; set; }
        public string accountno { get; set; }
        public string SubHeadofAccount { get; set; }
        public string headid { get; set; }
        public string doe { get; set; }
        public string btnval { get; set; }
        public string SNo { get; set; }
        public List<Subheadofaccount> paymententry { get; set; }
    }

    public void save_SubHeadofAccount_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            Subheadofaccount obj = js.Deserialize<Subheadofaccount>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string btn_save = obj.btnval;
            string headid = obj.headid;
            string SNo = obj.SNo;
            string SubHeadofAccount = obj.SubHeadofAccount;
            if (btn_save == "Save")
            {
                if (obj.paymententry.Count != 0)
                {
                    foreach (Subheadofaccount si in obj.paymententry)
                    {
                        string headofaccount = si.HeadOfAccount;
                        string subheadofaccount = si.SubHeadofAccount;
                        cmd = new SqlCommand("insert into subheadofaccount_details (headofaccount, subname, doe, createdby) values (@headofaccount, @subname, @doe, @createdby)");
                        cmd.Parameters.Add("@headofaccount", si.SNo);
                        cmd.Parameters.Add("@subname", si.SubHeadofAccount);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@createdby", UserName);
                        vdm.insert(cmd);
                    }
                }
                else
                {
                    cmd = new SqlCommand("insert into subheadofaccount_details (headofaccount, subname, doe, createdby) values (@headofaccount, @subname, @doe, @createdby)");
                    cmd.Parameters.Add("@headofaccount", headid);
                    cmd.Parameters.Add("@subname", SubHeadofAccount);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    vdm.insert(cmd);
                }
                string msg = "Detailes successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {

                cmd = new SqlCommand("Update subheadofaccount_details set headofaccount=@headofaccount, subname=@subname, createdby=@createdby, doe=@doe where sno=@sno");
                cmd.Parameters.Add("@headofaccount", headid);
                cmd.Parameters.Add("@subname", SubHeadofAccount);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", SNo);
                vdm.Update(cmd);

                string msg = "updated successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_SubHeadofAccount_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT subheadofaccount_details.sno, subheadofaccount_details.headofaccount, subheadofaccount_details.subname, subheadofaccount_details.doe, subheadofaccount_details.createdby, headofaccounts_master.accountname FROM  subheadofaccount_details INNER JOIN headofaccounts_master ON subheadofaccount_details.headofaccount = headofaccounts_master.sno ");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Subheadofaccount> accountdetailslist = new List<Subheadofaccount>();
            foreach (DataRow dr in routes.Rows)
            {
                Subheadofaccount getaccountdetails = new Subheadofaccount();
                getaccountdetails.HeadOfAccount = dr["accountname"].ToString();
                getaccountdetails.SubHeadofAccount = dr["subname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.doe = dr["doe"].ToString();
                getaccountdetails.SNo = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_paymentsubentrys_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            paymentdetails obj = js.Deserialize<paymentdetails>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string sno = obj.sno;
            string branchid = obj.branchid;
            string totalamount = obj.totalamount;
            string btn_save2 = obj.btnval;
            if (btn_save2 == "Save")
            {
                cmd = new SqlCommand("delete from subaccount_payment where paymentrefno=@Refno");
                cmd.Parameters.Add("@Refno", sno);
                vdm.Delete(cmd);
                int Totalcount = obj.paymententry.Count;
                int count = 0;
                //int count = 0;
                foreach (paymentsubdetails si in obj.paymententry)
                {
                    string headofaccount = si.SNo;
                    string amount = si.amount;
                    cmd = new SqlCommand("insert into subaccount_payment (paymentrefno, headofaccount, amount,branchid) values (@paymentrefno, @headofaccount, @amount,@branchid)");
                    cmd.Parameters.Add("@paymentrefno", sno);
                    cmd.Parameters.Add("@headofaccount", headofaccount);
                    cmd.Parameters.Add("@amount", amount);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.insert(cmd);

                }
                cmd = new SqlCommand("select count(*) AS co from subaccount_payment where paymentrefno=@Refno");
                cmd.Parameters.Add("@Refno", sno);
                DataTable countno = vdm.SelectQuery(cmd).Tables[0];
                foreach (DataRow dr in countno.Rows)
                {

                    count = Convert.ToInt32(dr["co"].ToString());
                }
                //
                if (Convert.ToInt32(count) == Totalcount)
                {
                    cmd = new SqlCommand("select paymentrefno from subaccount_payment where paymentrefno=@Refno");
                    cmd.Parameters.Add("@Refno", sno);
                    DataTable dtrefno = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("UPDATE paymentdetails SET status=@status WHERE sno=@sno");
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@status", 'V');
                    vdm.Update(cmd);
                }
                //foreach (paymentsubdetails si in obj.subpaymententry)
                //{
                //    string headofaccount = si.SNo;
                //    string amount = si.amount;
                //    cmd = new SqlCommand("insert into subaccount_payment (paymentrefno, headofaccount, amount) values (@paymentrefno, @headofaccount, @amount)");
                //    cmd.Parameters.Add("@paymentrefno", sno);
                //    cmd.Parameters.Add("@headofaccount", headofaccount);
                //    cmd.Parameters.Add("@amount", amount);
                //    vdm.insert(cmd);
                //}
                string msg = "successfully inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {

            }
        }

        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_paymentsubentry_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("select branchname from branchmaster");
            DataTable dt = vdm.SelectQuery(cmd).Tables[0];
            string branchname = dt.Rows[0]["branchname"].ToString();
            string fromdate = context.Request["fromdate"];
            string todate = context.Request["todate"];
            string accountno = context.Request["accountno"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT paymentdetails.sno, paymentdetails.name, paymentdetails.accountno AS accountid, paymentdetails.totalamount, paymentdetails.remarks,  paymentdetails.approvedby, paymentdetails.paymentdate, paymentdetails.status, bankaccountno_master.accountno, bankaccountno_master.accounttype FROM  paymentdetails INNER JOIN bankaccountno_master ON paymentdetails.accountno = bankaccountno_master.sno  where paymentdetails.accountno = @accountno AND (paymentdetails.paymentdate between @d1 and @d2)AND (paymentdetails.status <> 'v') ");
            cmd.Parameters.Add("@accountno", accountno);
            cmd.Parameters.Add("@d1", fromdate);
            cmd.Parameters.Add("@d2", todate);
            //cmd.Parameters.Add("@d2", todate);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            //if (routes.Rows.Count > 0)
            //{
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.accountid = dr["accountid"].ToString();
                getaccountdetails.accountno = dr["accountno"].ToString();
                getaccountdetails.accounttype = dr["accounttype"].ToString();
                getaccountdetails.totalamount = dr["totalamount"].ToString();
                getaccountdetails.name = dr["name"].ToString();
                getaccountdetails.doe = dr["paymentdate"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                getaccountdetails.Remarks = dr["remarks"].ToString();
                getaccountdetails.approvedby = dr["approvedby"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_subaccountentry_paymentdetails(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string paymentno = context.Request["sno"];
            cmd = new SqlCommand("SELECT subaccount_payment.sno, subaccount_payment.paymentrefno, subaccount_payment.headofaccount, subaccount_payment.amount,  headofaccounts_master.accountname FROM subaccount_payment INNER JOIN headofaccounts_master ON subaccount_payment.headofaccount = headofaccounts_master.sno WHERE subaccount_payment.paymentrefno=@paymentno");
            cmd.Parameters.Add("@paymentno", paymentno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.refno = dr["paymentrefno"].ToString();
                getaccountdetails.accountno = dr["accountname"].ToString();
                getaccountdetails.headid = dr["headofaccount"].ToString();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }




    private void get_paymentsubview_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string sno = context.Request["sno"];
            cmd = new SqlCommand("SELECT psd.sno, psd.paymentrefno, psd.headofaccount, psd.amount, ham.accountname, psd.branchid, branchmaster.branchname FROM subaccount_payment AS psd INNER JOIN  headofaccounts_master AS ham ON psd.headofaccount = ham.sno INNER JOIN branchmaster ON psd.branchid = branchmaster.branchid WHERE  (psd.paymentrefno = @sno)");
            cmd.Parameters.Add("@sno", sno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> paymentdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getpaymentdetails = new paymentdetails();
                getpaymentdetails.headofaccount = dr["accountname"].ToString();
                getpaymentdetails.totalamount = dr["amount"].ToString();
                getpaymentdetails.branchid = dr["branchname"].ToString();
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void save_transaction_type(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string transactiontype = context.Request["transactiontype"];
            string shortdescription = context.Request["shortdescription"];
            string system = context.Request["system"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into transactiontype (transactiontype,shortdescription,system,doe,createdby) values (@transactiontype,@shortdescription,@system,@doe,@createdby)");
                cmd.Parameters.Add("@transactiontype", transactiontype);
                cmd.Parameters.Add("@shortdescription", shortdescription);
                cmd.Parameters.Add("@system", system);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update transactiontype set transactiontype=@transactiontype,shortdescription=@shortdescription,system=@system,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@transactiontype", transactiontype);
                cmd.Parameters.Add("@shortdescription", shortdescription);
                cmd.Parameters.Add("@system", system);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class transactiontypes
    {
        public string transactiontype { get; set; }
        public string shortdescription { get; set; }
        public string system { get; set; }
        public string sno { get; set; }
        public string system1 { get; set; }

    }

    private void get_transaction_type(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("select sno,transactiontype,shortdescription,system from transactiontype");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<transactiontypes> transactionlist = new List<transactiontypes>();
            foreach (DataRow dr in routes.Rows)
            {
                transactiontypes gettransdetail = new transactiontypes();
                gettransdetail.transactiontype = dr["transactiontype"].ToString();
                string vouchertype=
                gettransdetail.shortdescription = dr["shortdescription"].ToString();
                string system = dr["system"].ToString();
                if (system == "M")
                {
                    system = "Manual";

                }
                else if (system == "S")
                {
                    system = "System";

                }
                gettransdetail.system = system;
                gettransdetail.system1 = dr["system"].ToString();
                //gettransdetail.system = dr["system"].ToString();
                gettransdetail.sno = dr["sno"].ToString();
                transactionlist.Add(gettransdetail);
            }
            string response = GetJson(transactionlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void save_primarygroup_details(HttpContext context)
    {
        try
        {

            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string Groupcode = context.Request["Groupcode"];
            string Shortdescription = context.Request["Shortdescription"];
            string Longdescription = context.Request["Longdescription"];
            string GLtype = context.Request["GLtype"];
            string Tradingac = context.Request["Tradingac"];
            string profitloss = context.Request["profitloss"];
            string Balancesheet = context.Request["Balancesheet"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into primarygroup (groupcode,shortdesc,longdesc,GLtype,tradingaccount,profitloss,balancesheet,doe,createdby) values (@groupcode,@shortdesc,@longdesc,@GLtype,@tradingaccount,@profitloss,@balancesheet,@doe,@createdby)");
                cmd.Parameters.Add("@groupcode", Groupcode);
                cmd.Parameters.Add("@shortdesc", Shortdescription);
                cmd.Parameters.Add("@longdesc", Longdescription);
                cmd.Parameters.Add("@GLtype", GLtype);
                cmd.Parameters.Add("@tradingaccount", Tradingac);
                cmd.Parameters.Add("@profitloss", profitloss);
                cmd.Parameters.Add("@balancesheet", Balancesheet);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update primarygroup set groupcode=@groupcode,shortdesc=@shortdesc,longdesc=@longdesc,GLtype=@GLtype,tradingaccount=@tradingaccount,profitloss=@profitloss,Balancesheet=@Balancesheet,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@groupcode", Groupcode);
                cmd.Parameters.Add("@shortdesc", Shortdescription);
                cmd.Parameters.Add("@longdesc", Longdescription);
                cmd.Parameters.Add("@GLtype", GLtype);
                cmd.Parameters.Add("@tradingaccount", Tradingac);
                cmd.Parameters.Add("@profitloss", profitloss);
                cmd.Parameters.Add("@balancesheet", Balancesheet);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class primarygroup
    {
        public string Groupcode { get; set; }
        public string Shortdescription { get; set; }
        public string Longdescription { get; set; }
        public string GLtype { get; set; }
        public string GLtype1 { get; set; }
        public string Tradingac { get; set; }
        public string Tradingac1 { get; set; }
        public string profitloss { get; set; }
        public string profitloss1 { get; set; }
        public string Balancesheet { get; set; }
        public string Balancesheet1 { get; set; }
        public string sno { get; set; }

    }

    private void get_primary_group(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("select sno, groupcode, shortdesc, longdesc, GLtype, tradingaccount, profitloss, balancesheet, doe, createdby from primarygroup");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<primarygroup> primarygrouplist = new List<primarygroup>();
            foreach (DataRow dr in routes.Rows)
            {
                primarygroup getprimarydetail = new primarygroup();
                getprimarydetail.Groupcode = dr["groupcode"].ToString();
                getprimarydetail.Shortdescription = dr["shortdesc"].ToString();
                getprimarydetail.Longdescription = dr["longdesc"].ToString();
                string GLtype = dr["GLtype"].ToString();
                if (GLtype == "A")
                {
                    GLtype = "Assets";
                }
                else if (GLtype == "L")
                {
                    GLtype = "Liability";
                }
                if (GLtype == "I")
                {
                    GLtype = "Income";
                }
                else if (GLtype == "E")
                {
                    GLtype = "Expenditure";
                }
                getprimarydetail.GLtype = GLtype;
                getprimarydetail.GLtype1 = dr["GLtype"].ToString();
                string Tradingac = dr["tradingaccount"].ToString();
                if (Tradingac == "C")
                {
                    Tradingac = "Credit";
                }
                else if (Tradingac == "D")
                {
                    Tradingac = "Debit";
                }
                if (Tradingac == "N")
                {
                    Tradingac = "Null";
                }
                getprimarydetail.Tradingac = Tradingac;
                getprimarydetail.Tradingac1 = dr["tradingaccount"].ToString();
                string profitloss = dr["profitloss"].ToString();
                if (profitloss == "C")
                {
                    profitloss = "Credit";
                }
                else if (profitloss == "D")
                {
                    profitloss = "Debit";
                }
                if (profitloss == "N")
                {
                    profitloss = "Null";
                }
                getprimarydetail.profitloss = profitloss;
                getprimarydetail.profitloss1 = dr["profitloss"].ToString();
                string Balancesheet = dr["balancesheet"].ToString();
                if (Balancesheet == "C")
                {
                    Balancesheet = "Credit";
                }
                else if (Balancesheet == "D")
                {
                    Balancesheet = "Debit";
                }
                if (Balancesheet == "N")
                {
                    Balancesheet = "Null";
                }
                getprimarydetail.Balancesheet = Balancesheet;
                getprimarydetail.Balancesheet1 = dr["balancesheet"].ToString();
                getprimarydetail.sno = dr["sno"].ToString();
                primarygrouplist.Add(getprimarydetail);
            }
            string response = GetJson(primarygrouplist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_primary_group_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno, shortdesc FROM primarygroup");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<primarygroup> primarygrouplist = new List<primarygroup>();
            foreach (DataRow dr in routes.Rows)
            {
                primarygroup getprimarydetail = new primarygroup();
                getprimarydetail.Shortdescription = dr["shortdesc"].ToString();
                getprimarydetail.sno = dr["sno"].ToString();
                primarygrouplist.Add(getprimarydetail);
            }
            string response = GetJson(primarygrouplist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void save_financial_year(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string startdate = context.Request["startdate"];
            string Enddate = context.Request["Enddate"];
            string year = context.Request["year"];
            string currentyear = context.Request["currentyear"];
            string Acclosed = context.Request["Acclosed"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into financialyeardetails (startdate,enddate,year,currentyear,acclosed,doe,createdby) values (@startdate,@enddate,@year,@currentyear,@acclosed,@doe,@createdby)");
                cmd.Parameters.Add("@startdate", startdate);
                cmd.Parameters.Add("@enddate", Enddate);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@currentyear", currentyear);
                cmd.Parameters.Add("@acclosed", Acclosed);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update financialyeardetails set startdate=@startdate,enddate=@enddate,year=@year,currentyear=@currentyear,acclosed=@acclosed,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@startdate", startdate);
                cmd.Parameters.Add("@enddate", Enddate);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@currentyear", currentyear);
                cmd.Parameters.Add("@acclosed", Acclosed);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class financialyear
    {
        public string startdate { get; set; }
        public string Enddate { get; set; }
        public string year { get; set; }
        public string sno { get; set; }
        public string currentyear { get; set; }
        public string acclosed { get; set; }

    }

    private void get_financial_year(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("select sno, startdate, enddate, year, currentyear, acclosed, doe, createdby from financialyeardetails");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<financialyear> finyearlist = new List<financialyear>();
            foreach (DataRow dr in routes.Rows)
            {
                financialyear getfinyrdetail = new financialyear();
                getfinyrdetail.startdate = ((DateTime)dr["startdate"]).ToString("yyyy-MM-dd");
                getfinyrdetail.Enddate = ((DateTime)dr["enddate"]).ToString("yyyy-MM-dd");//dr["enddate"].ToString();
                getfinyrdetail.year = dr["year"].ToString();
                getfinyrdetail.acclosed = dr["acclosed"].ToString();
                getfinyrdetail.currentyear = dr["currentyear"].ToString();
                getfinyrdetail.sno = dr["sno"].ToString();
                finyearlist.Add(getfinyrdetail);
            }
            string response = GetJson(finyearlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_voucherseries_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string branchcode = context.Request["brcode"];
            string finyear = context.Request["Financialyear"];
            string vouchertype = context.Request["vouchertype"];
            string voucherfrm = context.Request["vouchernofrom"];
            //   string voucherto = context.Request["vouchernoto"];
            string manualsys = context.Request["manualsystem"];
            string narration = context.Request["narration"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {

                cmd = new SqlCommand("insert into voucherseries (branchcode,financialyear,vouchertype,vouchernofrm,manualsystem,narration,doe,createdby) values (@branchcode,@financialyear,@vouchertype,@vouchernofrm,@manualsystem,@narration,@doe,@createdby)");
                cmd.Parameters.Add("@branchcode", branchcode);
                cmd.Parameters.Add("@financialyear", finyear);
                cmd.Parameters.Add("@vouchertype", vouchertype);
                cmd.Parameters.Add("@vouchernofrm", voucherfrm);
                //  cmd.Parameters.Add("@vouchernoto", voucherto);
                cmd.Parameters.Add("@manualsystem", manualsys);
                cmd.Parameters.Add("@narration", narration);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update voucherseries set branchcode=@branchcode,financialyear=@financialyear,vouchertype=@vouchertype,vouchernofrm=@vouchernofrm,manualsystem=@manualsystem,narration=@narration,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@branchcode", branchcode);
                cmd.Parameters.Add("@financialyear", finyear);
                cmd.Parameters.Add("@vouchertype", vouchertype);
                cmd.Parameters.Add("@vouchernofrm", voucherfrm);
                //  cmd.Parameters.Add("@vouchernoto", voucherto);
                cmd.Parameters.Add("@manualsystem", manualsys);
                cmd.Parameters.Add("@narration", narration);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details updated  successfully ";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class voucherseries
    {
        public string branchcode { get; set; }
        public string finyear { get; set; }
        public string vouchertype { get; set; }
        public string voucherfrm { get; set; }
        public string voucherto { get; set; }
        public string branchname { get; set; }
        public string desc { get; set; }
        public string sno { get; set; }
        public string code { get; set; }
        public string year { get; set; }
        public string manualsystem { get; set; }
        public string transactiontype { get; set; }
        public string vouchertypename { get; set; }

        public string voucherno { get; set; }

        public string narration { get; set; }
    }
    private void get_voucher_no(HttpContext context)
    {
        int count = 0;
        DataTable dtratechart = new DataTable();
        try
        {
            try
            {
                
            vdm = new VehicleDBMgr();
            string vouchertype = context.Request["vouchertype"];
           // cmd = new SqlCommand("SELECT { fn IFNULL(MAX(sno), 0) } + 1 AS voucherno FROM  voucherseries where vouchertype=@vouchertype");
            cmd = new SqlCommand("SELECT COUNT(sno) AS voucherno FROM  voucherseries  where vouchertype=@vouchertype group by vouchertype order by vouchertype");
            cmd.Parameters.Add("@vouchertype", vouchertype);
             dtratechart = vdm.SelectQuery(cmd).Tables[0];
             count = Convert.ToInt32(dtratechart.Rows[0]["voucherno"].ToString());
           
                if (count > 0)
                {
                    count = count + 1;
                }
                else
                {
                    count = 1;
                }
            }
            catch
            {
                count = 1;
            }
            string voucherseries = "0000" + count.ToString() + "";
            List<voucherseries> voucherlist = new List<voucherseries>();
            //foreach (DataRow dr in dtratechart.Rows)
            //{
                voucherseries getvoucherdetail = new voucherseries();
                getvoucherdetail.voucherno = voucherseries;
                voucherlist.Add(getvoucherdetail);
            //}
            string response = GetJson(voucherlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_voucher_series(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            // cmd = new SqlCommand("select sno,branchcode,financialyear,vouchertype,vouchernofrm,vouchernoto,manualsystem,doe,createdby from voucherseries");
            cmd = new SqlCommand("SELECT voucherseries.sno, voucherseries.vouchertype, voucherseries.financialyear,voucherseries.narration, voucherseries.branchcode, voucherseries.vouchernofrm, voucherseries.vouchernoto, voucherseries.manualsystem,branchmaster.code, branchmaster.branchname, company_master.companyname, transactiontype.transactiontype FROM voucherseries INNER JOIN branchmaster ON voucherseries.branchcode = branchmaster.branchid INNER JOIN transactiontype ON voucherseries.vouchertype = transactiontype.sno LEFT OUTER JOIN company_master ON branchmaster.company_code = company_master.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<voucherseries> voucherlist = new List<voucherseries>();
            foreach (DataRow dr in routes.Rows)
            {
                voucherseries getvoucherdetail = new voucherseries();
                getvoucherdetail.branchcode = dr["branchcode"].ToString();
                getvoucherdetail.code = dr["code"].ToString();
                getvoucherdetail.branchname = dr["branchname"].ToString();
                getvoucherdetail.desc = dr["companyname"].ToString();
                getvoucherdetail.finyear = dr["financialyear"].ToString();
                getvoucherdetail.vouchertype = dr["vouchertype"].ToString();
                getvoucherdetail.vouchertypename = dr["transactiontype"].ToString();
                getvoucherdetail.voucherfrm = dr["vouchernofrm"].ToString();
                getvoucherdetail.manualsystem = dr["manualsystem"].ToString();
                getvoucherdetail.narration = dr["narration"].ToString();
                getvoucherdetail.sno = dr["sno"].ToString();
                voucherlist.Add(getvoucherdetail);
            }
            string response = GetJson(voucherlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_month_master(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string monthno = context.Request["monthno"];
            string monthname = context.Request["monthname"];
            string sequenceno = context.Request["sequenceno"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into monthmaster (monthno,monthname,sequenceno,doe,createdby) values (@monthno,@monthname,@sequenceno,@doe,@createdby)");
                cmd.Parameters.Add("@monthno", monthno);
                cmd.Parameters.Add("@monthname", monthname);
                cmd.Parameters.Add("@sequenceno", sequenceno);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update monthmaster set monthno=@monthno,monthname=@monthname,sequenceno=@sequenceno,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@monthno", monthno);
                cmd.Parameters.Add("@monthname", monthname);
                cmd.Parameters.Add("@sequenceno", sequenceno);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class monthmaster
    {
        public string monthno { get; set; }
        public string monthname { get; set; }
        public string sequenceno { get; set; }
        public string sno { get; set; }

    }

    private void get_month_master(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("select sno,monthno,monthname,sequenceno,doe,createdby from monthmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<monthmaster> monthlist = new List<monthmaster>();
            foreach (DataRow dr in routes.Rows)
            {
                monthmaster getmonthdetail = new monthmaster();
                getmonthdetail.monthno = dr["monthno"].ToString();
                getmonthdetail.monthname = dr["monthname"].ToString();
                getmonthdetail.sequenceno = dr["sequenceno"].ToString();
                getmonthdetail.sno = dr["sno"].ToString();
                monthlist.Add(getmonthdetail);
            }
            string response = GetJson(monthlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void savegroupdetailes(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string groupcode = context.Request["groupcode"];
            string createdby = context.Session["UserSno"].ToString();
            string modifiedby = context.Session["UserSno"].ToString();
            string shortdes = context.Request["shortdes"];
            string longdesc = context.Request["longdesc"];
            //string sno = context.Request["sno"];
            //string sno = context.Request["sno"];
            string btnSave = context.Request["btnVal"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into gl_details (glcode,short_desc,long_desc,createdby,createdon) values (@glcode,@short_desc,@long_desc,@createdby,@createdon )");
                //cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@glcode", groupcode);
                cmd.Parameters.Add("@short_desc", shortdes);
                cmd.Parameters.Add("@long_desc", longdesc);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@createdon", ServerDateCurrentdate);

                vdm.insert(cmd);
                string Response = GetJson("Insert Successfully");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"].ToString();
                cmd = new SqlCommand("Update gl_details set  glcode=@glcode,short_desc=@short_desc, long_desc=@long_desc,modifiedby=@modifiedby,modifiedon=@modifiedon where sno=@sno ");
                cmd.Parameters.Add("@glcode", groupcode);
                cmd.Parameters.Add("@short_desc", shortdes);
                cmd.Parameters.Add("@long_desc", longdesc);
                cmd.Parameters.Add("@modifiedby", modifiedby);
                cmd.Parameters.Add("@modifiedon", ServerDateCurrentdate);
                //cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("UPDATE");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }


    public class gldetailes
    {
        public string groupcode { get; set; }
        public string shortdes { get; set; }
        public string longdesc { get; set; }
        public string sno { get; set; }


    }
    private void get_glgroup_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,glcode,short_desc,long_desc FROM gl_details");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<gldetailes> EmployeDetalis = new List<gldetailes>();
            foreach (DataRow dr in routes.Rows)
            {
                gldetailes getbrcdetails = new gldetailes();
                getbrcdetails.groupcode = dr["glcode"].ToString();
                getbrcdetails.shortdes = dr["short_desc"].ToString();
                getbrcdetails.longdesc = dr["long_desc"].ToString();
                getbrcdetails.sno = dr["sno"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_group_ledger(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string primarygroup = context.Request["primarygroupid"];
            string groupcode = context.Request["groupcode"];
            string groupshortdesc = context.Request["groupshortdesc"];
           // string grouplongdesc = context.Request["grouplongdesc"];
           // string subgroupcode = context.Request["subgroupcode"];
            string schedule = context.Request["schedule"];
            string order = context.Request["order"];
            string addless = context.Request["addless"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into groupledgermaster (primarygroupcode,groupcode,groupshortdesc,schedule,orders,addless,doe,createdby) values (@primarygroupcode,@groupcode,@groupshortdesc,@schedule,@orders,@addless,@doe,@createdby)");
                cmd.Parameters.Add("@primarygroupcode", primarygroup);
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@groupshortdesc", groupshortdesc);
               // cmd.Parameters.Add("@grouplongdesc", grouplongdesc);
                //cmd.Parameters.Add("@subgroupcode", subgroupcode);
                cmd.Parameters.Add("@schedule", schedule);
                cmd.Parameters.Add("@orders", order);
                cmd.Parameters.Add("@addless", addless);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update groupledgermaster set primarygroupcode=@primarygroupcode,groupcode=@groupcode,groupshortdesc=@groupshortdesc,schedule=@schedule,orders=@orders,addless=@addless,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@primarygroupcode", primarygroup);
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@groupshortdesc", groupshortdesc);
               // cmd.Parameters.Add("@grouplongdesc", grouplongdesc);
               // cmd.Parameters.Add("@subgroupcode", subgroupcode);
                cmd.Parameters.Add("@schedule", schedule);
                cmd.Parameters.Add("@orders", order);
                cmd.Parameters.Add("@addless", addless);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class groupledger
    {
        public string primarygroup { get; set; }
        public string groupcode { get; set; }
        public string groupshortdesc { get; set; }
        public string grouplongdesc { get; set; }
        public string subgroupcode { get; set; }
        public string schedule { get; set; }
        public string order { get; set; }
        public string addless { get; set; }
        public string sno { get; set; }
        public string primarygroupid { get; set; }
        public string shortdesc { get; set; }

        public string groupledgercode { get; set; }

        public string groupledgerid { get; set; }

        public string subgroup { get; set; }
    }

    private void get_group_ledger(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT   groupledgermaster.sno, groupledgermaster.primarygroupcode, groupledgermaster.groupcode, groupledgermaster.groupshortdesc,   groupledgermaster.grouplongdesc, groupledgermaster.subgroupcode, groupledgermaster.schedule, groupledgermaster.orders, groupledgermaster.addless,  groupledgermaster.doe, groupledgermaster.createdby, primarygroup.groupcode AS primarygroupid, primarygroup.shortdesc FROM  groupledgermaster INNER JOIN  primarygroup ON groupledgermaster.primarygroupcode = primarygroup.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<groupledger> ledgerlist = new List<groupledger>();
            foreach (DataRow dr in routes.Rows)
            {
                groupledger getgroupledger = new groupledger();
                getgroupledger.primarygroup = dr["primarygroupid"].ToString();
                getgroupledger.primarygroupid = dr["primarygroupcode"].ToString();
                getgroupledger.shortdesc = dr["shortdesc"].ToString();
                getgroupledger.groupcode = dr["groupcode"].ToString();
                getgroupledger.groupshortdesc = dr["groupshortdesc"].ToString();
                getgroupledger.grouplongdesc = dr["grouplongdesc"].ToString();
                getgroupledger.subgroupcode = dr["subgroupcode"].ToString();
                getgroupledger.schedule = dr["schedule"].ToString();
                getgroupledger.order = dr["orders"].ToString();
                getgroupledger.addless = dr["addless"].ToString();
                getgroupledger.sno = dr["sno"].ToString();
                ledgerlist.Add(getgroupledger);
            }
            string response = GetJson(ledgerlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_reason_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string reasoncode = context.Request["reasoncode"];
            string Department = context.Request["Department"];
            string section = context.Request["section"];
            string reason = context.Request["reason"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into reasonmaster (reasoncode,reason,department,section,doe,createdby) values (@reasoncode,@reason,@department,@section,@doe,@createdby)");
                cmd.Parameters.Add("@reasoncode", reasoncode);
                cmd.Parameters.Add("@reason", reason);
                cmd.Parameters.Add("@department", Department);
                cmd.Parameters.Add("@section", section);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update reasonmaster set reasoncode=@reasoncode,reason=@reason,department=@department,section=@section,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@reasoncode", reasoncode);
                cmd.Parameters.Add("@reason", reason);
                cmd.Parameters.Add("@department", Department);
                cmd.Parameters.Add("@section", section);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class reasonmaster
    {
        public string rcode { get; set; }
        public string section { get; set; }
        public string reason { get; set; }
        public string deptid { get; set; }
        public string deptname { get; set; }
        public string sno { get; set; }
        public string department { get; set; }
        public string section1 { get; set; }
        public string departmentcode { get; set; }
    }

    private void get_reason_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  reasonmaster.sno, reasonmaster.reasoncode, reasonmaster.reason, reasonmaster.department, reasonmaster.section, reasonmaster.doe, reasonmaster.createdby, DepartmentDetails.DepartmentCode,  Departmentdetails.DepartmentName FROM  reasonmaster INNER JOIN  Departmentdetails ON reasonmaster.department = Departmentdetails.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<reasonmaster> monthlist = new List<reasonmaster>();
            foreach (DataRow dr in routes.Rows)
            {
                reasonmaster getmonthdetail = new reasonmaster();
                getmonthdetail.rcode = dr["reasoncode"].ToString();
                getmonthdetail.deptid = dr["department"].ToString();
                getmonthdetail.department = dr["DepartmentName"].ToString();
                getmonthdetail.departmentcode = dr["DepartmentCode"].ToString();
                getmonthdetail.reason = dr["reason"].ToString();
                string section = dr["section"].ToString();
                if (section == "A")
                {
                    section = "accounts";
                }
                else if (section == "I")
                {
                    section = "IT";
                }
                getmonthdetail.section = section;
                getmonthdetail.section1 = dr["section"].ToString();
                getmonthdetail.deptname = dr["DepartmentName"].ToString();
                getmonthdetail.sno = dr["sno"].ToString();
                monthlist.Add(getmonthdetail);
            }
            string response = GetJson(monthlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    //public class fam_tax_per
    //{
    //    public string taxcode { get; set; }
    //    public string taxcodetype { get; set; }
    //    public string rangefrom { get; set; }
    //    public string rangeto { get; set; }
    //    public string percent { get; set; }
    //    public string effFrom { get; set; }
    //    public string effTo { get; set; }
    //    public string status { get; set; }
    //    public string createdby { get; set; }
    //    public string createdon { get; set; }
    //    public string modifiedby { get; set; }
    //    public string modifiedon { get; set; }
    //    public string doe { get; set; }
    //    public string sno { get; set; }
    //    public string btn_val { get; set; }
    //    public List<fam_tax_per_gl_code> DataTable1 { get; set; }
    //    public List<fam_tax_per_other> DataTable { get; set; }
    //}

    //public class fam_tax_per_other
    //{

    //    public string code { get; set; }
    //    public string desc { get; set; }
    //    public string code_ledger { get; set; }
    //    public string desc_ledger { get; set; }
    //    public string tab_percent { get; set; }
    //    public string createdby { get; set; }
    //    public string createdon { get; set; }
    //    public string modifiedby { get; set; }
    //    public string modifiedon { get; set; }
    //    public string doe { get; set; }
    //    public string sno { get; set; }

    //}

    //public class fam_tax_per_gl_code
    //{

    //    public string sno1 { get; set; }
    //    public string code1 { get; set; }
    //    public string desc1 { get; set; }
    //    public string code_ledger1 { get; set; }
    //    public string desc_ledger1 { get; set; }
    //    public string createdby { get; set; }
    //    public string createdon { get; set; }
    //    public string modifiedby { get; set; }
    //    public string modifiedon { get; set; }
    //    public string doe { get; set; }

    //}

    //public class get_tax_det
    //{
    //    public List<fam_tax_per> tax_per1 { get; set; }
    //    public List<fam_tax_per_gl_code> tax_per_gl_code1 { get; set; }
    //    public List<fam_tax_per_other> tax_per_other1 { get; set; }
    //}

    
    //private void get_tax_per_other_details(HttpContext context)
    //{
    //    try
    //    {
    //        vdm = new VehicleDBMgr();
    //        string sno = context.Request["refno"].ToString();
    //        cmd = new SqlCommand("SELECT sno, code, description, glcodefor_ledger_posting, percentage, createdby, createdon FROM fam_tax_per_other WHERE refno=@refno");
    //        cmd.Parameters.Add("@refno", sno);
    //        DataTable routes = vdm.SelectQuery(cmd).Tables[0];
    //        List<fam_tax_per_other> paymentdetailslist = new List<fam_tax_per_other>();
    //        foreach (DataRow dr in routes.Rows)
    //        {
    //            fam_tax_per_other getpaymentdetails = new fam_tax_per_other();
    //            getpaymentdetails.code = dr["code"].ToString();
    //            getpaymentdetails.desc = dr["description"].ToString();
    //            getpaymentdetails.code_ledger = dr["glcodefor_ledger_posting"].ToString();
    //            getpaymentdetails.createdby = dr["createdby"].ToString();
    //            //   getpaymentdetails.createdby = dr["createdby"].ToString();
    //            getpaymentdetails.createdon = dr["createdon"].ToString();
    //            getpaymentdetails.tab_percent = dr["percentage"].ToString();
    //            getpaymentdetails.sno = dr["sno"].ToString();
    //            paymentdetailslist.Add(getpaymentdetails);
    //        }
    //        string response = GetJson(paymentdetailslist);
    //        context.Response.Write(response);
    //    }
    //    catch (Exception ex)
    //    {
    //        string Response = GetJson(ex.Message);
    //        context.Response.Write(Response);
    //    }
    //}

    ////private void get_tax_per_glcode_details(HttpContext context)
    //{
    //    try
    //    {
    //        vdm = new VehicleDBMgr();
    //        string sno = context.Request["refno"].ToString();
    //        cmd = new SqlCommand("SELECT sno, glcode, description, glcoeforledger_posting,createdby,createdon FROM fam_tax_for_glcode WHERE refno=@refno");
    //        cmd.Parameters.Add("@refno", sno);
    //        DataTable routes = vdm.SelectQuery(cmd).Tables[0];
    //        List<fam_tax_per_gl_code> paymentdetailslist = new List<fam_tax_per_gl_code>();
    //        foreach (DataRow dr in routes.Rows)
    //        {
    //            fam_tax_per_gl_code getpaymentdetails = new fam_tax_per_gl_code();
    //            getpaymentdetails.code1 = dr["glcode"].ToString();
    //            getpaymentdetails.desc1 = dr["description"].ToString();
    //            getpaymentdetails.code_ledger1 = dr["glcoeforledger_posting"].ToString();
    //            getpaymentdetails.createdby = dr["createdby"].ToString();
    //            getpaymentdetails.createdon = dr["createdon"].ToString();
    //            getpaymentdetails.sno1 = dr["sno"].ToString();
    //            //getpaymentdetails.sno1 = dr["sno"].ToString();
    //            paymentdetailslist.Add(getpaymentdetails);
    //        }
    //        string response = GetJson(paymentdetailslist);
    //        context.Response.Write(response);
    //    }
    //    catch (Exception ex)
    //    {
    //        string Response = GetJson(ex.Message);
    //        context.Response.Write(Response);
    //    }
    //}
    //public class get_tax_det
    //{
    //    public List<fam_tax_per> tax_per1 { get; set; }
    //    public List<fam_tax_per_gl_code> tax_per_gl_code1 { get; set; }
    //    public List<fam_tax_per_other> tax_per_other1 { get; set; }
    //}

    //public class taxDet
    //{
    //    public string tax_code { get; set; } 
    //    public string description { get; set; } 

    //} 

    //private void get_tax1_details(HttpContext context)
    //{
    //    try
    //    {
    //        vdm = new VehicleDBMgr();
    //        cmd = new SqlCommand("SELECT taxtypecode,description FROM fam_tax_types");
    //        DataTable routes = vdm.SelectQuery(cmd).Tables[0];
    //        List<taxDet> Departmentslst = new List<taxDet>();
    //        foreach (DataRow dr in routes.Rows)
    //        {
    //            taxDet getdepts = new taxDet();
    //            getdepts.description = dr["description"].ToString();
    //            getdepts.tax_code = dr["taxtypecode"].ToString();
    //            Departmentslst.Add(getdepts);
    //        }
    //        string response = GetJson(Departmentslst);
    //        context.Response.Write(response);
    //    }
    //    catch (Exception ex)
    //    {
    //        string Response = GetJson(ex.Message);
    //        context.Response.Write(Response);
    //    }
    //}
    public void save_party_type_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();

            string partytype = context.Request["partytype"];
            string description = context.Request["description"];
            string glcodeType = context.Request["glcodeid"];
            string glcode = context.Request["glcode"];
            string btn_save = context.Request["btn_val"];
            string UserName = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into fam_party_type (party_tp,short_desc,gl_code,group_cd,createdby,createddate,doe) values (@partytype,@description,@glcodeType,@glcode,@createdby,@createddate,@doe)");
                cmd.Parameters.Add("@partytype", partytype);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@glcodeType", glcodeType);
                cmd.Parameters.Add("@createddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Party Type details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("Update fam_party_type set short_desc=@description,gl_code=@glcodeType,group_cd=@glcode,createdby=@createdby,createddate=@createddate,modifiedby=@modifiedby,modifieddate=@modifieddate,doe=@doe where PARTY_TP=@partytype");
                cmd.Parameters.Add("@partytype", partytype);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@glcodeType", glcodeType);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@createddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@modifiedby", UserName);
                cmd.Parameters.Add("@modifieddate", ServerDateCurrentdate);
                vdm.Update(cmd);
                string msg = "Party Type details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class PartyType
    {
        public string PARTY_TP { get; set; }
        public string SHORT_DESC { get; set; }
        public string GL_CODE { get; set; }
        public string GROUP_CD { get; set; }
        public string createdby { get; set; }
        public string createddate { get; set; }
        public string modifiedby { get; set; }
        public string modifieddate { get; set; }
        public string groupcode { get; set; }
        public string doe { get; set; }
        public string sno { get; set; }
        public string groupdesc { get; set; }
    }
    private void get_party_type_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  fam_party_type.sno, fam_party_type.party_tp, fam_party_type.short_desc, fam_party_type.gl_code, fam_party_type.group_cd, fam_party_type.createdby, fam_party_type.createddate,fam_party_type.modifiedby, fam_party_type.modifieddate, fam_party_type.doe, groupledgermaster.groupcode, groupledgermaster.groupshortdesc FROM  fam_party_type INNER JOIN groupledgermaster ON fam_party_type.gl_code = groupledgermaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<PartyType> companyMasterlist = new List<PartyType>();
            foreach (DataRow dr in routes.Rows)
            {
                PartyType getcompanydetails = new PartyType();
                getcompanydetails.sno = dr["sno"].ToString();
                getcompanydetails.PARTY_TP = dr["PARTY_TP"].ToString();
                getcompanydetails.SHORT_DESC = dr["SHORT_DESC"].ToString();
                getcompanydetails.GL_CODE = dr["GL_CODE"].ToString();
                getcompanydetails.GROUP_CD = dr["GROUP_CD"].ToString();
                getcompanydetails.groupcode = dr["groupcode"].ToString();
                getcompanydetails.groupdesc = dr["groupshortdesc"].ToString();
                companyMasterlist.Add(getcompanydetails);
            }
            string response = GetJson(companyMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class PartyType1
    {
        public string sno { get; set; }
        public string party_tp { get; set; }
        public string short_desc { get; set; }
        public string gl_code { get; set; }
        public string group_cd { get; set; }
        public string createdby { get; set; }
        public string createddate { get; set; }
        public string modifiedby { get; set; }
        public string modifieddate { get; set; }
        public string doe { get; set; }

    }
    private void get_party_type1_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,party_tp,short_desc,createdby,createddate,modifiedby,modifieddate,doe FROM fam_party_type");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<PartyType1> companyMasterlist = new List<PartyType1>();
            foreach (DataRow dr in routes.Rows)
            {
                PartyType1 getcompanydetails = new PartyType1();
                getcompanydetails.sno = dr["sno"].ToString();
                getcompanydetails.party_tp = dr["party_tp"].ToString();
                getcompanydetails.short_desc = dr["short_desc"].ToString();
                getcompanydetails.createdby = dr["createdby"].ToString();
                getcompanydetails.createddate = dr["createddate"].ToString();
                getcompanydetails.modifiedby = dr["modifiedby"].ToString();
                getcompanydetails.modifieddate = dr["modifieddate"].ToString();
                getcompanydetails.doe = dr["doe"].ToString();

                companyMasterlist.Add(getcompanydetails);
            }
            string response = GetJson(companyMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_tax_type_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();

            string taxtype = context.Request["taxtype"];
            string description = context.Request["description"];
            string sno = context.Request["sno"];
            string btn_save = context.Request["btn_val"];
            string UserName = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into fam_tax_types (taxtypecode,description,createdby,createddate,doe) values (@taxtype,@description,@createdby,@createddate,@doe)");
                cmd.Parameters.Add("@taxtype", taxtype);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@createddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                //cmd.Parameters.Add("@glcode", glcode);
                vdm.insert(cmd);
                string msg = "Party Type details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string CompanyCode = context.Request["CompanyCode"];
                cmd = new SqlCommand("Update fam_tax_types set description=@description,modifiedby=@modifiedby,modifieddate=@modifieddate,taxtypecode=@taxtype where sno=@sno");
                cmd.Parameters.Add("@taxtype", taxtype);
                cmd.Parameters.Add("@description", description);
                //cmd.Parameters.Add("@createddate", ServerDateCurrentdate);
                //cmd.Parameters.Add("@createdby", UserName);
                //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@modifiedby", UserName);
                cmd.Parameters.Add("@modifieddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Party Type details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class TaxType
    {
        public string TAX_TYPE { get; set; }
        public string DESCRIPTION { get; set; }
        //public string createdby { get; set; }
        //public string createddate { get; set; }
        //public string modifiedby { get; set; }
        //public string modifieddate { get; set; }
        //public string doe { get; set; }
        public string sno { get; set; }

    }
    private void get_tax_type_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno, taxtypecode,description,createdby,createddate,modifiedby,modifieddate,doe FROM fam_tax_types");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<TaxType> companyMasterlist = new List<TaxType>();
            foreach (DataRow dr in routes.Rows)
            {
                TaxType getcompanydetails = new TaxType();
                getcompanydetails.TAX_TYPE = dr["taxtypecode"].ToString();
                getcompanydetails.DESCRIPTION = dr["description"].ToString();
                //getcompanydetails.createdby = dr["createdby"].ToString();
                //getcompanydetails.createddate = dr["createddate"].ToString();
                //getcompanydetails.modifiedby = dr["modifiedby"].ToString();
                //getcompanydetails.modifieddate = dr["modifieddate"].ToString();
                //getcompanydetails.doe = dr["doe"].ToString();
                getcompanydetails.sno = dr["sno"].ToString();
                companyMasterlist.Add(getcompanydetails);
            }
            string response = GetJson(companyMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    //public class taxDet
    //{
    //    public string tax_code { get; set; }
    //    public string description { get; set; }

    //}
    private void get_tax_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT tp.sno,tp.groupcode as groupid,g.groupcode,g.groupshortdesc,tp.taxtype,t.taxtypecode,t.description, tp.rangefrom, tp.rangeto, tp.percentage, tp.fromdate, tp.todate,tp.status FROM fam_tax_per tp join groupledgermaster g on tp.groupcode=g.sno join fam_tax_types t on tp.taxtype=t.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fam_tax_per> paymentdetailslist = new List<fam_tax_per>();
            foreach (DataRow dr in routes.Rows)
            {
                fam_tax_per getpaymentdetails = new fam_tax_per();
                getpaymentdetails.groupcode = dr["groupcode"].ToString();
                getpaymentdetails.groupcodesno = dr["groupid"].ToString();
                getpaymentdetails.groupcodedesc = dr["groupshortdesc"].ToString();
                getpaymentdetails.taxcodesno = dr["taxtype"].ToString();
                getpaymentdetails.taxcode = dr["taxtypecode"].ToString();
                getpaymentdetails.taxcodedesc = dr["description"].ToString();
                getpaymentdetails.rangefrom = dr["rangefrom"].ToString();
                getpaymentdetails.rangeto = dr["rangeto"].ToString();
                getpaymentdetails.percent = dr["percentage"].ToString();
                getpaymentdetails.effFrom = ((DateTime)dr["fromdate"]).ToString("yyyy-MM-dd");
                getpaymentdetails.effTo = ((DateTime)dr["todate"]).ToString("yyyy-MM-dd");
                //getpaymentdetails.status = dr["status"].ToString();
                string statuscode = dr["status"].ToString();
                if (statuscode == "A")
                {
                    getpaymentdetails.status = "Active";
                }
                else
                {
                    getpaymentdetails.status = "InActive";
                }
                //getpaymentdetails.doe = dr["doe"].ToString();
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class fam_tax_per
    {
        public string groupcode { get; set; }
        public string groupcodedesc { get; set; }
        public string groupcodesno { get; set; }
        public string taxcode { get; set; }
        public string taxcodedesc { get; set; }
        public string taxcodesno { get; set; }
        public string rangefrom { get; set; }
        public string rangeto { get; set; }
        public string percent { get; set; }
        public string effFrom { get; set; }
        public string effTo { get; set; }
        public string status { get; set; }
        public string sno { get; set; }
        public string btn_val { get; set; }
    }

    private void save_tax_percent_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            fam_tax_per obj = js.Deserialize<fam_tax_per>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string taxcode = obj.taxcode;
            string groupcode = obj.groupcode;
            string rangefrom = obj.rangefrom;
            string rangeto = obj.rangeto;
            string percent = obj.percent;

            DateTime effFrom = Convert.ToDateTime(obj.effFrom);
            DateTime effTo = Convert.ToDateTime(obj.effTo);
            string status = obj.status;
            string btn_save = obj.btn_val;

            if (btn_save == "Save")
            {

                cmd = new SqlCommand("insert into fam_tax_per (groupcode,taxtype,rangefrom,rangeto,percentage,fromdate,todate,status,createdby,createdon,doe) values (@groupcode,@taxcode,@rangefrom,@rangeto,@percent,@effFrom,@effTo,@status,@createdby,@doe,@doe)");
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@taxcode", taxcode);
                cmd.Parameters.Add("@rangefrom", rangefrom);
                cmd.Parameters.Add("@rangeto", rangeto);
                cmd.Parameters.Add("@percent", percent);
                cmd.Parameters.Add("@effFrom", effFrom);
                cmd.Parameters.Add("@effTo", effTo);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);

                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {

                string Sno = obj.sno;
                //taxtype,rangefrom,rangeto,percentage,fromdate,todate,status,createdby,createdon,doe
                cmd = new SqlCommand("UPDATE fam_tax_per SET groupcode=@groupcode,taxtype=@taxcode,rangefrom=@rangefrom,rangeto=@rangeto,percentage=@percent,fromdate=@effFrom,todate=@effTo, status=@status,createdby=@createdby,createdon=@doe,modifiedby=@createdby,modifiedon=@doe,doe=@doe WHERE sno=@sno");
                cmd.Parameters.Add("@taxcode", taxcode);
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@rangefrom", rangefrom);
                cmd.Parameters.Add("@rangeto", rangeto);
                cmd.Parameters.Add("@percent", percent);
                cmd.Parameters.Add("@effFrom", effFrom);
                cmd.Parameters.Add("@effTo", effTo);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@sno", Sno);
                vdm.Update(cmd);


                string msg = "successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class partywisebg
    {
        public string groupcode1 { get; set; }
        public string groupname1 { get; set; }
        public string partycode1 { get; set; }
        public string partyname1 { get; set; }
        public string btnval { get; set; }
        public string groupid1 { get; set; }
        public string partyid1 { get; set; }
        public string sno { get; set; }
        public string doe { get; set; }
        public string number { get; set; }
        public List<partywisebgsub> bgfdr_array { get; set; }
    }
    public class getpartywisebg
    {
        public List<partywisebg> partywisebg { get; set; }
        public List<partywisebgsub> partywisebgsub { get; set; }
    }
    public class partywisebgsub
    {
        public string type { get; set; }
        public string number { get; set; }
        public string value { get; set; }
        public string bgdate { get; set; }
        public string effective { get; set; }
        public string expireydate { get; set; }
        public string remarks { get; set; }
        public string sno { get; set; }

    }
    private void save_bg_click(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            partywisebg obj = js.Deserialize<partywisebg>(title1);
            string groupcode1 = obj.groupcode1.TrimEnd();
            string groupid1 = obj.groupid1.TrimEnd();
            string groupname1 = obj.groupname1.TrimEnd();
            string partycode1 = obj.partycode1.TrimEnd();
            string partyid1 = obj.partyid1.TrimEnd();
            string partyname1 = obj.partyname1.TrimEnd();
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                foreach (partywisebgsub es in obj.bgfdr_array)
                {
                    cmd = new SqlCommand("insert into bg_fdr_details (groupcode,partycode,type,bgfdrno,value,bgfdrdate,effectivefrom,expirydate,remarks,doe,createdby) values (@groupcode,@partycode,@type,@bgfdrno,@value,@bgfdrdate,@effectivefrom,@expirydate,@remarks,@doe,@createdby)");
                    //groupcode,partycode,type,bgfdrno,value,bgfdrdate,effectivefrom,expirydate,remarks,doe,createdby
                    cmd.Parameters.Add("@groupcode", groupid1);
                    cmd.Parameters.Add("@partycode", partyid1);
                    cmd.Parameters.Add("@type", es.type);
                    cmd.Parameters.Add("@bgfdrno", es.number);
                    cmd.Parameters.Add("@value", es.value);
                    cmd.Parameters.Add("@bgfdrdate", es.bgdate);
                    cmd.Parameters.Add("@effectivefrom", es.effective);
                    cmd.Parameters.Add("@expirydate", es.expireydate);
                    cmd.Parameters.Add("@remarks", es.remarks);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    vdm.insert(cmd);
                }
                string response = GetJson("Insert Successfully");
                context.Response.Write(response);
            }
            else
            {
                foreach (partywisebgsub es in obj.bgfdr_array)
                {
                    string sno = es.sno;
                    //groupcode,partycode,type,bgfdrno,value,bgfdrdate,effectivefrom,expirydate,remarks,doe,createdby
                    cmd = new SqlCommand("Update bg_fdr_details set groupcode=@groupcode,partycode=@partycode,type=@type,bgfdrno=@bgfdrno,value=@value,bgfdrdate=@bgfdrdate,effectivefrom=@effectivefrom,expirydate=@expirydate,remarks=@remarks,doe=@doe,createdby=@createdby where sno=@sno");
                    cmd.Parameters.Add("@groupcode", groupid1);
                    cmd.Parameters.Add("@partycode", partyid1);
                    cmd.Parameters.Add("@type", es.type);
                    cmd.Parameters.Add("@bgfdrno", es.number);
                    cmd.Parameters.Add("@value", es.value);
                    cmd.Parameters.Add("@bgfdrdate", es.bgdate);
                    cmd.Parameters.Add("@effectivefrom", es.effective);
                    cmd.Parameters.Add("@expirydate", es.expireydate);
                    cmd.Parameters.Add("@remarks", es.remarks);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", sno);
                    if (vdm.Update(cmd) == 0)
                    {

                        cmd = new SqlCommand("insert into bg_fdr_details (groupcode,partycode,type,bgfdrno,value,bgfdrdate,effectivefrom,expirydate,remarks,doe,createdby) values (@groupcode,@partycode,@type,@bgfdrno,@value,@bgfdrdate,@effectivefrom,@expirydate,@remarks,@doe,@createdby)");
                        //groupcode,partycode,type,bgfdrno,value,bgfdrdate,effectivefrom,expirydate,remarks,doe,createdby
                        cmd.Parameters.Add("@groupcode", groupid1);
                        cmd.Parameters.Add("@partycode", partyid1);
                        cmd.Parameters.Add("@type", es.type);
                        cmd.Parameters.Add("@bgfdrno", es.number);
                        cmd.Parameters.Add("@value", es.value);
                        cmd.Parameters.Add("@bgfdrdate", es.bgdate);
                        cmd.Parameters.Add("@effectivefrom", es.effective);
                        cmd.Parameters.Add("@expirydate", es.expireydate);
                        cmd.Parameters.Add("@remarks", es.remarks);
                        cmd.Parameters.Add("@createdby", createdby);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        vdm.insert(cmd);

                    }
                }
                string response = GetJson("update Successfully");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }
    private void get_party_typebg_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  bg_fdr_details.sno, bg_fdr_details.groupcode, bg_fdr_details.partycode, bg_fdr_details.type, bg_fdr_details.bgfdrno, bg_fdr_details.value, bg_fdr_details.bgfdrdate, bg_fdr_details.effectivefrom, bg_fdr_details.expirydate, bg_fdr_details.remarks, bg_fdr_details.doe, bg_fdr_details.createdby, partymaster.partycode AS partyid, partymaster.partyname, primarygroup.groupcode AS Expr1, primarygroup.shortdesc FROM   bg_fdr_details INNER JOIN primarygroup ON bg_fdr_details.sno = primarygroup.sno LEFT OUTER JOIN partymaster ON bg_fdr_details.partycode = partymaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttds = view.ToTable(true, "sno", "Expr1", "partyid", "groupcode", "shortdesc", "partycode", "partyname", "bgfdrno", "doe");
            DataTable dttdssub = view.ToTable(true, "sno", "type", "bgfdrno", "value", "bgfdrdate", "effectivefrom", "expirydate", "remarks", "doe");
            List<getpartywisebg> getpartywise = new List<getpartywisebg>();
            List<partywisebg> getpartywisetds = new List<partywisebg>();
            List<partywisebgsub> getpartywisetdssub = new List<partywisebgsub>();
            foreach (DataRow dr in dttds.Rows)
            {
                partywisebg gettds = new partywisebg();
                // getemployee.sno = dr["sno"].ToString();
                gettds.groupcode1 = dr["groupcode"].ToString();
                gettds.groupname1 = dr["shortdesc"].ToString();
                gettds.partycode1 = dr["partycode"].ToString();
                gettds.partyname1 = dr["partyname"].ToString();
                gettds.number = dr["bgfdrno"].ToString();
                gettds.sno = dr["sno"].ToString();
                gettds.groupid1 = dr["Expr1"].ToString();
                gettds.partyid1 = dr["partyid"].ToString();
                gettds.doe = dr["doe"].ToString();
                getpartywisetds.Add(gettds);
            }
            foreach (DataRow dr in dttdssub.Rows)
            {
                partywisebgsub gettdssub = new partywisebgsub();
                gettdssub.type = dr["type"].ToString();
                gettdssub.number = dr["bgfdrno"].ToString();
                gettdssub.value = dr["value"].ToString();
                gettdssub.bgdate = ((DateTime)dr["bgfdrdate"]).ToString("yyyy-MM-dd"); //dr["receiveddate"].ToString(); //((DateTime)dr["relationdob"]).ToString("yyyy-MM-dd"); //
                gettdssub.effective = dr["effectivefrom"].ToString();
                gettdssub.expireydate = ((DateTime)dr["expirydate"]).ToString("yyyy-MM-dd");
                gettdssub.remarks = dr["remarks"].ToString();
                gettdssub.sno = dr["sno"].ToString();
                getpartywisetdssub.Add(gettdssub);
            }
            getpartywisebg getemployeeDatas = new getpartywisebg();
            getemployeeDatas.partywisebg = getpartywisetds;
            getemployeeDatas.partywisebgsub = getpartywisetdssub;
            getpartywise.Add(getemployeeDatas);
            string response = GetJson(getpartywise);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class partywisebank
    {
        public string groupcode2 { get; set; }
        public string groupname2 { get; set; }
        public string partycode2 { get; set; }
        public string partyname2 { get; set; }
        public string btnval { get; set; }
        public string accountno { get; set; }
        public string sno { get; set; }
        public string groupid2 { get; set; }
        public string partyid2 { get; set; }
        public string doe { get; set; }
        public string longdesc { get; set; }
        public List<partywisebanksub> bank_array { get; set; }

    }
    public class getpartywisebank
    {
        public List<partywisebank> partywisebank { get; set; }
        public List<partywisebanksub> partywisebanksub { get; set; }
    }
    public class partywisebanksub
    {
        public string bankcode { get; set; }
        public string bankname { get; set; }
        public string branchcode { get; set; }
        public string branchname { get; set; }
        public string accno { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string sno { get; set; }
        public string bankid { get; set; }
        public string branchid { get; set; }

    }
    private void save_Bank_Details(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            partywisebank obj = js.Deserialize<partywisebank>(title1);
            string groupcode2 = obj.groupcode2.TrimEnd();
            string groupname2 = obj.groupname2.TrimEnd();
            string partycode2 = obj.partycode2.TrimEnd();
            string groupid2 = obj.groupid2.TrimEnd();
            string partyname2 = obj.partyname2.TrimEnd();
            string partyid2 = obj.partyid2.TrimEnd();
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                foreach (partywisebanksub es in obj.bank_array)
                {
                    cmd = new SqlCommand("insert into bg_fdr_bankdetails (groupcode,partycode,bankcode,branchcode,accountno,fromdate,todate,doe,createdby) values (@groupcode,@partycode,@bankcode,@branchcode,@accountno,@fromdate,@todate,@doe,@createdby)");
                    //groupcode,partycode,bankcode,branchcode,accountno,fromdate,todate,doe,createdby
                    cmd.Parameters.Add("@groupcode", groupid2);
                    cmd.Parameters.Add("@partycode", partyid2);
                    cmd.Parameters.Add("@bankcode", es.bankid);
                    cmd.Parameters.Add("@branchcode", es.branchid);
                    cmd.Parameters.Add("@accountno", es.accno);
                    cmd.Parameters.Add("@fromdate", es.fromdate);
                    cmd.Parameters.Add("@todate", es.todate);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    vdm.insert(cmd);
                }
                string response = GetJson("Insert Successfully");
                context.Response.Write(response);
            }
            else
            {
                foreach (partywisebanksub es in obj.bank_array)
                {
                    string sno = es.sno;
                    //groupcode,partycode,bankcode,branchcode,accountno,fromdate,todate,doe,createdby
                    cmd = new SqlCommand("Update bg_fdr_bankdetails set groupcode=@groupcode,partycode=@partycode,bankcode=@bankcode,branchcode=@branchcode,accountno=@accountno,fromdate=@fromdate,todate=@todate,doe=@doe,createdby=@createdby where sno=@sno");
                    cmd.Parameters.Add("@groupcode", groupid2);
                    cmd.Parameters.Add("@partycode", partyid2);
                    cmd.Parameters.Add("@bankcode", es.bankid);
                    cmd.Parameters.Add("@branchcode", es.branchid);
                    cmd.Parameters.Add("@accountno", es.accno);
                    cmd.Parameters.Add("@fromdate", es.fromdate);
                    cmd.Parameters.Add("@todate", es.todate);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", sno);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into bg_fdr_bankdetails (groupcode,partycode,bankcode,branchcode,accountno,fromdate,todate,doe,createdby) values (@groupcode,@partycode,@bankcode,@branchcode,@accountno,@fromdate,@todate,@doe,@createdby)");
                        //groupcode,partycode,bankcode,branchcode,accountno,fromdate,todate,doe,createdby
                        cmd.Parameters.Add("@groupcode", groupid2);
                        cmd.Parameters.Add("@partycode", partyid2);
                        cmd.Parameters.Add("@bankcode", es.bankid);
                        cmd.Parameters.Add("@branchcode", es.branchid);
                        cmd.Parameters.Add("@accountno", es.accno);
                        cmd.Parameters.Add("@fromdate", es.fromdate);
                        cmd.Parameters.Add("@todate", es.todate);
                        cmd.Parameters.Add("@createdby", createdby);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        vdm.insert(cmd);

                    }
                }
                string response = GetJson("update Successfully");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }

    private void get_party_typebank_details(HttpContext context)
    
    {
        try
        {
            vdm = new VehicleDBMgr();
            //cmd = new SqlCommand("SELECT    bg_fdr_bankdetails.sno, bg_fdr_bankdetails.groupcode,primarygroup.shortdesc, bg_fdr_bankdetails.partycode, bg_fdr_bankdetails.bankcode, bg_fdr_bankdetails.branchcode, bg_fdr_bankdetails.accountno, bg_fdr_bankdetails.fromdate, bg_fdr_bankdetails.todate, bg_fdr_bankdetails.doe, bg_fdr_bankdetails.createdby, bankmaster.bankname, bankmaster.code, ifscmaster.ifsccode, ifscmaster.branchname, primarygroup.groupcode AS Expr1, partymaster.partycode AS Expr2, partymaster.partyname FROM  bg_fdr_bankdetails LEFT OUTER JOIN bankmaster ON bg_fdr_bankdetails.bankcode = bankmaster.code LEFT OUTER JOIN ifscmaster ON bg_fdr_bankdetails.branchcode = ifscmaster.ifsccode LEFT OUTER JOIN primarygroup ON bg_fdr_bankdetails.groupcode = primarygroup.sno LEFT OUTER JOIN partymaster ON bg_fdr_bankdetails.partycode = partymaster.sno");
            cmd = new SqlCommand("SELECT  bg_fdr_bankdetails.sno, bg_fdr_bankdetails.groupcode, bg_fdr_bankdetails.partycode, bg_fdr_bankdetails.bankcode, bg_fdr_bankdetails.branchcode, bg_fdr_bankdetails.accountno, bg_fdr_bankdetails.fromdate, bg_fdr_bankdetails.todate, bg_fdr_bankdetails.doe, bg_fdr_bankdetails.createdby, primarygroup.shortdesc, primarygroup.longdesc, partymaster.partycode AS Expr1, partymaster.partyname, bankmaster.code, bankmaster.bankname, ifscmaster.ifsccode, ifscmaster.branchname FROM  bg_fdr_bankdetails INNER JOIN primarygroup ON bg_fdr_bankdetails.groupcode = primarygroup.sno INNER JOIN partymaster ON bg_fdr_bankdetails.partycode = partymaster.sno INNER JOIN bankmaster ON bg_fdr_bankdetails.bankcode = bankmaster.sno INNER JOIN ifscmaster ON bg_fdr_bankdetails.branchcode = ifscmaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttds = view.ToTable(true, "sno", "groupcode","partycode","shortdesc","longdesc","Expr1","partyname","accountno");
            DataTable dttdssub = view.ToTable(true, "sno","bankcode","branchcode", "code", "bankname", "ifsccode", "branchname", "accountno", "fromdate", "todate", "doe");
            List<getpartywisebank> getpartywise = new List<getpartywisebank>();
            List<partywisebank> getpartywisetds = new List<partywisebank>();
            List<partywisebanksub> getpartywisetdssub = new List<partywisebanksub>();
            foreach (DataRow dr in dttds.Rows)
            {
                partywisebank gettds = new partywisebank();
                // getemployee.sno = dr["sno"].ToString();
                gettds.groupcode2 = dr["shortdesc"].ToString();
                gettds.groupname2 = dr["longdesc"].ToString();
                gettds.partycode2 = dr["partyname"].ToString();
                gettds.partyname2 = dr["Expr1"].ToString();
                gettds.accountno = dr["accountno"].ToString();
                gettds.sno = dr["sno"].ToString();
                gettds.groupid2 = dr["groupcode"].ToString();
                gettds.partyid2 = dr["partycode"].ToString();
                //gettds.doe = dr["doe"].ToString();
                gettds.longdesc = dr["longdesc"].ToString();
                getpartywisetds.Add(gettds);
            }
            foreach (DataRow dr in dttdssub.Rows)
            {
                partywisebanksub gettdssub = new partywisebanksub();
                gettdssub.bankid = dr["bankcode"].ToString();
                gettdssub.branchid = dr["branchcode"].ToString();
                gettdssub.bankcode = dr["code"].ToString();
                gettdssub.bankname = dr["bankname"].ToString();
                gettdssub.branchcode = dr["ifsccode"].ToString();
                gettdssub.branchname = dr["branchname"].ToString();
                gettdssub.fromdate = ((DateTime)dr["fromdate"]).ToString("yyyy-MM-dd"); //dr["receiveddate"].ToString(); //((DateTime)dr["relationdob"]).ToString("yyyy-MM-dd"); //
                gettdssub.sno = dr["sno"].ToString();
                gettdssub.todate = ((DateTime)dr["todate"]).ToString("yyyy-MM-dd");
                gettdssub.accno = dr["accountno"].ToString();
                getpartywisetdssub.Add(gettdssub);
            }
            getpartywisebank getemployeeDatas = new getpartywisebank();
            getemployeeDatas.partywisebank = getpartywisetds;
            getemployeeDatas.partywisebanksub = getpartywisetdssub;
            getpartywise.Add(getemployeeDatas);
            string response = GetJson(getpartywise);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }


    public class chequeprinting
    {
        public string sno { get; set; }
        public string financial { get; set; }
        public string voucher { get; set; }
        public string bankcode { get; set; }
        public string bankname { get; set; }
        public string chequenumber { get; set; }
        public string btnval { get; set; }
        public string doe { get; set; }
        public string year { get; set; }
        public string bankid { get; set; }
        public List<chequeprintingsub> cheq_array { get; set; }
    }
    public class getchequeprinting
    {
        public List<chequeprinting> chequeprinting { get; set; }
        public List<chequeprintingsub> chequeprintingsub { get; set; }
    }
    public class chequeprintingsub
    {
        public string sno { get; set; }
        public string refno { get; set; }
        public string partycode { get; set; }
        public string partyname { get; set; }
        public string partyid { get; set; }
        public string remarks { get; set; }
        public string amount { get; set; }
        public string chqno { get; set; }
        public string chqdate { get; set; }
        public string doe { get; set; }
        public string hdnproductsno { get; set; }
        public string sno1 { get; set; }
    }
    private void save_chequeprinting_click(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            chequeprinting obj = js.Deserialize<chequeprinting>(title1);
            string financial = obj.financial.TrimEnd();
            string voucher = obj.voucher.TrimEnd();
            string bankcode = obj.bankcode.TrimEnd();
            string bankname = obj.bankname.TrimEnd();
            string bankid = obj.bankid.TrimEnd();
            string chequenumber = obj.chequenumber.TrimEnd();
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();

            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into chequeprinting (financialyear,voucherdate,bankcode,startingcheque,doe,createdby) values (@financialyear,@voucherdate,@bankcode,@startingcheque,@doe,@createdby)");
                //financialyear,voucherdate,bankcode,startingcheque,doe,createdby
                cmd.Parameters.Add("@financialyear", financial);
                cmd.Parameters.Add("@voucherdate", voucher);
                cmd.Parameters.Add("@bankcode", bankid);
                cmd.Parameters.Add("@startingcheque", chequenumber);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);

                cmd = new SqlCommand("Select  MAX(sno) as sno from chequeprinting");
                DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtpo.Rows[0]["sno"].ToString();
                foreach (chequeprintingsub o in obj.cheq_array)
                {

                    cmd = new SqlCommand("insert into chequeprinting_subdetails(partycode,remarks,amount,chequeno,chequedate,doe,refno)values(@partycode,@remarks,@amount,@chequeno,@chequedate,@doe,@refno)");
                    //partycode,remarks,amount,chequeno,chequedate,doe,refno
                    cmd.Parameters.Add("@partycode", o.partyid);
                    cmd.Parameters.Add("@remarks", o.remarks);
                    cmd.Parameters.Add("@amount", o.amount);
                    cmd.Parameters.Add("@chequeno", o.chqno);
                    cmd.Parameters.Add("@chequedate", o.chqdate);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@refno", refno);
                    vdm.insert(cmd);
                }
                string msg = "Successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = obj.sno.TrimEnd();
                cmd = new SqlCommand("update chequeprinting set financialyear=@financialyear,voucherdate=@voucherdate,bankcode=@bankcode,startingcheque=@startingcheque,doe=@doe,createdby=@createdby  where sno=@sno");
                //financialyear,voucherdate,bankcode,startingcheque,doe,createdby
                cmd.Parameters.Add("@financialyear", financial);
                cmd.Parameters.Add("@voucherdate", voucher);
                cmd.Parameters.Add("@bankcode", bankid);
                cmd.Parameters.Add("@startingcheque", chequenumber);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@refno", sno.Trim());
                vdm.Update(cmd);
                foreach (chequeprintingsub o in obj.cheq_array)
                {

                    string sno1 = o.hdnproductsno;
                    string refno = o.refno;
                    cmd = new SqlCommand("update chequeprinting_subdetails set partycode=@partycode,remarks=@remarks,amount=@amount,chequeno=@chequeno,chequedate=@chequedate,doe=@doe where refno=@refno and sno=@sno");
                    //partycode,remarks,amount,chequeno,chequedate,doe,refno
                    cmd.Parameters.Add("@partycode", o.partyid);
                    cmd.Parameters.Add("@remarks", o.remarks);
                    cmd.Parameters.Add("@amount", o.amount);
                    cmd.Parameters.Add("@chequeno", o.chqno);
                    cmd.Parameters.Add("@chequedate", o.chqdate);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@refno", refno);
                    cmd.Parameters.Add("@sno", sno1);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into chequeprinting_subdetails(partycode,remarks,amount,chequeno,chequedate,doe,refno)values(@partycode,@remarks,@amount,@chequeno,@chequedate,@doe,@refno)");
                        //partycode,remarks,amount,chequeno,chequedate,doe,refno
                        cmd.Parameters.Add("@partycode", o.partyid);
                        cmd.Parameters.Add("@remarks", o.remarks);
                        cmd.Parameters.Add("@amount", o.amount);
                        cmd.Parameters.Add("@chequeno", o.chqno);
                        cmd.Parameters.Add("@chequedate", o.chqdate);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@refno", refno);
                        vdm.insert(cmd);

                    }
                }
                string msg = " Successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_chequeprinting_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT  chequeprinting.financialyear, chequeprinting.voucherdate, chequeprinting.sno AS Expr2, chequeprinting.bankcode, chequeprinting.startingcheque, chequeprinting_subdetails.refno,  chequeprinting_subdetails.sno, chequeprinting_subdetails.partycode, chequeprinting_subdetails.remarks, chequeprinting_subdetails.amount,  chequeprinting_subdetails.chequeno, chequeprinting_subdetails.chequedate, financialyeardetails.year, bankmaster.bankname, bankmaster.code,  partymaster.partycode AS Expr1, partymaster.partyname FROM  chequeprinting INNER JOIN chequeprinting_subdetails ON chequeprinting.sno = chequeprinting_subdetails.refno INNER JOIN financialyeardetails ON chequeprinting.financialyear = financialyeardetails.sno INNER JOIN bankmaster ON chequeprinting.bankcode = bankmaster.sno INNER JOIN partymaster ON chequeprinting_subdetails.partycode = partymaster.sno");
            //SELECT  chequeprinting.sno, chequeprinting.financialyear, chequeprinting.voucherdate, chequeprinting.bankcode, chequeprinting.startingcheque, chequeprinting.doe,   chequeprinting.createdby, financialyeardetails.year, bankmaster.code, bankmaster.bankname, fam_party_type.party_tp, fam_party_type.short_desc,  chequeprinting_subdetails.refno, chequeprinting_subdetails.partycode, chequeprinting_subdetails.remarks, chequeprinting_subdetails.amount, chequeprinting_subdetails.chequeno, chequeprinting_subdetails.chequedate FROM chequeprinting INNER JOIN financialyeardetails ON chequeprinting.financialyear = financialyeardetails.sno INNER JOIN bankmaster ON chequeprinting.bankcode = bankmaster.sno INNER JOIN  chequeprinting_subdetails ON chequeprinting.sno = chequeprinting_subdetails.refno INNER JOIN fam_party_type ON chequeprinting_subdetails.partycode = fam_party_type.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtchq = view.ToTable(true, "Expr2", "financialyear", "year", "voucherdate", "bankcode", "code", "bankname", "startingcheque");
            DataTable dtchqsub = view.ToTable(true, "Expr2", "sno", "refno", "partycode", "Expr1", "partyname", "remarks", "amount", "chequeno", "chequedate");
            List<getchequeprinting> getchequeprinting = new List<getchequeprinting>();
            List<chequeprinting> chequeprinting = new List<chequeprinting>();
            List<chequeprintingsub> chequeprintingsub = new List<chequeprintingsub>();
            foreach (DataRow dr in dtchq.Rows)
            {
                chequeprinting getpurchasedetails = new chequeprinting();
                getpurchasedetails.sno = dr["Expr2"].ToString();
                getpurchasedetails.financial = dr["financialyear"].ToString();
                getpurchasedetails.voucher = ((DateTime)dr["voucherdate"]).ToString("yyyy-MM-dd");
                getpurchasedetails.bankcode = dr["code"].ToString();
                getpurchasedetails.bankid = dr["bankcode"].ToString();
                getpurchasedetails.bankname = dr["bankname"].ToString();
                getpurchasedetails.chequenumber = dr["startingcheque"].ToString();
                //getpurchasedetails.doe = ((DateTime)dr["doe"]).ToString("yyyy-MM-dd"); //dr["delivarrydate"].ToString();
                getpurchasedetails.year = dr["year"].ToString();
                chequeprinting.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtchqsub.Rows)
            {
                chequeprintingsub getroutes = new chequeprintingsub();
                getroutes.refno = dr["refno"].ToString();
                getroutes.partycode = dr["Expr1"].ToString();
                getroutes.partyname = dr["partyname"].ToString();
                getroutes.partyid = dr["partycode"].ToString();
                getroutes.remarks = dr["remarks"].ToString();
                getroutes.amount = dr["amount"].ToString();
                getroutes.chqno = dr["chequeno"].ToString();
                getroutes.chqdate = ((DateTime)dr["chequedate"]).ToString("yyyy-MM-dd");
                getroutes.sno = dr["Expr2"].ToString();
                getroutes.sno1 = dr["sno"].ToString();
                chequeprintingsub.Add(getroutes);
            }
            getchequeprinting get_purchases = new getchequeprinting();
            get_purchases.chequeprinting = chequeprinting;
            get_purchases.chequeprintingsub = chequeprintingsub;
            getchequeprinting.Add(get_purchases);
            string response = GetJson(getchequeprinting);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    public class partywisetds
    {
        public string groupcode { get; set; }
        public string groupname { get; set; }
        public string partycode { get; set; }
        public string partyname { get; set; }
        public string btnval { get; set; }
        public string certificateno { get; set; }
        public string sno { get; set; }
        public string doe { get; set; }
        public string groupid { get; set; }
        public string partyid { get; set; }
        public string longdescription { get; set; }
        public List<partywisetdssub> party_array { get; set; }

    }
    public class getpartywisetds
    {
        public List<partywisetds> partywisetds { get; set; }
        public List<partywisetdssub> partywisetdssub { get; set; }
    }
    public class partywisetdssub
    {
        public string glcode { get; set; }
        public string glname { get; set; }
        public string certificatenumber { get; set; }
        public string percentage { get; set; }
        public string exemptionamount { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string remarks { get; set; }
        public string doe { get; set; }
        public string sno { get; set; }
        public string glid { get; set; }

    }
    private void save_partywisetds_click(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            partywisetds obj = js.Deserialize<partywisetds>(title1);
            string groupcode = obj.groupcode.TrimEnd();
            string groupid = obj.groupid.TrimEnd();
            string partyid = obj.partyid.TrimEnd();
            string partycode = obj.partycode.TrimEnd();
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            string modifiedby = context.Session["UserSno"].ToString();

            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                foreach (partywisetdssub es in obj.party_array)
                {
                    cmd = new SqlCommand("insert into partywise_tds_exemption (groupcode,partytype,glcode,certificateno,percentage,exemptionamount,fromdate,todate,remarks,createdby,createdon,doe) values (@groupcode,@partytype,@glcode,@certificateno,@percentage,@exemptionamount,@fromdate,@todate,@remarks,@createdby,@createdon,@doe)");
                    //groupcode,partytype,glcode,certificateno,percentage,exemptionamount,fromdate,todate,remarks,createdby,createdon,doe
                    cmd.Parameters.Add("@groupcode", groupid);
                    cmd.Parameters.Add("@partytype", partyid);
                    cmd.Parameters.Add("@glcode", es.glid);
                    cmd.Parameters.Add("@certificateno", es.certificatenumber);
                    cmd.Parameters.Add("@percentage", es.percentage);
                    cmd.Parameters.Add("@exemptionamount", es.exemptionamount);
                    cmd.Parameters.Add("@fromdate", es.fromdate);
                    cmd.Parameters.Add("@todate", es.todate);
                    cmd.Parameters.Add("@remarks", es.remarks);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@createdon", ServerDateCurrentdate);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    vdm.insert(cmd);
                }
                string response = GetJson("Insert Successfully");
                context.Response.Write(response);
            }
            else
            {
                foreach (partywisetdssub es in obj.party_array)
                {
                    string sno = es.sno;
                    //groupcode,partytype,glcode,certificateno,percentage,exemptionamount,fromdate,todate,remarks,modifiedby,modifiedon,doe
                    cmd = new SqlCommand("Update partywise_tds_exemption set groupcode=@groupcode,partytype=@partytype,glcode=@glcode,certificateno=@certificateno,percentage=@percentage,exemptionamount=@exemptionamount,fromdate=@fromdate,todate=@todate,remarks=@remarks,modifiedby=@modifiedby,modifiedon=@modifiedon,doe=@doe where sno=@sno");
                    cmd.Parameters.Add("@groupcode", groupid);
                    cmd.Parameters.Add("@partytype", partyid);
                    cmd.Parameters.Add("@glcode", es.glid);
                    cmd.Parameters.Add("@certificateno", es.certificatenumber);
                    cmd.Parameters.Add("@percentage", es.percentage);
                    cmd.Parameters.Add("@exemptionamount", es.exemptionamount);
                    cmd.Parameters.Add("@fromdate", es.fromdate);
                    cmd.Parameters.Add("@todate", es.todate);
                    cmd.Parameters.Add("@remarks", es.remarks);
                    cmd.Parameters.Add("@modifiedby", modifiedby);
                    cmd.Parameters.Add("@modifiedon", ServerDateCurrentdate);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", sno);
                    if (vdm.Update(cmd) == 0)
                    {

                        cmd = new SqlCommand("insert into partywise_tds_exemption (groupcode,partytype,glcode,certificateno,percentage,exemptionamount,fromdate,todate,remarks,createdby,createdon,doe) values (@groupcode,@partytype,@glcode,@certificateno,@percentage,@exemptionamount,@fromdate,@todate,@remarks,@createdby,@createdon,@doe)");
                        cmd.Parameters.Add("@groupcode", groupid);
                        cmd.Parameters.Add("@partytype", partyid);
                        cmd.Parameters.Add("@glcode", es.glid);
                        cmd.Parameters.Add("@certificateno", es.certificatenumber);
                        cmd.Parameters.Add("@percentage", es.percentage);
                        cmd.Parameters.Add("@exemptionamount", es.exemptionamount);
                        cmd.Parameters.Add("@fromdate", es.fromdate);
                        cmd.Parameters.Add("@todate", es.todate);
                        cmd.Parameters.Add("@remarks", es.remarks);
                        cmd.Parameters.Add("@createdby", createdby);
                        cmd.Parameters.Add("@createdon", ServerDateCurrentdate);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        vdm.insert(cmd);

                    }
                }
                string response = GetJson("update Successfully");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }

    private void get_partywisetds_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            //string createdby = context.Session["UserSno"].ToString();
            cmd = new SqlCommand("SELECT partywise_tds_exemption.sno, partywise_tds_exemption.groupcode, partywise_tds_exemption.partytype, partywise_tds_exemption.glcode, partywise_tds_exemption.certificateno, partywise_tds_exemption.percentage, partywise_tds_exemption.fromdate, partywise_tds_exemption.exemptionamount, partywise_tds_exemption.todate, partywise_tds_exemption.remarks, partywise_tds_exemption.doe, groupledgermaster.groupcode AS groupid, groupledgermaster.groupshortdesc, primarygroup.groupcode AS primartgroup, primarygroup.longdesc, primarygroup.shortdesc, partymaster.partycode, partymaster.partyname FROM partywise_tds_exemption LEFT OUTER JOIN groupledgermaster ON partywise_tds_exemption.glcode = groupledgermaster.sno LEFT OUTER JOIN primarygroup ON partywise_tds_exemption.groupcode = primarygroup.sno LEFT OUTER JOIN partymaster ON partywise_tds_exemption.partytype = partymaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttds = view.ToTable(true, "sno", "primartgroup", "partycode", "groupcode", "shortdesc", "partytype", "partyname", "certificateno", "doe", "longdesc");
            DataTable dttdssub = view.ToTable(true, "sno", "groupid", "glcode", "groupshortdesc", "certificateno", "exemptionamount", "percentage", "fromdate", "todate", "remarks", "doe");
            List<getpartywisetds> getpartywise = new List<getpartywisetds>();
            List<partywisetds> getpartywisetds = new List<partywisetds>();
            List<partywisetdssub> getpartywisetdssub = new List<partywisetdssub>();
            foreach (DataRow dr in dttds.Rows)
            {
                partywisetds gettds = new partywisetds();
                // getemployee.sno = dr["sno"].ToString();
                gettds.groupcode = dr["groupcode"].ToString();
                gettds.groupname = dr["shortdesc"].ToString();
                gettds.partycode = dr["partytype"].ToString();
                gettds.partyname = dr["partyname"].ToString();
                gettds.certificateno = dr["certificateno"].ToString();
                gettds.sno = dr["sno"].ToString();
                gettds.groupid = dr["primartgroup"].ToString();
                gettds.partyid = dr["partycode"].ToString(); 
                gettds.doe = dr["doe"].ToString();
                gettds.longdescription = dr["longdesc"].ToString();
                getpartywisetds.Add(gettds);
            }
            foreach (DataRow dr in dttdssub.Rows)
            {
                partywisetdssub gettdssub = new partywisetdssub();
                gettdssub.glcode = dr["glcode"].ToString();
                gettdssub.glname = dr["groupshortdesc"].ToString();
                gettdssub.certificatenumber = dr["certificateno"].ToString();
                gettdssub.percentage = dr["percentage"].ToString();
                gettdssub.exemptionamount = dr["exemptionamount"].ToString();
                gettdssub.fromdate = ((DateTime)dr["fromdate"]).ToString("yyyy-MM-dd"); //dr["receiveddate"].ToString(); //((DateTime)dr["relationdob"]).ToString("yyyy-MM-dd"); //
                gettdssub.todate = ((DateTime)dr["todate"]).ToString("yyyy-MM-dd");
                gettdssub.remarks = dr["remarks"].ToString();
                gettdssub.doe = dr["doe"].ToString();
                gettdssub.sno = dr["sno"].ToString();
                gettdssub.glid = dr["groupid"].ToString();
                getpartywisetdssub.Add(gettdssub);
            }
            getpartywisetds getemployeeDatas = new getpartywisetds();
            getemployeeDatas.partywisetds = getpartywisetds;
            getemployeeDatas.partywisetdssub = getpartywisetdssub;
            getpartywise.Add(getemployeeDatas);
            string response = GetJson(getpartywise);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_post_datedcheques(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string branchcode = context.Request["branchcode"];
            string partycode = context.Request["partycode"];
            string createdby = context.Session["UserSno"].ToString();
            string acccode = context.Request["acccode"];
            string chqno = context.Request["chqno"];
            string chqdate = context.Request["chqdate"];
            string amount = context.Request["amount"];
            string drabank = context.Request["drabank"]; 
            string btnval = context.Request["btnval"];
            string remarks = context.Request["remarks"];
            string chequetype = context.Request["chequetype"];
            string branchid = context.Request["branchid"];
            string accountid = context.Request["accountid"];
            string partyid = context.Request["partyid"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into postdated_cheques_entry (branchcode,partycode,accountcode,chequeno,chequedate,amount,draweebank,remarks,status,chequetype,doe,createdby) values (@branchcode,@partycode,@accountcode,@chequeno,@chequedate,@amount,@draweebank,@remarks,@status,@chequetype,@doe,@createdby)");
                //branchcode,partycode,accountcode,chequeno,chequedate,amount,draweebank,doe,createdby
                cmd.Parameters.Add("@branchcode", branchid);
                cmd.Parameters.Add("@partycode", partyid);
                cmd.Parameters.Add("@accountcode", accountid);
                cmd.Parameters.Add("@chequeno", chqno);
                cmd.Parameters.Add("@chequedate", chqdate);
                cmd.Parameters.Add("@amount", amount);
                cmd.Parameters.Add("@draweebank", drabank);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@chequetype", chequetype);
                cmd.Parameters.Add("@status", "P");
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);
                string Response = GetJson("Insert Successfully");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"].ToString();
                cmd = new SqlCommand("Update postdated_cheques_entry set remarks=@remarks,branchcode=@branchcode,partycode=@partycode,accountcode=@accountcode,chequeno=@chequeno,chequedate=@chequedate,amount=@amount,draweebank=@draweebank,status=@status,chequetype=@chequetype,doe=@doe,createdby=@createdby where sno=@sno ");
                cmd.Parameters.Add("@branchcode", branchid);
                cmd.Parameters.Add("@partycode", partyid);
                cmd.Parameters.Add("@accountcode", accountid);
                cmd.Parameters.Add("@chequeno", chqno);
                cmd.Parameters.Add("@chequedate", chqdate);
                cmd.Parameters.Add("@amount", amount);
                cmd.Parameters.Add("@draweebank", drabank);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@chequetype", chequetype);
                cmd.Parameters.Add("@status", "P");
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.Update(cmd);
                string response = GetJson("Updated Sucessfully");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class postdatedcheques
    {
        public string branchcode { get; set; }
        public string branchname { get; set; }
        public string partycode { get; set; }
        public string partyname { get; set; }
        public string sno { get; set; }
        public string acccode { get; set; }
        public string des { get; set; }
        public string accid { get; set; }
        public string chqno { get; set; }
        public string chqdate { get; set; }
        public string amount { get; set; }
        public string drabank { get; set; }
        public string branchid { get; set; }
        public string partyid { get; set; }
        public string remarks { get; set; }
        public string chequetype { get; set; }

        public string chequeid { get; set; }
    }
    private void get_post_datedcheques(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  postdated_cheques_entry.sno, postdated_cheques_entry.branchcode, postdated_cheques_entry.chequetype,postdated_cheques_entry.remarks, postdated_cheques_entry.partycode, postdated_cheques_entry.accountcode, postdated_cheques_entry.chequeno, postdated_cheques_entry.chequedate, postdated_cheques_entry.amount, postdated_cheques_entry.draweebank, postdated_cheques_entry.doe, postdated_cheques_entry.createdby, bankaccountno_master.accountno, bankaccountno_master.accounttype, branchmaster.code, branchmaster.branchname, partymaster.partycode AS Expr1, partymaster.partyname FROM postdated_cheques_entry INNER JOIN branchmaster ON postdated_cheques_entry.branchcode = branchmaster.branchid INNER JOIN bankaccountno_master ON postdated_cheques_entry.accountcode = bankaccountno_master.sno INNER JOIN partymaster ON postdated_cheques_entry.partycode = partymaster.sno");
            //SELECT  postdated_cheques_entry.sno, postdated_cheques_entry.branchcode, postdated_cheques_entry.partycode, postdated_cheques_entry.accountcode,   postdated_cheques_entry.chequeno, postdated_cheques_entry.chequedate, postdated_cheques_entry.amount, postdated_cheques_entry.draweebank,  postdated_cheques_entry.doe, postdated_cheques_entry.createdby, bankaccountno_master.accountno, bankaccountno_master.accounttype,  fam_party_type.party_tp, fam_party_type.short_desc, branchmaster.code, branchmaster.branchname FROM   postdated_cheques_entry INNER JOIN  branchmaster ON postdated_cheques_entry.branchcode = branchmaster.branchid INNER JOIN  fam_party_type ON postdated_cheques_entry.partycode = fam_party_type.sno INNER JOIN  bankaccountno_master ON postdated_cheques_entry.accountcode = bankaccountno_master.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<postdatedcheques> EmployeDetalis = new List<postdatedcheques>();
            foreach (DataRow dr in routes.Rows)
            {
                postdatedcheques getbrcdetails = new postdatedcheques();
                getbrcdetails.sno = dr["sno"].ToString();
                getbrcdetails.branchcode = dr["code"].ToString();
                getbrcdetails.branchname = dr["branchname"].ToString();
                getbrcdetails.branchid = dr["branchcode"].ToString();
                getbrcdetails.partycode = dr["Expr1"].ToString();
                getbrcdetails.partyname = dr["partyname"].ToString();
                getbrcdetails.partyid = dr["partycode"].ToString();
                getbrcdetails.acccode = dr["accountno"].ToString();
                string chequetype = dr["chequetype"].ToString();
                if (chequetype == "R")
                {
                    getbrcdetails.chequetype ="Receipt";
                }
                if (chequetype == "P")
                {
                    getbrcdetails.chequetype ="Payment";
                }
                getbrcdetails.chequeid = dr["chequetype"].ToString();
                getbrcdetails.des = dr["accounttype"].ToString();
                getbrcdetails.accid = dr["accountcode"].ToString();
                getbrcdetails.chqno = dr["chequeno"].ToString();
                getbrcdetails.chqdate = ((DateTime)dr["chequedate"]).ToString("yyyy-MM-dd");
                getbrcdetails.amount = dr["amount"].ToString();
                getbrcdetails.drabank = dr["draweebank"].ToString();
                getbrcdetails.remarks = dr["remarks"].ToString();
                EmployeDetalis.Add(getbrcdetails);  
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void save_fixedassets_group(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string groupcode = context.Request["groupcode"];
            string groupname = context.Request["groupname"];
            string createdby = context.Session["UserSno"].ToString();
            string groupdescription = context.Request["groupdescription"];
            string description = context.Request["description"];
            string gamount = context.Request["gamount"];
            string btnval = context.Request["btnval"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into fixed_assets_groups (groupname,groupcode,description,grossamount,doe,createdby) values (@groupname,@groupcode,@description,@grossamount,@doe,@createdby)");
                cmd.Parameters.Add("@groupname", groupname);
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@grossamount", gamount);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);
                string Response = GetJson("Insert Successfully");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"].ToString();
                cmd = new SqlCommand("Update fixed_assets_groups set groupname=@groupname,groupcode=@groupcode,description=@description,grossamount=@grossamount,doe=@doe,createdby=@createdby where sno=@sno ");
                cmd.Parameters.Add("@groupname", groupname);
                cmd.Parameters.Add("@groupcode", groupcode);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@grossamount", gamount);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("Update Sucessfully");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class fixedassetsgroup
    {
        public string groupcode { get; set; }
        public string groupname { get; set; }
        public string description { get; set; }
        public string gamount { get; set; }
        public string sno { get; set; }
        public string doe { get; set; }
    }
    private void get_fixedassets_group(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,groupname,groupcode,description,grossamount,doe,createdby from fixed_assets_groups");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fixedassetsgroup> EmployeDetalis = new List<fixedassetsgroup>();
            foreach (DataRow dr in routes.Rows)
            {
                fixedassetsgroup getbrcdetails = new fixedassetsgroup();
                getbrcdetails.sno = dr["sno"].ToString();
                getbrcdetails.groupname = dr["groupname"].ToString();
                getbrcdetails.groupcode = dr["groupcode"].ToString();
                getbrcdetails.description = dr["description"].ToString();
                getbrcdetails.gamount = dr["grossamount"].ToString();
                getbrcdetails.doe = dr["doe"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void save_natureof_work(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string shortdesc = context.Request["shortdesc"];
            string longdesc = context.Request["longdesc"];
            string createdby = context.Session["UserSno"].ToString();  
            string glcode = context.Request["glcode"];
            string btnsave = context.Request["btnsave"];
            string glid = context.Request["glid"];
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btnsave == "save")
            {
                cmd = new SqlCommand("insert into natureofwork (shortdescription,longdescription,glcode,doe,createdby) values (@shortdescription,@longdescription,@glcode,@doe,@createdby)");
                cmd.Parameters.Add("@shortdescription", shortdesc);
                cmd.Parameters.Add("@longdescription", longdesc);
                cmd.Parameters.Add("@glcode", glid);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);
                string Response = GetJson("Insert Successfully");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"].ToString();
                cmd = new SqlCommand("Update natureofwork set shortdescription=@shortdescription, longdescription=@longdescription,glcode=@glcode,doe=@doe,createdby=@createdby where sno=@sno ");
                cmd.Parameters.Add("@shortdescription", shortdesc);
                cmd.Parameters.Add("@longdescription", longdesc);
                cmd.Parameters.Add("@glcode", glid);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@sno", sno);
                //cmd.Parameters.Add("@branchid", branchid);
                vdm.Update(cmd);
                string response = GetJson("UPDATE");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class natureofwork
    {
        public string shortdescription { get; set; }
        public string longdescription { get; set; }
        public string glcode { get; set; }
        public string groupshortdesc { get; set; }
        public string sno { get; set; }
        public string glid { get; set; }
    }
    private void get_natureof_work(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT   natureofwork.sno, natureofwork.shortdescription, natureofwork.longdescription, natureofwork.glcode, natureofwork.doe, natureofwork.createdby,  groupledgermaster.groupcode, groupledgermaster.groupshortdesc FROM  natureofwork INNER JOIN groupledgermaster ON natureofwork.glcode = groupledgermaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<natureofwork> EmployeDetalis = new List<natureofwork>();
            foreach (DataRow dr in routes.Rows)
            {
                natureofwork getbrcdetails = new natureofwork();
                getbrcdetails.sno = dr["sno"].ToString();
                getbrcdetails.shortdescription = dr["shortdescription"].ToString();
                getbrcdetails.longdescription = dr["longdescription"].ToString();
                getbrcdetails.glcode = dr["glcode"].ToString();
                getbrcdetails.glid = dr["groupcode"].ToString();
                getbrcdetails.groupshortdesc = dr["groupshortdesc"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void save_depreciation_statement(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            deprectionstatement obj = js.Deserialize<deprectionstatement>(title1);
            string branchcode = obj.branchcode.TrimEnd();
            string branchid = obj.branchid.TrimEnd();
            string financeyear = obj.financeyear.TrimEnd();
            string date = obj.date.TrimEnd();
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            string modifiedby = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into depreciation_statement (branchcode,financialyear,date,doe,createdby) values (@branchcode,@financialyear,@date,@doe,@createdby)");
                //sno,branchcode,financialyear,date,doe,createdby
                cmd.Parameters.Add("@branchcode", branchid);
                cmd.Parameters.Add("@financialyear", financeyear);
                cmd.Parameters.Add("@date", date);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);
                cmd = new SqlCommand("Select  MAX(sno) as sno from depreciation_statement");
                DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtpo.Rows[0]["sno"].ToString();
                foreach (deprectionstatementsub o in obj.dps_array)
                {
                    cmd = new SqlCommand("insert into depreciation_sub_statement(accountcode,groupcode,deprate,openingwdv,additions,purchasedate,sales,saledate,noofdays,depramount,closingwdv,soldwdv,profitloss,doe,createdby,refno)values(@accountcode,@groupcode,@deprate,@openingwdv,@additions,@purchasedate,@sales,@saledate,@noofdays,@depramount,@closingwdv,@soldwdv,@profitloss,@doe,@createdby,@refno)");
                    //sno,accountcode,groupcode,deprate,openingwdv,additions,purchasedate,sales,saledate,noofdays,depramount,closingwdv,soldwdv,profitloss,doe,createdby,refno
                    cmd.Parameters.Add("@accountcode", o.accountid);
                    cmd.Parameters.Add("@groupcode", o.groupid);
                    cmd.Parameters.Add("@deprate", o.deprate);
                    cmd.Parameters.Add("@openingwdv", o.opewdv);
                    cmd.Parameters.Add("@additions", o.additions);
                    cmd.Parameters.Add("@purchasedate", o.purdate);
                    cmd.Parameters.Add("@sales", o.sales);
                    cmd.Parameters.Add("@saledate", o.saledate);
                    cmd.Parameters.Add("@noofdays", o.noofdays);
                    cmd.Parameters.Add("@depramount", o.depamount);
                    cmd.Parameters.Add("@closingwdv", o.closewdv);
                    cmd.Parameters.Add("@soldwdv", o.soldwdv);
                    cmd.Parameters.Add("@profitloss", o.profitloss);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@refno", refno);
                    vdm.insert(cmd);
                }
                string msg = "Successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = obj.sno.TrimEnd();
                //string sno = context.Request["sno"].ToString();
                cmd = new SqlCommand("update depreciation_statement set branchcode=@branchcode,financialyear=@financialyear,date=@date,doe=@doe,createdby=@createdby  where sno=@sno");
                //financialyear,voucherdate,bankcode,startingcheque,doe,createdby
                cmd.Parameters.Add("@branchcode", branchid);
                cmd.Parameters.Add("@financialyear", financeyear);
                cmd.Parameters.Add("@date", date);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@refno", sno.Trim());
                vdm.Update(cmd);
                foreach (deprectionstatementsub o in obj.dps_array)
                {

                    string sno1 = o.hdnproductsno;
                    string refno = o.refno;
                    cmd = new SqlCommand("update depreciation_sub_statement set accountcode=@accountcode,groupcode=@groupcode,deprate=@deprate,openingwdv=@openingwdv,additions=@additions,purchasedate=@purchasedate,sales=@sales,saledate=@saledate,noofdays=@noofdays,depramount=@depramount,closingwdv=@closingwdv,soldwdv=@soldwdv,profitloss=@profitloss,doe=@doe,createdby=@createdby where refno=@refno and sno=@sno");
                    //sno,accountcode,groupcode,deprate,openingwdv,additions,purchasedate,sales,saledate,noofdays,depramount,closingwdv,soldwdv,profitloss,doe,createdby,refno
                    cmd.Parameters.Add("@accountcode", o.accountid);
                    cmd.Parameters.Add("@groupcode", o.groupid);
                    cmd.Parameters.Add("@deprate", o.deprate);
                    cmd.Parameters.Add("@openingwdv", o.opewdv);
                    cmd.Parameters.Add("@additions", o.additions);
                    cmd.Parameters.Add("@purchasedate", o.purdate);
                    cmd.Parameters.Add("@sales", o.sales);
                    cmd.Parameters.Add("@saledate", o.saledate);
                    cmd.Parameters.Add("@noofdays", o.noofdays);
                    cmd.Parameters.Add("@depramount", o.depamount);
                    cmd.Parameters.Add("@closingwdv", o.closewdv);
                    cmd.Parameters.Add("@soldwdv", o.soldwdv);
                    cmd.Parameters.Add("@profitloss", o.profitloss);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@refno", refno);
                    cmd.Parameters.Add("@sno", sno1);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into depreciation_sub_statement(accountcode,groupcode,deprate,openingwdv,additions,purchasedate,sales,saledate,noofdays,depramount,closingwdv,soldwdv,profitloss,doe,createdby,refno)values(@accountcode,@groupcode,@deprate,@openingwdv,@additions,@purchasedate,@sales,@saledate,@noofdays,@depramount,@closingwdv,@soldwdv,@profitloss,@doe,@createdby,@refno)");
                        //sno,accountcode,groupcode,deprate,openingwdv,additions,purchasedate,sales,saledate,noofdays,depramount,closingwdv,soldwdv,profitloss,doe,createdby,refno
                        cmd.Parameters.Add("@accountcode", o.accountid);
                        cmd.Parameters.Add("@groupcode", o.groupid);
                        cmd.Parameters.Add("@deprate", o.deprate);
                        cmd.Parameters.Add("@openingwdv", o.opewdv);
                        cmd.Parameters.Add("@additions", o.additions);
                        cmd.Parameters.Add("@purchasedate", o.purdate);
                        cmd.Parameters.Add("@sales", o.sales);
                        cmd.Parameters.Add("@saledate", o.saledate);
                        cmd.Parameters.Add("@noofdays", o.noofdays);
                        cmd.Parameters.Add("@depramount", o.depamount);
                        cmd.Parameters.Add("@closingwdv", o.closewdv);
                        cmd.Parameters.Add("@soldwdv", o.soldwdv);
                        cmd.Parameters.Add("@profitloss", o.profitloss);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@createdby", createdby);
                        cmd.Parameters.Add("@refno", refno);
                        vdm.insert(cmd);

                    }


                }
                string response = GetJson("update Successfully");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }
    public class deprectionstatement
    {
        public string branchcode { get; set; }
        public string branchname { get; set; }
        public string branchid { get; set; }
        public string financeyear { get; set; }
        public string date { get; set; }
        public string btnval { get; set; }
        public string sno { get; set; }
        public string year { get; set; }
        public string code { get; set; }
        public string doe { get; set; }
        public List<deprectionstatementsub> dps_array { get; set; }

    }
    public class getdeprectionstatement
    {
        public List<deprectionstatement> deprectionstatement { get; set; }
        public List<deprectionstatementsub> deprectionstatementsub { get; set; }
    }
    public class deprectionstatementsub
    {
        public string acccode { get; set; }
        public string accdescription { get; set; }
        public string groupcode { get; set; }
        public string groupid { get; set; }
        public string deprate { get; set; }
        public string opewdv { get; set; }
        public string additions { get; set; }
        public string purdate { get; set; }
        public string sales { get; set; }
        public string saledate { get; set; }
        public string noofdays { get; set; }
        public string depamount { get; set; }
        public string closewdv { get; set; }
        public string soldwdv { get; set; }
        public string profitloss { get; set; }
        public string sno1 { get; set; }
        public string hdnproductsno { get; set; }
        public string refno { get; set; }
        public string accountno { get; set; }
        public string accounttype { get; set; }
        public string sno { get; set; }
        public string accountid { get; set; }
    }
    private void get_depreciation_statement(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            //string createdby = context.Session["UserSno"].ToString();
            cmd = new SqlCommand("SELECT  depreciation_statement.sno, depreciation_statement.branchcode, depreciation_statement.financialyear, depreciation_statement.date, depreciation_sub_statement.sno AS sno1, depreciation_sub_statement.accountcode, depreciation_sub_statement.groupcode, depreciation_sub_statement.deprate, depreciation_sub_statement.openingwdv, depreciation_sub_statement.additions, depreciation_sub_statement.purchasedate, depreciation_sub_statement.sales, depreciation_sub_statement.saledate, depreciation_sub_statement.noofdays, depreciation_sub_statement.depramount, depreciation_sub_statement.closingwdv, depreciation_sub_statement.soldwdv, depreciation_sub_statement.profitloss, depreciation_sub_statement.refno,branchmaster.branchname, branchmaster.code, depreciation_statement.doe,accountmaster.accountcode, accountmaster.description,primarygroup.shortdesc FROM  depreciation_statement INNER JOIN depreciation_sub_statement ON depreciation_statement.sno = depreciation_sub_statement.refno INNER JOIN accountmaster ON depreciation_sub_statement.accountcode = accountmaster.sno INNER JOIN primarygroup ON depreciation_sub_statement.groupcode = primarygroup.sno LEFT OUTER JOIN branchmaster ON depreciation_statement.branchcode = branchmaster.branchid");
            //SELECT  depreciation_statement.sno, depreciation_statement.branchcode, depreciation_statement.financialyear, depreciation_statement.date, depreciation_sub_statement.sno AS sno1, depreciation_sub_statement.accountcode, depreciation_sub_statement.groupcode, depreciation_sub_statement.deprate,   depreciation_sub_statement.openingwdv, depreciation_sub_statement.additions, depreciation_sub_statement.purchasedate, depreciation_sub_statement.sales,  depreciation_sub_statement.saledate, depreciation_sub_statement.noofdays, depreciation_sub_statement.depramount, depreciation_sub_statement.closingwdv,   depreciation_sub_statement.soldwdv, depreciation_sub_statement.profitloss, depreciation_sub_statement.refno, financialyeardetails.year,  branchmaster.branchname, branchmaster.code, depreciation_statement.doe, groupledgermaster.groupcode AS groupid, bankaccountno_master.accounttype,  bankaccountno_master.accountno FROM  depreciation_statement INNER JOIN depreciation_sub_statement ON depreciation_statement.sno = depreciation_sub_statement.refno LEFT OUTER JOIN  bankaccountno_master ON depreciation_sub_statement.accountcode = bankaccountno_master.sno LEFT OUTER JOIN  financialyeardetails ON depreciation_statement.financialyear = financialyeardetails.sno LEFT OUTER JOIN branchmaster ON depreciation_statement.branchcode = branchmaster.branchid LEFT OUTER JOIN  groupledgermaster ON depreciation_sub_statement.groupcode = groupledgermaster.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttds = view.ToTable(true, "sno", "branchcode", "code", "branchname", "financialyear", "date");
            DataTable dttdssub = view.ToTable(true, "sno", "sno1", "refno", "accountcode", "description", "groupcode", "shortdesc", "deprate", "openingwdv", "additions", "purchasedate", "sales", "saledate", "noofdays", "depramount", "closingwdv", "soldwdv", "profitloss");
            List<getdeprectionstatement> getdeprectionstatement = new List<getdeprectionstatement>();
            List<deprectionstatement> deprectionstatement = new List<deprectionstatement>();
            List<deprectionstatementsub> deprectionstatementsub = new List<deprectionstatementsub>();
            foreach (DataRow dr in dttds.Rows)
            {
                deprectionstatement gettds = new deprectionstatement();
                gettds.branchcode = dr["branchname"].ToString();
                gettds.branchid = dr["branchcode"].ToString();
                gettds.branchname = dr["code"].ToString();
                gettds.financeyear = dr["financialyear"].ToString();
                //gettds.year = dr["year"].ToString();
                gettds.date = ((DateTime)dr["date"]).ToString("yyyy-MM-dd");
                gettds.sno = dr["sno"].ToString();
                deprectionstatement.Add(gettds);
            }
            foreach (DataRow dr in dttdssub.Rows)
            {
                deprectionstatementsub gettdssub = new deprectionstatementsub();
                gettdssub.sno = dr["sno"].ToString();
                gettdssub.sno1 = dr["sno1"].ToString();
                gettdssub.refno = dr["refno"].ToString();
                gettdssub.accountid = dr["accountcode"].ToString();
            //    gettdssub.accountno = dr["accountshortdesc"].ToString();
                gettdssub.accounttype = dr["description"].ToString();
                gettdssub.groupid = dr["groupcode"].ToString();
                gettdssub.groupcode = dr["shortdesc"].ToString();
                gettdssub.deprate = dr["deprate"].ToString();
                gettdssub.opewdv = dr["openingwdv"].ToString();
                gettdssub.additions = dr["additions"].ToString();
                gettdssub.purdate = ((DateTime)dr["purchasedate"]).ToString("yyyy-MM-dd");
                gettdssub.sales = dr["sales"].ToString();
                gettdssub.saledate = ((DateTime)dr["saledate"]).ToString("yyyy-MM-dd");
                gettdssub.noofdays = dr["noofdays"].ToString();
                gettdssub.depamount = dr["depramount"].ToString(); //dr["receiveddate"].ToString(); //((DateTime)dr["relationdob"]).ToString("yyyy-MM-dd"); //
                gettdssub.closewdv = dr["closingwdv"].ToString();
                gettdssub.soldwdv = dr["soldwdv"].ToString();
                gettdssub.profitloss = dr["profitloss"].ToString();
                
                deprectionstatementsub.Add(gettdssub);
            }
            getdeprectionstatement getemployeeDatas = new getdeprectionstatement();
            getemployeeDatas.deprectionstatement = deprectionstatement;
            getemployeeDatas.deprectionstatementsub = deprectionstatementsub;
            getdeprectionstatement.Add(getemployeeDatas);
            string response = GetJson(getdeprectionstatement);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class transDet
    {
        public string trans_type { get; set; }
        public string short_desc { get; set; }
        public string sno { get; set; }

    }

    private void get_trans_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,transactiontype,shortdescription FROM transactiontype");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<transDet> Departmentslst = new List<transDet>();
            foreach (DataRow dr in routes.Rows)
            {
                transDet getdepts = new transDet();
                getdepts.trans_type = dr["transactiontype"].ToString();
                getdepts.short_desc = dr["shortdescription"].ToString();
                getdepts.sno = dr["sno"].ToString();
                Departmentslst.Add(getdepts);
            }
            string response = GetJson(Departmentslst);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class transSubDet
    {
        public string sub_type { get; set; }
        public string description { get; set; }
        public string sno { get; set; }

    }

    private void get_trans_sub_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,subtype,description FROM transactionsubtypes");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<transSubDet> Departmentslst = new List<transSubDet>();
            foreach (DataRow dr in routes.Rows)
            {
                transSubDet getdepts = new transSubDet();
                getdepts.sub_type = dr["subtype"].ToString();
                getdepts.description = dr["description"].ToString();
                getdepts.sno = dr["sno"].ToString();
                Departmentslst.Add(getdepts);
            }
            string response = GetJson(Departmentslst);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class Det_code
    {
        public string account_code { get; set; }
        public string cost_center { get; set; }
        public string budget_code { get; set; }
        public string acc_desc { get; set; }
        public string sno { get; set; }

    }

    private void get_code_det(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,accountcode,acdescription,costcenter,budgetcode FROM suspensecashrequisition");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Det_code> Departmentslst = new List<Det_code>();
            foreach (DataRow dr in routes.Rows)
            {
                Det_code getdepts = new Det_code();
                getdepts.account_code = dr["accountcode"].ToString();
                getdepts.acc_desc = dr["acdescription"].ToString();
                getdepts.cost_center = dr["costcenter"].ToString();
                getdepts.budget_code = dr["budgetcode"].ToString();
                getdepts.sno = dr["sno"].ToString();
                Departmentslst.Add(getdepts);
            }
            string response = GetJson(Departmentslst);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void save_voucher_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            fan_trans_det obj = js.Deserialize<fan_trans_det>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            //string Trans_no = obj.Trans_no;
            string Trans_Date = obj.Trans_Date; //((DateTime)obj.Trans_Date).ToString("yyyy-MM-dd");
            string financial_yr = obj.financial_yr;
            string branch_code = obj.branch_code;
            string voucher_type = obj.voucher_type;
            //string voucher_sub_type = obj.voucher_sub_type;
            string code_acc = obj.code_acc;
            //string note_type = obj.note_type;
            string party_type = obj.party_type;
            string party_code = obj.party_code;
            string remarks = obj.remarks;
            string sno = obj.sno;
            //DateTime effFrom = Convert.ToDateTime(obj.effFrom);
            //DateTime effTo = Convert.ToDateTime(obj.effTo);
            string btn_save = obj.btn_save;

            if (btn_save == "Save")
            {

                cmd = new SqlCommand("insert into credit_note_entry (date,financialyear,branchcode,vouchertype,accountcode,partytype,partycode,remarks,doe,createdby) values (@Trans_Date,@financial_yr,@branch_code,@voucher_type,@code_acc,@party_type,@party_code,@remarks,@doe,@createdby)");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                //cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from credit_note_entry ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string refno = routes.Rows[0]["sno"].ToString();//tax_gl_code
                foreach (fan_voucher si in obj.DataTable)
                {
                    string acc_code = si.acc_code;
                    string desc = si.desc;
                    string cost_code = si.cost_code;
                    string budget_code = si.budget_code;
                    string name = si.name;
                    string amt = si.amount;
                    //string Sno = si.sno;
                    cmd = new SqlCommand("insert into credit_voucher_details (accountcode,description,costcentercode,budgetcode,name,amount,doe,createdby,refno) values (@acc_code, @desc, @cost_code, @budget_code, @name, @amt, @doe, @createdby, @refno)");
                    cmd.Parameters.Add("@acc_code", acc_code);
                    cmd.Parameters.Add("@desc", desc);
                    cmd.Parameters.Add("@cost_code", cost_code);
                    cmd.Parameters.Add("@budget_code", budget_code);
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@amt", amt);
                    cmd.Parameters.Add("@refno", refno);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {


                //taxtype,rangefrom,rangeto,percentage,fromdate,todate,status,createdby,createdon,doe
                cmd = new SqlCommand("UPDATE credit_note_entry SET date=@Trans_Date,financialyear=@financial_yr,branchcode=@branch_code,vouchertype=@voucher_type,accountcode=@code_acc, partytype=@party_type,partycode=@party_code,remarks=@remarks WHERE sno=@sno");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                //cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                //cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);

                foreach (fan_voucher si in obj.DataTable)
                {
                    string acc_code = si.acc_code;
                    string desc = si.desc;
                    string cost_code = si.cost_code;
                    string budget_code = si.budget_code;
                    string name = si.name;
                    string amt = si.amount;
                    string Sno = si.sno;
                    cmd = new SqlCommand("update credit_voucher_details set accountcode=@acc_code, description=@desc, costcentercode=@cost_code, budgetcode=@budget_code, name=@name, amount=@amt where sno=@sno");
                    cmd.Parameters.Add("@acc_code", acc_code);
                    cmd.Parameters.Add("@desc", desc);
                    cmd.Parameters.Add("@cost_code", cost_code);
                    cmd.Parameters.Add("@budget_code", budget_code);
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@amt", amt);
                    cmd.Parameters.Add("@sno", Sno);
                    //cmd.Parameters.Add("@refno", refno);
                    //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    //cmd.Parameters.Add("@createdby", UserName);
                    vdm.Update(cmd);
                }
                string msg = "successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class fan_trans_det
    {
        //public string Trans_no { get; set; }
        public string Trans_Date { get; set; }
        public string financial_yr { get; set; }
        public string financial_yr1 { get; set; }
        public string branch_code { get; set; }
        public string branch_code1 { get; set; }
        public string voucher_type { get; set; }
        public string voucher_type1 { get; set; }
        public string voucher_sub_type { get; set; }
        public string voucher_sub_type1 { get; set; }
        public string code_acc { get; set; }
        public string code_acc1 { get; set; }
        //public string note_type { get; set; }
        public string party_type { get; set; }
        public string party_type1 { get; set; }
        public string party_code { get; set; }
        public string party_code1 { get; set; }
        public string remarks { get; set; }
        public string sno { get; set; }
        public string btn_save { get; set; }
        public List<fan_voucher> DataTable { get; set; }
    }

    public class fan_voucher
    {

        public string acc_code { get; set; }
        public string desc { get; set; }
        public string cost_code { get; set; }
        public string budget_code { get; set; }
        public string name { get; set; }
        public string amount { get; set; }
        public string sno { get; set; }
        public string refno { get; set; }
        public string accountid { get; set; }
        public string description { get; set; }
        public string budgetcode { get; set; }
        public string costcentercode { get; set; }
        public string sno1 { get; set; }
    }
    public class getcreditnotedetails
    {
        public List<fan_trans_det> fan_trans_det { get; set; }
        public List<fan_voucher> fan_voucher { get; set; }
    }
    private void get_creditnote_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            //cmd = new SqlCommand("SELECT sno,date,financialyear,branchcode,vouchertype,vouchersubtype,accountcode,partytype,partycode,remarks,doe,createdby FROM credit_note_entry");
            //cmd = new SqlCommand("SELECT e.sno,e.date,e.financialyear,e.branchcode,e.vouchertype,e.vouchersubtype,e.accountcode,e.partytype,e.partycode,e.remarks FROM credit_note_entry e join credit_voucher_details i on e.sno=i.refno");
            cmd = new SqlCommand("SELECT e.sno,e.date,e.financialyear,f.year,e.branchcode,b.code,e.vouchertype,v.transactiontype,e.vouchersubtype,ts.subtype,e.accountcode AS account_code,vs.accountno,e.partytype,p.party_tp,e.partycode AS party_code,pc.partycode,e.remarks FROM credit_note_entry e join credit_voucher_details i on e.sno=i.refno inner join branchmaster b on b.branchid=e.branchcode inner join financialyeardetails f on f.sno=e.financialyear inner join transactiontype v on v.sno=e.vouchertype inner join fam_party_type p on p.sno=e.partytype inner join partymaster pc on pc.sno=e.partycode inner join bankaccountno_master vs on vs.sno=e.accountcode inner join transactionsubtypes ts on ts.sno=e.vouchersubtype");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_trans_det> paymentdetailslist = new List<fan_trans_det>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_trans_det getpaymentdetails = new fan_trans_det();
                getpaymentdetails.financial_yr = dr["year"].ToString();
                getpaymentdetails.financial_yr1 = dr["financialyear"].ToString();
                getpaymentdetails.branch_code = dr["code"].ToString();
                getpaymentdetails.branch_code1 = dr["branchcode"].ToString();
                getpaymentdetails.voucher_type = dr["transactiontype"].ToString();
                getpaymentdetails.voucher_type1 = dr["vouchertype"].ToString();
                getpaymentdetails.voucher_sub_type = dr["subtype"].ToString();
                getpaymentdetails.voucher_sub_type1 = dr["vouchersubtype"].ToString();
                getpaymentdetails.code_acc = dr["accountno"].ToString();
                getpaymentdetails.code_acc1 = dr["account_code"].ToString();
                getpaymentdetails.Trans_Date = ((DateTime)dr["date"]).ToString("yyyy-MM-dd");
                getpaymentdetails.remarks = dr["remarks"].ToString();
                getpaymentdetails.party_type = dr["party_tp"].ToString();
                getpaymentdetails.party_type1 = dr["partytype"].ToString();
                getpaymentdetails.party_code = dr["partycode"].ToString();
                getpaymentdetails.party_code1 = dr["party_code"].ToString();
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class fan_trans_det1
    {
        //public string Trans_no { get; set; }
        public string Trans_Date1 { get; set; }
        public string financial_yr1 { get; set; }
        public string financial_yr11 { get; set; }
        public string branch_code1 { get; set; }
        public string branch_code11 { get; set; }
        public string voucher_type1 { get; set; }
        public string voucher_type11 { get; set; }
        public string voucher_sub_type1 { get; set; }
        public string voucher_sub_type11 { get; set; }
        public string code_acc1 { get; set; }
        public string code_acc11 { get; set; }
        //public string note_type { get; set; }
        public string party_type1 { get; set; }
        public string party_type11 { get; set; }
        public string party_code1 { get; set; }
        public string party_code11 { get; set; }
        public string remarks1 { get; set; }
        public string sno1 { get; set; }
        public string btn_save { get; set; }
        public List<fan_invoice> DataTable1 { get; set; }
    }

    public class fan_invoice
    {

        public string particulars { get; set; }
        public string invoice_no { get; set; }
        public string invoice_date { get; set; }
        public string sno1 { get; set; }
        public string refno { get; set; }

    }

    private void save_invoice_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            fan_trans_det1 obj = js.Deserialize<fan_trans_det1>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            //string Trans_no = obj.Trans_no;
            string Trans_Date = obj.Trans_Date1; //((DateTime)obj.Trans_Date).ToString("yyyy-MM-dd");
            string financial_yr = obj.financial_yr1;
            string branch_code = obj.branch_code1;
            string voucher_type = obj.voucher_type1;
            string voucher_sub_type = obj.voucher_sub_type1;
            string code_acc = obj.code_acc1;
            //string note_type = obj.note_type;
            string party_type = obj.party_type1;
            string party_code = obj.party_code1;
            string remarks = obj.remarks1;
            string sno = obj.sno1;
            //DateTime effFrom = Convert.ToDateTime(obj.effFrom);
            //DateTime effTo = Convert.ToDateTime(obj.effTo);
            string btn_save = obj.btn_save;

            if (btn_save == "Save")
            {

                cmd = new SqlCommand("insert into credit_note_entry (date,financialyear,branchcode,vouchertype,vouchersubtype,accountcode,partytype,partycode,remarks,doe,createdby) values (@Trans_Date,@financial_yr,@branch_code,@voucher_type,@voucher_sub_type,@code_acc,@party_type,@party_code,@remarks,@doe,@createdby)");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from credit_note_entry ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string refno = routes.Rows[0]["sno"].ToString();//tax_gl_code
                foreach (fan_invoice si in obj.DataTable1)
                {
                    string particulars = si.particulars;
                    string invoice_no = si.invoice_no;
                    string invoice_date = si.invoice_date;
                    //string Sno = si.sno;
                    cmd = new SqlCommand("insert into credit_invoice_details (particulars,invoiceno,invoicedate,doe,createdby,refno) values (@particulars, @invoice_no, @invoice_date, @doe, @createdby, @refno)");
                    cmd.Parameters.Add("@particulars", particulars);
                    cmd.Parameters.Add("@invoice_no", invoice_no);
                    cmd.Parameters.Add("@invoice_date", invoice_date);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@refno", refno);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {


                //taxtype,rangefrom,rangeto,percentage,fromdate,todate,status,createdby,createdon,doe
                cmd = new SqlCommand("UPDATE credit_note_entry SET date=@Trans_Date,financialyear=@financial_yr,branchcode=@branch_code,vouchertype=@voucher_type,vouchersubtype=@voucher_sub_type,accountcode=@code_acc, partytype=@party_type,partycode=@party_code,remarks=@remarks WHERE sno=@sno");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                //cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);

                foreach (fan_invoice si in obj.DataTable1)
                {
                    string particulars = si.particulars;
                    string invoice_no = si.invoice_no;
                    string invoice_date = si.invoice_date;
                    string sno1 = si.sno1;
                    cmd = new SqlCommand("update credit_invoice_details set particulars=@particulars, invoiceno=@invoice_no, invoicedate=@invoice_date where sno=@sno");
                    cmd.Parameters.Add("@particulars", particulars);
                    cmd.Parameters.Add("@invoice_no", invoice_no);
                    cmd.Parameters.Add("@invoice_date", invoice_date);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@sno", sno1);
                    //cmd.Parameters.Add("@refno", refno);
                    //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    //cmd.Parameters.Add("@createdby", UserName);
                    vdm.Update(cmd);
                }

            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_creditnote_details1(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            //cmd = new SqlCommand("SELECT sno,date,financialyear,branchcode,vouchertype,vouchersubtype,accountcode,partytype,partycode,remarks,doe,createdby FROM credit_note_entry");
            //cmd = new SqlCommand("SELECT e.sno,e.date,e.financialyear,e.branchcode,e.vouchertype,e.vouchersubtype,e.accountcode,e.partytype,e.partycode,e.remarks FROM credit_note_entry e join credit_invoice_details i on e.sno=i.refno");
            cmd = new SqlCommand("SELECT e.sno,e.date,e.financialyear,f.year,e.branchcode,b.code,e.vouchertype,v.transactiontype,e.vouchersubtype,ts.subtype,e.accountcode AS account_code,vs.accountno,e.partytype,p.party_tp,e.partycode AS party_code,pc.partycode,e.remarks FROM credit_note_entry e join credit_invoice_details i on e.sno=i.refno inner join branchmaster b on b.branchid=e.branchcode inner join financialyeardetails f on f.sno=e.financialyear inner join transactiontype v on v.sno=e.vouchertype inner join fam_party_type p on p.sno=e.partytype inner join partymaster pc on pc.sno=e.partycode inner join bankaccountno_master vs on vs.sno=e.accountcode inner join transactionsubtypes ts on ts.sno=e.vouchersubtype");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_trans_det1> paymentdetailslist = new List<fan_trans_det1>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_trans_det1 getpaymentdetails = new fan_trans_det1();
                getpaymentdetails.financial_yr1 = dr["year"].ToString();
                getpaymentdetails.financial_yr11 = dr["financialyear"].ToString();
                getpaymentdetails.branch_code1 = dr["code"].ToString();
                getpaymentdetails.branch_code11 = dr["branchcode"].ToString();
                getpaymentdetails.voucher_type1 = dr["transactiontype"].ToString();
                getpaymentdetails.voucher_type11 = dr["vouchertype"].ToString();
                getpaymentdetails.voucher_sub_type1 = dr["subtype"].ToString();
                getpaymentdetails.voucher_sub_type11 = dr["vouchersubtype"].ToString();
                getpaymentdetails.code_acc1 = dr["accountno"].ToString();
                getpaymentdetails.code_acc11 = dr["account_code"].ToString();
                getpaymentdetails.Trans_Date1 = ((DateTime)dr["date"]).ToString("yyyy-MM-dd");
                getpaymentdetails.remarks1 = dr["remarks"].ToString();
                getpaymentdetails.party_type1 = dr["party_tp"].ToString();
                getpaymentdetails.party_type11 = dr["partytype"].ToString();
                getpaymentdetails.party_code1 = dr["partycode"].ToString();
                getpaymentdetails.party_code11 = dr["party_code"].ToString();
                getpaymentdetails.sno1 = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    //public class fixedassets
    //{
    //    public string sno { get; set; }
    //    public string btnval { get; set; }
    //    public List<fixedassetssub> fixedassetsarray { get; set; }

    //}
    //public class fixedassetssub
    //{
    //    public string branchcode { get; set; }
    //    public string accountcode { get; set; }
    //    public string accountdescription { get; set; }
    //    public string acclongdescription { get; set; }
    //    public string groupcode { get; set; } 
    //    public string deprate { get; set; }
    //    public string doe { get; set; }
    //    public string sno { get; set; }
    //    public string branchid { get; set; }
    //    public string accountid { get; set; }
    //    public string groupid { get; set; }
    //    public string branchname { get; set; }
    //}
    //private void save_fixed_assets(HttpContext context)
    //{
    //    try
    //    {
    //        var js = new JavaScriptSerializer();
    //        var title1 = context.Request.Params[1];
    //        fixedassets obj = js.Deserialize<fixedassets>(title1);
    //        string btnval = obj.btnval.TrimEnd();
    //        string createdby = context.Session["UserSno"].ToString();
    //        string modifiedby = context.Session["UserSno"].ToString();
    //        DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
    //        vdm = new VehicleDBMgr();
    //        if (btnval == "Save")
    //        {
    //            foreach (fixedassetssub es in obj.fixedassetsarray)
    //            {
    //                cmd = new SqlCommand("insert into fixed_assets (branchcode,accountcode,groupcode,dep_rate,doe,createdby) values (@branchcode,@accountcode,@groupcode,@dep_rate,@doe,@createdby)");
    //                //branchcode,accountcode,groupcode,dep_rate,doe,createdby
    //                cmd.Parameters.Add("@branchcode", es.branchid);
    //                cmd.Parameters.Add("@accountcode", es.accountid);
    //                cmd.Parameters.Add("@groupcode", es.groupcode);
    //                cmd.Parameters.Add("@dep_rate", es.deprate);
    //                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
    //                cmd.Parameters.Add("@createdby", createdby);
    //                vdm.insert(cmd);
    //            }
    //            string response = GetJson("Insert Successfully");
    //            context.Response.Write(response);
    //        }
    //        else
    //        {
    //            foreach (fixedassetssub es in obj.fixedassetsarray)
    //            {
    //                string sno = obj.sno;
    //                cmd = new SqlCommand("Update fixed_assets set branchcode=@branchcode,accountcode=@accountcode,groupcode=@groupcode,dep_rate=@dep_rate,doe=@doe,createdby=@createdby where sno=@sno");
    //                //branchcode,accountcode,groupcode,dep_rate,doe,createdby
    //                cmd.Parameters.Add("@branchcode", es.branchid);
    //                cmd.Parameters.Add("@accountcode", es.accountid);
    //                cmd.Parameters.Add("@groupcode", es.groupcode);
    //                cmd.Parameters.Add("@dep_rate", es.deprate);
    //                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
    //                cmd.Parameters.Add("@createdby", createdby);
    //                cmd.Parameters.Add("@sno", sno);
    //                if (vdm.Update(cmd) == 0)
    //                {
    //                    cmd = new SqlCommand("insert into fixed_assets (branchcode,accountcode,groupcode,dep_rate,doe,createdby) values (@branchcode,@accountcode,@groupcode,@dep_rate,@doe,@createdby)");
    //                    //branchcode,accountcode,groupcode,dep_rate,doe,createdby
    //                    cmd.Parameters.Add("@branchcode", es.branchid);
    //                    cmd.Parameters.Add("@accountcode", es.accountid);
    //                    cmd.Parameters.Add("@groupcode", es.groupcode);
    //                    cmd.Parameters.Add("@dep_rate", es.deprate);
    //                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
    //                    cmd.Parameters.Add("@createdby", createdby);
    //                    vdm.insert(cmd);
    //                }
    //            }
    //            string response = GetJson("update Successfully");
    //            context.Response.Write(response);
    //        }
    //    }

    //    catch (Exception ex)
    //    {
    //        string response = GetJson(ex.Message);
    //        context.Response.Write(response);
    //    }
    //}
    //public class getfixedassets
    //{
    //    public List<fixedassets> fixedassets { get; set; }
    //    public List<fixedassetssub> fixedassetssub { get; set; }
    //}
    //private void get_fixed_assets(HttpContext context)
    //{
    //    try
    //    {
    //        vdm = new VehicleDBMgr();
    //        DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
    //        //string createdby = context.Session["UserSno"].ToString();
    //        cmd = new SqlCommand("SELECT  fixed_assets.sno, fixed_assets.accountcode, fixed_assets.groupcode, fixed_assets.dep_rate, fixed_assets.doe, fixed_assets.createdby, fixed_assets.branchcode,  branchmaster.branchname, accountmaster.accountcode AS acountid, accountmaster.accountshortdesc,accountmaster.accountlongdesc, subgroup_ledgerdetails.subgroupcode,  subgroup_ledgerdetails.subgroup FROM  fixed_assets LEFT OUTER JOIN branchmaster ON fixed_assets.branchcode = branchmaster.branchid LEFT OUTER JOIN accountmaster ON fixed_assets.accountcode = accountmaster.sno LEFT OUTER JOIN subgroup_ledgerdetails ON accountmaster.groupcode = subgroup_ledgerdetails.sno");
    //        //SELECT  fixed_assets.sno, fixed_assets.accountcode, fixed_assets.groupcode, fixed_assets.dep_rate, fixed_assets.doe, fixed_assets.createdby, branchmaster.branchname, branchmaster.code, fixed_assets.branchcode, bankaccountno_master.accountno, bankaccountno_master.accounttype,  groupledgermaster.groupcode AS groupid FROM  fixed_assets LEFT OUTER JOIN  branchmaster ON fixed_assets.branchcode = branchmaster.branchid LEFT OUTER JOIN  bankaccountno_master ON fixed_assets.accountcode = bankaccountno_master.sno LEFT OUTER JOIN  groupledgermaster ON fixed_assets.groupcode = groupledgermaster.sno
    //        DataTable routes = vdm.SelectQuery(cmd).Tables[0];
    //        DataView view = new DataView(routes);
    //        DataTable dttds = view.ToTable(true, "sno");
    //        DataTable dttdssub = view.ToTable(true, "sno", "accountcode", "groupcode", "dep_rate", "doe", "branchname", "branchcode", "acountid", "accountshortdesc", "subgroup", "accountlongdesc");
    //        List<getfixedassets> getfixedassets = new List<getfixedassets>();
    //        List<fixedassets> fixedassets = new List<fixedassets>();
    //        List<fixedassetssub> fixedassetssub = new List<fixedassetssub>();
    //        foreach (DataRow dr in dttds.Rows)
    //        {
    //            fixedassets gettds = new fixedassets();
    //            gettds.sno = dr["sno"].ToString();
    //            fixedassets.Add(gettds);
    //        }
    //        foreach (DataRow dr in dttdssub.Rows)
    //        {
    //            fixedassetssub gettdssub = new fixedassetssub();
    //            gettdssub.accountcode = dr["accountcode"].ToString();
    //            gettdssub.groupcode = dr["groupcode"].ToString();
    //            gettdssub.deprate = dr["dep_rate"].ToString();
    //            gettdssub.branchname = dr["branchname"].ToString();
    //            //gettdssub.branchcode = dr["code"].ToString();
    //            gettdssub.branchid = dr["branchcode"].ToString(); 
    //            gettdssub.accountid = dr["acountid"].ToString();
    //            gettdssub.acclongdescription = dr["accountlongdesc"].ToString();
    //            gettdssub.accountdescription = dr["accountshortdesc"].ToString();
    //            gettdssub.groupid = dr["subgroup"].ToString();
    //            gettdssub.sno = dr["sno"].ToString();
    //            gettdssub.doe = dr["doe"].ToString();
    //            fixedassetssub.Add(gettdssub);
    //        }
    //        getfixedassets getemployeeDatas = new getfixedassets();
    //        getemployeeDatas.fixedassets = fixedassets;
    //        getemployeeDatas.fixedassetssub = fixedassetssub;
    //        getfixedassets.Add(getemployeeDatas);
    //        string response = GetJson(getfixedassets);
    //        context.Response.Write(response);
    //    }
    //    catch (Exception ex)
    //    {
    //        string Response = GetJson(ex.Message);
    //        context.Response.Write(Response);
    //    }
    //}
    public void save_cashadvance_requisition(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string advreqno = context.Request["advreqno"];
            string advreqdate = context.Request["advreqdate"];
            string financeyear = context.Request["financeyear"];
            string name = context.Request["name"];
            string nameid = context.Request["nameid"];
            string prvadvpndamount = context.Request["prvadvpndamount"];
            string designation = context.Request["designation"];
            string particulars = context.Request["particulars"];
            string advreqamount = context.Request["advreqamount"];
            string workponumber = context.Request["workponumber"];
            string advamountrecomnd = context.Request["advamountrecomnd"];
            string payorder = context.Request["payorder"];

            string btn_save = context.Request["btnval"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into cash_advance_requisition (advreqdate,financialyear,empcode,particulars,advreqamount,workorderpono,advamountrcmd,payorderfor,doe,createdby,previouspendingadvance) values (@advreqdate,@financialyear,@empcode,@particulars,@advreqamount,@workorderpono,@advamountrcmd,@payorderfor,@doe,@createdby,@previouspendingadvance)");
                //advreqdate,financialyear,controltype,accountcode,costcenter,budgetcode,empcode,particulars,advreqamount,workorderpono,advamountrcmd,payorderfor,doe,createdby
                cmd.Parameters.Add("@advreqdate", advreqdate);
                cmd.Parameters.Add("@financialyear", financeyear);
                cmd.Parameters.Add("@previouspendingadvance", prvadvpndamount);
                cmd.Parameters.Add("@empcode", nameid);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@advreqamount", advreqamount);
                cmd.Parameters.Add("@workorderpono", workponumber);
                cmd.Parameters.Add("@advamountrcmd", advamountrecomnd);
                cmd.Parameters.Add("@payorderfor", payorder);

                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["advreqno"];
                cmd = new SqlCommand("Update cash_advance_requisition set advreqdate=@advreqdate,financialyear=@financialyear,empcode=@empcode,particulars=@particulars,advreqamount=@advreqamount,workorderpono=@workorderpono,advamountrcmd=@advamountrcmd,payorderfor=@payorderfor,doe=@doe,createdby=@createdby,previouspendingadvance=@previouspendingadvance where sno=@sno");
                cmd.Parameters.Add("@advreqdate", advreqdate);
                cmd.Parameters.Add("@financialyear", financeyear);
                cmd.Parameters.Add("@previouspendingadvance", prvadvpndamount);
                cmd.Parameters.Add("@empcode", nameid);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@advreqamount", advreqamount);
                cmd.Parameters.Add("@workorderpono", workponumber);
                cmd.Parameters.Add("@advamountrcmd", advamountrecomnd);
                cmd.Parameters.Add("@payorderfor", payorder);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", advreqno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class cashadvance
    {
        public string advreqno { get; set; }
        public string advreqdate { get; set; }
        public string financeyear { get; set; }
        public string year { get; set; }
        public string name { get; set; }
        public string nameid { get; set; }
        public string branchid { get; set; }
        public string deptid { get; set; }
        public string DepartmentName { get; set; }
        public string designationcode { get; set; }
        public string designation { get; set; }
        public string prvadvpndamount { get; set; }
        public string pay { get; set; }
        public string particulars { get; set; }
        public string advreqamount { get; set; }
        public string workponumber { get; set; }
        public string advamountrecomnd { get; set; }
        public string payorder { get; set; }
        public string doe { get; set; }

    }

    private void get_cashadvance_requisition(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  cash_advance_requisition.sno, cash_advance_requisition.previouspendingadvance, cash_advance_requisition.advreqdate, cash_advance_requisition.financialyear, cash_advance_requisition.empcode,cash_advance_requisition.particulars, cash_advance_requisition.advreqamount, cash_advance_requisition.workorderpono, cash_advance_requisition.advamountrcmd, cash_advance_requisition.payorderfor,cash_advance_requisition.doe, cash_advance_requisition.createdby, financialyeardetails.year, employe_login.name, employe_login.branchid, employe_login.deptid, Departmentdetails.DepartmentName FROM  cash_advance_requisition INNER JOIN financialyeardetails ON cash_advance_requisition.financialyear = financialyeardetails.sno INNER JOIN Departmentdetails INNER JOIN employe_login ON Departmentdetails.sno = employe_login.deptid ON cash_advance_requisition.empcode = employe_login.sno");
            //SELECT   cash_advance_requisition.sno, cash_advance_requisition.advreqdate, cash_advance_requisition.financialyear, cash_advance_requisition.controltype, cash_advance_requisition.accountcode, cash_advance_requisition.costcenter, cash_advance_requisition.budgetcode, cash_advance_requisition.empcode,  cash_advance_requisition.particulars, cash_advance_requisition.advreqamount, cash_advance_requisition.workorderpono,  cash_advance_requisition.advamountrcmd, cash_advance_requisition.payorderfor, cash_advance_requisition.doe, cash_advance_requisition.createdby,  financialyeardetails.year, controltype.controltype AS controlid, controltype.description, bankaccountno_master.accountno, bankaccountno_master.accounttype,   costcenter_master.costcentercode, costcenter_master.costcenterdesc, budgetmaster.budgetcode AS budgectid, budgetmaster.budgetdesc, employe_login.name,  employe_login.branchid, employe_login.deptid, Departmentdetails.DepartmentName FROM  Departmentdetails INNER JOIN employe_login ON Departmentdetails.sno = employe_login.deptid RIGHT OUTER JOIN cash_advance_requisition INNER JOIN financialyeardetails ON cash_advance_requisition.financialyear = financialyeardetails.sno INNER JOIN costcenter_master ON cash_advance_requisition.costcenter = costcenter_master.sno LEFT OUTER JOIN controltype ON cash_advance_requisition.controltype = controltype.sno LEFT OUTER JOIN bankaccountno_master ON cash_advance_requisition.accountcode = bankaccountno_master.sno LEFT OUTER JOIN   budgetmaster ON cash_advance_requisition.budgetcode = budgetmaster.sno ON employe_login.sno = cash_advance_requisition.empcode
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<cashadvance> monthlist = new List<cashadvance>();
            foreach (DataRow dr in routes.Rows)
            {
                cashadvance getmonthdetail = new cashadvance();
                getmonthdetail.advreqno = dr["sno"].ToString();

                getmonthdetail.advreqdate = ((DateTime)dr["advreqdate"]).ToString("yyyy-MM-dd");
                getmonthdetail.financeyear = dr["financialyear"].ToString();
                getmonthdetail.year = dr["year"].ToString();
                getmonthdetail.nameid = dr["empcode"].ToString();
                getmonthdetail.name = dr["name"].ToString();
                getmonthdetail.prvadvpndamount = dr["previouspendingadvance"].ToString();
                getmonthdetail.branchid = dr["branchid"].ToString();
                getmonthdetail.designationcode = dr["deptid"].ToString();
                getmonthdetail.designation = dr["DepartmentName"].ToString();
                getmonthdetail.particulars = dr["particulars"].ToString();
                getmonthdetail.advreqamount = dr["advreqamount"].ToString();
                getmonthdetail.workponumber = dr["workorderpono"].ToString();
                getmonthdetail.advamountrecomnd = dr["advamountrcmd"].ToString();
                getmonthdetail.payorder = dr["payorderfor"].ToString();

                getmonthdetail.doe = dr["doe"].ToString();
                monthlist.Add(getmonthdetail);
            }
            string response = GetJson(monthlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_budget_code(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string budgetcode = context.Request["budgetcode"].ToString();
            string budgetdesc = context.Request["budgetdesc"];
            string UserName = context.Session["UserSno"].ToString();
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into budgetmaster (budgetcode,budgetdesc,doe,createdby) values (@budgetcode,@budgetdesc,@doe,@createdby)");
                cmd.Parameters.Add("@budgetcode", budgetcode);
                cmd.Parameters.Add("@budgetdesc", budgetdesc);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update budgetmaster set budgetcode=@budgetcode,budgetdesc=@budgetdesc,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@budgetcode", budgetcode);
                cmd.Parameters.Add("@budgetdesc", budgetdesc);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class budgetmaster
    {
        public string budgetcode { get; set; }
        public string budgetdesc { get; set; }
        public string sno { get; set; }

    }

    private void get_budget_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  sno,budgetcode,budgetdesc from budgetmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<budgetmaster> budgetlist = new List<budgetmaster>();
            foreach (DataRow dr in routes.Rows)
            {
                budgetmaster getbudgetdetail = new budgetmaster();
                getbudgetdetail.budgetcode = dr["budgetcode"].ToString();
                getbudgetdetail.budgetdesc = dr["budgetdesc"].ToString();
                getbudgetdetail.sno = dr["sno"].ToString();
                budgetlist.Add(getbudgetdetail);
            }
            string response = GetJson(budgetlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_cost_center(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string costcode = context.Request["costcentercode"].ToString();
            string costdesc = context.Request["costcenterdesc"];
            string UserName = context.Session["UserSno"].ToString();
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into costcenter_master (costcentercode,costcenterdesc,doe,createdby) values (@costcode,@costcenterdesc,@doe,@createdby)");
                cmd.Parameters.Add("@costcode", costcode);
                cmd.Parameters.Add("@costcenterdesc", costdesc);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update costcenter_master set costcentercode=@costcode,costcenterdesc=@costcenterdesc,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@costcode", costcode);
                cmd.Parameters.Add("@costcenterdesc", costdesc);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class costmaster
    {
        public string costcentercode { get; set; }
        public string costcenterdescr { get; set; }
        public string sno { get; set; }

    }

    private void get_costcenter_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  sno,costcentercode,costcenterdesc from costcenter_master");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<costmaster> costcenterlist = new List<costmaster>();
            foreach (DataRow dr in routes.Rows)
            {
                costmaster getcostdetail = new costmaster();
                getcostdetail.costcentercode = dr["costcentercode"].ToString();
                getcostdetail.costcenterdescr = dr["costcenterdesc"].ToString();
                getcostdetail.sno = dr["sno"].ToString();
                costcenterlist.Add(getcostdetail);
            }
            string response = GetJson(costcenterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_cattlefeed_sales(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string erngdedu = context.Request["erngdedu"];
            string groupcode1 = context.Request["groupcode1"];
            string groupname1 = context.Request["groupname1"];
            string glcode1 = context.Request["glcode1"];
            string groupid1 = context.Request["groupid1"];
            string groupid2 = context.Request["groupid2"];
            string glid1 = context.Request["glid1"];
            string glid2 = context.Request["glid2"];

            string glname1 = context.Request["glname1"];
            string groupcode2 = context.Request["groupcode2"];
            string groupname2 = context.Request["groupname2"];
            string glcode2 = context.Request["glcode2"];

            string glname2 = context.Request["glname2"];
            string sno = context.Request["sno"];

            string btn_save = context.Request["btnval"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into cattle_feed_sales (earndeductcode,debitgroupcode,debitglcode,creditgroupcode,creditglcode,doe,createdby) values (@earndeductcode,@debitgroupcode,@debitglcode,@creditgroupcode,@creditglcode,@doe,@createdby)");
                //earndeductcode,debitgroupcode,debitglcode,creditgroupcode,creditglcode,doe,createdby
                cmd.Parameters.Add("@earndeductcode", erngdedu);
                cmd.Parameters.Add("@debitgroupcode", groupid1);
                cmd.Parameters.Add("@debitglcode", glid1);
                cmd.Parameters.Add("@creditgroupcode", groupid2);
                cmd.Parameters.Add("@creditglcode", glid2);

                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("Update cattle_feed_sales set earndeductcode=@earndeductcode,debitgroupcode=@debitgroupcode,debitglcode=@debitglcode,creditgroupcode=@creditgroupcode,creditglcode=@creditglcode,doe=@doe,createdby=@createdby where sno=@sno");
                cmd.Parameters.Add("@earndeductcode", erngdedu);
                cmd.Parameters.Add("@debitgroupcode", groupid1);
                cmd.Parameters.Add("@debitglcode", glid1);
                cmd.Parameters.Add("@creditgroupcode", groupid2);
                cmd.Parameters.Add("@creditglcode", glid2);

                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class cattlefeed
    {
        public string erngdedu { get; set; }
        public string groupcode1 { get; set; }
        public string groupname1 { get; set; }
        public string glcode1 { get; set; }
        public string glname1 { get; set; }
        public string groupcode2 { get; set; }
        public string groupname2 { get; set; }
        public string glcode2 { get; set; }

        public string glname2 { get; set; }
        public string groupid1 { get; set; }
        public string glid1 { get; set; }
        public string groupid2 { get; set; }
        public string glid2 { get; set; }
        public string sno { get; set; }
        public string doe { get; set; }
    }

    private void get_cattlefeed_sales(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT  cattle_feed_sales.sno, cattle_feed_sales.earndeductcode, cattle_feed_sales.debitgroupcode, cattle_feed_sales.debitglcode, cattle_feed_sales.creditgroupcode,  cattle_feed_sales.creditglcode, cattle_feed_sales.doe, primarygroup.shortdesc, primarygroup.longdesc, groupledgermaster.groupcode,  groupledgermaster.groupshortdesc, primarygroup_1.shortdesc AS Expr1, primarygroup_1.longdesc AS Expr2, groupledgermaster_1.groupcode AS Expr3,  groupledgermaster_1.groupshortdesc AS Expr4 FROM cattle_feed_sales INNER JOIN  primarygroup ON cattle_feed_sales.debitgroupcode = primarygroup.sno INNER JOIN groupledgermaster ON cattle_feed_sales.debitglcode = groupledgermaster.sno INNER JOIN primarygroup AS primarygroup_1 ON cattle_feed_sales.creditgroupcode = primarygroup_1.sno INNER JOIN groupledgermaster AS groupledgermaster_1 ON cattle_feed_sales.creditglcode = groupledgermaster_1.sno");
            //SELECT   cattle_feed_sales.sno, cattle_feed_sales.earndeductcode, cattle_feed_sales.debitgroupcode, cattle_feed_sales.debitglcode, cattle_feed_sales.creditgroupcode,  cattle_feed_sales.creditglcode, cattle_feed_sales.doe, cattle_feed_sales.createdby, groupledgermaster.groupcode AS groupid1,  groupledgermaster.groupshortdesc AS groupname1, gl_details.glcode AS glid, gl_details.short_desc AS glname1, groupledgermaster_1.groupcode AS groupid2,  groupledgermaster_1.groupshortdesc AS groupname2, gl_details_1.glcode AS glid2, gl_details_1.short_desc AS glname2 FROM  cattle_feed_sales INNER JOIN  gl_details AS gl_details_1 ON cattle_feed_sales.creditglcode = gl_details_1.sno LEFT OUTER JOIN groupledgermaster ON cattle_feed_sales.debitgroupcode = groupledgermaster.sno LEFT OUTER JOIN  gl_details ON cattle_feed_sales.debitglcode = gl_details.sno LEFT OUTER JOIN  groupledgermaster AS groupledgermaster_1 ON cattle_feed_sales.creditgroupcode = groupledgermaster_1.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<cattlefeed> monthlist = new List<cattlefeed>();
            foreach (DataRow dr in routes.Rows)
            {
                cattlefeed getmonthdetail = new cattlefeed();
                getmonthdetail.erngdedu = dr["earndeductcode"].ToString();
                getmonthdetail.groupcode1 = dr["shortdesc"].ToString();
                getmonthdetail.groupid1 = dr["debitgroupcode"].ToString();
                getmonthdetail.groupname1 = dr["longdesc"].ToString();
                getmonthdetail.glcode1 = dr["groupshortdesc"].ToString();
                getmonthdetail.glid1 = dr["debitglcode"].ToString();
                getmonthdetail.glname1 = dr["groupcode"].ToString();

                getmonthdetail.groupcode2 = dr["Expr1"].ToString();
                getmonthdetail.groupid2 = dr["creditgroupcode"].ToString();
                getmonthdetail.groupname2 = dr["Expr2"].ToString();
                getmonthdetail.glcode2 = dr["Expr4"].ToString();
                getmonthdetail.glid2 = dr["creditglcode"].ToString();
                getmonthdetail.glname2 = dr["Expr3"].ToString();
                getmonthdetail.sno = dr["sno"].ToString();
                getmonthdetail.doe = dr["doe"].ToString();
                monthlist.Add(getmonthdetail);
            }
            string response = GetJson(monthlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_miscellaneousbillentry_click(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            miscellaneous obj = js.Deserialize<miscellaneous>(title1);
            string transatondate = obj.transatondate.TrimEnd();
            string financeyear = obj.financeyear.TrimEnd();
            string ntrofwork = obj.ntrofwork.TrimEnd();
            string naturename = obj.naturename.TrimEnd();
            string status = obj.status.TrimEnd();

            string name = obj.name.TrimEnd();
            string nameid = obj.nameid.TrimEnd();
            string advreqamount = obj.advreqamount.TrimEnd();
            string advreqdate = obj.advreqdate.TrimEnd();

            string departmentcode = obj.departmentcode.TrimEnd();
            string departmentname = obj.departmentname.TrimEnd();
            string particulars = obj.particulars.TrimEnd();
            string totalamount = obj.totalamount.TrimEnd();

            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            string modifiedby = context.Session["UserSno"].ToString();

            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into miscellaneous_billdetails (status,transactiondate,financialyear,natureofwork,employeid,advancereqno,advreqdate,deptid,particulars,totalamount,createdby,doe) values (@status,@transactiondate,@financialyear,@natureofwork,@employeid,@advancereqno,@advreqdate,@deptid,@particulars,@totalamount,@createdby,@doe)");
                //transactiondate,financialyear,natureofwork,employeid,advancereqno,advreqdate,deptid,particulars,totalamount,createdby,doe
                cmd.Parameters.Add("@transactiondate", transatondate);
                cmd.Parameters.Add("@financialyear", financeyear);
                cmd.Parameters.Add("@natureofwork", ntrofwork);
                cmd.Parameters.Add("@employeid", nameid);
                cmd.Parameters.Add("@advancereqno", advreqamount);
                cmd.Parameters.Add("@advreqdate", advreqdate);

                cmd.Parameters.Add("@deptid", departmentcode);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@totalamount", totalamount);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);

                cmd.Parameters.Add("@status", status);
                vdm.insert(cmd);

                cmd = new SqlCommand("Select  MAX(sno) as sno from miscellaneous_billdetails");
                DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
                string miscellaneous_refno = dtpo.Rows[0]["sno"].ToString();
                foreach (miscellaneoussub o in obj.mbe_array)
                {

                    cmd = new SqlCommand("insert into miscellaneous_bill_subdetails(miscellaneous_refno,costcentercode,budgetcode,grnno,vendorcode,name,billno,billdate,item,description,uom,quantity,rate,amount,remarks)values(@miscellaneous_refno,@costcentercode,@budgetcode,@grnno,@vendorcode,@name,@billno,@billdate,@item,@description,@uom,@quantity,@rate,@amount,@remarks)");
                    //miscellaneous_refno,costcentercode,budgetcode,grnno,vendorcode,name,billno,billdate,item,description,uom,quantity,rate,amount,remarks
                    cmd.Parameters.Add("@miscellaneous_refno", miscellaneous_refno);
                    cmd.Parameters.Add("@costcentercode", o.costcode);
                    cmd.Parameters.Add("@budgetcode", o.budgectcode);
                    cmd.Parameters.Add("@grnno", o.grnno);
                    cmd.Parameters.Add("@vendorcode", o.vendorcode);
                    cmd.Parameters.Add("@name", o.vendorname);
                    cmd.Parameters.Add("@billno", o.billno);

                    cmd.Parameters.Add("@billdate", o.billdate);
                    cmd.Parameters.Add("@item", o.item);
                    cmd.Parameters.Add("@description", o.description);
                    cmd.Parameters.Add("@uom", o.uom);
                    cmd.Parameters.Add("@quantity", o.quantity);
                    cmd.Parameters.Add("@rate", o.rate);
                    cmd.Parameters.Add("@amount", o.amount);
                    cmd.Parameters.Add("@remarks", o.remarks);
                    vdm.insert(cmd);
                }
                string msg = "Successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = obj.sno.TrimEnd();
                cmd = new SqlCommand("update miscellaneous_billdetails set status=@status,transactiondate=@transactiondate,financialyear=@financialyear,natureofwork=@natureofwork,employeid=@employeid,advancereqno=@advancereqno,advreqdate=@advreqdate,deptid=@deptid,particulars=@particulars,totalamount=@totalamount,modifiedby=@modifiedby,modifieddate=@modifieddate  where sno=@sno");
                //transactiondate,financialyear,natureofwork,employeid,advancereqno,advreqdate,deptid,particulars,totalamount,modifiedby,modifieddate
                cmd.Parameters.Add("@transactiondate", transatondate);
                cmd.Parameters.Add("@financialyear", financeyear);
                cmd.Parameters.Add("@natureofwork", ntrofwork);
                cmd.Parameters.Add("@employeid", nameid);
                cmd.Parameters.Add("@advancereqno", advreqamount);
                cmd.Parameters.Add("@advreqdate", advreqdate);
                cmd.Parameters.Add("@deptid", departmentcode);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@totalamount", totalamount);

                cmd.Parameters.Add("@modifiedby", modifiedby);
                cmd.Parameters.Add("@modifieddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@miscellaneous_refno", sno.Trim());
                vdm.Update(cmd);
                foreach (miscellaneoussub o in obj.mbe_array)
                {

                    string sno1 = o.hdnproductsno;
                    string refno = o.refno;
                    cmd = new SqlCommand("update miscellaneous_bill_subdetails set costcentercode=@costcentercode,budgetcode=@budgetcode,grnno=@grnno,vendorcode=@vendorcode,name=@name,billno=@billno,billdate=@billdate,item=@item,description=@description,uom=@uom,quantity=@quantity,rate=@rate,amount=@amount,remarks=@remarks where miscellaneous_refno=@miscellaneous_refno and sno=@sno");
                    //partycode,remarks,amount,chequeno,chequedate,doe,refno
                    cmd.Parameters.Add("@costcentercode", o.costcode);
                    cmd.Parameters.Add("@budgetcode", o.budgectcode);
                    cmd.Parameters.Add("@grnno", o.grnno);
                    cmd.Parameters.Add("@vendorcode", o.vendorcode);
                    cmd.Parameters.Add("@name", o.vendorname);
                    cmd.Parameters.Add("@billno", o.billno);
                    cmd.Parameters.Add("@billdate", o.billdate);
                    cmd.Parameters.Add("@item", o.item);
                    cmd.Parameters.Add("@description", o.description);
                    cmd.Parameters.Add("@uom", o.uom);
                    cmd.Parameters.Add("@quantity", o.quantity);
                    cmd.Parameters.Add("@rate", o.rate);
                    cmd.Parameters.Add("@amount", o.amount);
                    cmd.Parameters.Add("@remarks", o.remarks);

                    cmd.Parameters.Add("@miscellaneous_refno", refno);
                    cmd.Parameters.Add("@sno", sno1);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into miscellaneous_bill_subdetails(miscellaneous_refno,costcentercode,budgetcode,grnno,vendorcode,name,billno,billdate,item,description,uom,quantity,rate,amount,remarks)values(@miscellaneous_refno,@costcentercode,@budgetcode,@grnno,@vendorcode,@name,@billno,@billdate,@item,@description,@uom,@quantity,@rate,@amount,@remarks)");
                        //miscellaneous_refno,costcentercode,budgetcode,grnno,vendorcode,name,billno,billdate,item,description,uom,quantity,rate,amount,remarks
                        cmd.Parameters.Add("@miscellaneous_refno", refno);
                        cmd.Parameters.Add("@costcentercode", o.costcode);
                        cmd.Parameters.Add("@budgetcode", o.budgectcode);
                        cmd.Parameters.Add("@grnno", o.grnno);
                        cmd.Parameters.Add("@vendorcode", o.vendorcode);
                        cmd.Parameters.Add("@name", o.vendorname);
                        cmd.Parameters.Add("@billno", o.billno);

                        cmd.Parameters.Add("@billdate", o.billdate);
                        cmd.Parameters.Add("@item", o.item);
                        cmd.Parameters.Add("@description", o.description);
                        cmd.Parameters.Add("@uom", o.uom);
                        cmd.Parameters.Add("@quantity", o.quantity);
                        cmd.Parameters.Add("@rate", o.rate);
                        cmd.Parameters.Add("@amount", o.amount);
                        cmd.Parameters.Add("@remarks", o.remarks);
                        vdm.insert(cmd);
                    }
                }
                string msg = " Successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class miscellaneous
    {
        public string transatondate { get; set; }
        public string financeyear { get; set; }
        public string year { get; set; }
        public string ntrofwork { get; set; }
        public string naturename { get; set; }
        public string name { get; set; }
        public string desgnation { get; set; }
        public string nameid { get; set; }
        public string advreqamount { get; set; }
        public string advreqdate { get; set; }
        public string natureofworkid { get; set; }
        public string departmentid { get; set; }

        public string departmentcode { get; set; }
        public string departmentname { get; set; }
        public string particulars { get; set; }
        public string totalamount { get; set; }
        public string sno { get; set; }
        public string btnval { get; set; }
        public string status { get; set; }
        public string status1 { get; set; }
        public List<miscellaneoussub> mbe_array { get; set; }
    }

    public class miscellaneoussub
    {
        public string sno { get; set; }
        public string miscellaneous_refno { get; set; }
        public string costcode { get; set; }
        public string budgectcode { get; set; }
        public string grnno { get; set; }
        public string vendorcode { get; set; }
        public string vendorname { get; set; }
        public string billno { get; set; }
        public string billdate { get; set; }
        public string item { get; set; }
        public string description { get; set; }
        public string costcenterid { get; set; }
        public string budgectid { get; set; }

        public string uom { get; set; }
        public string quantity { get; set; }
        public string rate { get; set; }
        public string amount { get; set; }
        public string remarks { get; set; }
        public string hdnproductsno { get; set; }
        public string refno { get; set; }
        public string sno1 { get; set; }
    }
    public class getmiscellaneous
    {
        public List<miscellaneous> miscellaneous { get; set; }
        public List<miscellaneoussub> miscellaneoussub { get; set; }
    }
    private void get_miscellaneousbillentry_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT  miscellaneous_billdetails.sno, miscellaneous_billdetails.status, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear,  miscellaneous_billdetails.natureofwork, miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate,  miscellaneous_billdetails.deptid, miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_billdetails.createdby,  miscellaneous_billdetails.doe, miscellaneous_billdetails.modifiedby, miscellaneous_billdetails.modifieddate, miscellaneous_bill_subdetails.sno AS sno1,  miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode,  miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno,  miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom,  miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks,  financialyeardetails.year, natureofwork.sno AS natureofworkid, natureofwork.shortdescription, employe_login.name AS employname,   Departmentdetails.DepartmentName, Departmentdetails.DepartmentCode, costcenter_master.costcentercode AS costcenterid,  budgetmaster.budgetcode AS budgectid FROM  miscellaneous_billdetails INNER JOIN  miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno LEFT OUTER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno LEFT OUTER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno LEFT OUTER JOIN employe_login ON miscellaneous_billdetails.employeid = employe_login.sno LEFT OUTER JOIN  Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno LEFT OUTER JOIN  costcenter_master ON miscellaneous_bill_subdetails.costcentercode = costcenter_master.sno LEFT OUTER JOIN budgetmaster ON miscellaneous_bill_subdetails.budgetcode = budgetmaster.sno");
            //SELECT   miscellaneous_billdetails.sno, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear, miscellaneous_billdetails.natureofwork,  miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate, miscellaneous_billdetails.deptid,  miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_billdetails.createdby, miscellaneous_billdetails.doe,   miscellaneous_billdetails.modifiedby, miscellaneous_billdetails.modifieddate, miscellaneous_bill_subdetails.sno AS sno1,  miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode,  miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno,  miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom,  miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks,   financialyeardetails.year, natureofwork.sno AS natureofworkid, natureofwork.shortdescription, employe_login.name AS employeeid,  Departmentdetails.DepartmentName, Departmentdetails.DepartmentCode, costcenter_master.costcentercode AS costcenterid,   budgetmaster.budgetcode AS budgectid FROM   miscellaneous_billdetails INNER JOIN  miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno INNER JOIN  natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno INNER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno INNER JOIN employe_login ON miscellaneous_billdetails.employeid = employe_login.sno INNER JOIN  Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno INNER JOIN costcenter_master ON miscellaneous_bill_subdetails.costcentercode = costcenter_master.sno INNER JOIN budgetmaster ON miscellaneous_bill_subdetails.budgetcode = budgetmaster.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtchq = view.ToTable(true, "sno", "status", "transactiondate", "financialyear", "year", "natureofwork", "natureofworkid", "shortdescription", "employeid", "employname", "advancereqno", "advreqdate", "deptid", "DepartmentName", "DepartmentCode", "particulars", "totalamount");
            DataTable dtchqsub = view.ToTable(true, "sno", "sno1", "miscellaneous_refno", "costcentercode", "costcenterid", "budgetcode", "budgectid", "grnno", "vendorcode", "name", "billno", "billdate", "item", "description", "uom", "quantity", "rate", "amount", "remarks");
            List<getmiscellaneous> getmiscellaneous = new List<getmiscellaneous>();
            List<miscellaneous> miscellaneous = new List<miscellaneous>();
            List<miscellaneoussub> miscellaneoussub = new List<miscellaneoussub>();
            foreach (DataRow dr in dtchq.Rows)
            {
                miscellaneous getpurchasedetails = new miscellaneous();
                getpurchasedetails.sno = dr["sno"].ToString();

                getpurchasedetails.transatondate = ((DateTime)dr["transactiondate"]).ToString("yyyy-MM-dd");
                getpurchasedetails.financeyear = dr["financialyear"].ToString();
                getpurchasedetails.year = dr["year"].ToString();
                getpurchasedetails.ntrofwork = dr["natureofwork"].ToString();
                getpurchasedetails.natureofworkid = dr["natureofworkid"].ToString();
                getpurchasedetails.naturename = dr["shortdescription"].ToString();

                getpurchasedetails.nameid = dr["employeid"].ToString();
                getpurchasedetails.name = dr["employname"].ToString();
                getpurchasedetails.advreqamount = dr["advancereqno"].ToString();
                getpurchasedetails.advreqdate = ((DateTime)dr["advreqdate"]).ToString("yyyy-MM-dd"); // dr["advreqdate"].ToString();
                getpurchasedetails.departmentid = dr["deptid"].ToString();

                getpurchasedetails.departmentname = dr["DepartmentName"].ToString();
                getpurchasedetails.departmentcode = dr["DepartmentCode"].ToString();
                getpurchasedetails.particulars = dr["particulars"].ToString();
                getpurchasedetails.totalamount = dr["totalamount"].ToString();
                getpurchasedetails.status = dr["status"].ToString();
                miscellaneous.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtchqsub.Rows)
            {
                //"sno", "sno1", "miscellaneous_refno", "costcentercode","costcenterid","budgetcode","budgectid","grnno","vendorcode","name","billno","billdate","item","description","uom","quantity","rate","amount","remarks"
                miscellaneoussub getroutes = new miscellaneoussub();
                getroutes.miscellaneous_refno = dr["miscellaneous_refno"].ToString();
                getroutes.costcode = dr["costcentercode"].ToString();
                getroutes.costcenterid = dr["costcenterid"].ToString();
                getroutes.budgectcode = dr["budgetcode"].ToString();
                getroutes.budgectid = dr["budgectid"].ToString();
                getroutes.grnno = dr["grnno"].ToString();

                getroutes.vendorcode = dr["vendorcode"].ToString();
                getroutes.vendorname = dr["name"].ToString();
                getroutes.billno = dr["billno"].ToString();
                getroutes.billdate = ((DateTime)dr["billdate"]).ToString("yyyy-MM-dd");
                getroutes.item = dr["item"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.uom = dr["uom"].ToString();

                getroutes.quantity = dr["quantity"].ToString();
                getroutes.rate = dr["rate"].ToString();
                getroutes.amount = dr["amount"].ToString();
                getroutes.remarks = dr["remarks"].ToString();

                getroutes.sno = dr["sno"].ToString();
                getroutes.sno1 = dr["sno1"].ToString();
                miscellaneoussub.Add(getroutes);
            }
            getmiscellaneous get_purchases = new getmiscellaneous();
            get_purchases.miscellaneous = miscellaneous;
            get_purchases.miscellaneoussub = miscellaneoussub;
            getmiscellaneous.Add(get_purchases);
            string response = GetJson(getmiscellaneous);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private void updtae_approvalmiscellaneousbill_click(HttpContext context)
    {
        vdm = new VehicleDBMgr();
        string sno = context.Request["sno"];
        string btnval = context.Request["btnval"];
        string msg = "";
        if (btnval == "Approve")
        {
            cmd = new SqlCommand("UPDATE miscellaneous_billdetails SET status='A' Where sno=@sno");
            msg = "Approved successfully";
        }
        else
        {
            cmd = new SqlCommand("UPDATE miscellaneous_billdetails SET status='P' Where sno=@sno");
            msg = "Pending";
        }
        cmd.Parameters.Add("@sno", sno);
        vdm.Update(cmd);
        string Response = GetJson(msg);
        context.Response.Write(Response);
    }
    private void get_appmiscellaneousbillentry_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT   miscellaneous_billdetails.sno, miscellaneous_billdetails.status, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear,   miscellaneous_billdetails.natureofwork, miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate,  miscellaneous_billdetails.deptid, miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_billdetails.createdby,  miscellaneous_billdetails.doe, miscellaneous_billdetails.modifiedby, miscellaneous_billdetails.modifieddate, miscellaneous_bill_subdetails.sno AS sno1,  miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode,  miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno,  miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom,   miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks,  financialyeardetails.year, natureofwork.sno AS natureofworkid, natureofwork.shortdescription, employe_login.name AS employname,  Departmentdetails.DepartmentName, Departmentdetails.DepartmentCode, costcenter_master.costcentercode AS costcenterid,    budgetmaster.budgetcode AS budgectid FROM  miscellaneous_billdetails INNER JOIN miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno LEFT OUTER JOIN natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno LEFT OUTER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno LEFT OUTER JOIN employe_login ON miscellaneous_billdetails.employeid = employe_login.sno LEFT OUTER JOIN Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno LEFT OUTER JOIN costcenter_master ON miscellaneous_bill_subdetails.costcentercode = costcenter_master.sno LEFT OUTER JOIN  budgetmaster ON miscellaneous_bill_subdetails.budgetcode = budgetmaster.sno WHERE (miscellaneous_billdetails.status = 'P')");
            //SELECT   miscellaneous_billdetails.sno, miscellaneous_billdetails.transactiondate, miscellaneous_billdetails.financialyear, miscellaneous_billdetails.natureofwork,  miscellaneous_billdetails.employeid, miscellaneous_billdetails.advancereqno, miscellaneous_billdetails.advreqdate, miscellaneous_billdetails.deptid,  miscellaneous_billdetails.particulars, miscellaneous_billdetails.totalamount, miscellaneous_billdetails.createdby, miscellaneous_billdetails.doe,   miscellaneous_billdetails.modifiedby, miscellaneous_billdetails.modifieddate, miscellaneous_bill_subdetails.sno AS sno1,  miscellaneous_bill_subdetails.miscellaneous_refno, miscellaneous_bill_subdetails.costcentercode, miscellaneous_bill_subdetails.budgetcode,  miscellaneous_bill_subdetails.grnno, miscellaneous_bill_subdetails.vendorcode, miscellaneous_bill_subdetails.name, miscellaneous_bill_subdetails.billno,  miscellaneous_bill_subdetails.billdate, miscellaneous_bill_subdetails.item, miscellaneous_bill_subdetails.description, miscellaneous_bill_subdetails.uom,  miscellaneous_bill_subdetails.quantity, miscellaneous_bill_subdetails.rate, miscellaneous_bill_subdetails.amount, miscellaneous_bill_subdetails.remarks,   financialyeardetails.year, natureofwork.sno AS natureofworkid, natureofwork.shortdescription, employe_login.name AS employeeid,  Departmentdetails.DepartmentName, Departmentdetails.DepartmentCode, costcenter_master.costcentercode AS costcenterid,   budgetmaster.budgetcode AS budgectid FROM   miscellaneous_billdetails INNER JOIN  miscellaneous_bill_subdetails ON miscellaneous_billdetails.sno = miscellaneous_bill_subdetails.miscellaneous_refno INNER JOIN  natureofwork ON miscellaneous_billdetails.natureofwork = natureofwork.sno INNER JOIN financialyeardetails ON miscellaneous_billdetails.financialyear = financialyeardetails.sno INNER JOIN employe_login ON miscellaneous_billdetails.employeid = employe_login.sno INNER JOIN  Departmentdetails ON miscellaneous_billdetails.deptid = Departmentdetails.sno INNER JOIN costcenter_master ON miscellaneous_bill_subdetails.costcentercode = costcenter_master.sno INNER JOIN budgetmaster ON miscellaneous_bill_subdetails.budgetcode = budgetmaster.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtchq = view.ToTable(true, "sno", "status", "transactiondate", "financialyear", "year", "natureofwork", "natureofworkid", "shortdescription", "employeid", "employname", "advancereqno", "advreqdate", "deptid", "DepartmentName", "DepartmentCode", "particulars", "totalamount");
            DataTable dtchqsub = view.ToTable(true, "sno", "sno1", "miscellaneous_refno", "costcentercode", "costcenterid", "budgetcode", "budgectid", "grnno", "vendorcode", "name", "billno", "billdate", "item", "description", "uom", "quantity", "rate", "amount", "remarks");
            List<getmiscellaneous> getmiscellaneous = new List<getmiscellaneous>();
            List<miscellaneous> miscellaneous = new List<miscellaneous>();
            List<miscellaneoussub> miscellaneoussub = new List<miscellaneoussub>();
            foreach (DataRow dr in dtchq.Rows)
            {
                miscellaneous getpurchasedetails = new miscellaneous();
                getpurchasedetails.sno = dr["sno"].ToString();

                getpurchasedetails.transatondate = ((DateTime)dr["transactiondate"]).ToString("yyyy-MM-dd");
                getpurchasedetails.financeyear = dr["financialyear"].ToString();
                getpurchasedetails.year = dr["year"].ToString();
                getpurchasedetails.ntrofwork = dr["natureofwork"].ToString();
                getpurchasedetails.natureofworkid = dr["natureofworkid"].ToString();
                getpurchasedetails.naturename = dr["shortdescription"].ToString();

                getpurchasedetails.nameid = dr["employeid"].ToString();
                getpurchasedetails.name = dr["employname"].ToString();
                getpurchasedetails.advreqamount = dr["advancereqno"].ToString();
                getpurchasedetails.advreqdate = ((DateTime)dr["advreqdate"]).ToString("yyyy-MM-dd"); // dr["advreqdate"].ToString();
                getpurchasedetails.departmentid = dr["deptid"].ToString();

                getpurchasedetails.departmentname = dr["DepartmentName"].ToString();
                getpurchasedetails.departmentcode = dr["DepartmentCode"].ToString();
                getpurchasedetails.particulars = dr["particulars"].ToString();
                getpurchasedetails.totalamount = dr["totalamount"].ToString();
                string status = dr["status"].ToString();
                if (status == "P")
                {
                    status = "Pending";
                }
                getpurchasedetails.status = status;
                getpurchasedetails.status1 = dr["status"].ToString();
                miscellaneous.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtchqsub.Rows)
            {
                //"sno", "sno1", "miscellaneous_refno", "costcentercode","costcenterid","budgetcode","budgectid","grnno","vendorcode","name","billno","billdate","item","description","uom","quantity","rate","amount","remarks"
                miscellaneoussub getroutes = new miscellaneoussub();
                getroutes.miscellaneous_refno = dr["miscellaneous_refno"].ToString();
                getroutes.costcode = dr["costcentercode"].ToString();
                getroutes.costcenterid = dr["costcenterid"].ToString();
                getroutes.budgectcode = dr["budgetcode"].ToString();
                getroutes.budgectid = dr["budgectid"].ToString();
                getroutes.grnno = dr["grnno"].ToString();

                getroutes.vendorcode = dr["vendorcode"].ToString();
                getroutes.vendorname = dr["name"].ToString();
                getroutes.billno = dr["billno"].ToString();
                getroutes.billdate = ((DateTime)dr["billdate"]).ToString("yyyy-MM-dd");
                getroutes.item = dr["item"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.uom = dr["uom"].ToString();

                getroutes.quantity = dr["quantity"].ToString();
                getroutes.rate = dr["rate"].ToString();
                getroutes.amount = dr["amount"].ToString();
                getroutes.remarks = dr["remarks"].ToString();

                getroutes.sno = dr["sno"].ToString();
                getroutes.sno1 = dr["sno1"].ToString();
                miscellaneoussub.Add(getroutes);
            }
            getmiscellaneous get_purchases = new getmiscellaneous();
            get_purchases.miscellaneous = miscellaneous;
            get_purchases.miscellaneoussub = miscellaneoussub;
            getmiscellaneous.Add(get_purchases);
            string response = GetJson(getmiscellaneous);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    public void save_designation_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string desigcode = context.Request["DesignationCode"];
            string designation = context.Request["Designation"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into designationmaster (designation,designationcode,doe,createdby) values (@designation,@designationcode,@doe,@createdby)");
                cmd.Parameters.Add("@designation", designation);
                cmd.Parameters.Add("@designationcode", desigcode);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update designationmaster set designation=@designation,designationcode=@designationcode,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@designation", designation);
                cmd.Parameters.Add("@designationcode", desigcode);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class designationdetails
    {
        public string designation { get; set; }
        public string desigcode { get; set; }
        public string sno { get; set; }

    }

    private void get_designation_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT sno,designation,designationcode,doe,createdby from designationmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<designationdetails> desiglist = new List<designationdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                designationdetails getdesigdetail = new designationdetails();
                getdesigdetail.designation = dr["designation"].ToString();
                getdesigdetail.desigcode = dr["designationcode"].ToString();
                getdesigdetail.sno = dr["sno"].ToString();
                desiglist.Add(getdesigdetail);
            }
            string response = GetJson(desiglist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void save_norms_entry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string Designation = context.Request["Designation"];
            string Fromdate = context.Request["Fromdate"];
            string Todate = context.Request["Todate"];
            string suspenseamount = context.Request["suspenseamount"];
            string daystosettle = context.Request["daystosettle"];
            string particulars = context.Request["particulars"];
            string suspensesettled = context.Request["suspensesettled"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into suspensenorms (designation,fromdate,todate,suspenseamount,daystosettle,particulars,suspensesettled,doe,createdby) values (@designation,@fromdate,@todate,@suspenseamount,@daystosettle,@particulars,@suspensesettled,@doe,@createdby)");
                cmd.Parameters.Add("@designation", Designation);
                cmd.Parameters.Add("@fromdate", Fromdate);
                cmd.Parameters.Add("@todate", Todate);
                cmd.Parameters.Add("@suspenseamount", suspenseamount);
                cmd.Parameters.Add("@daystosettle", daystosettle);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@suspensesettled", suspensesettled);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update suspensenorms set designation=@designation,fromdate=@fromdate,todate=@todate,suspenseamount=@suspenseamount,daystosettle=@daystosettle,particulars=@particulars,suspensesettled=@suspensesettled,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@designation", Designation);
                cmd.Parameters.Add("@fromdate", Fromdate);
                cmd.Parameters.Add("@todate", Todate);
                cmd.Parameters.Add("@suspenseamount", suspenseamount);
                cmd.Parameters.Add("@daystosettle", daystosettle);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@suspensesettled", suspensesettled);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details updated  successfully ";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class suspensenorms
    {
        public string designation { get; set; }
        public string fromdate { get; set; }
        public string sno { get; set; }
        public string todate { get; set; }
        public string suspenseamount { get; set; }
        public string daystosettle { get; set; }
        public string particulars { get; set; }
        public string suspensesettled { get; set; }


        public string designame { get; set; }

        public string desigid { get; set; }

        public string suspense { get; set; }
    }

    private void get_suspensenorms_entry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT designationmaster.designationcode, designationmaster.designation, suspensenorms.sno, suspensenorms.fromdate, suspensenorms.todate, suspensenorms.designation AS desigid, suspensenorms.suspenseamount, suspensenorms.daystosettle, suspensenorms.particulars, suspensenorms.suspensesettled, suspensenorms.doe FROM suspensenorms INNER JOIN designationmaster ON suspensenorms.designation = designationmaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<suspensenorms> normsentry = new List<suspensenorms>();
            foreach (DataRow dr in routes.Rows)
            {
                suspensenorms getnormsentry = new suspensenorms();
                getnormsentry.designation = dr["designationcode"].ToString();
                getnormsentry.fromdate = ((DateTime)dr["fromdate"]).ToString("yyyy-MM-dd");
                getnormsentry.todate = ((DateTime)dr["todate"]).ToString("yyyy-MM-dd");
                getnormsentry.suspenseamount = dr["suspenseamount"].ToString();
                getnormsentry.daystosettle = dr["daystosettle"].ToString();
                getnormsentry.particulars = dr["particulars"].ToString();
                getnormsentry.desigid = dr["desigid"].ToString();
                string suspense = dr["suspensesettled"].ToString();
                if (suspense == "Y")
                {
                    suspense = "Yes";

                }
                else
                {
                    suspense = "NO";

                }
                getnormsentry.suspense = suspense;
                getnormsentry.suspensesettled = dr["suspensesettled"].ToString();
                getnormsentry.designame = dr["designation"].ToString();
                getnormsentry.sno = dr["sno"].ToString();
                normsentry.Add(getnormsentry);
            }
            string response = GetJson(normsentry);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void save_cash_requisition(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string reqno = context.Request["reqno"];
            string reqdate = context.Request["reqdate"];
            string finyear = context.Request["finyear"];
            //string controltype = context.Request["controltype"];
            //string controldesc = context.Request["controldesc"];
            //string Accountcode = context.Request["Accountcode"];
            //string acdesc = context.Request["acdesc"];
            string designation = context.Request["designation"];
            string Employeecode = context.Request["Employeecode"];
            string availamount = context.Request["availamount"];
            string deptcode = context.Request["deptcode"];
            //string costcenter = context.Request["costcenter"];
            //string Costdesc = context.Request["Costdesc"];
            //string budgetcode = context.Request["budgetcode"];
            //string budgetdesc = context.Request["budgetdesc"];
            string reqamount = context.Request["reqamount"];
            string particulars = context.Request["particulars"];
            //string reasoncode = context.Request["reasoncode"];
            //string reasondesc = context.Request["reasondesc"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into  suspensecashrequisition(reqno,reqdate,financialyear,designation,employeecode,availableamount,departmentcode,reqamount,particulars,doe,createdby) values (@reqno,@reqdate,@financialyear,@designation,@employeecode,@availableamount,@departmentcode,@reqamount,@particulars,@doe,@createdby)");
                cmd.Parameters.Add("@reqno", reqno);
                cmd.Parameters.Add("@reqdate", reqdate);
                cmd.Parameters.Add("@financialyear", finyear);
                //cmd.Parameters.Add("@controltype", controltype);
                //cmd.Parameters.Add("@description", controldesc);
                //cmd.Parameters.Add("@accountcode", Accountcode);
                //cmd.Parameters.Add("@acdescription", acdesc);
                cmd.Parameters.Add("@designation", designation);
                cmd.Parameters.Add("@employeecode", Employeecode);
                cmd.Parameters.Add("@availableamount", availamount);
                cmd.Parameters.Add("@departmentcode", deptcode);
                //cmd.Parameters.Add("@costcenter", costcenter);
                //cmd.Parameters.Add("@costdesc", Costdesc);
                //cmd.Parameters.Add("@budgetcode", budgetcode);
                //cmd.Parameters.Add("@budgetdescription", budgetdesc);
                cmd.Parameters.Add("@reqamount", reqamount);
                cmd.Parameters.Add("@particulars", particulars);
                //cmd.Parameters.Add("@reasoncode", reasoncode);
                //cmd.Parameters.Add("@reasondescription", reasondesc);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update suspensecashrequisition set reqno=@reqno,reqdate=@reqdate,financialyear=@financialyear,designation=@designation,employeecode=@employeecode,availableamount=@availableamount,departmentcode=@departmentcode,reqamount=@reqamount,particulars=@particulars where sno=@sno");
                cmd.Parameters.Add("@reqno", reqno);
                cmd.Parameters.Add("@reqdate", reqdate);
                cmd.Parameters.Add("@financialyear", finyear);
                //cmd.Parameters.Add("@controltype", controltype);
                //cmd.Parameters.Add("@description", controldesc);
                //cmd.Parameters.Add("@accountcode", Accountcode);
                //cmd.Parameters.Add("@acdescription", acdesc);
                cmd.Parameters.Add("@designation", designation);
                cmd.Parameters.Add("@employeecode", Employeecode);
                cmd.Parameters.Add("@availableamount", availamount);
                cmd.Parameters.Add("@departmentcode", deptcode);
                //cmd.Parameters.Add("@costcenter", costcenter);
                //cmd.Parameters.Add("@costdesc", Costdesc);
                //cmd.Parameters.Add("@budgetcode", budgetcode);
                //cmd.Parameters.Add("@budgetdescription", budgetdesc);
                cmd.Parameters.Add("@reqamount", reqamount);
                cmd.Parameters.Add("@particulars", particulars);
                //cmd.Parameters.Add("@reasoncode", reasoncode);
                //cmd.Parameters.Add("@reasondescription", reasondesc);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details updated  successfully ";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class suspensecash
    {
        public string reqno { get; set; }
        public string reqdate { get; set; }
        public string sno { get; set; }
        public string finyear { get; set; }
        public string controltype { get; set; }
        public string description { get; set; }
        public string accountcode { get; set; }
        public string acdescription { get; set; }
        public string designation { get; set; }
        public string designame { get; set; }
        public string empcode { get; set; }
        public string empname { get; set; }
        public string availamount { get; set; }
        public string deptcode { get; set; }
        public string deptname { get; set; }
        public string costcenter { get; set; }
        public string costdesc { get; set; }
        public string budgetcode { get; set; }
        public string budgetdesc { get; set; }
        public string reqamount { get; set; }
        public string particulars { get; set; }
        public string reasoncode { get; set; }
        public string reasondesc { get; set; }
        public string deptid { get; set; }
        public string budgetid { get; set; }
        public string contrltypeid { get; set; }
        public string acccode { get; set; }
        public string desigid { get; set; }
        public string costid { get; set; }
        public string empid { get; set; }
    }
    private void get_suspensecash_requisition(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT suspensecashrequisition.sno, suspensecashrequisition.reqno,suspensecashrequisition.employeecode, suspensecashrequisition.reqdate, suspensecashrequisition.financialyear, suspensecashrequisition.designation as desigid,suspensecashrequisition.availableamount, suspensecashrequisition.reqamount, suspensecashrequisition.particulars, suspensecashrequisition.doe, suspensecashrequisition.createdby,suspensecashrequisition.departmentcode, Departmentdetails.DepartmentName, employe_login.name, designationmaster.designation FROM  Departmentdetails INNER JOIN suspensecashrequisition ON Departmentdetails.sno = suspensecashrequisition.departmentcode INNER JOIN employe_login ON suspensecashrequisition.employeecode = employe_login.sno INNER JOIN designationmaster ON suspensecashrequisition.designation = designationmaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<suspensecash> suspcashdetails = new List<suspensecash>();
            foreach (DataRow dr in routes.Rows)
            {
                suspensecash getsuspensecash = new suspensecash();
                getsuspensecash.reqno = dr["reqno"].ToString();
                getsuspensecash.reqdate = ((DateTime)dr["reqdate"]).ToString("yyyy-MM-dd");
                getsuspensecash.finyear = dr["financialyear"].ToString();
               // getsuspensecash.controltype = dr["contrltype"].ToString();
               // getsuspensecash.description = dr["description"].ToString();
               // getsuspensecash.accountcode = dr["acccode"].ToString();
               // getsuspensecash.acdescription = dr["acdescription"].ToString();
                getsuspensecash.designation = dr["designation"].ToString();
                getsuspensecash.empcode = dr["name"].ToString();
                //getsuspensecash.empname = dr["employeename"].ToString();
                getsuspensecash.availamount = dr["availableamount"].ToString();
                getsuspensecash.deptcode = dr["DepartmentName"].ToString();
               // getsuspensecash.costcenter = dr["costname"].ToString();
              //  getsuspensecash.costdesc = dr["costdesc"].ToString();
               // getsuspensecash.budgetcode = dr["budgetname"].ToString();
               // getsuspensecash.budgetdesc = dr["budgetdescription"].ToString();
                getsuspensecash.reqamount = dr["reqamount"].ToString();
                getsuspensecash.particulars = dr["particulars"].ToString();
                //getsuspensecash.reasoncode = dr["reasoncode"].ToString();
               // getsuspensecash.reasondesc = dr["reasondescription"].ToString();
                getsuspensecash.deptid = dr["departmentcode"].ToString();
                getsuspensecash.desigid = dr["desigid"].ToString();
             //   getsuspensecash.acccode = dr["accountcode"].ToString();
               // getsuspensecash.budgetid = dr["budgetcode"].ToString();
               // getsuspensecash.costid = dr["costcenter"].ToString();
                getsuspensecash.empid = dr["employeecode"].ToString();
                //getsuspensecash.contrltypeid = dr["controlid"].ToString();


                getsuspensecash.sno = dr["sno"].ToString();
                suspcashdetails.Add(getsuspensecash);
            }
            string response = GetJson(suspcashdetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_available_amount(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string Designation = context.Request["designation"];
            cmd = new SqlCommand("SELECT  sno, designation, suspenseamount FROM  suspensenorms where designation=@desig");
            cmd.Parameters.Add("@desig", Designation);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<suspensenorms> normsentry = new List<suspensenorms>();
            foreach (DataRow dr in routes.Rows)
            {
                suspensenorms getnormsentry = new suspensenorms();
                getnormsentry.designation = dr["designationcode"].ToString();
                getnormsentry.suspenseamount = dr["suspenseamount"].ToString();
                getnormsentry.sno = dr["sno"].ToString();
                normsentry.Add(getnormsentry);
            }
            string response = GetJson(normsentry);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class susp_bill_entry
    {
        public string transactionno { get; set; }
        public string transactiondate { get; set; }
        public string financialyear { get; set; }
        public string natureofwork { get; set; }
        public string designationcode { get; set; }
        public string designame { get; set; }
        public string empcode { get; set; }
        public string empname { get; set; }
        public string suspreqno { get; set; }
        public string reqdate { get; set; }
        public string reqamount { get; set; }
        public string deptcode { get; set; }
        public string deptname { get; set; }
        public string sectioncode { get; set; }
        public string particulars { get; set; }
        public string actualexpenses { get; set; }
        public string balamount { get; set; }
        public string doe { get; set; }
        public string sno { get; set; }
        public string btn_val { get; set; }
        public string reqid { get; set; }
        public List<bill_subentry> DataTable { get; set; }
        public string totalamount { get; set; }
        public string status { get; set; }

        public string deptid { get; set; }

        public string desigid { get; set; }

        public string empid { get; set; }

        public string workid { get; set; }

        public string suspreqid { get; set; }
    }

    public class bill_subentry
    {

        public string costcentercode { get; set; }
        public string budgetcode { get; set; }
        public string grnno { get; set; }
        public string vendorcode { get; set; }
        public string name { get; set; }
        public string createdby { get; set; }
        public string billno { get; set; }
        public string billdate { get; set; }
        public string Item { get; set; }
        public string Description { get; set; }
        public string UOM { get; set; }
        public string Quantity { get; set; }
        public string Rate { get; set; }
        public string Amount { get; set; }
        public string Remarks { get; set; }
        public string refno { get; set; }
        public string sno { get; set; }
       

    }
    public class getbillentry
    {
        public List<susp_bill_entry> suspbill { get; set; }
        public List<bill_subentry> suspsubentry { get; set; }
    }
    private void save_suspense_billentry(HttpContext context)
    {
        try
        {

            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            susp_bill_entry obj = js.Deserialize<susp_bill_entry>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string transactionno = obj.transactionno;
            string transactiondate = obj.transactiondate;
            string financialyear = obj.financialyear;
            //string natureofwork = obj.natureofwork;
           // string designationcode = obj.designationcode;
          //  string empcode = obj.empcode;
            string suspreqno = obj.suspreqid;
            string reqdate = obj.reqdate;
            string reqamount = obj.reqamount;
            //string deptcode = obj.deptcode;
            string sectioncode = obj.sectioncode;
            string particulars = obj.particulars;
            string actualexpenses = obj.actualexpenses;
            string balamount = obj.balamount;
            string totalamount = obj.totalamount;

            string btn_save = obj.btn_val;

            if (btn_save == "Save")
            {

                cmd = new SqlCommand("insert into suspense_bill_entry (transactionno,transactiondate,financialyear,suspensereqno,reqdate,reqamount,sectioncode,particulars,actualexpenses,balamount,totalamount,status,createdby,doe) values (@transactionno,@transactiondate,@financialyear,@suspensereqno,@reqdate,@reqamount,@sectioncode,@particulars,@actualexpenses,@balamount,@totalamount,@status,@createdby,@doe)");
                cmd.Parameters.Add("@transactionno", transactionno);
                cmd.Parameters.Add("@transactiondate", transactiondate);
                cmd.Parameters.Add("@financialyear", financialyear);
             //   cmd.Parameters.Add("@natureofwork", natureofwork);
               //cmd.Parameters.Add("@designationcode", designationcode);
                //cmd.Parameters.Add("@empcode", empcode);
               cmd.Parameters.Add("@suspensereqno", suspreqno);
                cmd.Parameters.Add("@reqdate", reqdate);
                cmd.Parameters.Add("@reqamount", reqamount);
               // cmd.Parameters.Add("@deptcode", deptcode);
                cmd.Parameters.Add("@sectioncode", sectioncode);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@actualexpenses", actualexpenses);
                cmd.Parameters.Add("@balamount", balamount);
                cmd.Parameters.Add("@totalamount", totalamount);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@status", 'P');
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from suspense_bill_entry ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string refno = routes.Rows[0]["sno"].ToString();
                foreach (bill_subentry si in obj.DataTable)
                {
                    //string costcentercode = si.costcentercode;
                    //string budgetcode = si.budgetcode;
                    string grnno = si.grnno;
                    //string vendorcode = si.vendorcode;
                    //string name = si.name;
                    string billno = si.billno;
                    string billdate = si.billdate;
                    //string Item = si.Item;
                    //string Description = si.Description;
                    //string UOM = si.UOM;
                    //string Quantity = si.Quantity;
                    //string Rate = si.Rate;
                    string Amount = si.Amount;
                    string Remarks = si.Remarks;
                    cmd = new SqlCommand("insert into suspense_bill_subentry (grnno,billno,billdate,amount,remarks,createdby,refno) values (@grnno,@billno,@billdate,@amount,@remarks,@createdby,@refno)");
                   // cmd.Parameters.Add("@costcentercode", costcentercode);
                  //  cmd.Parameters.Add("@budgetcode", budgetcode);
                    cmd.Parameters.Add("@grnno", grnno);
                   // cmd.Parameters.Add("@vendorcode", vendorcode);
                   // cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@billno", billno);
                    cmd.Parameters.Add("@billdate", billdate);
                    //cmd.Parameters.Add("@item", Item);
                    //cmd.Parameters.Add("@description", Description);
                    //cmd.Parameters.Add("@uom", UOM);
                    //cmd.Parameters.Add("@quantity", Quantity);
                    //cmd.Parameters.Add("@rate", Rate);
                    cmd.Parameters.Add("@amount", Amount);
                    cmd.Parameters.Add("@remarks", Remarks);
                  
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@refno", refno);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {

                string Sno = obj.sno;
                cmd = new SqlCommand("UPDATE suspense_bill_entry SET transactionno=@transactionno,transactiondate=@transactiondate,financialyear=@financialyear,suspensereqno=@suspensereqno,reqdate=@reqdate,reqamount=@reqamount,sectioncode=@sectioncode,particulars=@particulars,actualexpenses=@actualexpenses,balamount=@balamount,totalamount=@totalamount,doe=@doe WHERE sno=@sno");
                cmd.Parameters.Add("@transactionno", transactionno);
                cmd.Parameters.Add("@transactiondate", transactiondate);
                cmd.Parameters.Add("@financialyear", financialyear);
               // cmd.Parameters.Add("@natureofwork", natureofwork);
               // cmd.Parameters.Add("@designationcode", designationcode);
               // cmd.Parameters.Add("@empcode", empcode);
                cmd.Parameters.Add("@suspensereqno", suspreqno);
                cmd.Parameters.Add("@reqdate", reqdate);
                cmd.Parameters.Add("@reqamount", reqamount);
                //cmd.Parameters.Add("@deptcode", deptcode);
                cmd.Parameters.Add("@sectioncode", sectioncode);
                cmd.Parameters.Add("@particulars", particulars);
                cmd.Parameters.Add("@actualexpenses", actualexpenses);
                cmd.Parameters.Add("@balamount", balamount);
                cmd.Parameters.Add("@totalamount", totalamount);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", Sno);
                vdm.Update(cmd);

                foreach (bill_subentry si in obj.DataTable)
                {
                 //   string costcentercode = si.costcentercode;
                  //  string budgetcode = si.budgetcode;
                    string grnno = si.grnno;
                   // string vendorcode = si.vendorcode;
                    //string name = si.name;
                    string billno = si.billno;
                    string billdate = si.billdate;
                    //string Item = si.Item;
                   // string Description = si.Description;
                   // string UOM = si.UOM;
                  //  string Quantity = si.Quantity;
                  //  string Rate = si.Rate;
                    string Amount = si.Amount;
                    string Remarks = si.Remarks;
                    string sno = si.sno;
                    cmd = new SqlCommand("update suspense_bill_subentry set grnno=@grnno, billno=@billno,billdate=@billdate,amount=@amount,remarks=@remarks,createdby=@createdby where sno=@sno");
                   // cmd.Parameters.Add("@costcentercode", costcentercode);
                   // cmd.Parameters.Add("@budgetcode", budgetcode);
                    cmd.Parameters.Add("@grnno", grnno);
                   // cmd.Parameters.Add("@vendorcode", vendorcode);
                  //  cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@billno", billno);
                    cmd.Parameters.Add("@billdate", billdate);
                    //cmd.Parameters.Add("@item", Item);
                    //cmd.Parameters.Add("@description", Description);
                  //  cmd.Parameters.Add("@uom", UOM);
                  //  cmd.Parameters.Add("@quantity", Quantity);
                  //  cmd.Parameters.Add("@rate", Rate);
                    cmd.Parameters.Add("@amount", Amount);
                    cmd.Parameters.Add("@remarks", Remarks);
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    vdm.Update(cmd);
                }
                string msg = "successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_suspense_billentry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
          //  cmd = new SqlCommand("SELECT suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate, suspense_bill_entry.financialyear, suspense_bill_entry.empcode as empid, suspense_bill_entry.suspensereqno as reqid, suspense_bill_entry.reqdate, suspense_bill_entry.reqamount, suspense_bill_entry.deptcode as deptid, suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses, suspense_bill_entry.totalamount,suspense_bill_entry.balamount,suspense_bill_entry.natureofwork as workid, suspense_bill_entry.doe, suspense_bill_entry.createdby, suspense_bill_entry.status, suspense_bill_subentry.sno AS Expr1, suspense_bill_subentry.budgetcode, suspense_bill_subentry.costcentercode, suspense_bill_subentry.vendorcode, suspense_bill_subentry.grnno, suspense_bill_subentry.name, suspense_bill_subentry.billno, suspense_bill_subentry.billdate, suspense_bill_subentry.item,suspense_bill_subentry.description, suspense_bill_subentry.uom, suspense_bill_subentry.quantity, suspense_bill_subentry.rate, suspense_bill_subentry.amount, suspense_bill_subentry.doe AS Expr2, suspense_bill_subentry.createdby AS Expr3, suspense_bill_subentry.remarks, suspense_bill_entry.sno, suspense_bill_subentry.refno, designationmaster.designation as designationcode, natureofwork.sno AS workcode, suspense_bill_entry.designationcode as desigid, suspense_bill_entry.natureofwork, Departmentdetails.DepartmentName as deptcode, employe_login.name AS empcode FROM  suspense_bill_entry INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno INNER JOIN designationmaster ON suspense_bill_entry.designationcode = designationmaster.sno INNER JOIN natureofwork ON suspense_bill_entry.natureofwork = natureofwork.sno INNER JOIN Departmentdetails ON suspense_bill_entry.deptcode = Departmentdetails.sno INNER JOIN employe_login ON suspense_bill_entry.empcode = employe_login.sno");
            cmd = new SqlCommand("SELECT suspense_bill_subentry.refno, suspensecashrequisition.sno, suspense_bill_entry.suspensereqno as reqid, suspensecashrequisition.reqno, suspensecashrequisition.reqdate, suspensecashrequisition.availableamount,suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate, suspense_bill_entry.financialyear, suspense_bill_entry.reqdate AS Expr1, suspense_bill_entry.reqamount,suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses, suspense_bill_entry.balamount, suspense_bill_entry.totalamount, suspense_bill_entry.status,suspense_bill_subentry.grnno, suspense_bill_subentry.billno, suspense_bill_subentry.billdate, suspense_bill_subentry.amount,suspense_bill_subentry.remarks FROM  suspense_bill_entry INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno INNER JOIN suspensecashrequisition ON suspense_bill_entry.suspensereqno = suspensecashrequisition.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);

            DataTable dtsuspbills = view.ToTable(true, "sno", "transactionno", "transactiondate", "financialyear","reqdate", "reqamount","sectioncode", "particulars", "actualexpenses", "balamount","totalamount", "status","reqno", "reqid");
            DataTable dtsuspbillssubentry = view.ToTable(true, "sno","grnno","billno", "billdate","amount", "remarks");
            List<getbillentry> getbilldetails = new List<getbillentry>();
            List<susp_bill_entry> suspensebillslist = new List<susp_bill_entry>();
            List<bill_subentry> suspensesubentrylist = new List<bill_subentry>();
            foreach (DataRow dr in dtsuspbills.Rows)
            {
                susp_bill_entry getbills = new susp_bill_entry();
                getbills.transactionno = dr["transactionno"].ToString();
                getbills.transactiondate = ((DateTime)dr["transactiondate"]).ToString("yyyy-MM-dd");
                getbills.financialyear = dr["financialyear"].ToString();
              //  getbills.natureofwork = dr["natureofwork"].ToString();
               // getbills.designationcode = dr["designationcode"].ToString();
               // getbills.empcode = dr["empcode"].ToString();
                getbills.suspreqno = dr["reqno"].ToString();
                getbills.reqid = dr["reqid"].ToString();
                getbills.reqdate = ((DateTime)dr["reqdate"]).ToString("yyyy-MM-dd");//dr["invoicedate"].ToString();
                getbills.reqamount = dr["reqamount"].ToString();
              //  getbills.deptcode = dr["deptcode"].ToString();
              //  getbills.deptid = dr["deptid"].ToString();
               // getbills.desigid = dr["desigid"].ToString();
               // getbills.empid = dr["empid"].ToString();
               // getbills.workid = dr["workid"].ToString();
                getbills.sectioncode = dr["sectioncode"].ToString();
                getbills.particulars = dr["particulars"].ToString();
                getbills.actualexpenses = dr["actualexpenses"].ToString();
                getbills.balamount = dr["balamount"].ToString();
                getbills.totalamount = dr["totalamount"].ToString();
                string status = dr["status"].ToString();
                if (status == "P")
                {
                    getbills.status = "Pending";
                }
                getbills.sno = dr["sno"].ToString();
                suspensebillslist.Add(getbills);
            }
            foreach (DataRow dr in dtsuspbillssubentry.Rows)
            {
                bill_subentry getsubentry = new bill_subentry();
              //  getsubentry.costcentercode = dr["costcentercode"].ToString();
              //  getsubentry.budgetcode = dr["budgetcode"].ToString();
                getsubentry.grnno = dr["grnno"].ToString();
              //  getsubentry.vendorcode = dr["vendorcode"].ToString();
              //  getsubentry.name = dr["name"].ToString();
                getsubentry.billno = dr["billno"].ToString();
                getsubentry.billdate = dr["billdate"].ToString();
              //  getsubentry.Item = dr["item"].ToString();
              //  getsubentry.Description = dr["description"].ToString();
              //  getsubentry.UOM = dr["uom"].ToString();
               // getsubentry.Quantity = dr["quantity"].ToString();
               // getsubentry.Rate = dr["rate"].ToString();
                getsubentry.Amount = dr["amount"].ToString();
                getsubentry.Remarks = dr["remarks"].ToString();
                getsubentry.refno = dr["sno"].ToString();
                suspensesubentrylist.Add(getsubentry);
            }
            getbillentry getInwadDatas = new getbillentry();
            getInwadDatas.suspbill = suspensebillslist;
            getInwadDatas.suspsubentry = suspensesubentrylist;
            getbilldetails.Add(getInwadDatas);
            string response = GetJson(getbilldetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_suspensesub_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
           // cmd = new SqlCommand("SELECT employe_login.name AS empcode, designationmaster.designationcode AS designationcode, suspensecashrequisition.reqno AS suspensereqno,Departmentdetails.DepartmentCode AS deptcode, suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate,suspense_bill_entry.status, suspense_bill_entry.suspensereqno,suspense_bill_entry.empcode,suspense_bill_entry.financialyear, suspense_bill_entry.reqdate, suspense_bill_entry.reqamount, suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses,suspense_bill_entry.doe AS Expr1, suspense_bill_entry.balamount, suspense_bill_entry.createdby AS Expr2, natureofwork.sno AS natureofwork, suspensecashrequisition.reqno, suspense_bill_entry.sno AS sno, suspense_bill_subentry.costcentercode,suspense_bill_subentry.budgetcode,suspense_bill_subentry.grnno,suspense_bill_subentry.vendorcode,suspense_bill_subentry.name,suspense_bill_subentry.billno,suspense_bill_subentry.billdate,suspense_bill_subentry.item,suspense_bill_subentry.description,suspense_bill_subentry.uom,suspense_bill_subentry.quantity,suspense_bill_subentry.rate,suspense_bill_subentry.amount,suspense_bill_subentry.remarks FROM suspense_bill_entry INNER JOIN designationmaster ON suspense_bill_entry.designationcode = designationmaster.sno INNER JOIN employe_login ON suspense_bill_entry.empcode = employe_login.sno INNER JOIN Departmentdetails ON suspense_bill_entry.deptcode = Departmentdetails.sno INNER JOIN suspensecashrequisition ON suspense_bill_entry.suspensereqno = suspensecashrequisition.sno INNER JOIN natureofwork ON natureofwork.sno = suspense_bill_entry.natureofwork INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno where (suspense_bill_entry.status='P')");
            cmd = new SqlCommand("SELECT suspensecashrequisition.reqno AS suspensereqno, suspense_bill_entry.sno,suspense_bill_entry.transactionno, suspense_bill_entry.transactiondate, suspense_bill_entry.status, suspense_bill_entry.suspensereqno AS reqid,suspense_bill_entry.financialyear, suspense_bill_entry.reqdate, suspense_bill_entry.reqamount, suspense_bill_entry.sectioncode, suspense_bill_entry.particulars, suspense_bill_entry.actualexpenses,suspense_bill_entry.balamount, suspensecashrequisition.reqno, suspense_bill_subentry.grnno, suspense_bill_subentry.billno,suspense_bill_subentry.billdate, suspense_bill_subentry.amount, suspense_bill_subentry.remarks, suspense_bill_subentry.refno FROM suspense_bill_entry INNER JOIN suspensecashrequisition ON suspense_bill_entry.suspensereqno = suspensecashrequisition.sno INNER JOIN suspense_bill_subentry ON suspense_bill_entry.sno = suspense_bill_subentry.refno WHERE (suspense_bill_entry.status = 'P')");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);

            DataTable dtsuspbills = view.ToTable(true, "sno", "transactionno", "transactiondate", "financialyear", "reqno","reqid", "reqdate", "reqamount","sectioncode", "particulars", "actualexpenses", "balamount", "status");
            DataTable dtsuspbillssubentry = view.ToTable(true, "refno","grnno","billno", "billdate","amount", "remarks");
            List<getbillentry> getbilldetails = new List<getbillentry>();
            List<susp_bill_entry> suspensebillslist = new List<susp_bill_entry>();
            List<bill_subentry> suspensesubentrylist = new List<bill_subentry>();
            foreach (DataRow dr in dtsuspbills.Rows)
            {
                susp_bill_entry getbills = new susp_bill_entry();
                getbills.transactionno = dr["transactionno"].ToString();
                getbills.transactiondate = ((DateTime)dr["transactiondate"]).ToString("yyyy-MM-dd");
                getbills.financialyear = dr["financialyear"].ToString();
                getbills.suspreqno = dr["reqno"].ToString();
                getbills.reqdate = ((DateTime)dr["reqdate"]).ToString("yyyy-MM-dd");//dr["invoicedate"].ToString();
                getbills.reqamount = dr["reqamount"].ToString();
                getbills.sectioncode = dr["sectioncode"].ToString();
                getbills.particulars = dr["particulars"].ToString();
                getbills.actualexpenses = dr["actualexpenses"].ToString();
                getbills.balamount = dr["balamount"].ToString();
                string status = dr["status"].ToString();
                if (status == "P")
                {
                    getbills.status = "Pending";
                }
                getbills.sno = dr["sno"].ToString();
                suspensebillslist.Add(getbills);
            }
            foreach (DataRow dr in dtsuspbillssubentry.Rows)
            {
                bill_subentry getsubentry = new bill_subentry();
                getsubentry.grnno = dr["grnno"].ToString();
                getsubentry.billno = dr["billno"].ToString();
                getsubentry.billdate = dr["billdate"].ToString();
                getsubentry.Amount = dr["amount"].ToString();
                getsubentry.Remarks = dr["remarks"].ToString();
                getsubentry.refno = dr["refno"].ToString();
                suspensesubentrylist.Add(getsubentry);
            }
            getbillentry getInwadDatas = new getbillentry();
            getInwadDatas.suspbill = suspensebillslist;
            getInwadDatas.suspsubentry = suspensesubentrylist;
            getbilldetails.Add(getInwadDatas);
            string response = GetJson(getbilldetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void update_suspensebill_click(HttpContext context)
    {
        vdm = new VehicleDBMgr();
        string sno = context.Request["sno"];
        string btnvalue = context.Request["btnval"];
        string msg = "";
        if (btnvalue == "Approve")
        {
            cmd = new SqlCommand("UPDATE suspense_bill_entry SET status='A' Where sno=@sno");
            msg = "Approved successfully";
        }
        else
        {
            cmd = new SqlCommand("UPDATE suspense_bill_entry SET status='R' Where sno=@sno");
            msg = "Rejected";
        }
        cmd.Parameters.Add("@sno", sno);
        vdm.Update(cmd);
        string Response = GetJson(msg);
        context.Response.Write(Response);
    }

    public void save_subgroup_ledger(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string groupcode = context.Request["groupid"];
            string Subgroupcode = context.Request["subgroupcode"];
            string Desc = context.Request["description"];
            string btn_save = context.Request["btnVal"];
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into subgroup_ledgerdetails (groupledgerid,subgroupcode,subgroup,doe,createdby) values (@groupledgerid,@subgroupcode,@subgroup,@doe,@createdby)");
                cmd.Parameters.Add("@groupledgerid", groupcode);
                cmd.Parameters.Add("@subgroupcode", Subgroupcode);
                cmd.Parameters.Add("@subgroup", Desc);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update subgroup_ledgerdetails set groupledgerid=@groupledgerid,subgroupcode=@subgroupcode,subgroup=@subgroup,modifiedon=@doe,modifiedby=@modifiedby where sno=@sno");
                cmd.Parameters.Add("@groupledgerid", groupcode);
                cmd.Parameters.Add("@subgroupcode", Subgroupcode);
                cmd.Parameters.Add("@subgroup", Desc);
                cmd.Parameters.Add("@modifiedby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class subgroupledger
    {
        public string groupcode { get; set; }
        public string Subgroupcode { get; set; }
        public string description { get; set; }
        public string sno { get; set; }


        public string groupledgerid { get; set; }
    }

    private void get_subgroup_ledger(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT subgroup_ledgerdetails.sno, subgroup_ledgerdetails.groupledgerid, subgroup_ledgerdetails.subgroupcode, subgroup_ledgerdetails.subgroup, subgroup_ledgerdetails.createdby, subgroup_ledgerdetails.doe, groupledgermaster.groupshortdesc  FROM  groupledgermaster INNER JOIN subgroup_ledgerdetails ON groupledgermaster.sno = subgroup_ledgerdetails.groupledgerid");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<subgroupledger> subgrouplist = new List<subgroupledger>();
            foreach (DataRow dr in routes.Rows)
            {
                subgroupledger getsubgroupdetail = new subgroupledger();
                getsubgroupdetail.groupcode = dr["groupshortdesc"].ToString();
                getsubgroupdetail.groupledgerid = dr["groupledgerid"].ToString();
                getsubgroupdetail.Subgroupcode = dr["subgroupcode"].ToString();
                getsubgroupdetail.description = dr["subgroup"].ToString();
                getsubgroupdetail.sno = dr["sno"].ToString();
                subgrouplist.Add(getsubgroupdetail);
            }
            string response = GetJson(subgrouplist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_passbookclosing_entry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string bankcode = context.Request["bankcode"];
            string bankname = context.Request["bankname"];
            string closingbalncedate = context.Request["closingbalncedate"];
            string closingbalance = context.Request["closingbalance"];
            string debitcradit = context.Request["debitcradit"];
            string btnval = context.Request["btnval"];
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into passbook_closings_entry (bankcode,closingbalancedate,closingbalance,debitcredit,doe,createdby) values (@bankcode,@closingbalancedate,@closingbalance,@debitcredit,@doe,@createdby)");
                //bankcode,closingbalancedate,closingbalance,debitcredit,doe,createdby
                cmd.Parameters.Add("@bankcode", bankcode);
                cmd.Parameters.Add("@closingbalancedate", closingbalncedate);
                cmd.Parameters.Add("@closingbalance", closingbalance);
                cmd.Parameters.Add("@debitcredit", debitcradit);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update passbook_closings_entry set bankcode=@bankcode,closingbalancedate=@closingbalancedate,closingbalance=@closingbalance,debitcredit=@debitcredit,doe=@doe,createdby=@createdby where sno=@sno");
                cmd.Parameters.Add("@bankcode", bankcode);
                cmd.Parameters.Add("@closingbalancedate", closingbalncedate);
                cmd.Parameters.Add("@closingbalance", closingbalance);
                cmd.Parameters.Add("@debitcredit", debitcradit);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details updated  successfully ";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class passbookclosing
    {
        public string bankcode { get; set; }
        public string bankname { get; set; }
        public string closingbalance { get; set; }
        public string closingbalncedate { get; set; }
        public string debitcradit { get; set; }
        public string debitcradit1 { get; set; }
        public string bankid { get; set; }
        public string sno { get; set; }
    }
    private void get_passbookclosing_entry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            // SELECT  passbook_closings_entry.sno, passbook_closings_entry.bankcode, passbook_closings_entry.closingbalancedate, passbook_closings_entry.closingbalance, passbook_closings_entry.debitcredit, passbook_closings_entry.doe, passbook_closings_entry.createdby, bankmaster.bankname, bankmaster.code FROM passbook_closings_entry INNER JOIN bankmaster ON passbook_closings_entry.bankcode = bankmaster.sno
            cmd = new SqlCommand("SELECT  passbook_closings_entry.sno, passbook_closings_entry.bankcode, passbook_closings_entry.closingbalancedate, passbook_closings_entry.closingbalance, passbook_closings_entry.debitcredit, passbook_closings_entry.doe, passbook_closings_entry.createdby, bankmaster.bankname, bankmaster.code FROM passbook_closings_entry INNER JOIN bankmaster ON passbook_closings_entry.bankcode = bankmaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<passbookclosing> voucherlist = new List<passbookclosing>();
            foreach (DataRow dr in routes.Rows)
            {
                passbookclosing getvoucherdetail = new passbookclosing();
                getvoucherdetail.bankcode = dr["bankcode"].ToString();
                getvoucherdetail.closingbalncedate = ((DateTime)dr["closingbalancedate"]).ToString("yyyy-MM-dd");    // dr["closingbalancedate"].ToString();
                getvoucherdetail.closingbalance = dr["closingbalance"].ToString();
                getvoucherdetail.debitcradit1 = dr["debitcredit"].ToString();
                string debitcradit = dr["debitcredit"].ToString();
                if (debitcradit == "D")
                {
                    debitcradit = "Debit";
                }
                if (debitcradit == "C")
                {
                    debitcradit = "Credit";
                }
                getvoucherdetail.debitcradit = debitcradit;
                getvoucherdetail.bankname = dr["bankname"].ToString();
                getvoucherdetail.bankid = dr["code"].ToString();
                getvoucherdetail.sno = dr["sno"].ToString();
                voucherlist.Add(getvoucherdetail);
            }
            string response = GetJson(voucherlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class openingbalance
    {
        public string branchcode { get; set; }
        public string branchname { get; set; }
        public string branchid { get; set; }
        public string financeyear { get; set; }
        public string year { get; set; }
        public string btnval { get; set; }
        public string sno { get; set; }
        public string doe { get; set; }
        public string drammount { get; set; }
        public string crammount { get; set; }
        public List<openingbalancesub> openingbalance_array { get; set; }
    }
    public class getopeningbalance
    {
        public List<openingbalance> openingbalance { get; set; }
        public List<openingbalancesub> openingbalancesub { get; set; }
    }
    public class openingbalancesub
    {
        public string accountcode { get; set; }
        public string description { get; set; }
        public string partycode { get; set; }
        public string partyname { get; set; }
        public string drammount { get; set; }
        public string crammount { get; set; }
        public string accountid { get; set; }
        public string partyid { get; set; }
        public string doe { get; set; }
        public string sno { get; set; }
        public string hdnproductsno { get; set; }
    }
    private void save_openingbalance_entry(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            openingbalance obj = js.Deserialize<openingbalance>(title1);
            string branchcode = obj.branchcode.TrimEnd();
            string financeyear = obj.financeyear.TrimEnd();
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            string modifiedby = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                foreach (openingbalancesub es in obj.openingbalance_array)
                {
                    cmd = new SqlCommand("insert into opening_balances_entry (branchcode,financialyear,accountcode,partycode,dramount,cramount,doe,createdby) values (@branchcode,@financialyear,@accountcode,@partycode,@dramount,@cramount,@doe,@createdby)");
                    //branchcode,financialyear,accountcode,partycode,dramount,cramount,doe,createdby
                    cmd.Parameters.Add("@branchcode", branchcode);
                    cmd.Parameters.Add("@financialyear", financeyear);
                    cmd.Parameters.Add("@accountcode", es.accountcode);
                    cmd.Parameters.Add("@partycode", es.partycode);
                    cmd.Parameters.Add("@dramount", es.drammount);
                    cmd.Parameters.Add("@cramount", es.crammount);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    vdm.insert(cmd);
                }
                string response = GetJson("Insert Successfully");
                context.Response.Write(response);
            }
            else
            {
                foreach (openingbalancesub es in obj.openingbalance_array)
                {
                    string sno = es.hdnproductsno;
                    //branchcode,financialyear,accountcode,partycode,dramount,cramount,doe,createdby
                    cmd = new SqlCommand("Update opening_balances_entry set branchcode=@branchcode,financialyear=@financialyear,accountcode=@accountcode,partycode=@partycode,dramount=@dramount,cramount=@cramount,doe=@doe,createdby=@createdby where sno=@sno");
                    cmd.Parameters.Add("@branchcode", branchcode);
                    cmd.Parameters.Add("@financialyear", financeyear);
                    cmd.Parameters.Add("@accountcode", es.accountcode);
                    cmd.Parameters.Add("@partycode", es.partycode);
                    cmd.Parameters.Add("@dramount", es.drammount);
                    cmd.Parameters.Add("@cramount", es.crammount);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", sno);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into opening_balances_entry (branchcode,financialyear,accountcode,partycode,dramount,cramount,doe,createdby) values (@branchcode,@financialyear,@accountcode,@partycode,@dramount,@cramount,@doe,@createdby)");
                        //branchcode,financialyear,accountcode,partycode,dramount,cramount,doe,createdby
                        cmd.Parameters.Add("@branchcode", branchcode);
                        cmd.Parameters.Add("@financialyear", financeyear);
                        cmd.Parameters.Add("@accountcode", es.accountcode);
                        cmd.Parameters.Add("@partycode", es.partycode);
                        cmd.Parameters.Add("@dramount", es.drammount);
                        cmd.Parameters.Add("@cramount", es.crammount);
                        cmd.Parameters.Add("@createdby", createdby);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        vdm.insert(cmd);
                    }
                }
                string response = GetJson("update Successfully");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }

    private void get_openingbalance_entry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            //string createdby = context.Session["UserSno"].ToString();
            cmd = new SqlCommand("SELECT opening_balances_entry.sno, opening_balances_entry.branchcode, opening_balances_entry.financialyear, opening_balances_entry.accountcode, opening_balances_entry.partycode, opening_balances_entry.dramount, opening_balances_entry.cramount, opening_balances_entry.doe, opening_balances_entry.createdby, branchmaster.branchname, branchmaster.code, bankaccountno_master.accountno, bankaccountno_master.accounttype, financialyeardetails.year, fam_party_type.party_tp, fam_party_type.short_desc FROM  opening_balances_entry LEFT OUTER JOIN branchmaster ON opening_balances_entry.branchcode = branchmaster.branchid LEFT OUTER JOIN bankaccountno_master ON opening_balances_entry.accountcode = bankaccountno_master.sno LEFT OUTER JOIN financialyeardetails ON opening_balances_entry.financialyear = financialyeardetails.sno LEFT OUTER JOIN fam_party_type ON opening_balances_entry.partycode = fam_party_type.sno");
            //SELECT opening_balances_entry.sno, opening_balances_entry.branchcode, opening_balances_entry.financialyear, opening_balances_entry.accountcode, opening_balances_entry.partycode, opening_balances_entry.dramount, opening_balances_entry.cramount, opening_balances_entry.doe, opening_balances_entry.createdby, branchmaster.branchname, branchmaster.code, bankaccountno_master.accountno, bankaccountno_master.accounttype, financialyeardetails.year, fam_party_type.party_tp, fam_party_type.short_desc FROM  opening_balances_entry LEFT OUTER JOIN branchmaster ON opening_balances_entry.branchcode = branchmaster.branchid LEFT OUTER JOIN bankaccountno_master ON opening_balances_entry.accountcode = bankaccountno_master.sno LEFT OUTER JOIN financialyeardetails ON opening_balances_entry.financialyear = financialyeardetails.sno LEFT OUTER JOIN fam_party_type ON opening_balances_entry.partycode = fam_party_type.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttds = view.ToTable(true, "sno", "branchcode", "financialyear", "branchname", "code", "year", "doe", "dramount", "cramount");
            DataTable dttdssub = view.ToTable(true, "sno", "accountcode", "partycode", "dramount", "cramount", "accountno", "accounttype", "party_tp", "short_desc");
            List<getopeningbalance> getopeningbalance = new List<getopeningbalance>();
            List<openingbalance> openingbalance = new List<openingbalance>();
            List<openingbalancesub> openingbalancesub = new List<openingbalancesub>();
            foreach (DataRow dr in dttds.Rows)
            {
                openingbalance gettds = new openingbalance();
                gettds.branchcode = dr["branchcode"].ToString();
                gettds.financeyear = dr["financialyear"].ToString();
                gettds.branchname = dr["branchname"].ToString();
                gettds.branchid = dr["code"].ToString();
                gettds.year = dr["year"].ToString();
                gettds.sno = dr["sno"].ToString();
                gettds.doe = dr["doe"].ToString();
                gettds.drammount = dr["dramount"].ToString();
                gettds.crammount = dr["cramount"].ToString();
                openingbalance.Add(gettds);
            }
            foreach (DataRow dr in dttdssub.Rows)
            {
                openingbalancesub gettdssub = new openingbalancesub();
                gettdssub.accountcode = dr["accountcode"].ToString();
                gettdssub.partycode = dr["partycode"].ToString();
                gettdssub.accountid = dr["accountno"].ToString();
                gettdssub.description = dr["accounttype"].ToString();
                gettdssub.partyid = dr["party_tp"].ToString();
                gettdssub.partyname = dr["short_desc"].ToString();
                gettdssub.drammount = dr["dramount"].ToString();
                gettdssub.crammount = dr["cramount"].ToString();
                gettdssub.sno = dr["sno"].ToString();
                openingbalancesub.Add(gettdssub);
            }
            getopeningbalance getemployeeDatas = new getopeningbalance();
            getemployeeDatas.openingbalance = openingbalance;
            getemployeeDatas.openingbalancesub = openingbalancesub;
            getopeningbalance.Add(getemployeeDatas);
            string response = GetJson(getopeningbalance);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class profitandlossbalance
    {
        public string branchcode { get; set; }
        public string branchname { get; set; }
        public string branchid { get; set; }
        public string financeyear { get; set; }
        public string year { get; set; }
        public string btnval { get; set; }
        public string sno { get; set; }
        public string doe { get; set; }
        public string date { get; set; }
        public string currentyearamount { get; set; }
        public string previousyearamount { get; set; }
        public List<profitandlossbalancesub> profitandlossbalance_array { get; set; }
    }
    public class getprofitandlossbalance
    {
        public List<profitandlossbalance> profitandlossbalance { get; set; }
        public List<profitandlossbalancesub> profitandlossbalancesub { get; set; }
    }
    public class profitandlossbalancesub
    {
        public string schedule { get; set; }
        public string accountcode { get; set; }
        public string description { get; set; }
        public string addless { get; set; }
        public string currentyearamount { get; set; }
        public string previousyearamount { get; set; }
        public string accountid { get; set; }
        public string shaduleid { get; set; }
        public string doe { get; set; }
        public string sno { get; set; }
        public string hdnproductsno { get; set; }
    }
    private void save_profitandlossbalance_sheet(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            profitandlossbalance obj = js.Deserialize<profitandlossbalance>(title1);
            string branchcode = obj.branchcode.TrimEnd();
            string financeyear = obj.financeyear.TrimEnd();
            string date = obj.date.TrimEnd();
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            string modifiedby = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                foreach (profitandlossbalancesub es in obj.profitandlossbalance_array)
                {
                    cmd = new SqlCommand("insert into PLadjustment (branchid,financialyear,entrydate,schedule,accountcode,add_less,currentyearamount,prev_yearamount,entryby) values (@branchid,@financialyear,@entrydate,@schedule,@accountcode,@add_less,@currentyearamount,@prev_yearamount,@entryby)");
                    //branchid,financialyear,entrydate,schedule,accountcode,add_less,currentyearamount,prev_yearamount,entryby,
                    cmd.Parameters.Add("@branchid", branchcode);
                    cmd.Parameters.Add("@financialyear", financeyear);
                    cmd.Parameters.Add("@entrydate", date);
                    cmd.Parameters.Add("@schedule", es.schedule);
                    cmd.Parameters.Add("@accountcode", es.accountcode);
                    cmd.Parameters.Add("@add_less", es.addless);
                    cmd.Parameters.Add("@currentyearamount", es.currentyearamount);
                    cmd.Parameters.Add("@prev_yearamount", es.previousyearamount);
                    cmd.Parameters.Add("@entryby", createdby);
                    vdm.insert(cmd);
                }
                string response = GetJson("Insert Successfully");
                context.Response.Write(response);
            }
            else
            {
                foreach (profitandlossbalancesub es in obj.profitandlossbalance_array)
                {
                    string sno = es.hdnproductsno;
                    //branchcode,financialyear,accountcode,partycode,dramount,cramount,doe,modifyby
                    cmd = new SqlCommand("Update PLadjustment set branchid=@branchid,financialyear=@financialyear,entrydate=@entrydate,schedule=@schedule,accountcode=@accountcode,add_less=@add_less,currentyearamount=@currentyearamount,prev_yearamount=@prev_yearamount,modifyby=@modifyby where sno=@sno");
                    cmd.Parameters.Add("@branchid", branchcode);
                    cmd.Parameters.Add("@financialyear", financeyear);
                    cmd.Parameters.Add("@entrydate", date);
                    cmd.Parameters.Add("@schedule", es.schedule);
                    cmd.Parameters.Add("@accountcode", es.accountcode);
                    cmd.Parameters.Add("@add_less", es.addless);
                    cmd.Parameters.Add("@currentyearamount", es.currentyearamount);
                    cmd.Parameters.Add("@prev_yearamount", es.previousyearamount);
                    cmd.Parameters.Add("@modifyby", modifiedby);
                    cmd.Parameters.Add("@sno", sno);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into PLadjustment (branchid,financialyear,entrydate,schedule,accountcode,add_less,currentyearamount,prev_yearamount,entryby) values (@branchid,@financialyear,@entrydate,@schedule,@accountcode,@add_less,@currentyearamount,@prev_yearamount,@entryby)");
                        //branchid,financialyear,entrydate,schedule,accountcode,add_less,currentyearamount,prev_yearamount,entryby,
                        cmd.Parameters.Add("@branchid", branchcode);
                        cmd.Parameters.Add("@financialyear", financeyear);
                        cmd.Parameters.Add("@entrydate", date);
                        cmd.Parameters.Add("@schedule", es.schedule);
                        cmd.Parameters.Add("@accountcode", es.accountcode);
                        cmd.Parameters.Add("@add_less", es.addless);
                        cmd.Parameters.Add("@currentyearamount", es.currentyearamount);
                        cmd.Parameters.Add("@prev_yearamount", es.previousyearamount);
                        cmd.Parameters.Add("@entryby", createdby);
                        vdm.insert(cmd);
                    }
                }
                string response = GetJson("update Successfully");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }
    private void get_profitandlossbalance_sheet(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            //string createdby = context.Session["UserSno"].ToString();
            cmd = new SqlCommand("SELECT  PLadjustment.sno, PLadjustment.financialyear, PLadjustment.entrydate, PLadjustment.schedule, PLadjustment.accountcode, PLadjustment.add_less, PLadjustment.currentyearamount, PLadjustment.prev_yearamount, PLadjustment.entryby, PLadjustment.branchid, PLadjustment.modifyby, financialyeardetails.year, groupledgermaster.schedule AS scheduleid, bankaccountno_master.accountno, bankaccountno_master.accounttype, branchmaster.branchname, branchmaster.code FROM PLadjustment LEFT OUTER JOIN financialyeardetails ON PLadjustment.financialyear = financialyeardetails.sno LEFT OUTER JOIN groupledgermaster ON PLadjustment.schedule = groupledgermaster.sno LEFT OUTER JOIN bankaccountno_master ON PLadjustment.accountcode = bankaccountno_master.sno LEFT OUTER JOIN branchmaster ON PLadjustment.branchid = branchmaster.branchid");
            //SELECT  PLadjustment.sno, PLadjustment.financialyear, PLadjustment.entrydate, PLadjustment.schedule, PLadjustment.accountcode, PLadjustment.add_less, PLadjustment.currentyearamount, PLadjustment.prev_yearamount, PLadjustment.entryby, PLadjustment.branchid, PLadjustment.modifyby, financialyeardetails.year, groupledgermaster.schedule AS scheduleid, bankaccountno_master.accountno, bankaccountno_master.accounttype, branchmaster.branchname, branchmaster.code FROM PLadjustment LEFT OUTER JOIN financialyeardetails ON PLadjustment.financialyear = financialyeardetails.sno LEFT OUTER JOIN groupledgermaster ON PLadjustment.schedule = groupledgermaster.sno LEFT OUTER JOIN bankaccountno_master ON PLadjustment.accountcode = bankaccountno_master.sno LEFT OUTER JOIN branchmaster ON PLadjustment.branchid = branchmaster.branchid
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttds = view.ToTable(true, "sno", "branchid", "branchname", "code", "financialyear", "year", "entrydate", "currentyearamount", "prev_yearamount");
            DataTable dttdssub = view.ToTable(true, "sno", "schedule", "scheduleid", "accountcode", "accountno", "accounttype", "add_less", "currentyearamount", "prev_yearamount");
            List<getprofitandlossbalance> getprofitandlossbalance = new List<getprofitandlossbalance>();
            List<profitandlossbalance> profitandlossbalance = new List<profitandlossbalance>();
            List<profitandlossbalancesub> profitandlossbalancesub = new List<profitandlossbalancesub>();
            foreach (DataRow dr in dttds.Rows)
            {
                profitandlossbalance gettds = new profitandlossbalance();
                gettds.branchid = dr["branchid"].ToString();
                gettds.branchcode = dr["code"].ToString();
                gettds.branchname = dr["branchname"].ToString();
                gettds.financeyear = dr["financialyear"].ToString();
                gettds.year = dr["year"].ToString();
                gettds.date = ((DateTime)dr["entrydate"]).ToString("yyyy-MM-dd");  //dr["entrydate"].ToString();
                gettds.currentyearamount = dr["currentyearamount"].ToString();
                gettds.previousyearamount = dr["prev_yearamount"].ToString();
                gettds.sno = dr["sno"].ToString();
                profitandlossbalance.Add(gettds);
            }
            foreach (DataRow dr in dttdssub.Rows)
            {
                profitandlossbalancesub gettdssub = new profitandlossbalancesub();
                gettdssub.sno = dr["sno"].ToString();
                gettdssub.schedule = dr["schedule"].ToString();
                gettdssub.shaduleid = dr["scheduleid"].ToString();
                gettdssub.accountcode = dr["accountcode"].ToString();
                gettdssub.accountid = dr["accountno"].ToString();
                gettdssub.description = dr["accounttype"].ToString();
                gettdssub.addless = dr["add_less"].ToString();
                gettdssub.currentyearamount = dr["currentyearamount"].ToString();
                gettdssub.previousyearamount = dr["prev_yearamount"].ToString();
                gettdssub.sno = dr["sno"].ToString();
                profitandlossbalancesub.Add(gettdssub);
            }
            getprofitandlossbalance getemployeeDatas = new getprofitandlossbalance();
            getemployeeDatas.profitandlossbalance = profitandlossbalance;
            getemployeeDatas.profitandlossbalancesub = profitandlossbalancesub;
            getprofitandlossbalance.Add(getemployeeDatas);
            string response = GetJson(getprofitandlossbalance);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public void save_bankpassbookunmatched_entry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string bankcode = context.Request["bankcode"];
            string bankname = context.Request["bankname"];
            string entrydate = context.Request["entrydate"];
            string chequedd = context.Request["chequedd"];
            string chequeddno = context.Request["chequeddno"];
            string amount = context.Request["amount"];
            string debitcradit = context.Request["debitcradit"];
            string conform = context.Request["conform"];
            string remarks = context.Request["remarks"];
            string btnval = context.Request["btnval"];
            if (btnval == "Save")
            {
                if (chequedd == "C")
                {
                    cmd = new SqlCommand("insert into brspassbook_unmatched_details (bankid,entrydate,checkordd,checkno,amount,amounttranstype,status,remarks,createdby,doe) values (@bankid,@entrydate,@checkordd,@checkno,@amount,@amounttranstype,@status,@remarks,@createdby,@doe)");
                    //bankid,entrydate,checkordd,checkno,amount,amounttranstype,status,remarks,createdby,doe
                    cmd.Parameters.Add("@bankid", bankcode);
                    cmd.Parameters.Add("@entrydate", entrydate);
                    cmd.Parameters.Add("@checkordd", chequedd);
                    cmd.Parameters.Add("@checkno", chequeddno);
                    cmd.Parameters.Add("@amount", amount);
                    cmd.Parameters.Add("@amounttranstype", debitcradit);
                    cmd.Parameters.Add("@status", conform);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    vdm.insert(cmd);
                    string msg = "Details successfully saved";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
                else
                {
                    cmd = new SqlCommand("insert into brspassbook_unmatched_details (bankid,entrydate,checkordd,ddno,amount,amounttranstype,status,remarks,createdby,doe) values (@bankid,@entrydate,@checkordd,@ddno,@amount,@amounttranstype,@status,@remarks,@createdby,@doe)");
                    //bankid,entrydate,checkordd,ddno,amount,amounttranstype,status,remarks,createdby,doe
                    cmd.Parameters.Add("@bankid", bankcode);
                    cmd.Parameters.Add("@entrydate", entrydate);
                    cmd.Parameters.Add("@checkordd", chequedd);
                    cmd.Parameters.Add("@ddno", chequeddno);
                    cmd.Parameters.Add("@amount", amount);
                    cmd.Parameters.Add("@amounttranstype", debitcradit);
                    cmd.Parameters.Add("@status", conform);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    vdm.insert(cmd);
                    string msg = "Details successfully saved";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
            }
            else
            {
                if (chequedd == "C")
                {
                    string sno = context.Request["sno"];
                    cmd = new SqlCommand("Update brspassbook_unmatched_details set bankid=@bankid,entrydate=@entrydate,checkordd=@checkordd,checkno=@checkno,amount=@amount,amounttranstype=@amounttranstype,status=@status,remarks=@remarks,modifiedby=@modifiedby,modifiedon=@modifiedon where sno=@sno");
                    cmd.Parameters.Add("@bankid", bankcode);
                    cmd.Parameters.Add("@entrydate", entrydate);
                    cmd.Parameters.Add("@checkordd", chequedd);
                    cmd.Parameters.Add("@checkno", chequeddno);
                    cmd.Parameters.Add("@amount", amount);
                    cmd.Parameters.Add("@amounttranstype", debitcradit);
                    cmd.Parameters.Add("@status", conform);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@modifiedby", UserName);
                    cmd.Parameters.Add("@modifiedon", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", sno);
                    vdm.Update(cmd);
                    string msg = "Details updated  successfully ";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
                else 
                {
                    string sno = context.Request["sno"];
                    cmd = new SqlCommand("Update brspassbook_unmatched_details set bankid=@bankid,entrydate=@entrydate,checkordd=@checkordd,ddno=@ddno,amount=@amount,amounttranstype=@amounttranstype,status=@status,remarks=@remarks,modifiedby=@modifiedby,modifiedon=@modifiedon where sno=@sno");
                    cmd.Parameters.Add("@bankid", bankcode);
                    cmd.Parameters.Add("@entrydate", entrydate);
                    cmd.Parameters.Add("@checkordd", chequedd);
                    cmd.Parameters.Add("@ddno", chequeddno);
                    cmd.Parameters.Add("@amount", amount);
                    cmd.Parameters.Add("@amounttranstype", debitcradit);
                    cmd.Parameters.Add("@status", conform);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@modifiedby", UserName);
                    cmd.Parameters.Add("@modifiedon", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", sno);
                    vdm.Update(cmd);
                    string msg = "Details updated  successfully ";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                    
                }
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class bankpassbookunmatched
    {
        public string bankcode { get; set; }
        public string bankname { get; set; }
        public string bankid { get; set; }
        public string entrydate { get; set; }
        public string chequedd { get; set; }
        public string chequedd1 { get; set; }
        public string chequeddno { get; set; }
        public string chequeddno1 { get; set; }
        public string amount { get; set; }
        public string debitcradit { get; set; }
        public string debitcradit1 { get; set; } 
        public string conform { get; set; }
        public string conform1 { get; set; }
        public string remarks { get; set; }
        public string sno { get; set; }
    }
    private void get_bankpassbookunmatched_entry(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            //SELECT  brspassbook_unmatched_details.sno, brspassbook_unmatched_details.bankid, brspassbook_unmatched_details.entrydate, brspassbook_unmatched_details.checkordd, brspassbook_unmatched_details.ddno, brspassbook_unmatched_details.checkno, brspassbook_unmatched_details.amount, brspassbook_unmatched_details.amounttranstype, brspassbook_unmatched_details.status, brspassbook_unmatched_details.remarks, brspassbook_unmatched_details.createdby, brspassbook_unmatched_details.doe, brspassbook_unmatched_details.modifiedby, brspassbook_unmatched_details.modifiedon, bankmaster.bankname, bankmaster.code FROM  brspassbook_unmatched_details LEFT OUTER JOIN bankmaster ON brspassbook_unmatched_details.bankid = bankmaster.sno
            cmd = new SqlCommand("SELECT  brspassbook_unmatched_details.sno, brspassbook_unmatched_details.bankid, brspassbook_unmatched_details.entrydate, brspassbook_unmatched_details.checkordd, brspassbook_unmatched_details.ddno, brspassbook_unmatched_details.checkno, brspassbook_unmatched_details.amount, brspassbook_unmatched_details.amounttranstype, brspassbook_unmatched_details.status, brspassbook_unmatched_details.remarks, brspassbook_unmatched_details.createdby, brspassbook_unmatched_details.doe, brspassbook_unmatched_details.modifiedby, brspassbook_unmatched_details.modifiedon, bankmaster.bankname, bankmaster.code FROM  brspassbook_unmatched_details LEFT OUTER JOIN bankmaster ON brspassbook_unmatched_details.bankid = bankmaster.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<bankpassbookunmatched> voucherlist = new List<bankpassbookunmatched>();
            foreach (DataRow dr in routes.Rows)
            {
                bankpassbookunmatched getvoucherdetail = new bankpassbookunmatched();
                getvoucherdetail.bankid = dr["bankid"].ToString();
                getvoucherdetail.bankcode = dr["code"].ToString();
                getvoucherdetail.bankname = dr["bankname"].ToString();
                getvoucherdetail.entrydate = ((DateTime)dr["entrydate"]).ToString("yyyy-MM-dd");    // dr["closingbalancedate"].ToString();
                getvoucherdetail.chequedd = dr["checkordd"].ToString();

                string chequedd = dr["checkordd"].ToString();
                if (chequedd == "C")
                {
                    chequedd = "Cheque";
                }
                if (chequedd == "D")
                {
                    chequedd = "DD";
                }
                getvoucherdetail.chequedd = chequedd;

                getvoucherdetail.chequedd1 = dr["checkordd"].ToString();
                getvoucherdetail.chequeddno = dr["ddno"].ToString();
                getvoucherdetail.chequeddno1 = dr["checkno"].ToString();
                getvoucherdetail.amount = dr["amount"].ToString();

                string debitcradit = dr["amounttranstype"].ToString();
                if (debitcradit == "D")
                {
                    debitcradit = "Debit";
                }
                if (debitcradit == "C")
                {
                    debitcradit = "Credit";
                }
                getvoucherdetail.debitcradit = debitcradit;

                getvoucherdetail.debitcradit1 = dr["amounttranstype"].ToString();

                string conform = dr["status"].ToString();
                if (conform == "P")
                {
                    conform = "Pending";
                }
                if (conform == "C")
                {
                    conform = "Clear";
                }
                getvoucherdetail.conform = conform;

                getvoucherdetail.conform1 = dr["status"].ToString();
                getvoucherdetail.remarks = dr["remarks"].ToString();
                getvoucherdetail.sno = dr["sno"].ToString();
                voucherlist.Add(getvoucherdetail);
            }
            string response = GetJson(voucherlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_voucher_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string sno = context.Request["refno"].ToString();
            cmd = new SqlCommand("SELECT sno,accountcode,description,costcentercode,budgetcode,name,amount,doe,createdby FROM credit_voucher_details WHERE refno=@refno");
            cmd.Parameters.Add("@refno", sno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_voucher> paymentdetailslist = new List<fan_voucher>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_voucher getpaymentdetails = new fan_voucher();
                getpaymentdetails.desc = dr["description"].ToString();
                getpaymentdetails.cost_code = dr["costcentercode"].ToString();
                getpaymentdetails.budget_code = dr["budgetcode"].ToString();
                getpaymentdetails.acc_code = dr["accountcode"].ToString();
                getpaymentdetails.name = dr["name"].ToString();
                getpaymentdetails.amount = dr["amount"].ToString();
                //getpaymentdetails.refno = dr["refno"].ToString();
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_invoice_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string sno = context.Request["refno"].ToString();
            cmd = new SqlCommand("SELECT sno,particulars,invoiceno,invoicedate,doe,createdby FROM credit_invoice_details WHERE refno=@refno");
            cmd.Parameters.Add("@refno", sno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_invoice> paymentdetailslist = new List<fan_invoice>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_invoice getpaymentdetails = new fan_invoice();
                getpaymentdetails.particulars = dr["particulars"].ToString();
                getpaymentdetails.invoice_no = dr["invoiceno"].ToString();
                getpaymentdetails.invoice_date = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");    ///dr["invoicedate"].ToString();
                //getpaymentdetails.refno = dr["refno"].ToString();
                getpaymentdetails.sno1 = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class fan_debit_det
    {
        //public string Trans_no { get; set; }
        public string Trans_Date { get; set; }
        public string financial_yr { get; set; }
        public string financial_yr1 { get; set; }
        public string branch_code { get; set; }
        public string branch_code1 { get; set; }
        public string voucher_type { get; set; }
        public string voucher_type1 { get; set; }
        public string voucher_sub_type { get; set; }
        public string voucher_sub_type1 { get; set; }
        public string code_acc { get; set; }
        public string code_acc1 { get; set; }
        //public string note_type { get; set; }
        public string party_type { get; set; }
        public string party_type1 { get; set; }
        public string party_code { get; set; }
        public string party_code1 { get; set; }
        public string remarks { get; set; }
        public string sno { get; set; }
        public string btn_save { get; set; }
        public List<fan_debit_voucher> DataTable { get; set; }
    }
    public class fan_debit_voucher
    {

        public string acc_code { get; set; }
        public string desc { get; set; }
        public string cost_code { get; set; }
        public string budget_code { get; set; }
        public string name { get; set; }
        public string amount { get; set; }
        public string sno { get; set; }
        public string refno { get; set; }

    }
    private void save_debit_voucher_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            fan_debit_det obj = js.Deserialize<fan_debit_det>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            //string Trans_no = obj.Trans_no;
            string Trans_Date = obj.Trans_Date; //((DateTime)obj.Trans_Date).ToString("yyyy-MM-dd");
            string financial_yr = obj.financial_yr;
            string branch_code = obj.branch_code;
            string voucher_type = obj.voucher_type;
            string voucher_sub_type = obj.voucher_sub_type;
            string code_acc = obj.code_acc;
            //string note_type = obj.note_type;
            string party_type = obj.party_type;
            string party_code = obj.party_code;
            string remarks = obj.remarks;
            string sno = obj.sno;
            //DateTime effFrom = Convert.ToDateTime(obj.effFrom);
            //DateTime effTo = Convert.ToDateTime(obj.effTo);
            string btn_save = obj.btn_save;

            if (btn_save == "Save")
            {

                cmd = new SqlCommand("insert into debit_note_entry (date,financialyear,branchcode,vouchertype,vouchersubtype,accountcode,partytype,partycode,remarks,doe,createdby) values (@Trans_Date,@financial_yr,@branch_code,@voucher_type,@voucher_sub_type,@code_acc,@party_type,@party_code,@remarks,@doe,@createdby)");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from debit_note_entry ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string refno = routes.Rows[0]["sno"].ToString();//tax_gl_code
                foreach (fan_debit_voucher si in obj.DataTable)
                {
                    string acc_code = si.acc_code;
                    string desc = si.desc;
                    string cost_code = si.cost_code;
                    string budget_code = si.budget_code;
                    string name = si.name;
                    string amt = si.amount;
                    //string Sno = si.sno;
                    cmd = new SqlCommand("insert into debit_voucher_details (accountcode,description,costcentercode,budgetcode,name,amount,doe,createdby,refno) values (@acc_code, @desc, @cost_code, @budget_code, @name, @amt, @doe, @createdby, @refno)");
                    cmd.Parameters.Add("@acc_code", acc_code);
                    cmd.Parameters.Add("@desc", desc);
                    cmd.Parameters.Add("@cost_code", cost_code);
                    cmd.Parameters.Add("@budget_code", budget_code);
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@amt", amt);
                    cmd.Parameters.Add("@refno", refno);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {


                //taxtype,rangefrom,rangeto,percentage,fromdate,todate,status,createdby,createdon,doe
                cmd = new SqlCommand("UPDATE debit_note_entry SET date=@Trans_Date,financialyear=@financial_yr,branchcode=@branch_code,vouchertype=@voucher_type,vouchersubtype=@voucher_sub_type,accountcode=@code_acc, partytype=@party_type,partycode=@party_code,remarks=@remarks WHERE sno=@sno");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                //cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);

                foreach (fan_debit_voucher si in obj.DataTable)
                {
                    string acc_code = si.acc_code;
                    string desc = si.desc;
                    string cost_code = si.cost_code;
                    string budget_code = si.budget_code;
                    string name = si.name;
                    string amt = si.amount;
                    string Sno = si.sno;
                    cmd = new SqlCommand("update debit_voucher_details set accountcode=@acc_code, description=@desc, costcentercode=@cost_code, budgetcode=@budget_code, name=@name, amount=@amt where sno=@sno");
                    cmd.Parameters.Add("@acc_code", acc_code);
                    cmd.Parameters.Add("@desc", desc);
                    cmd.Parameters.Add("@cost_code", cost_code);
                    cmd.Parameters.Add("@budget_code", budget_code);
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@amt", amt);
                    cmd.Parameters.Add("@sno", Sno);
                    //cmd.Parameters.Add("@refno", refno);
                    //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    //cmd.Parameters.Add("@createdby", UserName);
                    vdm.Update(cmd);
                }
                string msg = "successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_debitnote_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            //cmd = new SqlCommand("SELECT sno,date,financialyear,branchcode,vouchertype,vouchersubtype,accountcode,partytype,partycode,remarks,doe,createdby FROM debit_note_entry");
            cmd = new SqlCommand("SELECT e.sno,e.date,e.financialyear,f.year,b.code,e.branchcode,e.vouchertype,v.transactiontype,e.vouchersubtype,ts.subtype,e.accountcode AS account_code,vs.accountno,e.partytype,p.party_tp,e.partycode AS party_code,pc.partycode,e.remarks FROM debit_note_entry e join debit_voucher_details i on e.sno=i.refno inner join branchmaster b on b.branchid=e.branchcode inner join financialyeardetails f on f.sno=e.financialyear inner join transactiontype v on v.sno=e.vouchertype inner join fam_party_type p on p.sno=e.partytype inner join partymaster pc on pc.sno=e.partycode inner join bankaccountno_master vs on vs.sno=e.accountcode inner join transactionsubtypes ts on ts.sno=e.vouchersubtype");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_debit_det> paymentdetailslist = new List<fan_debit_det>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_debit_det getpaymentdetails = new fan_debit_det();
                getpaymentdetails.financial_yr = dr["year"].ToString();
                getpaymentdetails.financial_yr1 = dr["financialyear"].ToString();
                getpaymentdetails.branch_code = dr["code"].ToString();
                getpaymentdetails.branch_code1 = dr["branchcode"].ToString();
                getpaymentdetails.voucher_type = dr["transactiontype"].ToString();
                getpaymentdetails.voucher_type1 = dr["vouchertype"].ToString();
                getpaymentdetails.voucher_sub_type = dr["subtype"].ToString();
                getpaymentdetails.voucher_sub_type1 = dr["vouchersubtype"].ToString();
                getpaymentdetails.code_acc = dr["accountno"].ToString();
                getpaymentdetails.code_acc1 = dr["account_code"].ToString();
                getpaymentdetails.Trans_Date = ((DateTime)dr["date"]).ToString("yyyy-MM-dd");
                getpaymentdetails.remarks = dr["remarks"].ToString();
                getpaymentdetails.party_type = dr["party_tp"].ToString();
                getpaymentdetails.party_type1 = dr["partytype"].ToString();
                getpaymentdetails.party_code = dr["partycode"].ToString();
                getpaymentdetails.party_code1 = dr["party_code"].ToString();
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_debit_voucher_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string sno = context.Request["refno"].ToString();
            cmd = new SqlCommand("SELECT sno,accountcode,description,costcentercode,budgetcode,name,amount,doe,createdby FROM debit_voucher_details WHERE refno=@refno");
            cmd.Parameters.Add("@refno", sno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_debit_voucher> paymentdetailslist = new List<fan_debit_voucher>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_debit_voucher getpaymentdetails = new fan_debit_voucher();
                getpaymentdetails.desc = dr["description"].ToString();
                getpaymentdetails.cost_code = dr["costcentercode"].ToString();
                getpaymentdetails.budget_code = dr["budgetcode"].ToString();
                getpaymentdetails.acc_code = dr["accountcode"].ToString();
                getpaymentdetails.name = dr["name"].ToString();
                getpaymentdetails.amount = dr["amount"].ToString();
                //getpaymentdetails.refno = dr["refno"].ToString();
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class fan_debit_det1
    {
        //public string Trans_no { get; set; }
        public string Trans_Date1 { get; set; }
        public string financial_yr1 { get; set; }
        public string financial_yr11 { get; set; }
        public string branch_code1 { get; set; }
        public string branch_code11 { get; set; }
        public string voucher_type1 { get; set; }
        public string voucher_type11 { get; set; }
        public string voucher_sub_type1 { get; set; }
        public string voucher_sub_type11 { get; set; }
        public string code_acc1 { get; set; }
        public string code_acc11 { get; set; }
        //public string note_type { get; set; }
        public string party_type1 { get; set; }
        public string party_type11 { get; set; }
        public string party_code1 { get; set; }
        public string party_code11 { get; set; }
        public string remarks1 { get; set; }
        public string sno1 { get; set; }
        public string btn_save { get; set; }
        public List<fan_debit_invoice> DataTable1 { get; set; }
    }

    public class fan_debit_invoice
    {

        public string particulars { get; set; }
        public string invoice_no { get; set; }
        public string invoice_date { get; set; }
        public string sno1 { get; set; }
        public string refno { get; set; }

    }
    private void get_debitnote_details1(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            //cmd = new SqlCommand("SELECT sno,date,financialyear,branchcode,vouchertype,vouchersubtype,accountcode,partytype,partycode,remarks,doe,createdby FROM debit_note_entry");
            cmd = new SqlCommand("SELECT e.sno,e.date,e.financialyear,f.year,b.code,e.branchcode,e.vouchertype,v.transactiontype,e.vouchersubtype,ts.subtype,e.accountcode AS account_code,vs.accountno,e.partytype,p.party_tp,e.partycode AS party_code,pc.partycode,e.remarks FROM debit_note_entry e join debit_invoice_details i on e.sno=i.refno inner join branchmaster b on b.branchid=e.branchcode inner join financialyeardetails f on f.sno=e.financialyear inner join transactiontype v on v.sno=e.vouchertype inner join fam_party_type p on p.sno=e.partytype inner join partymaster pc on pc.sno=e.partycode inner join bankaccountno_master vs on vs.sno=e.accountcode inner join transactionsubtypes ts on ts.sno=e.vouchersubtype");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_debit_det1> paymentdetailslist = new List<fan_debit_det1>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_debit_det1 getpaymentdetails = new fan_debit_det1();
                getpaymentdetails.financial_yr1 = dr["year"].ToString();
                getpaymentdetails.financial_yr11 = dr["financialyear"].ToString();
                getpaymentdetails.branch_code1 = dr["code"].ToString();
                getpaymentdetails.branch_code11 = dr["branchcode"].ToString();
                getpaymentdetails.voucher_type1 = dr["transactiontype"].ToString();
                getpaymentdetails.voucher_type11 = dr["vouchertype"].ToString();
                getpaymentdetails.voucher_sub_type1 = dr["subtype"].ToString();
                getpaymentdetails.voucher_sub_type11 = dr["vouchersubtype"].ToString();
                getpaymentdetails.code_acc1 = dr["accountno"].ToString();
                getpaymentdetails.code_acc11 = dr["account_code"].ToString();
                getpaymentdetails.Trans_Date1 = ((DateTime)dr["date"]).ToString("yyyy-MM-dd");
                getpaymentdetails.remarks1 = dr["remarks"].ToString();
                getpaymentdetails.party_type1 = dr["party_tp"].ToString();
                getpaymentdetails.party_type11 = dr["partytype"].ToString();
                getpaymentdetails.party_code1 = dr["partycode"].ToString();
                getpaymentdetails.party_code11 = dr["party_code"].ToString();
                getpaymentdetails.sno1 = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_debit_invoice_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string refno = context.Request["refno"].ToString();
            cmd = new SqlCommand("SELECT sno,particulars,invoiceno,invoicedate,doe,createdby FROM debit_invoice_details WHERE refno=@refno");
            cmd.Parameters.Add("@refno", refno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_debit_invoice> paymentdetailslist = new List<fan_debit_invoice>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_debit_invoice getpaymentdetails = new fan_debit_invoice();
                getpaymentdetails.particulars = dr["particulars"].ToString();
                getpaymentdetails.invoice_no = dr["invoiceno"].ToString();
                getpaymentdetails.invoice_date = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");  // dr["invoicedate"].ToString();
                //getpaymentdetails.refno = dr["refno"].ToString();
                getpaymentdetails.sno1 = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void save_debit_invoice_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            fan_debit_det1 obj = js.Deserialize<fan_debit_det1>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            //string Trans_no = obj.Trans_no;
            string Trans_Date = obj.Trans_Date1; //((DateTime)obj.Trans_Date).ToString("yyyy-MM-dd");
            string financial_yr = obj.financial_yr1;
            string branch_code = obj.branch_code1;
            string voucher_type = obj.voucher_type1;
            string voucher_sub_type = obj.voucher_sub_type1;
            string code_acc = obj.code_acc1;
            //string note_type = obj.note_type;
            string party_type = obj.party_type1;
            string party_code = obj.party_code1;
            string remarks = obj.remarks1;
            string sno = obj.sno1;
            //DateTime effFrom = Convert.ToDateTime(obj.effFrom);
            //DateTime effTo = Convert.ToDateTime(obj.effTo);
            string btn_save = obj.btn_save;

            if (btn_save == "Save")
            {

                cmd = new SqlCommand("insert into debit_note_entry (date,financialyear,branchcode,vouchertype,vouchersubtype,accountcode,partytype,partycode,remarks,doe,createdby) values (@Trans_Date,@financial_yr,@branch_code,@voucher_type,@voucher_sub_type,@code_acc,@party_type,@party_code,@remarks,@doe,@createdby)");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from debit_note_entry ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string refno = routes.Rows[0]["sno"].ToString();//tax_gl_code
                foreach (fan_debit_invoice si in obj.DataTable1)
                {
                    string particulars = si.particulars;
                    string invoice_no = si.invoice_no;
                    string invoice_date = si.invoice_date;
                    //string Sno = si.sno;
                    cmd = new SqlCommand("insert into debit_invoice_details (particulars,invoiceno,invoicedate,doe,createdby,refno) values (@particulars, @invoice_no, @invoice_date, @doe, @createdby, @refno)");
                    cmd.Parameters.Add("@particulars", particulars);
                    cmd.Parameters.Add("@invoice_no", invoice_no);
                    cmd.Parameters.Add("@invoice_date", invoice_date);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@refno", refno);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {


                //taxtype,rangefrom,rangeto,percentage,fromdate,todate,status,createdby,createdon,doe
                cmd = new SqlCommand("UPDATE debit_note_entry SET date=@Trans_Date,financialyear=@financial_yr,branchcode=@branch_code,vouchertype=@voucher_type,vouchersubtype=@voucher_sub_type,accountcode=@code_acc, partytype=@party_type,partycode=@party_code,remarks=@remarks WHERE sno=@sno");
                //cmd.Parameters.Add("@Trans_no", Trans_no);
                cmd.Parameters.Add("@Trans_Date", Trans_Date);
                cmd.Parameters.Add("@financial_yr", financial_yr);
                cmd.Parameters.Add("@branch_code", branch_code);
                cmd.Parameters.Add("@voucher_type", voucher_type);
                cmd.Parameters.Add("@voucher_sub_type", voucher_sub_type);
                cmd.Parameters.Add("@code_acc", code_acc);
                //cmd.Parameters.Add("@note_type", note_type);
                cmd.Parameters.Add("@party_type", party_type);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@remarks", remarks);
                //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                //cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);

                foreach (fan_debit_invoice si in obj.DataTable1)
                {
                    string particulars = si.particulars;
                    string invoice_no = si.invoice_no;
                    string invoice_date = si.invoice_date;
                    string sno1 = si.sno1;
                    cmd = new SqlCommand("update debit_invoice_details set particulars=@particulars, invoiceno=@invoice_no, invoicedate=@invoice_date where sno=@sno");
                    cmd.Parameters.Add("@particulars", particulars);
                    cmd.Parameters.Add("@invoice_no", invoice_no);
                    cmd.Parameters.Add("@invoice_date", invoice_date);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", UserName);
                    cmd.Parameters.Add("@sno", sno1);
                    //cmd.Parameters.Add("@refno", refno);
                    //cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    //cmd.Parameters.Add("@createdby", UserName);
                    vdm.Update(cmd);
                }
                string msg = "successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);

            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class brs_passbook_det
    {
        public string entrydate { get; set; }
        public string checkno { get; set; }
        public string amount { get; set; }
        public string amounttranstype { get; set; }
        public string status { get; set; }
    }

    private void get_match_unmatch_det(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string account_cd = context.Request["account_cd"].ToString();
            string fromdate = context.Request["fromdate"].ToString();
            string Todate = context.Request["Todate"].ToString();
            string cp = context.Request["cp"].ToString();
            if (cp == "C")
            {
                cmd = new SqlCommand("select brs.bankid, brs.entrydate, brs.checkordd, brs.ddno, brs.checkno, brs.amount, brs.amounttranstype, brs.status from brspassbook_unmatched_details brs join bankaccountno_master bam on brs.bankid=bam.bankid where (bam.accountno=@account_cd) and (brs.entrydate BETWEEN @d1 AND @d2) and (brs.status=@cp) and (brs.checkordd='C')");
                cmd.Parameters.Add("@cp", cp);
                //cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                //cmd.Parameters.Add("@d2", GetHighDate(Todate));
                cmd.Parameters.Add("@account_cd", account_cd);
                cmd.Parameters.Add("@d1", fromdate);
                cmd.Parameters.Add("@d2", Todate);
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                List<brs_passbook_det> paymentdetailslist = new List<brs_passbook_det>();
                foreach (DataRow dr in routes.Rows)
                {
                    brs_passbook_det getpaymentdetails = new brs_passbook_det();
                    getpaymentdetails.entrydate = dr["entrydate"].ToString();
                    getpaymentdetails.amount = dr["amount"].ToString();
                    string checkordd = dr["checkordd"].ToString();
                    if (checkordd == "C")
                    {
                        getpaymentdetails.checkno = dr["checkno"].ToString();
                    }

                    string transtype = dr["amounttranstype"].ToString();
                    if (transtype == "C")
                    {
                        getpaymentdetails.amounttranstype = "CHEQUE";
                    }
                    else
                    {
                        getpaymentdetails.amounttranstype = "DD";
                    }

                    string status_type = dr["status"].ToString();
                    if (status_type == "C")
                    {
                        getpaymentdetails.status = "Matched";
                    }
                    else
                    {
                        getpaymentdetails.status = "UnMatched";
                    }
                    paymentdetailslist.Add(getpaymentdetails);
                }
                string response = GetJson(paymentdetailslist);
                context.Response.Write(response);
            }
            else
            {
                cmd = new SqlCommand("select brs.bankid, brs.entrydate, brs.checkordd, brs.ddno, brs.checkno, brs.amount, brs.amounttranstype, brs.status from brspassbook_unmatched_details brs join bankaccountno_master bam on brs.bankid=bam.bankid where (bam.accountno=@account_cd) and (brs.entrydate BETWEEN @d1 AND @d2) and (brs.status=@cp) and (brs.checkordd='C')");
                cmd.Parameters.Add("@cp", cp);
                //cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                //cmd.Parameters.Add("@d2", GetHighDate(Todate));
                cmd.Parameters.Add("@account_cd", account_cd);
                cmd.Parameters.Add("@d1", fromdate);
                cmd.Parameters.Add("@d2", Todate);
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                List<brs_passbook_det> paymentdetailslist = new List<brs_passbook_det>();
                foreach (DataRow dr in routes.Rows)
                {
                    brs_passbook_det getpaymentdetails = new brs_passbook_det();
                    getpaymentdetails.entrydate = dr["entrydate"].ToString();
                    getpaymentdetails.amount = dr["amount"].ToString();
                    string checkordd = dr["checkordd"].ToString();
                    if (checkordd == "C")
                    {
                        getpaymentdetails.checkno = dr["checkno"].ToString();
                    }

                    string transtype = dr["amounttranstype"].ToString();
                    if (transtype == "C")
                    {
                        getpaymentdetails.amounttranstype = "CHEQUE";
                    }
                    else
                    {
                        getpaymentdetails.amounttranstype = "DD";
                    }
                    string status_type = dr["status"].ToString();
                    if (status_type == "C")
                    {
                        getpaymentdetails.status = "Matched";
                    }
                    else
                    {
                        getpaymentdetails.status = "UnMatched";
                    }
                    paymentdetailslist.Add(getpaymentdetails);
                }
                string response = GetJson(paymentdetailslist);
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void save_party_master(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            fan_party_master_det obj = js.Deserialize<fan_party_master_det>(title1);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string party_tp = obj.party_tp; //((DateTime)obj.Trans_Date).ToString("yyyy-MM-dd");
            string party_code = obj.party_code;
            string party_name = obj.party_name;
            //string branch_name = obj.branch_name;
            //string gl_group = obj.gl_group;
            string gl_id = obj.gl_id;
            string gl_group_desc = obj.gl_group_desc;
            string address = obj.address;
            string state = obj.state;
            string pin = obj.pin;
            string tin = obj.tin;
            string pan = obj.pan;
            string cst = obj.cst;
            string phone = obj.phone;
            string fax = obj.fax;
            string mail = obj.mail;
            string status = obj.status;
            string sno = obj.sno;
            //DateTime effFrom = Convert.ToDateTime(obj.effFrom);
            //DateTime effTo = Convert.ToDateTime(obj.effTo);
            string btn_save = obj.btn_save;

            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into partymaster (partytype,partycode,partyname,gl_group,description,address,pincode,phoneno,fax,email,status,doe,createdby,state,tinno,panno,cstno) values (@party_tp,@party_code,@party_name,@gl_group,@gl_group_desc,@address,@pin,@phone,@fax,@mail,@status,@doe,@createdby,@state,@tin,@pan,@cst)");
                cmd.Parameters.Add("@party_tp", party_tp);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@party_name", party_name);
                //cmd.Parameters.Add("@branch_name", branch_name);
                cmd.Parameters.Add("@gl_group", gl_id);
                cmd.Parameters.Add("@gl_group_desc", gl_group_desc);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@state", state);
                cmd.Parameters.Add("@pin", pin);
                cmd.Parameters.Add("@tin", tin);
                cmd.Parameters.Add("@pan", pan);
                cmd.Parameters.Add("@cst", cst);
                cmd.Parameters.Add("@phone", phone);
                cmd.Parameters.Add("@fax", fax);
                cmd.Parameters.Add("@mail", mail);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                vdm.insert(cmd);
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("UPDATE partymaster SET partytype=@party_tp,partycode=@party_code,partyname=@party_name,gl_group=@gl_group,description=@gl_group_desc,address=@address,pincode=@pin,phoneno=@phone, fax=@fax,email=@mail,status=@status,state=@state,tinno=@tin,panno=@pan,cstno=@cst WHERE sno=@sno");
                cmd.Parameters.Add("@party_tp", party_tp);
                cmd.Parameters.Add("@party_code", party_code);
                cmd.Parameters.Add("@party_name", party_name);
                //cmd.Parameters.Add("@branch_name", branch_name);
                cmd.Parameters.Add("@gl_group", gl_id);
                cmd.Parameters.Add("@gl_group_desc", gl_group_desc);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@state", state);
                cmd.Parameters.Add("@pin", pin);
                cmd.Parameters.Add("@tin", tin);
                cmd.Parameters.Add("@pan", pan);
                cmd.Parameters.Add("@cst", cst);
                cmd.Parameters.Add("@phone", phone);
                cmd.Parameters.Add("@fax", fax);
                cmd.Parameters.Add("@mail", mail);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class fan_party_master_det
    {
        public string party_tp_sno { get; set; }
        public string party_tp { get; set; }
        public string party_code { get; set; }
        public string party_name { get; set; }
        //public string branch_name { get; set; }
        public string gl_group { get; set; }
        public string gl_id { get; set; }
        public string gl_group_desc { get; set; }
        public string address { get; set; }
        public string state { get; set; }
        public string pin { get; set; }
        public string phone { get; set; }
        public string fax { get; set; }
        public string mail { get; set; }
        public string tin { get; set; }
        public string pan { get; set; }
        public string cst { get; set; }
        public string status { get; set; }
        public string sno { get; set; }
        public string btn_save { get; set; }

    }
    private void get_party_master(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            //cmd = new SqlCommand("SELECT  sno, partytype, partycode, partyname, gl_group, description, address, pincode, phoneno, fax, email, status, state, tinno, panno, cstno, doe, createdby FROM partymaster");
            cmd = new SqlCommand("SELECT  pm.sno, pt.party_tp, pm.partytype, pm.partycode, pm.partyname, g.groupcode, pm.gl_group, pm.description, pm.address, pm.pincode, pm.phoneno, pm.fax, pm.email, pm.status, pm.state, pm.tinno, pm.panno, pm.cstno FROM partymaster pm join fam_party_type pt on pt.sno=pm.partytype join groupledgermaster g on g.sno=pm.gl_group");
            //cmd = new SqlCommand("SELECT  p.sno, pt.party_tp, p.partytype, p.partycode, p.partyname,pg.shortdesc, p.gl_group, p.description, p.address, p.pincode, p.phoneno, p.fax, p.email, p.status, p.state, p.tinno, p.panno, p.cstno, pg.groupcode FROM partymaster p join primarygroup pg on p.gl_group=pg.sno join fam_party_type pt on p.partytype=pt.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<fan_party_master_det> paymentdetailslist = new List<fan_party_master_det>();
            foreach (DataRow dr in routes.Rows)
            {
                fan_party_master_det getpaymentdetails = new fan_party_master_det();
                getpaymentdetails.party_tp = dr["party_tp"].ToString();
                getpaymentdetails.party_tp_sno = dr["partytype"].ToString();
                getpaymentdetails.party_code = dr["partycode"].ToString();
                getpaymentdetails.party_name = dr["partyname"].ToString();
                getpaymentdetails.gl_group = dr["groupcode"].ToString();
                getpaymentdetails.gl_id = dr["gl_group"].ToString();
                getpaymentdetails.gl_group_desc = dr["description"].ToString();
                //getpaymentdetails.Trans_Date = ((DateTime)dr["date"]).ToString("yyyy-MM-dd");
                getpaymentdetails.address = dr["address"].ToString();
                getpaymentdetails.pin = dr["pincode"].ToString();
                getpaymentdetails.phone = dr["phoneno"].ToString();
                getpaymentdetails.fax = dr["fax"].ToString();
                getpaymentdetails.mail = dr["email"].ToString();
                getpaymentdetails.state = dr["state"].ToString();
                getpaymentdetails.tin = dr["tinno"].ToString();
                getpaymentdetails.pan = dr["panno"].ToString();
                getpaymentdetails.cst = dr["cstno"].ToString();
                //getpaymentdetails.branch_name = dr["branchid"].ToString();
                var status = dr["status"].ToString();
                if (status == "A")
                {
                    getpaymentdetails.status = "Active";
                }
                if (status == "I")
                {
                    getpaymentdetails.status = "InActive";
                }
                getpaymentdetails.sno = dr["sno"].ToString();
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class partycode_list
    {
        public string party_name { get; set; }
        public string party_code { get; set; }
        public string gl_group { get; set; }
        public string address { get; set; }
        public string pincode { get; set; }
        public string phoneno { get; set; }
        public string fax { get; set; }
        public string email { get; set; }
        public string status { get; set; }
        public string sno { get; set; }
    }

    public class branchcode_list
    {
        public string branchid { get; set; }
    }

    private void get_partycode_det(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string branch_cd = context.Request["branch_cd"];
            cmd = new SqlCommand("SELECT  branchid FROM branchmaster WHERE code=@branch_cd");
            cmd.Parameters.Add("@branch_cd", branch_cd);
            DataTable dtpo1 = vdm.SelectQuery(cmd).Tables[0];
            List<branchcode_list> workorderDetails1 = new List<branchcode_list>();
            branchcode_list getworkorderreport1 = new branchcode_list();
            foreach (DataRow dr in dtpo1.Rows)
            {
                //branchcode_list getworkorderreport = new branchcode_list();
                //getworkorderreport.sno = dr["sno"].ToString();
                getworkorderreport1.branchid = dr["branchid"].ToString();
                workorderDetails1.Add(getworkorderreport1);
            }
            int branchid = Convert.ToInt32(getworkorderreport1.branchid);
            cmd = new SqlCommand("SELECT  p.partyname, p.partycode,g.groupcode,p.address,p.pincode,p.phoneno,p.fax,p.email,p.status FROM partymaster p join groupledgermaster g on p.gl_group=g.sno WHERE branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<partycode_list> workorderDetails = new List<partycode_list>();
            foreach (DataRow dr in dtpo.Rows)
            {
                partycode_list getworkorderreport = new partycode_list();
                //getworkorderreport.sno = dr["sno"].ToString();
                getworkorderreport.party_name = dr["partyname"].ToString();
                getworkorderreport.party_code = dr["partycode"].ToString();
                getworkorderreport.gl_group = dr["groupcode"].ToString();
                getworkorderreport.address = dr["address"].ToString();
                getworkorderreport.pincode = dr["pincode"].ToString();
                getworkorderreport.phoneno = dr["phoneno"].ToString();
                getworkorderreport.fax = dr["fax"].ToString();
                getworkorderreport.email = dr["email"].ToString();
                //getworkorderreport.status = dr["status"].ToString();
                var status = dr["status"].ToString();
                if (status == "A")
                {
                    getworkorderreport.status = "Active";
                }
                if (status == "I")
                {
                    getworkorderreport.status = "InActive";
                }
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class post_cheque_list
    {
        public string partycode { get; set; }
        public string amount { get; set; }
        public string chequeno { get; set; }
        public string chequedate { get; set; }
        public string branchname { get; set; }
        public string partyname { get; set; }
        public string address { get; set; }
        public string pincode { get; set; }
        public string status { get; set; }
        public string sno { get; set; }
        public string remarks { get; set; }
        public string chequetype { get; set; }
    }

    public class bank_cheque_list
    {
        public string sno { get; set; }
    }

    private void get_post_cheque(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string acno = context.Request["accountno"].ToString();
            string fromdate = context.Request["fromdate"].ToString();
            string Todate = context.Request["Todate"].ToString();
            cmd = new SqlCommand("SELECT  sno,accountno FROM bankaccountno_master WHERE sno=@acno");
            cmd.Parameters.Add("@acno", acno);
            DataTable dtpo1 = vdm.SelectQuery(cmd).Tables[0];
            List<bank_cheque_list> workorderDetails1 = new List<bank_cheque_list>();
            bank_cheque_list getworkorderreport1 = new bank_cheque_list();
            foreach (DataRow dr in dtpo1.Rows)
            {
                //branchcode_list getworkorderreport = new branchcode_list();
                getworkorderreport1.sno = dr["sno"].ToString();
                workorderDetails1.Add(getworkorderreport1);
            }
            int acid = Convert.ToInt32(getworkorderreport1.sno);
            cmd = new SqlCommand("SELECT  postdated_cheques_entry.sno,postdated_cheques_entry.partycode, postdated_cheques_entry.chequeno,postdated_cheques_entry.chequetype, postdated_cheques_entry.amount, postdated_cheques_entry.remarks,postdated_cheques_entry.amount,postdated_cheques_entry.status, partymaster.partyname FROM  postdated_cheques_entry INNER JOIN partymaster ON postdated_cheques_entry.partycode = partymaster.sno where (postdated_cheques_entry.accountcode=@accountno) and (postdated_cheques_entry.status='P')and (postdated_cheques_entry.chequedate BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@accountno", acid);
            cmd.Parameters.Add("@d1", fromdate);
            cmd.Parameters.Add("@d2", Todate);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<post_cheque_list> paymentdetailslist = new List<post_cheque_list>();
            foreach (DataRow dr in routes.Rows)
            {
                post_cheque_list getpaymentdetails = new post_cheque_list();
                getpaymentdetails.partycode = dr["partycode"].ToString();
                getpaymentdetails.amount = dr["amount"].ToString();
                getpaymentdetails.chequeno = dr["chequeno"].ToString();
                getpaymentdetails.partyname = dr["partyname"].ToString();
                getpaymentdetails.remarks = dr["remarks"].ToString();
                var chequestatus = dr["status"].ToString();
                if (chequestatus== "P")
                {
                    getpaymentdetails.status = "Pending";
                }
                if (chequestatus == "C")
                {
                    getpaymentdetails.status = "Cleared";
                }
                if (chequestatus == "R")
                {
                    getpaymentdetails.status = "Rejected";
                }
                getpaymentdetails.sno = dr["sno"].ToString();
                var chequetype = dr["chequetype"].ToString();
                if (chequetype == "R")
                {
                    getpaymentdetails.chequetype = "Receipt";
                }
                if (chequetype == "P")
                {
                    getpaymentdetails.chequetype = "Payment";
                }
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_cheque_status(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string sno = context.Request["sno"].ToString();
            cmd = new SqlCommand("select sno,chequeno from  postdated_cheques_entry where sno=@sno");
            cmd.Parameters.Add("@sno", sno);
            DataTable dtpo1 = vdm.SelectQuery(cmd).Tables[0];
            List<bank_cheque_list> workorderDetails1 = new List<bank_cheque_list>();
            bank_cheque_list getworkorderreport1 = new bank_cheque_list();
            foreach (DataRow dr in dtpo1.Rows)
            {
                getworkorderreport1.sno = dr["sno"].ToString();
                workorderDetails1.Add(getworkorderreport1);
            }
            int sid = Convert.ToInt32(getworkorderreport1.sno);
            cmd = new SqlCommand("update postdated_cheques_entry set status=@status where sno=@sid");
            cmd.Parameters.Add("@sid", sid);
            cmd.Parameters.Add("@status", "C");
            vdm.Update(cmd);
            cmd = new SqlCommand("SELECT  postdated_cheques_entry.sno,postdated_cheques_entry.partycode, postdated_cheques_entry.chequeno, postdated_cheques_entry.chequetype,postdated_cheques_entry.amount, postdated_cheques_entry.remarks,postdated_cheques_entry.amount,postdated_cheques_entry.status, partymaster.partyname FROM  postdated_cheques_entry INNER JOIN partymaster ON postdated_cheques_entry.partycode = partymaster.sno where postdated_cheques_entry.sno=@sno");
            cmd.Parameters.Add("@sno", sid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<post_cheque_list> paymentdetailslist = new List<post_cheque_list>();
            foreach (DataRow dr in routes.Rows)
            {
                post_cheque_list getpaymentdetails = new post_cheque_list();
                getpaymentdetails.partycode = dr["partycode"].ToString();
                getpaymentdetails.amount = dr["amount"].ToString();
                getpaymentdetails.chequeno = dr["chequeno"].ToString();
                getpaymentdetails.partyname = dr["partyname"].ToString();
                var chequestatus = dr["status"].ToString();
                if (chequestatus== "P")
                {
                    getpaymentdetails.status = "Pending";
                }
                if (chequestatus == "C")
                {
                    getpaymentdetails.status = "Cleared";
                }
                var chequetype = dr["chequetype"].ToString();
                if (chequetype == "R")
                {
                    getpaymentdetails.chequetype = "Receipt";
                }
                if (chequetype == "P")
                {
                    getpaymentdetails.chequetype = "Payment";
                }
                getpaymentdetails.remarks = dr["remarks"].ToString();
           
                paymentdetailslist.Add(getpaymentdetails);
            }
            string response = GetJson(paymentdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    
    public void save_tds_acknowledge_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();

            string fin_year = context.Request["fin_year"];
            string from_date = context.Request["from_date"];
            string to_date = context.Request["to_date"];
            string glcode = context.Request["glcode"];
            string type = context.Request["type"];
            string qtr_no = context.Request["qtr_no"];
            string ackn_no = context.Request["ackn_no"];
            string ackn_date = context.Request["ackn_date"];
            string sno = context.Request["sno"];
            string btn_save = context.Request["btn_save"];
            string UserName = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into tds_acknowledgement (financialyear,fromdate,todate,glcode,type,qtrno,acknowledgeno,acknowledgedate,doe,createdby) values (@fin_year,@from_date,@to_date,@glcode,@type,@qtr_no,@ackn_no,@ackn_date,@doe,@createdby)");
                cmd.Parameters.Add("@fin_year", fin_year);
                cmd.Parameters.Add("@from_date", from_date);
                cmd.Parameters.Add("@to_date", to_date);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@qtr_no", qtr_no);
                cmd.Parameters.Add("@ackn_no", ackn_no);
                cmd.Parameters.Add("@ackn_date", ackn_date);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                //cmd.Parameters.Add("@glcode", glcode);
                vdm.insert(cmd);
                string msg = "details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string CompanyCode = context.Request["CompanyCode"];
                cmd = new SqlCommand("Update tds_acknowledgement set financialyear=@fin_year,fromdate=@from_date,todate=@to_date,glcode=@glcode,type=@type,qtrno=@qtr_no,acknowledgeno=@ackn_no,acknowledgedate=@ackn_date,createdby=@createdby,doe=@doe where sno=@sno");
                cmd.Parameters.Add("@fin_year", fin_year);
                cmd.Parameters.Add("@from_date", from_date);
                cmd.Parameters.Add("@to_date", to_date);
                cmd.Parameters.Add("@glcode", glcode);
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@qtr_no", qtr_no);
                cmd.Parameters.Add("@ackn_no", ackn_no);
                cmd.Parameters.Add("@ackn_date", ackn_date);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.Update(cmd);
                string msg = "details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class Tds_Entry
    {
        public string fin_year { get; set; }
        public string fin_year1 { get; set; }
        public string from_date { get; set; }
        public string to_date { get; set; }
        public string glcode { get; set; }
        public string glcode1 { get; set; }
        public string type { get; set; }
        public string qtr_no { get; set; }
        public string ackn_no { get; set; }
        public string ackn_date { get; set; }
        public string sno { get; set; }

    }
    private void get_tds_acknowledge_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT t.sno,t.financialyear,f.year,t.fromdate,t.todate,t.glcode AS gl_code,g.glcode,t.type,t.qtrno,t.acknowledgeno,t.acknowledgedate,t.doe,t.createdby FROM tds_acknowledgement t inner join financialyeardetails f on f.sno= t.financialyear inner join gl_details g on g.sno=t.glcode");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Tds_Entry> companyMasterlist = new List<Tds_Entry>();
            foreach (DataRow dr in routes.Rows)
            {
                Tds_Entry getcompanydetails = new Tds_Entry();
                getcompanydetails.fin_year = dr["year"].ToString();
                getcompanydetails.fin_year1 = dr["financialyear"].ToString();
                getcompanydetails.from_date = ((DateTime)dr["fromdate"]).ToString("yyyy-MM-dd");
                //getcompanydetails.from_date = dr["fromdate"].ToString();
                getcompanydetails.to_date = ((DateTime)dr["todate"]).ToString("yyyy-MM-dd");
                //getcompanydetails.to_date = dr["todate"].ToString();
                getcompanydetails.glcode = dr["glcode"].ToString();
                getcompanydetails.glcode1 = dr["gl_code"].ToString();
                getcompanydetails.type = dr["type"].ToString();
                getcompanydetails.qtr_no = dr["qtrno"].ToString();
                getcompanydetails.ackn_no = dr["acknowledgeno"].ToString();
                getcompanydetails.ackn_date = ((DateTime)dr["acknowledgedate"]).ToString("yyyy-MM-dd");
                //getcompanydetails.ackn_date = dr["acknowledgedate"].ToString();
                getcompanydetails.sno = dr["sno"].ToString();

                companyMasterlist.Add(getcompanydetails);
            }
            string response = GetJson(companyMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void save_accountmaster_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string UserName = context.Session["UserSno"].ToString();
            string groupcode = context.Request["groupcode"];
            string groupid = context.Request["groupid"];
            string accountcode = context.Request["accountcode"];
            string accshortdescription = context.Request["accshortdescription"];
            string acctype = context.Request["acctype"];
            string accstatus = context.Request["accstatus"];
            string fbtapplicable = context.Request["fbtapplicable"];
            string vatreturns = context.Request["vatreturns"];
            string tdsappicable = context.Request["tdsappicable"];
            string btnval = context.Request["btnVal"];
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into accountmaster (groupcode,accountcode,description,accounttype,accountstatus,fbtapplicable,vatreturns,tdsapplicable,doe,createdby) values (@groupcode,@accountcode,@description,@accounttype,@accountstatus,@fbtapplicable,@vatreturns,@tdsapplicable,@doe,@createdby)");
                cmd.Parameters.Add("@groupcode", groupid);
                cmd.Parameters.Add("@accountcode", accountcode);
                cmd.Parameters.Add("@description", accshortdescription);
                cmd.Parameters.Add("@accounttype", acctype);
                cmd.Parameters.Add("@accountstatus", accstatus);
                cmd.Parameters.Add("@fbtapplicable", fbtapplicable);
                cmd.Parameters.Add("@vatreturns", vatreturns);
                cmd.Parameters.Add("@tdsapplicable", tdsappicable);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "Details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update accountmaster set groupcode=@groupcode,accountcode=@accountcode,description=@description,accounttype=@accounttype,accountstatus=@accountstatus,fbtapplicable=@fbtapplicable,vatreturns=@vatreturns,tdsapplicable=@tdsapplicable,doe=@doe,createdby=@createdby where sno=@sno");
                cmd.Parameters.Add("@groupcode", groupid);
                cmd.Parameters.Add("@accountcode", accountcode);
                cmd.Parameters.Add("@description", accshortdescription);
                cmd.Parameters.Add("@accounttype", acctype);
                cmd.Parameters.Add("@accountstatus", accstatus);
                cmd.Parameters.Add("@fbtapplicable", fbtapplicable);
                cmd.Parameters.Add("@vatreturns", vatreturns);
                cmd.Parameters.Add("@tdsapplicable", tdsappicable);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string msg = "Details updated  successfully ";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class accountmaster
    {
        public string groupcode { get; set; }
        public string groupname { get; set; }
        public string accountcode { get; set; }
        public string accshortdescription { get; set; }
        public string acclongdescription { get; set; }
        public string acctype { get; set; }
        public string acctype1 { get; set; }
        public string accstatus { get; set; }
        public string accstatus1 { get; set; }
        public string fbtapplicable { get; set; }
        public string fbtapplicable1 { get; set; }
        public string vatreturns { get; set; }
        public string vatreturns1 { get; set; }
        public string tdsappicable { get; set; }
        public string tdsappicable1 { get; set; }
        public string sno { get; set; }
        public string groupid { get; set; }

        public string acode { get; set; }
    }

    private void get_accountmaster_click(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            // cmd = new SqlCommand("select sno,branchcode,financialyear,vouchertype,vouchernofrm,vouchernoto,manualsystem,doe,createdby from voucherseries");
            cmd = new SqlCommand("SELECT fixed_assets_groups.groupname, accountmaster.sno,accountmaster.groupcode, accountmaster.accountcode, accountmaster.description, accountmaster.accounttype, accountmaster.accountstatus, accountmaster.fbtapplicable,accountmaster.vatreturns, accountmaster.tdsapplicable, accountmaster.createdby FROM accountmaster INNER JOIN fixed_assets_groups ON accountmaster.groupcode = fixed_assets_groups.sno");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<accountmaster> accountmaster = new List<accountmaster>();
            foreach (DataRow dr in routes.Rows)
            {
                accountmaster getvoucherdetail = new accountmaster();
                getvoucherdetail.groupcode = dr["groupname"].ToString();
                getvoucherdetail.groupid = dr["groupcode"].ToString();
                getvoucherdetail.accountcode = dr["accountcode"].ToString();
                getvoucherdetail.accshortdescription = dr["description"].ToString();
                getvoucherdetail.acctype = dr["accounttype"].ToString();
                var acctype1 = dr["accounttype"].ToString();
                if (acctype1 == "CA")
                {
                    getvoucherdetail.acctype1 = "Cash";
                }
                if (acctype1 == "BA")
                {
                    getvoucherdetail.acctype1 = "Bank";
                }
                if (acctype1 == "PA")
                {
                    getvoucherdetail.acctype1 = "Purchase";
                }
                if (acctype1 == "SA")
                {
                    getvoucherdetail.acctype1 = "SA";
                }
                if (acctype1 == "TAX")
                {
                    getvoucherdetail.acctype1 = "TAX";
                }
                getvoucherdetail.accstatus = dr["accountstatus"].ToString();
                var accstatus1 = dr["accountstatus"].ToString();
                if (accstatus1 == "A")
                {
                    getvoucherdetail.accstatus1 = "Active";
                }
                if (accstatus1 == "I")
                {
                    getvoucherdetail.accstatus1 = "Inactive";
                }
                getvoucherdetail.fbtapplicable = dr["fbtapplicable"].ToString();
                var fbtapplicable1 = dr["fbtapplicable"].ToString();
                if (fbtapplicable1 == "Y")
                {
                    getvoucherdetail.fbtapplicable1 = "Yes";
                }
                if (fbtapplicable1 == "N")
                {
                    getvoucherdetail.fbtapplicable1 = "No";
                }
                getvoucherdetail.vatreturns = dr["vatreturns"].ToString();
                var vatreturns1 = dr["vatreturns"].ToString();
                if (vatreturns1 == "Y")
                {
                    getvoucherdetail.vatreturns1 = "Yes";
                }
                if (vatreturns1 == "N")
                {
                    getvoucherdetail.vatreturns1 = "No";
                }
                getvoucherdetail.tdsappicable = dr["tdsapplicable"].ToString();
                var tdsappicable1 = dr["tdsapplicable"].ToString();
                if (tdsappicable1 == "Y")
                {
                    getvoucherdetail.tdsappicable1 = "Yes";
                }
                if (tdsappicable1 == "N")
                {
                    getvoucherdetail.tdsappicable1 = "No";
                }
                getvoucherdetail.sno = dr["sno"].ToString();
                accountmaster.Add(getvoucherdetail);
            }
            string response = GetJson(accountmaster);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_account_code(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string groupcode = context.Request["groupcode"];
            cmd = new SqlCommand("SELECT { fn IFNULL(MAX(sno), 0) } + 1 AS acode FROM  accountmaster where groupcode=@groupcode");
            cmd.Parameters.Add("@groupcode", groupcode);
            DataTable dtaccode = vdm.SelectQuery(cmd).Tables[0];
            string accountno = "00" + dtaccode.Rows[0]["acode"].ToString() + "";
            List<accountmaster> voucherlist = new List<accountmaster>();
            foreach (DataRow dr in dtaccode.Rows)
            {
                accountmaster getvoucherdetail = new accountmaster();
                getvoucherdetail.acode = accountno;
                voucherlist.Add(getvoucherdetail);
            }
            string response = GetJson(voucherlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }



    public void save_credit_entry_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();

            string trans_dt = context.Request["trans_dt"];
            string fin_yr = context.Request["fin_yr"];
            string gl_code = context.Request["gl_code"];
            string party_tp = context.Request["party_tp"];
            string party_cd = context.Request["party_cd"];
            string inv_no = context.Request["inv_no"];
            string inv_dt = context.Request["inv_dt"];
            string inv_amt = context.Request["inv_amt"];
            string vou_tp = context.Request["vou_tp"];
            string deb_acc = context.Request["deb_acc"];
            string deb_amt = context.Request["deb_amt"];
            string cre_acc = context.Request["cre_acc"];
            string cre_amt = context.Request["cre_amt"];
            string remarks = context.Request["remarks"];
            string sno = context.Request["sno"];
            string btn_save = context.Request["btn_save"];
            string UserName = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into creditnote_entry (transactiondate,financialyear,groupledger,partytype,partyname,invoiceno,invoicedate,invoiceamount,vouchertype,debitoraccount,debitoramount,creditoraccount,creditoramount,remarks,doe,createdby) values (@trans_dt,@fin_yr,@gl_code,@party_tp,@party_cd,@inv_no,@inv_dt,@inv_amt,@vou_tp,@deb_acc,@deb_amt,@cre_acc,@cre_amt,@remarks,@doe,@createdby)");
                cmd.Parameters.Add("@trans_dt", trans_dt);
                cmd.Parameters.Add("@fin_yr", fin_yr);
                cmd.Parameters.Add("@gl_code", gl_code);
                cmd.Parameters.Add("@party_tp", party_tp);
                cmd.Parameters.Add("@party_cd", party_cd);
                cmd.Parameters.Add("@inv_no", inv_no);
                cmd.Parameters.Add("@inv_dt", inv_dt);
                cmd.Parameters.Add("@inv_amt", inv_amt);
                cmd.Parameters.Add("@vou_tp", vou_tp);
                cmd.Parameters.Add("@deb_acc", deb_acc);
                cmd.Parameters.Add("@deb_amt", deb_amt);
                cmd.Parameters.Add("@cre_acc", cre_acc);
                cmd.Parameters.Add("@cre_amt", cre_amt);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("Update creditnote_entry set transactiondate=@trans_dt,financialyear=@fin_yr,groupledger=@gl_code,partytype=@party_tp,partyname=@party_cd,invoiceno=@inv_no,invoicedate=@inv_dt,invoiceamount=@inv_amt,vouchertype=@vou_tp,debitoraccount=@deb_acc,debitoramount=@deb_amt,creditoraccount=@cre_acc,creditoramount=@cre_amt,remarks=@remarks where sno=@sno");
                cmd.Parameters.Add("@trans_dt", trans_dt);
                cmd.Parameters.Add("@fin_yr", fin_yr);
                cmd.Parameters.Add("@gl_code", gl_code);
                cmd.Parameters.Add("@party_tp", party_tp);
                cmd.Parameters.Add("@party_cd", party_cd);
                cmd.Parameters.Add("@inv_no", inv_no);
                cmd.Parameters.Add("@inv_dt", inv_dt);
                cmd.Parameters.Add("@inv_amt", inv_amt);
                cmd.Parameters.Add("@vou_tp", vou_tp);
                cmd.Parameters.Add("@deb_acc", deb_acc);
                cmd.Parameters.Add("@deb_amt", deb_amt);
                cmd.Parameters.Add("@cre_acc", cre_acc);
                cmd.Parameters.Add("@cre_amt", cre_amt);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.Update(cmd);
                string msg = "details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Credit_Entry
    {
        public string trans_dt { get; set; }
        public string fin_yr { get; set; }
        public string fin_yr1 { get; set; }
        public string gl_code { get; set; }
        public string gl_code1 { get; set; }
        public string gl_code_name { get; set; }
        public string party_tp { get; set; }
        public string party_tp_desc { get; set; }
        public string party_tp1 { get; set; }
        public string party_cd { get; set; }
        public string party_cd1 { get; set; }
        public string party_name { get; set; }
        public string inv_no { get; set; }
        public string inv_dt { get; set; }
        public string inv_amt { get; set; }
        public string vou_tp { get; set; }
        public string vou_tp1 { get; set; }
        public string deb_acc { get; set; }
        public string deb_acc1 { get; set; }
        public string deb_amt { get; set; }
        public string cre_acc { get; set; }
        public string cre_acc1 { get; set; }
        public string cre_amt { get; set; }
        public string remarks { get; set; }
        public string sno { get; set; }

    }
    private void get_credit_entry_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT c.sno,c.transactiondate,c.financialyear,fy.year,c.groupledger,pg.groupcode,pg.groupshortdesc,c.partytype,pt.party_tp,pt.short_desc,c.partyname as party_cd,pm.partycode,pm.partyname,c.invoiceno,c.invoicedate,c.invoiceamount,c.vouchertype,tv.transactiontype,c.debitoraccount,hod.accountname as debit_head,c.debitoramount,c.creditoraccount,hoc.accountname as credit_head,c.creditoramount,c.remarks FROM creditnote_entry c join groupledgermaster pg on pg.sno=c.groupledger join fam_party_type pt on pt.sno=c.partytype join partymaster pm on pm.sno=c.partyname join transactiontype tv on tv.sno=c.vouchertype join headofaccounts_master hod on hod.sno=c.debitoraccount join headofaccounts_master hoc on hoc.sno=c.creditoraccount join financialyeardetails fy on fy.sno=c.financialyear");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Credit_Entry> companyMasterlist = new List<Credit_Entry>();
            foreach (DataRow dr in routes.Rows)
            {
                Credit_Entry getcompanydetails = new Credit_Entry();
                //getcompanydetails.trans_dt = dr["transactiondate"].ToString();
                getcompanydetails.trans_dt = ((DateTime)dr["transactiondate"]).ToString("yyyy-MM-dd");
                getcompanydetails.fin_yr = dr["year"].ToString();
                getcompanydetails.fin_yr1 = dr["financialyear"].ToString();
                getcompanydetails.gl_code = dr["groupcode"].ToString();
                getcompanydetails.gl_code1 = dr["groupledger"].ToString();
                getcompanydetails.gl_code_name = dr["groupshortdesc"].ToString();
                getcompanydetails.party_tp = dr["party_tp"].ToString();
                getcompanydetails.party_tp1 = dr["partytype"].ToString();
                getcompanydetails.party_tp_desc = dr["short_desc"].ToString();
                //getcompanydetails.from_date = ((DateTime)dr["fromdate"]).ToString("yyyy-MM-dd");
                getcompanydetails.party_cd = dr["partycode"].ToString();
                getcompanydetails.party_cd1 = dr["party_cd"].ToString();
                getcompanydetails.party_name = dr["partyname"].ToString();
                getcompanydetails.inv_no = dr["invoiceno"].ToString();
                //getcompanydetails.inv_dt = dr["invoicedate"].ToString();
                getcompanydetails.inv_dt = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");
                getcompanydetails.inv_amt = dr["invoiceamount"].ToString();
                getcompanydetails.vou_tp = dr["transactiontype"].ToString();
                getcompanydetails.vou_tp1 = dr["vouchertype"].ToString();
                getcompanydetails.deb_acc = dr["debit_head"].ToString();
                getcompanydetails.deb_acc1 = dr["debitoraccount"].ToString();
                getcompanydetails.deb_amt = dr["debitoramount"].ToString();
                getcompanydetails.cre_acc = dr["credit_head"].ToString();
                getcompanydetails.cre_acc1 = dr["creditoraccount"].ToString();
                getcompanydetails.cre_amt = dr["creditoramount"].ToString();
                getcompanydetails.remarks = dr["remarks"].ToString();
                getcompanydetails.sno = dr["sno"].ToString();

                companyMasterlist.Add(getcompanydetails);
            }
            string response = GetJson(companyMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void save_debit_entry_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();

            string trans_dt = context.Request["trans_dt"];
            string fin_yr = context.Request["fin_yr"];
            string gl_code = context.Request["gl_code"];
            string party_tp = context.Request["party_tp"];
            string party_cd = context.Request["party_cd"];
            string inv_no = context.Request["inv_no"];
            string inv_dt = context.Request["inv_dt"];
            string inv_amt = context.Request["inv_amt"];
            string vou_tp = context.Request["vou_tp"];
            string deb_acc = context.Request["deb_acc"];
            string deb_amt = context.Request["deb_amt"];
            string cre_acc = context.Request["cre_acc"];
            string cre_amt = context.Request["cre_amt"];
            string remarks = context.Request["remarks"];
            string sno = context.Request["sno"];
            string btn_save = context.Request["btn_save"];
            string UserName = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into debitnote_entry (transactiondate,financialyear,groupledger,partytype,partyname,invoiceno,invoicedate,invoiceamount,vouchertype,debitoraccount,debitoramount,creditoraccount,creditoramount,remarks,doe,createdby) values (@trans_dt,@fin_yr,@gl_code,@party_tp,@party_cd,@inv_no,@inv_dt,@inv_amt,@vou_tp,@deb_acc,@deb_amt,@cre_acc,@cre_amt,@remarks,@doe,@createdby)");
                cmd.Parameters.Add("@trans_dt", trans_dt);
                cmd.Parameters.Add("@fin_yr", fin_yr);
                cmd.Parameters.Add("@gl_code", gl_code);
                cmd.Parameters.Add("@party_tp", party_tp);
                cmd.Parameters.Add("@party_cd", party_cd);
                cmd.Parameters.Add("@inv_no", inv_no);
                cmd.Parameters.Add("@inv_dt", inv_dt);
                cmd.Parameters.Add("@inv_amt", inv_amt);
                cmd.Parameters.Add("@vou_tp", vou_tp);
                cmd.Parameters.Add("@deb_acc", deb_acc);
                cmd.Parameters.Add("@deb_amt", deb_amt);
                cmd.Parameters.Add("@cre_acc", cre_acc);
                cmd.Parameters.Add("@cre_amt", cre_amt);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.insert(cmd);
                string msg = "details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("Update debitnote_entry set transactiondate=@trans_dt,financialyear=@fin_yr,groupledger=@gl_code,partytype=@party_tp,partyname=@party_cd,invoiceno=@inv_no,invoicedate=@inv_dt,invoiceamount=@inv_amt,vouchertype=@vou_tp,debitoraccount=@deb_acc,debitoramount=@deb_amt,creditoraccount=@cre_acc,creditoramount=@cre_amt,remarks=@remarks where sno=@sno");
                cmd.Parameters.Add("@trans_dt", trans_dt);
                cmd.Parameters.Add("@fin_yr", fin_yr);
                cmd.Parameters.Add("@gl_code", gl_code);
                cmd.Parameters.Add("@party_tp", party_tp);
                cmd.Parameters.Add("@party_cd", party_cd);
                cmd.Parameters.Add("@inv_no", inv_no);
                cmd.Parameters.Add("@inv_dt", inv_dt);
                cmd.Parameters.Add("@inv_amt", inv_amt);
                cmd.Parameters.Add("@vou_tp", vou_tp);
                cmd.Parameters.Add("@deb_acc", deb_acc);
                cmd.Parameters.Add("@deb_amt", deb_amt);
                cmd.Parameters.Add("@cre_acc", cre_acc);
                cmd.Parameters.Add("@cre_amt", cre_amt);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@createdby", UserName);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                vdm.Update(cmd);
                string msg = "details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Debit_Entry
    {
        public string trans_dt { get; set; }
        public string fin_yr { get; set; }
        public string fin_yr1 { get; set; }
        public string gl_code { get; set; }
        public string gl_code_name { get; set; }
        public string gl_code1 { get; set; }
        public string party_tp { get; set; }
        public string party_tp1 { get; set; }
        public string party_tp_desc { get; set; }
        public string party_cd { get; set; }
        public string party_cd1 { get; set; }
        public string party_name { get; set; }
        public string inv_no { get; set; }
        public string inv_dt { get; set; }
        public string inv_amt { get; set; }
        public string vou_tp { get; set; }
        public string vou_tp1 { get; set; }
        public string deb_acc { get; set; }
        public string deb_acc1 { get; set; }
        public string deb_amt { get; set; }
        public string cre_acc { get; set; }
        public string cre_acc1 { get; set; }
        public string cre_amt { get; set; }
        public string remarks { get; set; }
        public string sno { get; set; }

    }
    private void get_debit_entry_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            cmd = new SqlCommand("SELECT c.sno,c.transactiondate,c.financialyear,fy.year,c.groupledger,pg.groupcode,pg.groupshortdesc,c.partytype,pt.party_tp,pt.short_desc,c.partyname as party_cd,pm.partycode,pm.partyname,c.invoiceno,c.invoicedate,c.invoiceamount,c.vouchertype,tv.transactiontype,c.debitoraccount,hod.accountname as debit_head,c.debitoramount,c.creditoraccount,hoc.accountname as credit_head,c.creditoramount,c.remarks FROM debitnote_entry c join groupledgermaster pg on pg.sno=c.groupledger join fam_party_type pt on pt.sno=c.partytype join partymaster pm on pm.sno=c.partyname join transactiontype tv on tv.sno=c.vouchertype join headofaccounts_master hod on hod.sno=c.debitoraccount join headofaccounts_master hoc on hoc.sno=c.creditoraccount join financialyeardetails fy on fy.sno=c.financialyear");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Debit_Entry> companyMasterlist = new List<Debit_Entry>();
            foreach (DataRow dr in routes.Rows)
            {
                Debit_Entry getcompanydetails = new Debit_Entry();
                //getcompanydetails.trans_dt = dr["transactiondate"].ToString();
                getcompanydetails.trans_dt = ((DateTime)dr["transactiondate"]).ToString("yyyy-MM-dd");
                getcompanydetails.fin_yr = dr["year"].ToString();
                getcompanydetails.fin_yr1 = dr["financialyear"].ToString();
                getcompanydetails.gl_code = dr["groupcode"].ToString();
                getcompanydetails.gl_code1 = dr["groupledger"].ToString();
                getcompanydetails.gl_code_name = dr["groupshortdesc"].ToString();
                getcompanydetails.party_tp = dr["party_tp"].ToString();
                getcompanydetails.party_tp1 = dr["partytype"].ToString();
                getcompanydetails.party_tp_desc = dr["short_desc"].ToString();
                //getcompanydetails.from_date = ((DateTime)dr["fromdate"]).ToString("yyyy-MM-dd");
                getcompanydetails.party_cd = dr["partycode"].ToString();
                getcompanydetails.party_cd1 = dr["party_cd"].ToString();
                getcompanydetails.party_name = dr["partyname"].ToString();
                getcompanydetails.inv_no = dr["invoiceno"].ToString();
                //getcompanydetails.inv_dt = dr["invoicedate"].ToString();
                getcompanydetails.inv_dt = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");
                getcompanydetails.inv_amt = dr["invoiceamount"].ToString();
                getcompanydetails.vou_tp = dr["transactiontype"].ToString();
                getcompanydetails.vou_tp1 = dr["vouchertype"].ToString();
                getcompanydetails.deb_acc = dr["debit_head"].ToString();
                getcompanydetails.deb_acc1 = dr["debitoraccount"].ToString();
                getcompanydetails.deb_amt = dr["debitoramount"].ToString();
                getcompanydetails.cre_acc = dr["credit_head"].ToString();
                getcompanydetails.cre_acc1 = dr["creditoraccount"].ToString();
                getcompanydetails.cre_amt = dr["creditoramount"].ToString();
                getcompanydetails.remarks = dr["remarks"].ToString();
                getcompanydetails.sno = dr["sno"].ToString();

                companyMasterlist.Add(getcompanydetails);
            }
            string response = GetJson(companyMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class fixedassets
    {
        public string sno { get; set; }
        public string btnval { get; set; }
        public List<fixedassetssub> fixedassetsarray { get; set; }

    }
    public class fixedassetssub
    {
        public string branchcode { get; set; }
        public string accountcode { get; set; }
        public string accountdescription { get; set; }
        public string acclongdescription { get; set; }
        public string groupcode { get; set; }
        public string deprate { get; set; }
        public string doe { get; set; }
        public string hdnproductsno { get; set; }
        public string branchid { get; set; }
        public string accountid { get; set; }
        public string groupid { get; set; }
        public string branchname { get; set; }
    }
    private void save_fixed_assets(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            fixedassets obj = js.Deserialize<fixedassets>(title1);
            string btnval = obj.btnval.TrimEnd();
            string createdby = context.Session["UserSno"].ToString();
            string modifiedby = context.Session["UserSno"].ToString();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            vdm = new VehicleDBMgr();
            if (btnval == "Save")
            {
                foreach (fixedassetssub es in obj.fixedassetsarray)
                {
                    cmd = new SqlCommand("insert into fixed_assets (branchcode,accountcode,groupcode,dep_rate,doe,createdby) values (@branchcode,@accountcode,@groupcode,@dep_rate,@doe,@createdby)");
                    //branchcode,accountcode,groupcode,dep_rate,doe,createdby
                    cmd.Parameters.Add("@branchcode", es.branchid);
                    cmd.Parameters.Add("@accountcode", es.accountid);
                    cmd.Parameters.Add("@groupcode", es.groupid);
                    cmd.Parameters.Add("@dep_rate", es.deprate);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", createdby);
                    vdm.insert(cmd);
                }
                string response = GetJson("Insert Successfully");
                context.Response.Write(response);
            }
            else
            {
                foreach (fixedassetssub es in obj.fixedassetsarray)
                {
                    //string sno = obj.sno;
                    cmd = new SqlCommand("Update fixed_assets set branchcode=@branchcode,accountcode=@accountcode,groupcode=@groupcode,dep_rate=@dep_rate,doe=@doe,createdby=@createdby where sno=@sno");
                    //branchcode,accountcode,groupcode,dep_rate,doe,createdby
                    cmd.Parameters.Add("@branchcode", es.branchid);
                    cmd.Parameters.Add("@accountcode", es.accountid);
                    cmd.Parameters.Add("@groupcode", es.groupid);
                    cmd.Parameters.Add("@dep_rate", es.deprate);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@sno", es.hdnproductsno);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into fixed_assets (branchcode,accountcode,groupcode,dep_rate,doe,createdby) values (@branchcode,@accountcode,@groupcode,@dep_rate,@doe,@createdby)");
                        //branchcode,accountcode,groupcode,dep_rate,doe,createdby
                        cmd.Parameters.Add("@branchcode", es.branchid);
                        cmd.Parameters.Add("@accountcode", es.accountid);
                        cmd.Parameters.Add("@groupcode", es.groupid);
                        cmd.Parameters.Add("@dep_rate", es.deprate);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@createdby", createdby);
                        vdm.insert(cmd);
                    }
                }
                string response = GetJson("update Successfully");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }
    public class getfixedassets
    {
        public List<fixedassets> fixedassets { get; set; }
        public List<fixedassetssub> fixedassetssub { get; set; }
    }
    private void get_fixed_assets(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            //string createdby = context.Session["UserSno"].ToString();
            //cmd = new SqlCommand("SELECT  fixed_assets.sno, fixed_assets.accountcode, fixed_assets.groupcode, fixed_assets.dep_rate, fixed_assets.doe, fixed_assets.createdby, fixed_assets.branchcode,  branchmaster.branchname, accountmaster.accountcode AS acountid, accountmaster.description, subgroup_ledgerdetails.subgroupcode,  subgroup_ledgerdetails.subgroup FROM  fixed_assets LEFT OUTER JOIN branchmaster ON fixed_assets.branchcode = branchmaster.branchid LEFT OUTER JOIN accountmaster ON fixed_assets.accountcode = accountmaster.sno LEFT OUTER JOIN subgroup_ledgerdetails ON accountmaster.groupcode = subgroup_ledgerdetails.sno");
            cmd = new SqlCommand("SELECT  fixed_assets.sno, fixed_assets.accountcode, fixed_assets.groupcode, fixed_assets.dep_rate, fixed_assets.doe, fixed_assets.createdby, fixed_assets.branchcode,  branchmaster.branchname, accountmaster.accountcode AS acountid, accountmaster.description, fixed_assets_groups.groupname FROM  fixed_assets LEFT OUTER JOIN branchmaster ON fixed_assets.branchcode = branchmaster.branchid LEFT OUTER JOIN accountmaster ON fixed_assets.accountcode = accountmaster.sno LEFT OUTER JOIN fixed_assets_groups ON accountmaster.groupcode = fixed_assets_groups.sno");
            //SELECT  fixed_assets.sno, fixed_assets.accountcode, fixed_assets.groupcode, fixed_assets.dep_rate, fixed_assets.doe, fixed_assets.createdby, branchmaster.branchname, branchmaster.code, fixed_assets.branchcode, bankaccountno_master.accountno, bankaccountno_master.accounttype,  groupledgermaster.groupcode AS groupid FROM  fixed_assets LEFT OUTER JOIN  branchmaster ON fixed_assets.branchcode = branchmaster.branchid LEFT OUTER JOIN  bankaccountno_master ON fixed_assets.accountcode = bankaccountno_master.sno LEFT OUTER JOIN  groupledgermaster ON fixed_assets.groupcode = groupledgermaster.sno
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            //DataTable dttds = view.ToTable(true, "sno");
            DataTable dttdssub = view.ToTable(true, "sno", "accountcode", "groupcode", "dep_rate", "doe", "branchname", "branchcode", "acountid", "description", "groupname");
            List<getfixedassets> getfixedassets = new List<getfixedassets>();
            List<fixedassets> fixedassets = new List<fixedassets>();
            List<fixedassetssub> fixedassetssub = new List<fixedassetssub>();
            //foreach (DataRow dr in dttds.Rows)
            //{
            //    fixedassets gettds = new fixedassets();
            //    gettds.sno = dr["sno"].ToString();
            //    fixedassets.Add(gettds);
            //}
            foreach (DataRow dr in dttdssub.Rows)
            {
                fixedassetssub gettdssub = new fixedassetssub();
                gettdssub.accountcode = dr["accountcode"].ToString();
                gettdssub.groupcode = dr["groupname"].ToString();
                gettdssub.deprate = dr["dep_rate"].ToString();
                gettdssub.branchname = dr["branchname"].ToString();
                //gettdssub.branchcode = dr["code"].ToString();
                gettdssub.branchid = dr["branchcode"].ToString();
                gettdssub.accountid = dr["acountid"].ToString();
                //gettdssub.acclongdescription = dr["accountlongdesc"].ToString();
                gettdssub.accountdescription = dr["description"].ToString();
                gettdssub.groupid = dr["groupcode"].ToString();
                gettdssub.hdnproductsno = dr["sno"].ToString();
                gettdssub.doe = dr["doe"].ToString();
                fixedassetssub.Add(gettdssub);
            }
            getfixedassets getemployeeDatas = new getfixedassets();
            getemployeeDatas.fixedassets = fixedassets;
            getemployeeDatas.fixedassetssub = fixedassetssub;
            getfixedassets.Add(getemployeeDatas);
            string response = GetJson(getfixedassets);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class procurement
    {
        public string plantcode { get; set; }

        public string plantname { get; set; }

        public string Billdate { get; set; }

        public string Tid { get; set; }

        public string jvno { get; set; }

        public string vchdate { get; set; }

        public string ledgername { get; set; }

        public string amount { get; set; }

        public string narration { get; set; }

        public string HeadOfAccount { get; set; }

        public string Amount { get; set; }

        public string ledgerid { get; set; }
    }
    private void get_plant_names(HttpContext context)
    {
        try
        {
            ProcureDBmanager pdm = new ProcureDBmanager();
            cmd = new SqlCommand("SELECT Plant_Code, Plant_Name FROM Plant_Master where plant_code not in (150,139,160)");
            DataTable dtplant = pdm.SelectQuery(cmd).Tables[0];
            List<procurement> plantlist= new List<procurement>();
            foreach (DataRow dr in dtplant.Rows)
            {
                procurement getvoucherdetail = new procurement();
                getvoucherdetail.plantcode = dr["Plant_Code"].ToString();
                getvoucherdetail.plantname = dr["Plant_Name"].ToString();
                plantlist.Add(getvoucherdetail);
            }
            string response = GetJson(plantlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_bill_dates(HttpContext context)
    {

        try
        {
            ProcureDBmanager pdm = new ProcureDBmanager();
            string fromdate = "";
            string todate = "";
            string plantcode = context.Request["plantcode"].ToString();
            cmd = new SqlCommand("SELECT  TID,Bill_frmdate,Bill_todate FROM Bill_date where  Plant_Code=@plantcode  order by  Bill_frmdate desc");
            cmd.Parameters.Add("@plantcode", plantcode);
            DataTable dtpagentinfo = pdm.SelectQuery(cmd).Tables[0];
            List<procurement> plantlist = new List<procurement>();
            foreach (DataRow dr in dtpagentinfo.Rows)
            {
                procurement getloanentrydetails = new procurement();
                DateTime d1 = Convert.ToDateTime(dr["Bill_frmdate"].ToString());
                DateTime d2 = Convert.ToDateTime(dr["Bill_todate"].ToString());
                fromdate = d1.ToString("dd/MM/yyy");
                todate = d2.ToString("dd/MM/yyy");
                getloanentrydetails.Billdate = fromdate + "-" + todate;
                getloanentrydetails.Tid = dr["TID"].ToString();
                plantlist.Add(getloanentrydetails);

            }
            string response = GetJson(plantlist);
            context.Response.Write(response);
        }
        catch
        {

        }
    }

    private void get_jvagent(HttpContext context)
    {
        ProcureDBmanager pdm = new ProcureDBmanager();
        string frmdate = "";
        string Todate;
        string getvald;
        string getvalm;
        string getvaly;
        string getvaldd;
        string getvalmm;
        string getvalyy;
        string FDATE;
        string TODATE;
        string month;
        int Checkstatus;
        int datach;
        string Tallyno;
        string serino = "";
        double totamt = 0;
        string se = "";
        string aname;
        string uptime = "";
        string fdate;
        string todate;
        string pcode2;
        string agent;
        //string amount;
        string ppname;
        string narration = "";
        string INSERT = "";

        int CHEKKVAL = 0;
        string billdate = context.Request["billdate"].ToString();
        string plantcode = context.Request["plantcode"].ToString();
        string[] p = billdate.Split('/', '-');
        getvald = p[0];
        getvalm = p[1];
        getvaly = p[2];
        getvaldd = p[3];
        getvalmm = p[4];
        getvalyy = p[5];
        FDATE = getvalm + "/" + getvald + "/" + getvaly;
        TODATE = getvalmm + "/" + getvaldd + "/" + getvalyy;

        SqlCommand cmd = new SqlCommand("Select  CONVERT(VARCHAR,Added_Date,101) AS UpdateTime  from (Select convert(varchar,Agent_Id) as Agent_Id,NetAmount,convert(varchar,Agent_Name) as Agent_Name,Added_Date,Plant_Code,convert(varchar,Billfrmdate,103) as Billfrmdate,convert(varchar,Billtodate,103) as Billtodate from BankPaymentllotment  where Plant_code=@plantcode  and  Billfrmdate='" + FDATE + "' and Billtodate='" + TODATE + "' AND TallyStatus IS  NULL   ) as banpay   left join (Select Plant_Code as pmplantcode,Plant_Name   from Plant_Master   where plant_code=@plantcode  group by Plant_Code,Plant_Name) as pm   on banpay.Plant_Code=pm.pmplantcode   GROUP BY  Added_Date  ORDER BY   convert(datetime, Added_Date, 103) ASC   ");
        cmd.Parameters.Add("@plantcode", plantcode);
        DataTable datecount = pdm.SelectQuery(cmd).Tables[0];
        foreach (DataRow Dsrr in datecount.Rows)
        {
            StateBag ViewState = new StateBag();
            try
            {
                SqlCommand dmk = new SqlCommand("Select max(JVNO)  as JVNO  from  TallyloanEntryJvpassAgentWsie WHERE plant_code=@plantcode");
                dmk.Parameters.Add("@plantcode", plantcode);
                DataTable dtjvno = pdm.SelectQuery(dmk).Tables[0];
                if (dtjvno.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtjvno.Rows)
                    {
                        int gettidd = Convert.ToInt32(dr["JVNO"]);
                        ViewState["maxtid"] = gettidd + 1;
                        serino = Convert.ToString(gettidd + 1);
                    }
                }
            }
            catch
            {
                ViewState["maxtid"] = 1;
                serino = "1";
            }
            string getdattt = Dsrr[0].ToString();
            SqlCommand pmd = new SqlCommand("SELECT (   AgentId +'-' + Name + '-' + Plant_Name) as Agentname,UpdateTime,CONVERT(VARCHAR,Billfrmdate,101) AS Billfrmdate, CONVERT(VARCHAR,Billtodate,101) AS Billtodate,PlantCode,AgentId,NetAmount,Plant_Name  FROM (SELECT AgentId,Name,UpdateTime,NetAmount,Plant_Code AS PlantCode,Billfrmdate,Billtodate   FROM (Select convert(varchar,Agent_Id) as AgentId,NetAmount,convert(varchar,Agent_Name) as Agent_Name,convert(varchar,Added_Date,101) as UpdateTime,Plant_Code,convert(varchar,Billfrmdate,103) as Billfrmdate,convert(varchar,Billtodate,103) as Billtodate from BankPaymentllotment    where Plant_code=@plantcode  and  Billfrmdate='" + FDATE + "' and Billtodate='" + TODATE + "'  and  Added_Date ='" + getdattt + "'  AND TallyStatus IS  NULL   ) AS FF  LEFT JOIN (SELECT Agent_id,Agent_name AS Name,Plant_code AS PCCODE  FROM  Paymentdata WHERE  Plant_code=@plantcode  and frm_date='" + FDATE + "'  and to_date='" + TODATE + "' GROUP BY Agent_id,Agent_name,Plant_code ) AS PAYDATA  ON  FF.AgentId=PAYDATA.Agent_id) AS GETSS LEFT JOIN (Select Plant_Code as pmplantcode,Plant_Name   from Plant_Master  where Plant_code=@plantcode    group by     Plant_Code,Plant_Name) AS RIGHTS ON GETSS.PlantCode=RIGHTS.pmplantcode    order by rand(AgentId) asc");
            pmd.Parameters.Add("@plantcode", plantcode);
            DataTable dugs = pdm.SelectQuery(pmd).Tables[0];
            foreach (DataRow dtp in dugs.Rows)
            {
                se = serino;
                aname = dtp[0].ToString();
                uptime = dtp[1].ToString();
                fdate = dtp[2].ToString();
                todate = dtp[3].ToString();
                pcode2 = dtp[4].ToString();
                agent = dtp[5].ToString();
                string amount = dtp[6].ToString();
                totamt = totamt + Convert.ToDouble(amount);
                ppname = dtp[7].ToString();
                narration = " Being the Billperiod Of  " + ppname + " From:" + fdate + "To:" + todate;
                INSERT = "";
                DateTime NEWTIME = new DateTime();
                NEWTIME = System.DateTime.Now;
                SqlCommand cmd1 = new SqlCommand("INSERT INTO TallyloanEntryJvpassAgentWsie (JVNO,jvDate,Legdername,Amount,Frm_date,To_date,plant_code,narration,entrydate,agent_id) VALUES ('" + se + "','" + uptime + "','" + aname + "','" + amount + "','" + FDATE + "','" + TODATE + "','" + plantcode + "','" + narration + "','" + NEWTIME + "','" + agent + "')");
                pdm.insert(cmd1);
                SqlCommand cmd2 = new SqlCommand("Update  BankPaymentllotment set TallyStatus='1'  where     plant_code=@plantcode   and Billfrmdate='" + FDATE + "'   and Billtodate='" + TODATE + "'  and TallyStatus is null and Agent_id='" + agent + "'");
                cmd2.Parameters.Add("@plantcode", plantcode);
                cmd2.Parameters.Add("@billdate", billdate);
                pdm.Update(cmd2);
                CHEKKVAL = 1;

            }
            if (CHEKKVAL == 1)
            {
                string Uid = context.Session["UserSno"].ToString();
                SqlCommand cmd3 = new SqlCommand("INSERT INTO TallyloanEntryJvpassAgentWsie (JVNO,jvDate,Legdername,Amount,Frm_date,To_date,plant_code,narration,insertedby,entrydate) VALUES ('" + se + "','" + uptime + "','SVDS.P.LTD.PUNABAKA PLANT','" + -(totamt) + "','" + FDATE + "','" + TODATE + "','" + plantcode + "','" + narration + "','" + Uid + "','" + System.DateTime.Now + "')");
                pdm.insert(cmd3);
                totamt = 0;
            }

        }
        string billdt = context.Request["billdate"];
        string vdate = context.Request["vdate"].ToString();
        string[] p1 = billdt.Split('/', '-');
        getvald = p1[0];
        getvalm = p1[1];
        getvaly = p1[2];
        getvaldd = p1[3];
        getvalmm = p1[4];
        getvalyy = p1[5];
        FDATE = getvalm + "/" + getvald + "/" + getvaly;
        TODATE = getvalmm + "/" + getvaldd + "/" + getvalyy;
        List<procurement> plantlist = new List<procurement>();
        SqlCommand CMt = new SqlCommand("Select  JVNO,REPLACE(CONVERT(VARCHAR(9), jvDate, 6), ' ', '-') AS [VchDate],Legdername,Amount,Narration   from TallyloanEntryJvpassAgentWsie where plant_code=@plantcode and frm_date='" + FDATE + "'   and to_date='" + TODATE + "' and jvDate=@vdate");
        CMt.Parameters.Add("@plantcode", plantcode);
        CMt.Parameters.Add("@vdate", vdate);
        DataTable report = pdm.SelectQuery(CMt).Tables[0];
        if (report.Rows.Count > 0)
        {

            foreach (DataRow dr in report.Rows)
            {
                procurement getloanentrydetails = new procurement();
                getloanentrydetails.jvno = dr["JVNO"].ToString();
                getloanentrydetails.vchdate = dr["VchDate"].ToString();
                getloanentrydetails.HeadOfAccount = dr["Legdername"].ToString();
                vdm = new VehicleDBMgr();
                string headofaccount = dr["Legdername"].ToString();
                CMt = new SqlCommand("select sno,accountname from headofaccounts_master where accountname=@headofaccount");
                CMt.Parameters.Add("headofaccount", headofaccount);
                DataTable dtledgerid = vdm.SelectQuery(CMt).Tables[0];
                if (dtledgerid.Rows.Count > 0)
                {
                    string ledgerid = dtledgerid.Rows[0]["sno"].ToString();
                    getloanentrydetails.ledgerid = ledgerid;
                }
                getloanentrydetails.Amount = dr["Amount"].ToString();
                getloanentrydetails.narration = dr["Narration"].ToString();
                plantlist.Add(getloanentrydetails);
            }
            string response = GetJson(plantlist);
            context.Response.Write(response);
        }
        else
        {
            string response = "No Data Found";
            context.Response.Write(response);
        }
    }

    public void view_jvagent_details(HttpContext context)
    {
        ProcureDBmanager pdm = new ProcureDBmanager();
        SqlConnection con = new SqlConnection();
        DbHelper DB = new DbHelper();
        string frmdate;
        string Todate;
        string getvald;
        string getvalm;
        string getvaly;
        string getvaldd;
        string getvalmm;
        string getvalyy;
        string FDATE;
        string TODATE;
        string month;
        int Checkstatus;
        string billdate = context.Request["billdate"].ToString();
        string plantcode = context.Request["plantcode"].ToString();
        string vdate = context.Request["vdate"].ToString();
        string[] p = billdate.Split('/', '-');
        getvald = p[0];
        getvalm = p[1];
        getvaly = p[2];
        getvaldd = p[3];
        getvalmm = p[4];
        getvalyy = p[5];
        FDATE = getvalm + "/" + getvald + "/" + getvaly;
        TODATE = getvalmm + "/" + getvaldd + "/" + getvalyy;
        con = DB.GetConnection();
        string GETTS = "";
        GETTS = " sELECT   ('BANKPAY' +'_' + JVNO) AS JVNO,VchDate,Legdername,Amount,Narration   FROM (SELECT CONVERT(VARCHAR,JVNO) AS JVNO,REPLACE(CONVERT(VARCHAR(9), JvDate, 6), ' ', '-') AS [VchDate],Legdername,Amount,Narration   FROM      TallyloanEntryJvpassAgentWsie   where plant_code=@plantcode and Frm_Date='" + FDATE + "'    and To_date='" + TODATE + "' and jvDate=@vdate and UpdateStatus is null) AS HH";
        SqlCommand cmd = new SqlCommand(GETTS, con);
        cmd.Parameters.Add("@plantcode", plantcode);
        cmd.Parameters.Add("@vdate",vdate);
        SqlDataAdapter abc = new SqlDataAdapter(cmd);
        DataTable views = new DataTable();
        List<procurement> plantlist = new List<procurement>();
        views.Rows.Clear();
        abc.Fill(views);
        if (views.Rows.Count > 0)
        {
            foreach (DataRow dr in views.Rows)
            {
                procurement getloanentrydetails = new procurement();
                getloanentrydetails.jvno = dr["JVNO"].ToString();
                getloanentrydetails.vchdate = dr["VchDate"].ToString();
                getloanentrydetails.ledgername = dr["Legdername"].ToString();
                getloanentrydetails.amount = dr["Amount"].ToString();
                getloanentrydetails.narration = dr["Narration"].ToString();
                plantlist.Add(getloanentrydetails);
            }
            string response = GetJson(plantlist);
            context.Response.Write(response);
        }
        else
        {
            string response = "No Records";
            context.Response.Write(response);
        }
    }

    private void get_jv_details(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            string date = context.Request["date"].ToString();
            string branch = context.Request["branch"].ToString();
            DateTime jvdate = Convert.ToDateTime(date);
            cmd = new SqlCommand("SELECT journel_entry.sno, journel_entry.branchid,journel_entry.jvdate, journel_entry.amount, journel_entry.doe, journel_entry.remarks, journel_entry.status, employe_login.name AS empname, branchmaster.branchname FROM journel_entry INNER JOIN employe_login ON journel_entry.createdby = employe_login.sno INNER JOIN branchmaster ON journel_entry.branchid = branchmaster.branchid where (journel_entry.jvdate BETWEEN @d1 AND @d2) AND (journel_entry.branchid = @BranchID) ORDER BY journel_entry.doe");
            cmd.Parameters.Add("@d1", GetLowDate(jvdate));
            cmd.Parameters.Add("@d2", GetHighDate(jvdate));
            cmd.Parameters.Add("@BranchID", branch);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<paymentdetails> accountdetailslist = new List<paymentdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                paymentdetails getaccountdetails = new paymentdetails();
                getaccountdetails.totalamount = dr["amount"].ToString();
                getaccountdetails.branchid = dr["branchid"].ToString();
                getaccountdetails.branchname = dr["branchname"].ToString();
                getaccountdetails.doe = dr["doe"].ToString();
                getaccountdetails.jvdate = dr["jvdate"].ToString();
                getaccountdetails.sno = dr["sno"].ToString();
                getaccountdetails.Remarks = dr["remarks"].ToString();
                getaccountdetails.approvedby = dr["empname"].ToString();
                accountdetailslist.Add(getaccountdetails);
            }
            string response = GetJson(accountdetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_bank_Document_Info(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            if (context.Request.Files.Count > 0)
            {
                string bankid = context.Request["bankid"];
                string doe = context.Request["doe"];

                string branchid = context.Session["FA_branchid"].ToString();
                string entryby = context.Session["UserSno"].ToString();
                HttpFileCollection files = context.Request.Files;
                DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    string upload_filename = "";
                    string[] extension = file.FileName.Split('.');
                    if (extension[1] == "pdf")
                    {
                        upload_filename = "bankstatement_" + bankid + "_branchid_" + branchid + ".pdf";// +extension[extension.Length - 1];
                    }
                    else
                    {
                        upload_filename = "bankstatement_" + bankid + "_branchid_" + branchid + ".jpeg";
                    }

                    if (UploadpicToFTP(file, upload_filename))
                    {
                        cmd = new SqlCommand("SELECT MAX(sno) AS sno from accountnowiseclosingdetails WHERE accountid=@aid");
                        cmd.Parameters.Add("@aid", bankid);
                        DataTable dtcl = vdm.SelectQuery(cmd).Tables[0];
                        string refsno = dtcl.Rows[0]["sno"].ToString();
                        cmd = new SqlCommand("UPDATE accountnowiseclosingdetails SET path=@documentpath where sno=@refno");
                        cmd.Parameters.Add("@refno", refsno);
                        cmd.Parameters.Add("@documentpath", upload_filename);
                        vdm.Update(cmd);
                    }
                }
                //context.Response.ContentType = "text/plain";
                string response = GetJson("File Uploaded Successfully!");
                context.Response.Write(response);
            }
            //}

        }
        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }

    public class bank_documents
    {
        public string sno { get; set; }
        public string documenttype { get; set; }
        public string path { get; set; }
        public string bankid { get; set; }
        public string ftplocation { get; set; }
    }

    private void getbank_Uploaded_Documents(HttpContext context)
    {
        try
        {
            vdm = new VehicleDBMgr();
            string branchid = context.Session["FA_branchid"].ToString();
            string bankid = context.Request["bankid"];
            string doe = context.Request["doe"];
            DateTime fromdate = DateTime.Now;
            string[] fromdatestrig = doe.Split(' ');
            if (fromdatestrig.Length > 1)
            {
                if (fromdatestrig[0].Split('-').Length > 0)
                {
                    string[] dates = fromdatestrig[0].Split('-');
                    string[] times = fromdatestrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            //cmd = new SqlCommand("SELECT stocktransfersubdetails.productid, stocktransfersubdetails.quantity, stocktransfersubdetails.remarks, stocktransfersubdetails.taxtype, stocktransfersubdetails.taxvalue, stocktransfersubdetails.price, productmaster.productname FROM stocktransfersubdetails INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid WHERE (stocktransfersubdetails.quantity > 0) AND (stocktransfersubdetails.stock_refno = @sno)");
            cmd = new SqlCommand("SELECT sno, path, accountid from accountnowiseclosingdetails  WHERE accountid=@bankid and doe BETWEEN @d1 and @d2");
            cmd.Parameters.Add("@bankid", bankid);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(fromdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<bank_documents> doc_Details = new List<bank_documents>();
            foreach (DataRow dr in routes.Rows)
            {
                bank_documents get_details = new bank_documents();
                get_details.sno = dr["sno"].ToString();
                get_details.path = dr["path"].ToString();
                get_details.bankid = dr["accountid"].ToString();
                get_details.ftplocation = "ftp://223.196.32.30:21/FA/";
                doc_Details.Add(get_details);
            }
            string response = GetJson(doc_Details);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private bool UploadpicToFTP(HttpPostedFile fileToUpload, string filename)
    {
        // Get the object used to communicate with the server.
        string uploadUrl = "ftp://223.196.32.30/FA/";
        // string fileName = fileToUpload.FileName;
        try
        {
            FtpWebRequest del_request = (FtpWebRequest)WebRequest.Create(uploadUrl + @"/" + filename);
            del_request.Credentials = new NetworkCredential("ftpvys", "Vyshnavi123");
            del_request.Method = WebRequestMethods.Ftp.DeleteFile;
            FtpWebResponse delete_response = (FtpWebResponse)del_request.GetResponse();
            Console.WriteLine("Delete status: {0}", delete_response.StatusDescription);
            delete_response.Close();
        }
        catch
        {
        }
        FtpWebRequest request = (FtpWebRequest)WebRequest.Create(uploadUrl + @"/" + filename);
        request.Credentials = new NetworkCredential("ftpvys", "Vyshnavi123");
        request.Method = WebRequestMethods.Ftp.UploadFile;
        byte[] fileContents = null;
        using (var binaryReader = new BinaryReader(fileToUpload.InputStream))
        {
            fileContents = binaryReader.ReadBytes(fileToUpload.ContentLength);
        }
        request.ContentLength = fileContents.Length;
        Stream requestStream = request.GetRequestStream();
        requestStream.Write(fileContents, 0, fileContents.Length);
        requestStream.Close();
        FtpWebResponse response = (FtpWebResponse)request.GetResponse();
        response.Close();
        return true;
    }
    public class employeedetails
    {
        public string sno { get; set; }
        public string employeename { get; set; }
        public string logintime { get; set; }
        public string logouttime { get; set; }
        public string ipaddress { get; set; }
        public string devicetype { get; set; }
        public string leveltype { get; set; }
        public string loginstatus { get; set; }
        public string sessiontimeout { get; set; }

        public string indate { get; set; }
        public string intime { get; set; }
        public string outdate { get; set; }
        public string outtime { get; set; }
        public string timeinterval { get; set; }
    }
    private void get_employee_detail_login(HttpContext context)
    {
        vdm = new VehicleDBMgr();
        string BranchID = context.Session["FA_branchid"].ToString();
        cmd = new SqlCommand("SELECT   sno, name, username, passward, branchid, doe, createdby, deptid, designation, leveltype, hempid, loginstatus FROM  employe_login WHERE (branchid = @branchid)");
        cmd.Parameters.Add("@branchid", BranchID);
        DataTable dtemployee = vdm.SelectQuery(cmd).Tables[0];
        List<employeedetails> emloyeeedetalis = new List<employeedetails>();
        if (dtemployee.Rows.Count > 0)
        {
            foreach (DataRow dr in dtemployee.Rows)
            {
                employeedetails details = new employeedetails();
                details.sno = dr["sno"].ToString();
                details.employeename = dr["name"].ToString();
                details.leveltype = dr["leveltype"].ToString();
                string status = dr["loginstatus"].ToString();
                if (status == "False")
                {
                    status = "InActive";
                }
                if (status == "True")
                {
                    status = "Active";
                }
                details.loginstatus = status;
                emloyeeedetalis.Add(details);
            }
            string response = GetJson(emloyeeedetalis);
            context.Response.Write(response);
        }
    }
    private void btn_getlogininfoemployee_details(HttpContext context)
    {
        string BranchID = context.Session["FA_branchid"].ToString();
        string employeeid = context.Request["employeeid"];
        string fromdate = context.Request["fromdate"];
        string todate = context.Request["todate"];
        string date = context.Request["date"];
        DateTime dtfromdate = Convert.ToDateTime(fromdate);
        DateTime dttodate = Convert.ToDateTime(todate);
        DateTime dtdate = Convert.ToDateTime(date);
        if (employeeid == "" || employeeid == null)
        {
            //cmd = new SqlCommand("SELECT  employe_login.sno, employe_login.name, employe_login.branchid, logininfo.logintime,logininfo.logouttime, logininfo.ipaddress, logininfo.devicetype, employe_login.loginstatus FROM  employe_login INNER JOIN logininfo ON employe_login.sno = logininfo.userid WHERE  (employe_login.branchid = @branchid) AND (logininfo.logintime BETWEEN @d1 AND @d2)");
            cmd = new SqlCommand("SELECT  employe_login.sno, employe_login.name, employe_login.branchid, logininfo.logintime,logininfo.logouttime, CONVERT(VARCHAR(11), logininfo.Logintime, 106) AS indate,CONVERT(VARCHAR(11), logininfo.Logintime, 108) AS intime, CONVERT(VARCHAR(11), logininfo.LogoutTime, 106) AS outdate, CONVERT(VARCHAR(11), logininfo.LogoutTime, 108) AS outtime, logininfo.ipaddress, logininfo.devicetype, employe_login.loginstatus FROM  employe_login INNER JOIN logininfo ON employe_login.sno = logininfo.userid WHERE  (employe_login.branchid = @branchid) AND (logininfo.logintime BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@d1", GetLowDate(dtdate));
            cmd.Parameters.Add("@d2", GetHighDate(dtdate));
            cmd.Parameters.Add("@branchid", BranchID);
        }
        else
        {
            //cmd = new SqlCommand("SELECT  employe_login.sno, employe_login.name, employe_login.branchid, logininfo.logintime, logininfo.logouttime, logininfo.ipaddress, logininfo.devicetype, employe_login.loginstatus FROM  employe_login INNER JOIN logininfo ON employe_login.sno = logininfo.userid WHERE  (employe_login.branchid = @branchid) AND (logininfo.logintime BETWEEN @d1 AND @d2) AND (logininfo.userid = @sno)");
            cmd = new SqlCommand("SELECT  employe_login.sno, employe_login.name, employe_login.branchid, logininfo.logintime,logininfo.logouttime, CONVERT(VARCHAR(11), logininfo.Logintime, 106) AS indate,CONVERT(VARCHAR(11), logininfo.Logintime, 108) AS intime, CONVERT(VARCHAR(11), logininfo.LogoutTime, 106) AS outdate, CONVERT(VARCHAR(11), logininfo.LogoutTime, 108) AS outtime, logininfo.ipaddress, logininfo.devicetype, employe_login.loginstatus FROM  employe_login INNER JOIN logininfo ON employe_login.sno = logininfo.userid WHERE  (employe_login.branchid = @branchid) AND (logininfo.logintime BETWEEN @d1 AND @d2) AND (logininfo.userid = @sno)");
            cmd.Parameters.Add("@sno", employeeid);
            cmd.Parameters.Add("@d1", GetLowDate(dtfromdate));
            cmd.Parameters.Add("@d2", GetHighDate(dttodate));
            cmd.Parameters.Add("@branchid", BranchID);
        }
        DataTable dtloginfo = vdm.SelectQuery(cmd).Tables[0];
        List<employeedetails> emloyeeedetalis = new List<employeedetails>();
        if (dtloginfo.Rows.Count > 0)
        {
            foreach (DataRow dr in dtloginfo.Rows)
            {
                string logouttimings = dr["logouttime"].ToString();
                if (logouttimings != "")
                {
                    employeedetails details = new employeedetails();
                    details.sno = dr["sno"].ToString();
                    details.employeename = dr["name"].ToString();
                    details.logintime = dr["logintime"].ToString();
                    details.logouttime = dr["logouttime"].ToString();
                    //details.sessiontimeout = dr["SessionPeriod"].ToString();
                    details.ipaddress = dr["ipaddress"].ToString();
                    details.devicetype = dr["devicetype"].ToString();

                    details.indate = dr["indate"].ToString();
                    details.intime = dr["intime"].ToString();
                    details.outdate = dr["outdate"].ToString();
                    details.outtime = dr["outtime"].ToString();
                    string Logintime = dr["Logintime"].ToString();
                    string LogoutTime = dr["LogoutTime"].ToString();
                    string intime = dr["intime"].ToString();
                    string outtime = dr["outtime"].ToString();
                    TimeSpan difference = DateTime.Parse(outtime) - DateTime.Parse(intime);
                    double hourDiff = difference.TotalHours;
                    double minutes = difference.TotalMinutes;
                    details.timeinterval = Math.Round(hourDiff, 2).ToString();
                    emloyeeedetalis.Add(details);

                }
            }
            string response = GetJson(emloyeeedetalis);
            context.Response.Write(response);
        }
    }
}