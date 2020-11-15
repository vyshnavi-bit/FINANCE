<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="taxtype.aspx.cs" Inherits="taxtype" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        $("#divtax").css("display", "block");
        get_tax_type_details();
        clear_tax_type_Details();
        get_tax_details();
        get_glgroup_details();
        get_group_ledger();
        GetFixedrows();
        GetFixedrows1();
        get_tax1_details();
        emptytable = [];
        emptytable2 = [];
        clear_tax_percentage_Details();
        emptytable3 = [];

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
            $("#divtax").css("display", "block");
            $("#divtaxpercent").css("display", "none");
            $('#showlogs').css('display', 'none');
            $('#div_SectionData1').show();
            $('#div_inwardtable1').show();
            $('#div_SectionData2').hide();
            $('#div_SectionData3').hide();
            $('#div_inwardtable2').hide();
            $('#div_inwardtable3').hide();
        }
        function showbankdetails() {
            $("#divtax").css("display", "none");
            $("#divtaxpercent").css("display", "block");
            $('#showlogs2').css('display', 'block');
            $('#div_SectionData2').show();
            $('#div_SectionData3').show();
            $('#div_inwardtable2').show();
            $('#div_inwardtable3').show();
            clear_tax_type_Details();

            get_tax_details();
            get_glgroup_details();
            get_group_ledger();
            GetFixedrows();
            GetFixedrows1();
            get_tax1_details();
            emptytable = [];
            emptytable2 = [];
            clear_tax_percentage_Details();
            emptytable3 = [];
        }
        function save_tax_type_details() {
            var taxtype = document.getElementById('txt_ptype').value;
            if (taxtype == "") {
                alert("Please Enter tax Type");
                return false;
            }
            var desc = document.getElementById('txt_des').value;
            var btn_val = document.getElementById('btn_save').value;
            var data = { 'op': 'save_tax_type_details', 'taxtype': taxtype, 'description': desc, 'btn_val': btn_val };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_tax_type_details();
                        clear_tax_type_Details();
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
        function get_tax_type_details() {
            var data = { 'op': 'get_tax_type_details' };
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
        function filldetails(msg) {
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">TAX_TYPE</th><th scope="col">DESCRIPTION</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="TAX_TYPE"  class="2">' + msg[i].TAX_TYPE + '</td>';
                results += '<td data-title="DESCRIPTION" class="3">' + msg[i].DESCRIPTION + '</td>';
            }
            results += '</tr></table></div>';
            $("#div_inwardtable1").html(results);
        }
        function getme(thisid) {

            $("#divtax").css("display", "block");
            $("#divtaxpercent").css("display", "none");
            $('#div_SectionData1').show();
            $('#newrow1').css('display', 'none');

            var TAX_TYPE = $(thisid).parent().parent().children('.2').html();
            var DESCRIPTION = $(thisid).parent().parent().children('.3').html();
            document.getElementById('txt_ptype').value = TAX_TYPE;
            document.getElementById('txt_des').value = DESCRIPTION;
            document.getElementById('btn_save').value = "Modify";
        }
        function clear_tax_type_Details() {
            document.getElementById('txt_ptype').value = "";
            document.getElementById('txt_des').value = "";
            document.getElementById('btn_save').value = "Save";
        }
        var description = [];
        function get_tax1_details()
        {
            var data = { 'op': 'get_tax_type_details' };
            var s = function (msg)
            {
                if (msg) {
                    description = msg;
                    var taxlist = [];
                    for (var i = 0; i < msg.length; i++) {
                        var taxtype = msg[i].TAX_TYPE;
                        taxlist.push(taxtype);
                    }
                    $('#slct_taxcode').autocomplete({
                        source: taxlist,
                        change: Getgroupcode,
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
        function Getgroupcode(slct_taxcode) {
            var code = document.getElementById('slct_taxcode').value;
            for (var i = 0; i < description.length; i++) {
                if (code == description[i].TAX_TYPE) {
                    document.getElementById('txt_taxcode').value = description[i].DESCRIPTION;
                    document.getElementById('txt_taxid').value = description[i].sno;

                }
            }
        }
        var shortdes = [];
        function get_glgroup_details() {
            var data = { 'op': 'get_glgroup_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillglgroup(msg);
                        shortdes = msg;

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
        function fillglgroup(msg)
        {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var code = msg[i].groupcode;
                compiledList.push(code);
            }

            $('.clscode').autocomplete({
                source: compiledList,
                change: calTotal,
                autoFocus: true
            });
        }
        var emptytable = [];
        function calTotal() {
            var des = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(des) == -1) {
                for (var i = 0; i < shortdes.length; i++) {
                    if (des == shortdes[i].groupcode) {
                        $(this).closest('tr').find('#txt_desc1').val(shortdes[i].shortdes);
                        $(this).closest('tr').find('#txt_glid2').val(shortdes[i].sno);
                        emptytable.push(des);
                    }
                }
            }
        }
        $(document).click(function () {
            $('#tabledetails1').on('change', '.clscode', calTotal)
            $('#tabledetails').on('change', '.clscode2', calTotal2)
            $('#tabledetails1').on('change', '.clscode3', calTotal3)
        });
        var groupshortdesc = [];
        function get_group_ledger() {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillledger(msg);
                        fillledger3(msg);
                        groupshortdesc = msg;

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
        function fillledger(msg)
        {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var code = msg[i].groupcode;
                compiledList.push(code);
            }

            $('.clscode2').autocomplete({
                source: compiledList,
                change: calTotal2,
                autoFocus: true
            });
        }
        var emptytable2 = [];
        function calTotal2() {
            var des = $(this).val();
            var checkflag = true;
            if (emptytable2.indexOf(des) == -1) {
                for (var i = 0; i < groupshortdesc.length; i++) {
                    if (des == groupshortdesc[i].groupcode) {
                        $(this).closest('tr').find('#txt_desc_ledger').val(groupshortdesc[i].groupshortdesc);
                        $(this).closest('tr').find('#txt_glid').val(groupshortdesc[i].sno);
                        emptytable2.push(des);
                    }


                }
            }
        }
        function fillledger3(msg)
        {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var code = msg[i].groupcode;
                compiledList.push(code);
            }

            $('.clscode3').autocomplete({
                source: compiledList,
                change: calTotal3,
                autoFocus: true
            });
        }
        var emptytable3 = [];
        function calTotal3() {
            var des = $(this).val();
            var checkflag = true;
            if (emptytable3.indexOf(des) == -1) {
                for (var i = 0; i < groupshortdesc.length; i++) {
                    if (des == groupshortdesc[i].groupcode) {
                        $(this).closest('tr').find('#txt_desc_ledger1').val(groupshortdesc[i].groupshortdesc);
                        $(this).closest('tr').find('#txt_glid3').val(groupshortdesc[i].sno);
                        emptytable3.push(des);
                    }
                }
            }
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE For Ledger Posting</th><th scope="col">Description</th><th scope="col">Percentage</th></tr></thead></tbody>';
            for (var i = 1; i < 3; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txt_code" type="text" class="form-control"   placeholder= "Enter Code"  style="width:90px;" /></td>';
                results += '<td ><input id="txt_desc" type="text" class="form-control"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_code_ledger" placeholder= "Enter GL Code" class="clscode2"    style="width:180px;"/></td>';
                results += '<td ><input id="txt_desc_ledger" type="text"  class="clsDescription"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_tab_percent" placeholder= "Enter %" type="text"  class="form-control"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_glid"  class="clsglid"   type="hidden" style="width:180px;"/></td>';
                results += '<td ><input id="txt_sno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData2").html(results);
        }
        var DataTable;
        function insertrow() {
            DataTable = [];
            get_group_ledger();
            var txtsno = 0;
            code = 0;
            desc = 0;
            code_ledger = 0;
            desc_ledger = 0;
            tab_percent = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                code = $(this).find('#txt_code').val();
                desc = $(this).find('#txt_desc').val();
                code_ledger = $(this).find('#txt_code_ledger').val();
                desc_ledger = $(this).find('#txt_desc_ledger').val();
                tab_percent = $(this).find('#txt_tab_percent').val();
                sno = $(this).find('#txt_sno').val();
                DataTable.push({ Sno: txtsno, code: code, desc: desc, code_ledger: code_ledger, desc_ledger: desc_ledger, tab_percent: tab_percent, sno: sno });
                rowsno++;

            });
            code = 0;
            desc = 0;
            code_ledger = 0;
            desc_ledger = 0;
            tab_percent = 0;
            sno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, code: code, desc: desc, code_ledger: code_ledger, desc_ledger: desc_ledger, tab_percent: tab_percent, sno: sno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE for Ledger Posting</th><th scope="col">Description</th><th scope="col">Percentage</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txt_code" type="text" placeholder= "Enter Code" class="form-control"  style="width:90px;"   value="' + DataTable[i].code + '"/></td>';
                results += '<td ><input id="txt_desc" type="text" class="form-control" style="width:90px;" value="' + DataTable[i].desc + '"/></td>';
                results += '<td ><input id="txt_code_ledger" placeholder= "Enter GL Code"  class="clscode2"   style="width:90px;" value="' + DataTable[i].code_ledger + '"/></td>';
                results += '<td ><input id="txt_desc_ledger" type="text" class="clsDescription"  style="width:90px;"  value="' + DataTable[i].desc_ledger + '"/></td>';
                results += '<td ><input id="txt_tab_percent" type="text" placeholder= "Enter %" class="form-control"  style="width:50px;" value="' + DataTable[i].tab_percent + '"/></td>';
                results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="" value="' + DataTable[i].sno + '" ></input></td>';
                results += '<td ><input id="txt_glid"  class="clsglid"   type="hidden" style="width:180px;"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData2").html(results);
        }
        function GetFixedrows1() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails1">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE for Ledger Posting</th><th scope="col">Description</th></tr></thead></tbody>';
            for (var i = 1; i < 3; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno1">' + i + '</td>';
                results += '<td ><input id="txt_code1" class="clscode" placeholder= "Enter Code"   style="width:135px;" /></td>';
                results += '<td ><input id="txt_desc1" type="text" class="clsDescription"  style="width:135px;"/></td>';
                results += '<td ><input id="txt_code_ledger1" placeholder= "Enter GL Code"  class="clscode3"    style="width:135px;"/></td>';
                results += '<td ><input id="txt_desc_ledger1" type="text"  class="clsDescription"   style="width:135px;"/></td>';
                results += '<td ><input id="txt_glid3" type="hidden"/></td>';
                results += '<td ><input id="txt_glid2" type="hidden"/></td>';
                results += '<td ><input id="txt_sno1" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData3").html(results);
        }
        var DataTable1;
        function insertrow1() {
            DataTable1 = [];
            var txtsno1 = 0;
            get_glgroup_details();
            get_group_ledger();
            code1 = 0;
            desc1 = 0;
            code_ledger1 = 0;
            desc_ledger1 = 0;
            //tab_percent = 0;
            var rows = $("#tabledetails1 tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno1 = rowsno;
                code1 = $(this).find('#txt_code1').val();
                desc1 = $(this).find('#txt_desc1').val();
                code_ledger1 = $(this).find('#txt_code_ledger1').val();
                desc_ledger1 = $(this).find('#txt_desc_ledger1').val();
                sno1 = $(this).find('#txt_sno1').val();
                DataTable1.push({ Sno1: txtsno1, code1: code1, desc1: desc1, code_ledger1: code_ledger1, desc_ledger1: desc_ledger1, sno1: sno1 });
                rowsno++;

            });
            code1 = 0;
            desc1 = 0;
            code_ledger1 = 0;
            desc_ledger1 = 0;
            sno1 = 0;
            var Sno1 = parseInt(txtsno1) + 1;
            DataTable1.push({ Sno1: Sno1, code1: code1, desc1: desc1, code_ledger1: code_ledger1, desc_ledger1: desc_ledger1, sno1: sno1 });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails1">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE for Ledger Posting</th><th scope="col">Description</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable1.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno1">' + DataTable1[i].Sno1 + '</td>';
                results += '<td ><input id="txt_code1" class="clscode" placeholder= "Enter Code" style="width:135px;"   value="' + DataTable1[i].code1 + '"/></td>';
                results += '<td ><input id="txt_desc1" type="text" class="clsDescription" style="width:135px;" value="' + DataTable1[i].desc1 + '"/></td>';
                results += '<td ><input id="txt_code_ledger1"  class="clscode3" placeholder= "Enter GL Code"  style="width:135px;" value="' + DataTable1[i].code_ledger1 + '"/></td>';
                results += '<td ><input id="txt_desc_ledger1" type="text" class="clsDescription"  style="width:135px;"  value="' + DataTable1[i].desc_ledger1 + '"/></td>';
                results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno1"  name="" value="' + DataTable1[i].sno1 + '" ></input></td>';
                results += '<td ><input id="txt_glid3" type="hidden"/></td>';
                results += '<td ><input id="txt_glid2" type="hidden"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</tr></table></div>';
            $("#div_SectionData3").html(results);
        }
        function save_tax_percentage_details() {
            var DataTable = [];
            var count = 0
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                code = $(this).find('#txt_code').val();
                desc = $(this).find('#txt_desc').val();
                code_ledger = $(this).find('#txt_code_ledger').val();
                desc_ledger = $(this).find('#txt_desc_ledger').val();
                tab_percent = $(this).find('#txt_tab_percent').val();
                sno = $(this).find('#txt_sno').val();
                var abc = { code: code, desc: desc, code_ledger: code_ledger, desc_ledger: desc_ledger, tab_percent: tab_percent, sno: sno };
                if (code != "") {
                    DataTable.push(abc);
                }
            });

            var DataTable1 = [];
            var count1 = 0;
            var rows1 = $("#tabledetails1 tr:gt(0)");
            var rowsno1 = 1;
            $(rows1).each(function (i, obj) {
                txtsno1 = rowsno;
                code1 = $(this).find('#txt_code1').val();
                desc1 = $(this).find('#txt_desc1').val();
                code_ledger1 = $(this).find('#txt_code_ledger1').val();
                desc_ledger1 = $(this).find('#txt_desc_ledger1').val();
                //tab_percent = $(this).find('#txt_tab_percent').val();
                sno1 = $(this).find('#txt_sno1').val();
                //DataTable1.push({ code1: code1, desc1: desc1, code_ledger1: code_ledger1, desc_ledger1: desc_ledger1, sno1: sno1 }
                var abc1 = { code1: code1, desc1: desc1, code_ledger1: code_ledger1, desc_ledger1: desc_ledger1, sno1: sno1 };
                if (desc1 != "" || desc1 == "0") {
                    DataTable1.push(abc1);
                }
            });
            var rangefrom = document.getElementById('txt_rangefrom').value;
            //var slct_taxcode = document.getElementById('slct_taxcode').value;
            var taxcode = document.getElementById('txt_taxcode').value;
            var taxcodeType = document.getElementById('slct_taxcode').value;
            //document.getElementById('txt_taxcode').value = document.getElementById('slct_taxcode').value;
            if (taxcodeType == "") {
                alert("Please select Tax Code Type");
                return false;
            }
            var rangeto = document.getElementById('txt_rangeto').value;
            var percent = document.getElementById('txt_percent').value;
            var effFrom = document.getElementById('txt_effFrom').value;
            var effTo = document.getElementById('txt_effTo').value;
            var status = document.getElementById('sl_status').value;
            var sno = document.getElementById('lbl_sno2').value;
            var btn_val = document.getElementById('btn_savepercentage').value;
            var data = { 'op': 'save_tax_percent_details', 'sno': sno, 'taxcodeType': taxcodeType, 'taxcode': taxcode, 'rangefrom': rangefrom, 'taxcodeType': taxcodeType, 'rangeto': rangeto, 'percent': percent, 'effFrom': effFrom, 'effTo': effTo, 'status': status, 'DataTable': DataTable, 'DataTable1': DataTable1, 'btn_val': btn_val };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_tax_details();
                        clear_tax_percentage_Details();
                        get_glgroup_details();
                        get_group_ledger();

                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(data, s, e);
        }
        var empdata = [];
        function get_tax_details() {
            var data = { 'op': 'get_tax_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_foreground_tbl(msg);

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
        function fill_foreground_tbl(msg) {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">TAXCODE</th><th scope="col">RANGE_FROM</th><th scope="col">RANGE_TO</th><th scope="col">PERCENTAGE</th><th scope="col">EFFECTIVE_FROM</th><th scope="col">EFFECTIVE_TO</th><th scope="col">STATUS</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="update(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="TAXCODE" class="1" >' + msg[i].taxcodetype + '</td>';
                results += '<td data-title="RANGE_FROM" class="2">' + msg[i].rangefrom + '</td>';
                results += '<td data-title="RANGE_TO" class="3">' + msg[i].rangeto + '</td>';
                results += '<td data-title="PERCENTAGE" class="4">' + msg[i].percent + '</td>';
                results += '<td data-title="EFFECTIVE_FROM" class="5">' + msg[i].effFrom + '</td>';
                results += '<td data-title="EFFECTIVE_TO" class="6">' + msg[i].effTo + '</td>';
                results += '<td data-title="STATUS" class="7">' + msg[i].status + '</td>';
                results += '<td style="display:none;" data-title="sno" class="8">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable2").html(results);
        }
        function update(thisid) {
            var taxcodetype = $(thisid).parent().parent().children('.1').html();
            var rangefrom = $(thisid).parent().parent().children('.2').html();
            var rangeto = $(thisid).parent().parent().children('.3').html();
            var percent = $(thisid).parent().parent().children('.4').html();
            var effFrom = $(thisid).parent().parent().children('.5').html();
            var effTo = $(thisid).parent().parent().children('.6').html(); //.toString[mm / dd / yyyy]
            var status = $(thisid).parent().parent().children('.7').html();
            var sno = $(thisid).parent().parent().children('.8').html();

            document.getElementById('slct_taxcode').value = taxcodetype;
            document.getElementById('txt_rangefrom').value = rangefrom;
            document.getElementById('txt_rangeto').value = rangeto;
            document.getElementById('txt_percent').value = percent;
            document.getElementById('txt_effFrom').value = effFrom;
            document.getElementById('txt_effTo').value = effTo;
            document.getElementById('sl_status').value = status;
            document.getElementById('lbl_sno2').value = sno;
            document.getElementById('btn_savepercentage').value = "Modify";
        }
        var empty = [];
        function clear_tax_percentage_Details() {
            document.getElementById('txt_taxcode').value = "";
            document.getElementById('txt_rangefrom').value = "";
            document.getElementById('slct_taxcode').selectedIndex = 0;
            document.getElementById('txt_rangeto').value = "";
            document.getElementById('txt_percent').value = "";
            document.getElementById('txt_effFrom').value = "";
            document.getElementById('txt_effTo').value = "";
            document.getElementById('sl_status').selectedIndex = 0;
            document.getElementById('txt_code').value = "";
            document.getElementById('txt_desc').value = "";
            document.getElementById('btn_savepercentage').value = "Save";
            GetFixedrows();
            GetFixedrows1();
            get_group_ledger();
            get_glgroup_details();
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<section class="content-header">
        <h1>
           Tax Types
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#"> Tax Types</a></li>
        </ol>
    </section>
     <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showbrfdrdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Tax Types </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showbankdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Tax Type Percentage </a></li>
                </ul>
            </div>
            <div id="divtax" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Tax Type Details
                    </h3>
                </div>
                 <div class="box-body">
                    <div id='fillform'>
                    <table align="center" style="width: 60%;">
                               <table align="center" style="width: 60%;">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Tax Type</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_ptype" type="text" maxlength="45" class="form-control" placeholder="Enter Tax Type" /><label
                                            id="Label1" class="errormessage">* Please Enter Tax Type
                                        </label>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Description</label>
                                    </td>
                                    <td>
                                        <textarea id="txt_des" class="form-control" cols="20" rows="4" placeholder="Enter Description"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_tax_type_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_tax_type_Details();">
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
                        </div>
               <div id="divtaxpercent" style="display: none;">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Tax Type Percentage
                        </h3>
                    </div>
                     <div id='showlogs2' style="display: none;">
                        <table align="center" style="width: 60%;">
                            <tr>
                                <th>
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Tax Type Code :</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td>
                                    <input id="slct_taxcode" class="form-control" placeholder="Enter Tax Type"></input>
                                    <input id="txt_taxid" type="hidden"></input>
                                   
                                </td>
                                <td style="width: 5px">
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_taxcode" class="form-control" type="text" name="taxcode" disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>
                                        Range From</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_rangefrom" type="text" maxlength="45" class="form-control" placeholder="Enter RangeFrom" /><label
                                        id="Label2" class="errormessage">* Please Enter RangeFrom
                                    </label>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>
                                        Range TO</label>
                                </td>
                                <td>
                                    <input id="txt_rangeto" class="form-control" type="text" name="RangeTo" placeholder="Enter RangeTo" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>
                                        Percentage % :</label>
                                </td>
                                <td>
                                    <input id="txt_percent" class="form-control" type="text" name="Percent" placeholder="Enter percentage"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>
                                        Effective FromDate</label>
                                </td>
                                <td>
                                    <input id="txt_effFrom" class="form-control" type="date" name="effFromDate" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>
                                        Effective ToDate</label>
                                </td>
                                <td>
                                    <input id="txt_effTo" class="form-control" type="date" name="effToDate" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Status :</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td>
                                    <select id="sl_status">
                                        <option value="">SELECT</option>
                                        <option value="A">ACTIVE</option>
                                        <option value="I">INACTIVE</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                            </div>
                                <br />
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Other Taxes
                                        </h3>
                                    </div>
                                    <div class="box-body">
                                        <div id="div_SectionData2">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <table align="center" style="width: 60%;">
                                    <tr>
                                <td>
                                </td>
                                <td align="center" style="height: 40px;">
                                    <input id="btn_insert" type="button" class="btn btn-primary" name="submit" value="INSERT ROW"
                                        onclick="insertrow();">
                                </td>
                                    </tr>
                                    </table>
                                    
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Gl Codes
                                        </h3>
                                    </div>
                                    <div class="box-body">
                                        <div id="div_SectionData3">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <table align="center" style="width: 60%;">
                                    <tr>
                                <td>
                                </td>
                                <td align="center" style="height: 40px;">
                                    <input id="btn_insert1" type="button" class="btn btn-primary" name="submit" value="INSERT ROW"
                                        onclick="insertrow1();" />
                                </td>
                                    </tr>
                                </table>
                                </div>

                                <table align="center">
                                    <tr>
                                <td>
                                </td>
                                <td align="center" style="height: 40px;">
                                    <input id="btn_savepercentage" type="button" class="btn btn-success" name="submit" value="Save"
                                        onclick="save_tax_percentage_details();" />
                                    <input id="tn_closepercentage" type="button" class="btn btn-danger" name="submit" value="Clear"
                                        onclick="clear_tax_percentage_Details();" />
                                </td>
                                 </tr>
                                 <td hidden>
                                    <label id="lbl_sno2">
                                    </label>
                                </td>
                                </table>
                                </div>
                            <div>
                    <div id="div_inwardtable2">
                  </div>
             </div>
    </section>
</asp:Content>

