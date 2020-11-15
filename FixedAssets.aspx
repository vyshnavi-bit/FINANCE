<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="FixedAssets.aspx.cs" Inherits="FixedAssets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_fixed_assets();
        get_Branch_details();
        get_accountmaster_click();
        emptytable = [];
        $('#btn_addswab').click(function () {
            $('#fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_editswabdata').hide();
            GetFixedAssets();
            get_Branch_details();
            get_accountmaster_click();
            emptytable = [];
        });
        $('#btn_close').click(function () {
            $('#fillform').css('display', 'none');
            $('#showlogs').css('display', 'block');
            $('#div_editswabdata').show();
            forclearall();
        });

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
    function GetFixedAssets() {
        var results = '<div style="overflow:auto;"><table id="tbl_swab_details" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">BranchCode</th><th scope="col">AccountCode</th><th scope="col">AccountDescription</th><th scope="col">GroupCode</th><th scope="col">Dep.Rate</th></tr></thead></tbody>';
        for (var i = 1; i < 10; i++) {
            results += '<td data-title="Sno" id="txtsno" class="1">' + i + '</td>';
            results += '<td data-title="Branch Code" style="text-align:center;" ><input class="clscode"  type="text" placeholder="Branch Code"   id="txt_branchcode" onchange="Getbranchname(this);"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
            results += '<td data-title="Account Code" style="text-align:center;" ><input class="clscode2" type="text"  placeholder="Account Code" id="txt_accountcode"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
            results += '<td data-title="Account Description" style="text-align:center;" ><input class="clsDescription" type="text" placeholder="Account Description"    id="txt_accountdes" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
            results += '<td data-title="Group Code" style="text-align:center;" ><input class="clsDescription" type="text" class="form-control" name="Group Code" id="txt_groupcode" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;" ></td>';
            results += '<td data-title="Dep. Rate" style="text-align:center;" ><input type="text" onkeypress="return isNumber(event)" class="form-control" placeholder="Dep. Rate" id="txt_deprate" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;" ></td>';
            results += '<td data-title="Group Code" style="text-align:center;" ><input class="clsDescription" type="text" class="form-control" name="Group Code" id="txt_groupid" style="display: none;" ></td>';
            results += '<td data-title="Branch Code" style="text-align:center;" ><input class="clsDescription"  type="text" placeholder="Branch Code"   id="txt_accountid"  style="display: none;" /></td>';
            results += '<td data-title="Branch Code" style="text-align:center;" ><input class="clsDescription"  type="text" placeholder="Branch Code"   id="txt_branchid"  style="display: none;" /></td>';
            results += '<td data-title="Minus"><input id="btn_poplate" type="button"  onclick="removerow(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
            results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
        }
        results += '</table></div>';
        $("#div_swabdata").html(results);
    }
    var DataTable;
    function add_swab() {
        DataTable = [];
        accountdescription = 0;
        deprate = 0;
        var txtsno = 0;
        var sno = 0;
        var rows = $("#tbl_swab_details tr:gt(0)");
        var rowsno = 1;
        $(rows).each(function (i, obj) {

            txtsno = rowsno;
            branchcode = $(this).find('#txt_branchcode').val();
            accountcode = $(this).find('#txt_accountcode').val();
            accountdescription = $(this).find('#txt_accountdes').val();
            groupcode = $(this).find('#txt_groupcode').val();
            groupid = $(this).find('#txt_groupid').val();
            deprate = $(this).find('#txt_deprate').val();
            branchid = $(this).find('#txt_branchid').val();
            accountid = $(this).find('#txt_accountid').val();
            sno = $(this).find('#hdnproductsno').val();
            DataTable.push({ Sno: txtsno, branchcode: branchcode, branchid: branchid, accountid: accountid, accountcode: accountcode, accountdescription: accountdescription, groupcode: groupcode, groupid: groupid, deprate: deprate, sno: sno });
            rowsno++;

        });
        branchcode = 0;
        accountcode = 0;
        accountdescription = 0;
        groupcode = 0;
        deprate = 0;
        var Sno = parseInt(txtsno) + 1;
        DataTable.push({ Sno: Sno, branchcode: branchcode, branchid: branchid, accountid: accountid, accountcode: accountcode, accountdescription: accountdescription, groupcode: groupcode, groupid: groupid, deprate: deprate, sno: sno });
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tbl_swab_details">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">BranchCode</th><th scope="col">AccountCode</th><th scope="col">AccountDescription</th><th scope="col">GroupCode</th><th scope="col">Dep.Rate</th></tr></thead></tbody>';
        for (var i = 0; i < DataTable.length; i++) {
            results += '<tr><td scope="row"  style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
            results += '<td ><input id="txt_branchcode" type="text" class="clscode"  style="font-size:12px;padding: 0px 5px;height:30px;"   value="' + DataTable[i].branchcode + '"/></td>';
            results += '<td ><input id="txt_accountcode" type="text"  class="clscode2" style="font-size:12px;padding: 0px 5px;height:30px;" value="' + DataTable[i].accountcode + '"/></td>';
            results += '<td ><input id="txt_accountdes" type="text" class="clsDescription" style="font-size:12px;padding: 0px 5px;height:30px;" value="' + DataTable[i].accountdescription + '"/></td>';
            results += '<td ><input id="txt_groupcode" type="text" class="clsDescription" style="font-size:12px;padding: 0px 5px;height:30px;" value="' + DataTable[i].groupcode + '"/></td>';
            results += '<td ><input id="txt_deprate" type="text" onkeypress="return isNumber(event)"  style="font-size:12px;padding: 0px 5px;height:30px;" value="' + DataTable[i].deprate + '"/></td>';
            results += '<td ><input id="txt_branchid" type="text"  value="' + DataTable[i].branchid + '" style="display: none;"/></td>';
            results += '<td ><input id="txt_groupid" type="text"  value="' + DataTable[i].groupid + '" style="display: none;"/></td>';
            results += '<td ><input id="txt_accountid" type="text"  value="' + DataTable[i].accountid + '" style="display: none;" /></td>';
            results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
            results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
            results += '<td style="display:none" class="6">' + i + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_swabdata").html(results);
        get_Branch_details();
        get_accountmaster_click();
    }
    var DataTable;
    function removerow(thisid) {
        $(thisid).parents('tr').remove();
    }
    var replaceHtmlEntites = (function () {
        return function (s) {
            return (s.replace(translate_re, function (match, entity) {
                return translate[entity];
            }));
        }
    })();
    function save_fixed_assets() {
        var btnval = document.getElementById('btn_save').value;
        var sno = document.getElementById('lbl_sno').value;
        var fixedassetsarray = [];
        $('#tbl_swab_details> tbody > tr').each(function () {
            var branchcode = $(this).find('#txt_branchcode').val();
            var accountcode = $(this).find('#txt_accountcode').val();
            var accountdescription = $(this).find('#txt_accountdes').val();
            var groupcode = $(this).find('#txt_groupcode').val();
            var deprate = $(this).find('#txt_deprate').val();
            var hdnproductsno = $(this).find('#hdnproductsno').val();
            var branchid = $(this).find('#txt_branchid').val();
            var accountid = $(this).find('#txt_accountid').val();
            var groupid = $(this).find('#txt_groupid').val();
            if (deprate == "" || deprate == "0") {
            }
            else {
                fixedassetsarray.push({ 'branchcode': branchcode, 'branchid': branchid, 'accountid': accountid, 'accountcode': accountcode, 'accountdescription': accountdescription, 'groupcode': groupcode, 'groupid': groupid, 'deprate': deprate, 'hdnproductsno': hdnproductsno });
            }
        });
        var data = { 'op': 'save_fixed_assets', 'btnval': btnval, 'sno': sno, 'fixedassetsarray': fixedassetsarray };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                forclearall();
                $('#fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_swabdata').show();
                $('#div_editswabdata').show();
                get_fixed_assets();
            }

        };
        var e = function (x, h, e) {
        };
        CallHandlerUsingJson(data, s, e);
    }
    function forclearall() {
        document.getElementById('btn_save').value = "Save";
        document.getElementById('lbl_sno').value = "";
    }
    var filldescrption = [];
    function get_Branch_details() {
        var data = { 'op': 'get_Branch_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldata(msg);
                    filldescrption = msg;
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
    function filldata(msg) {
        var compiledList = [];
        for (var i = 0; i < msg.length; i++) {
            var productname = msg[i].branchname;
            compiledList.push(productname);
        }

        $('.clscode').autocomplete({
            source: compiledList,
            change: test,
            autoFocus: true
        });
    }
    var emptytable = [];
    function test() {
        var productname = $(this).val();
        var checkflag = true;
        if (emptytable1.indexOf(productname) == -1) {
            for (var i = 0; i < filldescrption.length; i++) {
                if (productname == filldescrption[i].branchname) {
                    $(this).closest('tr').find('#txt_branchid').val(filldescrption[i].branchid);
                    emptytable1.push(productname);
                }
            }
        }
    }
    var filldescrption1 = [];
    function get_accountmaster_click() {
        var data = { 'op': 'get_accountmaster_click' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldata1(msg);
                    filldescrption1 = msg;
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
    function filldata1(msg) {
        var compiledList = [];
        for (var i = 0; i < msg.length; i++) {
            var productname = msg[i].accountcode;
            compiledList.push(productname);
        }

        $('.clscode2').autocomplete({
            source: compiledList,
            change: filldesc,
            autoFocus: true
        });
    }
    var emptytable1 = [];
    function filldesc()
    {
        var productname = $(this).val();
        var checkflag = true;
        if (emptytable1.indexOf(productname) == -1) {
            for (var i = 0; i < filldescrption1.length; i++) {
                if (productname == filldescrption1[i].accountcode) {
                    $(this).closest('tr').find('#txt_accountdes').val(filldescrption1[i].accshortdescription);
                    $(this).closest('tr').find('#txt_groupcode').val(filldescrption1[i].groupcode);
                    $(this).closest('tr').find('#txt_groupid').val(filldescrption1[i].groupid);
                    $(this).closest('tr').find('#txt_accountid').val(filldescrption1[i].sno);
                    emptytable1.push(productname);
                }
            }
        }
    }
    var partytds = [];
    function get_fixed_assets() {
        var data = { 'op': 'get_fixed_assets' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fill_fixed_assets_details(msg);

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
    var tdssub = [];
    function fill_fixed_assets_details(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
        results += '<thead><tr><th scope="col"></th><th scope="col">BranchName</th><th scope="col">AccountNumber</th><th scope="col">AccountDescription</th><th scope="col">GroupCode</th><th scope="col">DepRate</th><th scope="col">DateOfEntry</th></tr></thead></tbody>';
        //var tds = msg[0].fixedassets;
        tdssub = msg[0].fixedassetssub;
        var l = 0;
        var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
        for (var i = 0; i < tdssub.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getpartytdsentry(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td data-title="groupcode" style="display:none;" class="1" >' + tdssub[i].hdnproductsno + '</td>';
            results += '<td data-title="partytype" style="display:none;"  class="2">' + tdssub[i].accountcode + '</td>';
            results += '<td data-title="partytype" style="display:none;"  class="3">' + tdssub[i].groupid + '</td>';
            results += '<td data-title="partytype"   class="4">' + tdssub[i].branchname + '</td>';
            results += '<td data-title="doe" style="display:none;" class="6">' + tdssub[i].branchid + '</td>';
            results += '<td data-title="groupname"  class="7" >' + tdssub[i].accountid + '</td>';
            results += '<td data-title="certificateno"  class="8">' + tdssub[i].accountdescription + '</td>';
            results += '<td data-title="certificateno"  class="9">' + tdssub[i].groupcode + '</td>';
            results += '<td data-title="certificateno"  class="10">' + tdssub[i].deprate + '</td>';
            //results += '<td data-title="certificateno"  class="12">' + tdssub[i].accountdescription + '</td>';
            results += '<td data-title="doe"   class="11">' + tdssub[i].doe + '</td></tr>'; 
        }
        results += '</table></div>';
        $("#div_editswabdata").html(results);
    }
    function getpartytdsentry(thisid) {
        $('#fillform').css('display', 'block');
        $('#showlogs').css('display', 'none');
        $('#div_editswabdata').hide();

        var sno = $(thisid).parent().parent().children('.1').html();
        //document.getElementById('lbl_sno').value = sno;
        document.getElementById('btn_save').value = "Modify";

        var table = document.getElementById("tabledetails");
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tbl_swab_details">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">BranchCode</th><th scope="col">AccountCode</th><th scope="col">AccountDescription</th><th scope="col">GroupCode</th><th scope="col">DepRate</th></tr></thead></tbody>';
        var k = 1;
        for (var i = 0; i < tdssub.length; i++) {
            if (sno == tdssub[i].hdnproductsno) {
                results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                results += '<td data-title="From"><input id="txt_branchcode" class="clscode" name="glcode"  value="' + tdssub[i].branchname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                results += '<td data-title="From"><input id="txt_accountcode" class="clscode2" name="groupname"  value="' + tdssub[i].accountid + '"style="width:100; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                results += '<td data-title="From"><input  id="txt_accountdes"  class="clsDescription" value="' + tdssub[i].accountdescription + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                results += '<td data-title="From"><input  id="txt_groupcode" class="clsDescription" name="percentage" value="' + tdssub[i].groupcode + '"  style="width:100; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                results += '<td data-title="From"><input id="txt_deprate" class="form-control" name="exemptionamount" onkeypress="return isNumber(event)"  value="' + tdssub[i].deprate + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td data-title="From" style="display:none"><input  id="txt_branchid" class="clsDescription" name="percentage" value="' + tdssub[i].branchid + '"   ></td>';
                results += '<td data-title="From" style="display:none"><input  id="txt_groupid" class="clsDescription" name="percentage" value="' + tdssub[i].groupid + '"   ></td>';
                results += '<td data-title="From" style="display:none"><input  id="txt_accountid" class="clsDescription" name="percentage" value="' + tdssub[i].accountcode + '" ></td>';
                results += '<td data-title="From" style="display:none"><input class="form-control" id="hdnproductsno"  value="' + tdssub[i].hdnproductsno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                k++;
            }
        }
        results += '</table></div>';
        $("#div_swabdata").html(results);
        get_Branch_details();
        get_accountmaster_click();
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
            Fixed Assets
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transactions</a></li>
            <li><a href="#">Fixed Assets </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-body">
                <div id="showlogs" align="center">
                    <input id="btn_addswab" type="button" name="submit" value='Add FixedAssets' class="btn btn-success" />
                </div>
                <div id="div_editswabdata">
                </div>
                <div id='fillform' style="display: none;">
                    <div>
                        <div class="box-body">
                            <div id="div_swabdata">
                            </div>
                        </div>
                        <p id="newrow">
                            <input type="button" id="btn_addswabdetails" onclick="add_swab();" class="btn btn-default"
                                value="Insert row" /></p>
                    </div>
                    <label id="lbl_sno" style="display: none;">
                    </label>
                    <div id="">
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <input type="button" class="btn btn-success" id="btn_save" value="Save" onclick="save_fixed_assets();" />
                                <input type="button" class="btn btn-danger" id="btn_close" value="Clear" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </section>


</asp:Content>

