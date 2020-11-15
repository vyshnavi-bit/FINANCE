<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="paymentapproval.aspx.cs" Inherits="paymentapproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_payments_details();
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
        function get_payments_details() {
            var data = { 'op': 'get_payments_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                    else {
                        var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
                        results += '<thead><tr><th scope="col">Name</th><th scope="col">Account Type</th><th scope="col">Total Amount</th><th scope="col">Date</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
                        results += '</table></div>';
                        $("#div_Deptdata").html(results);
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
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Name</th><th scope="col">Account Type</th><th scope="col">Total Amount</th><th scope="col">Date</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].name + '</th>';
                results += '<th scope="row" class="2" style="text-align:center;">' + msg[i].accounttype + '</th>';
                results += '<th scope="row" class="3" style="text-align:center;">' + msg[i].totalamount + '</th>';
                results += '<th scope="row" class="4" style="text-align:center;">' + msg[i].doe + '</th>';
                results += '<th scope="row" class="5" style="text-align:center;">' + msg[i].status + '</th>';
                results += '<th scope="row" style="display:none" class="7" style="text-align:center;">' + msg[i].accountno + '</th>';
                results += '<td><input id="btn_poplate" type="button"  data-toggle="modal" data-target="#myModal" onclick="getme(this)" name="submit" class="btn btn-primary" value="View"/></td>';
                results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }
        function getme(thisid) {
            var sno = $(thisid).parent().parent().children('.6').html();
            var accountno = $(thisid).parent().parent().children('.7').html();
            var accounttype = $(thisid).parent().parent().children('.2').html();
            var name = $(thisid).parent().parent().children('.1').html();
            var date = $(thisid).parent().parent().children('.4').html();
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('lblpayto').innerHTML = name;
            document.getElementById('lbldate').innerHTML = date;
            document.getElementById('lblaccountno').innerHTML = accountno;
            document.getElementById('lblaccounttype').innerHTML = accounttype;
            var data = { 'op': 'get_paymentsub_details', 'sno': sno };
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
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Head Of Account</th><th scope="col"></th><th scope="col">Ammount</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].headofaccount + '</th>';
                results += '<th scope="row" class="2" style="text-align:center;"></th>';
                results += '<th scope="row" class="3" style="text-align:center;">' + msg[i].totalamount + '</th>';
                results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
        }
        function save_approvalpayment_click(msg) {
            var sno = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById("btn_approve").value;
            var data = { 'op': 'updtae_approvalpayment_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_payments_details();
                    $('#myModal').modal('hide');
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function save_rejectpayment_click(msg) {
            var sno = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById("btn_reject").value;
            var data = { 'op': 'updtae_approvalpayment_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_payments_details();
                    $('#myModal').modal('hide');
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Approval Payments <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Approval Payments</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Approval Payments Details
                </h3>
            </div>
            <div class="box-body">
                <div id="div_Deptdata">
                </div>
            </div>
            
            <div id="myModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            &times;</button>
                        <h4 class="modal-title">
                            Pay ment Details</h4>
                    </div>
                    <div class="modal-body">
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
                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Date :</label>
                            </td>
                            <td>
                                <label id="lbldate"></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                   Account No :
                                </label>
                            </td>
                            <td>
                                <label id="lblaccountno"></label>
                            </td>
                       
                            <td>
                                <label>
                                    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Account Type :</label>
                            </td>
                            <td>
                                <label id="lblaccounttype"></label>
                            </td>
                           
                        </tr>
                        <tr>
                            <td colspan="4">
                                <div id="divHeadAcount">
                                </div>
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="lbl_sno"></label>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_approve" type="button" class="btn btn-success" name="submit" value='Approve'
                                    onclick="save_approvalpayment_click()" />
                                <input id='btn_reject' type="button" class="btn btn-danger" name="Close" value='Reject'
                                    onclick="save_rejectpayment_click()" />
                            </td>
                        </tr>
                    </table>
                    </div>
                    <div class="modal-footer">
                        <button id="btnaclose" type="button" class="btn btn-default" data-dismiss="modal">
                            Close</button>
                    </div>
                </div>
            </div>
        </div>
        </div>
    </section>
</asp:Content>
