<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Journel_Entry.aspx.cs" Inherits="Journel_Entry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Branch_details();
            get_headofaccount_details();
            get_Journel_entry_details();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_date').val(today);
        });
       
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
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
        function save_journel_voucher_click() {
            var branch = document.getElementById("selct_branch").value;
            var totalamount = document.getElementById("txt_totalamount").value;
            var btnval = document.getElementById("btn_save").value;
            var Remarks = document.getElementById('txtRemarks').value;
            var sno = document.getElementById("txtsno").value;
            var jvdate = document.getElementById("txt_date").value;
            if (branch == "" || branch == "Select Branch Name") {
                alert("Select Branch Name");
                return false;
            }
            var rows = $("#tableCashFormdetails tr:gt(0)");
            var paymententry = new Array();
            $(rows).each(function (i, obj) {
                paymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').text() });
            });
            if (paymententry.length == "0") {
                alert("Please enter head of account details");
                return false;
            }

            var subrows = $("#subtableetails tr:gt(0)");
            var subpaymententry = new Array();
            $(subrows).each(function (i, obj) {
                subpaymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').text() });
            });
            var Data = { 'op': 'save_jounel_voucher_click', 'subpaymententry': subpaymententry, 'jvdate': jvdate, 'Remarks': Remarks, 'btnval': btnval, 'branchid': branch, 'totalamount': totalamount, 'sno': sno, 'paymententry': paymententry };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_Journel_entry_details();
                }
            }
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
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
        function forclearall() {
            document.getElementById('txtamount').value = "";
            document.getElementById('txt_totalamount').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById("txt_jv_subamount").value = "";
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
                Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });

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
                document.getElementById("txt_jv_subamount").value = TotRate;
            }
        }
        function get_Journel_entry_details() {
            var data = { 'op': 'get_Journel_entry_details' };
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
            results += '<thead><tr><th scope="col"></th><th scope="col">Name</th><th scope="col">TotalAmount</th><th scope="col">Date</th><th scope="col">Entry By</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getcoln(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td  class="9">' + msg[i].branchname + '</td>';
                results += '<td  class="4" style="display:none">' + msg[i].branchid + '</td>';
                results += '<td  class="3">' + msg[i].totalamount + '</td>';
                results += '<td class="5">' + msg[i].doe + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].accountid + '</td>';
                results += '<td  class="7">' + msg[i].approvedby + '</td>';
                results += '<td  class="8">' + msg[i].Remarks + '</td>';
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
            var branchid = $(thisid).parent().parent().children('.4').html();
            var totalamount = $(thisid).parent().parent().children('.3').html();
            var accountno = $(thisid).parent().parent().children('.7').html();
            var remarks = $(thisid).parent().parent().children('.8').html();
            var approved = $(thisid).parent().parent().children('.9').html();
            var Debitname = $(thisid).parent().parent().children('.10').html();
            document.getElementById('txtsno').value = sno;
            document.getElementById('selct_branch').value = branchid;
            document.getElementById('txt_totalamount').value = totalamount;
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('btn_save').value = "Modify";
            get_jvdetails(sno);
            get_subaccount_paymentdetails(sno);
        }
        function get_subaccount_paymentdetails(sno) {
            var data = { 'op': 'get_subjv_creditdetails', 'sno': sno };
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
            var TotRate = 0.0;
            $('.subAmountClass').each(function (i, obj) {
                if ($(this).text() == "") {
                }
                else {
                    TotRate += parseFloat($(this).text());
                }
            });
            TotRate = parseFloat(TotRate).toFixed(2);
            document.getElementById("txt_jv_subamount").value = TotRate;
        }
        function get_jvdetails(sno) {
            var data = { 'op': 'get_journelsubdetails', 'sno': sno };
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
            document.getElementById("txt_jv_subamount").value = TotRate;
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
                    HeadSno = $(this).find('#HeadSno').val();
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Journel Voucher Entry
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Journel Voucher</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Journel Voucher Details
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
                                    JV Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" class="form-control" type="date" />
                            </td>
                        </tr>
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
                                    Debit Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddlheadaccounts" type="text" class="form-control" placeholder="Enter head of accounts" />
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
                            <td colspan="4">
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
                                <input id="txt_totalamount" class="form-control" type="text" readonly />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Credit Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddl_subheadaccounts" type="text" class="form-control" placeholder="Enter sub head of account" />
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
                            <td colspan="4">
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
                                <input id="txt_jv_subamount" class="form-control" type="text" readonly />
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
                                    onclick="save_journel_voucher_click()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
                <div id="div_data">
                </div>
            </div>
        </div>
    </section>
</asp:Content>
