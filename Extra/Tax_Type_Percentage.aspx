<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master"
 AutoEventWireup="true" CodeFile="Tax_Type_Percentage.aspx.cs" Inherits="Tax_Type_Percentage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
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
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
            $.ajax({
                type: "GET",
                url: "DairyFleet.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }

        function isFloat(evt) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            else {
                //if dot sign entered more than once then don't allow to enter dot sign again. 46 is the code for dot sign
                var parts = evt.srcElement.value.split('.');
                if (parts.length > 1 && charCode == 46)
                    return false;
                return true;
            }
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        var description = [];
        function get_tax1_details() {
            var data = { 'op': 'get_tax_type_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldepdetails(msg);
                        description = msg;
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
        function filldepdetails(msg) {
            var data = document.getElementById('slct_taxcode');
            var length = data.options.length;
            document.getElementById('slct_taxcode').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT CODE";
            opt.value = "SELECT CODE";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].TAX_TYPE != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].TAX_TYPE;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function Getgroupcode(slct_taxcode) {
            var code = document.getElementById('slct_taxcode').value;
            for (var i = 0; i < description.length; i++) {
                if (code == description[i].sno) {
                    document.getElementById('txt_taxcode').value = description[i].DESCRIPTION;
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
        function fillglgroup(msg) {
            $('.clscode').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                var opt = document.createElement('option');
                opt.innerHTML = "SELECT CODE";
                opt.value = "SELECT CODE";
                opt.setAttribute("selected", "selected");
                opt.setAttribute("disabled", "disabled");
                opt.setAttribute("class", "dispalynone");
                taxtype[0].appendChild(opt);
                for (var i = 0; i < msg.length; i++) {
                    if (msg[i].groupcode != null) {
                        // if (msg[i].taxtype == "Tax") {
                        var option = document.createElement('option');
                        option.innerHTML = msg[i].groupcode;
                        option.value = msg[i].sno;
                        taxtype[0].appendChild(option);
                    }
                    //}
                }

            });
        }
        var emptytable = [];
        function calTotal() {
            var des = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(des) == -1) {
                for (var i = 0; i < shortdes.length; i++) {
                    if (des == shortdes[i].sno) {
                        $(this).closest('tr').find('#txt_desc1').val(shortdes[i].shortdes);
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

        function fillledger(msg) {
            $('.clscode2').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                var opt = document.createElement('option');
                opt.innerHTML = "SELECT CODE";
                opt.value = "SELECT CODE";
                opt.setAttribute("selected", "selected");
                opt.setAttribute("disabled", "disabled");
                opt.setAttribute("class", "dispalynone");
                taxtype[0].appendChild(opt);
                for (var i = 0; i < msg.length; i++) {
                    if (msg[i].groupcode != null) {
                        // if (msg[i].taxtype == "Tax") {
                        var option = document.createElement('option');
                        option.innerHTML = msg[i].groupcode;
                        option.value = msg[i].sno;
                        taxtype[0].appendChild(option);
                    }
                    //}
                }

            });
        }
        var emptytable2 = [];
        function calTotal2() {
            var des = $(this).val();
            var checkflag = true;
            if (emptytable2.indexOf(des) == -1) {
                for (var i = 0; i < groupshortdesc.length; i++) {
                    if (des == groupshortdesc[i].sno) {
                        $(this).closest('tr').find('#txt_desc_ledger').val(groupshortdesc[i].groupshortdesc);
                        emptytable2.push(des);
                    }


                }
            }
        }
        
        function fillledger3(msg) {
            $('.clscode3').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                var opt = document.createElement('option');
                opt.innerHTML = "SELECT CODE";
                opt.value = "SELECT CODE";
                opt.setAttribute("selected", "selected");
                opt.setAttribute("disabled", "disabled");
                opt.setAttribute("class", "dispalynone");
                taxtype[0].appendChild(opt);
                for (var i = 0; i < msg.length; i++) {
                    if (msg[i].groupcode != null) {
                        // if (msg[i].taxtype == "Tax") {
                        var option = document.createElement('option');
                        option.innerHTML = msg[i].groupcode;
                        option.value = msg[i].sno;
                        taxtype[0].appendChild(option);
                    }
                    //}
                }

            });
        }
        var emptytable3 = [];
        function calTotal3() {
            var des = $(this).val();
            var checkflag = true;
            if (emptytable3.indexOf(des) == -1) {
                for (var i = 0; i < groupshortdesc.length; i++) {
                    if (des == groupshortdesc[i].sno) {
                        $(this).closest('tr').find('#txt_desc_ledger1').val(groupshortdesc[i].groupshortdesc);
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
                results += '<td ><input id="txt_code" type="text" class="form-control"   placeholder= "Code"  style="width:90px;" /></td>';
                results += '<td ><input id="txt_desc" type="text" class="form-control"  style="width:90px;"/></td>';
                results += '<td ><select id="txt_code_ledger"  class="clscode2"    style="width:180px;"/></td>';
                results += '<td ><input id="txt_desc_ledger" type="text"  class="clsDescription"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_tab_percent" type="text"  class="form-control" onkeypress="return isFloat(event)" style="width:90px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td ><input id="txt_sno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
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
                results += '<td ><input id="txt_code" type="text" class="form-control"  style="width:90px;"   value="' + DataTable[i].code + '"/></td>';
                results += '<td ><input id="txt_desc" type="text" class="form-control" style="width:90px;" value="' + DataTable[i].desc + '"/></td>';
                results += '<td ><select id="txt_code_ledger"  class="clscode2"   style="width:90px;" value="' + DataTable[i].code_ledger + '"/></td>';
                results += '<td ><input id="txt_desc_ledger" type="text" class="clsDescription"  style="width:90px;"  value="' + DataTable[i].desc_ledger + '"/></td>';
                results += '<td ><input id="txt_tab_percent" type="text" class="form-control" onkeypress="return isFloat(event)" style="width:50px;" value="' + DataTable[i].tab_percent + '"/></td>';
                results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="" value="' + DataTable[i].sno + '" ></input></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
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

        function GetFixedrows1() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails1">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE for Ledger Posting</th><th scope="col">Description</th></tr></thead></tbody>';
            for (var i = 1; i < 3; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno1">' + i + '</td>';
                results += '<td ><select id="txt_code1" class="clscode"    style="width:135px;" /></td>';//class="clscode"
                results += '<td ><input id="txt_desc1" type="text" class="clsDescription"  style="width:135px;"/></td>';
                results += '<td ><select id="txt_code_ledger1"  class="clscode3"    style="width:135px;"/></td>';
                results += '<td ><input id="txt_desc_ledger1" type="text"  class="clsDescription"   style="width:135px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                //results += '<td ><input id="txt_tab_percent" type="text"  class="form-control"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_sno1" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row1").html(results);
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
                //tab_percent = $(this).find('#txt_tab_percent').val();
                sno1 = $(this).find('#txt_sno1').val();
                DataTable1.push({ Sno1: txtsno1, code1: code1, desc1: desc1, code_ledger1: code_ledger1, desc_ledger1: desc_ledger1, sno1: sno1 });
                rowsno++;

            });
            code1 = 0;
            desc1 = 0;
            code_ledger1 = 0;
            desc_ledger1 = 0;
            //tab_percent = 0;
            sno1 = 0;
            var Sno1 = parseInt(txtsno1) + 1;
            DataTable1.push({ Sno1: Sno1,code1: code1, desc1: desc1, code_ledger1: code_ledger1, desc_ledger1: desc_ledger1, sno1: sno1 });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails1">';
            results += '<thead><tr><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE for Ledger Posting</th><th scope="col">Description</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable1.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno1">' + DataTable1[i].Sno1 + '</td>';
                results += '<td ><select id="txt_code1" class="clscode"  style="width:135px;"   value="' + DataTable1[i].code1 + '"/></td>';
                results += '<td ><input id="txt_desc1" type="text" class="clsDescription" style="width:135px;" value="' + DataTable1[i].desc1 + '"/></td>';
                results += '<td ><select id="txt_code_ledger1"  class="clscode3"   style="width:135px;" value="' + DataTable1[i].code_ledger1 + '"/></td>';
                results += '<td ><input id="txt_desc_ledger1" type="text" class="clsDescription"  style="width:135px;"  value="' + DataTable1[i].desc_ledger1 + '"/></td>';
                //results += '<td ><input id="txt_bloodgrp" type="text" class="form-control"  style="width:50px;" value="' + DataTable[i].tab_percent + '"/></td>';
                results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno1"  name="" value="' + DataTable1[i].sno1 + '" ></input></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                // results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</tr></table></div>';
            $("#div_insert_row1").html(results);
        }

        function save_tax_percentage_details() {
            var DataTable = [];
            var count = 0;
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
            if (rangefrom == "") {
                alert("Enter  range from ");
                return false;
            }
            //var slct_taxcode = document.getElementById('slct_taxcode').value;
            var taxcode = document.getElementById('txt_taxcode').value;
            if (taxcode == "") {
                alert("Enter  tax code");
                return false;
            }
            var taxcodeType = document.getElementById('slct_taxcode').value;
            if (taxcodeType == "") {
                alert("Enter  tax code Type");
                return false;
            }
            //document.getElementById('txt_taxcode').value = document.getElementById('slct_taxcode').value;
            var rangeto = document.getElementById('txt_rangeto').value;
            if (rangeto == "") {
                alert("Enter   range to");
                return false;
            }
            var percent = document.getElementById('txt_percent').value;
            if (percent == "") {
                alert("Enter  percent");
                return false;
            }
            var effFrom = document.getElementById('txt_effFrom').value;
            var effTo = document.getElementById('txt_effTo').value;
            if (effTo == "") {
                alert("Enter  eff To");
                return false;
            }
            //var sl_status = document.getElementById('sl_status').value;
            var status = document.getElementById('sl_status').value;
            if (status == "") {
                alert("Enter  status");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btn_val = document.getElementById('btn_save').value;
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
            //callHandler(data, s, e);
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
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">TAXCODE</th><th scope="col">RANGE_FROM</th><th scope="col">RANGE_TO</th><th scope="col">PERCENTAGE</th><th scope="col">EFFECTIVE_FROM</th><th scope="col">EFFECTIVE_TO</th><th scope="col">STATUS</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="update(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="TAXCODE" class="1" >' + msg[i].taxcodetype + '</td>';
                results += '<td style="display:none;" data-title="" class="9" >' + msg[i].taxcodetype1 + '</td>';
                results += '<td data-title="RANGE_FROM" class="2">' + msg[i].rangefrom + '</td>';
                results += '<td data-title="RANGE_TO" class="3">' + msg[i].rangeto + '</td>';
                results += '<td data-title="PERCENTAGE" class="4">' + msg[i].percent + '</td>';
                results += '<td data-title="EFFECTIVE_FROM" class="5">' + msg[i].effFrom + '</td>';
                results += '<td data-title="EFFECTIVE_TO" class="6">' + msg[i].effTo + '</td>';
                results += '<td data-title="STATUS" class="7">' + msg[i].status + '</td>';
                results += '<td style="display:none;" data-title="sno" class="8">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_tax_percent").html(results);
        }
        function update(thisid) {
            var taxcodetype = $(thisid).parent().parent().children('.1').html();
            var taxcodetype1 = $(thisid).parent().parent().children('.9').html();
            var rangefrom = $(thisid).parent().parent().children('.2').html();
            var rangeto = $(thisid).parent().parent().children('.3').html();
            var percent = $(thisid).parent().parent().children('.4').html();
            var effFrom = $(thisid).parent().parent().children('.5').html();
            var effTo = $(thisid).parent().parent().children('.6').html(); //.toString[mm / dd / yyyy]
            var statuscode = $(thisid).parent().parent().children('.7').html();

            if (statuscode == "InActive") {

                status = "I";
            }
            else {
                status = "A";
            }

            var sno = $(thisid).parent().parent().children('.8').html();

            document.getElementById('slct_taxcode').value = taxcodetype1;
            document.getElementById('txt_rangefrom').value = rangefrom;
            document.getElementById('txt_rangeto').value = rangeto;
            document.getElementById('txt_percent').value = percent;
            document.getElementById('txt_effFrom').value = effFrom;
            document.getElementById('txt_effTo').value = effTo;
            document.getElementById('sl_status').value = status;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            var data = { 'op': 'get_tax_per_other_details', 'refno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_othertaxes(msg);

                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
            get_group_ledger();

            var data = { 'op': 'get_tax_per_glcode_details', 'refno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_glcodetaxes(msg);

                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
            get_group_ledger();
            get_glgroup_details();
        }
        function fill_othertaxes(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE for Ledger Posting</th><th scope="col">Description</th><th scope="col">Percentage</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + (k + 1) + '</td>';
                results += '<td ><input id="txt_code" type="text" class="form-control" value="' + msg[k].code + '"   placeholder= "Code"  style="width:90px;" /></td>';
                results += '<td ><input id="txt_desc" type="text" class="form-control" value="' + msg[k].desc + '" style="width:90px;"/></td>';
                results += '<td ><select id="txt_code_ledger"  class="clscode2" value="' + msg[k].code_ledger + '" class="form-control"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_desc_ledger" type="text"  class="clsDescription" value="" class="form-control"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_tab_percent" type="text" onkeypress="return isFloat(event)" class="form-control" value="' + msg[k].tab_percent + '" style="width:90px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td ><input  type="hidden" id="txt_sno"  class="form-control" value="' + msg[k].sno + '" class="form-control"  style="width:90px;"/></td></tr>';
                //results += '<td style="display:block;" id="txt_sno"  value="' + msg[k].sno + '" class="form-control"  style="width:90px;"/></td></tr>';
            } //data-title="sno"
            results += '</table></div>';
            $("#div_insert_row").html(results);
            get_tax_details();
            get_glgroup_details();
            get_group_ledger();
        }

        function fill_glcodetaxes(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails1">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th><th scope="col">Description</th><th scope="col">GL CODE for Ledger Posting</th><th scope="col">Description</th></tr></thead></tbody>';
            for (var n = 0; n < msg.length; n++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + (n + 1) + '</td>';
                results += '<td ><select id="txt_code1" class="clscode" value="' + msg[n].code1 + '"   placeholder= "Code"  style="width:90px;" /></td>';
                results += '<td ><input id="txt_desc1" type="text" class="clsDescription" value="' + msg[n].desc1 + '" style="width:90px;"/></td>';
                results += '<td ><select id="txt_code_ledger1"  class="clscode3" value="' + msg[n].code_ledger1 + '" class="form-control"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_desc_ledger1" type="text"  class="clsDescription" value="" class="form-control"  style="width:90px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td ><input  type="hidden" id="txt_sno1"  class="form-control" value="' + msg[n].sno1 + '" class="form-control"  style="width:90px;"/></td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row1").html(results);
            get_tax_details();
            get_glgroup_details();
            get_group_ledger();
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
            document.getElementById('btn_save').value = "Save";
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
            Tax Type Percentage
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Tax type Percentage</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Tax Type Percentage
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
                        </div>
                        <div id='fillform'>
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
                                <td >
                                    <select id="slct_taxcode"  onchange="Getgroupcode(this);">
                                       <%-- <option value
                                            ="SELECT CODE">SELECT CODE</option>--%>
                                        <%--<option value="1">TAXTYPE</option>
                                        <option value="2">TAXTYPE_DESC</option>--%>
                                    </select>
                                </td>
                                    <td style="width:5px">

                                    </td>
                                <td style="height: 40px;">
                                    <input id="txt_taxcode" class="form-control" type="text" name="taxcode" readonly="readonly" />
                                </td>
                            </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Range From</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_rangefrom" type="text" maxlength="45" onkeypress="return isNumber(event)" class="form-control" /><label
                                            id="Label1" class="errormessage">* Please Enter RangeFrom
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
                                        <input id="txt_rangeto" class="form-control" type="text" onkeypress="return isNumber(event)" name="RangeTo" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Percentage % :</label>
                                    </td>
                                    <td>
                                        <input id="txt_percent" class="form-control" type="text" onkeypress="return isFloat(event)" name="Percent" />
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
                                <td >
                                    <select id="sl_status">
                                        <option value
                                            ="">SELECT</option>
                                        <option value="A">ACTIVE</option>
                                        <option value="I">INACTIVE</option>
                                    </select>
                                </td>
                            </tr>
                            
                          </table>
                       </div>

                        <div>
                            <div>
                            <table>
                                 <tr>
                                    <td>
                                    <label>
                                        Other Taxes :</label>
                                </td>
                                </tr>
                            </table>
                            </div>
                            <div id="div_insert_row">
                            </div>
                            <table align="center" style="width: 60%;">
                                 <tr>
                                    <td></td>
                                    <td  align="center" style="height: 40px;">
                                        <input id="btn_insert" type="button" class="btn btn-primary" name="submit" value="INSERT ROW"
                                            onclick="insertrow();">
                                        </td>
                                </tr>
                            </table>
                            
                        </div>
                        <div>
                            <table>
                                 <tr>
                                    <td>
                                    <label>
                                        GL Codes : </label>
                                </td>
                                </tr>
                            </table>
                            <div id="div_insert_row1">
                            </div>
                            <table align="center" style="width: 60%;">
                                 <tr>
                                    <td></td>
                                    <td align="center" style="height: 40px;">
                                        <input id="btn_insert1" type="button" class="btn btn-primary" name="submit" value="INSERT ROW"
                                            onclick="insertrow1();">
                                        </td>
                                </tr>
                            </table>
                            
                        </div>
                        <div class="box-header with-border">
                            <table align="center" style="width: 60%;">
                                <%--<tr>
                                    <td></td>
                                    <td style="height: 40px;">
                                        <input id="btn_insert" type="button" class="btn btn-primary" name="submit" value="INSERT ROW"
                                            onclick="insertrow();">
                                        </td>
                                </tr>--%>
                                <tr>
                                    <td></td>
                                    <td  align="center" style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_tax_percentage_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_tax_percentage_Details();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_tax_percent">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

