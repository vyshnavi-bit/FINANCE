<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="ProfitAndLossBalanceSheetAdjustmentsentry.aspx.cs" Inherits="ProfitAndLossBalanceSheetAdjustmentsentry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_profitandlossbalance_sheet();
            forclearall();
            get_Branch_details();
            get_financial_year();
            $('#add_Inward').click(function () {
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
                get_Branch_details();
                get_financial_year();
                GetFixedrows();
                get_bankaccount_details();
                get_group_ledger();
                forclearall();
                get_profitandlossbalance_sheet();
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
            });
            $('#close_id').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
                forclearall();
                get_profitandlossbalance_sheet();
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
        function canceldetails() {
            $("#div_CategoryData").show();
            $("#fillform").hide();
            $('#showlogs').show();
            get_profitandlossbalance_sheet();
            forclearall();
        }
        var branchnamearr = [];
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    branchnamearr = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].branchname;
                        empnameList.push(empname);
                    }
                    $('#txt_branchcode').autocomplete({
                        source: empnameList,
                        change: Getbranchcode,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getbranchcode() {
            var empname = document.getElementById('txt_branchcode').value;
            for (var i = 0; i < branchnamearr.length; i++) {
                if (empname == branchnamearr[i].branchname) {
                    document.getElementById('txt_branchname').value = branchnamearr[i].code;
                    document.getElementById('txt_branchcode_sno').value = branchnamearr[i].branchid;
                }
            }
        }

        function get_financial_year() {
            var data = { 'op': 'get_financial_year' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillledger(msg);
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
            var data = document.getElementById('txt_financeyear');
            var length = data.options.length;
            document.getElementById('txt_financeyear').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Financial Year";
            opt.value = "Select Financial Year";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].year != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].year;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function isNumber(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode != 46 && charCode > 31
            && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        var accountNumber = [];
        function get_bankaccount_details() {
            var data = { 'op': 'get_bankaccount_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails1(msg);
                        accountNumber = msg;
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
        function filldetails1(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var AccountNumber = msg[i].AccountNumber;
                compiledList.push(AccountNumber);
            }

            $('.clscode2').autocomplete({
                source: compiledList,
                change: calTotal4,
                autoFocus: true
            });
        }
        var emptytable = [];
        function calTotal1() {
            var AccountNumber = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(AccountNumber) == -1) {
                for (var i = 0; i < accountNumber.length; i++) {
                    if (AccountNumber == accountNumber[i].AccountNumber) {
                        $(this).closest('tr').find('#txt_accountcode_sno').val(accountNumber[i].sno);
                        $(this).closest('tr').find('#txt_description').val(accountNumber[i].Accounttype);
                        emptytable.push(party_tp);
                    }
                }
            }
            else {
                //alert("already added");
                //var empt = "";
                //$(this).val(empt);
                //$(this).focus();
                //return false;
            }
        }
        var short_desc_sch = [];
        function get_group_ledger() {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails2(msg);
                        short_desc_sch = msg;
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
        function filldetails2(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var schedule = msg[i].schedule;
                compiledList.push(schedule);
            }

            $('.clscode1').autocomplete({
                source: compiledList,
                change: calTotal4,
                autoFocus: true
            });
        }
        var emptytable1 = [];
        function calTotal4() {
            var schedule = $(this).val();
            var checkflag = true;
            if (emptytable1.indexOf(schedule) == -1) {
                for (var i = 0; i < short_desc_sch.length; i++) {
                    if (schedule == short_desc_sch[i].schedule) {
                        $(this).closest('tr').find('#txt_schedule_sno').val(short_desc_sch[i].sno);
                        emptytable1.push(party_tp);
                    }
                }
            }
            else {
                //alert("already added");
                //var empt = "";
                //$(this).val(empt);
                //$(this).focus();
                //return false;
            }
        }

        $(document).click(function () {
            $('#tabledetails').on('change', '.clscode2', calTotal1)
            $('#tabledetails').on('change', '.clscode1', calTotal4)
        });
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Schedule</th><th scope="col">Account Code</th><th scope="col">Description</th><th scope="col">Add Less</th><th scope="col">CurrentYearAmount</th><th scope="col">PreviousYearAmount</th></tr></thead></tbody>';
            for (var i = 1; i < 10; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txt_schedule" type="text" class="clscode1" placeholder= "Schedule"  style="width:150px;"  /></td>';
                results += '<td style="display:none"><input id="txt_schedule_sno" type="text" class="clscodesno1"  /></td>';
                results += '<td ><input id="txt_accountcode" type="text" class="clscode2" placeholder= "Account code" style="width:150px;"/></td>';
                results += '<td style="display:none"><input id="txt_accountcode_sno" type="text" class="clscodesno2"  /></td>';
                results += '<td ><input id="txt_description" type="text"  placeholder= "Description" class="clsDescription"  style="width:150px;"/></td>';
                results += '<td data-title="Phosps" ><select id="txt_addless" type="text" class="form-control" placeholder= "Add less"  style="width:150px;"><option   value="0">select</option><option   value="1">Add</option><option  value="-1">Less</option></select></td>';
                results += '<td ><input id="txt_currentyearamount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Current Year Amount" style="width:150px;"/></td>';
                results += '<td ><input id="txt_previousyearamount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Previous Year Amount" style="width:150px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function insertrow() {
            DataTable = [];
            get_bankaccount_details();
            get_group_ledger();
            var txtsno = 0;
            accountcode = 0;
            schedule = 0;
            accountcode = 0;
            description = 0;
            addless = 0;
            currentyearamount = 0;
            previousyearamount = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                schedule = $(this).find('#txt_schedule_sno').val();
                accountcode = $(this).find('#txt_accountcode_sno').val();
                description = $(this).find('#txt_description').val();
                addless = $(this).find('#txt_addless').val();
                currentyearamount = $(this).find('#txt_currentyearamount').val();
                previousyearamount = $(this).find('#txt_previousyearamount').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                DataTable.push({ Sno: txtsno, schedule: schedule, accountcode: accountcode, description: description, addless: addless, currentyearamount: currentyearamount, previousyearamount: previousyearamount, hdnproductsno: hdnproductsno });
                rowsno++;
            });
            accountcode = 0;
            schedule = 0;
            accountcode = 0;
            description = 0;
            addless = 0;
            currentyearamount = 0;
            previousyearamount = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, schedule: schedule, accountcode: accountcode, description: description, addless: addless, currentyearamount: currentyearamount, previousyearamount: previousyearamount, hdnproductsno: hdnproductsno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Schedule</th><th scope="col">Account Code</th><th scope="col">Description</th><th scope="col">Add Less</th><th scope="col">CurrentYearAmount</th><th scope="col">PreviousYearAmount</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txt_schedule" type="text" class="clscode1" placeholder= "Schedule"  style="width:150px;"  value="' + DataTable[i].schedule + '" /></td>';
                results += '<td style="display:none"><input id="txt_schedule_sno" type="text" class="clscodesno1"  /></td>';
                results += '<td ><input id="txt_accountcode" type="text" class="clscode2" placeholder= "Account code" style="width:150px;"/></td>';
                results += '<td style="display:none"><input id="txt_accountcode_sno" type="text" class="clscodesno2"  /></td>';
                results += '<td ><input id="txt_description" type="text"  placeholder= "Description" class="clsDescription"  style="width:150px;" value="' + DataTable[i].description + '" /></td>';
                results += '<td data-title="Phosps" ><select id="txt_addless" type="text" class="form-control" placeholder= "Add less"  style="width:150px;"><option   value="0">select</option><option   value="1">Add</option><option  value="-1">Less</option></select></td>';
                results += '<td ><input id="txt_currentyearamount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Current Year Amount" style="width:150px;" value="' + DataTable[i].currentyearamount + '" /></td>';
                results += '<td ><input id="txt_previousyearamount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Previous Year Amount" style="width:150px;" value="' + DataTable[i].previousyearamount + '" /></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
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
        function save_profitandlossbalance_sheet() {
            var branchcode = document.getElementById('txt_branchcode_sno').value;
            if (branchcode == "") {
                alert("Enter  branch code");
                return false;
            }
            var financeyear = document.getElementById('txt_financeyear').value;
            if (financeyear == "") {
                alert("Enter  finance year");
                return false;
            }
            var date = document.getElementById('txt_date').value;
            if (date == "") {
                alert("Enter  date");
                return false;
            }
            var btnval = document.getElementById('btn_save').value;
            var profitandlossbalance_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtsno').text();
                var schedule = $(this).find('#txt_schedule_sno').val();
                var accountcode = $(this).find('#txt_accountcode_sno').val();
                var description = $(this).find('#txt_description').val();
                var addless = $(this).find('#txt_addless').val();
                var currentyearamount = $(this).find('#txt_currentyearamount').val();
                var previousyearamount = $(this).find('#txt_previousyearamount').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (currentyearamount == "" || currentyearamount == "0") {
                }
                else {
                    profitandlossbalance_array.push({ 'schedule': schedule, 'accountcode': accountcode, 'description': description, 'addless': addless, 'currentyearamount': currentyearamount, 'previousyearamount': previousyearamount, 'hdnproductsno': hdnproductsno
                    });
                }
            });
            var data = { 'op': 'save_profitandlossbalance_sheet', 'branchcode': branchcode, 'financeyear': financeyear, 'date': date, 'profitandlossbalance_array': profitandlossbalance_array, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_profitandlossbalance_sheet();
                    $('#vehmaster_fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_inwardtable').show();
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function forclearall() {
            document.getElementById('txt_branchcode').value = "";
            document.getElementById('txt_branchname').value = "";
            document.getElementById('txt_financeyear').selectedIndex = 0;
            document.getElementById('btn_save').value = "Save";
            GetFixedrows();
            get_bankaccount_details();
            get_group_ledger();
        }
        var partytds = [];
        function get_profitandlossbalance_sheet() {
            var data = { 'op': 'get_profitandlossbalance_sheet' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillprofitloss_details(msg);
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
        function fillprofitloss_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">BranchCode</th><th scope="col">BranchName</th><th scope="col">FinancialYear</th><th scope="col">Date</th><th scope="col">CurrentYearAmount</th><th scope="col">PreviousYearAmount</th></tr></thead></tbody>';
            var tds = msg[0].profitandlossbalance;
            tdssub = msg[0].profitandlossbalancesub;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < tds.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getprofitlossdetails(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="branchid" style="display:none;"  class="1" >' + tds[i].branchid + '</td>';
                results += '<td data-title="branchcode"  class="2">' + tds[i].branchcode + '</td>';
                results += '<td data-title="branchname"  class="3">' + tds[i].branchname + '</td>';
                results += '<td data-title="financeyear" style="display:none;" class="4">' + tds[i].financeyear + '</td>';
                results += '<td data-title="year"  class="5">' + tds[i].year + '</td>';
                results += '<td data-title="date"  class="6">' + tds[i].date + '</td>';
                results += '<td data-title="currentyearamount"  class="7">' + tds[i].currentyearamount + '</td>';
                results += '<td data-title="previousyearamount"  class="8">' + tds[i].previousyearamount + '</td>';
                results += '<td data-title="sno" style="display:none;"  class="9">' + tds[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable").html(results);
        }
        function getprofitlossdetails(thisid) {
            $('#vehmaster_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_Grid').hide();
            $('#div_SectionData').show();
            $('#div_inwardtable').hide();
            $('#newrow').show();
            var branchcode = $(thisid).parent().parent().children('.1').html();
            var branchid = $(thisid).parent().parent().children('.2').html();
            var branchname = $(thisid).parent().parent().children('.3').html();
            var financeyear = $(thisid).parent().parent().children('.4').html();
            var year = $(thisid).parent().parent().children('.5').html();
            var date = $(thisid).parent().parent().children('.6').html();
            var currentyearamount = $(thisid).parent().parent().children('.7').html();
            var previousyearamount = $(thisid).parent().parent().children('.8').html();
            var sno = $(thisid).parent().parent().children('.9').html();

            document.getElementById('txt_branchcode').value = branchname;
            document.getElementById('txt_branchcode_sno').value = branchcode;
            document.getElementById('txt_branchname').value = branchid;
            document.getElementById('txt_financeyear').value = financeyear;
            document.getElementById('txt_date').value = date;
            document.getElementById('btn_save').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Schedule</th><th scope="col">Account Code</th><th scope="col">Description</th><th scope="col">Add Less</th><th scope="col">CurrentYearAmount</th><th scope="col">PreviousYearAmount</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < tdssub.length; i++) {
                if (sno == tdssub[i].sno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td ><input id="txt_schedule" type="text" class="clscode1" placeholder= "Schedule"  style="width:150px;"  value="' + tdssub[i].shaduleid + '" /></td>';
                    results += '<td style="display:none"><input id="txt_schedule_sno" type="text" class="clscodesno1" value="' + tdssub[i].schedule + '"  /></td>';
                    results += '<td ><input id="txt_accountcode" type="text" class="clscode2" placeholder= "Account code" style="width:150px;" value="' + tdssub[i].accountid + '" /></td>';
                    results += '<td style="display:none"><input id="txt_accountcode_sno" type="text" class="clscodesno2" value="' + tdssub[i].accountcode + '"  /></td>';
                    results += '<td ><input id="txt_description" type="text"  placeholder= "Description" class="clsDescription"  style="width:150px;" value="' + tdssub[i].description + '" /></td>';
                    results += '<td data-title="Phosps" ><select id="txt_addless" type="text" class="form-control" placeholder= "Add less"  style="width:150px;"><option   value="0">select</option><option   value="1">Add</option><option  value="-1">Less</option></select></td>';
                    results += '<td ><input id="txt_currentyearamount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Current Year Amount" style="width:150px;" value="' + tdssub[i].currentyearamount + '" /></td>';
                    results += '<td ><input id="txt_previousyearamount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Previous Year Amount" style="width:150px;" value="' + tdssub[i].previousyearamount + '" /></td>';
                    results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + tdssub[i].sno + '"/></td>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            get_bankaccount_details();
            get_group_ledger();
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Profit & Loss Balance Sheet Adjustments Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transactios</a></li>
            <li><a href="#">Profit & Loss Balance Sheet Adjustments Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Profit & Loss Balance Sheet Adjustments
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <table>
                        <tr>
                           
                            <td>
                                <input id="add_Inward" type="button" name="submit" value='Profit & Loss/Balance Entry ' class="btn btn-primary" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div_inwardtable">
                </div>
                <div id='vehmaster_fillform' style="display: none;">
                    <asp:UpdatePanel ID="Up1" runat="server">
                        <ContentTemplate>
                            <div class="row-fluid">
                                <div style="padding-left: 150px;">
                                    <table id="tbl_leavemanagement" align="center">
                                    <tr>
                            <td>
                                <label>
                                    Branch Code</label>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="txt_branchcode" class="form-control" onchange="Getbranchcode(this);" >
                                </select>--%>
                                <input id="txt_branchcode" type="text" class="form-control" placeholder="Enter Branch Code" onchange="Getbranchcode(this);" />
                                <input id="txt_branchcode_sno" type="text" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_branchname" class="form-control" placeholder="Branch Code" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Financial year</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_financeyear" class="form-control" >
                                </select>
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" class="form-control" type="date" />
                            </td>
                            </tr>
                            </table>
                            </div>
                                <br />
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Profit & Loss Balance Sheet Adjustments Entry
                                        </h3>
                                    </div>
                                    <div class="box-body">
                                        <div id="div_SectionData">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <p id="newrow">
                                    <input type="button" onclick="insertrow();" class="btn btn-default" value="Insert row" /></p>
                                <div id="">
                                </div>
                                <table>
                                <table align="center">
                                    <tr>
                                        <td>
                                            <input type="button" class="btn btn-success" id="btn_save" value="Save" onclick="save_profitandlossbalance_sheet();" />
                                            <input type="button" class="btn btn-danger" id="close_id" value="Clear" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
         </div>
    </section>
</asp:Content>

