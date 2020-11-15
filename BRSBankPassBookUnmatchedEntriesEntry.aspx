<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="BRSBankPassBookUnmatchedEntriesEntry.aspx.cs" Inherits="BRSBankPassBookUnmatchedEntriesEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        forclearall();
        get_bank_details();
        get_bankpassbookunmatched_entry();
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd
        }
        if (mm < 10) {
            mm = '0' + mm
        }
        var hrs = today.getHours();
        var mnts = today.getMinutes();
        $('#txt_entrydate').val(yyyy + '-' + mm + '-' + dd);
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

    function save_bankpassbookunmatched_entry() {
        var bankcode = document.getElementById('txt_bankcode_sno').value;
        var bankname = document.getElementById('txt_bankname').value;
        var entrydate = document.getElementById('txt_entrydate').value;
        var chequedd = document.getElementById('txt_chequedd').value;
        var chequeddno = document.getElementById('tct_chequeddno').value;
        var amount = document.getElementById('txt_amount').value;
        var debitcradit = document.getElementById('txt_debitcradit').value;
        var conform = document.getElementById('txt_conform').value;
        var remarks = document.getElementById('txt_remarks').value;
        if (bankcode == "") {
            alert("Enter bank code ");
            return false;
        }
        if (entrydate == "") {
            alert("Enter entry date");
            return false;
        }
        if (chequedd == "") {
            alert("Enter cheque dd");
            return false;
        }
        if (chequeddno == "") {
            alert("Enter cheque dd no");
            return false;
        }
        if (amount == "") {
            alert("Enter amount");
            return false;
        }
        if (debitcradit == "") {
            alert("Enter debit cradit");
            return false;
        }
        if (conform == "") {
            alert("Enter conform");
            return false;
        }
        var sno = document.getElementById('txt_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_bankpassbookunmatched_entry', 'bankcode': bankcode, 'bankname': bankname, 'entrydate': entrydate, 'chequedd': chequedd, 'chequeddno': chequeddno, 'amount': amount, 'debitcradit': debitcradit, 'conform': conform, 'remarks': remarks, 'sno': sno, 'btnval': btnval };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    forclearall();
                    get_bankpassbookunmatched_entry();
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
        document.getElementById('txt_entrydate').value = "";
        document.getElementById('txt_chequedd').selectedIndex = 0;
        document.getElementById('tct_chequeddno').value = "";
        document.getElementById('txt_amount').value = "";
        document.getElementById('txt_debitcradit').selectedIndex = 0;
        document.getElementById('txt_conform').selectedIndex = 0;
        document.getElementById('txt_remarks').value = "";
        document.getElementById('btn_save').value = "Save";
    }
    function isNumber(evt) {
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode != 46 && charCode > 31
            && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }

    function get_bankpassbookunmatched_entry() {
        var data = { 'op': 'get_bankpassbookunmatched_entry' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillbankpassbookunmatcheddetails(msg);

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
    function fillbankpassbookunmatcheddetails(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">BankCode</th><th scope="col">BankName</th><th scope="col">EntryDate</th><th scope="col">Cheque/DD</th><th scope="col">DDNumber</th><th scope="col">ChequeNumber</th><th scope="col">Amount</th><th scope="col">DebitCradit</th><th scope="col">Status</th><th scope="col">Remarks</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td style="display:none"  data-title="code" class="1" >' + msg[i].bankid + '</td>';
            results += '<td data-title="code" class="2">' + msg[i].bankcode + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].bankname + '</td>';
            results += '<td data-title="code" class="4">' + msg[i].entrydate + '</td>';
            results += '<td data-title="code" class="5">' + msg[i].chequedd + '</td>';
            results += '<td style="display:none" data-title="code"  class="6">' + msg[i].chequedd1 + '</td>';
            results += '<td  data-title="code" class="7">' + msg[i].chequeddno + '</td>';
            results += '<td  data-title="code" class="8">' + msg[i].chequeddno1 + '</td>';

            results += '<td data-title="code" class="9">' + msg[i].amount + '</td>';
            results += '<td  data-title="code" class="10">' + msg[i].debitcradit + '</td>';
            results += '<td style="display:none" data-title="code" class="11">' + msg[i].debitcradit1 + '</td>';
            results += '<td data-title="code"  class="12">' + msg[i].conform + '</td>';
            results += '<td style="display:none"  data-title="code" class="13">' + msg[i].conform1 + '</td>';
            results += '<td   data-title="code" class="14">' + msg[i].remarks + '</td>';

            results += '<td style="display:none" class="15">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_data").html(results);
    }
    function getme(thisid) {
        var bankid = $(thisid).parent().parent().children('.1').html();
        var bankcode = $(thisid).parent().parent().children('.2').html();
        var bankname = $(thisid).parent().parent().children('.3').html();
        var entrydate = $(thisid).parent().parent().children('.4').html();
        var chequedd = $(thisid).parent().parent().children('.5').html();
        var chequedd1 = $(thisid).parent().parent().children('.6').html();
        var chequeddno = $(thisid).parent().parent().children('.7').html();
        var chequeddno1 = $(thisid).parent().parent().children('.8').html();
        var amount = $(thisid).parent().parent().children('.9').html();
        var debitcradit = $(thisid).parent().parent().children('.10').html();
        var debitcradit1 = $(thisid).parent().parent().children('.11').html();
        var conform = $(thisid).parent().parent().children('.12').html();
        var conform1 = $(thisid).parent().parent().children('.13').html();
        var remarks = $(thisid).parent().parent().children('.14').html();
        var sno = $(thisid).parent().parent().children('.15').html();

        document.getElementById('txt_bankcode').value = bankcode;
        document.getElementById('txt_bankcode_sno').value = bankid;
        document.getElementById('txt_bankname').value = bankname;
        document.getElementById('txt_entrydate').value = entrydate;
        document.getElementById('txt_chequedd').value = chequedd1;
        if (chequeddno !== "") {
            document.getElementById('tct_chequeddno').value = chequeddno;
        }
        else if (chequeddno1 !== "") {
            document.getElementById('tct_chequeddno').value = chequeddno1;
        }
        document.getElementById('txt_amount').value = amount;
        document.getElementById('txt_debitcradit').value = debitcradit1;
        document.getElementById('txt_conform').value = conform1;
        document.getElementById('txt_remarks').value = remarks;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('txt_sno').value = sno;
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            BRS Bank Pass Book Unmatched Entries Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transaction</a></li>
            <li><a href="#">BRS Bank Pass Book Unmatched Entries Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>BRS Bank Pass Book Unmatched Entries Entry
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
                                    Entry Date</label>
                                    <span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_entrydate" class="form-control" type="date" />
                            </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Cheque/DD</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td style="height: 40px;">
                                    <select id="txt_chequedd" class="form-control">
                                        <option value="">Select</option>
                                        <option value="C">Cheque</option>
                                        <option value="D">DD</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Cheque/DD No</label>
                                    <span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <input id="tct_chequeddno" class="form-control" type="text" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Amount</label>
                                    <span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_amount" class="form-control" type="text" onkeypress="return isNumber(event)"/>
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
                            <tr>
                                <td>
                                    <label>
                                       Confirm</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td style="height: 40px;">
                                    <select id="txt_conform" class="form-control">
                                        <option value="">Select</option>
                                        <option value="P">Pending </option>
                                        <option value="C">Clear</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_remarks" class="form-control" type="text" />
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
                                    onclick="save_bankpassbookunmatched_entry()" />
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