<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="DepreciationStatement.aspx.cs" Inherits="DepreciationStatement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_Branch_details();
        get_financial_year();
        get_accountmaster_click();
        get_primary_group();
        get_depreciation_statement();
        GetFixedrows();
        emptytable = [];
        $('#add_Inward').click(function () {
            $('#vehmaster_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_inwardtable').hide();
            get_Branch_details();
            get_financial_year();
            get_accountmaster_click();
            get_primary_group();
            GetFixedrows();
            emptytable = [];
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
        forclearall();
    }
    var branchname1 = [];
    function get_Branch_details() {
        var data = { 'op': 'get_Branch_details' };
        var s = function (msg) {
            if (msg) {
                branchname1 = msg;
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
        for (var i = 0; i < branchname1.length; i++) {
            if (empname == branchname1[i].branchname) {
                document.getElementById('txt_branchid').value = branchname1[i].branchid;
                document.getElementById('txt_branchname').value = branchname1[i].code;
            }
        }
    }
    function get_financial_year() {
        var data = { 'op': 'get_financial_year' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fill_fin_yr_det(msg);
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
    function fill_fin_yr_det(msg)
    {
        for (i = 0; i < msg.length; i++) {
            if (msg[i].currentyear == "true") {
                document.getElementById('txt_financeyear').value = msg[i].year;
            }
        }
    }
    var filldescrption = [];
    function get_accountmaster_click() {
        var data = { 'op': 'get_accountmaster_click' };
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
            var productname = msg[i].accshortdescription;
            compiledList.push(productname);
        }

        $('.clscode1').autocomplete({
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
                if (productname == filldescrption[i].accshortdescription) {
                    $(this).closest('tr').find('#txt_accountid').val(filldescrption[i].sno);
                    $(this).closest('tr').find('#txt_accdescription').val(filldescrption[i].accountcode);
                    emptytable.push(productname);
                }
            }
        }
    }
    var filldescrption1 = [];
    function get_primary_group() {
        var data = { 'op': 'get_primary_group' };
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
            var productname = msg[i].Shortdescription;
            compiledList1.push(productname);
        }

        $('.clscode2').autocomplete({
            source: compiledList1,
            change: getbranchname1,
            autoFocus: true
        });
    }
    var emptytable1 = [];
    function getbranchname1() {
        var productname = $(this).val();
        var checkflag = true;
        if (emptytable1.indexOf(productname) == -1) {
            for (var i = 0; i < filldescrption1.length; i++) {
                if (productname == filldescrption1[i].Shortdescription) {
                    $(this).closest('tr').find('#txt_groupid').val(filldescrption1[i].sno);
                    emptytable1.push(productname);
                }
            }
        }
    }
    function GetFixedrows() {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">AccountCode</th><th scope="col">AccDescription</th><th scope="col">GroupCode</th><th scope="col">Dep.Rate%</th><th scope="col">OpeningWDV</th><th scope="col">Additions</th><th scope="col">PurchaseDate</th><th scope="col">Sales</th><th scope="col">SaleDate</th><th scope="col">NumberOfDays</th><th scope="col">Dep.Amount</th><th scope="col">ClosingWDV</th><th scope="col">SoldWDV</th><th scope="col">Profit/Loss</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 1; i < 5; i++) {
            results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
            results += '<td ><input id="txt_acccode" type="text" class="clscode1" placeholder= "Account code"  style="width:100px;"  /></td>';
            results += '<td ><input id="txt_accdescription" type="text" class="clsDescription" placeholder= "Description" style="width:100px;"/></td>';
            results += '<td ><input id="txt_groupcode" type="text"  placeholder= "groupcode" class="clscode2"  style="width:100px;"/></td>';
            results += '<td ><input id="txt_deprate" type="text"  onkeypress="return isNumber(event)" class="" placeholder= "Dep. Rate%" style="width:100px;"/></td>';
            results += '<td ><input id="txt_opewdv" type="text" onkeypress="return isNumber(event)" class="clsopewdv" placeholder= "Opening WDV" style="width:100px;"/></td>';
            results += '<td ><input id="txt_additions" type="text" onkeypress="return isNumber(event)" class="clsadditions" placeholder= "Additions"   style="width:100px;"/></td>';
            results += '<td ><input id="txt_purdate" type="date"  class="" placeholder= "Purchase Date" style="width:150px;"/></td>';
            results += '<td ><input id="txt_sales" type="text" onkeypress="return isNumber(event)" class="clssales" placeholder= "Sales" style="width:100px;"/></td>';
            results += '<td ><input id="txt_saledate" type="date"  class="" placeholder= "Sale Date"   style="width:150px;"/></td>';
            results += '<td ><input id="txt_noofdays" type="text" onkeypress="return isNumber(event)"  class="" placeholder= "Number Of Days" style="width:100px;"/></td>';
            results += '<td ><input id="txt_depamount" type="text" onkeypress="return isNumber(event)" class="clsdepamount" placeholder= "Dep. Amount" onkeypress="return isFloat(event)"  style="width:100px;"/></td>';
            results += '<td ><input id="txt_closewdv" type="text" onkeypress="return isNumber(event)"  class="clsclosewdv" placeholder= "Closing WDV"   style="width:100px;"/></td>';
            results += '<td ><input id="txt_soldwdv" type="text" onkeypress="return isNumber(event)" class="clssoldwdv" placeholder= "Sold WDV" style="width:100px;"/></td>';
            results += '<td ><input id="txt_profitloss" type="text"   class="clsprofitloss" placeholder= "Profit /Loss" onkeypress="return isFloat(event)" style="width:100px;"/></td>';
            //results += '<td style="display:none"><input id="txt_sno" type="text" class="form-control"  style="width:50px;"/></td>';
            results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
            results += '<td style="display:none"><input id="txt_accountid" class="clsDescription" type="hidden" /></td>';
            results += '<td style="display:none"><input id="txt_groupid" class="clsDescription" type="hidden" /></td>';
            results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
        }
        results += '</table></div>';
        $("#div_SectionData").html(results);
    }
    var DataTable;
        function insertrow() {
            DataTable = [];
            var txtsno = 0;
            get_primary_group();
            get_depreciation_statement();
            acccode = 0;
            accdescription = 0;
            groupcode = 0;
            deprate = 0;
            opewdv = 0;
            additions = 0;
            purdate = 0;
            sales = 0;
            saledate = 0;
            noofdays = 0;
            depamount = 0;
            closewdv = 0;
            soldwdv = 0;
            profitloss = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                refno = $(this).find('#txt_refno').val();
                acccode = $(this).find('#txt_acccode').val();
                accdescription = $(this).find('#txt_accdescription').val();
                groupcode = $(this).find('#txt_groupcode').val();
                deprate = $(this).find('#txt_deprate').val();
                opewdv = $(this).find('#txt_opewdv').val();
                additions = $(this).find('#txt_additions').val();
                purdate = $(this).find('#txt_purdate').val();
                sales = $(this).find('#txt_sales').val();
                saledate = $(this).find('#txt_saledate').val();
                noofdays = $(this).find('#txt_noofdays').val();
                depamount = $(this).find('#txt_depamount').val();
                closewdv = $(this).find('#txt_closewdv').val();
                soldwdv = $(this).find('#txt_soldwdv').val();
                profitloss = $(this).find('#txt_profitloss').val();
                accountid = $(this).find('#txt_accountid').val();
                groupid = $(this).find('#txt_groupid').val();
                //sno = $(this).find('#txt_sno').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                DataTable.push({ Sno: txtsno,refno:refno,accountid:accountid,groupid:groupid, acccode: acccode, accdescription: accdescription, groupcode: groupcode, deprate: deprate, opewdv: opewdv, additions: additions, purdate: purdate, sales: sales, hdnproductsno: hdnproductsno, saledate: saledate, noofdays: noofdays, depamount: depamount, closewdv: closewdv, soldwdv:soldwdv , profitloss: profitloss });
                rowsno++;
            });
            acccode = 0;
            accdescription = 0;
            groupcode = 0;
            deprate = 0;
            opewdv = 0;
            additions = 0;
            purdate = 0;
            sales = 0;
            saledate = 0;
            noofdays = 0;
            depamount = 0;
            closewdv = 0;
            soldwdv = 0;
            profitloss = 0;
            hdnproductsno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, refno: refno, acccode: acccode, accountid: accountid, groupid: groupid, accdescription: accdescription, groupcode: groupcode, deprate: deprate, opewdv: opewdv, additions: additions, purdate: purdate, sales: sales, hdnproductsno: hdnproductsno, saledate: saledate, noofdays: noofdays, depamount: depamount, closewdv: closewdv, soldwdv: soldwdv, profitloss: profitloss });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">AccountCode</th><th scope="col">AccDescription</th><th scope="col">GroupCode</th><th scope="col">Dep.Rate%</th><th scope="col">OpeningWDV</th><th scope="col">Additions</th><th scope="col">PurchaseDate</th><th scope="col">Sales</th><th scope="col">SaleDate</th><th scope="col">NumberOfDays</th><th scope="col">Dep.Amount</th><th scope="col">ClosingWDV</th><th scope="col">SoldWDV</th><th scope="col">Profit/Loss</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td style="display:none" ><input id="txt_refno"  type="text" class="form-control" placeholder= "Ref. No"  value="' + DataTable[i].refno + '"  style="width:130px;"  /></td>';
                results += '<td ><input id="txt_acccode" type="text" class="clscode1" placeholder= "acccode"  style="width:100px;"   value="' + DataTable[i].acccode + '"/></td>';
                results += '<td ><input id="txt_accdescription" type="text" class="clsDescription" placeholder= "Description" style="width:100px;" value="' + DataTable[i].accdescription + '"/></td>';
                results += '<td ><input id="txt_groupcode"  type="text"  class="clscode2" placeholder= "groupcode"  style="width:100px;" value="' + DataTable[i].groupcode + '"/></td>';
                results += '<td ><input id="txt_deprate"type="text" onkeypress="return isNumber(event)"  class="" placeholder= "deprate" style="width:100px;"  value="' + DataTable[i].deprate + '"/></td>';
                results += '<td ><input id="txt_opewdv" type="text" onkeypress="return isNumber(event)"  class="clsopewdv" placeholder= "opewdv" style="width:100px;" value="' + DataTable[i].opewdv + '"/></td>';
                results += '<td ><input id="txt_additions" type="text" onkeypress="return isNumber(event)" class="clsadditions" placeholder= "additions"   style="width:100px;"  value="' + DataTable[i].additions + '"/></td>';
                results += '<td ><input id="txt_purdate" type="date"  class="" placeholder= "purdate"   style="width:150px;"  value="' + DataTable[i].purdate + '"/></td>';
                results += '<td ><input id="txt_sales" type="text" onkeypress="return isNumber(event)" class="clssales" placeholder= "sales" style="width:100px;"  value="' + DataTable[i].sales + '"/></td>';
                results += '<td ><input id="txt_saledate"type="date"   class="" placeholder= "saledate" style="width:150px;"  value="' + DataTable[i].saledate + '"/></td>';
                results += '<td ><input id="txt_noofdays" type="text" onkeypress="return isNumber(event)" class="" placeholder= "noofdays" style="width:100px;" value="' + DataTable[i].noofdays + '"/></td>';
                results += '<td ><input id="txt_depamount" type="text" onkeypress="return isNumber(event)" class="clsdepamount" placeholder= "depamount"   style="width:100px;"  value="' + DataTable[i].depamount + '"/></td>';
                results += '<td ><input id="txt_closewdv" type="text" onkeypress="return isNumber(event)"  class="clsclosewdv" placeholder= "closewdv"   style="width:100px;"  value="' + DataTable[i].closewdv + '"/></td>';
                results += '<td ><input id="txt_soldwdv" type="text" onkeypress="return isNumber(event)" class="clssoldwdv" placeholder= "soldwdv" style="width:100px;"  value="' + DataTable[i].soldwdv + '"/></td>';
                results += '<td ><input id="txt_profitloss" type="text"  class="clsprofitloss" placeholder= "profitloss" style="width:100px;" value="' + DataTable[i].profitloss + '"/></td>';
                //results += '<td style="display:none"><input id="txt_sno" type="text" class="form-control"  style="width:50px;"  value="' + DataTable[i].sno + '"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" ><input id="txt_accountid"  type="hidden" value="' + DataTable[i].accountid + '"/></td>';
                results += '<td style="display:none" ><input id="txt_groupid"  type="hidden" value="' + DataTable[i].groupid + '"/></td>';
                results += '<td style="display:none" ><input id="hdnproductsno"  type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            get_accountmaster_click();
            get_primary_group();
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
        function save_depreciation_statement() {
            var branchcode = document.getElementById('txt_branchcode').value;
            var branchid = document.getElementById('txt_branchid').value;
            if (branchcode == "") {
                alert("Enter branchcode ");
                return false;
            }
            var branchname = document.getElementById('txt_branchname').value;
            var financeyear = document.getElementById('txt_financeyear').value;
            if (financeyear == "") {
                alert("Enter financeyear ");
                return false;
            }
            var date = document.getElementById('txt_date').value;
            if (date == "") {
                alert("Enter date ");
                return false;
            }
            var btnval = document.getElementById('btn_save').value;
            var sno = document.getElementById('txt_sno').value;
            var dps_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtsno').text();
                var refno = $(this).find('#txt_refno').val();
                var acccode = $(this).find('#txt_acccode').val();
                var accdescription = $(this).find('#txt_accdescription').val();
                var groupcode = $(this).find('#txt_groupcode').val();
                var deprate = $(this).find('#txt_deprate').val();
                var opewdv = $(this).find('#txt_opewdv').val();
                var additions = $(this).find('#txt_additions').val();
                var purdate = $(this).find('#txt_purdate').val();
                var sales = $(this).find('#txt_sales').val();
                var saledate = $(this).find('#txt_saledate').val();
                var noofdays = $(this).find('#txt_noofdays').val();
                var depamount = $(this).find('#txt_depamount').val();
                var closewdv = $(this).find('#txt_closewdv').val();
                var soldwdv = $(this).find('#txt_soldwdv').val();
                var profitloss = $(this).find('#txt_profitloss').val();
                var accountid = $(this).find('#txt_accountid').val();
                var groupid = $(this).find('#txt_groupid').val();
                //var sno = $(this).find('#txt_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (sales == "" || sales == "0") {
                }
                else {
                    dps_array.push({ 'refno': refno,'accountid':accountid,'groupid':groupid, 'acccode': acccode, 'accdescription': accdescription, 'groupcode': groupcode, 'deprate': deprate, 'opewdv': opewdv, 'additions': additions, 'purdate': purdate, 'sales': sales, 'saledate': saledate, 'noofdays': noofdays, 'depamount': depamount, 'closewdv': closewdv, 'soldwdv': soldwdv, 'profitloss': profitloss, 'hdnproductsno': hdnproductsno
                    });
                }
            });

            var data = { 'op': 'save_depreciation_statement','branchid':branchid, 'branchcode': branchcode, 'branchname': branchname, 'financeyear': financeyear, 'date': date, 'btnval': btnval, 'dps_array': dps_array, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_depreciation_statement();
                    $('#vehmaster_fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_inwardtable').show();
                }

            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function get_depreciation_statement() {
            var data = { 'op': 'get_depreciation_statement' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldepreciation_details(msg);
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
        var chequesub = [];
        function filldepreciation_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"><th scope="col">BranchName</th><th scope="col">BranchCode</th></th><th scope="col">FinancialYear</th></th><th scope="col">Date</th></tr></thead></tbody>';
            var chq = msg[0].deprectionstatement;
            chequesub = msg[0].deprectionstatementsub;
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < chq.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getdepreciationdetails(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="branchcode"  class="1"  >' + chq[i].branchcode + '</td>';
                results += '<td data-title="financeyear"  class="2" style="display:none" >' + chq[i].branchid + '</td>';
                results += '<td data-title="year"  class="3">' + chq[i].branchname + '</td>';
//                results += '<td data-title="date"  class="4" style="display:none">' + chq[i].year + '</td>';
                results += '<td data-title="code"  class="5" >' + chq[i].financeyear + '</td>';
                results += '<td data-title="branchname"  class="6" >' + chq[i].date + '</td>';
                results += '<td data-title="sno"  class="7"  style="display:none">' + chq[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable").html(results);
        }
        function getdepreciationdetails(thisid) {

            $('#vehmaster_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_Grid').hide();
            $('#div_SectionData').show();
            $('#div_inwardtable').hide();
            $('#newrow').show();

            var branchcode = $(thisid).parent().parent().children('.1').html();
            var branchid = $(thisid).parent().parent().children('.2').html();
            var branchname = $(thisid).parent().parent().children('.3').html();
            var financeyear = $(thisid).parent().parent().children('.5').html();
//            var year = $(thisid).parent().parent().children('.5').html();
            var date = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.7').html();

            document.getElementById('txt_branchcode').value = branchcode;
            document.getElementById('txt_branchid').value = branchid;
            document.getElementById('txt_branchname').value = branchname;
            document.getElementById('txt_financeyear').value = financeyear;
            document.getElementById('txt_date').value = date;
            document.getElementById('txt_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";

            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">AccountCode</th><th scope="col">AccDescription</th><th scope="col">GroupCode</th><th scope="col">Dep.Rate%</th><th scope="col">OpeningWDV</th><th scope="col">Additions</th><th scope="col">PurchaseDate</th><th scope="col">Sales</th><th scope="col">SaleDate</th><th scope="col">NumberOfDays</th><th scope="col">Dep.Amount</th><th scope="col">ClosingWDV</th><th scope="col">SoldWDV</th><th scope="col">Profit/Loss</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < chequesub.length; i++) {
                if (sno == chequesub[i].sno) {
                    results += '<tr><td data-title="From" style="display:none" ><input id="txt_refno" style="text-align:center;"  class="form-control" name="glcode"  value="' + chequesub[i].refno + '" style="width:130px;" readonly ></td>';
                    results += '<td data-title="From"><input id="txt_acccode" type="text" class="clscode1" name="groupname"  value="' + chequesub[i].accountno + '"style="width:100px;"></td>';
                    results += '<td data-title="From"><input  id="txt_accdescription" type="text" name="clsDescription" class="form-control" value="' + chequesub[i].accountid + '"  style="width:100px;"></td>';
                    results += '<td data-title="From"><input  id="txt_groupcode" type="text" class="clscode2" name="percentage" value="' + chequesub[i].groupcode + '"  style="width:100px;"></td>';
                    results += '<td data-title="From"><input id="txt_deprate" onkeypress="return isNumber(event)" type="text" class="" name="exemptionamount"   value="' + chequesub[i].deprate + '"  style="width:100px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_opewdv" onkeypress="return isNumber(event)" type="text" class="clsopewdv"  name="fromdate" value="' + chequesub[i].opewdv + '"  style="width:100px;"></td>';
                    results += '<td data-title="From"><input id="txt_additions" onkeypress="return isNumber(event)" type="text" class="clsadditions"  name="todate"  value="' + chequesub[i].additions + '"  style="width:100px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_purdate" type="date" class="" name="percentage" value="' + chequesub[i].purdate + '"  style="width:150px;"></td>';
                    results += '<td data-title="From"><input id="txt_sales" onkeypress="return isNumber(event)" type="text" class="clssales" name="exemptionamount"   value="' + chequesub[i].sales + '"  style="width:100px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_saledate" type="date" class=""  name="fromdate" value="' + chequesub[i].saledate + '"  style="width:150px;"></td>';
                    results += '<td data-title="From"><input id="txt_noofdays" onkeypress="return isNumber(event)" type="text" class=""  name="todate"  value="' + chequesub[i].noofdays + '"  style="width:100px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_depamount" onkeypress="return isNumber(event)" type="text" class="clsdepamount" name="percentage" value="' + chequesub[i].depamount + '"  style="width:100px;"></td>';
                    results += '<td data-title="From"><input id="txt_closewdv" onkeypress="return isNumber(event)" type="text" class="clsclosewdv" name="exemptionamount"   value="' + chequesub[i].closewdv + '"  style="width:100px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_soldwdv" onkeypress="return isNumber(event)" type="text" class="clssoldwdv"  name="fromdate" value="' + chequesub[i].soldwdv + '"  style="width:100px;"></td>';
                    results += '<td data-title="From"><input id="txt_profitloss" type="text" class="clsprofitloss"  name="todate"  value="' + chequesub[i].profitloss + '"  style="width:100px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="clsDescription" id="txt_accountid" name="hdnproductsno" value="' + chequesub[i].accountid + '"style="width:100px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="clsDescription" id="txt_groupid" name="hdnproductsno" value="' + chequesub[i].groupid + '"style="width:100px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="hdnproductsno" name="hdnproductsno" value="' + chequesub[i].sno1 + '"style="width:100px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            get_primary_group();
            get_accountmaster_click();
        }
        function forclearall() {
            document.getElementById('txt_branchcode').value = "";
            document.getElementById('txt_branchname').value = "";
            document.getElementById('txt_financeyear').value = "";
            document.getElementById('txt_date').value = "";
            document.getElementById('btn_save').value = "Save";
        }
        var closewdv;
        var profitloss;
        var depamount;
        var closewdv;
        deprate = 0;
        opewdv = 0;
        additions = 0;
        purdate = 0;
        sales = 0;
        saledate = 0;
        noofdays = 0;
        depamount = 0;
        closewdv = 0;
        soldwdv = 0;
        profitloss = 0;
        function calTotal() {
            var $row = $(this).closest('tr'),
            sales = $row.find('.clssales').val(),
            soldwdv = $row.find('.clssoldwdv').val(),
            profitloss = parseFloat(sales) - parseFloat(soldwdv);
            $row.find('.clsprofitloss').val(profitloss);
        }
        function calTotal2() {
            var $row = $(this).closest('tr'),
            opewdv = $row.find('.clsopewdv').val(),
            additions = $row.find('.clsadditions').val(),
            depamount = parseFloat(opewdv) + parseFloat(additions);
            $row.find('.clsdepamount').val(depamount);
        }
        function calTotal3() {
            var $row = $(this).closest('tr'),
            opewdv = $row.find('.clsopewdv').val(),
            additions = $row.find('.clsadditions').val(),
            sales = $row.find('.clssales').val(),
            depamount = $row.find('.clsdepamount').val(),
            closewdv = parseFloat(opewdv) + parseFloat(additions) - parseFloat(sales) - parseFloat(depamount);
            $row.find('.clsclosewdv').val(closewdv);
        }
        function calTotal4() {
            var $row = $(this).closest('tr'),
            opewdv = $row.find('.clsopewdv').val(),
            additions = $row.find('.clsadditions').val(),
            depamount = $row.find('.clsdepamount').val(),
            soldwdv = parseFloat(opewdv) + parseFloat(additions) - parseFloat(depamount);
            $row.find('.clssoldwdv').val(soldwdv);
        }
        $(document).click(function () {
            $('#tabledetails').on('change', '.clssales', calTotal)
            $('#tabledetails').on('change', '.clssoldwdv', calTotal)
            $('#tabledetails').on('change', '.clsprofitloss', calTotal)

            $('#tabledetails').on('change', '.clsopewdv', calTotal2)
            $('#tabledetails').on('change', '.clsadditions', calTotal2)
            $('#tabledetails').on('change', '.clsdepamount', calTotal2)

            $('#tabledetails').on('change', '.clsopewdv', calTotal3)
            $('#tabledetails').on('change', '.clsadditions', calTotal3)
            $('#tabledetails').on('change', '.clssales', calTotal3)
            $('#tabledetails').on('change', '.clsdepamount', calTotal3)
            $('#tabledetails').on('change', '.clsclosewdv', calTotal3)

            $('#tabledetails').on('change', '.clsopewdv', calTotal4)
            $('#tabledetails').on('change', '.clsadditions', calTotal4)
            $('#tabledetails').on('change', '.clsdepamount', calTotal4)
            $('#tabledetails').on('change', '.clssoldwdv', calTotal4)
        });
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
            Depreciation Statement<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transactions</a></li>
            <li><a href="#">Depreciation Statement</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Depreciation Statement
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <table>
                    <tr>
                           
                            <td>
                                <input id="add_Inward" type="button" name="submit" value='Add Statements ' class="btn btn-primary" />
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
                                <input id="txt_branchcode" class="form-control" onchange="Getbranchcode(this);"  placeholder="Enter Branch Code">
                                <input id="txt_branchid" class="form-control" type="text"  style="display:none"/>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_branchname" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <label>
                                    Financial Year</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_financeyear" class="form-control" readonly >
                                </select>
                            </td>
                            </tr>
                            <tr>
                                <td>
                                <label>
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" class="form-control" type="date" >
                                </input>
                            </td>
                            </tr>
                            <td style="display: none;">
                                         <input id="txt_sno" type="text"  class="form-control"  />
                                    </td>
                            </table>
                            </div>
                                <br />
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Depreciation Statement Entry
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
                                <table align="center">
                                    <tr>
                                        <td>
                                            <input type="button" class="btn btn-success" id="btn_save" value="Save" onclick="save_depreciation_statement();" />
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
