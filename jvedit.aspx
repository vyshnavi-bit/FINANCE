<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="jvedit.aspx.cs" Inherits="jvedit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_date').val(today);
            $('#txt_entrydate').val(today);
            get_Branch_details();
            $("#divmain").css("display", "none");
            $("#divsub").css("display", "none");
            $("#divsave").css("display", "none");
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
        function get_jv_details() {
            var date = document.getElementById("txt_date").value;
            var branch = document.getElementById("selct_branch").value;
            var data = { 'op': 'get_jv_details', 'date': date, 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filljvdetails(msg);
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
        function filljvdetails(msg) {
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
        function getcoln(thisid) {
            var sno = $(thisid).parent().parent().children('.6').html();
            var branchid = $(thisid).parent().parent().children('.4').html();
            var totalamount = $(thisid).parent().parent().children('.3').html();
            var accountno = $(thisid).parent().parent().children('.7').html();
            var remarks = $(thisid).parent().parent().children('.8').html();
            var approved = $(thisid).parent().parent().children('.9').html();
            var Debitname = $(thisid).parent().parent().children('.10').html();
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('txt_totalamount').value = totalamount;
            get_jvdetails(sno);
            get_subaccount_paymentdetails(sno);
            $("#divmain").css("display", "block");
            $("#divsub").css("display", "block");
            $("#divsave").css("display", "block");
            $("#divHeadAcount").css("display", "block");
            $("#div_subHeadAcount").css("display", "block");
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
                results += '<td class="2"><input id="txtamount" type="text" class="AmountClass" style="width:90px;" value="' + Collectionform[i].Amount + '"/></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
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
                results += '<td ><input id="txtamount" type="text" class="subAmountClass" style="width:90px;" value="' + SubCollectionform[i].Amount + '"/></td>';
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
        function save_journel_voucher_click() {
            var branch = document.getElementById("selct_branch").value;
            var btnval = document.getElementById("btn_save").value;
            var Remarks = document.getElementById('txtRemarks').value;
            var sno = document.getElementById("txtsno").value;
            var jvdate = document.getElementById("txt_entrydate").value;
            if (branch == "" || branch == "Select Branch Name") {
                alert("Select Branch Name");
                return false;
            }
            var rows = $("#tableCashFormdetails tr:gt(0)");
            var paymententry = new Array();
            $(rows).each(function (i, obj) {
                paymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').val() });
                var amt = $(this).find('#txtamount').val();
                document.getElementById('txt_totalamount').value = amt;
            });
            if (paymententry.length == "0") {
                alert("Please enter head of account details");
                return false;
            }

            var subrows = $("#subtableetails tr:gt(0)");
            var subpaymententry = new Array();
            $(subrows).each(function (i, obj) {
                subpaymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').val() });
            });
            var totalamount = document.getElementById('txt_totalamount').value;
            var Data = { 'op': 'save_jounel_voucher_click', 'subpaymententry': subpaymententry, 'jvdate': jvdate, 'Remarks': Remarks, 'btnval': btnval, 'branchid': branch, 'totalamount': totalamount, 'sno': sno, 'paymententry': paymententry };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
        }
        function forclearall() {
            document.getElementById('txtamount').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById("txt_jv_subamount").value = "";
            document.getElementById('btn_save').value = "Save";
            $("#divmain").css("display", "none");
            $("#divsub").css("display", "none");
            $("#divsave").css("display", "none");
            $("#divHeadAcount").css("display", "none");
            $("#div_subHeadAcount").css("display", "none");
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
                                     Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_entrydate" class="form-control" type="date" />
                            </td>
                            <td>
                                <label>
                                    JV Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" class="form-control" type="date" />
                            </td>
                            <td></td>
                            <td>
                                <label>
                                    Branch Name</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="selct_branch" class="form-control">
                                    <option selected disabled value="Select state">Select Branch Name</option>
                                </select>
                            </td>
                            <td>
                            </td>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_genarate" type="button" class="btn btn-success" name="submit" value='Genarate'
                                    onclick="get_jv_details();" />
                            </td>
                        </tr>
                  
                        <tr style="display: none;">
                        <input id="txt_totalamount" class="form-control" type="text" readonly />
                            <td>
                                <label id="txtsno">
                                </label>
                            </td>
                        </tr>
                    </table>
                    
                    <div id="divmain">
                    Main Head Of Account
                    <div id="divHeadAcount">
                    </div>
                    </div>
                    <div id="divsub">
                    <br />
                     Sub Head Of Account
                    <div id="div_subHeadAcount">
                    </div>
                    <input id="txt_jv_subamount" class="form-control" type="text" readonly />
                    </div>

                    <div id="divsave">
                     <table align="center">
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
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_journel_voucher_click()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                    </div>
                </div>
                <div id="div_data">
                </div>
            </div>
        </div>
    </section>
</asp:Content>
