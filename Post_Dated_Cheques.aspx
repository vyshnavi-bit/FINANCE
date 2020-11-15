<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Post_Dated_Cheques.aspx.cs" Inherits="Post_Dated_Cheques" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_bankaccount_details();
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
                        fillacdetails(msg);
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
         function fillacdetails(msg) {
            var data = document.getElementById('slct_ac');
            var length = data.options.length;
            document.getElementById('slct_ac').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Account No";
            opt.value = "Select Account No";
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
        var cheque = [];
        function btn_party_code_click() {
            var accountno = document.getElementById('slct_ac').value;
            if (accountno == "") {
                alert("Please select location");
                return false;
            }
            var fromdate = document.getElementById('txt_from').value;
            if (fromdate == "") {
                alert("Please enter from date");
                return false;
            }
            var Todate = document.getElementById('txt_to').value;
            if (Todate == "") {
                alert("Please enter to date");
                return false;
            }
            var data = { 'op': 'get_post_cheque', 'accountno': accountno, 'fromdate': fromdate, 'Todate': Todate };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        cheque = msg;
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
            results += '<thead><tr><th scope="col"></th><th scope="col">Sno</th><th scope="col">Party Name</th><th scope="col">Cheque Number</th><th scope="col">ChequeType</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].status == "Pending") {
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                    results += '<thead><tr><th scope="col"></th><th scope="col">Sno</th><th scope="col">Party Name</th><th scope="col">Cheque Number</th><th scope="col">ChequeType</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col">Status</th></tr></thead></tbody>';
                    results += '<tr><th><input id="btnclear" type="button"   onclick="Clearcheque(this);"  name="Edit" class="btn btn-primary" value="Clear" /></th>'
                    results += '<td scope="row" class="1">' + (i + 1) + '</td>';
                    results += '<td data-title="partyname" class="2">' + msg[i].partyname + '</td>';
                    results += '<td data-title="cheque no" class="3">' + msg[i].chequeno + '</td>';
                    results += '<td data-title="chequetype" class="4">' + msg[i].chequetype + '</td>';
                    results += '<td data-title="" class="6">' + msg[i].amount + '</td>';
                    results += '<td data-title="" class="10">' + msg[i].remarks + '</td>';
                    results += '<td data-title="Status" class="7">' + msg[i].status + '</td>';
                    results += '<td data-title="cheque date" class="8" style="display:none">' + msg[i].chequedate + '</td>';
                    results += '<td style="display:none;" class="9">' + msg[i].sno + '</td>';
                    results += '</tr>';
                }
      
                else {
                   // for (var i = 0; i < msg.length; i++) {
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                    results += '<thead><th scope="col">Sno</th><th scope="col">Party Name</th><th scope="col">Cheque Number</th><th scope="col">ChequeType</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col">Status</th></tr></thead></tbody>';
                    results += '<tr><td scope="row" class="1">' + (i + 1) + '</td>';
                    results += '<td data-title="partyname" class="2">' + msg[i].partyname + '</td>';
                    results += '<td data-title="cheque no" class="3">' + msg[i].chequeno + '</td>';
                    results += '<td data-title="chequetype" class="4">' + msg[i].chequetype + '</td>';
                    results += '<td data-title="" class="6">' + msg[i].amount + '</td>';
                    results += '<td data-title="" class="10">' + msg[i].remarks + '</td>';
                    results += '<td data-title="Status" class="7">' + msg[i].status + '</td>';
                    results += '<td data-title="cheque date" class="8" style="display:none">' + msg[i].chequedate + '</td>';
                    results += '<td style="display:none;"class="9">' + msg[i].sno + '</td>';
                    results += '</tr>';
//                }
            }
        }
            results += '</table></div>';
            $("#div_post_cheque_det").html(results);
        }
        function Clearcheque(thisid)
        {
            var sno = $(thisid).parent().parent().children('.9').html();
            var data = { 'op': 'get_cheque_status', 'sno': sno };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e)
            {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function clearAll() {
            var msg = [];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Sno</th><th scope="col">Party Name</th><th scope="col">Cheque Number</th><th scope="col">ChequeType</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="partyname" class="8">' + msg[i].partyname + '</td>';
                results += '<td data-title="cheque no" class="5">' + msg[i].chequeno + '</td>';
                results += '<td data-title="amount" class="4">' + msg[i].amount + '</td>';
                results += '<td data-title="" class="8">' + msg[i].amount + '</td>';
                results += '<td data-title="" class="9">' + msg[i].amount + '</td>';
                results += '<td  data-title="Status" class="7">' + msg[i].status + '</td>';
              //  results += '<td style="display:none;"class="7">' + msg[i].sno + '</td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_post_cheque_det").html(results);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Post_Dated_Cheques_Details
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Post_Dated_Cheques_Details</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Post_Dated_Cheques_Details
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
                                    <td>
                                        <label>
                                            Account Number</label>
                                    </td>
                                    <td>
                                        <select id="slct_ac" type="text" class="form-control"></select>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td>
                                        <label>
                                            From Date</label>
                                    </td>
                                    <td>
                                        <input id="txt_from" type="date" class="form-control" />
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td>
                                        <label>
                                            To Date</label>
                                    </td>
                                    <td>
                                        <input id="txt_to" type="date" class="form-control" />
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td>
                                        <input id="btn_get" type="button" name="get" value="GET" class="btn btn-primary" onclick="btn_party_code_click();" />
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_post_cheque_det">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
</asp:Content>

