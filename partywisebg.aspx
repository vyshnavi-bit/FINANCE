<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="partywisebg.aspx.cs" Inherits="partywisebg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $("#divbank").css("display", "block");
            get_group_ledger();
            get_party_type1_details();
            get_party_typebg_details();
            get_party_typebank_details();
            GetFixedrows1();
            clearbgdetails();
            GetFixedrows2();
            get_bank_details();
            emptytable = [];
            get_bankifsc_details();
            emptytable2 = [];
            clearbankdetails();
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txt_date').val(yyyy + '-' + mm + '-' + dd);
            $('#txt_date1').val(yyyy + '-' + mm + '-' + dd);
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
            clearbgdetails();
        }
        function showbankdetails() {
            $("#divbank").css("display", "none");
            $("#divifsc").css("display", "block");
            $('#showlogs2').css('display', 'block');
            $('#div_SectionData2').show();
            $('#div_inwardtable2').show();
            get_party_typebank_details();
            get_bank_details();
            GetFixedrows2();
            emptytable = [];
            get_bankifsc_details(); 
            emptytable2 = [];
            clearbankdetails();
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txt_date1').val(yyyy + '-' + mm + '-' + dd);
        }
        var branchname = [];
        function get_group_ledger() {
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
        function get_party_type1_details() {
            var data = { 'op': 'get_party_master' };
            var s = function (msg) {
                if (msg) {
                    branchname1 = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].party_name;
                        empnameList.push(empname);
                    }
                    $('#txt_partycode1').autocomplete({
                        source: empnameList,
                        change: Getpartycode,
                        autoFocus: true
                    });
                    $('#txt_partycode2').autocomplete({
                        source: empnameList,
                        change: Getpartycode2,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getpartycode() {
            var empname = document.getElementById('txt_partycode1').value;
            for (var i = 0; i < branchname1.length; i++) {
                if (empname == branchname1[i].party_name) {
                    document.getElementById('txt_partyid1').value = branchname1[i].sno;
                    document.getElementById('txt_partyname1').value = branchname1[i].party_code;
                }
            }
        }
        function Getpartycode2() {
            var empname = document.getElementById('txt_partycode2').value;
            for (var i = 0; i < branchname1.length; i++) {
                if (empname == branchname1[i].party_name) {
                    document.getElementById('txt_partyid2').value = branchname1[i].sno;
                    document.getElementById('txt_partyname2').value = branchname1[i].party_code;
                }
            }
        }
        var filldescrption = [];
        function get_bank_details() {
            var data = { 'op': 'get_bank_details' };
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
                var productname = msg[i].code;
                compiledList.push(productname);
            }

            $('.clscode').autocomplete({
                source: compiledList,
                change: bankname,
                autoFocus: true
            });
        }
        var emptytable = [];
        function bankname() {
            var productname = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(productname) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (productname == filldescrption[i].code) {
                        $(this).closest('tr').find('#txt_bankid').val(filldescrption[i].sno);
                        $(this).closest('tr').find('#txt_bankname').val(filldescrption[i].name);
                        emptytable.push(productname);
                    }
                }
            }
        }
        var filldescrption1 = [];
        function get_bankifsc_details() {
            var data = { 'op': 'get_bankifsc_details' };
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
            var compiledList1 = [];
            for (var i = 0; i < msg.length; i++) {
                var productname = msg[i].Ifsccode;
                compiledList1.push(productname);
            }

            $('.clscode2').autocomplete({
                source: compiledList1,
                change: getbranchname,
                autoFocus: true
            });
        }
        var emptytable1 = [];
        function getbranchname() {
            var productname = $(this).val();
            var checkflag = true;
            if (emptytable1.indexOf(productname) == -1) {
                for (var i = 0; i < filldescrption1.length; i++) {
                    if (productname == filldescrption1[i].Ifsccode) {
                        $(this).closest('tr').find('#txt_branchid').val(filldescrption1[i].sno);
                        $(this).closest('tr').find('#txt_branchname').val(filldescrption1[i].branchname);
                        emptytable1.push(productname);
                    }
                }
            }
        }
        function GetFixedrows1() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Type</th><th scope="col">BG/FDR No.</th><th scope="col">Value</th><th scope="col">BG/FDR Date</th><th scope="col">Effective From</th><th scope="col">Expiry Date</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 1; i < 10; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td data-title="Phosps" ><select id="txt_type" type="text" class="form-control" placeholder= "Type"  style="width:90px;"><option   value="0">select</option><option   value="BG">BG</option><option  value="FDR">FDR</option></select></td>';
                results += '<td ><input id="txt_number" type="text" class="form-control" placeholder= "BG/FDR Number" style="width:140px;"/></td>';
                results += '<td ><input id="txt_value" type="text" onkeypress="return isNumber(event)"  placeholder= "Value" class="form-control"  style="width:140px;"/></td>';
                results += '<td ><input id="txt_bgdate" type="date"  class="form-control" onblur="compareDates();" placeholder= "BG/FDR Date"   style="width:150px;"/></td>';
                results += '<td ><input id="txt_effective" type="text"  class="form-control" placeholder= "EffectiveFrom"   style="width:150px;"/></td>';
                results += '<td ><input id="txt_expireydate" type="date"  class="form-control" onblur="compareDates1();" placeholder= "ExpireyDate" style="width:150px;"/></td>';
                results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:90px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData1").html(results);
        }
        var DataTable;
        function insertrow1() {
            DataTable = [];
            var txtsno = 0;
            type = 0;
            number = 0;
            value = 0;
            bgdate = 0;
            effective = 0;
            expireydate = 0;
            remarks = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                type = $(this).find('#txt_type').val();
                number = $(this).find('#txt_number').val();
                value = $(this).find('#txt_value').val();
                bgdate = $(this).find('#txt_bgdate').val();
                effective = $(this).find('#txt_effective').val();
                expireydate = $(this).find('#txt_expireydate').val();
                remarks = $(this).find('#txt_remarks').val();
                sno = $(this).find('#txt_sno').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                DataTable.push({ Sno: txtsno, type: type, number: number, value: value, bgdate: bgdate, effective: effective, expireydate: expireydate, remarks: remarks, hdnproductsno: hdnproductsno });
                rowsno++;
            });
            type = 0;
            number = 0;
            value = 0;
            bgdate = 0;
            effective = 0;
            expireydate = 0;
            remarks = 0;
            hdnproductsno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, type: type, number: number, value: value, bgdate: bgdate, effective: effective, expireydate: expireydate, remarks: remarks, hdnproductsno: hdnproductsno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Type</th><th scope="col">BG/FDR No.</th><th scope="col">Value</th><th scope="col">BG/FDR Date</th><th scope="col">Effective From</th><th scope="col">Expiry Date</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td data-title="Phosps"  ><select id="txt_type" class="form-control" style="width:90px;" ><option   value="BG">BG</option><option  value="FDR">FDR</option></select></td>';
                results += '<td ><input id="txt_number" type="text" class="form-control" placeholder= "BG/FDR Number" style="width:140px;" value="' + DataTable[i].number + '"/></td>';
                results += '<td ><input id="txt_value"  type="text" onkeypress="return isNumber(event)" class="form-control" placeholder= "Value"  style="width:140px;" value="' + DataTable[i].value + '"/></td>';
                results += '<td ><input id="txt_bgdate"type="date"   class="form-control" placeholder= "Percentage" style="width:150px;"  onblur="compareDates();" value="' + DataTable[i].bgdate + '"/></td>';
                results += '<td ><input id="txt_effective" type="text"  class="form-control" placeholder= "Effective" style="width:130px;"  value="' + DataTable[i].effective + '"/></td>';
                results += '<td ><input id="txt_expireydate" type="date"  class="form-control" placeholder= "ExpireyDate"   style="width:150px;" onblur="compareDates1();" value="' + DataTable[i].expireydate + '"/></td>';
                results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:90px;"  value="' + DataTable[i].remarks + '"/></td>';
                results += '<td ><input id="txt_sno" type="text" style="display:none" class="form-control"  style="width:50px;"  value="' + DataTable[i].sno + '"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td ><input id="hdnproductsno" style="display:none" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData1").html(results);
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
        function save_bg_click() {
            var groupcode1 = document.getElementById('txt_groupcode1').value;
            var groupid1 = document.getElementById('txt_groupid1').value;
            if (groupcode1 == "" || groupid1 == "" || groupname1 == "") {
                alert("Enter  group code");
                return false;
            }
            var groupname1 = document.getElementById('txt_groupname1').value;
            var partycode1 = document.getElementById('txt_partycode1').value;
            var partyid1 = document.getElementById('txt_partyid1').value;
            if (partycode1 == "") {
                alert("Enter  party code");
                return false;
            }
            var partyname1 = document.getElementById('txt_partyname1').value;
            var date = document.getElementById('txt_date').value;
            if (date == "") {
                alert("Enter  date");
                return false;
            }
            var btnval = document.getElementById('btn_save_bg').value;
            var bgfdr_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtsno').text();
                var type = $(this).find('#txt_type').val();
                var number = $(this).find('#txt_number').val();
                var value = $(this).find('#txt_value').val();
                var bgdate = $(this).find('#txt_bgdate').val();
                var effective = $(this).find('#txt_effective').val();
                var expireydate = $(this).find('#txt_expireydate').val();
                var remarks = $(this).find('#txt_remarks').val();
                var sno = $(this).find('#txt_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (number == "" || number == "0") {
                }
                else {
                    bgfdr_array.push({ 'type': type, 'number': number, 'value': value, 'bgdate': bgdate, 'effective': effective, 'expireydate': expireydate, 'remarks': remarks, 'sno': sno
                    });
                }
            });

            var data = { 'op': 'save_bg_click', 'groupcode1': groupcode1, 'groupid1':groupid1,'partyid1':partyid1,'groupname1': groupname1, 'partycode1': partycode1, 'partyname1': partyname1, 'bgfdr_array': bgfdr_array, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    clearbgdetails();
                    get_party_typebg_details();
                }

            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function compareDates(date, bgdate) {
            var date = document.getElementById('txt_date').value;
            var bgdate = document.getElementById('txt_bgdate').value;
            var dt1 = parseInt(date.substring(8, 10), 10);
            var mon1 = parseInt(date.substring(5, 7), 10);
            var yr1 = parseInt(date.substring(0, 4), 10);
            var dt2 = parseInt(bgdate.substring(8, 10), 10);
            var mon2 = parseInt(bgdate.substring(5, 7), 10);
            var yr2 = parseInt(bgdate.substring(0, 4), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);

            if (date2 < date1) {
                alert("Enter Correct date");
                return false;
            }
            else {
            }
        }
        function compareDates1(date, expireydate) {
            var date = document.getElementById('txt_date').value;
            var expireydate = document.getElementById('txt_expireydate').value;
            var dt1 = parseInt(date.substring(8, 10), 10);
            var mon1 = parseInt(date.substring(5, 7), 10);
            var yr1 = parseInt(date.substring(0, 4), 10);
            var dt2 = parseInt(expireydate.substring(8, 10), 10);
            var mon2 = parseInt(expireydate.substring(5, 7), 10);
            var yr2 = parseInt(expireydate.substring(0, 4), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);

            if (date2 < date1) {
                alert("Enter Correct date");
                return false;
            }
            else {
            }

        }
        function clearbgdetails() {
            document.getElementById('txt_groupcode1').value = "";
            document.getElementById('txt_groupname1').value = "";
            document.getElementById('txt_partycode1').value = "";
            document.getElementById('txt_partyname1').value = "";
            document.getElementById('txt_groupid1').value = "";
            document.getElementById('txt_partyid1').value = "";
            document.getElementById('txt_type').selectedIndex = 0;
            document.getElementById('txt_number').value = "";
            document.getElementById('txt_value').value = "";
            document.getElementById('txt_bgdate').value = "";
            document.getElementById('txt_effective').value = "";
            document.getElementById('txt_expireydate').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('btn_save_bg').value = "Save";
            get_group_ledger();
            get_party_type1_details();
            GetFixedrows1();

        }
        function GetFixedrows2() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails2">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Bank Code</th><th scope="col">Bank Name</th><th scope="col">Brach Code</th><th scope="col">Branch Name</th><th scope="col">A/c Number</th><th scope="col">From Date</th><th scope="col">To Date</th></tr></thead></tbody>';
            for (var i = 1; i < 10; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txt_bankcode" type="text" class="clscode" placeholder= "Bank Code"  style="width:100px;"/></td>';
                results += '<td ><input id="txt_bankname" type="text" class="clsDescription" placeholder= "BankName" style="width:150px;"/></td>';
                results += '<td ><input id="txt_branchcode" type="text"  placeholder= "Brach Code" class="clscode2"  style="width:100px;"/></td>';
                results += '<td ><input id="txt_branchname" type="text"  class="clsDescription" placeholder= "BranchName"   style="width:150px;"/></td>';
                results += '<td ><input id="txt_accno" type="text"  class="form-control" placeholder= "A/c No."   style="width:150px;"/></td>';
                results += '<td ><input id="txt_fromdate" type="date"  class="form-control" placeholder= "From Date" onblur="compareDates2();" style="width:150px;"/></td>';
                results += '<td ><input id="txt_todate" type="date"  class="form-control" placeholder= "To Date" onblur="compareDates3();" style="width:150px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="txt_bankid" class="clsDescription" type="hidden" /></td>';
                results += '<td style="display:none"><input id="txt_branchid" class="clsDescription" type="hidden" /></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData2").html(results);
        }
        var DataTable2;
        function insertrow2() {
            DataTable2 = [];
            get_bank_details();
            get_bankifsc_details();
            var txtsno = 0;
            bankcode = 0;
            bankname = 0;
            branchcode = 0;
            branchname = 0;
            accno = 0;
            fromdate = 0;
            todate = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails2 tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                bankcode = $(this).find('#txt_bankcode').val();
                bankname = $(this).find('#txt_bankname').val();
                branchcode = $(this).find('#txt_branchcode').val();
                branchname = $(this).find('#txt_branchname').val();
                accno = $(this).find('#txt_accno').val();
                fromdate = $(this).find('#txt_fromdate').val();
                todate = $(this).find('#txt_todate').val();
                sno = $(this).find('#txt_sub_sno').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                bankid = $(this).find('#txt_bankid').val();
                branchid = $(this).find('#txt_branchid').val();
                DataTable2.push({ Sno: txtsno, bankcode: bankcode,bankid:bankid,branchid:branchid, bankname: bankname, branchcode: branchcode, branchname: branchname, accno: accno, fromdate: fromdate, todate: todate, hdnproductsno: hdnproductsno });
                rowsno++;
            });
            bankcode = 0;
            bankname = 0;
            branchcode = 0;
            branchname = 0;
            accno = 0;
            fromdate = 0;
            todate = 0;
            hdnproductsno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable2.push({ Sno: Sno, bankcode: bankcode, bankid: bankid, branchid: branchid, bankname: bankname, branchcode: branchcode, branchname: branchname, accno: accno, fromdate: fromdate, todate: todate, hdnproductsno: hdnproductsno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails2">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Bank Code</th><th scope="col">Bank Name</th><th scope="col">Brach Code</th><th scope="col">Branch Name</th><th scope="col">A/c Number</th><th scope="col">From Date</th><th scope="col">To Date</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable2.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable2[i].Sno + '</td>';
                results += '<td ><input id="txt_bankcode" class="clscode" style="width:100px;" value="' + DataTable2[i].bankcode + '"/></td>';
                results += '<td ><input id="txt_bankname" type="text" class="clsDescription" placeholder= "BankName" style="width:150px;" value="' + DataTable2[i].bankname + '"/></td>';
                results += '<td ><input id="txt_branchcode"   class="clscode2" style="width:100px;" value="' + DataTable2[i].branchcode + '"/></td>';
                results += '<td ><input id="txt_branchname"type="text"   class="clsDescription" placeholder= "BranchName" style="width:150px;"  value="' + DataTable2[i].branchname + '"/></td>';
                results += '<td ><input id="txt_accno" type="text"  class="form-control" placeholder= "A/c No." style="width:130px;" value="' + DataTable2[i].accno + '"/></td>';
                results += '<td ><input id="txt_fromdate" type="date"  class="form-control" placeholder= "From Date"   style="width:150px;" onblur="compareDates2();"  value="' + DataTable2[i].fromdate + '"/></td>';
                results += '<td ><input id="txt_todate" type="date"  class="form-control" placeholder= "To Date" style="width:150px;" onblur="compareDates3();"  value="' + DataTable2[i].todate + '"/></td>';
                results += '<td ><input id="txt_sno" type="text" style="display:none" class="form-control"  style="width:50px;"  value="' + DataTable2[i].sno + '"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td ><input id="txt_bankid" style="display:none"  class="clsDescription" value="' + DataTable2[i].bankid + '"/></td>';
                results += '<td ><input id="txt_branchid" style="display:none"  class="clsDescription"  value="' + DataTable2[i].branchid + '"/></td>';
                results += '<td ><input id="hdnproductsno" style="display:none" type="hidden" value="' + DataTable2[i].hdnproductsno + '"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData2").html(results);
        }
        function save_Bank_Details() {
            var date1 = document.getElementById('txt_date1').value;
            var groupcode2 = document.getElementById('txt_groupcode2').value;
            var groupname2 = document.getElementById('txt_groupname2').value;
            var groupid2 = document.getElementById('txt_groupid2').value;
            if (groupcode2 == "" || groupid2 == "" || groupname2 == "") {
                alert("Enter  group code");
                return false;
            }
            var partyid2 = document.getElementById('txt_partyid2').value;
            var partycode2 = document.getElementById('txt_partycode2').value;
            if (partycode2 == "" || partyid2 == "" || partyname2 == "") {
                alert("Enter  group code");
                return false;
            }
            if (date1 == "") {
                alert("Enter  group code");
                return false;
            }
            var partyname2 = document.getElementById('txt_partyname2').value;
            var btnval = document.getElementById('btn_bank_save').value;
            var bank_array = [];
            $('#tabledetails2> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtsno').text();
                var bankcode = $(this).find('#txt_bankcode').val();
                var bankname = $(this).find('#txt_bankname').val();
                var branchcode = $(this).find('#txt_branchcode').val();
                var branchname = $(this).find('#txt_branchname').val();
                var accno = $(this).find('#txt_accno').val();
                var fromdate = $(this).find('#txt_fromdate').val();
                var todate = $(this).find('#txt_todate').val();
                var sno = $(this).find('#txt_sno').val();
                var bankid = $(this).find('#txt_bankid').val();
                var branchid = $(this).find('#txt_branchid').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (accno == "" || accno == "0") {
                }
                else {
                    bank_array.push({ 'bankcode': bankcode,'bankid':bankid,'branchid':branchid, 'bankname': bankname, 'branchcode': branchcode, 'branchname': branchname, 'accno': accno, 'fromdate': fromdate, 'todate': todate, 'sno': sno
                    });
                }
            });

            var data = { 'op': 'save_Bank_Details', 'groupcode2': groupcode2,'groupid2':groupid2,'partyid2':partyid2, 'groupname2': groupname2, 'partycode2': partycode2, 'partyname2': partyname2, 'bank_array': bank_array, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    clearbankdetails();
                    get_party_typebank_details();
                }

            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function compareDates2(date, fromdate) {
            var date = document.getElementById('txt_date').value;
            var fromdate = document.getElementById('txt_fromdate').value;
            var dt1 = parseInt(date.substring(8, 10), 10);
            var mon1 = parseInt(date.substring(5, 7), 10);
            var yr1 = parseInt(date.substring(0, 4), 10);
            var dt2 = parseInt(fromdate.substring(8, 10), 10);
            var mon2 = parseInt(fromdate.substring(5, 7), 10);
            var yr2 = parseInt(fromdate.substring(0, 4), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);

            if (date2 < date1) {
                alert("Enter Correct date");
                return false;
            }
           else {
            } 
        }
        function compareDates3(date, todate) {
            var date = document.getElementById('txt_date').value;
            var todate = document.getElementById('txt_todate').value;
            var dt1 = parseInt(date.substring(8, 10), 10);
            var mon1 = parseInt(date.substring(5, 7), 10);
            var yr1 = parseInt(date.substring(0, 4), 10);
            var dt2 = parseInt(todate.substring(8, 10), 10);
            var mon2 = parseInt(todate.substring(5, 7), 10);
            var yr2 = parseInt(todate.substring(0, 4), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);

            if (date2 < date1) {
                alert("Enter Correct date");
                return false;
            }
            else {
            }
        }
        function clearbankdetails() {
            document.getElementById('txt_groupcode2').value = "";
            document.getElementById('txt_groupname2').value = "";
            document.getElementById('txt_partycode2').value = "";
            document.getElementById('txt_partyname2').value = "";
            document.getElementById('txt_bankcode').value = "";
            document.getElementById('txt_bankname').value = "";
            document.getElementById('txt_branchcode').value = "";
            document.getElementById('txt_branchname').value = "";
            document.getElementById('txt_accno').value = "";
            document.getElementById('txt_fromdate').value = "";
            document.getElementById('txt_todate').value = "";
            document.getElementById('btn_bank_save').value = "Save";
            get_group_ledger();
            get_party_type1_details();
            GetFixedrows2();
            get_bank_details();
            get_bankifsc_details();
        }
        var partytds = [];
        function get_party_typebg_details() {
            var data = { 'op': 'get_party_typebg_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpartybg_details(msg);

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
        function fillpartybg_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">GroupCode</th><th scope="col">PartyType</th><th scope="col">BG/FDRNumber</th><th scope="col">DateOfEntry</th></tr></thead></tbody>';
            var tds = msg[0].partywisebg;
            tdssub = msg[0].partywisebgsub;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < tds.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getpartytdsentry(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="partytype"  class="7">' + tds[i].groupid1 + '</td>';
                results += '<td data-title="partytype"  class="8">' + tds[i].partyid1 + '</td>';
                //results += '<td data-title="glcode"  class="3">' + tds[i].glcode + '</td>';
                results += '<td data-title="certificateno"  class="4">' + tds[i].number + '</td>';
                results += '<td data-title="doe"  class="5">' + tds[i].doe + '</td>';
                results += '<td data-title="groupcode" style="display:none;" class="1" >' + tds[i].groupcode1 + '</td>';
                results += '<td data-title="partytype" style="display:none;" class="2">' + tds[i].partycode1 + '</td>';
                results += '<td data-title="doe" style="display:none;"  class="10">' + tds[i].sno + '</td>';
                results += '<td data-title="groupname"  class="12" style="display:none;" >' + tds[i].groupname1 + '</td>';
                results += '<td data-title="partyname"  class="13" style="display:none;">' + tds[i].partyname1 + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable1").html(results);
        }
        function getpartytdsentry(thisid) {
            $("#divbank").css("display", "block");
            $("#divifsc").css("display", "none");
            $('#div_SectionData1').show();
            $('#newrow1').show();
            var groupcode1 = $(thisid).parent().parent().children('.1').html();
            var groupshortdesc = $(thisid).parent().parent().children('.12').html();
            var partycode1 = $(thisid).parent().parent().children('.2').html();
            var partyshortdesc = $(thisid).parent().parent().children('.13').html();
            var sno = $(thisid).parent().parent().children('.10').html();
            var groupname1 = $(thisid).parent().parent().children('.12').html();
            var partyid1 = $(thisid).parent().parent().children('.8').html();

            document.getElementById('txt_groupcode1').value = groupname1;
            document.getElementById('txt_groupname1').value = groupshortdesc;
            document.getElementById('txt_groupid1').value = groupcode1;
            document.getElementById('txt_partyid1').value = partycode1;
            document.getElementById('txt_partyname1').value = partyid1;
            document.getElementById('txt_partycode1').value = partyshortdesc;
            document.getElementById('btn_save_bg').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Type</th><th scope="col">BG/FDRNumber</th><th scope="col">Value</th><th scope="col">BGDate</th><th scope="col">Effective</th><th scope="col">ExpireyDate</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < tdssub.length; i++) {
                if (sno == tdssub[i].sno) {
                    results += '<tr ><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td data-title="From"><select id="txt_type" class="clscode" name="type"  value="' + tdssub[i].type + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"><option   value="BG">BG</option><option  value="FDR">FDR</option></select></td>';
                    results += '<td data-title="From"><input id="txt_number" class="clsDescription" name="number"  value="' + tdssub[i].number + '"style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  id="txt_value" name="value" class="form-control" value="' + tdssub[i].value + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  id="txt_bgdate" type="date" class="form-control" name="bgdate" value="' + tdssub[i].bgdate + '"  style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_effective"  class="form-control" name="effective"   value="' + tdssub[i].effective + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_expireydate" type="date" class="form-control"  name="expireydate" value="' + tdssub[i].expireydate + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_remarks" class="form-control"  name="remarks"  value="' + tdssub[i].remarks + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="txt_sno" name="txt_sub_sno" value="' + tdssub[i].sno + '"style="width:10%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData1").html(results);
        }
        var partytds1 = [];
        function get_party_typebank_details() {
            var data = { 'op': 'get_party_typebank_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpartybg1_details(msg);

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
        var tdssub1 = [];
        function fillpartybg1_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">GroupName</th><th scope="col">GroupDescription</th><th scope="col">PartyName</th><th scope="col">PartyCode</th><th scope="col">AccountNumber</th></tr></thead></tbody>';
            var tds1 = msg[0].partywisebank;
            tdssub1 = msg[0].partywisebanksub;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < tds1.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getpartytdsentry1(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="groupcode"  class="1" >' + tds1[i].groupcode2 + '</td>';
                results += '<td data-title="partytype"  class="2">' + tds1[i].groupname2 + '</td>';
                results += '<td data-title="partytype"  class="3">' + tds1[i].partycode2 + '</td>';
                results += '<td data-title="partytype"  class="4">' + tds1[i].partyname2 + '</td>';
                results += '<td data-title="certificateno"  class="5">' + tds1[i].accountno + '</td>';
                results += '<td data-title="doe" style="display:none;"  class="6">' + tds1[i].sno + '</td>';
                results += '<td data-title="groupname"  class="7" style="display:none;" >' + tds1[i].groupid2 + '</td>';
                results += '<td data-title="groupname"  class="8" style="display:none;" >' + tds1[i].partyid2 + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable2").html(results);
        }
        function getpartytdsentry1(thisid) {
            $("#divbank").css("display", "none");
            $("#divifsc").css("display", "block");
            $('#div_SectionData2').show();
            $('#newrow2').show();

            var groupcode2 = $(thisid).parent().parent().children('.1').html();
            var groupname2 = $(thisid).parent().parent().children('.2').html();
            var partycode2 = $(thisid).parent().parent().children('.3').html();
            var partyname2 = $(thisid).parent().parent().children('.4').html();
            var accountno = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.6').html();
            var groupid2 = $(thisid).parent().parent().children('.7').html();
            var partyid2 = $(thisid).parent().parent().children('.8').html();

            document.getElementById('txt_groupcode2').value = groupcode2;
            document.getElementById('txt_groupname2').value = groupname2;
            document.getElementById('txt_partyname2').value = partyname2;
            document.getElementById('txt_partycode2').value = partycode2;
            document.getElementById('txt_groupid2').value = groupid2;
            document.getElementById('txt_partyid2').value = partyid2;
            document.getElementById('btn_bank_save').value = "Modify";
            var table = document.getElementById("tabledetails2");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails2">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Bank Code</th><th scope="col">Bank Name</th><th scope="col">Brach Code</th><th scope="col">Branch Name</th><th scope="col">A/c Number</th><th scope="col">From Date</th><th scope="col">To Date</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < tdssub1.length; i++) {
                if (sno == tdssub1[i].sno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td data-title="From"><input id="txt_bankcode" class="clscode" name="type"  value="' + tdssub1[i].bankcode + '" style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_bankname" class="clsDescription" name="number"  value="' + tdssub1[i].bankname + '"style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  id="txt_branchcode" name="value" class="clscode2" value="' + tdssub1[i].branchcode + '"  style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  id="txt_branchname" class="clsDescription" name="bgdate" value="' + tdssub1[i].branchname + '"  style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_accno" class="form-control" name="effective"   value="' + tdssub1[i].accno + '"  style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_fromdate" type="date" class="form-control"  name="expireydate" value="' + tdssub1[i].fromdate + '"  style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_todate" type="date" class="form-control"  name="remarks"  value="' + tdssub1[i].todate + '"  style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="txt_bankid" name="txt_sub_sno" value="' + tdssub[i].bankid + '"style="width:10%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="txt_branchid" name="txt_sub_sno" value="' + tdssub[i].branchid + '"style="width:10%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="txt_sno" name="txt_sub_sno" value="' + tdssub[i].sno + '"style="width:100px; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData2").html(results);
            get_bank_details();
            get_bankifsc_details();
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Party wise BG
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Party wise BG</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showbrfdrdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;BG/FDR Details </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showbankdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Bank Details </a></li>
                </ul>
            </div>
             <div id="divbank" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>BG/FDR Details
                    </h3>
                </div>
                 <div class="box-body">
                    <div id='fillform'>
                        <table align="center" style="width: 60%;">
                        <tr>
                            <td>
                            
                                <label>
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupcode1" placeholder="Enter group code" class="form-control" onchange="Getgroupcode1(this);" />
                                <input id="txt_groupid1" class="form-control" style="display: none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupname1" placeholder="group code" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                            <td>
                            
                                <label>
                                    Party Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partycode1" class="form-control" placeholder="Enter Party code" onchange="Getpartycode1(this);" />
                                <input id="txt_partyid1" class="form-control" style="display: none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partyname1" class="form-control" placeholder="Party code" type="text"  readonly/>
                                </td>
                            </tr>

                            <tr style="display: none;">
                            <td>
                            
                                <label>
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" type="date" class="form-control"  />
                                
                            </td>
                            </tr>


                            </table>
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>BG/FDR Details Entry
                                        </h3>
                                    </div>
                                    <div class="box-body">
                                        <div id="div_SectionData1">
                                        </div>
                                    </div>
                                </div>
                            
                            <div>
                                <p id="newrow1">
                                    <input type="button" onclick="insertrow1();" class="btn btn-default" value="Insert row" /></p>
                                <div id="">
                                </div>
                                <table align="center">
                                    <tr>
                                <td colspan="6" align="center" style="height: 40px;">
                                    <input id="btn_save_bg" type="button" class="btn btn-primary" name="submit" value='Save'
                                        onclick="save_bg_click();" />
                                    <input id='btn_close_bg' type="button" class="btn btn-danger" name="Clear" value='Clear'
                                        onclick="clearbgdetails();" />
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
            <div id="divifsc" style="display: none;">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Bank details 
                        </h3>
                    </div>
                     <div id='showlogs2' style="display: none;">
                        <table  align="center">
                        <tr>
                            <td>
                            
                                <label>
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupcode2" class="form-control" placeholder="Enter group code" onchange="Getgroupcode2(this);" />
                                <input id="txt_groupid2" class="form-control" style="display: none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupname2" class="form-control" placeholder="group code" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                            <td>
                            
                                <label>
                                    Party Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partycode2" class="form-control" placeholder="Enter party code" onchange="Getpartycode2(this);" />
                                <input id="txt_partyid2" class="form-control" placeholder="party code" style="display: none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partyname2" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr style="display: none;">
                            <td>
                            
                                <label>
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date1" type="date" class="form-control"  />
                                
                            </td>
                            </tr>
                            </table>
                            </div>
                                <br />
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Bank details Entry
                                        </h3>
                                    </div>
                                    <div class="box-body">
                                        <div id="div_SectionData2">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <p id="newrow2">
                                    <input type="button" onclick="insertrow2();" class="btn btn-default" value="Insert row" /></p>
                                <div id="Div1">
                                </div>
                                <table align="center">
                                    <tr>
                                        <td style="height: 40px;">
                                    <input id="btn_bank_save" type="button" class="btn btn-success" name="submit" value="Save"
                                        onclick="save_Bank_Details();">
                                    <input id="btn_bank_close" type="button" class="btn btn-danger" name="submit" value="Clear"
                                      onclick="clearbankdetails();"  ">
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
    </section>
</asp:Content>
