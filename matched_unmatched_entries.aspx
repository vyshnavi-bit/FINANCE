<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="matched_unmatched_entries.aspx.cs" Inherits="matched_unmatched_entries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_accountcode_details();
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
        var AccountCodeDetails = [];
        function get_accountcode_details() {
            var data = { 'op': 'get_bankaccount_details' };
            var s = function (msg) {
                if (msg) {
                    AccountCodeDetails = msg;
                    var AccountCodeList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var code = msg[i].AccountNumber;
                        AccountCodeList.push(code);
                    }
                    $('#account_cd').autocomplete({
                        source: AccountCodeList,
                        change: Getnature,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }

        function Getnature() {
            var AccountNumber = document.getElementById('account_cd').value;
            for (var i = 0; i < AccountCodeDetails.length; i++) {
                if (AccountNumber == AccountCodeDetails[i].AccountNumber) {
                    document.getElementById('account_cd_desc').value = AccountCodeDetails[i].bankname;
                }
            }
        }

        function btn_account_code_click() {
            var account_cd = document.getElementById('account_cd').value;
            if (account_cd == "") {
                alert("Please select account no");
                return false;
            }
            var fromdate = document.getElementById('txt_from').value;
            if (fromdate == "") {
                alert("Please enter from date");
                return false;
            }
            var todate = document.getElementById('txt_to').value;
            if (todate == "") {
                alert("Please enter to date");
                return false;
            }
            var cp = document.getElementById('slct_cp').value;
            if (cp == "") {
                alert("Please select Cleared/Pending");
                return false;
            }
            var data = { 'op': 'get_match_unmatch_det', 'account_cd': account_cd, 'fromdate': fromdate, 'todate': todate, 'cp': cp };
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
            clearAll();
        }
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">ACCOUNT NO</th><th scope="col">CHEQUE NO</th><th scope="col">CHEQUE DATE</th><th scope="col">AMOUNT</th><th scope="col">DRAWEE BANK</th><th scope="col">BRANCH</th><th scope="col">PARTY CODE</th><th scope="col">STATUS</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="ACCOUNT NO" class="3">' + msg[i].accountcode + '</td>';
                results += '<td data-title="CHEQUE NO" class="4">' + msg[i].chequeno + '</td>';
                results += '<td data-title="CHEQUE DATE" class="8">' + msg[i].chequedate + '</td>';
                results += '<td data-title="AMOUNT" class="5">' + msg[i].amount + '</td>';
                results += '<td data-title="DRAWEE BANK" class="6">' + msg[i].draweebank + '</td>';
                results += '<td data-title="BRANCH" class="9">' + msg[i].branchcode + '</td>';
                results += '<td data-title="PARTY CODE" class="10">' + msg[i].partycode + '</td>';
                results += '<td data-title="STATUS" class="7">' + msg[i].status + '</td>';
                results += '<td style="display:none;" data-title="REMARKS" class="11">' + msg[i].remarks + '</td>';
                results += '<td style="display:none;" data-title="CHEQUE TYPE" class="12">' + msg[i].chequetype + '</td>';
                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_match_unmatch_det").html(results);
        }
        function clearAll() {
            var msg = [];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">ENTRY DATE</th><th scope="col">CHEQUE NO</th><th scope="col">AMOUNT</th><th scope="col">TRANSACTION TYPE</th><th scope="col">STATUS</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="ENTRY DATE" class="3">' + msg[i].entrydate + '</td>';
                results += '<td data-title="CHEQUE NO" class="4">' + msg[i].checkno + '</td>';
                results += '<td data-title="AMOUNT" class="5">' + msg[i].amount + '</td>';
                results += '<td data-title="TRANSACTION TYPE" class="6">' + msg[i].amounttranstype + '</td>';
                results += '<td data-title="STATUS" class="7">' + msg[i].status + '</td>';
                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_match_unmatch_det").html(results);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Matched UnMatched Entries
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#"> Matched UnMatched Entries</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i> Matched UnMatched Entries
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
                        </div>
                        <div id='fillform'>
                            <table align="center">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Account Code</label>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td style="height: 40px;">
                                        <input id="account_cd" type="text" class="form-control" placeholder="Enter Account Code"  onchange="Getnature();" />
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td style="height: 40px;">
                                        <input id="account_cd_desc" type="text" class="form-control" placeholder="Account Description" readonly="readonly" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            From Date</label>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td style="height: 40px;">
                                        <input id="txt_from" type="date" class="form-control" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            To Date</label>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td style="height: 40px;">
                                        <input id="txt_to" type="date" class="form-control" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Cleared/Pending</label>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td style="height: 40px;">
                                        <select id="slct_cp">
                                            <option value="">SELECT</option>
                                            <option value="C">CLEARED</option>
                                            <option value="P">PENDING</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <table align="center">
                                <tr>
                                    <td>
                                        <input type="button" name="get" value="GET" class="btn btn-primary" onclick="btn_account_code_click();" />
                                    </td>
                                </tr>
                            </table>
                            <div id="div_match_unmatch_det">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

