<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
 CodeFile="Voucherseriesmaster.aspx.cs" Inherits="Voucherseriesmaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_voucher_series();
        get_Branch_details();
        get_transaction_type();
        get_financial_year();
        forclearall();
    });
    function callHandler(d, s, e)
    {
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
    function save_voucherseries_click()
    {
        var Branchcode = document.getElementById('slct_bcode').value;
        if (Branchcode == "") {
            alert("Enter Branch code ");
            return false;

        }
        var brcode = document.getElementById('txtbrcode').value;
        var Financialyear = document.getElementById('slct_finyr').value;
        if (Financialyear == "") {
            alert("Enter  Financialyear");
            return false;
        }
        var vouchertypename = document.getElementById('ddlvouchertype').value;
        if (vouchertype == "") {
            alert("Enter  vouchertype");
            return false;
        }
        var vouchertype = document.getElementById('txtvtype').value;
        var vouchernofrom = document.getElementById('txt_vchno').value;
        var manualsystem = document.getElementById('ddl_msys').value;
        if (manualsystem == "") {
            alert("Enter  manual or system");
            return false;
        }
        var narration = document.getElementById('txt_narration').value;
        if (narration == "") {
            alert("Enter narration");
            return false;
        }
        var sno = document.getElementById('txtsno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_voucherseries_click', 'brcode': brcode, 'Financialyear': Financialyear, 'vouchertype': vouchertype, 'vouchernofrom': vouchernofrom, 'manualsystem': manualsystem, 'narration':narration,'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_voucher_series();
                    forclearall();
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
    function forclearall()
    {
        get_financial_year();
        document.getElementById('slct_finyr').value = "";
        document.getElementById('slct_bcode').value = "";
        document.getElementById('ddlvouchertype').value = "";
        document.getElementById('txt_vchno').value = "";
        document.getElementById('ddl_msys').selectedIndex = 0;
        document.getElementById('txt_bname').value = "";
        document.getElementById('txt_narration').value = "";
        document.getElementById('btn_save').value = "Save";
    }
    function get_voucher_series()
    {
        var data = { 'op': 'get_voucher_series' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillvoucherdetails(msg);

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
    function fillvoucherdetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">BranchName</th><th scope="col">FinancialYear</th><th scope="col">Vouchertype</th><th scope="col">VoucherNo</th><th scope="col">Narration</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th style="display:none" scope="row" class="1" style="text-align:center;">' + msg[i].branchcode + '</th>';
            results += '<td style="display:none"  data-title="code" class="9">' + msg[i].code + '</td>';
            results += '<td  data-title="code" class="8">' + msg[i].branchname + '</td>';
            results += '<td  data-title="code" class="2">' + msg[i].finyear + '</td>';
            results += '<td style="display:none" data-title="code" class="13">' + msg[i].vouchertype + '</td>';
            results += '<td data-title="code" class="14">' + msg[i].vouchertypename + '</td>';
            results += '<td style="display:none" data-title="code" class="3">' + msg[i].desc + '</td>';
            results += '<td data-title="code" class="4">' + msg[i].voucherfrm + '</td>';
            results += '<td data-title="code" class="15">' + msg[i].narration + '</td>';
            results += '<td style="display:none" data-title="code" class="12">' + msg[i].manualsystem + '</td>';
            results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_data").html(results);
    }
    function getme(thisid)
    {
        var branchname = $(thisid).parent().parent().children('.8').html();
        var branchcode = $(thisid).parent().parent().children('.1').html();
        var finyear = $(thisid).parent().parent().children('.2').html();
        var vouchertypename = $(thisid).parent().parent().children('.14').html();
        var vouchertype = $(thisid).parent().parent().children('.13').html();
        var vouchernofrom = $(thisid).parent().parent().children('.4').html();
        var sno = $(thisid).parent().parent().children('.6').html();
        var desc = $(thisid).parent().parent().children('.3').html();
        var shortdescription = $(thisid).parent().parent().children('.7').html();
        var manualsystem = $(thisid).parent().parent().children('.12').html();
        var narration = $(thisid).parent().parent().children('.15').html();

        document.getElementById('slct_bcode').value = branchname;
        document.getElementById('txtbrcode').value = branchcode;
        document.getElementById('slct_finyr').value = finyear;
        document.getElementById('ddlvouchertype').value = vouchertypename;
        document.getElementById('txtvtype').value = vouchertype;
        document.getElementById('txt_vchno').value = vouchernofrom;
        document.getElementById('txt_bname').value = desc;
        document.getElementById('ddl_msys').value = manualsystem;
        document.getElementById('txt_narration').value = narration;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('txtsno').value = sno;
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
                    var branchname = msg[i].branchname;
                    branchList.push(branchname);
                }
                $('#slct_bcode').autocomplete({
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
    function Getbranchname(slct_bcode)
    {
        var code = document.getElementById('slct_bcode').value;
        for (var i = 0; i < branchnamearr.length; i++) {
            if (code == branchnamearr[i].branchname) {
                document.getElementById('txt_bname').value = branchnamearr[i].companyname;
                document.getElementById('txtbrcode').value = branchnamearr[i].branchid;
            }
        }
    }
    function get_financial_year()
    {
        var data = { 'op': 'get_financial_year' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillfinyeardetails(msg);
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
    function fillfinyeardetails(msg)
    {

        for (var i = 0; i < msg.length; i++) {
            if (msg[i].currentyear == "true") {
                document.getElementById('slct_finyr').value = msg[i].year;
            }
        }
    }
    var vouchertypearr = [];
    function get_transaction_type()
    {
        var data = { 'op': 'get_transaction_type' };
        var s = function (msg)
        {
            if (msg) {
                vouchertypearr = msg;
                var transList = [];
                for (var i = 0; i < msg.length; i++) {
                    var transname = msg[i].transactiontype;
                    transList.push(transname);
                }
                $('#ddlvouchertype').autocomplete({
                    source: transList,
                    change: Gettransid
                });
            }
        }
        var e = function (x, h, e)
        {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Gettransid(ddlvouchertype)
    {
        var vtype = document.getElementById('ddlvouchertype').value;
      
        for (var i = 0; i < vouchertypearr.length; i++) {
            if (vtype == vouchertypearr[i].transactiontype) {
                document.getElementById('txtvtype').value = vouchertypearr[i].sno;

            }
        }
    }
    var subarr = [];
    var result = "";
    function getvoucherno()
    {
        var vouchertype = document.getElementById('txtvtype').value;
        var data = { 'op': 'get_voucher_no', 'vouchertype': vouchertype };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillvoucherno(msg);
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
    function fillvoucherno(msg)
    {
        result = "";
        var fin = document.getElementById('slct_finyr').value;
        var fintype = fin.substring(0, 2);
        var system = document.getElementById('ddl_msys').value;
        if (system == "S") {
        var vtype = document.getElementById('ddlvouchertype').value;
        var voucherarr = vtype.split(" ");
        for (i = 0; i < voucherarr.length; i++) {
            var start = voucherarr[i].substring(0, 1);
            result += start;
        }
        for (var i = 0; i < msg.length; i++) {
            document.getElementById('txt_vchno').value = "" + result + fintype + msg[i].voucherno;
            }
        }
        else {
            document.getElementById('txt_vchno').value = "";
        }
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Voucher Series
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Voucher Series</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Voucher Series
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
                                    Branch Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="slct_bcode" class="form-control" onchange="Getbranchname(this);" placeholder="Enter Branch Code" >
                                </input>
                                <input id="txtbrcode" type="hidden"></input>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_bname" class="form-control" type="text"  readonly/>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Financial Year</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="slct_finyr"  readonly class="form-control" ></input>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Voucher Type</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddlvouchertype" class="form-control" placeholder="Enter Voucher type">
                                </input>
                                <input id="txtvtype" type="hidden"></input>
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                         <tr>
                            <td>
                                <label>
                                    Manual System</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddl_msys" class="form-control" onchange="getvoucherno()">
                                    <option value="M">Manual</option>
                                    <option value="S">Automatic</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Voucher No
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_vchno" type="text" class="form-control" placeholder="Enter Voucher No" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                        <tr>
                        <td style="height: 40px;">
                                        <label>
                                            Narration </label>
                                    </td>
                                    <td>
                                        <textarea rows="3" cols="25" id="txt_narration" class="form-control" maxlength="2000"
                                    placeholder="Enter Narration"></textarea>
                                    </td>
                                    <td>
                                    </td>
                        </tr>
                       
                        <tr style="display: none;">
                            <td>
                                <label id="txtsno">
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_voucherseries_click()" />
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

