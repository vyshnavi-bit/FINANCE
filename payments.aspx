<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="payments.aspx.cs" Inherits="payments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_bankaccount_details();
            get_headofaccount_details();
            get_employee_details();
            get_payment_details();
            get_Branch_details();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_date').val(today);
        });
        function callHandler(d, s, e) {
            $.ajax({
                url: 'DairyFleet.axd',
                data: d,
                type: 'GET',
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: true,
                success: s,
                Error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = encodeURIComponent(d);
            $.ajax({
                type: "GET",
                url: " DairyFleet.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function CallHandlerUsingJson_POST(d, s, e) {
            d = JSON.stringify(d);
            d = encodeURIComponent(d);
            $.ajax({
                type: "POST",
                url: "DairyFleet.axd",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        fillsubbranchdetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function filldetails(msg) {
            var data = document.getElementById('selct_branch');
            var length = data.options.length;
            document.getElementById('selct_branch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch Name";
            opt.value = "Select Branch Name";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }
        function fillsubbranchdetails(msg) {
            var data = document.getElementById('slct_subbranch');
            var length = data.options.length;
            document.getElementById('slct_subbranch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch Name";
            opt.value = "Select Branch Name";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }
       
        function save_payment_click() {
            var name = document.getElementById("txt_name").value;
            var paymentdate = document.getElementById("txt_date").value;
            var accountno = document.getElementById("ddlaccountno").value;
            var totalamount = document.getElementById("txt_totalamount").value;
            var btnval = document.getElementById("btn_save").value;
            var Remarks = document.getElementById('txtRemarks').value;
            var ApprovedBy = document.getElementById("ddlapprovedby").value;
            var branchname = document.getElementById("selct_branch").value;
            var sno = document.getElementById("txtsno").value;
            var sapimport = document.getElementById("slct_sapimport").value;
            var subbranch = document.getElementById("slct_subbranch").value;
            var totalamountsub = document.getElementById("txt_totalamt_sub").value;
            if (name == "") {
                alert("Please enter pay to");
                return false;
            }
            if (paymentdate == "") {
                alert("Please enter pay to");
                return false;
            }
            if (accountno == "") {
                alert("Please enter pay to");
                return false;
            }
            if (Remarks == "") {
                alert("Please enter remarks");
                return false;
            }
            if (ApprovedBy == "") {
                alert("Please enter pay to");
                return false;
            }
            if (sapimport == "") {
                alert("Please Select SAP Import");
                return false;
            }
            var rows = $("#tableCashFormdetails tr:gt(0)");
            var paymententry = new Array();
            $(rows).each(function (i, obj) {
                paymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), amount: $(this).find('#txtamount').text() });
            });
            if (paymententry.length == "0") {
                alert("Please enter head of account details");
                return false;
            }
            var subpaymententry = new Array();
            var subrows = $("#subtableetails tr:gt(0)"); 
            $(subrows).each(function (i, obj) {
                subpaymententry.push({ SNo: $(this).find('#hdnHeadSno').val(),  amount: $(this).find('#txtamount').text() });
            });
            var Data = { 'op': 'save_paymententrys_click', 'subpaymententry': subpaymententry, 'Remarks': Remarks, 'paymentdate': paymentdate, 'ApprovedBy': ApprovedBy, 'btnval': btnval, 'name': name, 'accountno': accountno, 'totalamount': totalamount, 'sno': sno, 'paymententry': paymententry, 'branchname': branchname, 'sapimport': sapimport, 'subbranch': subbranch, 'totalamountsub': totalamountsub };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_payment_details();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson_POST(Data, s, e);
        }

        function get_bankaccount_details() {
            var data = { 'op': 'get_bankaccount_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillaccountdetail(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillaccountdetail(msg) {
            var data = document.getElementById('ddlaccountno');
            var length = data.options.length;
            document.getElementById('ddlaccountno').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select AccountNumber";
            opt.value = "Select AccountNumber";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].AccountNumber != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].AccountNumber;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        var AccountNameDetails = [];
        function get_headofaccount_details() {
            var data = { 'op': 'get_headofaccount_details' };
            var s = function (msg) {
                if (msg) {
                    AccountNameDetails = msg;
                    var AccountNameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var AccountName = msg[i].AccountName;
                        AccountNameList.push(AccountName);
                    }
                    $('#ddlheadaccounts').autocomplete({
                        source: AccountNameList,
                        change: AccountNamechange,
                        autoFocus: true
                    });
                    $('#ddl_subheadaccounts').autocomplete({
                        source: AccountNameList,
                        change: SubAccountNamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function SubAccountNamechange() {
            var AccountName = document.getElementById('ddl_subheadaccounts').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_sub_head').value = AccountNameDetails[i].sno;
                }
            }
        }
        function AccountNamechange() {
            var AccountName = document.getElementById('ddlheadaccounts').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_head').value = AccountNameDetails[i].sno;
                }
            }
        }
        function get_employee_details() {
            var data = { 'op': 'get_employee_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillapprovedbydetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillapprovedbydetails(msg) {
            var data = document.getElementById('ddlapprovedby');
            var length = data.options.length;
            document.getElementById('ddlapprovedby').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Approvedby";
            opt.value = "Select Approvedby";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].username != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].username;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function forclearall() {
            document.getElementById('txt_name').value = "";
            document.getElementById('ddlaccountno').selectedIndex = 0;
            document.getElementById('txtamount').value = "";
            document.getElementById('txt_totalamount').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('ddlapprovedby').selectedIndex = 0;
            document.getElementById('txt_subamount').value = "";
            document.getElementById('btn_save').value = "Save";
            Collectionform = [];
            var results = '<div  style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < Collectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
            SubCollectionform = [];
            var results = '<div  style="overflow:auto;"><table id="subtableetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < SubCollectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + SubCollectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + SubCollectionform[i].Amount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + SubCollectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + SubCollectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="subaccountrowdeleteclick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#div_subHeadAcount").html(results);
        }
        var Collectionform = [];
        function BtnAddClick() {
            $("#divHeadAcount").css("display", "block");
            var accountno = document.getElementById("ddlaccountno").value;
            if (accountno == "Select AccountNumber" || accountno == "") {
                alert("Select AccountNumber");
                return false;
            }
            var HeadSno = document.getElementById("txt_head").value;
            var HeadOfAccount = document.getElementById("ddlheadaccounts").value;
            var Checkexist = false;
            $('.AccountClass').each(function (i, obj) {
                var IName = $(this).text();
                if (IName == HeadOfAccount) {
                    alert("Account Already Added");
                    Checkexist = true;
                }
            });
            if (Checkexist == true) {
                return;
            }
            var Amount = document.getElementById("txtamount").value;
            if (Amount == "") {
                alert("Enter Amount");
                return false;
            }
            else {
//                for (i = 0; i < jvimport.length; i++) {
//                    HeadOfAccount = jvimport[i].HeadOfAccount;
//                    Amount = jvimport[i].Amount;
                    Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });
//                }
                var results = '<div  style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
                results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < Collectionform.length; i++) {
                    results += '<tr><td></td>';
                    results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
                    results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
                    results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                    results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
                    results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
                }
                results += '</table></div>';
                $("#divHeadAcount").html(results);
                var TotRate = 0.0;
                $('.AmountClass').each(function (i, obj) {
                    if ($(this).text() == "") {
                    }
                    else {
                        TotRate += parseFloat($(this).text());
                    }
                });
                TotRate = parseFloat(TotRate).toFixed(2);
                document.getElementById("txt_totalamount").value = TotRate;
            }
        }
        var SubCollectionform = [];
        function Btn_subAddClick() {
            $("#div_subHeadAcount").css("display", "block");
            var accountno = document.getElementById("ddl_subheadaccounts").value;
            if (accountno == "Select AccountNumber" || accountno == "") {
                alert("Select AccountNumber");
                return false;
            }
            var HeadSno = document.getElementById("txt_sub_head").value;
            var HeadOfAccount = document.getElementById("ddl_subheadaccounts").value;
            var Checkexist = false;
            $('.subAccountClass').each(function (i, obj) {
                var IName = $(this).text();
                if (IName == HeadOfAccount) {
                    alert("Account Already Added");
                    Checkexist = true;
                }
            });
            if (Checkexist == true) {
                return;
            }
            var Amount = document.getElementById("txt_subamount").value;
            if (Amount == "") {
                alert("Enter Amount");
                return false;
            }
            else {
                SubCollectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });
                var results = '<div  style="overflow:auto;"><table id="subtableetails" class="responsive-table">';
                results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < SubCollectionform.length; i++) {
                    results += '<tr><td></td>';
                    results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="subAccountClass"><b>' + SubCollectionform[i].HeadOfAccount + '</b></span></td>';
                    results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="subAmountClass"><b>' + SubCollectionform[i].Amount + '</b></span></td>';
                    results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + SubCollectionform[i].HeadSno + '" /></td>';
                    results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + SubCollectionform[i].subsno + '"/></td>';
                    results += '<td  class="6"> <img src="Images/Odclose.png" onclick="subaccountrowdeleteclick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
                }
                results += '</table></div>';
                $("#div_subHeadAcount").html(results);
                 var TotRate = 0.0;
                $('.subAmountClass').each(function (i, obj) {
                    if ($(this).text() == "") {
                    }
                    else {
                        TotRate += parseFloat($(this).text());
                    }
                });
                TotRate = parseFloat(TotRate).toFixed(2);
                document.getElementById("txt_totalamt_sub").value = TotRate;
            }
        }

        function get_payment_details() {
            var data = { 'op': 'get_payment_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpaymentdetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillpaymentdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col"></th><th scope="col">Account Number</th><th scope="col">Account Type</th><th scope="col">TotalAmount</th><th scope="col">Name</th><th scope="col">Date</th><th scope="col">Branch</th><th scope="col">SubBranch</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getcoln(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td><input id="btn_poplate" type="button"  onclick="getprintreceipt(this)" name="submit" class="btn btn-primary" value="Print" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].accountno + '</th>';
                results += '<td class="2">' + msg[i].accounttype + '</td>';
                results += '<td  class="3">' + msg[i].totalamount + '</td>';
                results += '<td  class="4">' + msg[i].name + '</td>';
               // results += '<td class="5">' + msg[i].doe + '</td>';
                results += '<td class="5">' + msg[i].paymentdate + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].approvedby + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].Remarks + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].accountid + '</td>';
                results += '<td  class="10">' + msg[i].branch + '</td>';
                results += '<td  class="11">' + msg[i].subbranch + '</td>';
                results += '<td  style="display:none" class="12">' + msg[i].sapimport + '</td>';
                results += '<td style="display:none" class="13">' + msg[i].branchid + '</td>';
                results += '<td style="display:none" class="14">' + msg[i].subbranchid + '</td>';
                results += '<td style="display:none" class="15">' + msg[i].totalsubamount + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_data").html(results);
        }
        function getprintreceipt(thisid) {
            var sno = $(thisid).parent().parent().children('.6').html();
            var data = { 'op': 'btnPaymentPrintClick', 'voucherno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
            window.location = "Print_payment.aspx";
        }
        function getcoln(thisid) {
            var sno = $(thisid).parent().parent().children('.6').html();
            var name = $(thisid).parent().parent().children('.4').html();
            var paymentdate = $(thisid).parent().parent().children('.5').html();
            var totalamount = $(thisid).parent().parent().children('.3').html();
            var accountno = $(thisid).parent().parent().children('.7').html();
            var remarks = $(thisid).parent().parent().children('.8').html();
            var approved = $(thisid).parent().parent().children('.9').html();
            var branch = $(thisid).parent().parent().children('.10').html();
            var subbranch = $(thisid).parent().parent().children('.11').html();
            var sapimport = $(thisid).parent().parent().children('.12').html();
            var branchid = $(thisid).parent().parent().children('.13').html();
            var subbranchid = $(thisid).parent().parent().children('.14').html();
            var totalsubamount = $(thisid).parent().parent().children('.15').html();

            document.getElementById('txtsno').value = sno;
            document.getElementById('txt_name').value = name;
            document.getElementById('txt_date').value = paymentdate;
            document.getElementById('ddlaccountno').selectedIndex = accountno;
            document.getElementById('txt_totalamount').value = totalamount;
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('ddlapprovedby').selectedIndex = approved;
            document.getElementById('slct_sapimport').value = sapimport;
            document.getElementById('txt_totalamt_sub').value = totalsubamount;
            document.getElementById('selct_branch').value = branchid;
            document.getElementById('slct_subbranch').value = subbranchid;
            document.getElementById('btn_save').value = "Modify";
            get_paymentsubdetails(sno);
            get_subaccount_paymentdetails(sno);
        }
        function get_subaccount_paymentdetails(sno) {
            var data = { 'op': 'get_subaccount_paymentdetails', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsubaccountpaymentedetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillsubaccountpaymentedetails(msg) {
            $("#div_subHeadAcount").css("display", "block");
            SubCollectionform = [];
            for (var i = 0; i < msg.length; i++) {
                var subno = msg[i].sno;
                var HeadSno = msg[i].headid;
                var HeadOfAccount = msg[i].accountno;
                var Amount = msg[i].totalamount;
                SubCollectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, subsno: subno });
            }
            var results = '<div  style="overflow:auto;"><table id="subtableetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < SubCollectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="subAccountClass"><b>' + SubCollectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="subAmountClass"><b>' + SubCollectionform[i].Amount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + SubCollectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + SubCollectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="subaccountrowdeleteclick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#div_subHeadAcount").html(results);
        }
        function get_paymentsubdetails(sno) {
            var data = { 'op': 'get_paymentsubdetails', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpaymenteditdetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillpaymenteditdetails(msg) {
            $("#divHeadAcount").css("display", "block");
            Collectionform = [];
            for (var i = 0; i < msg.length; i++) {
                var subno = msg[i].sno;
                var HeadSno = msg[i].headid;
                var HeadOfAccount = msg[i].accountno;
                var Amount = msg[i].totalamount;
                Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, subsno: subno });
            }
            var results = '<div  style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < Collectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
        }
        function subaccountrowdeleteclick(Account) {
            SubCollectionform = [];
            var HeadOfAccount = "";
            var HeadSno = "";
            var Account = $(Account).closest("tr").find("#txtAccount").text();
            var Amount = "";
            var rows = $("#subtableetails tr:gt(0)");
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtamount').text() != "") {
                    HeadOfAccount = $(this).find('#txtAccount').text();
                    HeadSno = $(this).find('#hdnHeadSno').val();
                    Amount = $(this).find('#txtamount').text();
                    if (Account == HeadOfAccount) {
                    }
                    else {
                        SubCollectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });
                    }
                }
            });
            var results = '<div style="overflow:auto;"><table id="subtableetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < SubCollectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="subAccountClass"><b>' + SubCollectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="SubAmountClass"><b>' + SubCollectionform[i].Amount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + SubCollectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + SubCollectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="subaccountrowdeleteclick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#div_subHeadAcount").html(results);
            var TotRate = 0.0;
            $('.SubAmountClass').each(function (i, obj) {
                if ($(this).text() == "") {
                }
                else {
                    TotRate += parseFloat($(this).text());
                }
            });
            TotRate = parseFloat(TotRate).toFixed(2);
            document.getElementById("txt_totalamt_sub").value = TotRate;
        }
        function RowDeletingClick(Account) {
            Collectionform = [];
            var HeadOfAccount = "";
            var HeadSno = "";
            var Account = $(Account).closest("tr").find("#txtAccount").text();
            var Amount = "";
            var rows = $("#tableCashFormdetails tr:gt(0)");
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtamount').text() != "") {
                    HeadOfAccount = $(this).find('#txtAccount').text();
                    HeadSno = $(this).find('#hdnHeadSno').val();
                    Amount = $(this).find('#txtamount').text();
                    if (Account == HeadOfAccount) {
                    }
                    else {
                        Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });
                    }
                }
            });
            var results = '<div style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < Collectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
            var TotRate = 0.0;
            $('.AmountClass').each(function (i, obj) {
                if ($(this).text() == "") {
                }
                else {
                    TotRate += parseFloat($(this).text());
                }
            });
            TotRate = parseFloat(TotRate).toFixed(2);
            document.getElementById("txt_totalamount").value = TotRate;
        }
        function BtnClickHere() {
            Collectionform = [];
            $('#divMainAddNewRow').css('display', 'block');
            get_plant_names();
        }
        function BtnsubClick() {
            $('#divSubAddNewRow').css('display', 'block');
            get_subplant_names();
            SubCollectionform = [];
        }
        
      function CloseClick() {
          $('#divMainAddNewRow').css('display', 'none');
      }
      function ClosesubClick() {
          $('#divSubAddNewRow').css('display', 'none');
      }
      function get_subplant_names() {
          var data = { 'op': 'get_plant_names' };
          var s = function (msg) {
              if (msg) {
                  if (msg.length > 0) {
                      fillsubplantdetails(msg);
                  }
              }
              else {
              }
          };
          var e = function (x, h, e) {
          };
          $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
          callHandler(data, s, e);
      }
      function fillsubplantdetails(msg) {
          var data = document.getElementById('slct_subplant');
          var length = data.options.length;
          document.getElementById('slct_subplant').options.length = null;
          var opt = document.createElement('option');
          opt.innerHTML = "Select Plant Name";
          opt.value = "Select Plant Name";
          opt.setAttribute("selected", "selected");
          opt.setAttribute("disabled", "disabled");
          opt.setAttribute("class", "dispalynone");
          data.appendChild(opt);
          for (var i = 0; i < msg.length; i++) {
              if (msg[i].plantname != null) {
                  var option = document.createElement('option');
                  option.innerHTML = msg[i].plantname;
                  option.value = msg[i].plantcode;
                  data.appendChild(option);
              }
          }
      }
      function get_subbill_dates() {
          var plantcode = document.getElementById("slct_subplant").value;
          var data = { 'op': 'get_bill_dates', 'plantcode': plantcode };
          var s = function (msg) {
              if (msg) {
                  if (msg.length > 0) {
                      fillsubbilldetails(msg);
                  }
              }
              else {
              }
          };
          var e = function (x, h, e) {
          };
          $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
          callHandler(data, s, e);
      }
      function fillsubbilldetails(msg) {
          var data = document.getElementById('slct_subbilldate');
          var length = data.options.length;
          document.getElementById('slct_subbilldate').options.length = null;
          var opt = document.createElement('option');
          opt.innerHTML = "Select Bill Date";
          opt.value = "Select Bill Date";
          opt.setAttribute("selected", "selected");
          opt.setAttribute("disabled", "disabled");
          opt.setAttribute("class", "dispalynone");
          data.appendChild(opt);
          for (var i = 0; i < msg.length; i++) {
              if (msg[i].Billdate != null) {
                  var option = document.createElement('option');
                  option.innerHTML = msg[i].Billdate;
                  option.value = msg[i].Billdate;
                  data.appendChild(option);
              }
          }
      } 
      function get_plant_names() {
          var data = { 'op': 'get_plant_names' };
          var s = function (msg) {
              if (msg) {
                  if (msg.length > 0) {
                      fillplantdetails(msg);
                  }
              }
              else {
              }
          };
          var e = function (x, h, e) {
          };
          $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
          callHandler(data, s, e);
      }
      function fillplantdetails(msg) {
          var data = document.getElementById('selct_plant');
          var length = data.options.length;
          document.getElementById('selct_plant').options.length = null;
          var opt = document.createElement('option');
          opt.innerHTML = "Select Plant Name";
          opt.value = "Select Plant Name";
          opt.setAttribute("selected", "selected");
          opt.setAttribute("disabled", "disabled");
          opt.setAttribute("class", "dispalynone");
          data.appendChild(opt);
          for (var i = 0; i < msg.length; i++) {
              if (msg[i].plantname != null) {
                  var option = document.createElement('option');
                  option.innerHTML = msg[i].plantname;
                  option.value = msg[i].plantcode;
                  data.appendChild(option);
              }
          }
      }
      function get_bill_dates() {
          var plantcode = document.getElementById("selct_plant").value;
          var data = { 'op': 'get_bill_dates', 'plantcode': plantcode };
          var s = function (msg) {
              if (msg) {
                  if (msg.length > 0) {
                      fillbilldetails(msg);
                  }
              }
              else {
              }
          };
          var e = function (x, h, e) {
          };
          $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
          callHandler(data, s, e);
      }
      function fillbilldetails(msg) {
          var data = document.getElementById('slct_billdate');
          var length = data.options.length;
          document.getElementById('slct_billdate').options.length = null;
          var opt = document.createElement('option');
          opt.innerHTML = "Select Bill Date";
          opt.value = "Select Bill Date";
          opt.setAttribute("selected", "selected");
          opt.setAttribute("disabled", "disabled");
          opt.setAttribute("class", "dispalynone");
          data.appendChild(opt);
          for (var i = 0; i < msg.length; i++) {
              if (msg[i].Billdate != null) {
                  var option = document.createElement('option');
                  option.innerHTML = msg[i].Billdate;
                  option.value = msg[i].Billdate;
                  data.appendChild(option);
              }
          }
      } 
      var jvimport = [];
      function get_jvagent() {
       var billdate = document.getElementById("slct_billdate").value;
       var plantcode = document.getElementById("selct_plant").value;
       var vdate = document.getElementById("txt_date").value;
       var data = { 'op': 'get_jvagent', 'billdate': billdate, 'plantcode': plantcode, 'vdate': vdate };
       var s = function (msg) {
           if (msg) {
               if (msg.length > 0) {
                   fillbilljvdetails(msg);
                   jvimport = msg;
                   $('#divMainAddNewRow').css('display', 'none');
               }
           }
           else {
           }
       };
          var e = function (x, h, e) {
          };
          $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
          callHandler(data, s, e);
      }
      function fillbilljvdetails(msg) {
          var results = '<div  style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
          results += '<thead><tr><th scope="col">HeadOfAccount</th><th scope="col">Amount</th></tr></thead></tbody>';
          for (var i = 0; i < msg.length; i++) {
              var HeadOfAccount = msg[i].HeadOfAccount;
              var Amount = msg[i].Amount;
              var HeadSno = msg[i].ledgerid;
              Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });
              results += '<tr>';
              results += '<td data-title="SHORT_DESC" class="3" style="display:none">' + msg[i].ledgerid + '</td>';
              results += '<td data-title="groupcode"  class="6" id="txtAccount">' + msg[i].HeadOfAccount + '</td>';
              results += '<td  data-title="GROUP_CD" class="AmountClass" id="txtamount">' + msg[i].Amount + '</td>';
              results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
          }
          results += '</table></div>';
              $("#divHeadAcount").html(results);
          var TotRate = 0.0;
          $('.AmountClass').each(function (i, obj) {
              if ($(this).text() == "") {
              }
              else {
                  TotRate += parseFloat($(this).text());
              }
          });
          TotRate = parseFloat(TotRate).toFixed(2);
          document.getElementById("txt_totalamount").value = TotRate;
      }
      function get_subjvagent() {
          var billdate = document.getElementById("slct_subbilldate").value;
          var plantcode = document.getElementById("slct_subplant").value;
          var vdate = document.getElementById("txt_date").value;
          var data = { 'op': 'get_jvagent', 'billdate': billdate, 'plantcode': plantcode, 'vdate': vdate };
          var s = function (msg) {
              if (msg) {
                  if (msg.length > 0) {
                      fillsubjvdetails(msg);
                      $('#divSubAddNewRow').css('display', 'none');
                  }
              }
              else {
              }
          };
          var e = function (x, h, e) {
          };
          $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
          callHandler(data, s, e);
      }
      function fillsubjvdetails(msg) {
          var results = '<div  style="overflow:auto;"><table id="subtableetails" class="responsive-table">';
          results += '<thead><tr><th scope="col">HeadOfAccount</th><th scope="col">Amount</th></tr></thead></tbody>';
          for (var i = 0; i < msg.length; i++) {
              var HeadOfAccount = msg[i].HeadOfAccount;
              var Amount = msg[i].Amount;
              var HeadSno = msg[i].ledgerid;
              SubCollectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });
              results += '<tr>';
              results += '<td data-title="SHORT_DESC" class="3" style="display:none">' + msg[i].ledgerid + '</td>';
              results += '<td data-title="groupcode"  class="6" id="txtAccount">' + msg[i].HeadOfAccount + '</td>';
              results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + msg[i].ledgerid + '" /></td>';
              results += '<td  data-title="GROUP_CD" class="SubAmountClass" id="txtamount">' + msg[i].Amount + '</td>';
              results += '<td  class="6"> <img src="Images/Odclose.png" onclick="subaccountrowdeleteclick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
          }
          results += '</table></div>';
          $("#div_subHeadAcount").html(results);
          var subTotRate = 0.0;
          $('.SubAmountClass').each(function (i, obj) {
              if ($(this).text() == "") {
              }
              else {
                  subTotRate += parseFloat($(this).text());
              }
          });
          subTotRate = parseFloat(subTotRate).toFixed(2);
          document.getElementById("txt_totalamt_sub").value = subTotRate;
      }

//      function view_jvagent() {
//          var billdate = document.getElementById("slct_billdate").value;
//          var plantcode = document.getElementById("selct_plant").value;
//          var vdate = document.getElementById("txt_date").value;
//          var data = { 'op': 'view_jvagent_details', 'plantcode': plantcode, 'billdate': billdate, 'vdate': vdate };
//          var s = function (msg) {
//              if (msg) {
//                  if (msg.length > 0) {
//                      fillviewdetails(msg);
//                      $('#divMainAddNewRow').css('display', 'none');
//                  }
//              }
//              else {
//              }
//          };
//          var e = function (x, h, e) {
//          };
//          $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//          callHandler(data, s, e);
//      }
//      function fillviewdetails(msg) {
//          var results = '<div  style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
//          results += '<thead><tr><th scope="col">LedgerName</th><th scope="col">Amount</th></tr></thead></tbody>';
//          for (var i = 0; i < msg.length; i++) {
//              results += '<tr>';
//              results += '<td data-title="PARTY_TP" style="display:none" class="2">' + msg[i].jvno + '</td>';
//              results += '<td data-title="SHORT_DESC" class="3" style="display:none">' + msg[i].vchdate + '</td>';
//              results += '<td data-title="groupcode"  class="6" id="txtAccount">' + msg[i].ledgername + '</td>';
//              results += '<td data-title="groupdesc" class="AmountClass" id="txtamount">' + msg[i].amount + '</td>';
//              results += '<td  data-title="GROUP_CD" style="display:none" class="5">' + msg[i].narration + '</td>';
//              results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
//          }
//          results += '</table></div>';
//          $("#divHeadAcount").html(results);
//      }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Payments Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Payments Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>PaymentEntry Details
                </h3>
            </div>
            <div class="box-body">
                <div id="div_Payment">
                </div>
                <div id='fillform'>
                    <table align="center">
                       <tr>
                            <td>
                                <label>
                                    Branch Name</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="selct_branch" class="form-control">
                                    <option selected disabled value="Select state">Select Branch Name</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    DOP</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" class="form-control" type="date" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Pay to</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_name" class="form-control" type="text" placeholder="Enter Name" />
                            </td>
                        </tr>
                        
                        <tr>
                            <td>
                                <label>
                                    A/C Number</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlaccountno" class="form-control">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Main Head of Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddlheadaccounts" type="text" class="form-control" placeholder="Enter main head of account" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_proc" type="button" onclick="BtnClickHere();" class="btn btn-success"
                                    name="Add" value='Import'/>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txtamount" class="form-control" type="text" placeholder="Enter Amount" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_add" type="button" onclick="BtnAddClick();" class="btn btn-success"
                                    name="Add" value='Add' />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div id="divHeadAcount">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Total Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_totalamount" class="form-control" placeholder="Total Amount" type="text" readonly />
                            </td>
                        </tr>
                           <tr>
                            <td>
                                <label>
                                    Branch</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_subbranch" class="form-control">
                                    <option selected disabled value="Select Branch">Select Branch Name</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Sub Head of Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddl_subheadaccounts" type="text" class="form-control" placeholder="Enter sub head of account" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_subhoc" type="button" onclick="BtnsubClick();" class="btn btn-success"
                                    name="Add" value='Import'/>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_subamount" class="form-control" type="text" placeholder="Enter Amount" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="Button1" type="button" onclick="Btn_subAddClick();" class="btn btn-success"
                                    name="Add" value='Add' />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div id="div_subHeadAcount">
                                </div>
                            </td>
                        </tr>
                          <tr>
                            <td>
                                <label>
                                    Total Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_totalamt_sub" class="form-control" placeholder="Total Amount_Sub" type="text" readonly />
                            </td>
                        </tr>
                        <tr>
                         <td>
                                <label>
                                   SAP Import</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_sapimport" class="form-control">
                                <option value="1">Main Head Of Accounts</option>
                                 <option value="2">Sub Head Of Accounts</option>
                            </td>
                        
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td colspan="2">
                                <textarea rows="3" cols="45" id="txtRemarks" class="form-control" maxlength="2000"
                                    placeholder="Enter Remarks"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    ApprovedBy</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlapprovedby" class="form-control">
                                </select>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="txtsno">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td style="display: none">
                                <input id="txt_sub_head" type="hidden" style="height: 28px; opacity: 1.0; width: 150px;" />
                                <input id="txt_head" type="hidden" style="height: 28px; opacity: 1.0; width: 150px;" />
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_payment_click()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
                <div id="div_data" style="overflow:auto;height:500px">
                </div>
            </div>
               <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 800px;
             width:80%; position: absolute; display: none; left: 20%; top: 10%;">
             <div id="divAddNewRow" style="border: 5px solid #A0A0A0; top: 8%;
                 background-color: White; left: 10%; right: 10%; width: 80%; height: 50%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 border-radius: 10px 10px 10px 10px;">
                       <table align="center">
                       <h1>Loan Jv Report</h1>
                        <br />
                        <tr>
                        <td>
           <label>
           Plant Name</label>
            </td>
             <td style="height: 40px;">
              <select id="selct_plant" class="form-control" onchange="get_bill_dates()">
           <option selected disabled value="Select state">Select Plant Name</option>
            </select>
            </td>
            </tr>
                          <tr>
                            <td>
                                <label>
                                   Bill Date
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_billdate" type="text" class="form-control"></select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="lbl_sno"></label>
                            </td>
                        </tr>
                        <tr>
                            <td style="display: none">
                                <input id="Hidden1" type="hidden" style="height: 28px; opacity: 1.0; width: 150px;" />
                                 <input id="Hidden2" type="hidden" style="height: 28px; opacity: 1.0; width: 150px;" />
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                       <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save2" type="button" class="btn btn-success" name="submit" value='Get Report'
                                    onclick="get_jvagent()" />
                               <%-- <input id='btn_close2' type="button" class="btn btn-danger" name="Close" value='View Report'
                                    onclick="view_jvagent()" />--%>
                            </td>
                        </tr>
                    </table>
                  
                    </div>
                    <div id="divclose" style="width: 40px; top: 3%; right: 21%; position: absolute;
                 z-index: 99999; cursor: pointer;">
                 <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
             </div>
                </div>

                <div id="divSubAddNewRow" class="pickupclass" style="text-align: center; height: 800px;
             width:80%; position: absolute; display: none; left: 20%; top: 10%;">
             <div id="divAddNewRow" style="border: 5px solid #A0A0A0; top: 8%;
                 background-color: White; left: 10%; right: 10%; width: 80%; height: 50%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 border-radius: 10px 10px 10px 10px;">
                       <table align="center">
                       <h1>Loan Jv Report</h1>
                        <br />
                        <tr>
                        <td>
           <label>
           Plant Name</label>
            </td>
             <td style="height: 40px;">
              <select id="slct_subplant" class="form-control" onchange="get_subbill_dates()">
           <option selected disabled value="Select state">Select Plant Name</option>
            </select>
            </td>
            </tr>
                          <tr>
                            <td>
                                <label>
                                   Bill Date
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_subbilldate" type="text" class="form-control"></select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="Label1"></label>
                            </td>
                        </tr>
                        <tr>
                            <td style="display: none">
                                <input id="Hidden3" type="hidden" style="height: 28px; opacity: 1.0; width: 150px;" />
                                 <input id="Hidden4" type="hidden" style="height: 28px; opacity: 1.0; width: 150px;" />
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                       <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="Button2" type="button" class="btn btn-success" name="submit" value='Get Report'
                                    onclick="get_subjvagent()" />
                               
                            </td>
                        </tr>
                    </table>
                  
                    </div>
                    <div id="div3" style="width: 40px; top: 3%; right: 21%; position: absolute;
                 z-index: 99999; cursor: pointer;">
                 <img src="Images/Close.png" alt="close" onclick="ClosesubClick();" />
             </div>
                </div>

        </div>

    </section>
</asp:Content>
