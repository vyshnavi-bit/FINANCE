<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="MiscellaneousBillEntry.aspx.cs" Inherits="MiscellaneousBillEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $("#div_billentry").css("display", "block");
            get_financial_year();
            get_natureof_work();
            get_dept_details();
            get_employee_details();
            GetFixedrows();
            get_budget_details();
            get_costcenter_details();
            forclearall();
            get_miscellaneousbillentry_click();
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
            $('#txt_transatondate').val(yyyy + '-' + mm + '-' + dd);
            $('#txt_advreqdate').val(yyyy + '-' + mm + '-' + dd);
            $('#add_Inward').click(function () {
                forclearall();
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
                
            });
            $('#close_id').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
                $('#div_SectionData').show();
                forclearall();
            });
        });
        function forclearall() {
            $("#div_CategoryData").show();
            $("#fillform").hide();
            $('#showlogs').show();
            $('#div_SectionData').show();
            forclearall();
        }
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

        function show_entry_details() {
            $("#div_billentry").css("display", "block");
            $("#div_billapproval").css("display", "none");
            get_financial_year();
            get_natureof_work();
            get_dept_details();
            get_employee_details();
            GetFixedrows();
            get_budget_details();
            get_costcenter_details();
            forclearall();
            get_miscellaneousbillentry_click();
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
            $('#txt_transatondate').val(yyyy + '-' + mm + '-' + dd);
            $('#txt_advreqdate').val(yyyy + '-' + mm + '-' + dd);
            $('#add_Inward').click(function () {
                forclearall();
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();

            });
            $('#close_id').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
                $('#div_SectionData').show();
                forclearall();
            });
        }

        function show_approval_details() {
            $("#div_billentry").css("display", "none");
            $("#div_billapproval").css("display", "block");
            get_appmiscellaneousbillentry_click();
        }
        function get_financial_year() {
            var data = { 'op': 'get_financial_year' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillfinace(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            callHandler(data, s, e);
        }
        function fillfinace(msg)
        {
            for (i = 0; i < msg.length; i++) {
                if (msg[i].currentyear == "true") {
                    document.getElementById('fin_yr').value = msg[i].year;
                }
            }
        }
        var nature = [];
        function get_natureof_work() {
            var data = { 'op': 'get_natureof_work' };
            var s = function (msg) {
                if (msg) {
                    nature = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].sno;
                        empnameList.push(empname);
                    }
                    $('#txt_ntrofwork').autocomplete({
                        source: empnameList,
                        change: Getnature,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getnature() {
            var empname = document.getElementById('txt_ntrofwork').value;
            for (var i = 0; i < nature.length; i++) {
                if (empname == nature[i].sno) {
                    document.getElementById('txt_naturename').value = nature[i].shortdescription;
                }
            }
        }
        var dept = [];
        function get_dept_details() {
            var data = { 'op': 'get_dept_details' };
            var s = function (msg) {
                if (msg) {
                    dept = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].DepartmentCode;
                        empnameList.push(empname);
                    }
                    $('#txt_departmentcode').autocomplete({
                        source: empnameList,
                        change: Getdept,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getdept() {
            var empname = document.getElementById('txt_departmentcode').value;
            for (var i = 0; i < dept.length; i++) {
                if (empname == dept[i].DepartmentCode) {
                    document.getElementById('txt_departmentname').value = dept[i].DepartmentName;
                    document.getElementById('txt_departmentcode_sno').value = dept[i].sno;
                }
            }
        }
        var employeedetails = [];
        function get_employee_details() {
            var data = { 'op': 'get_employee_details' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].name;
                        empnameList.push(empname);
                    }
                    $('#txt_name').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function employeenamechange() {
            var empname = document.getElementById('txt_name').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].name) {
                    document.getElementById('txt_nameid').value = employeedetails[i].sno;
                    //document.getElementById('txt_desgnation').value = employeedetails[i].deptname;
                }
            }
        }
        var filldescription = [];
        function get_budget_details() {
            var data = { 'op': 'get_budget_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata(msg);
                        filldescription = msg;
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
                var budgetcode = msg[i].budgetcode;
                compiledList.push(budgetcode);
            }

            $('.budgetcodecls').autocomplete({
                source: compiledList,
                change: test1,
                autoFocus: true
            });
        }
        var emptytable = [];
        function test1() {
            var budgetcode = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(budgetcode) == -1) {
                for (var i = 0; i < filldescription.length; i++) {
                    if (budgetcode == filldescription[i].budgetcode) {
                        $(this).closest('tr').find('#txt_budgectcode_sno').val(filldescription[i].sno);
                        emptytable.push(budgetcode);
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
        var filldescription1 = [];
        function get_costcenter_details() {
            var data = { 'op': 'get_costcenter_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata1(msg);
                        filldescription1 = msg;
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
                var costcentercode = msg[i].costcentercode;
                compiledList.push(costcentercode);
            }

            $('.costcodecls').autocomplete({
                source: compiledList,
                change: test,
                autoFocus: true
            });
        }
        var emptytable1 = [];
        function test() {
            var costcentercode = $(this).val();
            var checkflag = true;
            if (emptytable1.indexOf(costcentercode) == -1) {
                for (var i = 0; i < filldescription1.length; i++) {
                    if (costcentercode == filldescription1[i].costcentercode) {
                        $(this).closest('tr').find('#txt_costcode_sno').val(filldescription1[i].sno);
                        emptytable1.push(costcentercode);
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

        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">CostCenterCode</th><th scope="col">BudgetCode</th><th scope="col">GRN No.</th><th scope="col">Vendor Code</th><th scope="col">Name</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Item</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col">Rate</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>'; 
            for (var i = 1; i < 10; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td style="display:none" ><input id="txt_refno"  type="text" class="form-control" placeholder= "Ref. No"  style="width:130px;"  /></td>';
                results += '<td ><input id="txt_costcode" type="text" class="costcodecls" placeholder= "Cost Center Code"  style="width:130px;"  /></td>';
                results += '<td style="display:none"><input id="txt_costcode_sno" type="text" class="costcodesnocls" /></td>';
                results += '<td ><input id="txt_budgectcode" type="text" class="budgetcodecls" placeholder= "Budget Code" style="width:100px;"/></td>';
                results += '<td style="display:none"><input id="txt_budgectcode_sno" type="text" class="budgetcodesnocls" /></td>';
                results += '<td ><input id="txt_grnno" type="text"  placeholder= "GRN No." class="form-control"  style="width:100px;"/></td>';
                results += '<td ><input id="txt_vendorcode" type="text"  class="form-control" placeholder= "Vendor Code" style="width:100px;"/></td>';
                results += '<td ><input id="txt_vendorname" type="text"   class="form-control" placeholder= "Name" style="width:100px;"/></td>';
                results += '<td ><input id="txt_billno" type="text"  class="form-control" placeholder= "Bill No"   style="width:100px;"/></td>';
                results += '<td ><input id="txt_billdate" type="date"  class="form-control" placeholder= "Bill Date" style="width:150px;"/></td>';
                results += '<td ><input id="txt_item" type="text"  class="form-control" placeholder= "Item" style="width:100px;"/></td>';
                results += '<td ><input id="txt_description" type="text"   class="form-control" placeholder= "Description" style="width:100px;"/></td>';
                results += '<td ><input id="txt_uom" type="text"  class="form-control" placeholder= "UOM"   style="width:100px;"/></td>';
                results += '<td ><input id="txt_quantity" type="text" onkeypress="return isNumber(event)" class="clsquantity" placeholder= "Quantity" style="width:100px;"/></td>';
                results += '<td ><input id="txt_rate" type="text"  class="clsrate" placeholder= "Rate" style="width:100px;"/></td>';
                results += '<td ><input id="txt_amount" type="text" onkeypress="return isNumber(event)" class="clsamount" placeholder= "Amount"   style="width:100px;"/></td>';
                results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:100px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function insertrow() {
            DataTable = [];
            get_budget_details();
            get_costcenter_details();
            refno = 0;
            costcode = 0;
            budgectcode = 0;
            grnno = 0;
            vendorcode = 0;
            name = 0;
            billno = 0;
            billdate = 0;
            item = 0;
            description = 0;
            uom = 0;
            quantity = 0;
            rate = 0;
            amount = 0;
            remarks=0;

            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                refno = $(this).find('#txt_refno').val();
                costcode = $(this).find('#txt_costcode').val();
                budgectcode = $(this).find('#txt_budgectcode').val();
                grnno = $(this).find('#txt_grnno').val();
                vendorcode = $(this).find('#txt_vendorcode').val();
                name = $(this).find('#txt_vendorname').val();
                billno = $(this).find('#txt_billno').val();
                billdate = $(this).find('#txt_billdate').val();
                item = $(this).find('#txt_item').val();
                description = $(this).find('#txt_description').val();
                uom = $(this).find('#txt_uom').val();
                quantity = $(this).find('#txt_quantity').val();
                rate = $(this).find('#txt_rate').val();
                amount = $(this).find('#txt_amount').val();
                remarks = $(this).find('#txt_remarks').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                DataTable.push({ txtsno:txtsno, refno: refno, costcode: costcode, budgectcode: budgectcode, grnno: grnno, vendorcode: vendorcode, name: name, billno: billno,billdate:billdate,item:item , description:description,uom:uom ,quantity:quantity,rate:rate,amount:amount,remarks:remarks,hdnproductsno:hdnproductsno });
                rowsno++;
            });
            costcode = 0;
            budgectcode = 0;
            grnno = 0;
            vendorcode = 0;
            name = 0;
            billno = 0;

            billdate = 0;
            item = 0;
            description = 0;
            uom = 0;
            quantity = 0;
            rate = 0;
            amount = 0;
            remarks=0;
            hdnproductsno=0;
            var txtsno = parseInt(txtsno) + 1;
            DataTable.push({ txtsno:txtsno, refno: refno, costcode: costcode, budgectcode: budgectcode, grnno: grnno, vendorcode: vendorcode, name: name, billno: billno,billdate:billdate,item:item , description:description,uom:uom ,quantity:quantity,rate:rate,amount:amount,remarks:remarks,hdnproductsno:hdnproductsno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">CostCenterCode</th><th scope="col">BudgetCode</th><th scope="col">GRN No.</th><th scope="col">Vendor Code</th><th scope="col">Name</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Item</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col">Rate</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].txtsno + '</td>';
                results += '<td style="display:none" ><input id="txt_refno"  type="text" class="form-control" placeholder= "Ref. No"  style="width:130px;" value="' + DataTable[i].refno + '" /></td>';
                results += '<td ><input id="txt_costcode" type="text" class="costcodecls" placeholder= "Cost Center Code"  style="width:130px;"  /></td>';
                results += '<td style="display:none"><input id="txt_costcode_sno" type="text" class="costcodesnocls" /></td>';
                results += '<td ><input id="txt_budgectcode" type="text" class="budgetcodecls" placeholder= "Budget Code" style="width:100px;"/></td>';
                results += '<td style="display:none"><input id="txt_budgectcode_sno" type="text" class="budgetcodesnocls" /></td>';
                results += '<td ><input id="txt_grnno" type="text"  placeholder= "GRN No." class="form-control"  style="width:100px;" value="' + DataTable[i].grnno + '"/></td>';
                results += '<td ><input id="txt_vendorcode" type="text"  class="form-control" placeholder= "Vendor Code" style="width:100px;" value="' + DataTable[i].vendorcode  + '"/></td>';
                results += '<td ><input id="txt_vendorname" type="text"   class="form-control" placeholder= "Name" style="width:100px;" value="' + DataTable[i].name + '"/></td>';
                results += '<td ><input id="txt_billno" type="text"  class="form-control" placeholder= "Bill No"   style="width:100px;" value="' + DataTable[i].billno  + '"/></td>';
                results += '<td ><input id="txt_billdate" type="date"  class="form-control" placeholder= "Bill Date" style="width:150px;"value="' + DataTable[i].billdate  + '"/></td>';
                results += '<td ><input id="txt_item" type="text"  class="form-control" placeholder= "Item" style="width:100px;"value="' + DataTable[i].item  + '" /></td>';
                results += '<td ><input id="txt_description" type="text"   class="form-control" placeholder= "Description" style="width:100px;" value="' + DataTable[i].description  + '"/></td>';
                results += '<td ><input id="txt_uom" type="text"  class="form-control" placeholder= "UOM"   style="width:100px;"value="' + DataTable[i].uom  + '" /></td>';
                results += '<td ><input id="txt_quantity" type="text" onkeypress="return isNumber(event)"  class="clsquantity" placeholder= "Quantity" style="width:100px;" value="' + DataTable[i].quantity + '"/></td>';
                results += '<td ><input id="txt_rate" type="text" onkeypress="return isNumber(event)"  class="clsrate" placeholder= "Rate" style="width:100px;" value="' + DataTable[i].rate + '"/></td>';
                results += '<td ><input id="txt_amount" type="text" onkeypress="return isNumber(event)"  class="clsamount" placeholder= "Amount"   style="width:100px;" value="' + DataTable[i].amount + '"/></td>';
                results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:100px;" value="' + DataTable[i].remarks  + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '" /></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
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
        function save_miscellaneousbillentry_click() {
            var transatondate = document.getElementById('txt_transatondate').value;
            if (transatondate == "") {
                alert("Enter  transatondate");
                return false;
            }
            var financeyear = document.getElementById('txt_financeyear').value;
            if (financeyear == "") {
                alert("Enter  financeyear");
                return false;
            }
            var ntrofwork = document.getElementById('txt_ntrofwork').value;
            var naturename = document.getElementById('txt_naturename').value;
            var name = document.getElementById('txt_name').value;
            if (name == "" || nameid == "") {
                alert("Enter  name");
                return false;
            }
            var nameid = document.getElementById('txt_nameid').value;
            var advreqamount = document.getElementById('txt_advreqamount').value;
            if (advreqamount == "") {
                alert("Enter  advreqamount");
                return false;
            }
            var advreqdate = document.getElementById('txt_advreqdate').value;
            if (advreqdate == "") {
                alert("Enter  advreqdate");
                return false;
            }
            var departmentcode = document.getElementById('txt_departmentcode_sno').value;
            if (departmentcode == "") {
                alert("Enter  departmentcode");
                return false;
            }
            var departmentname = document.getElementById('txt_departmentname').value;
            var particulars = document.getElementById('txt_particulars').value;
            var totalamount = document.getElementById('txt_totalamount').value;
            if (totalamount == "") {
                alert("Enter  totalamount");
                return false;
            }
            var status = document.getElementById('txt_status').value;
            if (status == "") {
                alert("Select  status");
                return false;
            }
            var sno = document.getElementById('txt_sno').value;  
            var btnval = document.getElementById('btn_save').value;

            var mbe_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtsno').text();
                var refno = $(this).find('#txt_refno').val();
                var costcode = $(this).find('#txt_costcode_sno').val();
                var budgectcode = $(this).find('#txt_budgectcode_sno').val();
                var grnno = $(this).find('#txt_grnno').val();
                var vendorcode = $(this).find('#txt_vendorcode').val();
                var vendorname = $(this).find('#txt_vendorname').val();
                var billno = $(this).find('#txt_billno').val();
                var billdate = $(this).find('#txt_billdate').val();

                var item = $(this).find('#txt_item').val();
                var description = $(this).find('#txt_description').val();
                var uom = $(this).find('#txt_uom').val();
                var quantity = $(this).find('#txt_quantity').val();
                var rate = $(this).find('#txt_rate').val();
                var amount = $(this).find('#txt_amount').val();
                var remarks = $(this).find('#txt_remarks').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (billno == "" || billno == "0") {
                }
                else {
                    mbe_array.push({ 'refno': refno, 'costcode': costcode, 'budgectcode': budgectcode, 'grnno': grnno, 'vendorcode': vendorcode,
                        'vendorname': vendorname, 'billno': billno, 'billdate': billdate, 'item': item, 'description': description, 'uom': uom,
                        'quantity': quantity, 'rate': rate, 'amount': amount, 'remarks': remarks, 'hdnproductsno': hdnproductsno
                    });
                }
            });
            var data = { 'op': 'save_miscellaneousbillentry_click', 'transatondate': transatondate, 'financeyear': financeyear, 'ntrofwork': ntrofwork, 'naturename': naturename,
                'name': name, 'nameid': nameid, 'advreqamount': advreqamount, 'advreqdate': advreqdate, 'departmentcode': departmentcode, 'departmentname': departmentname,
                'particulars': particulars, 'totalamount': totalamount, 'sno': sno, 'btnval': btnval, 'mbe_array': mbe_array, 'status': status
            };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    $('#vehmaster_fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_inwardtable').show();
                    get_miscellaneousbillentry_click();
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function forclearall() {
            document.getElementById('txt_transatondate').value = "";
            document.getElementById('txt_financeyear').selectedIndex = 0;
            document.getElementById('txt_ntrofwork').value = "";
            document.getElementById('txt_naturename').value = "";
            document.getElementById('txt_name').value = "";
            document.getElementById('txt_nameid').value = "";
            document.getElementById('txt_advreqamount').value = "";
            document.getElementById('txt_advreqdate').value = "";
            document.getElementById('txt_departmentcode').value = "";
            document.getElementById('txt_departmentname').value = "";
            document.getElementById('txt_particulars').value = "";
            document.getElementById('txt_totalamount').value = "";
            document.getElementById('txt_refno').value = "";
            document.getElementById('txt_costcode').value = "";
            document.getElementById('txt_budgectcode').value = "";
            document.getElementById('txt_status').selectedIndex = 0;
            document.getElementById('txt_grnno').value = "";
            document.getElementById('txt_vendorcode').value = "";
            document.getElementById('txt_vendorname').value = "";
            document.getElementById('txt_billno').value = "";
            document.getElementById('txt_billdate').value = "";
            document.getElementById('txt_item').value = "";
            document.getElementById('txt_description').value = "";
            document.getElementById('txt_uom').value = "";
            document.getElementById('txt_quantity').value = "";
            document.getElementById('txt_rate').value = "";
            document.getElementById('txt_amount').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('btn_save').value = "Save";
            GetFixedrows();
            get_budget_details();
            get_costcenter_details();
        }
        function get_miscellaneousbillentry_click() {
            var data = { 'op': 'get_miscellaneousbillentry_click' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillmiscellaneous_details(msg);
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
        function fillmiscellaneous_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">TransatonDate</th><th scope="col">FinancialYear</th><th scope="col">NatureOfWork</th><th scope="col">Description</th><th scope="col">EmployeeName</th><th scope="col">AdvanceRequestNo.</th><th scope="col">AdvanceRequestDate</th><th scope="col">DepartmentName</th><th scope="col">DepartmentCode</th><th scope="col">Particulars</th><th scope="col">TotalAmount</th></tr></thead></tbody>';
            var chq = msg[0].miscellaneous;
            chequesub = msg[0].miscellaneoussub;
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < chq.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getpartytdsentry(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="year"  class="1">' + chq[i].transatondate + '</td>';
                results += '<td data-title="voucher" style="display:none" class="2">' + chq[i].financeyear + '</td>';
                results += '<td data-title="bankcode"  class="3">' + chq[i].year + '</td>';
                results += '<td data-title="bankname" style="display:none" class="4">' + chq[i].ntrofwork + '</td>';
                results += '<td data-title="chequenumber"  class="5">' + chq[i].natureofworkid + '</td>';
                results += '<td data-title="doe" "  class="6">' + chq[i].naturename + '</td>';
                results += '<td data-title="financial" style="display:none"  class="7" >' + chq[i].nameid + '</td>';
                results += '<td data-title="financial"  class="8" >' + chq[i].name + '</td>';

                results += '<td data-title="year"  class="9">' + chq[i].advreqamount + '</td>';
                results += '<td data-title="voucher"  class="10">' + chq[i].advreqdate + '</td>';
                results += '<td data-title="bankcode" style="display:none"  class="11">' + chq[i].departmentid + '</td>';
                results += '<td data-title="bankname"  class="12">' + chq[i].departmentname + '</td>';
                results += '<td data-title="chequenumber"  class="13">' + chq[i].departmentcode + '</td>';
                results += '<td data-title="doe" "  class="14">' + chq[i].particulars + '</td>';
                results += '<td data-title="financial"  class="15" >' + chq[i].totalamount + '</td>';
                results += '<td data-title="financial" style="display:none" class="17" >' + chq[i].status + '</td>';
                results += '<td data-title="sno"  class="16"  style="display:none">' + chq[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable").html(results);
        }
        function getpartytdsentry(thisid) {
            $('#vehmaster_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_Grid').hide();
            $('#div_SectionData').show();
            $('#div_inwardtable').hide();
            $('#newrow').show();
            var transatondate = $(thisid).parent().parent().children('.1').html();
            var financeyear = $(thisid).parent().parent().children('.2').html();
            var year = $(thisid).parent().parent().children('.3').html();
            var ntrofwork = $(thisid).parent().parent().children('.4').html();
            var natureofworkid = $(thisid).parent().parent().children('.5').html();
            var naturename = $(thisid).parent().parent().children('.6').html();
            var nameid = $(thisid).parent().parent().children('.7').html();
            var name = $(thisid).parent().parent().children('.8').html();
            var advreqamount = $(thisid).parent().parent().children('.9').html();
            var advreqdate = $(thisid).parent().parent().children('.10').html();
            var departmentid = $(thisid).parent().parent().children('.11').html();
            var departmentname = $(thisid).parent().parent().children('.12').html();
            var departmentcode = $(thisid).parent().parent().children('.13').html();
            var particulars = $(thisid).parent().parent().children('.14').html();
            var totalamount = $(thisid).parent().parent().children('.15').html();
            var sno = $(thisid).parent().parent().children('.16').html();
            var status = $(thisid).parent().parent().children('.17').html();

            document.getElementById('txt_transatondate').value = transatondate;
            document.getElementById('txt_financeyear').value = financeyear;
            document.getElementById('txt_ntrofwork').value = ntrofwork;
            document.getElementById('txt_naturename').value = naturename;
            document.getElementById('txt_name').value = name;
            document.getElementById('txt_nameid').value = nameid;
            document.getElementById('txt_advreqamount').value = advreqamount;
            document.getElementById('txt_advreqdate').value = advreqdate;
            document.getElementById('txt_departmentcode').value = departmentcode;
            document.getElementById('txt_departmentcode_sno').value = departmentid;
            document.getElementById('txt_departmentname').value = departmentname;
            document.getElementById('txt_particulars').value = particulars;
            document.getElementById('txt_totalamount').value = totalamount;
            document.getElementById('txt_status').value = status;
            document.getElementById('txt_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">CostCenterCode</th><th scope="col">BudgetCode</th><th scope="col">GRN No.</th><th scope="col">Vendor Code</th><th scope="col">Name</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Item</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col">Rate</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < chequesub.length; i++) {
                if (sno == chequesub[i].sno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td style="display:none" ><input id="txt_refno"  type="text" class="form-control" placeholder= "Ref. No"  style="width:130px;" value="' + chequesub[i].miscellaneous_refno + '" /></td>';
                    //results += '<td ><select id="txt_costcode" type="text" class="clscode2" placeholder= "Cost Center Code"  style="width:130px;" value="' + chequesub[i].costcode + '" /></td>';
                    //results += '<td ><select id="txt_budgectcode" type="text" class="clscode" placeholder= "Budget Code" style="width:100px;" value="' + chequesub[i].budgectcode + '"/></td>';
                    results += '<td ><input id="txt_costcode" type="text" class="costcodecls" placeholder= "Cost Center Code"  style="width:130px;" value="' + chequesub[i].costcenterid + '"  /></td>';
                    results += '<td style="display:none"><input id="txt_costcode_sno" type="text" class="costcodesnocls"  value="' + chequesub[i].costcode + '" /></td>';
                    results += '<td ><input id="txt_budgectcode" type="text" class="budgetcodecls" placeholder= "Budget Code" style="width:100px;"  value="' + chequesub[i].budgectid + '" /></td>';
                    results += '<td style="display:none"><input id="txt_budgectcode_sno" type="text" class="budgetcodesnocls" value="' + chequesub[i].budgectcode + '" /></td>';
                    results += '<td ><input id="txt_grnno" type="text"  placeholder= "GRN No." class="form-control"  style="width:100px;" value="' + chequesub[i].grnno + '"/></td>';
                    results += '<td ><input id="txt_vendorcode" type="text"  class="form-control" placeholder= "Vendor Code" style="width:100px;" value="' + chequesub[i].vendorcode + '"/></td>';
                    results += '<td ><input id="txt_vendorname" type="text"   class="form-control" placeholder= "Name" style="width:100px;" value="' + chequesub[i].vendorname + '"/></td>';
                    results += '<td ><input id="txt_billno" type="text"  class="form-control" placeholder= "Bill No"   style="width:100px;" value="' + chequesub[i].billno + '"/></td>';
                    results += '<td ><input id="txt_billdate" type="date"  class="form-control" placeholder= "Bill Date" style="width:150px;"value="' + chequesub[i].billdate + '"/></td>';
                    results += '<td ><input id="txt_item" type="text"  class="form-control" placeholder= "Item" style="width:100px;"value="' + chequesub[i].item + '" /></td>';
                    results += '<td ><input id="txt_description" type="text"   class="form-control" placeholder= "Description" style="width:100px;" value="' + chequesub[i].description + '"/></td>';
                    results += '<td ><input id="txt_uom" type="text"  class="form-control" placeholder= "UOM"   style="width:100px;"value="' + chequesub[i].uom + '" /></td>';
                    results += '<td ><input id="txt_quantity" type="text" onkeypress="return isNumber(event)" class="clsquantity" placeholder= "Quantity" style="width:100px;" value="' + chequesub[i].quantity + '"/></td>';
                    results += '<td ><input id="txt_rate" type="text" onkeypress="return isNumber(event)" class="clsrate" placeholder= "Rate" style="width:100px;" value="' + chequesub[i].rate + '"/></td>';
                    results += '<td ><input id="txt_amount" type="text" onkeypress="return isNumber(event)" class="clsamount" placeholder= "Amount"   style="width:100px;" value="' + chequesub[i].amount + '"/></td>';
                    results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:100px;" value="' + chequesub[i].remarks + '"/></td>';
                    results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + chequesub[i].sno1 + '" /></td>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            get_budget_details();
            get_costcenter_details();
        }
        function isNumber(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode != 46 && charCode > 31
            && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        var amount;
        quantity = 0;
        rate = 0;
        function calTotal() {
            var $row = $(this).closest('tr'),
            quantity = $row.find('.clsquantity').val(),
            rate = $row.find('.clsrate').val(),
            amount = parseFloat(quantity) * parseFloat(rate);
            $row.find('.clsamount').val(amount);
        }
        $(document).click(function () {
            $('#tabledetails').on('change', '.clsamount', calTotal)
        });

        //--------------------------------------------BILL APPROVAL---------------------------------------------------------------------

        function get_appmiscellaneousbillentry_click() {
            var data = { 'op': 'get_appmiscellaneousbillentry_click' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                    else {
                        var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
                        results += '<thead><tr><th scope="col"></th><th scope="col">TransatonDate</th><th scope="col">FinancialYear</th><th scope="col">NatureOfWork</th><th scope="col">Description</th><th scope="col">EmployeeName</th><th scope="col">AdvanceRequestNo.</th><th scope="col">AdvanceRequestDate</th><th scope="col">DepartmentName</th><th scope="col">DepartmentCode</th><th scope="col">Particulars</th><th scope="col">TotalAmount</th></tr></thead></tbody>';
                        results += '</table></div>';
                        $("#div_Deptdata").html(results);
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
        var chequesub_app = [];
        function filldetails(msg) {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">TransatonDate</th><th scope="col">FinancialYear</th><th scope="col">NatureOfWork</th><th scope="col">Description</th><th scope="col">EmployeeName</th><th scope="col">AdvanceRequestNo.</th><th scope="col">AdvanceRequestDate</th><th scope="col">DepartmentName</th><th scope="col">DepartmentCode</th><th scope="col">Particulars</th><th scope="col">TotalAmount</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
            var chq = msg[0].miscellaneous;
            chequesub_app = msg[0].miscellaneoussub;
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < chq.length; i++) {
                results += '<tr>';
                results += '<td scope="row"  class="1">' + chq[i].transatondate + '</td>';
                results += '<td scope="row" style="display:none" class="2">' + chq[i].financeyear + '</td>';
                results += '<td scope="row"  class="3">' + chq[i].year + '</td>';
                results += '<td scope="row" style="display:none" class="4">' + chq[i].ntrofwork + '</td>';
                results += '<td scope="row"  class="5">' + chq[i].natureofworkid + '</td>';
                results += '<td scope="row"  class="6">' + chq[i].naturename + '</td>';
                results += '<td scope="row" style="display:none"  class="7" >' + chq[i].nameid + '</td>';
                results += '<td scope="row" class="8" >' + chq[i].name + '</td>';
                results += '<td scope="row" class="9">' + chq[i].advreqamount + '</td>';
                results += '<td scope="row" class="10">' + chq[i].advreqdate + '</td>';
                results += '<td scope="row" style="display:none"  class="11">' + chq[i].departmentid + '</td>';
                results += '<td scope="row"  class="12">' + chq[i].departmentname + '</td>';
                results += '<td scope="row" class="13">' + chq[i].departmentcode + '</td>';
                results += '<td scope="row" class="14">' + chq[i].particulars + '</td>';
                results += '<td scope="row" class="15" >' + chq[i].totalamount + '</td>';
                results += '<td scope="row" class="17" >' + chq[i].status + '</td>';
                results += '<td><input id="btn_poplate" type="button"  data-toggle="modal" data-target="#myModal" onclick="getme(this)" name="submit" class="btn btn-primary" value="View"/></td>';
                results += '<td data-title="sno"  class="16"  style="display:none">' + chq[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }
        function getme(thisid) {

            var transatondate = $(thisid).parent().parent().children('.1').html();
            var financeyear = $(thisid).parent().parent().children('.2').html();
            var year = $(thisid).parent().parent().children('.3').html();
            var ntrofwork = $(thisid).parent().parent().children('.4').html();
            var natureofworkid = $(thisid).parent().parent().children('.5').html();
            var naturename = $(thisid).parent().parent().children('.6').html();
            var nameid = $(thisid).parent().parent().children('.7').html();
            var name = $(thisid).parent().parent().children('.8').html();
            var advreqamount = $(thisid).parent().parent().children('.9').html();
            var advreqdate = $(thisid).parent().parent().children('.10').html();
            var departmentid = $(thisid).parent().parent().children('.11').html();
            var departmentname = $(thisid).parent().parent().children('.12').html();
            var departmentcode = $(thisid).parent().parent().children('.13').html();
            var particulars = $(thisid).parent().parent().children('.14').html();
            var totalamount = $(thisid).parent().parent().children('.15').html();
            var sno = $(thisid).parent().parent().children('.16').html();
            var status = $(thisid).parent().parent().children('.17').html();

            document.getElementById('txt_transatondate_app').innerHTML = transatondate;
            document.getElementById('txt_financeyear_app').innerHTML = year;
            document.getElementById('txt_ntrofwork_app').innerHTML = natureofworkid;
            document.getElementById('txt_naturename_app').innerHTML = naturename;
            document.getElementById('txt_name_app').innerHTML = name;
            document.getElementById('txt_advreqamount_app').innerHTML = advreqamount;
            document.getElementById('txt_advreqdate_app').innerHTML = advreqdate;
            document.getElementById('txt_departmentcode_app').innerHTML = departmentcode;
            document.getElementById('txt_departmentname_app').innerHTML = departmentname;
            document.getElementById('txt_particulars_app').innerHTML = particulars;
            document.getElementById('txt_totalamount_app').innerHTML = totalamount;
            document.getElementById('txt_sno_app').value = sno;
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">CostCenterCode</th><th scope="col">BudgetCode</th><th scope="col">GRN No.</th><th scope="col">Vendor Code</th><th scope="col">Name</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Item</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col">Rate</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < chequesub_app.length; i++) {
                if (sno == chequesub_app[i].sno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td scope="row" style="display:none" class="1" style="text-align:center;">' + chequesub_app[i].miscellaneous_refno + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + chequesub_app[i].costcenterid + '</th>';
                    results += '<th scope="row" class="2" style="text-align:center;">' + chequesub_app[i].budgectid + '</th>';
                    results += '<th scope="row" class="3" style="text-align:center;">' + chequesub_app[i].grnno + '</th>';
                    results += '<th scope="row" class="4" style="text-align:center;">' + chequesub_app[i].vendorcode + '</th>';
                    results += '<th scope="row" class="5" style="text-align:center;">' + chequesub_app[i].vendorname + '</th>';
                    results += '<th scope="row" class="6" style="text-align:center;">' + chequesub_app[i].billno + '</th>';
                    results += '<th scope="row" class="7" style="text-align:center;">' + chequesub_app[i].billdate + '</th>';
                    results += '<th scope="row" class="8" style="text-align:center;">' + chequesub_app[i].item + '</th>';
                    results += '<th scope="row" class="9" style="text-align:center;">' + chequesub_app[i].description + '</th>';
                    results += '<th scope="row" class="10" style="text-align:center;">' + chequesub_app[i].uom + '</th>';
                    results += '<th scope="row" class="11" style="text-align:center;">' + chequesub_app[i].quantity + '</th>';
                    results += '<th scope="row" class="12" style="text-align:center;">' + chequesub_app[i].rate + '</th>';
                    results += '<th scope="row" class="13" style="text-align:center;">' + chequesub_app[i].amount + '</th>';
                    results += '<th scope="row" class="14" style="text-align:center;">' + chequesub_app[i].remarks + '</th>';
                    results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + chequesub_app[i].sno1 + '" /></td>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
        }
        function save_approvalmiscellaneous_click(msg) {
            var sno = document.getElementById("txt_sno_app").value;
            var btnval = document.getElementById("btn_approve").value;
            var data = { 'op': 'updtae_approvalmiscellaneousbill_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_appmiscellaneousbillentry_click();
                    $('#myModal').modal('hide');
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function save_rejectmiscellaneous_click(msg) {
            var sno = document.getElementById("txt_sno_app").value;
            var btnval = document.getElementById("btn_reject").value;
            var data = { 'op': 'updtae_approvalmiscellaneousbill_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_appmiscellaneousbillentry_click();
                    $('#myModal').modal('hide');
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Miscellaneous Bill<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transations</a></li>
            <li><a href="#">Miscellaneous Bill</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">

            <div>
                <ul class="nav nav-tabs">
                 <li id="id_tab" class="active"><a data-toggle="tab" href="#" onclick="show_entry_details()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Miscellaneous Bill Entry</a></li>
                    <li id="id_tab_Personal" class=""><a data-toggle="tab" href="#" onclick="show_approval_details()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Miscellaneous Bill Approval</a></li>
                </ul>
            </div>

            <div id="div_billentry">
                <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Miscellaneous Bill Entry
                </h3>
            </div>

                <div class="box-body">
                <div id="showlogs" align="center">
                    <table>
                        <tr>
                           
                            <td>
                                <input id="add_Inward" type="button" name="submit" value='Bill Entry ' class="btn btn-primary" />
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
                                    <table id="tbl_leavemanagement">
                                    <tr>
                                <td>
                            
                                <label>
                                    Transaction date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_transatondate" class="form-control" type="date" >
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                            
                                <label>
                                    Financial Year</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_financeyear" class="form-control" >
                                </select>
                            </td>
                            </tr>
                            <tr>
                            <td>
                            
                                <label>
                                    Nature of Work</label>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="txt_ntrofwork" class="form-control" onchange="Getnature();">
                                </select>--%>
                                <input type="text" id="txt_ntrofwork" class="form-control"  placeholder="Enter Nature of work" onchange="Getnature();" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;" >
                                <label>
                                    Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_naturename" class="form-control" type="text"  placeholder="Description"  readonly/>
                                </td>
                            </tr>
                            <tr>
                            <td style="height: 40px;">
                                <label>
                                   Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_name" class="form-control"  placeholder="Enter Name" onchange="employeenamechange();" 
                                />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;" hidden>
                            <label>
                                   Designation</label>
                            </td>
                            <td style="height: 40px;" hidden>
                                <input id="txt_desgnation" class="form-control"  placeholder="Enter Designation" type="text" />
                                </td>
                                <td >
                            <input id="txt_nameid" type="hidden" class="form-control" name="hiddenempid" />
                             </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                  AdvanceRequestNo</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_advreqamount" class="form-control" placeholder="Enter Advance Request No" type="text"   />
                                
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="width: 5px;">
                            <label>
                                   AdvanceRequestDate</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_advreqdate" class="form-control" type="date" />
                                </td>
                                </tr>
                                <tr>
                            <td>
                                <label>
                                  Department Code</label>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="txt_departmentcode" class="form-control" onchange="Getdept();" >
                                </select>--%>
                                <input id="txt_departmentcode" class="form-control"  placeholder="Enter Department Code" onchange="Getdept();" />
                                <input id="txt_departmentcode_sno" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="width: 5px;">
                            <label>
                                   Department Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_departmentname" class="form-control"  placeholder="Department Name" type="text" />
                                </td>
                                </tr>
                                <tr style="display: none;">
                            <td>
                                <label>
                                  Section code & Name</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_sectioncode" class="form-control"  placeholder="Enter Section Code"   />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            </tr>
                            <tr>
                            <td >
                            <label>
                                   Particulars</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_particulars" class="form-control" placeholder="Enter Particulars" type="text" />
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                  Total Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_totalamount" class="form-control" type="text"  placeholder="Enter Total Amount" onkeypress="return isNumber(event)"  />
                                
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                  Status</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_status" class="form-control">
                                    <option value="P">Pending</option>
                                    <option value="A">Approval</option>
                                </select>
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
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Miscellaneous Bill Entry Details
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
                                            <input type="button" class="btn btn-success" id="btn_save" value="Save" onclick="save_miscellaneousbillentry_click();" />
                                            <input type="button" class="btn btn-danger" id="close_id" value="Clear"  />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            </div>

            <div id="div_billapproval" style="display:none">
                <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Miscellaneous Bill Approval Details
                </h3>
            </div>
            <div class="box-body">
                <div id="div_Deptdata">
                </div>
            </div>
            <div id="myModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            &times;</button>
                        <h4 class="modal-title">
                            Miscellaneous Bill Approval Details</h4>
                    </div>
                    <div class="modal-body">
                    <table align="center">
                        <tr>
                                <td>
                            
                                <label>
                                    Transaction date : </label>
                            </td>
                            <td>
                                <label id="txt_transatondate_app"></label>
                            </td>
                            <td>
                                <label>
                                &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp    Financial Year : </label>
                            </td>
                            <td>
                                <label id="txt_financeyear_app" >
                                </label>
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Nature of Work : </label>
                            </td>
                            <td >
                                <label id="txt_ntrofwork_app" >
                                </label>
                            </td>
                            <td  >
                                <label>
                                  &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp  Description : </label>
                            </td>
                            <td>
                                <label id="txt_naturename_app"></label>
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                   Name : </label>
                            </td>
                            <td>
                                <label id="txt_name_app"  />
                                
                            </td>
                                <td >
                            <label id="txt_nameid_app" />
                             </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                  AdvanceRequestNo : </label>
                            </td>
                            <td >
                                <label id="txt_advreqamount_app" />
                                
                            </td>
                            
                            <td >
                            <label>
                                 &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp  AdvanceRequestDate : </label>
                            </td>
                            <td>
                                <label id="txt_advreqdate_app" />
                                </td>
                                </tr>
                                <tr>
                            <td>
                                <label>
                                  Department Code : </label>
                            </td>
                            <td>
                                <label id="txt_departmentcode_app">
                                </label>
                            </td>
                            <td>
                            <label>
                                 &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp  Department Name : </label>
                            </td>
                            <td>
                                <label id="txt_departmentname_app" />
                                </td>
                                </tr>
                                
                            <tr>
                            <td >
                            <label>
                                   Particulars : </label>
                            </td>
                            <td>
                                <label id="txt_particulars_app" />
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                  Total Amount : </label>
                            </td>
                            <td>
                                <label id="txt_totalamount_app" />
                                
                            </td>
                            </tr>
                            <tr>
                            <td >
                              <label id="txt_sno_app"></label>
                                    </td>
                                    </tr>
                            </table>
                            <td colspan="4">
                                <div id="divHeadAcount">
                                </div>
                            </td>
                             <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_approve" type="button" class="btn btn-success" name="submit" value='Approve'
                                    onclick="save_approvalmiscellaneous_click()" />
                                <input id='btn_reject' type="button" class="btn btn-danger" name="Close" value='Reject'
                                    onclick="save_rejectmiscellaneous_click()" />
                            </td>
                        </tr>
                    </table>
                    </div>
                    <div class="modal-footer">
                        <button id="btnaclose" type="button" class="btn btn-default" data-dismiss="modal">
                            Close</button>
                    </div>
                </div>
            </div>
        </div>
        </div>
            </div>
            
         </div>
    </section>
</asp:Content>
