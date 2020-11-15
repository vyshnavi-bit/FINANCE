<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="transactions.aspx.cs" Inherits="Ttransactions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        $("#divbank").css("display", "block");
        get_transaction_type();
        clear_transaction_type();
        get_group_ledger();
        get_transsub_type();
        forclearall();
        get_transaction_type1();
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
        function showbrfdrdetails() {
            $("#divbank").css("display", "block");
            $("#divifsc").css("display", "none");
            $('#showlogs').css('display', 'none');
            $('#div_SectionData1').show();
            $('#div_inwardtable1').show();
        }
        function showbankdetails() {
            $("#divbank").css("display", "none");
            $("#divifsc").css("display", "block");
            $('#showlogs2').css('display', 'block');
            $('#div_SectionData2').show();
            $('#div_inwardtable2').show();
            get_transsub_type();
            clear_transaction_type();
            get_transaction_type();
            get_group_ledger();
            forclearall();
        }
        function save_transaction_type() {
            var transactiontype = document.getElementById('txt_tstype').value;
            if (transactiontype == "") {
                alert("Enter Transaction type ");
                return false;
            }
            var shortdescription = document.getElementById('txt_desc').value;
            if (shortdescription == "") {
                alert("Enter short description ");
                return false;
            }
            var system = document.getElementById('slct_sys').value;
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_transaction_type', 'transactiontype': transactiontype, 'shortdescription': shortdescription, 'system': system, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_transaction_type();
                        clear_transaction_type();
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
        function get_transaction_type() {
            var data = { 'op': 'get_transaction_type' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filltransdetails(msg);
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
        function filltransdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">TransactionType</th><th scope="col">ShortDescription</th><th scope="col">System</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1">' + msg[i].transactiontype + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].shortdescription + '</td>';
                results += '<td data-title="code" class="3">' + msg[i].system + '</td>';
                results += '<td  style="display:none" data-title="code" class="5">' + msg[i].system1 + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable1").html(results);
        }
        function getme(thisid) {

            $("#divbank").css("display", "block");
            $("#divifsc").css("display", "none");
            $('#div_SectionData1').show();
            $('#newrow1').css('display', 'none');

            var transactiontype = $(thisid).parent().parent().children('.1').html();
            var shortdescription = $(thisid).parent().parent().children('.2').html();
            var system = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.4').html();
            document.getElementById('txt_tstype').value = transactiontype;
            document.getElementById('slct_sys').value = system;
            document.getElementById('txt_desc').value = shortdescription;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }
        function clear_transaction_type() {
            document.getElementById('txt_tstype').value = "";
            document.getElementById('slct_sys').selectedIndex = 0;
            document.getElementById('txt_desc').value = "";
            document.getElementById('btn_save').value = "Save";
        }
        var transtype = [];
        function get_transaction_type1()
        {
            var data = { 'op': 'get_transaction_type' };
            var s = function (msg)
            {
                if (msg) {
                    transtype = msg;
                    var transList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var transtype = msg[i].transactiontype;
                        transList.push(transtype);
                    }
                    $('#selct_transtype').autocomplete({
                        source: transList,
                        change: gettransid
                    });
                }
            }
            var e = function (x, h, e)
            {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function gettransid(){
            var transtype = document.getElementById('selct_transtype').value;
            for (var i = 0; i < transtype.length; i++) {
                if (transtype == transtype[i].transactiontype) {
                    document.getElementById('txttrans').value = transtype[i].sno;
                }
            }
        }
        var groupshortdesc = [];
        function get_group_ledger()
        {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg)
            {
                if (msg) {
                    groupshortdesc = msg;
                    var glList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var glname = msg[i].groupshortdesc;
                        glList.push(glname);
                    }
                    $('#txt_glcode').autocomplete({
                        source: glList,
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
        function Getbranchname(txt_glcode) {
            var code = document.getElementById('txt_glcode').value;
            for (var i = 0; i < groupshortdesc.length; i++) {
                if (code == groupshortdesc[i].groupshortdesc) {
                    document.getElementById('txt_bname').value = groupshortdesc[i].groupcode;
                    document.getElementById('txt_glid').value = groupshortdesc[i].sno;
                }
            }
        }
        function save_Transaction_SubTypes() {
            var transtype = document.getElementById('selct_transtype').value;
            var transid = document.getElementById('txttrans').value;
            var subtype = document.getElementById('txt_subtype').value;
            var description = document.getElementById('txt_description').value;
            var glcode = document.getElementById('txt_glcode').value;
            var glid = document.getElementById('txt_glid').value;
            var bname = document.getElementById('txt_bname').value;
            var sno = document.getElementById('lbl_sno2').value;
            var btnsave = document.getElementById('btn_savesub').value;
            if (transtype == "" || transid == "") {
                alert("Enter  Transaction type");
                return false;
            }
            if (subtype == "") {
                alert("Enter  subtype");
                return false;
            }
            if (description == "") {
                alert("Enter  description");
                return false;
            }
            if (glcode == "" || glid == "" || bname == "") {
                alert("Enter  Group Ledger");
                return false;
            }
            var data = { 'op': 'save_Transaction_SubTypes', 'transid': transid, 'subtype': subtype, 'description': description, 'glid': glid, 'btnsave': btnsave, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_transsub_type();
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
        function get_transsub_type()
        {
            var data = { 'op': 'get_transsub_type'};
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldeptdetails1(msg);
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
        function filldeptdetails1(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">transactiontype</th><th scope="col">subtype</th><th scope="col">description</th><th scope="col">glcode</th><th scope="col">shortdescription</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme1(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th style="display:none" scope="row" class="1">' + msg[i].transactiontype + '</th>';
                results += '<td data-title="code" class="7">' + msg[i].transactionid + '</td>';
                results += '<td data-title="code" class="2">' + msg[i].subtype + '</td>';
                results += '<td data-title="code" class="3">' + msg[i].description + '</td>';
                results += '<td style="display:none" data-title="code" class="4">' + msg[i].glcode + '</td>';
                results += '<td data-title="code" class="8">' + msg[i].glid + '</td>';
                results += '<td data-title="code"   class="6">' + msg[i].short_desc + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable2").html(results);
        }
        function getme1(thisid) {

            $("#divbank").css("display", "none");
            $("#divifsc").css("display", "block");
            $('#div_SectionData2').show();
            $('#newrow2').css('display', 'none');
            var transactiontype = $(thisid).parent().parent().children('.7').html();
            var transactionid = $(thisid).parent().parent().children('.1').html();
            var subtype = $(thisid).parent().parent().children('.2').html();
            var description = $(thisid).parent().parent().children('.3').html();
            var glcode = $(thisid).parent().parent().children('.6').html();
            var glid = $(thisid).parent().parent().children('.4').html();
            var sno = $(thisid).parent().parent().children('.5').html();
            var short_desc = $(thisid).parent().parent().children('.8').html();

            document.getElementById('selct_transtype').value = transactiontype;
            document.getElementById('txttrans').value = transactionid;
            document.getElementById('txt_subtype').value = subtype;
            document.getElementById('txt_description').value = description;
            document.getElementById('txt_glcode').value = glcode;
            document.getElementById('txt_glid').value = glid;
            document.getElementById('txt_bname').value = short_desc;
            document.getElementById('btn_savesub').value = "Modify";
            document.getElementById('lbl_sno2').value = sno;
        }
        function forclearall() {
            document.getElementById('selct_transtype').value = "";
            document.getElementById('txt_subtype').value = "";
            document.getElementById('txt_description').value = "";
            document.getElementById('txt_glcode').value = "";
            document.getElementById('txt_bname').value = "";
            document.getElementById('btn_savesub').value = "save";
            get_transaction_type();
            get_group_ledger();
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Transactions 
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#"> Transactions</a></li>
        </ol>
    </section>
     <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showbrfdrdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Transaction Types </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showbankdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Transaction Sub Types</a></li>
                </ul>
            </div>
            <div id="divbank" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Transaction types
                    </h3>
                </div>
                 <div class="box-body">
                    <div id='fillform'>
                    <table align="center" style="width: 60%;">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Transaction type</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_tstype" type="text" maxlength="45" class="form-control" placeholder="Enter transaction type" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Short Description</label>
                                    </td>
                                    <td>
                                        <textarea rows="3" cols="20" id="txt_desc" class="form-control" maxlength="2000"
                                    placeholder="Enter Description"></textarea>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Manual/System</label>
                                    </td>
                                    <td>
                                        <select id="slct_sys"  type="text">
                                        <option value="M">Manual</option>
                                         <option value="S">System</option>
                                         </select>
                                    </td>
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_transaction_type();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_transaction_type();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            </div>
                                <div class="box-body">
                                        <div id="div_inwardtable1">
                                        </div>
                                    </div>
                                </div>
                        </div>
                <div id="divifsc" style="display: none;">
                    
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Transaction Sub Types
                        </h3>
                    </div>
                    <div>
                     <div id='showlogs2' style="display: none;">
                     <table align="center" style="width: 60%;">
                        <tr>
                            <td>
                                <label>
                                    Transaction Type</label>
                            </td>
                            <td>
                                <input id="selct_transtype" class="form-control" placeholder="Enter Transaction type">
                                </input>
                                <input id="txttrans" type="hidden"></input>
                            </td>
                        </tr>
                        
                            <tr>
                            <td>
                                <label>
                                    Sub Type</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_subtype" type="text" name="CCName" placeholder="Enter Sub Type" class="form-control" />
                            </td>
                            </tr>
                             <tr>
                            <td>
                                <label>
                                    Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_description" type="text" name="CCName" placeholder="Enter Description" class="form-control" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    GL Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_glcode" class="form-control" onchange="Getbranchname(this);" placeholder="Enter GLcode" >
                                </input>
                                <input id="txt_glid" type="hidden"></input>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_bname" class="form-control" type="text" placeholder="Group Ledger Code" readonly/>
                                </td>
                        </tr>
                         <tr style="display:none;"><td>
                            <label id="lbl_sno2"></label>
                            </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" style="height: 40px;">
                                    <input id="btn_savesub" type="button" class="btn btn-success" name="submit" value='save'
                                        onclick="save_Transaction_SubTypes()" />
                                    <input id='btn_clearsub' type="button" class="btn btn-danger" name="Clear" value='Clear'
                                        onclick="forclearall()" />
                                </td>
                            </tr>
                        </table>
                            </div>
                            <div>
                    <div id="div_inwardtable2">
                    </div>
                </div>
            </div>
            </div>
            </div>
    </section>
</asp:Content>

