<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Paymentsubentry.aspx.cs" Inherits="Paymentsubentry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_bankaccount_details();
            get_headofaccount_details();
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
        function save_paymentsub_click(thisid) {
            var btnval = document.getElementById("btn_save2").value; 
            var sno = document.getElementById("lbl_sno").value;
            var branchid = document.getElementById("selct_branch").value;
            var subtotalamount = document.getElementById("txt_totalamount").value;
            var paymenttotalamount = parseFloat(amt).toFixed(2);
            var rows = $("#tableCashFormdetails tr:gt(0)");
            var paymententry = new Array();
            $(rows).each(function (i, obj) {
                paymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').text() });
            });
            if (paymententry.length == "0") {
                alert("Please enter head of account details");
                return false;
            }
            if (branchid == "") {
                alert("Please enter branch details");
                return false;
            }
          if(paymenttotalamount != subtotalamount){
            alert("Please enter valid amount");
            return false;
            }
            var Data = { 'op': 'save_paymentsubentrys_click', 'sno': sno,'branchid':branchid, 'btnval': btnval,'paymententry':paymententry };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_subpayment_details();
                    get_payment_details();
                }
            }
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
        }
        function get_subpayment_details(thisid) {
            var sno = document.getElementById("lbl_sno").value;
            var data = { 'op': 'get_subaccountentry_paymentdetails', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpaymenteditdetails(msg);
                    }
                    else {


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
        function get_payment_details() {
            fromdate = document.getElementById("txt_fromdate").value;
            todate = document.getElementById("txt_todate").value;
            accountno = document.getElementById("ddlaccountno").value;
            if (accountno != "Select AccountNumber") {
                var data = { 'op': 'get_paymentsubentry_details', 'fromdate': fromdate, 'todate': todate, 'accountno': accountno };
                var s = function (msg) {
                    if (msg) {
                        if (msg.length > 0) {
                            fillpaymentdetails(msg);
                        }
                        else {

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
        }
        function fillpaymentdetails(msg) {
            if (msg.length > 0) {
                var results = '<div  style="overflow:auto;"><table class="responsive-table" id="paymentdeatils">';
                results += '<thead><tr><th scope="col">Account Number</th><th scope="col">Account Type</th><th scope="col">TotalAmount</th><th scope="col">Name</th><th scope="col">Date</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].accountno + '</th>';
                    results += '<td class="2">' + msg[i].accounttype + '</td>';
                    results += '<td  class="3">' + msg[i].totalamount + '</td>';
                    results += '<td  class="4">' + msg[i].name + '</td>';
                    results += '<td class="5">' + msg[i].doe + '</td>';
                    results += '<td style="display:none" class="9">' + msg[i].approvedby + '</td>';
                    results += '<td style="display:none" class="8">' + msg[i].Remarks + '</td>';
                    results += '<td style="display:none" class="7">' + msg[i].accountid + '</td>';
                    results += '<td style="display:none" class="6">' + msg[i].sno + '</td>';
                    results += '<td><input id="btn_poplate" type="button"   onclick="getcoln(this)" name="submit" class="btn btn-primary" value="SecondEntry"/></td></tr>';
                }
                results += '</table></div>';
                $("#div_data").html(results);
            }
            else {
                msg = "NO DATA FOUND";
                results = msg.fontcolor("red");
                $("#div_data").html(results);
            }
        }
        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none');
        }
        var amt = 0;
        function getcoln(thisid) {
            var sno = $(thisid).parent().parent().children('.6').html();
            var name = $(thisid).parent().parent().children('.4').html();
            var totalamount = $(thisid).parent().parent().children('.3').html();
            var accountno = $(thisid).parent().parent().children('.7').html();
            var remarks = $(thisid).parent().parent().children('.8').html();
            var approved = $(thisid).parent().parent().children('.9').html();
            getme(thisid);
            $('#divMainAddNewRow').css('display', 'block');
            get_subpayment_details();
            amt = totalamount;
            forclearall();
        }
        function getme(thisid) {
            var branchid = $(thisid).parent().parent().children('.10').html();
            var accountid = $(thisid).parent().parent().children('.1').html();
            var sno = $(thisid).parent().parent().children('.6').html();
            var doe = $(thisid).parent().parent().children('.5').html();
            var name = $(thisid).parent().parent().children('.4').html();
            var totalamount = $(thisid).parent().parent().children('.3').html();
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('lblpayto').innerHTML = name;
            document.getElementById('lbldate').innerHTML = doe;
            document.getElementById('lblaccountno').innerHTML = accountid;
            var data = { 'op': 'get_paymentsubview_details', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsubdetails(msg);
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
        function fillsubdetails(msg) {
            var results = '<div class="tableCashFormdetails" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Head Of Account</th><th scope="col"></th><th scope="col">Ammount</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].headofaccount + '</th>';
                results += '<th scope="row" class="2" style="text-align:center;"></th>';
                results += '<td  class="9">' + msg[i].branchid + '</td>';
                results += '<td  class="10" style="display:none">' + msg[i].branchid + '</td>';
                results += '<th scope="row" class="3" style="text-align:center;">' + msg[i].totalamount + '</th>';
                results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount1").html(results);
            var TotRate = 0.0;
            $('.subAmountClass').each(function (i, obj) {
                if ($(this).text() == "") {
                }
                else {
                    TotRate += parseFloat($(this).text());
                }
            });
            TotRate = parseFloat(TotRate).toFixed(2);
            document.getElementById("txt_totalamount").value = TotRate;
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
        function forclearall() {
            document.getElementById('txtamount').value = ""; 
            document.getElementById('txt_totalamount').value = "";
            document.getElementById('btn_save2').value = "Save";
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
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Payments Sub Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Payments sub Entry</a></li>
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
            <table>
           
           <tr>
          
           <td>
           <label>
           AccountNo
           </label>
           </td>
           <td>
           <select id="ddlaccountno" class="form-control"></select>
           </td>
            
           <td >
           <label>
           FROM DATE
           </label>
           </td>
           <td style="height: 40px;">
           <input id="txt_fromdate" type="Date" class="form-control" placeholder="select fromdate" />
           </td>
           <td>
           <label>
            TO DATE
           </label>
           </td>
           <td style="height: 40px;">
           <input id="txt_todate" type="Date" class="form-control" placeholder="select Todate" />
           </td>
           <td>
            &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
           </td>
           <td style="height: 40px;">
           <input type="button"   id="btn_gen" class="btn btn-primary"  name="Generate" value='Generate' onclick="get_payment_details();"/>
           </td>
           </tr>
            </table>
                <div id="div_Payment">
                </div>
                
                <div id="div_data">
                </div>
            </div>
        </div>
       <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 800px;
             width:80%; position: absolute; display: none; left: 20%; top: 10%; 
             background: rgba(192, 192, 192, 0.7);">
             <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                 background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 border-radius: 10px 10px 10px 10px;">
                       <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Pay to : </label>
                            </td>
                            <td>
                                <label id="lblpayto"></label>
                            </td>
                       
                            <td>
                                <label>
                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Date:</label>
                            </td>
                            <td>
                                <label id="lbldate"></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                   Account No:
                                </label>
                            </td>
                            <td>
                                <label id="lblaccountno"></label>
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
                                    SubHead of Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddlheadaccounts" type="text" class="form-control" placeholder="Enter main head of account" />
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
                       <%-- <tr>
                            <td>
                                <label>
                                    Debit of Account
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
                                <input id="txt_jv_subamount" class="form-control" type="text" readonly />
                            </td>
                        </tr>--%>
                        
                        <tr hidden>
                            <td>
                                <label id="lbl_sno"></label>
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
                                <input id="btn_save2" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_paymentsub_click()" />
                                <input id='btn_close2' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                    </div>
                    <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                 z-index: 99999; cursor: pointer;">
                 <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
             </div>
                </div>
    </section>
</asp:Content>
