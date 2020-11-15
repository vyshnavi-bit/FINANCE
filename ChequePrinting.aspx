<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ChequePrinting.aspx.cs" Inherits="ChequePrinting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_financial_year();
            get_bank_details();
            get_party_type1_details();
            GetFixedrows();
            emptytable = [];
            $("#divbank").css("display", "block");
            $('#div_inwardtable').show();
            get_chequeprinting_click();
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
        });
        $(function () {
            $('#add_Inward').click(function () {
                get_financial_year();
                get_bank_details();
                get_party_type1_details();
                GetFixedrows();
                emptytable = [];
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
            });
            $('#btn_close').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
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
        function forclearall() {
            $("#div_CategoryData").show();
            $("#fillform").hide();
            $('#showlogs').show();
            forclearall();
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
            var data = document.getElementById('txt_financial');
            var length = data.options.length;
            document.getElementById('txt_financial').options.length = null;
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
        var branchname1 = [];
        function get_bank_details() {
            var data = { 'op': 'get_bank_details' };
            var s = function (msg) {
                if (msg) {
                    branchname1 = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].code;
                        empnameList.push(empname);
                    }
                    $('#txt_bankcode').autocomplete({
                        source: empnameList,
                        change: Getbankcode,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getbankcode() {
            var empname = document.getElementById('txt_bankcode').value;
            for (var i = 0; i < branchname1.length; i++) {
                if (empname == branchname1[i].code) {
                    document.getElementById('txt_bankid').value = branchname1[i].sno;
                    document.getElementById('txt_bankname').value = branchname1[i].name;
                }
            }
        }
        var filldescrption1 = [];
        function get_party_type1_details() {
            var data = { 'op': 'get_party_master' };
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
                var productname = msg[i].party_name;
                compiledList1.push(productname);
            }

            $('.clscode').autocomplete({
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
                    if (productname == filldescrption1[i].party_name) {
                        $(this).closest('tr').find('#txt_partyid').val(filldescrption1[i].sno);
                        $(this).closest('tr').find('#txt_partyname').val(filldescrption1[i].party_code);
                        emptytable1.push(productname);
                    }
                }
            }
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Party Name</th><th scope="col">Party Code</th><th scope="col">Remarks</th><th scope="col">Amount</th><th scope="col">ChequeNumber</th><th scope="col">ChequeDate</th></tr></thead></tbody>';
            for (var i = 1; i < 5; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td style="display:none" ><input id="txt_refno"  type="text" class="form-control" placeholder= "Ref. No"  style="width:130px;"  /></td>';
                results += '<td ><input id="txt_partycode" type="text" class="clscode" placeholder= "Party Name" style="width:100px;"/></td>';
                results += '<td ><input id="txt_partyname" type="text"  placeholder= "Party Code" class="clsDescription"  style="width:130px;"/></td>';
                results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:100px;"/></td>';
                results += '<td ><input id="txt_amount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Amount"   style="width:100px;"/></td>';
                results += '<td ><input id="txt_chqno" type="text"  class="form-control" placeholder= "ChequeNo"   style="width:100px;"/></td>';
                results += '<td ><input id="txt_chqdate" type="date"  class="form-control" placeholder= "Chq .date" style="width:150px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="txt_partyid" type="hidden" class="clsDescription" /></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function insertrow() {
            DataTable = [];
            get_party_type1_details();
            var chqno = 0;
            partycode = 0;
            partyname = 0;
            remarks = 0;
            amount = 0;
            chqno = 0;
            chqdate = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                refno = $(this).find('#txt_refno').val();
                partycode = $(this).find('#txt_partycode').val();
                partyname = $(this).find('#txt_partyname').val();
                remarks = $(this).find('#txt_remarks').val();
                amount = $(this).find('#txt_amount').val();
                chqno = $(this).find('#txt_chqno').val();
                chqdate = $(this).find('#txt_chqdate').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                partyid = $(this).find('#txt_partyid').val();
                DataTable.push({ txtsno:txtsno,chqno: chqno, refno: refno,partyid:partyid, partycode: partycode, partyname: partyname, remarks: remarks, amount: amount, chqdate: chqdate, hdnproductsno: hdnproductsno });
                rowsno++;
            });
            refno = 0;
            partycode = 0;
            partyname = 0;
            remarks = 0;
            amount = 0;
            chqno = 0;
            chqdate = 0;
            hdnproductsno = 0;
            var txtsno = parseInt(txtsno) + 1;
            DataTable.push({ txtsno:txtsno,chqno: chqno,partyid:partyid, refno: refno, partycode: partycode, partyname: partyname, remarks: remarks, amount: amount, chqdate: chqdate, hdnproductsno: hdnproductsno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Party Name</th><th scope="col">Party Code</th><th scope="col">Remarks</th><th scope="col">Amount</th><th scope="col">ChequeNumber</th><th scope="col">ChequeDate</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].txtsno + '</td>';
                results += '<td style="display:none" ><input id="txt_refno" type="text"  class="form-control" placeholder= "Ref. No"  style="width:130px;"   value="' + DataTable[i].refno + '"/></td>';
                results += '<td ><input id="txt_partycode" type="text" class="clscode" placeholder= "Party Name" style="width:100px;" value="' + DataTable[i].partycode + '"/></td>';
                results += '<td ><input id="txt_partyname"  type="text"  class="clsDescription" placeholder= "Party Code" style="width:130px;" value="' + DataTable[i].partyname + '"/></td>';
                results += '<td ><input id="txt_remarks"type="text"   class="form-control" placeholder= "Remarks" style="width:100px;"  value="' + DataTable[i].remarks + '"/></td>';
                results += '<td ><input id="txt_amount" type="text" onkeypress="return isNumber(event)" class="form-control" placeholder= "Amount"   style="width:100px;" value="' + DataTable[i].amount + '"/></td>';
                results += '<td ><input id="txt_chqno" type="text"  class="form-control" placeholder= "ChequeNo"   style="width:100px;" value="' + DataTable[i].chqno + '"/></td>';
                results += '<td ><input id="txt_chqdate" type="date"  class="form-control" placeholder= "Chq .date" style="width:150px;"  value="' + DataTable[i].chqdate + '"/></td>';
                results += '<td data-title="Minus"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="txt_partyid" type="hidden" class="clsDescription" value="' + DataTable[i].partyid + '" /></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            get_party_type1_details();
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
        
        function save_chequeprinting_click() {
            var financial = document.getElementById('txt_financial').value;
            var voucher = document.getElementById('txt_voucher').value;
            var bankcode = document.getElementById('txt_bankcode').value;
            var bankid = document.getElementById('txt_bankid').value;

            var bankname = document.getElementById('txt_bankname').value;
            var chequenumber = document.getElementById('txt_chequenumber').value;
            var sno = document.getElementById('txt_sno').value;
            var btnval = document.getElementById('btn_save').value;
            if (chequenumber == "") {
                alert("Enter Cheque Number ");
                return false;
            }
            if (voucher == "") {
                alert("Enter Voucher");
                return false;
            }
            if (bankcode == "") {
                alert("Enter bankcode ");
                return false;
            }
            var cheq_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var refno = $(this).find('#txt_refno').val();
                var partycode = $(this).find('#txt_partycode').val();
                var partyname = $(this).find('#txt_partyname').val();
                var remarks = $(this).find('#txt_remarks').val();
                var amount = $(this).find('#txt_amount').val();
                var chqno = $(this).find('#txt_chqno').val();
                var chqdate = $(this).find('#txt_chqdate').val();
                var partyid = $(this).find('#txt_partyid').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (amount == "" || amount == "0") {
                }
                else {
                    cheq_array.push({ 'refno': refno,'partyid':partyid, 'partycode': partycode, 'partyname': partyname, 'remarks': remarks, 'amount': amount, 'chqno': chqno, 'chqdate': chqdate, 'hdnproductsno': hdnproductsno
                    });
                }
            });
            var data = { 'op': 'save_chequeprinting_click','bankid':bankid, 'financial': financial, 'voucher': voucher, 'bankcode': bankcode, 'bankname': bankname, 'chequenumber': chequenumber, 'sno': sno, 'btnval': btnval, 'cheq_array': cheq_array };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_chequeprinting_click();
                    $('#vehmaster_fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_inwardtable').show();
                }

            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function get_chequeprinting_click() {
            var data = { 'op': 'get_chequeprinting_click' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcheque_details(msg);
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
        function fillcheque_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">FinancialYear</th><th scope="col">VoucherDate</th><th scope="col">BankCode</th><th scope="col">BankName</th><th scope="col">ChequeNumber</th></tr></thead></tbody>';
            var chq = msg[0].chequeprinting;
            chequesub = msg[0].chequeprintingsub;
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < chq.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getpartytdsentry(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="year"  class="1">' + chq[i].year + '</td>';
                results += '<td data-title="voucher"  class="2">' + chq[i].voucher + '</td>';
                results += '<td data-title="bankcode"  class="3">' + chq[i].bankcode + '</td>';
                results += '<td data-title="bankname"  class="4">' + chq[i].bankname + '</td>';
                results += '<td data-title="chequenumber"  class="6">' + chq[i].chequenumber + '</td>'; 
                //results += '<td data-title="doe" "  class="7">' + chq[i].doe + '</td>';
                results += '<td data-title="financial"  class="9" style="display:none">' + chq[i].financial + '</td>';
                results += '<td data-title="financial"  class="10" style="display:none">' + chq[i].bankid + '</td>';
                results += '<td data-title="sno"  class="8"  style="display:none">' + chq[i].sno + '</td></tr>';
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
            var year  = $(thisid).parent().parent().children('.1').html();
            var voucher = $(thisid).parent().parent().children('.2').html();
            var bankid = $(thisid).parent().parent().children('.10').html();
            var bankcode = $(thisid).parent().parent().children('.3').html();
            var bankname = $(thisid).parent().parent().children('.4').html();
            var chequenumber = $(thisid).parent().parent().children('.6').html();
            var financial = $(thisid).parent().parent().children('.9').html();
            var sno = $(thisid).parent().parent().children('.8').html();

            document.getElementById('txt_financial').value = financial;
            document.getElementById('txt_voucher').value = voucher;
            document.getElementById('txt_bankcode').value = bankcode;
            document.getElementById('txt_bankid').value = bankid;
            document.getElementById('txt_bankname').value = bankname;
            document.getElementById('txt_chequenumber').value = chequenumber;
            document.getElementById('txt_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Party Name</th><th scope="col">Party Code</th><th scope="col">Remarks</th><th scope="col">Amount</th><th scope="col">ChequeNumber</th><th scope="col">ChequeDate</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < chequesub.length; i++) {
                if (sno == chequesub[i].sno) {
                    results += '<tr><td data-title="From" style="display:none" ><input id="txt_refno" style="text-align:center;"  class="form-control" name="glcode"  value="' + chequesub[i].refno + '" style="width:130px;" readonly ></td>';
                    results += '<td data-title="From"><input id="txt_partycode" type="text" class="clscode"  value="' + chequesub[i].partyname + '"style="width:100px;"></td>';
                    results += '<td data-title="From"><input  id="txt_partyname" type="text" class="clsDescription" value="' + chequesub[i].partycode + '"  style="width:130px;"></td>';
                    results += '<td data-title="From"><input  id="txt_remarks" type="text" class="form-control" value="' + chequesub[i].remarks + '"  style="width:100px;"></td>';
                    results += '<td data-title="From"><input id="txt_amount" onkeypress="return isNumber(event)" type="text" class="form-control" value="' + chequesub[i].amount + '"  style="width:100px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_chqno" type="text" class="form-control"   value="' + chequesub[i].chqno + '"  style="width:100px;"></td>';
                    results += '<td data-title="From"><input id="txt_chqdate" type="date" class="form-control"  value="' + chequesub[i].chqdate + '"  style="width:150px;"></input></td>';
                    results += '<td data-title="From"  style="display:none"><input id="txt_partyid" type="text" class="form-control"  value="' + chequesub[i].partycode + '"  style="width:150px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="hdnproductsno" value="' + chequesub[i].sno1 + '"style="width:150px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            get_party_type1_details();
        }
        function forclearall() {
            document.getElementById('txt_financial').value = "";
            document.getElementById('txt_voucher').value = "";
            document.getElementById('txt_bankcode').value = "";
            document.getElementById('txt_bankname').value = "";
            document.getElementById('txt_chequenumber').value = "";
            document.getElementById('btn_save').value = "Save";
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
            Cheque Printing
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Cheque Printing</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Cheque Printing
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <table>
                        <tr>
                           
                            <td>
                                <input id="add_Inward" type="button" name="submit" value='Add Cheque' class="btn btn-primary" />
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
                                    Financial Year</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_financial" class="form-control" >
                                </select>
                            </td>
                            </tr>
                            <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Voucher Date</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_voucher" type="date"  class="form-control"  ></input>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                            <td>
                            
                                <label>
                                    Bank Code </label>
                                    <span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_bankcode" class="form-control" onchange="Getbankcode(this);" placeholder="Enter Bank Code"/>
                               <input id="txt_bankid" class="form-control" style="display: none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_bankname" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Starting Cheque Number</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_chequenumber" type="text"  class="form-control" placeholder="Enter Cheque Number"/>
                                    </td>
                                    <td>
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
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Cheque Printing
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
                                            <input type="button" class="btn btn-success" id="btn_save" value="Save" onclick="save_chequeprinting_click();" />
                                            <input type="button" class="btn btn-danger" id="btn_close" value="Clear" onclick="forclearall();"/>
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
