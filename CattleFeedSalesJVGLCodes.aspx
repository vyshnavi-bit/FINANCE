<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CattleFeedSalesJVGLCodes.aspx.cs" Inherits="CattleFeedSalesJVGLCodes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_primary_group();
        get_group_ledger();
        forallclear();
        get_cattlefeed_sales();
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
    var branchname = [];
    function get_primary_group() {
        var data = { 'op': 'get_primary_group' };
        var s = function (msg) {
            if (msg) {
                branchname = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].Shortdescription;
                    empnameList.push(empname);
                }
                $('#txt_groupcode1').autocomplete({
                    source: empnameList,
                    change: Getgroupcode1,
                    autoFocus: true
                });
                $('#txt_groupcode2').autocomplete({
                    source: empnameList,
                    change: Getgroupcode2,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Getgroupcode1() {
        var empname = document.getElementById('txt_groupcode1').value;
        for (var i = 0; i < branchname.length; i++) {
            if (empname == branchname[i].Shortdescription) {
                document.getElementById('txt_groupid1').value = branchname[i].sno;
                document.getElementById('txt_groupname1').value = branchname[i].Longdescription;
            }
        }
    }
    function Getgroupcode2() {
        var empname = document.getElementById('txt_groupcode2').value;
        for (var i = 0; i < branchname.length; i++) {
            if (empname == branchname[i].Shortdescription) {
                document.getElementById('txt_groupid2').value = branchname[i].sno;
                document.getElementById('txt_groupname2').value = branchname[i].Longdescription;
            }
        }
    }
    var branchname1 = [];
    function get_group_ledger() {
        var data = { 'op': 'get_group_ledger' };
        var s = function (msg) {
            if (msg) {
                branchname1 = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].groupshortdesc;
                    empnameList.push(empname);
                }
                $('#txt_glcode1').autocomplete({
                    source: empnameList,
                    change: Getglcode1,
                    autoFocus: true
                });
                $('#txt_glcode2').autocomplete({
                    source: empnameList,
                    change: Getglcode2,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Getglcode1() {
        var empname = document.getElementById('txt_glcode1').value;
        for (var i = 0; i < branchname1.length; i++) {
            if (empname == branchname1[i].groupshortdesc) {
                document.getElementById('txt_glid1').value = branchname1[i].sno;
                document.getElementById('txt_glname1').value = branchname1[i].groupcode;
            }
        }
    }
    function Getglcode2() {
        var empname = document.getElementById('txt_glcode2').value;
        for (var i = 0; i < branchname1.length; i++) {
            if (empname == branchname1[i].groupshortdesc) {
                document.getElementById('txt_glid2').value = branchname1[i].sno;
                document.getElementById('txt_glname2').value = branchname1[i].groupcode;
            }
        }
    }
    function save_cattlefeed_sales() {
        var erngdedu = document.getElementById('txt_erngdedu').value;
        if (erngdedu == "") {
            alert("Enter Earnings & Deduction code ");
            return false;
        }
        var groupcode1 = document.getElementById('txt_groupcode1').value;
        var groupid1 = document.getElementById('txt_groupid1').value;
        if (groupcode1 == "") {
            alert("Enter groupcode ");
            return false;
        }
        var groupname1 = document.getElementById('txt_groupname1').value;
        var glid1 = document.getElementById('txt_glid1').value;
        var glcode1 = document.getElementById('txt_glcode1').value;
        if (glcode1 == "") {
            alert("Enter glcode ");
            return false;
        }
        var glname1 = document.getElementById('txt_glname1').value;
        var groupcode2 = document.getElementById('txt_groupcode2').value;
        var groupid2 = document.getElementById('txt_groupid2').value;
        if (groupcode2 == "") {
            alert("Enter groupcode");
            return false;
        }
        var groupname2 = document.getElementById('txt_groupname2').value;
        var glid2 = document.getElementById('txt_glid2').value;
        var glcode2 = document.getElementById('txt_glcode2').value;
        if (glcode2 == "") {
            alert("Enter glcode ");
            return false;
        }
        var glname2 = document.getElementById('txt_glname2').value;
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_cattlefeed_sales', 'erngdedu': erngdedu,'groupid1':groupid1,'groupid2':groupid2, 'glid1':glid1,'glid2':glid2,'groupcode1': groupcode1, 'groupname1': groupname1, 'glcode1': glcode1, 'glname1': glname1, 'groupcode2': groupcode2, 'groupname2': groupname2, 'glcode2': glcode2, 'glname2': glname2, 'btnval': btnval, 'sno': sno
        };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_cattlefeed_sales();
                    forallclear();
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
    function forallclear() {
        document.getElementById('txt_erngdedu').value = "";
        document.getElementById('txt_groupcode1').value = "";
        document.getElementById('txt_groupname1').value = "";
        document.getElementById('txt_glcode1').value = "";
        document.getElementById('txt_glname1').value = "";
        document.getElementById('txt_groupcode2').value = "";
        document.getElementById('txt_groupname2').value = "";
        document.getElementById('txt_glcode2').value = "";
        document.getElementById('txt_glname2').value = ""
        document.getElementById('btn_save').value = "Save";
    }
    function get_cattlefeed_sales() {
        var data = { 'op': 'get_cattlefeed_sales' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillcattlefeed(msg);

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
    function fillcattlefeed(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Earnings&Deduction</th><th scope="col">DabitGroupName</th><th scope="col">DabitGroupDescription</th><th scope="col">DabitGlName</th><th scope="col">DabitGlCode</th><th scope="col">CraditGroupName</th><th scope="col">CraditGroupDescription</th><th scope="col">CraditGlName</th><th scope="col">CraditGlCode</th><th scope="col">DateOfEntry</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td  data-title="code" class="1" >' + msg[i].erngdedu + '</td>';
            results += '<td  data-title="code" class="2">' + msg[i].groupcode1 + '</td>';
            results += '<td style="display:none" data-title="code" class="3">' + msg[i].groupid1 + '</td>';
            results += '<td  data-title="code" class="4">' + msg[i].groupname1 + '</td>';
            results += '<td  data-title="code" class="5">' + msg[i].glcode1 + '</td>';
            results += '<td style="display:none" data-title="code"  class="6">' + msg[i].glid1 + '</td>';
            results += '<td  data-title="code" class="7">' + msg[i].glname1 + '</td>';

            results += '<td  data-title="code" class="8" >' + msg[i].groupcode2 + '</td>';
            results += '<td style="display:none" data-title="code" class="9">' + msg[i].groupid2 + '</td>';
            results += '<td data-title="code" class="10">' + msg[i].groupname2 + '</td>';
            results += '<td  data-title="code"  class="11">' + msg[i].glcode2 + '</td>';
            results += '<td style="display:none" data-title="code" class="12">' + msg[i].glid2 + '</td>';
            results += '<td data-title="code" class="13">' + msg[i].glname2 + '</td>';
            results += '<td data-title="code"  class="14">' + msg[i].doe + '</td>';

            results += '<td style="display:none" class="15">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_reason").html(results);
    }
    function getme(thisid) {
        var erngdedu = $(thisid).parent().parent().children('.1').html();
        var groupcode1 = $(thisid).parent().parent().children('.2').html();
        var groupid1 = $(thisid).parent().parent().children('.3').html();
        var groupname1 = $(thisid).parent().parent().children('.4').html();
        var glcode1 = $(thisid).parent().parent().children('.5').html();
        var glid1 = $(thisid).parent().parent().children('.6').html();
        var glname1 = $(thisid).parent().parent().children('.7').html();
        var groupcode2 = $(thisid).parent().parent().children('.8').html();
        var groupid2 = $(thisid).parent().parent().children('.9').html();
        var groupname2 = $(thisid).parent().parent().children('.10').html();
        var glcode2 = $(thisid).parent().parent().children('.11').html();
        var glid2 = $(thisid).parent().parent().children('.12').html();
        var glname2 = $(thisid).parent().parent().children('.13').html();
        var sno = $(thisid).parent().parent().children('.15').html();

        document.getElementById('txt_erngdedu').value = erngdedu;
        document.getElementById('txt_groupcode1').value = groupcode1;
        document.getElementById('txt_groupname1').value = groupname1;
        document.getElementById('txt_glcode1').value = glcode1;
        document.getElementById('txt_glname1').value = glname1;
        document.getElementById('txt_groupid1').value = groupid1;
        document.getElementById('txt_glid1').value = glid1;
        document.getElementById('txt_groupid2').value = groupid2;
        document.getElementById('txt_glid2').value = glid2;
        document.getElementById('txt_groupcode2').value = groupcode2;
        document.getElementById('txt_groupname2').value = groupname2;
        document.getElementById('txt_glcode2').value = glcode2;
        document.getElementById('txt_glname2').value = glname2;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('lbl_sno').value = sno;
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Cattle Feed Sales JV GL Codes
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Master</a></li>
            <li><a href="#">Cattle Feed Sales JV GL Codes</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Cattle Feed Sales JV GL Codes
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_rsn">
                        </div>
                        <div id='fillform'>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Earnings & Deduction code</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_erngdedu" type="text"  class="form-control" placeholder="Enter  Earnings & Deduction code" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                </table>
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Debit GL Codes
                                        </h3>
                                    </div>
                                    <table>
                                    <tr>
                            <td>
                            
                                <label>
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupcode1" class="form-control" onchange="Getgroupcode1(this);" >
                                <input id="txt_groupid1" class="form-control" type="text" style="display:none"/>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupname1" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                            <td>
                            
                                <label>
                                    Gl Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_glcode1" class="form-control" onchange="Getglcode1(this);" />
                                <input id="txt_glid1" class="form-control" type="text" style="display:none"/>
                                
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_glname1" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            </table>
                            </div>
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Credit GL Codes
                                        </h3>
                                    </div>
                                    <table>
                                    <tr>
                            <td>
                            
                                <label>
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupcode2" class="form-control" onchange="Getgroupcode2(this);" />
                                <input id="txt_groupid2" class="form-control" type="text" style="display:none"/>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupname2" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                            <td>
                            
                                <label>
                                    Gl Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_glcode2" class="form-control" onchange="Getglcode2(this);" />
                                <input id="txt_glid2" class="form-control" type="text" style="display:none"/>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_glname2" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            </table>
                            
                                    </div>
                                </div>
                                <table align="center">
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_cattlefeed_sales();" />
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="forallclear();" />
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
                            <div id="div_reason">
                         </div>
                   </div>
              </div>
        </section>
</asp:Content>
