<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master"
    CodeFile="collections.aspx.cs" Inherits="collections" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_bankaccount_details();
            get_headofaccount_details();
            get_collections_details();
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
            var data = document.getElementById('slct_branch');
            var length = data.options.length;
            document.getElementById('slct_branch').options.length = null;
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
        function save_collections_click() {
            var name = document.getElementById("txt_name").value;
            if (name == "") {
                alert("Enter Name");
                return false;
            }
            var receiptdate = document.getElementById("txt_date").value;
            if (receiptdate == "") {
                alert("Enter Date");
                return false;
            }
            var accountno = document.getElementById("ddlaccountno").value;
            if (accountno == "") {
                alert("Enter Account Number");
                return false;
            }
            var totalamount = document.getElementById("txt_totalamount").value;
            var btnval = document.getElementById("btn_save").value;
            var Remarks = document.getElementById('txtRemarks').value;
            var sno = document.getElementById("txtsno").value;
            var sapimport = document.getElementById("slct_sapimport").value;
            var branch = document.getElementById("slct_branch").value;
            var subbranch = document.getElementById("slct_subbranch").value;
            var totalamountsub = document.getElementById("txt_totalamt_sub").value;
            var rows = $("#tableCashFormdetails tr:gt(0)");
            var colleciondetails = new Array();
            $(rows).each(function (i, obj) {
                colleciondetails.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').text(), subsno: $(this).find('#hdnsubSno').text() });
            });
            if (colleciondetails.length == "0") {
                alert("Please enter head of account details");
                return false;
            }
            var subrows = $("#subtabledetails tr:gt(0)");
            var subcollectionentry = new Array();
            $(subrows).each(function (i, obj) {
                subcollectionentry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').text() });
            });
            var Data = { 'op': 'save_collections_click', 'Remarks': Remarks, 'receiptdate': receiptdate, 'btnval': btnval, 'name': name, 'accountno': accountno, 'sno': sno, 'totalamount': totalamount, 'colleciondetails': colleciondetails, 'branch': branch, 'subbranch': subbranch, 'sapimport': sapimport, 'subcollectionentry': subcollectionentry, 'totalamountsub': totalamountsub };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_collections_details();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
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
                    $('#slct_subheadofacc').autocomplete({
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
        function AccountNamechange() {
            var AccountName = document.getElementById('ddlheadaccounts').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_head').value = AccountNameDetails[i].sno;
                }
            }
        }
        function SubAccountNamechange() {
            var AccountName = document.getElementById('slct_subheadofacc').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_sub_head').value = AccountNameDetails[i].sno;
                }
            }
        }
        var Collectionform = [];
        function get_collections_details() {
            var data = { 'op': 'get_collections_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcolectiondetails(msg);
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
        function fillcolectiondetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col"></th><th scope="col">Account Number</th><th scope="col">Pay To</th><th scope="col">TotalAmount</th><th scope="col">Name</th><th scope="col">Date</th><th scope="col">Branch</th><th scope="col">SubBranch</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getcoln(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td><input id="btn_poplate" type="button"  onclick="getprintreceipt(this)" name="submit" class="btn btn-primary" value="Print" /></td>';
                results += '<th scope="row"  style="text-align:center;">' + msg[i].accountid + '</th>';
                results += '<td class="2">' + msg[i].Name + '</td>';
                results += '<td  class="3">' + msg[i].totalamount + '</td>';
                results += '<td  class="4">' + msg[i].Name + '</td>';
                //results += '<td class="5">' + msg[i].doe + '</td>';
                results += '<td class="5">' + msg[i].receiptdate + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].remarks + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].accountno + '</td>';
                results += '<td  class="10">' + msg[i].branchname + '</td>';
                results += '<td  class="11">' + msg[i].subbranchname + '</td>';
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
            var data = { 'op': 'btnReceiptPrintClick', 'Receiptno': sno };
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
            window.location = "Print_receipt.aspx";
        }
        function getcoln(thisid) {
            var sno = $(thisid).parent().parent().children('.6').html();
            var name = $(thisid).parent().parent().children('.4').html();
            var receiptdate = $(thisid).parent().parent().children('.5').html();
            var totalamount = $(thisid).parent().parent().children('.3').html();
            var accountno = $(thisid).parent().parent().children('.7').html();
            var remarks = $(thisid).parent().parent().children('.8').html();
            var branch = $(thisid).parent().parent().children('.10').html();
            var subbranch = $(thisid).parent().parent().children('.11').html();
            var sapimport = $(thisid).parent().parent().children('.12').html();
            var branchid = $(thisid).parent().parent().children('.13').html();
            var subbranchid = $(thisid).parent().parent().children('.14').html();
            var totalsubamount = $(thisid).parent().parent().children('.15').html();

            document.getElementById('txtsno').value = sno;
            document.getElementById('txt_name').value = name;
            document.getElementById('txt_date').value = receiptdate;
            document.getElementById('ddlaccountno').selectedIndex = accountno;
            document.getElementById('txt_totalamount').value = totalamount;
            document.getElementById('txt_totalamt_sub').value = totalsubamount;
            document.getElementById('txtRemarks').value = remarks; 
            document.getElementById('slct_sapimport').value = sapimport;
            document.getElementById('slct_branch').value = branchid;
            document.getElementById('slct_subbranch').value = subbranchid;
            document.getElementById('btn_save').value = "Modify";
            get_collectionsubdetails(sno);
            get_subaccount_collectiondetails(sno);
        }
            function get_collectionsubdetails(sno)
            {
            var data = { 'op': 'get_collectionssubdetails', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcolectioneditdetails(msg);
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
        function fillcolectioneditdetails(msg) {
            $("#divHeadAcount").css("display", "block");
            Collectionform = [];
            for (var i = 0; i < msg.length; i++) {
                var subno = msg[i].sno;
                var HeadSno = msg[i].headid;
                var HeadOfAccount = msg[i].accountno;
                var Amount = msg[i].totalamount;
                Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, subsno: subno });
            }
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
        }
        function get_subaccount_collectiondetails(sno) {
            var data = { 'op': 'get_subaccount_collectiondetails', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsubcolectioneditdetails(msg);
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
        function fillsubcolectioneditdetails(msg) {
            $("#divSubHeadAccount").css("display", "block");
            SubCollectionform = [];
            for (var i = 0; i < msg.length; i++) {
                var subno = msg[i].sno;
                var HeadSno = msg[i].headid;
                var HeadOfAccount = msg[i].accountno;
                var Amount = msg[i].totalamount;
                SubCollectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, subsno: subno });
            }
            var results = '<div  style="overflow:auto;"><table id="subtabledetails" class="responsive-table">';
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
            $("#divSubHeadAccount").html(results);
        }
        function forclearall() {
            document.getElementById('txt_name').value = "";
            document.getElementById('ddlaccountno').selectedIndex = 0;
            document.getElementById('slct_branch').selectedIndex = 0;
            document.getElementById('slct_subbranch').selectedIndex = 0;
            document.getElementById('slct_sapimport').selectedIndex = 0;
            document.getElementById('txtamount').value = "";
            document.getElementById('txt_totalamount').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('txt_totalamt_sub').value = "";
            document.getElementById('btn_save').value = "Save";
            Collectionform = [];
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
           SubCollectionform = [];
           var results = '<div  style="overflow:auto;"><table id="subtabledetails" class="responsive-table">';
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
           $("#divSubHeadAccount").html(results);
        }
        function BtnAddClick() {
            $("#divHeadAcount").css("display", "block");
            var subsno = 0;
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
                Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, subsno: subsno });
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

        var SubCollectionform = [];
        function BtnAddSubClick() {
            $("#divSubHeadAccount").css("display", "block");
            var accountno = document.getElementById("slct_subheadofacc").value;
            if (accountno == "Select AccountNumber" || accountno == "") {
                alert("Select AccountNumber");
                return false;
            }
            var HeadSno = document.getElementById("txt_sub_head").value;
            var HeadOfAccount = document.getElementById("slct_subheadofacc").value;
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
            var Amount = document.getElementById("txt_amount_sub").value;
            if (Amount == "") {
                alert("Enter Amount");
                return false;
            }
            else {
                SubCollectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount });
                var results = '<div  style="overflow:auto;"><table id="subtabledetails" class="responsive-table">';
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
                $("#divSubHeadAccount").html(results);
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
        function subaccountrowdeleteclick(Account) {
            SubCollectionform = [];
            var HeadOfAccount = "";
            var HeadSno = "";
            var Account = $(Account).closest("tr").find("#txtAccount").text();
            var Amount = "";
            var rows = $("#subtabledetails tr:gt(0)");
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
            var results = '<div  style="overflow:auto;"><table id="subtabledetails" class="responsive-table">';
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
            $("#divSubHeadAccount").html(results);
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Receipts Entry
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Receipts Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Receipts Details
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
                                    DOR</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" class="form-control" type="date" />
                            </td>
                        </tr>
                          <tr>
                            <td>
                                <label>
                                    Branch</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_branch" class="form-control">
                                    <option selected disabled value="Select Branch">Select Branch Name</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Name</label>
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
                                    Head of Account
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
                                <input id="txt_totalamount" class="form-control" type="text" readonly />
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
                                <input id="slct_subheadofacc" type="text" class="form-control" placeholder="Enter head of accounts" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_amount_sub" class="form-control" type="text" placeholder="Enter Amount" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_add_sub" type="button" onclick="BtnAddSubClick();" class="btn btn-success"
                                    name="Add" value='Add' />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div id="divSubHeadAccount">
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
                                    onclick="save_collections_click()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
            </div>
            <div id="div_data"  style="overflow:auto;height:500px">
            </div>
        </div>
    </section>
</asp:Content>
