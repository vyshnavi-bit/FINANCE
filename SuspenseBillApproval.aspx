<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SuspenseBillApproval.aspx.cs" Inherits="SuspenseBillApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
        $(function () {
            get_suspensesub_details();
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
        function get_suspensesub_details()
        {
            var data = { 'op': 'get_suspensesub_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                    else {
                        var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
                        results += '<thead><tr><th scope="col">TransactionNo</th><th scope="col">Name</th><th scope="col">Total Amount</th><th scope="col">Date</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
                        results += '</table></div>';
                        $("#div_suspdata").html(results);
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
        function filldetails(msg)
        {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Transaction No</th><th scope="col">Transaction Date</th><th scope="col">Financial Year</th><th scope="col">Req No</th><th scope="col">Req Date</th><th scope="col">Req Amount</th><th scope="col">Section Code</th><th scope="col">Particulars</th><th scope="col">Actual Expenses</th><th scope="col">Balance Amount</th><th scope="col">Status</th></tr></thead></tbody>';
            suspsubentry = msg[0].suspsubentry;
            var billdetails = msg[0].suspbill;
            for (var i = 0; i < billdetails.length; i++) {
                results += '<tr>';
                results += '<td data-title="transactionno" class="2">' + billdetails[i].transactionno + '</td>';
                results += '<td data-title="transactiondate" class="3">' + billdetails[i].transactiondate + '</td>';
                results += '<td data-title="financialyear" class="4" >' + billdetails[i].financialyear + '</td>';
               // results += '<td data-title="natureofwork" class="5" >' + billdetails[i].natureofwork + '</td>';
                //results += '<td data-title="designationcode" class="6" >' + billdetails[i].designationcode + '</td>';
               // results += '<td data-title="empcode" class="8" >' + billdetails[i].empcode + '</td>';
                results += '<td data-title="suspreqno" class="10" >' + billdetails[i].suspreqno + '</td>';
                results += '<td data-title="reqdate" class="11" >' + billdetails[i].reqdate + '</td>';
                results += '<td data-title="reqamount" class="15" >' + billdetails[i].reqamount + '</td>';
                //results += '<td data-title="deptcode" class="16" >' + billdetails[i].deptcode + '</td>';
                results += '<td data-title="sectioncode" class="18">' + billdetails[i].sectioncode + '</td>';
                results += '<td data-title="particulars"  class="19">' + billdetails[i].particulars + '</td>';
                results += '<td data-title="actualexpenses" class="20" >' + billdetails[i].actualexpenses + '</td>';
                results += '<td data-title="balamount"  class="22">' + billdetails[i].balamount + '</td>';
                results += '<td data-title="balamount"  class="21">' + billdetails[i].status + '</td>';
                results += '<td><input id="btn_poplate" type="button"  data-toggle="modal" data-target="#myModal" onclick="getme(this)" name="submit" class="btn btn-primary" value="View"/></td>';
                results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + billdetails[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_suspdata").html(results);
        }
        var billsno = 0;
        function getme(thisid)
        {
            var sno = $(thisid).parent().parent().children('.14').html();
            var transactionno = $(thisid).parent().parent().children('.2').html();
            var transactiondate = $(thisid).parent().parent().children('.3').html();
            var reqno = $(thisid).parent().parent().children('.10').html();
            var balamount = $(thisid).parent().parent().children('.7').html();
            document.getElementById('lbl_sno').value = sno;

            billsno = sno;
            var table = document.getElementById("suspensetable");
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            var results = '<div  style="overflow:auto;"><table ID="suspensetable" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GRNNo</th><th scope="col">BillNo</th><th scope="col">BillDate</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < suspsubentry.length; i++) {
                if (sno == suspsubentry[i].refno) {
                    results += '<tr><td data-title="Sno">' + k + '</td>';
                    results += '<td data-title="grnno">' + suspsubentry[i].grnno + '</td>';
                    results += '<td data-title="billno">' + suspsubentry[i].billno + '</td>';
                    results += '<td data-title="billdate">' + suspsubentry[i].billdate + '</td>';
                   // results += '<td data-title="Item">' + suspsubentry[i].Item + '</td>';
                    //results += '<th data-title="Quantity">' + suspsubentry[i].Quantity + '</td>';
                   // results += '<th data-title="Rate">' + suspsubentry[i].Rate + '</span>';
                    results += '<th data-title="Amount">' + suspsubentry[i].Amount + '</span>';
                    results += '<th data-title="Remarks">' + suspsubentry[i].Remarks + '</span>';
                    results += '<th data-title="refno" style="display:none"><span class="7" id="txt_sub_sno" value="' + suspsubentry[i].refno + '"></span></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
        }
        function save_approvalbill_click(msg)
        {
            var sno = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById("btn_approve").value;
            var data = { 'op': 'update_suspensebill_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg)
            {
                if (msg) {
                    alert(msg);
                    get_suspensesub_details();
                    $('#myModal').modal('hide');
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
        function save_rejectbill_click(msg)
        {
            var sno = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById("btn_reject").value;
            var data = { 'op': 'update_suspensebill_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg)
            {
                if (msg) {
                    alert(msg);
                    get_suspensesub_details();
                    $('#myModal').modal('hide');
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
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Suspense Bill Approval
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Suspense Bill </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Suspense Bill Approval
                </h3>
            </div>
            <div class="box-body">
                <div id="div_suspdata">
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
                            Suspense Bill Details</h4>
                    </div>
                    <div class="modal-body">
                       <table align="center">
                       <tr>
                            <td colspan="2">
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
                                    onclick="save_approvalbill_click()" />
                                <input id='btn_reject' type="button" class="btn btn-danger" name="Close" value='Reject'
                                    onclick="save_rejectbill_click()" />
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

