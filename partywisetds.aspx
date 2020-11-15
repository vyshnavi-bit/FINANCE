<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="partywisetds.aspx.cs" Inherits="partywisetds" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_partywisetds_click();
            get_primary_group();
            get_party_master();
            get_group_ledger();
            $('#add_Inward').click(function () {
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
                get_group_ledger();
                get_party_master();
                get_group_ledger();
                GetFixedrows();
                emptytable = [];
                forclearall();
            });

            $('#close_id').click(function () {
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
        function canceldetails() {
            $("#div_CategoryData").show();
            $("#fillform").hide();
            $('#showlogs').show();
            forclearall();
        }
        var branchname = [];
        function get_primary_group() {
            var data = { 'op': 'get_primary_group' };
            var s = function (msg) {
                if (msg) {
                    branchname = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].Shortdescription;
                        empnameList.push(empname);
                    }
                    $('#txt_groupcode').autocomplete({
                        source: empnameList,
                        change: Getgroupcode,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getgroupcode() {
            var empname = document.getElementById('txt_groupcode').value;
            for (var i = 0; i < branchname.length; i++) {
                if (empname == branchname[i].Shortdescription) {
                    document.getElementById('txt_groupid').value = branchname[i].sno;
                    document.getElementById('txt_groupname').value = branchname[i].Longdescription;
                }
            }
        }
        var branchname1 = [];
        function get_party_master() {
            var data = { 'op': 'get_party_master' };
            var s = function (msg) {
                if (msg) {
                    branchname1 = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].party_name;
                        empnameList.push(empname);
                    }
                    $('#txt_partycode').autocomplete({
                        source: empnameList,
                        change: Getpartycode,
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
            var empname = document.getElementById('txt_partycode').value;
            for (var i = 0; i < branchname1.length; i++) {
                if (empname == branchname1[i].party_name) {
                    document.getElementById('txt_partyid').value = branchname1[i].sno;
                    document.getElementById('txt_partyname').value = branchname1[i].party_code;
                }
            }
        }
        var filldescrption1 = [];
        function get_group_ledger() {
            var data = { 'op': 'get_group_ledger' };
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
                var productname = msg[i].groupshortdesc;
                compiledList.push(productname);
            }

            $('.clscode').autocomplete({
                source: compiledList,
                change: test2,
                autoFocus: true
            });
        }
        var emptytable1 = [];
        function test2() {
            var productname = $(this).val();
            var checkflag = true;
            if (emptytable1.indexOf(productname) == -1) {
                for (var i = 0; i < filldescrption1.length; i++) {
                    if (productname == filldescrption1[i].groupshortdesc) {
                        $(this).closest('tr').find('#txt_glid').val(filldescrption1[i].sno);
                        $(this).closest('tr').find('#txt_description').val(filldescrption1[i].groupcode);
                        emptytable1.push(productname);
                    }
                }
            }
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GL Code</th><th scope="col">Description</th><th scope="col">CertificateNumber</th><th scope="col">Percentage</th><th scope="col">ExemptionAmount</th><th scope="col">FromDate</th><th scope="col">ToDate</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 1; i < 10; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txt_glcode" type="text" class="clscode" placeholder= "GL code"  style="width:90px;"  /></td>';
                results += '<td ><input id="txt_description" type="text" class="clsDescription" placeholder= "Description" style="width:90px;"/></td>';
                results += '<td ><input id="txt_certificatenumber" type="text"  placeholder= "Certificate Number" class="form-control"  style="width:140px;"/></td>';
                results += '<td ><input id="txt_percentage" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Percentage" style="width:90px;"/></td>';
                results += '<td ><input id="txt_exemptionamount" type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "ExemptionAmount" style="width:130px;"/></td>';
                results += '<td ><input id="txt_fromdate" type="date"  class="form-control" placeholder= "FromDate"   style="width:150px;"/></td>';
                results += '<td ><input id="txt_todate" type="date"  class="form-control" placeholder= "ToDate" style="width:130px;"/></td>';
                results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:90px;"/></td>';
                results += '<td style="display:none"><input id="txt_glid" type="text"  class="clsDescription" placeholder= "Remarks" style="width:90px;"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function insertrow() {
            DataTable = [];
            get_group_ledger();
            var txtsno = 0;
            glcode = 0;
            description = 0;
            certificatenumber = 0;
            percentage = 0;
            exemptionamount = 0;
            fromdate = 0;
            todate = 0;
            remarks = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                glcode = $(this).find('#txt_glcode').val();
                description = $(this).find('#txt_description').val();
                certificatenumber = $(this).find('#txt_certificatenumber').val();
                percentage = $(this).find('#txt_percentage').val();
                exemptionamount = $(this).find('#txt_exemptionamount').val();
                fromdate = $(this).find('#txt_fromdate').val();
                todate = $(this).find('#txt_todate').val();
                remarks = $(this).find('#txt_remarks').val();
                glid = $(this).find('#txt_glid').val();
                sno = $(this).find('#txt_sno').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                DataTable.push({ Sno: txtsno, glcode: glcode,glid:glid, description: description, certificatenumber: certificatenumber, percentage: percentage, exemptionamount: exemptionamount, fromdate: fromdate, todate: todate, remarks: remarks, hdnproductsno: hdnproductsno });
                rowsno++;
            });
            glcode = 0;
            description = 0;
            certificatenumber = 0;
            percentage = 0;
            exemptionamount = 0;
            fromdate = 0;
            todate = 0;
            remarks = 0;
            hdnproductsno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, glcode: glcode,glid:glid, description: description, certificatenumber: certificatenumber, percentage: percentage, exemptionamount: exemptionamount, fromdate: fromdate, todate: todate, remarks: remarks, hdnproductsno: hdnproductsno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GL Code</th><th scope="col">Description</th><th scope="col">Certificate Number</th><th scope="col">Percentage</th><th scope="col">ExemptionAmount</th><th scope="col">FromDate</th><th scope="col">ToDate</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txt_glcode" type="text" class="clscode" placeholder= "GL code"  style="width:90px;"   value="' + DataTable[i].glcode + '"/></td>';
                results += '<td ><input id="txt_description" type="text" class="clsDescription" placeholder= "Description" style="width:90px;" value="' + DataTable[i].description + '"/></td>';
                results += '<td ><input id="txt_certificatenumber"  type="text"  class="form-control" placeholder= "Certificate Number"  style="width:140px;" value="' + DataTable[i].certificatenumber + '"/></td>';
                results += '<td ><input id="txt_percentage"type="text" onkeypress="return isNumber(event)"  class="form-control" placeholder= "Percentage" style="width:90px;"  value="' + DataTable[i].percentage + '"/></td>';
                results += '<td ><input id="txt_exemptionamount" type="text" onkeypress="return isNumber(event)" class="form-control" placeholder= "ExemptionAmount" style="width:130px;" value="' + DataTable[i].exemptionamount + '"/></td>';
                results += '<td ><input id="txt_fromdate" type="date"  class="form-control" placeholder= "FromDate"   style="width:150px;"  value="' + DataTable[i].fromdate + '"/></td>';
                results += '<td ><input id="txt_todate" type="date"  class="form-control" placeholder= "ToDate"   style="width:150px;"  value="' + DataTable[i].todate + '"/></td>';
                results += '<td ><input id="txt_remarks" type="text"  class="form-control" placeholder= "Remarks" style="width:90px;"  value="' + DataTable[i].remarks + '"/></td>';
                results += '<td style="display:none"><input id="txt_sno" type="text" class="form-control"  style="width:50px;"  value="' + DataTable[i].sno + '"/></td>';
                results += '<td style="display:none" ><input id="hdnproductsno"  type="hidden" class="clsDescription" value="' + DataTable[i].glid + '"/></td>';
                results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" ><input id="hdnproductsno"  type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
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
        function save_partywisetds_click() {
            var groupcode = document.getElementById('txt_groupcode').value;
            if (groupcode == "") {
                alert("Enter  groupcode");
                return false;
            }
            var groupid = document.getElementById('txt_groupid').value;
            var partycode = document.getElementById('txt_partycode').value;
            if (partycode == "") {
                alert("Enter  partycode");
                return false;
            }
            var partyid = document.getElementById('txt_partyid').value;
            var btnval = document.getElementById('btn_save').value;
            var party_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtsno').text();
                var glcode = $(this).find('#txt_glcode').val();
                var certificatenumber = $(this).find('#txt_certificatenumber').val();
                var percentage = $(this).find('#txt_percentage').val();
                var exemptionamount = $(this).find('#txt_exemptionamount').val();
                var fromdate = $(this).find('#txt_fromdate').val();
                var todate = $(this).find('#txt_todate').val();
                var remarks = $(this).find('#txt_remarks').val();
                var sno = $(this).find('#txt_sub_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                var glid = $(this).find('#txt_glid').val();
                if (certificatenumber == "" || certificatenumber == "0") {
                }
                else {
                    party_array.push({ 'glcode': glcode,'glid':glid, 'certificatenumber': certificatenumber, 'percentage': percentage, 'exemptionamount': exemptionamount, 'fromdate': fromdate, 'todate': todate, 'remarks': remarks, 'sno': sno
                    });
                }
            });
            var data = { 'op': 'save_partywisetds_click','groupid':groupid,'partyid':partyid, 'groupcode': groupcode, 'partycode': partycode, 'party_array': party_array, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_partywisetds_click();
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
            document.getElementById('txt_groupcode').value = "";
            document.getElementById('txt_groupname').value = "";
            document.getElementById('txt_partycode').value = "";
            document.getElementById('txt_partyname').value = "";
            document.getElementById('txt_glcode').value = "";
            document.getElementById('txt_certificatenumber').value = "";
            document.getElementById('txt_percentage').value = "";
            document.getElementById('txt_exemptionamount').value = "";
            document.getElementById('txt_fromdate').value = "";
            document.getElementById('txt_todate').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('btn_save').value = "Save";
        }
        var partytds = [];
        function get_partywisetds_click() {
            var data = { 'op': 'get_partywisetds_click' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpartytds_details(msg);

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
        }
        var tdssub = [];
        function fillpartytds_details(msg) {
            get_group_ledger();
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">GroupName</th><th scope="col">PartyName</th><th scope="col">CertificateNumber</th><th scope="col">DateOfEntry</th></tr></thead></tbody>';
            var tds = msg[0].partywisetds;
            tdssub = msg[0].partywisetdssub;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < tds.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getpartytdsentry(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="groupcode" style="display:none;" class="1" >' + tds[i].groupcode + '</td>';
                results += '<td data-title="partytype" style="display:none;" class="2">' + tds[i].partycode + '</td>';
                results += '<td data-title="groupname"  class="12"  >' + tds[i].groupname + '</td>';
                results += '<td data-title="partyname"  class="13" >' + tds[i].partyname + '</td>';
                results += '<td data-title="partytype"  class="7" style="display:none;">' + tds[i].groupid + '</td>';
                results += '<td data-title="partytype"  class="8"style="display:none;">' + tds[i].partyid + '</td>';
                results += '<td data-title="certificateno"  class="4">' + tds[i].certificateno + '</td>';
                results += '<td data-title="certificateno"  class="5">' + tds[i].doe + '</td>';
                results += '<td data-title="doe" style="display:none;"  class="10">' + tds[i].sno + '</td>'; 
                results += '<td data-title="groupname"  class="12" style="display:none;" >' + tds[i].groupname + '</td>';
                results += '<td data-title="groupname"  class="14" style="display:none;" >' + tds[i].longdescription + '</td></tr>';
                //                results += '<td data-title="sno" class="11" style="display:none;">' + tdssub[i].sno + '</td></tr>';
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

            var groupcode = $(thisid).parent().parent().children('.1').html();
            var groupshortdesc = $(thisid).parent().parent().children('.12').html();
            var partycode = $(thisid).parent().parent().children('.2').html();
            var partyshortdesc = $(thisid).parent().parent().children('.13').html();
            var sno = $(thisid).parent().parent().children('.10').html();
            var groupid = $(thisid).parent().parent().children('.7').html();
            var partyid = $(thisid).parent().parent().children('.8').html();
            var longdescription = $(thisid).parent().parent().children('.14').html();

            document.getElementById('txt_groupcode').value = groupshortdesc;
            document.getElementById('txt_groupid').value = groupcode;
            document.getElementById('txt_partyid').value = partycode;
            document.getElementById('txt_groupname').value = longdescription;
            document.getElementById('txt_partyname').value = partyid;
            document.getElementById('txt_partycode').value = partyshortdesc;
            document.getElementById('btn_save').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">GLCode</th><th scope="col">GroupName</th><th scope="col">CertificateNumber</th><th scope="col">Percentage</th><th scope="col">ExemptionAmount</th><th scope="col">FromDate</th><th scope="col">ToDate</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < tdssub.length; i++) {
                if (sno == tdssub[i].sno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td data-title="From"><input id="txt_glcode" class="clscode" name="glcode"  value="' + tdssub[i].glname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_description" class="clsDescription" placeholder= "Description"  value="' + tdssub[i].glid + '"style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  id="txt_certificatenumber" name="certificatenumber" class="form-control" value="' + tdssub[i].certificatenumber + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  id="txt_percentage" onkeypress="return isNumber(event)" class="form-control" name="percentage" value="' + tdssub[i].percentage + '"  style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_exemptionamount" onkeypress="return isNumber(event)" class="form-control" name="exemptionamount"   value="' + tdssub[i].exemptionamount + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_fromdate" type="date"class="form-control"  name="fromdate" value="' + tdssub[i].fromdate + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input id="txt_todate" type="date" class="form-control"  name="todate"  value="' + tdssub[i].todate + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input  id="txt_remarks" name="remarks" class="form-control" value="' + tdssub[i].remarks + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="txt_glid" value="' + tdssub[i].glcode + '"style="width:10%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="form-control" id="txt_sub_sno" name="txt_sub_sno" value="' + tdssub[i].sno + '"style="width:10%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            get_group_ledger();
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
            Party wise TDS Exemption<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Party wise TDS Exemption</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Party wise TDS Exemption
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <table>
                        <tr>
                           
                            <td>
                                <input id="add_Inward" type="button" name="submit" value='TDS Exemption Entry ' class="btn btn-primary" />
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
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupcode" class="form-control" placeholder="Enter group code" onchange="Getgroupcode(this);" >
                                 <input id="txt_groupid" class="form-control" type="text" style="display: none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupname" class="form-control" placeholder="group code" type="text"  readonly/>
                                </td>
                            </tr>
                            <tr>
                            <td>
                            
                                <label>
                                    Party Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partycode" class="form-control" placeholder="Enter party code" onchange="Getpartycode(this);" />
                                <input id="txt_partyid" class="form-control" style="display: none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_partyname" class="form-control" placeholder="party code" type="text"  readonly/>
                                </td>
                            </tr>
                            </table>
                            </div>
                                <br />
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Party wise TDS Exemption Entry
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
                                            <input type="button" class="btn btn-success" id="btn_save" value="Save" onclick="save_partywisetds_click();" />
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
