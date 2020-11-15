<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="SuspenseBillEntry.aspx.cs" Inherits="SuspenseBillEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function ()
        {
            $("#divsusp").css("display", "block");
            get_financial_year();
            get_suspense_billentry();
            get_suspensecash_requisition();
            GetFixedrows();
            get_suspensesub_details();
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
        function CallHandlerUsingJson(d, s, e)
        {
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
        function isFloat(evt)
        {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            else {
                var parts = evt.srcElement.value.split('.');
                if (parts.length > 1 && charCode == 46)
                    return false;
                return true;
            }
        }
        var reqdata = [];
        function get_suspensecash_requisition()
        {
            var data = { 'op': 'get_suspensecash_requisition' };
            var s = function (msg)
            {
                if (msg) {
                    reqdata = msg;
                    var reqList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var reqno = msg[i].reqno;
                        reqList.push(reqno);
                    }
                    $('#slct_suspreqno').autocomplete({
                        source: reqList,
                        change:get_req_amount,
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
        function get_req_amount()
        {
            var suspno = document.getElementById('slct_suspreqno').value;
            for (var i = 0; i < reqdata.length; i++) {
                if (suspno == reqdata[i].reqno) {
                    document.getElementById('txt_reqamount').value = reqdata[i].reqamount;
                    document.getElementById('dt_reqdate').value = reqdata[i].reqdate;
                    document.getElementById('txt_reqid').value = reqdata[i].sno;
                }
            }
        }
        function get_financial_year()
        {
            var data = { 'op': 'get_financial_year' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        fillfinyeardetails(msg);

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

        function fillfinyeardetails(msg)
        {
            for (var i = 0; i < msg.length; i++) {
//                var year = true;
//               if (msg[i].currentyear == true) {
                 document.getElementById('slct_finyr').value = msg[i].year;
//                }

            }
        }
        function GetFixedrows()
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="suspensetable">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GRN NO</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 1; i < 2; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txt_grnno"  class="clscode2" placeholder="Enter GRN No"  style="width:90px;"/></td>';
                results += '<td ><input id="txt_billno" type="text" class="clsDescription" placeholder="Enter Bill No" style="width:90px;"/></td>';
                results += '<td ><input id="txt_billdate" type="date" class="clsDescription" placeholder="Enter Bill Date"  style="width:90px;" /></td>';
                results += '<td ><input id="txt_amount" type="text" name="Amount" class="Amount" placeholder="Enter Amount" style="width:90px;" onblur="findTotal()"/></td>';
                results += '<td ><input id="txt_remarks" type="text" class="clsDescription" placeholder="Enter Remarks" style="width:90px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name=""></input></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
        }
        var DataTable;
        function insertrow()
        {
            DataTable = [];
            var txtsno = 0;
            grnno = 0;
            billno = 0;
            billdate = 0;
            Amount = 0;
            Remarks = 0;

            var rows = $("#suspensetable tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj)
            {
                txtsno = rowsno;
                grnno = $(this).find('#txt_grnno').val();
                billno = $(this).find('#txt_billno').val();
                billdate = $(this).find('#txt_billdate').val();
                Amount = $(this).find('#txt_amount').val();
                Remarks = $(this).find('#txt_remarks').val();
                sno = $(this).find('#txt_sno').val();
                DataTable.push({ Sno: txtsno,grnno: grnno,billno: billno, billdate: billdate,Remarks: Remarks,Amount:Amount, sno: sno });
                rowsno++;

            });
            grnno = 0;
            name = 0;
            billno = 0;
            billdate = 0;
            Amount = 0;
            Remarks = 0;
            sno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, grnno: grnno, billno: billno, billdate: billdate, Remarks: Remarks, Amount: Amount, sno: sno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="suspensetable">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GRN NO</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr class="total"><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txt_grnno"  class="clscode2" placeholder="Enter GRN No"  style="width:90px;" value="' + DataTable[i].grnno + '"/></td>';
                results += '<td ><input id="txt_billno" type="text" class="clsDescription" placeholder="Enter Bill No" style="width:90px;" value="' + DataTable[i].billno + '"/></td>';
                results += '<td ><input id="txt_billdate" type="date" class="clscode2"   placeholder="Enter Bill Date" style="width:90px;" value="' + DataTable[i].billdate + '"/></td>';
                results += '<td ><input id="txt_amount" type="text" name="Amount" placeholder="Enter Amount" class="Amount" style="width:90px;" value="' + DataTable[i].Amount + '" onblur="findTotal()"/></td>';
                results += '<td ><input id="txt_remarks" type="text" class="clsDescription" placeholder="Enter Remarks" style="width:90px;" value="' + DataTable[i].Remarks + '"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="" value="' + DataTable[i].sno + '" ></input></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
        }
        function removerow(thisid)
        {
            $(thisid).parents('tr').remove();
        }
        function findTotal()
        {
            var arr = document.getElementsByName('Amount');
            var tot = 0;
            for (var i = 0; i < arr.length; i++) {
                if (parseInt(arr[i].value))
                    tot += parseInt(arr[i].value);
            }
            document.getElementById('total').value = tot;
        }
        function calbal()
        {
            var actexp = document.getElementById('txt_actexpenses').value;
            var req = document.getElementById('txt_reqamount').value;
            var bal = actexp - req;
            document.getElementById('txt_balamount').value = bal;
        }
        var employeedetails = [];
        function get_employee_details()
        {
            var data = { 'op': 'get_employee_details' };
            var s = function (msg)
            {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].name;
                        empnameList.push(empname);
                    }
                    $('#slct_empcode').autocomplete({
                        source: empnameList,
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
        function save_suspense_billentry()
        {
            var transactionno = document.getElementById('txt_transno').value;
            if (transactionno == "") {
                alert("Please Enter Transaction No");
                return false;
            }
            var transactiondate = document.getElementById('dt_transdate').value;
            if (transactiondate == "") {
                alert("Please Enter Transaction Date");
                return false;
            }
            var financialyear = document.getElementById('slct_finyr').value;
            if (financialyear == "") {
                alert("Please Enter Financial Year");
                return false;
            }
            var suspreqno = document.getElementById('slct_suspreqno').value;
            if (suspreqno == "") {
                alert("Please Enter Suspense Requisition No");
                return false;
            }
            var suspreqid = document.getElementById('txt_reqid').value;
            if (suspreqid == "") {
                alert("Please Enter Suspense Requisition id");
                return false;
            }
            var reqdate = document.getElementById('dt_reqdate').value;
            if (reqdate == "") {
                alert("Please Enter Requisition Date");
                return false;
            }
            var reqamount = document.getElementById('txt_reqamount').value;
            if (reqamount == "") {
                alert("Please Enter Requisition Amount");
                return false;
            }
            var sectioncode = document.getElementById('txt_sectcode').value;
            if (sectioncode == "") {
                alert("Please Enter Section Code");
                return false;
            }
            var particulars = document.getElementById('txt_particulars').value;
            if (particulars == "") {
                alert("Please Enter Particulars");
                return false;
            }
            var actualexpenses = document.getElementById('txt_actexpenses').value;
            if (actualexpenses == "") {
                alert("Please Enter actual expenses");
                return false;
            }
            var balamount = document.getElementById('txt_balamount').value;
            var totalamount = document.getElementById('total').value;
            var DataTable = [];
            var count = 0;
            var rows = $("#suspensetable tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj)
            {
                grnno = $(this).find('#txt_grnno').val();
                billno = $(this).find('#txt_billno').val();
                billdate = $(this).find('#txt_billdate').val();
                Amount = $(this).find('#txt_amount').val();
                Remarks = $(this).find('#txt_remarks').val();
                sno = $(this).find('#txt_sub_sno').val();
                var billentry ={  grnno: grnno, billno: billno, billdate: billdate,Remarks: Remarks,Amount:Amount, sno: sno };
                if (grnno != "") {
                    DataTable.push(billentry);
                }
            });
            var sno = document.getElementById('txtsno').value;
            var btn_val = document.getElementById('btn_save').value;
            var data = { 'op': 'save_suspense_billentry', 'sno': sno, 'particulars': particulars, 'actualexpenses': actualexpenses, 'suspreqid':suspreqid,'balamount': balamount, 'reqdate': reqdate, 'reqamount': reqamount, 'sectioncode': sectioncode, 'transactionno': transactionno, 'transactiondate': transactiondate, 'financialyear': financialyear,'suspreqno': suspreqno,'totalamount':totalamount, 'DataTable': DataTable, 'btn_val': btn_val };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_suspense_billentry();

                    }
                }
                else {
                }
            };
            var e = function (x, h, e)
            {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(data, s, e);
        }
        function forclearall()
        {
            document.getElementById('txt_transno').value = "";
            document.getElementById('dt_transdate').value = "";
            document.getElementById('slct_finyr').value = "";
            document.getElementById('slct_suspreqno').value = "";
            document.getElementById('dt_reqdate').value = "";
            document.getElementById('txt_reqamount').value = "";
            document.getElementById('txt_sectcode').value = "";
            document.getElementById('txt_particulars').value = "";
            document.getElementById('txt_actexpenses').value = "";
            document.getElementById('txt_balamount').value = "";
            document.getElementById('btn_save').value = "Save";
            document.getElementById('total').value = "";
            GetFixedrows();
//            var empty = [];
//            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="suspensetable">';
//            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GRN NO</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
//            for (var i = 0; i < empty.length; i++) {
//            }
//            results += '</table></div>';
//            $("#div_insert_row").html(results);
        }
        function get_suspense_billentry()
        {
            var data = { 'op': 'get_suspense_billentry' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        fill_suspensebill(msg);
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
        var suspense_sudbetails = [];
        function fill_suspensebill(msg)
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Transaction No</th><th scope="col">Transaction Date</th><th scope="col">Financial Year</th><th scope="col">Req No</th><th scope="col">Req Date</th><th scope="col">Req Amount</th><th scope="col">Section Code</th><th scope="col">Particulars</th><th scope="col">Actual Expenses</th><th scope="col">Balance Amount</th><th scope="col">Total Amount</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            suspensesubentry = msg[0].suspsubentry;
            var billdetails = msg[0].suspbill;
            for (var i = 0; i < billdetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="update(this)"  onclick="update(this)"  name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="transactionno" class="2">' + billdetails[i].transactionno + '</td>';
                results += '<td data-title="transactiondate" class="3">' + billdetails[i].transactiondate + '</td>';
                results += '<td data-title="financialyear" class="4" >' + billdetails[i].financialyear + '</td>';
                results += '<td data-title="suspreqno" class="10" >' + billdetails[i].suspreqno + '</td>';
                results += '<td data-title="reqdate" class="11" >' + billdetails[i].reqdate + '</td>';
                results += '<td data-title="reqamount" class="15" >' + billdetails[i].reqamount + '</td>';
                results += '<td data-title="sectioncode" class="18">' + billdetails[i].sectioncode + '</td>';
                results += '<td data-title="particulars"  class="19">' + billdetails[i].particulars + '</td>';
                results += '<td data-title="actualexpenses" class="20" >' + billdetails[i].actualexpenses + '</td>';
                results += '<td data-title="balamount"  class="22">' + billdetails[i].balamount + '</td>';
                results += '<td data-title="balamount"  class="28">' + billdetails[i].totalamount + '</td>';
               results += '<td data-title="balamount" style="display:none;"  class="23">' + billdetails[i].reqid + '</td>';
                results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + billdetails[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_suspensebill").html(results);
        }
        var sno = 0;
        function update(thisid)
        {
            var transactionno = $(thisid).parent().parent().children('.2').html();
            var transactiondate = $(thisid).parent().parent().children('.3').html();
            var financialyear = $(thisid).parent().parent().children('.4').html();
            var suspreqno = $(thisid).parent().parent().children('.10').html();
            var reqdate = $(thisid).parent().parent().children('.11').html();
            var reqamount = $(thisid).parent().parent().children('.15').html();
            var sectioncode = $(thisid).parent().parent().children('.18').html();
            var particulars = $(thisid).parent().parent().children('.19').html();
            var actualexpenses = $(thisid).parent().parent().children('.20').html();
            var balamount = $(thisid).parent().parent().children('.22').html();
            var totalamount = $(thisid).parent().parent().children('.28').html();
            var sno = $(thisid).parent().parent().children('.14').html();

            document.getElementById('txt_transno').value = transactionno;
            document.getElementById('dt_transdate').value = transactiondate;
            document.getElementById('slct_finyr').value = financialyear;
            document.getElementById('slct_suspreqno').value = suspreqno;
            document.getElementById('dt_reqdate').value = reqdate;
            document.getElementById('txt_reqamount').value = reqamount;
            document.getElementById('txt_sectcode').value = sectioncode;
            document.getElementById('txt_particulars').value = particulars;
            document.getElementById('txt_actexpenses').value = actualexpenses;
            document.getElementById('txt_balamount').value = balamount;
            document.getElementById('total').value = totalamount;
            document.getElementById('txtsno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            var table = document.getElementById("suspensetable");
            var results = '<div  style="overflow:auto;"><table ID="suspensetable" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GRN NO</th><th scope="col">Bill No</th><th scope="col">Bill Date</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < suspensesubentry.length; i++) {
                if (sno == suspensesubentry[i].refno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><input class="price" id="txt_grnno" name="PerUnitRs"  value="' + suspensesubentry[i].grnno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_billno" class="clsdisamt" name="disamt" value="' + suspensesubentry[i].billno + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_billdate"  class="Taxtypecls" name="taxtype"   value="' + suspensesubentry[i].billdate + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<th data-title="From"><input class="6" id="txt_amount"  name="subsno" value="' + suspensesubentry[i].Amount + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<th data-title="From"><input class="6" id="txt_remarks"  name="subsno" value="' + suspensesubentry[i].Remarks + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + suspensesubentry[i].refno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
        }

        function get_suspensesub_details()
        {
            var data = { 'op': 'get_suspensesub_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                    else {
                        var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
                        results += '<thead><tr><th scope="col">TransactionNo</th><th scope="col">Name</th><th scope="col">Total Amount</th><th scope="col">Date</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
                        results += '</table></div>';
                        $("#div_suspdata").html(results);
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
        function filldetails(msg)
        {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Transaction No</th><th scope="col">Transaction Date</th><th scope="col">Financial Year</th><th scope="col">Req No</th><th scope="col">Req Date</th><th scope="col">Req Amount</th><th scope="col">Section Code</th><th scope="col">Particulars</th><th scope="col">Actual Expenses</th><th scope="col">Balance Amount</th><th scope="col">Status</th></tr></thead></tbody>';
            suspsubentry = msg[0].suspsubentry;
            var billdetails = msg[0].suspbill;
            for (var i = 0; i < billdetails.length; i++) {
                results += '<tr>';
                results += '<td data-title="transactionno" class="2">' + billdetails[i].transactionno + '</td>';
                results += '<td data-title="transactiondate" class="3">' + billdetails[i].transactiondate + '</td>';
                results += '<td data-title="financialyear" class="4" >' + billdetails[i].financialyear + '</td>';
                // results += '<td data-title="natureofwork" class="5" >' + billdetails[i].natureofwork + '</td>';
                //results += '<td data-title="designationcode" class="6" >' + billdetails[i].designationcode + '</td>';
                // results += '<td data-title="empcode" class="8" >' + billdetails[i].empcode + '</td>';
                results += '<td data-title="suspreqno" class="10" >' + billdetails[i].suspreqno + '</td>';
                results += '<td data-title="reqdate" class="11" >' + billdetails[i].reqdate + '</td>';
                results += '<td data-title="reqamount" class="15" >' + billdetails[i].reqamount + '</td>';
                //results += '<td data-title="deptcode" class="16" >' + billdetails[i].deptcode + '</td>';
                results += '<td data-title="sectioncode" class="18">' + billdetails[i].sectioncode + '</td>';
                results += '<td data-title="particulars"  class="19">' + billdetails[i].particulars + '</td>';
                results += '<td data-title="actualexpenses" class="20" >' + billdetails[i].actualexpenses + '</td>';
                results += '<td data-title="balamount"  class="22">' + billdetails[i].balamount + '</td>';
                results += '<td data-title="balamount"  class="21">' + billdetails[i].status + '</td>';
                results += '<td><input id="btn_poplate" type="button"  data-toggle="modal" data-target="#myModal" onclick="getme(this)" name="submit" class="btn btn-primary" value="View"/></td>';
                results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + billdetails[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_suspdata").html(results);
        }
        var billsno = 0;
        function getme(thisid)
        {
            var sno = $(thisid).parent().parent().children('.14').html();
            var transactionno = $(thisid).parent().parent().children('.2').html();
            var transactiondate = $(thisid).parent().parent().children('.3').html();
            var reqno = $(thisid).parent().parent().children('.10').html();
            var balamount = $(thisid).parent().parent().children('.7').html();
            document.getElementById('lbl_sno').value = sno;
            billsno = sno;
            var table = document.getElementById("suspensetable");
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            var results = '<div  style="overflow:auto;"><table ID="suspensetable" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GRNNo</th><th scope="col">BillNo</th><th scope="col">BillDate</th><th scope="col">Amount</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < suspsubentry.length; i++) {
                if (sno == suspsubentry[i].refno) {
                    results += '<tr><td data-title="Sno">' + k + '</td>';
                    results += '<td data-title="grnno">' + suspsubentry[i].grnno + '</td>';
                    results += '<td data-title="billno">' + suspsubentry[i].billno + '</td>';
                    results += '<td data-title="billdate">' + suspsubentry[i].billdate + '</td>';
                    // results += '<td data-title="Item">' + suspsubentry[i].Item + '</td>';
                    //results += '<th data-title="Quantity">' + suspsubentry[i].Quantity + '</td>';
                    // results += '<th data-title="Rate">' + suspsubentry[i].Rate + '</span>';
                    results += '<th data-title="Amount">' + suspsubentry[i].Amount + '</span>';
                    results += '<th data-title="Remarks">' + suspsubentry[i].Remarks + '</span>';
                    results += '<th data-title="refno" style="display:none"><span class="7" id="txt_sub_sno" value="' + suspsubentry[i].refno + '"></span></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
        }
        function save_approvalbill_click(msg)
        {
            var sno = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById("btn_approve").value;
            var data = { 'op': 'update_suspensebill_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg)
            {
                if (msg) {
                    alert(msg);
                    get_suspensesub_details();
                    $('#myModal').modal('hide');
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
        function save_rejectbill_click(msg)
        {
            var sno = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById("btn_reject").value;
            var data = { 'op': 'update_suspensebill_click', 'sno': sno, 'btnval': btnval };
            var s = function (msg)
            {
                if (msg) {
                    alert(msg);
                    get_suspensesub_details();
                    $('#myModal').modal('hide');
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
        function showsuspbdetails()
        {
            $("#divsusp").css("display", "block");
            $("#suspApproval").css("display", "none");
        }
        function showbankdetails()
        {
            $("#divsusp").css("display", "none");
            $("#suspApproval").css("display", "block");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Suspense Bill Entry
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Suspense Bill Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
        <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showsuspbdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Suspense Bill Entry </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showbankdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Suspense Bill Approval</a></li>
                </ul>
            </div>
            <div id="divsusp" style="display: none;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Suspense Bill Entry
                </h3>
            </div>
            <div class="box-body">
                <div id="div_SBE">
                </div>
                <div id='fillform'>
                    <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Transaction No</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_transno" class="form-control" type="text" placeholder="Enter Transaction No" onkeypress="return isFloat(event)">
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Transaction Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="dt_transdate" class="form-control" type="date" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Financial Year</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="slct_finyr" class="form-control" type="text" readonly>
                            </td>
                        </tr>
                        <%--<tr>
                            <td>
                                <label>
                                    Nature of Work</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddl_workcode" class="form-control">
                                </select>
                            </td>
                        </tr>--%>
                        <%--<tr>
                            <td>
                                <label>
                                    Designation Code</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_desig" class="form-control">
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>--%>
                       <%-- <tr>
                            <td>
                                <label>
                                    Employee Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="slct_empcode" class="form-control">
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>--%>
                        <tr>
                            <td>
                                <label>
                                    Suspense Req No</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="slct_suspreqno" placeholder="Enter Suspense Requisition No" class="form-control">
                                </input>
                                <input id="txt_reqid" type="hidden"></input>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Req. Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="dt_reqdate" class="form-control" type="date" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Requisition Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_reqamount" class="form-control" readonly type="text" placeholder="Enter Req Amount"  onkeypress="return isFloat(event)"/>
                            </td>
                        </tr>
                        <tr>
                            <%--<td>
                                <label>
                                    Department Code
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_deptcode" class="form-control">
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            </td>--%>
                            <td>
                                <label>
                                    Section Code & Name
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_sectcode" type="text" class="form-control" placeholder="Enter Section Code" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Particulars</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_particulars" class="form-control" type="text" placeholder="Enter Particulars">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Actual Expenses</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_actexpenses" name="Expenses" class="form-control" placeholder="Enter Actual Expenses" type="text" onkeypress="return isFloat(event)" onblur="calbal()">
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Balance Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_balamount" class="form-control" placeholder="Balance Amount" type="text" onkeypress="return isFloat(event)"/>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="txtsno">
                                </label>
                            </td>
                        </tr>
                    </table>
                    <div id="div_insert_row">
                    </div>
                    <table align="center" style="width: 60%;">
                        <tr>
                            <td>
                            </td>
                            <td align="center" style="height: 40px;">
                                <input id="btn_insert" type="button" class="btn btn-primary" name="submit" value="INSERT ROW"
                                    onclick="insertrow()">
                            </td>
                        </tr>
                    </table>
                    <table>
                    <tr>
                    <td>
                    <label>Total Amount</label>
                    </td>
                    <td>
                    <input id="total"  name="TotalAmount" class="form-control" style=" color: Red; font-weight: bold;" readonly/>
                    </td>
                    </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_suspense_billentry()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                </div>
           
            <div id="div_suspensebill">
            </div>
             </div>
        </div>

        <div id="suspApproval" style="display: none;">
         <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Suspense Bill Approval
                </h3>
            </div>
            <div class="box-body">
                <div id="div_suspdata">
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
                            Suspense Bill Details</h4>
                    </div>
                    <div class="modal-body">
                       <table align="center">
                       <tr>
                            <td colspan="2">
                                <div id="divHeadAcount">
                                </div>
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="lbl_sno"></label>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_approve" type="button" class="btn btn-success" name="submit" value='Approve'
                                    onclick="save_approvalbill_click()" />
                                <input id='btn_reject' type="button" class="btn btn-danger" name="Close" value='Reject'
                                    onclick="save_rejectbill_click()" />
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
    </section>
</asp:Content>
