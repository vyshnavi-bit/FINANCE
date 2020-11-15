<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Groupledgermaster.aspx.cs" Inherits="Groupledgermaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function ()
    {
        $("#divPG").css("display", "block");
        get_group_ledger();
        get_primary_group();
        get_subgroup_ledger();
        get_group_ledgercode();
        get_primary_groupcode();
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
    function showPGdetails()
    {
        $("#divPG").css("display", "block");
        $("#divGL").css("display", "none");
        $("#divsubgroup").css("display", "none");
    }

    function showGldetails()
    {
        $("#divPG").css("display", "none");
        $("#divGL").css("display", "block");
        $("#divsubgroup").css("display", "none");
    }
    function showSubGldetails()
    {
        get_group_ledger();
        $("#divPG").css("display", "none");
        $("#divsubgroup").css("display", "block");
        $("#divGL").css("display", "none");
    }
    var namearr = [];
    function get_primary_groupcode()
        {
            var data = { 'op': 'get_primary_group' };
            var s = function (msg)
            {
                if (msg) {
                    namearr = msg;
                    var primnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var primname = msg[i].Shortdescription;
                        primnameList.push(primname);
                    }
                    $('#slct_pgcode').autocomplete({
                        source: primnameList,
                        change: Getbankcode
                    });
                }
            }
            var e = function (x, h, e)
            {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
         function Getbankcode(slct_pgcode) {
        var code = document.getElementById('slct_pgcode').value;
        for (var i = 0; i < namearr.length; i++) {
            if (code == namearr[i].Shortdescription) {
                document.getElementById('txt_pgname').value = namearr[i].Groupcode;
                document.getElementById('txt_pgid').value = namearr[i].sno;
            }
        }
    }
    function save_group_ledger()
    {
        var primarygroup = document.getElementById('slct_pgcode').value;
        if (primarygroup == "") {
            alert("Select primarygroup ");
            return false;
        }
        var primarygroupid = document.getElementById('txt_pgid').value;
        var groupcode = document.getElementById('txt_group').value;
        if (groupcode == "") {
            alert("Select Grouyp Code ");
            return false;
        }
        var groupshortdesc = document.getElementById('txt_gsc').value;
        if (groupshortdesc == "") {
            alert("Select Description ");
            return false;
        }
        var schedule = document.getElementById('txt_schd').value;
        var order = document.getElementById('txt_order').value;
        var addless = document.getElementById('txt_addless').value;
        var sno = document.getElementById('txtsno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_group_ledger', 'primarygroupid': primarygroupid, 'groupcode': groupcode, 'groupshortdesc': groupshortdesc, 'schedule': schedule, 'order': order, 'addless': addless,'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_group_ledger();
                    cleargroup();
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
    function cleargroup()
    {
        document.getElementById('slct_pgcode').value = "";
        document.getElementById('txt_pgname').value = "";
        document.getElementById('txt_group').value = "";
        document.getElementById('txt_gsc').value = "";
        document.getElementById('txt_schd').value = "";
        document.getElementById('txt_order').value = "";
        document.getElementById('txt_addless').value = "";
        document.getElementById('btn_save').value = "Save";
    }

    function get_group_ledger()
    {
        var data = { 'op': 'get_group_ledger' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillledgerdetails(msg);
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
    function fillledgerdetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">PrimaryGroupCode</th><th scope="col">GroupCode</th><th scope="col">Description</th><th scope="col">Schedule</th><th scope="col">Order</th><th scope="col">Add/Less</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getGL(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th scope="row" class="1">' + msg[i].primarygroup + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].groupcode + '</td>';
            results += '<td  data-title="code" class="3">' + msg[i].groupshortdesc + '</td>';
            results += '<td data-title="code" class="5">' + msg[i].schedule + '</td>';
            results += '<td data-title="code" class="6">' + msg[i].order + '</td>';
            results += '<td data-title="code" class="7">' + msg[i].addless + '</td>';
            results += '<td style="display:none" data-title="code" class="9">' + msg[i].grouplongdesc + '</td>';
            results += '<td style="display:none" data-title="code" class="10">' + msg[i].primarygroupid + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_ledgerdata").html(results);
    }
    function getGL(thisid)
    {
        var primarygroup = $(thisid).parent().parent().children('.1').html();
        var primarygroupid = $(thisid).parent().parent().children('.10').html();
        var groupcode = $(thisid).parent().parent().children('.2').html();
        var groupshortdesc = $(thisid).parent().parent().children('.3').html();
        var schedule = $(thisid).parent().parent().children('.5').html();
        var order = $(thisid).parent().parent().children('.6').html();
        var addless = $(thisid).parent().parent().children('.7').html();
        var sno = $(thisid).parent().parent().children('.8').html();

        document.getElementById('slct_pgcode').value = groupshortdesc;
        document.getElementById('txt_pgname').value = primarygroup;
        document.getElementById('txt_pgid').value = primarygroupid;
        document.getElementById('txt_group').value = groupcode;
        document.getElementById('txt_gsc').value = groupshortdesc;
        document.getElementById('txt_schd').value = schedule;
        document.getElementById('txt_order').value = order;
        document.getElementById('txt_addless').value = addless;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('txtsno').value = sno;
    }
    var groupshortdesc = [];
    function get_group_ledgercode()
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
                $('#selct_grcode').autocomplete({
                    source: glList,
                    change:getgroupid,
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
    function getgroupid(){
        var grcode = document.getElementById('selct_grcode').value;
        for (var i = 0; i < groupshortdesc.length; i++) {
            if (grcode == groupshortdesc[i].groupshortdesc) {
                document.getElementById('txt_groupid').value = groupshortdesc[i].sno;
            }
        }

        }
    function save_subgroup_ledger()
    {
        var groupcode = document.getElementById('selct_grcode').value;
        if (groupcode == "") {
            alert("Select Group Code ");
            return false;
        }
        var groupid = document.getElementById('txt_groupid').value;
        var subgroupcode = document.getElementById('txt_subgcode').value;
        if (subgroupcode == "") {
            alert("Select SubGroup Code ");
            return false;
        }
        var description = document.getElementById('txt_subdesc').value;
        if (description == "") {
            alert("Select Description");
            return false;
        }
        var sno = document.getElementById('lbl_subgroup').value;
        var btnval = document.getElementById('btnsubgroupsave').value;
        var data = { 'op': 'save_subgroup_ledger', 'groupid': groupid, 'subgroupcode': subgroupcode, 'description': description, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_subgroup_ledger();
                    clearsubgroup();
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
    function clearsubgroup()
    {
        document.getElementById('txt_subgcode').value = "";
        document.getElementById('selct_grcode').value = "";
        document.getElementById('txt_subdesc').value = "";
        document.getElementById('btnsubgroupsave').value = "Save";
    }
    function get_subgroup_ledger()
    {
        var data = { 'op': 'get_subgroup_ledger' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillsubgroupledger(msg);

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
    function fillsubgroupledger(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Group Code</th><th scope="col">Sub Group Code</th><th scope="col">Description</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getsub(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th scope="row" class="1">' + msg[i].groupcode + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].Subgroupcode + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].description + '</td>';
            results += '<td style="display:none" data-title="code" class="5">' + msg[i].groupledgerid + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_subgroup").html(results);
    }
    function getsub(thisid)
    {
        var groupcode = $(thisid).parent().parent().children('.1').html();
        var groupledgerid= $(thisid).parent().parent().children('.5').html();
        var Subgroupcode = $(thisid).parent().parent().children('.2').html();
        var description = $(thisid).parent().parent().children('.3').html();
        var sno = $(thisid).parent().parent().children('.4').html();
      
        document.getElementById('selct_grcode').value = groupcode;
        document.getElementById('txt_groupid').value = groupledgerid;
        document.getElementById('txt_subgcode').value = Subgroupcode;
        document.getElementById('txt_subdesc').value = description;
        document.getElementById('btnsubgroupsave').value = "Modify";
        document.getElementById('lbl_subgroup').value = sno;
    }
    function save_primarygroup_details()
    {
        var Groupcode = document.getElementById('txt_gcode').value;
        if (Groupcode == "") {
            alert("Enter Group code ");
            return false;
        }
        var Shortdescription = document.getElementById('txt_desc').value;
        if (Shortdescription == "") {
            alert("Enter Short description");
            return false;
        }
        var Longdescription = document.getElementById('txt_longdesc').value;
        if (Longdescription == "") {
            alert("Enter Long description");
            return false;
        }
        var GLtype = document.getElementById('slct_sys').value;
        var Tradingac = get_radio_value();
        var profitloss = get_profit_value();
        var Balancesheet = get_balance_value();
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_PGsave').value;
        var data = { 'op': 'save_primarygroup_details', 'Groupcode': Groupcode, 'Shortdescription': Shortdescription, 'Longdescription': Longdescription, 'GLtype': GLtype, 'Tradingac': Tradingac, 'profitloss': profitloss, 'Balancesheet': Balancesheet, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_primary_group();
                    clear_groups();
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
    function get_radio_value()
    {
        var inputs = document.getElementsByName("selected");
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].checked) {
                return inputs[i].value;
            }
        }
    }
    function get_profit_value()
    {
        var inputs = document.getElementsByName("profit");
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].checked) {
                return inputs[i].value;
            }
        }
    }
    function get_balance_value()
    {
        var inputs = document.getElementsByName("balance");
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].checked) {
                return inputs[i].value;
            }
        }
    }
    function get_primary_group()
    {
        var data = { 'op': 'get_primary_group' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillprimarygroup(msg);

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
    function fillprimarygroup(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">GroupCode</th><th scope="col">ShortDescription</th><th scope="col">Longdescription</th><th scope="col">GLtype</th><th scope="col">TrialBalance</th><th scope="col">profitloss</th><th scope="col">Balancesheet</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th scope="row" class="1">' + msg[i].Groupcode + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].Shortdescription + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].Longdescription + '</td>';
            results += '<td data-title="code" class="4">' + msg[i].GLtype + '</td>';
            results += '<td style="display:none" data-title="code" class="9">' + msg[i].GLtype1 + '</td>';
            results += '<td  data-title="code" class="9">' + msg[i].Tradingac + '</td>';
            results += '<td style="display:none" data-title="code" class="5">' + msg[i].Tradingac1 + '</td>';
            results += '<td  data-title="code" class="10">' + msg[i].profitloss + '</td>';
            results += '<td style="display:none" data-title="code" class="6">' + msg[i].profitloss1 + '</td>';
            results += '<td  data-title="code" class="11">' + msg[i].Balancesheet + '</td>';
            results += '<td style="display:none" data-title="code" class="7">' + msg[i].Balancesheet1 + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_primarygroup").html(results);
    }
    function getme(thisid)
    {
        var Groupcode = $(thisid).parent().parent().children('.1').html();
        var Shortdescription = $(thisid).parent().parent().children('.2').html();
        var Longdescription = $(thisid).parent().parent().children('.3').html();
        var GLtype = $(thisid).parent().parent().children('.9').html();
        var Tradingac = $(thisid).parent().parent().children('.5').html();
        var profitloss = $(thisid).parent().parent().children('.6').html();
        var Balancesheet = $(thisid).parent().parent().children('.7').html();
        var sno = $(thisid).parent().parent().children('.8').html();

        document.getElementById('txt_gcode').value = Groupcode;
        document.getElementById('txt_desc').value = Shortdescription;
        document.getElementById('txt_longdesc').value = Longdescription;
        document.getElementById('slct_sys').value = GLtype;
        if (Tradingac == "C") {
            document.getElementById('rdolst_0').checked = true;
        }
        if (Tradingac == "D") {
            document.getElementById('rdolst_1').checked = true;
        }
        if (Tradingac == "N") {
            document.getElementById('rdolst_2').checked = true;
        }
        if (profitloss == "C") {
            document.getElementById('plradio1').checked = true;
        }
        if (profitloss == "D") {
            document.getElementById('plradio2').checked = true;
        }
        if (profitloss == "N") {
            document.getElementById('plradio3').checked = true;
        }
        if (Balancesheet == "C") {
            document.getElementById('bsradio1').checked = true;
        }
        if (Balancesheet == "D") {
            document.getElementById('bsradio2').checked = true;
        }
        if (Balancesheet == "N") {
            document.getElementById('bsradio3').checked = true;
        }
        document.getElementById('btn_PGsave').value = "Modify";
        document.getElementById('lbl_sno').value = sno;
    }
    function clear_groups()
    {
        document.getElementById('txt_gcode').value = "";
        document.getElementById('slct_sys').selectedIndex = 0;
        document.getElementById('txt_desc').value = "";
        document.getElementById('txt_longdesc').value = "";
        document.getElementById('btn_PGsave').value = "Save";
        document.getElementById('rdolst_0').checked = false;
        document.getElementById('rdolst_1').checked = false;
        document.getElementById('rdolst_2').checked = false;
        document.getElementById('plradio1').checked = false;
        document.getElementById('plradio2').checked = false;
        document.getElementById('plradio3').checked = false;
        document.getElementById('bsradio1').checked = false;
        document.getElementById('bsradio2').checked = false;
        document.getElementById('bsradio3').checked = false;
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Group Ledger
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">GroupLedgerDetails</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                 <li id="id_tab" class="active"><a data-toggle="tab" href="#" onclick="showPGdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Primary Group</a></li>
                    <li id="id_tab_Personal" class=""><a data-toggle="tab" href="#" onclick="showGldetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Group Ledger</a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showSubGldetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Sub Group Ledger</a></li>
                </ul>
            </div>
            <div id="divPG" style="display:none">
            <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Primary Group
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_tnsct">
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
                                           Group Code</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_gcode" type="text" class="form-control" placeholder="Enter Group code" />
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
                                        <textarea rows="2" cols="10" id="txt_desc" class="form-control" maxlength="1000"
                                    placeholder="Enter Description"></textarea>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                  <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Long Description</label>
                                    </td>
                                    <td>
                                        <textarea rows="3" cols="20" id="txt_longdesc" class="form-control" maxlength="2000"
                                    placeholder="Enter Long Description"></textarea>
                                    </td>
                                    <td>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            GL Type</label>
                                    </td>
                                    <td>
                                        <select id="slct_sys"  type="text" >
                                            <option value="A">Assets</option>
                                            <option value="L">Liability</option>
                                            <option value="I">Income</option>
                                            <option value="E">Expenditure</option>
                                         </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <%--label>
                                            Trading Account Grouping</label>--%>
                                            <label>
                                            Trial Balance</label>
                                            </td>
                                            <td>
                                                <input id="rdolst_0" type="radio" name="selected" value="C" checked="checked" />
                                                Credit
                                                <input id="rdolst_1" type="radio" name="selected" value="D" />
                                                Debit
                                                <input id="rdolst_2" type="radio" name="selected" value="N" />
                                                None
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Profit/Loss Grouping</label>
                                            </td>
                                            <td>
                                                <input id="plradio1" type="radio" name="profit" value="C" checked="checked" />
                                                Credit
                                                <input id="plradio2" type="radio" name="profit" value="D" />
                                                Debit
                                                <input id="plradio3" type="radio" name="profit" value="N" />
                                                None
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Balance Sheet Grouping</label>
                                            </td>
                                            <td>
                                                <input id="bsradio1" type="radio" name="balance" value="C" checked="checked" />
                                                Credit
                                                <input id="bsradio2" type="radio" name="balance" value="D" />
                                                Debit
                                                <input id="bsradio3" type="radio" name="balance" value="N" />
                                                None
                                    </td>
                                </tr>
                                </table>
                                <table align="center">
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_PGsave" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_primarygroup_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_groups();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_primarygroup">
                            </div>
                        </div>
                    </div>
            
            </div>
            <div id="divGL" style="display: none;">
                 <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Group Ledger
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
                                    Primary Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="slct_pgcode" class="form-control" onchange="Getbankcode();" placeholder="Enter Primary Group"/>
                                <input id="txt_pgid" type="hidden"></input>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_pgname" class="form-control" type="text" />
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_group" class="form-control" type="text" placeholder="Enter Group Code" >
                            </td>
                        </tr>
                        <tr>
                        <tr>
                            <td>
                                <label>
                                    Group short desc</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_gsc" class="form-control" type="text" placeholder="Enter Description" >
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Schedule
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_schd" type="text" class="form-control" placeholder="Enter Schedule" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                   Order
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_order" class="form-control" type="text" placeholder="Enter Order" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Add/Less</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_addless" class="form-control" type="text" placeholder="Enter Amount" />
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
                                    onclick="save_group_ledger()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="cleargroup()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
            </div>
            <div id="div_ledgerdata">
            </div>
        </div>
            <div id="divsubgroup" style="display: none;">
             <div>
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Sub Group Ledger
                        </h3>
                    </div>
                    <div>
                        <table id="tbl_subledger" align="center">
                            <tr>
                                <td style="height: 40px;">
                                    Group Code
                                </td>
                                <td>
                                    <input id="selct_grcode" class="form-control" placeholder="Enter Group Code">
                                    </input>
                                    <input id="txt_groupid" type="hidden"></input>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    Sub Group Code
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txt_subgcode" placeholder="Enter Sub Group Code" />
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Description
                                </td>
                                <td>
                                <textarea rows="3" cols="25" id="txt_subdesc" class="form-control" maxlength="2000"
                                    placeholder="Enter Description"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td style="height: 40px;">
                                    <input id="btnsubgroupsave" type="button" class="btn btn-success" name="submit" value="Save"
                                        onclick="save_subgroup_ledger();">
                                    <input id="btnclose" type="button" class="btn btn-danger" name="submit" value="Clear"
                                        onclick="clearsubgroup();">
                                </td>
                            </tr>
                            <tr hidden>
                                <td>
                                    <label id="lbl_subgroup">
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div>
                        <div id="div_subgroup">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
