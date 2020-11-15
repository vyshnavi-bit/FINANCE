<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Debit_Note_Entry.aspx.cs" Inherits="Sample_debit_entry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_debit_note();
            get_party_details();
            get_primary_group();
            get_party_code_det();
            get_trans_details();
            get_fin_yr_det();
            get_headofaccount_details();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
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

        function get_fin_yr_det() {
            var data = { 'op': 'get_financial_year' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_fin_yr_det(msg);
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
        function fill_fin_yr_det(msg)
        {
            for (i = 0; i < msg.length; i++) {
                if (msg[i].currentyear == "true") {
                    document.getElementById('fin_yr').value = msg[i].year;
                }
            }
        }
        var shortdes2 = [];
        function get_primary_group() {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg) {
                if (msg) {
                    shortdes2 = msg;
                    var GroupCodeList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var groupshortdesc = msg[i].groupshortdesc;
                        GroupCodeList.push(groupshortdesc);
                    }
                    $('#slct_grp_ldgr').autocomplete({
                        source: GroupCodeList,
                        change: GroupCodechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function GroupCodechange() {
            var groupshortdesc = document.getElementById('slct_grp_ldgr').value;
            for (var i = 0; i < shortdes2.length; i++) {
                if (groupshortdesc == shortdes2[i].groupshortdesc) {
                    document.getElementById('txt_gl_desc').value = shortdes2[i].groupcode;
                    document.getElementById('txt_gl_sno').value = shortdes2[i].sno;
                }
            }
        }
        var shortdes1 = [];
        function get_party_details() {
            var data = { 'op': 'get_party_type_details' };
            var s = function (msg) {
                if (msg) {
                    shortdes1 = msg;
                    var PartyTypeList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var SHORT_DESC = msg[i].SHORT_DESC;
                        PartyTypeList.push(SHORT_DESC);
                    }
                    $('#slct_party_tp').autocomplete({
                        source: PartyTypeList,
                        change: PartyTypechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function PartyTypechange() {
            var SHORT_DESC = document.getElementById('slct_party_tp').value;
            for (var i = 0; i < shortdes1.length; i++) {
                if (SHORT_DESC == shortdes1[i].SHORT_DESC) {
                    document.getElementById('txt_party_tp_desc').value = shortdes1[i].PARTY_TP;
                    document.getElementById('txt_party_tp_sno').value = shortdes1[i].sno;
                }
            }
        }
        var shortdes = [];
        function get_party_code_det() {
            var data = { 'op': 'get_party_master' };
            var s = function (msg) {
                if (msg) {
                    shortdes = msg;
                    var PartyNameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var party_name = msg[i].party_name;
                        PartyNameList.push(party_name);
                    }
                    $('#slct_party_name').autocomplete({
                        source: PartyNameList,
                        change: PartyNamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function PartyNamechange() {
            var party_name = document.getElementById('slct_party_name').value;
            for (var i = 0; i < shortdes.length; i++) {
                if (party_name == shortdes[i].party_name) {
                    document.getElementById('txt_party_cd').value = shortdes[i].party_code;
                    document.getElementById('txt_party_cd_sno').value = shortdes[i].sno;
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
                    $('#txt_cre_vou').autocomplete({
                        source: AccountNameList,
                        change: AccountNamechange,
                        autoFocus: true
                    });
                    $('#txt_deb_vou').autocomplete({
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
        function SubAccountNamechange() {
            var AccountName = document.getElementById('txt_deb_vou').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_sub_head').value = AccountNameDetails[i].sno;
                }
            }
        }
        function AccountNamechange() {
            var AccountName = document.getElementById('txt_cre_vou').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_head').value = AccountNameDetails[i].sno;
                }
            }
        }
        var shortdes_vou = [];
        function get_trans_details() {
            var data = { 'op': 'get_transaction_type' };
            var s = function (msg) {
                if (msg) {
                    shortdes_vou = msg;
                    var VoucherTypeList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var transactiontype = msg[i].transactiontype;
                        VoucherTypeList.push(transactiontype);
                    }
                    $('#slct_vou').autocomplete({
                        source: VoucherTypeList,
                        change: VoucherTypechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }

        function VoucherTypechange() {
            var transactiontype = document.getElementById('slct_vou').value;
            for (var i = 0; i < shortdes_vou.length; i++) {
                if (transactiontype == shortdes_vou[i].transactiontype) {
                    document.getElementById('txt_vou_sno').value = shortdes_vou[i].sno;
                }
            }
        }

        function save_debit_note() {
            var trans_dt = document.getElementById('txt_trans_dt').value;
            if (trans_dt == "") {
                alert("Please Enter Transaction Date");
                return false;
            }
            var fin_yr = document.getElementById('fin_yr').value;
            if (fin_yr == "") {
                alert("Please Select Financial Year");
                return false;
            }
            var gl_code = document.getElementById('txt_gl_sno').value;
            if (gl_code == "") {
                alert("Please Enter Group Ledger");
                return false;
            }
            var party_tp = document.getElementById('txt_party_tp_sno').value;
            if (party_tp == "") {
                alert("Please Enter Party Type");
                return false;
            }
            var party_cd = document.getElementById('txt_party_cd_sno').value;
            if (party_cd == "") {
                alert("Please Enter Party Code");
                return false;
            }
            var inv_no = document.getElementById('txt_inv_no').value;
            if (inv_no == "") {
                alert("Please Enter Invoice No");
                return false;
            }
            var inv_dt = document.getElementById('txt_inv_dt').value;
            if (inv_dt == "") {
                alert("Please Enter Invoice Date");
                return false;
            }
            var inv_amt = document.getElementById('txt_inv_amt').value;
            if (inv_amt == "") {
                alert("Please Enter Invoice Amount");
                return false;
            }
            var vou_tp = document.getElementById('txt_vou_sno').value;
            if (vou_tp == "") {
                alert("Please Enter Voucher Type");
                return false;
            }
            var deb_acc = document.getElementById('txt_sub_head').value;
            if (deb_acc == "") {
                alert("Please Enter Debitor Name");
                return false;
            }
            var deb_amt = document.getElementById('txt_amt_deb').value;
            if (deb_amt == "") {
                alert("Please Enter Debitor Amount");
                return false;
            }
            var cre_acc = document.getElementById('txt_head').value;
            if (cre_acc == "") {
                alert("Please Enter Creditor Name");
                return false;
            }
            var cre_amt = document.getElementById('txt_amt_cre').value;
            if (cre_amt == "") {
                alert("Please Enter Creditor Amount");
                return false;
            }
            var remarks = document.getElementById('txtRemarks').value;
            var sno = document.getElementById('txtsno').value;
            var btn_save = document.getElementById('btn_save').value;

            var data = { 'op': 'save_debit_entry_details', 'sno': sno, 'trans_dt': trans_dt, 'fin_yr': fin_yr, 'gl_code': gl_code, 'party_tp': party_tp, 'party_cd': party_cd, 'inv_no': inv_no, 'inv_dt': inv_dt, 'inv_amt': inv_amt, 'vou_tp': vou_tp, 'deb_acc': deb_acc, 'deb_amt': deb_amt, 'cre_acc': cre_acc, 'cre_amt': cre_amt, 'remarks': remarks, 'btn_save': btn_save };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        clear_debit_note();
                        get_debit_note();

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
        function get_debit_note() {
            var data = { 'op': 'get_debit_entry_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_credit_details(msg);
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
        function fill_credit_details(msg) {
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Transaction Date</th><th scope="col">Financial Year</th><th scope="col">Group Ledger</th><th scope="col">Party Type</th><th scope="col">Party Code</th><th scope="col">Invoice No</th><th scope="col">Invoice Date</th><th scope="col">Invoice Amount</th><th scope="col">Voucher Type</th><th scope="col">Credit Account</th><th scope="col">Credit Amount</th><th scope="col">Debit Account</th><th scope="col">Debit Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="update(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="Transaction Date" class="15" >' + msg[i].trans_dt + '</td>';
                results += '<td data-title="Financial Year" class="16" >' + msg[i].fin_yr + '</td>';
                results += '<td style="display:none;" data-title="Financial Year" class="17" >' + msg[i].fin_yr1 + '</td>';
                results += '<td style="display:none;" data-title="Group Ledger" class="1" >' + msg[i].gl_code + '</td>';
                results += '<td data-title="Group Ledger" class="25" >' + msg[i].gl_code_name + '</td>';
                results += '<td style="display:none;" data-title="Group Ledger" class="18" >' + msg[i].gl_code1 + '</td>';
                results += '<td data-title="Party Type" class="14">' + msg[i].party_tp + '</td>';
                results += '<td style="display:none;" data-title="Party Type" class="26">' + msg[i].party_tp_desc + '</td>';
                results += '<td style="display:none;" data-title="Party Type" class="19" >' + msg[i].party_tp1 + '</td>';
                results += '<td  data-title="Party Name" class="2">' + msg[i].party_cd + '</td>';
                results += '<td style="display:none;" data-title="Party Code" class="20">' + msg[i].party_cd1 + '</td>';
                results += '<td style="display:none;" data-title="" class="24">' + msg[i].party_name + '</td>';
                results += '<td data-title="Invoice No" class="3">' + msg[i].inv_no + '</td>';
                results += '<td data-title="Invoice Date" class="4">' + msg[i].inv_dt + '</td>';
                results += '<td data-title="Invoice Amount" class="6">' + msg[i].inv_amt + '</td>';
                results += '<td data-title="Voucher Type" class="7">' + msg[i].vou_tp + '</td>';
                results += '<td style="display:none;" data-title="Voucher Type" class="21">' + msg[i].vou_tp1 + '</td>';
                results += '<td data-title="Credit Account" class="10">' + msg[i].cre_acc + '</td>';
                results += '<td style="display:none;" data-title="Credit Account" class="23">' + msg[i].cre_acc1 + '</td>';
                results += '<td data-title="Credit Amount" class="11">' + msg[i].cre_amt + '</td>';
                results += '<td data-title="Debit Account" class="8">' + msg[i].deb_acc + '</td>';
                results += '<td style="display:none;" data-title="Debit Account" class="22">' + msg[i].deb_acc1 + '</td>';
                results += '<td data-title="Debit Amount" class="9">' + msg[i].deb_amt + '</td>';
                results += '<td data-title="Remarks" class="12">' + msg[i].remarks + '</td>';
                results += '<td style="display:none;" data-title="sno" class="13">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_debit_note").html(results);
        }
        function update(thisid) {
            var trans_dt = $(thisid).parent().parent().children('.15').html();
            var fin_yr = $(thisid).parent().parent().children('.16').html();
            var fin_yr1 = $(thisid).parent().parent().children('.17').html();
            var gl_code = $(thisid).parent().parent().children('.1').html();
            var gl_code1 = $(thisid).parent().parent().children('.18').html();
            var gl_code_name = $(thisid).parent().parent().children('.25').html();
            var party_cd = $(thisid).parent().parent().children('.2').html();
            var party_cd1 = $(thisid).parent().parent().children('.20').html();
            var party_name = $(thisid).parent().parent().children('.24').html();
            var inv_no = $(thisid).parent().parent().children('.3').html();
            var party_tp = $(thisid).parent().parent().children('.14').html();
            var party_tp_desc = $(thisid).parent().parent().children('.26').html();
            var party_tp1 = $(thisid).parent().parent().children('.19').html();
            var inv_dt = $(thisid).parent().parent().children('.4').html();
            var inv_amt = $(thisid).parent().parent().children('.6').html(); //.toString[mm / dd / yyyy]
            var vou_tp = $(thisid).parent().parent().children('.7').html();
            var vou_tp1 = $(thisid).parent().parent().children('.21').html();
            var deb_acc = $(thisid).parent().parent().children('.8').html();
            var deb_acc1 = $(thisid).parent().parent().children('.22').html();
            var deb_amt = $(thisid).parent().parent().children('.9').html();
            var cre_acc = $(thisid).parent().parent().children('.10').html();
            var cre_acc1 = $(thisid).parent().parent().children('.23').html();
            var cre_amt = $(thisid).parent().parent().children('.11').html();
            var remarks = $(thisid).parent().parent().children('.12').html();
            var sno = $(thisid).parent().parent().children('.13').html();

            document.getElementById('txt_trans_dt').value = trans_dt;
            document.getElementById('fin_yr').value = fin_yr1;
            document.getElementById('slct_grp_ldgr').value = gl_code_name;
            document.getElementById('txt_gl_desc').value = gl_code;
            document.getElementById('txt_gl_sno').value = gl_code1;
            document.getElementById('slct_party_name').value = party_name;
            document.getElementById('txt_party_cd').value = party_cd;
            document.getElementById('txt_party_cd_sno').value = party_cd1;
            document.getElementById('txt_inv_no').value = inv_no;
            document.getElementById('slct_party_tp').value = party_tp;
            document.getElementById('txt_party_tp_desc').value = party_tp_desc;
            document.getElementById('txt_party_tp_sno').value = party_tp1;
            document.getElementById('txt_inv_dt').value = inv_dt;
            document.getElementById('txt_inv_amt').value = inv_amt;
            document.getElementById('slct_vou').value = vou_tp;
            document.getElementById('txt_vou_sno').value = vou_tp1;
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('txt_deb_vou').value = deb_acc;
            document.getElementById('txt_head').value = deb_acc1;
            document.getElementById('txt_amt_deb').value = deb_amt;
            document.getElementById('txt_cre_vou').value = cre_acc;
            document.getElementById('txt_sub_head').value = cre_acc1;
            document.getElementById('txt_amt_cre').value = cre_amt;
            document.getElementById('txtsno').value = sno;
            document.getElementById('btn_save').value = "Modify";
        }
        function clear_debit_note() {
            document.getElementById('txt_trans_dt').value = "";
            document.getElementById('fin_yr').selectedIndex = 0;
            document.getElementById('slct_grp_ldgr').value = "";
            document.getElementById('txt_gl_desc').value = "";
            document.getElementById('txt_gl_sno').value = "";
            document.getElementById('slct_party_name').value = "";
            document.getElementById('txt_party_cd').value = "";
            document.getElementById('txt_party_cd_sno').value = "";
            document.getElementById('txt_inv_no').value = "";
            document.getElementById('slct_party_tp').value = "";
            document.getElementById('txt_party_tp_sno').value = "";
            document.getElementById('txt_party_tp_desc').value = "";
            document.getElementById('txt_inv_dt').value = "";
            document.getElementById('txt_inv_amt').value = "";
            document.getElementById('slct_vou').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('txt_deb_vou').value = "";
            document.getElementById('txt_head').value = "";
            document.getElementById('txt_amt_deb').value = "";
            document.getElementById('txt_cre_vou').value = "";
            document.getElementById('txt_sub_head').value = "";
            document.getElementById('txt_amt_cre').value = "";
            document.getElementById('txtsno').value = "";
            document.getElementById('btn_save').value = "Save";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Debit Note Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Debit Note Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Debit Note Details
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
                                    Transaction Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_trans_dt" class="form-control" type="date" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Financial Year</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="fin_yr" class="form-control" readonly></input>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Group Ledger</label>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="slct_grp_ldgr"></select>--%>
                                <input id="slct_grp_ldgr" class="form-control" type="text" placeholder="Enter Group Ledger"/>
                                <input id="txt_gl_sno" class="form-control" type="text" style="display:none"/>
                            </td>
                            <td style="width: 5px;">
                            <td style="height: 40px;">
                                <input id="txt_gl_desc" class="form-control" type="text" readonly="readonly" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Party Type</label>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="slct_party_tp"></select>--%>
                                <input id="slct_party_tp" class="form-control" type="text" placeholder="Enter  Party Type"/>
                                <input id="txt_party_tp_sno" class="form-control" type="text" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            <td style="height: 40px;">
                                <input id="txt_party_tp_desc" class="form-control" type="text" readonly="readonly" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Party Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="slct_party_name" class="form-control" type="text" placeholder="Enter Party Name"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Party Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_party_cd" class="form-control" type="text" readonly="readonly" placeholder="Enter Party Code"/>
                                <input id="txt_party_cd_sno" class="form-control" type="text" style="display:none" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Invoice No</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_inv_no" class="form-control" type="text" placeholder="Enter Invoice No"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Invoice Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_inv_dt" class="form-control" type="date" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Invoice Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_inv_amt" class="form-control" type="text" placeholder="Enter Invoice Amount"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Voucher Type</label>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="slct_vou"></select>--%>
                                <input id="slct_vou" class="form-control" type="text" placeholder="Enter Voucher type"/>
                                <input id="txt_vou_sno" class="form-control" type="text" style="display:none" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Credit Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_cre_vou" type="text" class="form-control" placeholder="Enter credit account" />
                                <input id="txt_cre_vou_sno" type="text" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_amt_cre" class="form-control" type="text" placeholder="Enter Amount" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <%--<td>
                                <input id="btn_add_cre" type="button" onclick="BtnAddClick();" class="btn btn-success"
                                    name="Add" value='Add' />
                            </td>--%>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <div id="divHeadAcount">
                                </div>
                            </td>
                        </tr>
                        <%--<tr>
                            <td>
                                <label>
                                    Total Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_tot_amt_cre" class="form-control" type="text" readonly />
                            </td>
                        </tr>--%>
                        <tr>
                            <td>
                                <label>
                                    Debit Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_deb_vou" type="text" class="form-control" placeholder="Enter Debit account" />
                                <input id="txt_deb_vou_sno" type="text" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_amt_deb" class="form-control" type="text" placeholder="Enter Amount" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <%--<td>
                                <input id="btn_add_deb" type="button" onclick="Btn_subAddClick();" class="btn btn-success"
                                    name="Add" value='Add' />
                            </td>--%>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <div id="div_subHeadAcount">
                                </div>
                            </td>
                        </tr>
                        <%--<tr>
                            <td>
                                <label>
                                    Total Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_tot_amt_deb" class="form-control" type="text" readonly />
                            </td>
                        </tr>--%>
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
                        <%--<tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_gen" type="button" class="btn btn-success" name="submit" value='Generate'
                                    onclick="generate_voucher_invoice()" />
                        </tr>--%>
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_debit_note()" />
                                <input id='btn_clear' type="button" class="btn btn-danger" name="Clear" value='Clear'
                                    onclick="clear_debit_note()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
                <div id="div_debit_note">
                </div>
            </div>
        </div>
    </section>
</asp:Content>

