<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="FixedAssetsGroup.aspx.cs" Inherits="FixedAssetsGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function ()
    {
        $("#divfagroup").css("display", "block");
        get_fixedassets_group();
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
    function showfagroupdetails()
    {
        $("#divfagroup").css("display", "block");
        $("#Acmaster").css("display", "none");
    }
    function showaccdetails()
    {
        $("#divfagroup").css("display", "none");
        $("#Acmaster").css("display", "block");
        get_fixedasset_group();
        get_accountmaster_click();
    }
    function forclearall() {
        document.getElementById('txt_groupcode').value = "";
        document.getElementById('txt_groupname').value = "";
        document.getElementById('txt_description').value = "";
        document.getElementById('txt_gamount').value = "";
        document.getElementById('btn_FAsave').value = "Save";
    }
    function save_fixedassets_group() {
        var groupname = document.getElementById('txt_groupname').value;
        if (groupname == "") {
            alert("Enter Group Name ");
            return false;
        }
        var groupcode = document.getElementById('txt_groupcode').value;
        if (groupcode == "") {
            alert("Enter Group Code");
            return false;
        }
        var description = document.getElementById('txt_description').value;
        if (description == "") {
            alert("Enter Description");
            return false;
        }
        var gamount = document.getElementById('txt_gamount').value;
        var sno = document.getElementById('txt_sno').value;
        var btnval = document.getElementById('btn_FAsave').value;
        var data = { 'op': 'save_fixedassets_group', 'groupcode': groupcode, 'groupname': groupname, 'description': description, 'gamount': gamount, 'btnval': btnval, 'sno': sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_fixedassets_group();
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
    function get_fixedassets_group() {
        var data = { 'op': 'get_fixedassets_group' };
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
        results += '<thead><tr><th scope="col"></th><th scope="col">GroupName</th><th scope="col">GroupCode</th><th scope="col">Narration</th><th scope="col">GrossAmount</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getbankacc(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td  class="2">' + msg[i].groupname + '</td>';
            results += '<td  class="3">' + msg[i].groupcode + '</td>';
            results += '<td  class="5">' + msg[i].description + '</td>';
            results += '<td   class="7">' + msg[i].gamount + '</td>';
            results += '<td  style="display:none" class="8">' + msg[i].doe + '</td>';
            results += '<td style="display:none" class="9">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_data").html(results);
    }
    function getbankacc(thisid) {
        var groupname = $(thisid).parent().parent().children('.2').html();
        var groupcode = $(thisid).parent().parent().children('.3').html();
        var description = $(thisid).parent().parent().children('.5').html();
        var gamount = $(thisid).parent().parent().children('.7').html();
        var doe = $(thisid).parent().parent().children('.8').html();
        var sno = $(thisid).parent().parent().children('.9').html();

        document.getElementById('txt_groupname').value = groupname;
        document.getElementById('txt_groupcode').value = groupcode;
        document.getElementById('txt_description').value = description;
        document.getElementById('txt_gamount').value = gamount;
        document.getElementById('txt_sno').value = sno;
        document.getElementById('btn_FAsave').value = "Modify";
    }
    //Account Master
    var fagroup = [];
    function get_fixedasset_group()
    {
        var data = { 'op': 'get_fixedassets_group' };
        var s = function (msg)
        {
            if (msg) {
                fagroup = msg;
                var acnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var grname = msg[i].groupname;
                    acnameList.push(grname);
                }
                $('#txt_groupaccode').autocomplete({
                    source: acnameList,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e)
        {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function save_accountmaster_click()
    {
        var groupcode = document.getElementById('txt_groupaccode').value;
        if (groupcode == "") {
            alert("Select Group Code");
            return false;
        }
        var groupid = document.getElementById('txt_groupid').value;
        var accountcode = document.getElementById('txt_accountcode').value;
        if (accountcode == "") {
            alert("Enter Account Code");
            return false;
        }
        var accshortdescription = document.getElementById('txt_accshortdescription').value;
        if (accshortdescription == "") {
            alert("Enter Description");
            return false;
        }
        var acctype = document.getElementById('txt_acctype').value;
        var accstatus = document.getElementById('txt_accstatus').value;
        var fbtapplicable = document.getElementById('txt_fbtapplicable').value;
        var vatreturns = document.getElementById('txt_vatreturns').value;
        var tdsappicable = document.getElementById('txt_tdsappicable').value;
        var sno = document.getElementById('txtsno').value;
        var btnval = document.getElementById('btn_acsave').value;
        var data = { 'op': 'save_accountmaster_click', 'groupid': groupid, 'groupcode': groupcode, 'accountcode': accountcode, 'accshortdescription': accshortdescription, 'acctype': acctype, 'accstatus': accstatus, 'fbtapplicable': fbtapplicable, 'vatreturns': vatreturns, 'tdsappicable': tdsappicable, 'sno': sno, 'btnval': btnval
        };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    clearall();
                    get_accountmaster_click();
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
    function clearall()
    {
        document.getElementById('txt_groupaccode').value = "";
        document.getElementById('txt_groupid').value = "";
        document.getElementById('txt_accountcode').value = "";
        document.getElementById('txt_accshortdescription').value = "";
        document.getElementById('txt_acctype').selectedIndex = 0;
        document.getElementById('txt_accstatus').selectedIndex = 0;
        document.getElementById('txt_fbtapplicable').selectedIndex = 0;
        document.getElementById('txt_vatreturns').selectedIndex = 0;
        document.getElementById('txt_tdsappicable').selectedIndex = 0;
        document.getElementById('btn_acsave').value = "Save";
    }
    function get_accountmaster_click()
    {
        var data = { 'op': 'get_accountmaster_click' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillaccountmasterdetails(msg);
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
    function fillaccountmasterdetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">GroupCode</th><th scope="col">AccountCode</th><th scope="col">Description</th><th scope="col">AccountType</th><th scope="col">AccountStatus</th><th scope="col">FBTApplicable</th><th scope="col">VATReturns</th><th scope="col">TDSApplicable</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th  scope="row" class="1" style="text-align:center;">' + msg[i].groupcode + '</th>';
            results += '<td  style="display:none" data-title="code" class="3">' + msg[i].groupid + '</td>';
            results += '<td  data-title="code" class="4">' + msg[i].accountcode + '</td>';
            results += '<td data-title="code" class="5">' + msg[i].accshortdescription + '</td>';
            results += '<td  style="display:none" data-title="code" class="7">' + msg[i].acctype + '</td>';
            results += '<td  data-title="code" class="8">' + msg[i].acctype1 + '</td>';
            results += '<td  style="display:none" data-title="code" class="9">' + msg[i].accstatus + '</td>';
            results += '<td  data-title="code" class="10">' + msg[i].accstatus1 + '</td>';
            results += '<td  style="display:none" data-title="code" class="11">' + msg[i].fbtapplicable + '</td>';

            results += '<td  data-title="code" class="12">' + msg[i].fbtapplicable1 + '</td>';
            results += '<td  style="display:none" data-title="code" class="13">' + msg[i].vatreturns + '</td>';
            results += '<td  data-title="code" class="14">' + msg[i].vatreturns1 + '</td>';
            results += '<td  style="display:none"  data-title="code" class="15">' + msg[i].tdsappicable + '</td>';
            results += '<td data-title="code" class="16">' + msg[i].tdsappicable1 + '</td>';

            results += '<td style="display:none" class="17">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_acmaster").html(results);
    }
    function getme(thisid)
    {
        var groupcode = $(thisid).parent().parent().children('.1').html();
        var groupid = $(thisid).parent().parent().children('.3').html();
        var accountcode = $(thisid).parent().parent().children('.4').html();
        var accshortdescription = $(thisid).parent().parent().children('.5').html();
        var acctype = $(thisid).parent().parent().children('.7').html();
        var acctype1 = $(thisid).parent().parent().children('.8').html();
        var accstatus = $(thisid).parent().parent().children('.9').html();
        var accstatus1 = $(thisid).parent().parent().children('.10').html();
        var fbtapplicable = $(thisid).parent().parent().children('.11').html();
        var fbtapplicable1 = $(thisid).parent().parent().children('.12').html();
        var vatreturns = $(thisid).parent().parent().children('.13').html();
        var vatreturns1 = $(thisid).parent().parent().children('.14').html();
        var tdsappicable = $(thisid).parent().parent().children('.15').html();
        var tdsappicable1 = $(thisid).parent().parent().children('.16').html();
        var sno = $(thisid).parent().parent().children('.17').html();

        document.getElementById('txt_groupaccode').value = groupcode;
        document.getElementById('txt_groupid').value = groupid;
        document.getElementById('txt_accountcode').value = accountcode;
        document.getElementById('txt_accshortdescription').value = accshortdescription;
        document.getElementById('txt_acctype').value = acctype;
        document.getElementById('txt_accstatus').value = accstatus;
        document.getElementById('txt_fbtapplicable').value = fbtapplicable;
        document.getElementById('txt_vatreturns').value = vatreturns;
        document.getElementById('txt_tdsappicable').value = tdsappicable;
        document.getElementById('btn_acsave').value = "Modify";
        document.getElementById('txtsno').value = sno;
    }
   </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Fixed Assets Group
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Fixed Assets Group</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
         <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showfagroupdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Fixed Assets Groups </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showaccdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Account Master</a></li>
                </ul>
            </div>
            <div id="divfagroup" style="display:none">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Fixed Assets Group
                </h3>
            </div>
            <div class="box-body">
                <div id='fillform'>
                <table align="center">
                           <tr>
                            <td>
                                <label>
                                    Group Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupname" class="form-control" placeholder= "Enter Group Name" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Group Code
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupcode" type="text" class="form-control" placeholder= "Enter Group Code"/>
                            </td>
                            </tr>
                        <tr>
                             <td style="height: 40px;">
                                        <label>
                                            Narration </label>
                                    </td>
                                    <td>
                                        <textarea rows="3" cols="25" id="txt_description" class="form-control" maxlength="2000"
                                    placeholder="Enter Narration"></textarea>
                                    </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Gross Amount
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_gamount" type="text" class="form-control" placeholder="Enter Gross Amount" />
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
                                <input id="btn_FAsave" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_fixedassets_group()" />
                                <input id='btn_FAclose' type="button" class="btn btn-danger" name="Close" value='Clear'
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
            <div id="Acmaster" style="display:none">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Account Master
                </h3>
            </div>
            <div class="box-body">
                <div id='fillform'>
                    <table align="center">
                            <tr>
                            <td>
                                <label>
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupaccode" class="form-control" type="text"  placeholder="Enter Group Code" />
                                <input id="txt_groupid" class="form-control" type="text" style="display: none;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Account Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_accountcode" class="form-control" type="text"  placeholder="Account Code" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                   Description</label>
                            </td>
                            <td style="height: 40px;">
                            <textarea rows="3" cols="25" id="txt_accshortdescription" class="form-control" maxlength="2000"
                                    placeholder="Enter Description"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Account Type</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_acctype" class="form-control" style="width: 100px;">
                                    <option value="">Select</option>
                                    <option value="CA">Cash</option>
                                    <option value="BA">Bank</option>
                                    <option value="PA">Purchase</option>
                                    <option value="SA">Sale</option>
                                    <option value="TAX">Tax</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Account Satus</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_accstatus" class="form-control" style="width: 100px;" >
                                <option value="">Select</option>
                                    <option value="A">Active</option>
                                    <option value="I">Inactive </option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    FBT Applicable</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_fbtapplicable" class="form-control" style="width: 100px;">
                                <option value="">Select</option>
                                    <option value="Y">Yes</option>
                                    <option value="N">No </option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    VAT Returns</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_vatreturns" class="form-control" style="width: 100px;">
                                <option value="">Select</option>
                                    <option value="Y">Yes</option>
                                    <option value="N">No </option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    TDS Applicable</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_tdsappicable" class="form-control" style="width: 100px;">
                                <option value="">Select</option>
                                    <option value="Y">Yes</option>
                                    <option value="N">No </option>
                                </select>
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
                                <input id="btn_acsave" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_accountmaster_click()" />
                                <input id='account_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="clearall()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
            </div>
            <div id="div_acmaster" style="height:500px;overflow:auto;">
            </div>
            </div>
        </div>
    </section>
</asp:Content>

