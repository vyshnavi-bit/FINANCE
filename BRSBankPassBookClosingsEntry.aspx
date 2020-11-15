<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BRSBankPassBookClosingsEntry.aspx.cs" Inherits="BRSBankPassBookClosingsEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_bank_details();
        forclearall();
        get_passbookclosing_entry();
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
    //var branchname = [];
    //function get_bank_details() {
    //    var data = { 'op': 'get_bank_details' };
    //    var s = function (msg) {
    //        if (msg) {
    //            if (msg.length > 0) {
    //                filldetails(msg);
    //                branchname = msg;
    //            }
    //        }
    //        else {
    //        }
    //    };
    //    var e = function (x, h, e) {
    //    };
    //    callHandler(data, s, e);
    //}
    //function filldetails(msg) {
    //    var data = document.getElementById('txt_bankcode');
    //    var length = data.options.length;
    //    document.getElementById('txt_bankcode').options.length = null;
    //    var opt = document.createElement('option');
    //    opt.innerHTML = "Select Bank Name";
    //    opt.value = "Select Bank Name";
    //    opt.setAttribute("selected", "selected");
    //    opt.setAttribute("disabled", "disabled");
    //    opt.setAttribute("class", "dispalynone");
    //    data.appendChild(opt);
    //    for (var i = 0; i < msg.length; i++) {
    //        if (msg[i].code != null) {
    //            var option = document.createElement('option');
    //            option.innerHTML = msg[i].code;
    //            option.value = msg[i].sno;
    //            data.appendChild(option);
    //        }
    //    }
    //}
    //function Getbankname(txt_bankcode) {
    //    var code = document.getElementById('txt_bankcode').value;
    //    for (var i = 0; i < branchname.length; i++) {
    //        if (code == branchname[i].sno) {
    //            document.getElementById('txt_bankname').value = branchname[i].name;
    //        }
    //    }
    //}

    var branchname = [];
    function get_bank_details() {
        var data = { 'op': 'get_bank_details' };
        var s = function (msg) {
            if (msg) {
                branchname = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].code;
                    empnameList.push(empname);
                }
                $('#txt_bankcode').autocomplete({
                    source: empnameList,
                    change: Getbankname,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Getbankname() {
        var empname = document.getElementById('txt_bankcode').value;
        for (var i = 0; i < branchname.length; i++) {
            if (empname == branchname[i].code) {
                document.getElementById('txt_bankname').value = branchname[i].name;
                document.getElementById('txt_bankcode_sno').value = branchname[i].sno;
            }
        }
    }

    function save_passbookclosing_entry() {
        var bankcode = document.getElementById('txt_bankcode_sno').value;
        var bankname = document.getElementById('txt_bankname').value;
        var closingbalncedate = document.getElementById('txt_closingbalncedate').value;
        var closingbalance = document.getElementById('txt_closingbalance').value;
        var debitcradit = document.getElementById('txt_debitcradit').value;
        if (bankcode == "") {
            alert("Enter bank code ");
            return false;
        }
        if (closingbalncedate == "") {
            alert("Enter closing balnce date ");
            return false;
        }
        if (closingbalance == "") {
            alert("Enter closing balance");
            return false;
        }
        var sno = document.getElementById('txt_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_passbookclosing_entry', 'bankcode': bankcode, 'bankname': bankname, 'closingbalncedate': closingbalncedate, 'closingbalance': closingbalance, 'debitcradit': debitcradit, 'sno': sno, 'btnval': btnval };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    forclearall();
                    get_passbookclosing_entry();
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
    function forclearall() {
        document.getElementById('txt_bankcode').value = "";
        document.getElementById('txt_bankcode_sno').value = "";
        document.getElementById('txt_bankname').value = "";
        document.getElementById('txt_closingbalncedate').value = "";
        document.getElementById('txt_closingbalance').value = "";
        document.getElementById('txt_debitcradit').selectedIndex = 0;
        document.getElementById('btn_save').value = "Save";
    }
    function get_passbookclosing_entry() {
        var data = { 'op': 'get_passbookclosing_entry' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillpassbookclosingdetails(msg);

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
    function fillpassbookclosingdetails(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">BankCode</th><th scope="col">BankName</th><th scope="col">ClosingBalnceDate</th><th scope="col">ClosingBalance</th><th scope="col">Debit/Cradit</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th style="display:none" scope="row" class="1" style="text-align:center;">' + msg[i].bankcode + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].bankid + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].bankname + '</td>';
            results += '<td data-title="code" class="4">' + msg[i].closingbalncedate + '</td>';
            results += '<td data-title="code" class="5">' + msg[i].closingbalance + '</td>';
            results += '<td data-title="code" class="6">' + msg[i].debitcradit + '</td>';
            results += '<th style="display:none" scope="row" class="7" style="text-align:center;">' + msg[i].debitcradit1 + '</th>';
            results += '<td style="display:none" class="8">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_data").html(results);
    }
    function getme(thisid) {
        var bankcode = $(thisid).parent().parent().children('.1').html();
        var bankid = $(thisid).parent().parent().children('.2').html();
        var bankname = $(thisid).parent().parent().children('.3').html();
        var closingbalncedate = $(thisid).parent().parent().children('.4').html();
        var closingbalance = $(thisid).parent().parent().children('.5').html();
        var debitcradit1 = $(thisid).parent().parent().children('.7').html();
        var sno = $(thisid).parent().parent().children('.8').html();

        document.getElementById('txt_bankcode').value = bankid;
        document.getElementById('txt_bankcode_sno').value = bankcode;
        document.getElementById('txt_bankname').value = bankname;
        document.getElementById('txt_closingbalncedate').value = closingbalncedate;
        document.getElementById('txt_closingbalance').value = closingbalance;
        document.getElementById('txt_debitcradit').value = debitcradit1;
        document.getElementById('txt_sno').value = sno;
        document.getElementById('btn_save').value = "Modify";
    }
    function isNumber(evt) {
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode != 46 && charCode > 31
            && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            BRS Bank Pass Book Closings Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">BRS Bank Pass Book Closings Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>BRS Bank Pass Book Closings Entry
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
                                    Bank code</label>
                                    <span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="txt_bankcode" class="form-control" onchange="Getbankname(this);" >
                                </select>--%>
                                <input id="txt_bankcode" type="text" class="form-control" onchange="Getbankname(this);" />
                                <input id="txt_bankcode_sno" type="text" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_bankname" class="form-control" type="text"  readonly/>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Closing Balance Date</label>
                                    <span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_closingbalncedate" class="form-control" type="date" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Closing Balance</label>
                                    <span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_closingbalance" class="form-control" type="text" placeholder= "Enter Closing Balance" onkeypress="return isNumber(event)"/>
                            </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Debit/Credit</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td style="height: 40px;">
                                    <select id="txt_debitcradit" class="form-control">
                                        <option value="">Select</option>
                                        <option value="D">Debit</option>
                                        <option value="C">Credit</option>
                                    </select>
                                </td>
                            </tr>
                            <tr style="display: none;">
                            <td>
                                <label id="txt_sno">
                                </label>
                            </td>
                            </tr>
                            </table>
                            <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_passbookclosing_entry()" />
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
    </section>
</asp:Content>

