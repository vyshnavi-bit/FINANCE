<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Party_Master_Report.aspx.cs" Inherits="Party_Master_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_branchcode_details();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_date').val(today);
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
        var BranchCodeDetails = [];
        function get_branchcode_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    BranchCodeDetails = msg;
                    var BranchCodeList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var code = msg[i].code;
                        BranchCodeList.push(code);
                    }
                    $('#branch_cd').autocomplete({
                        source: BranchCodeList,
                        //change: AccountNamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function btn_party_code_click() {
            var branch_cd = document.getElementById('branch_cd').value;
            if (branch_cd == "") {
                alert("Please select location");
                return false;
            }
            var data = { 'op': 'get_partycode_det', 'branch_cd': branch_cd };
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
            clearAll();
        }
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">PARTY NAME</th><th scope="col">PARTY CODE</th><th scope="col">GL GROUP CODE</th><th scope="col">ADDRESS</th><th scope="col">PINCODE</th><th scope="col">PHONE NO</th><th scope="col">FAX</th><th scope="col">EMAIL</th><th scope="col">STATUS</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="PARTY NAME" class="2">' + msg[i].party_name + '</td>';
                results += '<td data-title="PARTY CODE" class="3">' + msg[i].party_code + '</td>';
                results += '<td data-title="GL GROUP CODE" class="4">' + msg[i].gl_group + '</td>';
                results += '<td data-title="ADDRESS" class="5">' + msg[i].address + '</td>';
                results += '<td data-title="PINCODE" class="6">' + msg[i].pincode + '</td>';
                results += '<td data-title="PHONE NO" class="7">' + msg[i].phoneno + '</td>';
                results += '<td data-title="FAX" class="8">' + msg[i].fax + '</td>';
                results += '<td data-title="EMAIL" class="9">' + msg[i].email + '</td>';
                results += '<td data-title="STATUS" class="10">' + msg[i].status + '</td>';
                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_partycode_det").html(results);
        }
        function clearAll() {
            var msg = [];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">PARTY NAME</th><th scope="col">PARTY CODE</th><th scope="col">GL GROUP CODE</th><th scope="col">ADDRESS</th><th scope="col">PINCODE</th><th scope="col">PHONE NO</th><th scope="col">FAX</th><th scope="col">EMAIL</th><th scope="col">STATUS</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="PARTY NAME" class="2">' + msg[i].party_name + '</td>';
                results += '<td data-title="PARTY CODE" class="3">' + msg[i].party_code + '</td>';
                results += '<td data-title="GL GROUP CODE" class="4">' + msg[i].gl_group + '</td>';
                results += '<td data-title="ADDRESS" class="5">' + msg[i].address + '</td>';
                results += '<td data-title="PINCODE" class="6">' + msg[i].pincode + '</td>';
                results += '<td data-title="PHONE NO" class="7">' + msg[i].phoneno + '</td>';
                results += '<td data-title="FAX" class="8">' + msg[i].fax + '</td>';
                results += '<td data-title="EMAIL" class="9">' + msg[i].email + '</td>';
                results += '<td data-title="STATUS" class="10">' + msg[i].status + '</td>';
                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_partycode_det").html(results);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Party_Master_Details
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Party_Master_Details</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Party_Master_Details
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
                                    <td style="height: 40px;">
                                        <label>
                                            Branch Code</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="branch_cd" type="text" class="form-control" placeholder="Enter Branch Code" />
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td>
                                        <input id="btn_get" type="button" name="get" value="GET" class="btn btn-primary" onclick="btn_party_code_click();" />
                                    </td>
                                </tr>
                                
                                <%--<tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_tax_type_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_tax_type_Details();">
                                    </td>
                                </tr>--%>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_partycode_det">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
</asp:Content>

