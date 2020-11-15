<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Post-datedchequesentry.aspx.cs" Inherits="Post_datedchequesentry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        $("#div_cheque_entry").css("display", "block");
        get_Branch_details();
        get_party_master();
        get_bankaccount_details();
        get_post_datedcheques();
    });

    function show_entry_details()
    {
        $("#div_cheque_entry").css("display", "block");
        $("#div_cheque_status").css("display", "none");
        get_Branch_details();
        get_party_master();
        get_bankaccount_details();
        get_post_datedcheques();
    }

    function show_status_details() {
        $("#div_cheque_entry").css("display", "none");
        $("#div_cheque_status").css("display", "block");
        get_bankaccount_details();
        var date = new Date();
        var day = date.getDate();
        var month = date.getMonth() + 1;
        var year = date.getFullYear();
        if (month < 10) month = "0" + month;
        if (day < 10) day = "0" + day;
        today = year + "-" + month + "-" + day;
        $('#txt_date').val(today);
    }

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
    var branchnamearr = [];
    function get_Branch_details()
    {
        var data = { 'op': 'get_Branch_details' };
        var s = function (msg)
        {
            if (msg) {
                branchnamearr = msg;
                var branchList = [];
                for (var i = 0; i < msg.length; i++) {
                    var bcode = msg[i].branchname;
                    branchList.push(bcode);
                }
                $('#txt_branchcode').autocomplete({
                    source: branchList,
                    change: Getbranchname
                });
            }
        }
        var e = function (x, h, e)
        {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Getbranchname(txt_branchcode) {
        var brcode = document.getElementById('txt_branchcode').value;
        for (var i = 0; i < branchnamearr.length; i++) {
            if (brcode == branchnamearr[i].branchname) {
                document.getElementById('txt_branchname').value = branchnamearr[i].code;
                document.getElementById('txt_branchid').value = branchnamearr[i].branchid;
            }
        }
    }
    var short_desc = [];
    function get_party_master()
    {
        var data = { 'op': 'get_party_master' };
        var s = function (msg)
        {
            if (msg) {
                short_desc = msg;
                var partylist = [];
                for (var i = 0; i < msg.length; i++) {
                    var bcode = msg[i].party_name;
                    partylist.push(bcode);
                }
                $('#txt_partycode').autocomplete({
                    source: partylist,
                    change: Getpartyname
                });
            }
        }
        var e = function (x, h, e)
        {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Getpartyname(txt_partycode) {
        var code = document.getElementById('txt_partycode').value;
        for (var i = 0; i < short_desc.length; i++) {
            if (code == short_desc[i].party_name) {
                document.getElementById('txt_partyname').value = short_desc[i].party_code;
                document.getElementById('txt_prtyid').value = short_desc[i].sno;

            }
        }
    }
    var AccountNumber = [];
    function get_bankaccount_details()
    {
        var data = { 'op': 'get_bankaccount_details' };
        var s = function (msg)
        {
            if (msg) {
                AccountNumber = msg;
                var acclist = [];
                for (var i = 0; i < msg.length; i++) {
                    var bcode = msg[i].AccountNumber;
                    acclist.push(bcode);
                }
                $('#txt_acccode').autocomplete({
                    source: acclist,
                    change: Getbankname
                });
            }
        }
        var e = function (x, h, e)
        {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Getbankname(txt_acccode) {
        var code = document.getElementById('txt_acccode').value;
        for (var i = 0; i < AccountNumber.length; i++) {
            if (code == AccountNumber[i].AccountNumber) {
                document.getElementById('txt_des').value = AccountNumber[i].Accounttype;
                document.getElementById('txt_accid').value = AccountNumber[i].sno;
                document.getElementById('txt_drabank').value = AccountNumber[i].bankname;
            }
        }
    }
    function save_post_datedcheques() {
        var branchcode = document.getElementById('txt_branchcode').value;
        if (branchcode == "") {
            alert("Enter  branchcode");
            return false;
        }
        var branchname = document.getElementById('txt_branchname').value;
        var branchid = document.getElementById('txt_branchid').value; 
        var partycode = document.getElementById('txt_partycode').value;
        if (partycode == "") {
            alert("Enter  partycode");
            return false;
        }
        var partyname = document.getElementById('txt_partyname').value;
        var partyid = document.getElementById('txt_prtyid').value; 
        var acccode = document.getElementById('txt_acccode').value;
        if (acccode == "") {
            alert("Enter  account code");
            return false;
        }
        var accountid = document.getElementById('txt_accid').value;
        var des = document.getElementById('txt_des').value;
        var chqno = document.getElementById('txt_chqno').value;
        if (chqno == "") {
            alert("Enter  cheque number");
            return false;
        }
        var chqdate = document.getElementById('txt_chqdate').value;
        if (chqdate == "") {
            alert("Enter  cheque date");
            return false;
        }
        var amount = document.getElementById('txt_amount').value;
        if (amount == "") {
            alert("Enter  amount");
            return false;
        }
        var drabank = document.getElementById('txt_drabank').value; 
        if (drabank == "") {
            alert("Enter  drawe bank");
            return false;
        }
        var remarks = document.getElementById('txt_remarks').value;
        var chequetype = document.getElementById('ddlchequetype').value;
        var sno = document.getElementById('txt_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_post_datedcheques', 'branchid': branchid,'branchcode':branchcode, 'accountid': accountid, 'branchname': branchname, 'partycode': partycode, 'partyid': partyid, 'partyname': partyname, 'acccode': acccode, 'chqno': chqno, 'chqdate': chqdate, 'amount': amount, 'drabank': drabank, 'chequetype':chequetype,'btnval': btnval, 'sno': sno, 'des': des, 'remarks': remarks };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_post_datedcheques();
                    forclearall();
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
            document.getElementById('txt_branchcode').value = "";
            document.getElementById('txt_branchname').value = "";
            document.getElementById('txt_partycode').value = "";
            document.getElementById('txt_partyname').value = "";
            document.getElementById('txt_acccode').value = "";
            document.getElementById('txt_des').value = "";
            document.getElementById('txt_chqno').value = "";
            document.getElementById('txt_chqdate').value = "";
            document.getElementById('txt_amount').value = "";
            document.getElementById('txt_drabank').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('ddlchequetype').selectedIndex = 0;
            document.getElementById('btn_save').value = "Save";
        }
        function get_post_datedcheques() {
            var data = { 'op': 'get_post_datedcheques' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbankaccountdetails(msg);

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
        function fillbankaccountdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">BranchName</th><th scope="col">PartyCode</th><th scope="col">PartyName</th><th scope="col">AccountNumber</th><th scope="col">Chequetype</th><th scope="col">ChequeNumber</th><th scope="col">ChequeDate</th><th scope="col">Amount</th><th scope="col">DraweeBank</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getbankacc(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td  style="display:none" class="1" >' + msg[i].branchcode + '</td>';
                results += '<td class="2">' + msg[i].branchname + '</td>';
                results += '<td  style="display:none" class="3">' + msg[i].branchid + '</td>';
                results += '<td  class="6">' + msg[i].partycode + '</td>'; 
                results += '<td class="5">' + msg[i].partyname + '</td>';
                results += '<td  style="display:none" class="4">' + msg[i].partyid + '</td>';
                results += '<td   class="7">' + msg[i].acccode + '</td>';
                results += '<td   class="6">' + msg[i].chequetype + '</td>';
                results += '<td  style="display:none" class="8">' + msg[i].des + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].accid + '</td>';
                results += '<td  class="10">' + msg[i].chqno + '</td>';
                results += '<td  class="11">' + msg[i].chqdate + '</td>';
                results += '<td   class="12">' + msg[i].amount + '</td>';
                results += '<td   class="13">' + msg[i].drabank + '</td>';
                results += '<td  style="display:none"  class="17">' + msg[i].chequeid + '</td>';
                results += '<td  style="display:none"  class="15">' + msg[i].remarks + '</td>';
                results += '<td style="display:none" class="14">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_data").html(results);
        }
        function getbankacc(thisid) {
            var branchcode = $(thisid).parent().parent().children('.1').html();
            var branchname = $(thisid).parent().parent().children('.2').html();
            var branchid = $(thisid).parent().parent().children('.3').html();
            var partycode = $(thisid).parent().parent().children('.4').html();
            var partyname = $(thisid).parent().parent().children('.5').html();
            var partyid = $(thisid).parent().parent().children('.6').html();
            var acccode = $(thisid).parent().parent().children('.7').html();
            var des = $(thisid).parent().parent().children('.8').html();
            var accid = $(thisid).parent().parent().children('.9').html();
            var chqno = $(thisid).parent().parent().children('.10').html();
            var chqdate = $(thisid).parent().parent().children('.11').html();
            var amount = $(thisid).parent().parent().children('.12').html();
            var drabank = $(thisid).parent().parent().children('.13').html();
            var remarks = $(thisid).parent().parent().children('.15').html();
            var chequetype = $(thisid).parent().parent().children('.16').html();
            var chequeid = $(thisid).parent().parent().children('.17').html();
            var sno = $(thisid).parent().parent().children('.14').html();

            document.getElementById('txt_branchcode').value = branchname;
            document.getElementById('txt_branchname').value = branchcode;
            document.getElementById('txt_branchid').value = branchid;
            document.getElementById('txt_partycode').value = partyname;
            document.getElementById('txt_partyname').value = partyid;
            document.getElementById('txt_prtyid').value = partycode;
            document.getElementById('txt_acccode').value = acccode;
            document.getElementById('txt_des').value = des;
            document.getElementById('txt_accid').value = accid;
            document.getElementById('txt_chqno').value = chqno;
            document.getElementById('txt_chqdate').value = chqdate;
            document.getElementById('txt_amount').value = amount;
            document.getElementById('txt_drabank').value = drabank;
            document.getElementById('ddlchequetype').value = chequeid;
            document.getElementById('txt_sno').value = sno;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('btn_save').value = "Modify";
        }

    //------------------------------------------------------post_dated_cheques---------------------------------------------

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
            var s = function (msg) {
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
        function Clearcheque(thisid) {
            var sno = $(thisid).parent().parent().children('.9').html();
            var data = { 'op': 'get_cheque_status', 'sno': sno };
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Post_dated Cheques
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Master</a></li>
            <li><a href="#">Post_dated Cheques</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_entry_details()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Post_dated Cheque Entry</a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_status_details()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Post_dated Cheque Status </a></li>
                </ul>
            </div>
            <div id="div_cheque_entry">
                <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Post_dated Cheques Entry
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
                                    Branch Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_branchcode" class="form-control" placeholder= "Enter Branch Code"/>
                                <input id="txt_branchid" type="hidden" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_branchname" class="form-control"  placeholder= "Branch Code" type="text"  readonly/>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Party Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partycode" class="form-control" placeholder= "Enter Party Code"/>
                                <input id="txt_prtyid" type="hidden"/>

                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partyname" class="form-control" placeholder= "Party Code" type="text"  readonly/>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                   Account Number</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_acccode" class="form-control" placeholder= "Enter Account Number"/>
                               <input id="txt_accid" type="hidden"></input>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_des" class="form-control" placeholder= "Account Number" type="text"  readonly/>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Cheque Type
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlchequetype" type="text" class="form-control">
                                <option value="">Select</option>
                                <option value="R">Receipt</option>
                                  <option value="P">Payment</option>
                             </td>
                            </tr>
                            <tr>
                            </tr>
                        <tr>
                            <td>
                                <label>
                                    Cheque No.
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_chqno" type="text" class="form-control" placeholder="Enter Cheque No." />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Cheque Date
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_chqdate" type="date" class="form-control"/>
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Amount
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_amount" type="text" class="form-control" placeholder="Enter Amount" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Drawee Bank
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_drabank" type="text" class="form-control" placeholder="Drawee bank" />
                            </td>
                            </tr>
                            <tr>
                                    <td style="height: 40px;">
                                        <label>
                                          Remarks</label>
                                    </td>
                                    <td>
                                        <textarea id="txt_remarks" class="form-control" rows="3" cols="25" placeholder= "Enter Remarks" ></textarea>
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
                                    onclick="save_post_datedcheques()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
            </div>
            <div id="div_data">
            </div>
            </div>
            
            <div id="div_cheque_status" style="display:none">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Post Dated Cheques Status
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_pde">
                        </div>
                        <div id='fillform_cheque'>
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
                                        <select id="slct_ac"  class="form-control"></select>
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