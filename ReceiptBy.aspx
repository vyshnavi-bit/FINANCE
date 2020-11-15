<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ReceiptBy.aspx.cs" Inherits="ReceiptBy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_bank_details();
            GetReceiptDetails();
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
        function showdesign() {
            $("#div_Receipt").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            forclearall();
        }
        function canceldetails() {
            $("#div_Receipt").show();
            $("#fillform").hide();
            $('#showlogs').show();
            forclearall();
        }
        function save_receipt_entry_click() {
            var name = document.getElementById('txt_payment').value;
            if (name == "") {
                alert("Enter name ");
                return false;

            }
            var acno = document.getElementById('txt_account').value;
            if (acno == "") {
                alert("Enter acno ");
                return false;
            }
            var ifsccode = document.getElementById('txt_IFC').value;
            if (ifsccode == "") {
                alert("Enter ifsccode ");
                return false;
            }
            var amount = document.getElementById('txtamount').value;
            if (amount == "") {
                alert("Enter amount ");
                return false;
            }
            var remarks = document.getElementById('txtRemarks').value;
            if (remarks == "") {
                alert("Enter Remaks ");
                return false;
            }
            var bankid = document.getElementById("ddlbank").value;
            if (bankid == "") {

                alert("select Bank name");
                return false;
            }

            var btnval = document.getElementById('btn_save').value;
            var sno = document.getElementById('lbl_sno').value;

            var data = { 'operation': 'save_receipt_entry_click', 'name': name, 'acno': acno, 'ifsccode': ifsccode, 'amount': amount, 'remarks': remarks, 'bankid': bankid, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        GetReceiptDetails();
                        $('#div_Receipt').show();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
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
        function get_bank_details() {
            var data = { 'operation': 'get_bank_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbank(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbank(msg) {
            var ddlbank = document.getElementById('ddlbank');
            var length = ddlbank.options.length;
            ddlbank.options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].name != null) {
                    var opt = document.createElement('option');
                    opt.innerHTML = msg[i].name;
                    opt.value = msg[i].sno;
                    ddlbank.appendChild(opt);
                }
            }
        }
        function GetReceiptDetails() {
            var data = { 'operation': 'GetReceiptDetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillreceipt(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillreceipt(msg) {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Name</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-success" value="Edit" /></td>';
                results += '<td scope="row" class="1" >' + msg[i].name + '</td>';
                results += '<td class="3">' + msg[i].amount + '</td>';
                results += '<td  class="4">' + msg[i].remarks + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].paytype + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].bankid + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].acno + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].ifsccode + '</td>';
                // results += '<td style="display:none" class="9">' + msg[i].entry_by + '</td>';
                results += '<td style="display:none" data-title="status" class="10">' + msg[i].status + '</td>';
                results += '<td style="display:none" class="11">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Receipt").html(results);
        }
        function getme(thisid) {
            var name = $(thisid).parent().parent().children('.1').html();
            var headsno = $(thisid).parent().parent().children('.2').html();
            var amount = $(thisid).parent().parent().children('.3').html();
            var remarks = $(thisid).parent().parent().children('.4').html();
            var paytype = $(thisid).parent().parent().children('.5').html();
            var bankid = $(thisid).parent().parent().children('.6').html();
            var acno = $(thisid).parent().parent().children('.7').html();
            var ifsccode = $(thisid).parent().parent().children('.8').html();
            var entry_by = $(thisid).parent().parent().children('.9').html();
            var sno = $(thisid).parent().parent().children('.11').html();
            document.getElementById('txt_payment').value = name;
            document.getElementById('txt_account').value = acno;
            document.getElementById('txt_IFC').value = ifsccode;
            document.getElementById('txtamount').value = amount;
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('ddlbank').value = bankid;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
            $("#div_Receipt").hide();
            $("#fillform").show();
            $('#showlogs').hide();
        }
        function forclearall() {
            document.getElementById('txt_payment').value = "";
            document.getElementById('txt_account').value = "";
            document.getElementById('txt_IFC').value = "";
            document.getElementById('txtamount').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('ddlbank').selectedIndex = 0;
            document.getElementById('btn_save').value = "Save";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Receipt Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Receipt Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Receipt Entry Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="right">
                    <input id="btn_Receipt" type="button" name="submit" value='AddReceipt' class="btn btn-success"
                        onclick="showdesign()" />
                </div>
                <div id="div_Receipt">
                </div>
                <div id='fillform' style="display: none;">
                    <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_payment" class="form-control" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Bank Name</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlbank" class="form-control">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    A/C Number</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_account" class="form-control" type="text" />
                            </td>
                            <td>
                                <label>
                                    IFSC code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_IFC" class="form-control" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtamount" class="form-control" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td colspan="2">
                                <textarea rows="5" cols="45" id="txtRemarks" class="form-control" maxlength="2000"
                                    placeholder="Enter Remarks"></textarea>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='save'
                                    onclick="save_receipt_entry_click()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="canceldetails()" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
