<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CashAdvanceRequisition.aspx.cs" Inherits="CashAdvanceRequisition" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function ()
    {
        get_cashadvance_requisition();
        get_financial_year();
        get_employee_details();
        forclearall();
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
        $('#txt_advreqdate').val(yyyy + '-' + mm + '-' + dd);
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
                document.getElementById('txt_financeyear').value = msg[i].year;
                document.getElementById('finyr_id').value = msg[i].sno;
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
                document.getElementById('txt_designation').value = employeedetails[i].deptname;
            }
        }
    }
    function save_cashadvance_requisition() {
//        var advreqno = document.getElementById('txt_advreqno').value;
//        if (advreqno == "") {
//            alert("Enter Requisition Number");
//            return false;
//        }
        var advreqdate = document.getElementById('txt_advreqdate').value;
        if (advreqdate == "") {
            alert("Enter Date");
            return false;
        }
        var financeyear = document.getElementById('finyr_id').value;
        var name = document.getElementById('txt_name').value;
        if (name == "") {
            alert("Enter name ");
            return false;
        }
        var nameid = document.getElementById('txt_nameid').value;
        var prvadvpndamount = document.getElementById('txt_prvadvpndamount').value;
        var designation = document.getElementById('txt_designation').value;
        var particulars = document.getElementById('txt_particulars').value;
        if (particulars == "") {
            alert("Enter particulars ");
            return false;
        }
        var advreqamount = document.getElementById('txt_advreqamount').value;
        if (advreqamount == "") {
            alert("Enter advreqamount ");
            return false;
        }
        var workponumber = document.getElementById('txt_workponumber').value;
        if (workponumber == "") {
            alert("Enter workponumber ");
            return false;
        }

        var advamountrecomnd = document.getElementById('txt_advamountrecomnd').value;
        if (advamountrecomnd == "") {
            alert("Enter advamountrecomnd ");
            return false;
        }
        var payorder = document.getElementById('txt_payorder').value;
        if (payorder == "") {
            alert("Enter payorder ");
            return false;
        }
        var advreqno = document.getElementById('req_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_cashadvance_requisition','advreqno':advreqno,'advreqdate': advreqdate, 'financeyear': financeyear,'name': name, 'nameid': nameid, 'prvadvpndamount': prvadvpndamount, 'designation': designation,'particulars':particulars, 'advreqamount': advreqamount, 'workponumber': workponumber, 'advamountrecomnd': advamountrecomnd, 'payorder': payorder, 'btnval': btnval
         };
         var s = function (msg) {
             if (msg) {
                 if (msg.length > 0) {
                     alert(msg);
                     forclearall();
                     get_cashadvance_requisition();
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
    function forclearall() {
        document.getElementById('req_sno').value = "";
        document.getElementById('txt_advreqdate').value = "";
        document.getElementById('txt_financeyear').value = "";
        document.getElementById('txt_name').value = "";
        document.getElementById('txt_nameid').value = "";
        document.getElementById('txt_prvadvpndamount').value = "";
        document.getElementById('txt_designation').value = "";
        document.getElementById('txt_particulars').value = "";
        document.getElementById('txt_advreqamount').value = "";
        document.getElementById('txt_workponumber').value = "";
        document.getElementById('txt_advamountrecomnd').value = "";
        document.getElementById('txt_payorder').value = "";
        document.getElementById('btn_save').value = "Save";
    }
    function get_cashadvance_requisition() {
        var data = { 'op': 'get_cashadvance_requisition' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillprimarygroup(msg);

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
    function fillprimarygroup(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">advreqdate</th><th scope="col">financeyear</th><th scope="col">name</th><th scope="col">designation</th><th scope="col">PreviousAdv</th><th scope="col">particulars</th><th scope="col">advreqamount</th><th scope="col">workponumber</th><th scope="col">advamountrecomnd</th><th scope="col">payorder</th></tr></thead></tbody>'; 
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td style="display:none" data-title="code" class="1">' + msg[i].advreqno + '</td>';
            results += '<td data-title="code" class="2">' + msg[i].advreqdate + '</td>';
            results += '<td style="display:none" data-title="code" class="3">' + msg[i].financeyear + '</td>';
            results += '<td data-title="code" class="4">' + msg[i].year + '</td>';
            results += '<td style="display:none" data-title="code" class="17">' + msg[i].nameid + '</td>';
            results += '<td  data-title="code" class="18">' + msg[i].name + '</td>';
            results += '<td style="display:none" data-title="code" class="19">' + msg[i].branchid + '</td>';
            //results += '<td  data-title="code" class="20">' + msg[i].designationcode + '</td>';
            results += '<td  data-title="code" class="21">' + msg[i].designation + '</td>';
            results += '<td  data-title="code" class="27">' + msg[i].prvadvpndamount + '</td>';
            results += '<td  data-title="code" class="22">' + msg[i].particulars + '</td>';
            results += '<td  data-title="code" class="23">' + msg[i].advreqamount + '</td>';
            results += '<td  data-title="code" class="24">' + msg[i].workponumber + '</td>';
            results += '<td  data-title="code" class="25">' + msg[i].advamountrecomnd + '</td>';
            results += '<td  data-title="code" class="26">' + msg[i].payorder + '</td>';
            results += '<td style="display:none" class="28">' + msg[i].doe + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_reason").html(results);
    }
    function getme(thisid) {
        var advreqno = $(thisid).parent().parent().children('.1').html();
        var advreqdate = $(thisid).parent().parent().children('.2').html();
        var financeyear = $(thisid).parent().parent().children('.4').html();
        var name = $(thisid).parent().parent().children('.17').html();
        var nameid = $(thisid).parent().parent().children('.18').html();
        var prvadvpndamount = $(thisid).parent().parent().children('.27').html();
        var designation = $(thisid).parent().parent().children('.21').html();
        var particulars = $(thisid).parent().parent().children('.22').html();
        var advreqamount = $(thisid).parent().parent().children('.23').html();
        var workponumber = $(thisid).parent().parent().children('.24').html();
        var advamountrecomnd = $(thisid).parent().parent().children('.25').html();
        var payorder = $(thisid).parent().parent().children('.26').html();
        var doe = $(thisid).parent().parent().children('.27').html();

        document.getElementById('req_sno').value = advreqno;
        document.getElementById('txt_advreqdate').value = advreqdate;
        document.getElementById('txt_financeyear').value = financeyear;
        document.getElementById('txt_name').value = nameid;
        document.getElementById('txt_nameid').value = name;
        document.getElementById('txt_prvadvpndamount').value = prvadvpndamount;
        //document.getElementById('txt_designationcode').value = designationcode;
        document.getElementById('txt_designation').value = designation;
        document.getElementById('txt_particulars').value = particulars;
        document.getElementById('txt_advreqamount').value = advreqamount;
        document.getElementById('txt_workponumber').value = workponumber;
        document.getElementById('txt_advamountrecomnd').value = advamountrecomnd;
        document.getElementById('txt_payorder').value = payorder;
        document.getElementById('btn_save').value = "Modify";
    }
    function validateEmail(email) {
        var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
        if (reg.test(email)) {
            return true;
        }
        else {
            return false;
        }
    }
    function ValidateAlpha(evt) {
        var keyCode = (evt.which) ? evt.which : evt.keyCode
        if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

            return false;
        return true;
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
            Cash Advance Requisition
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transactions</a></li>
            <li><a href="#">Cash Advance Requisition</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="divcash">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Cash Advance Requisition
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_rsn">
                        </div>
                        <div id='fillform'>
                            <table align="center">
                            <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <%--<td style="height: 40px;" hidden>
                                        <label>
                                            Advance Request Number</label>
                                    </td>

                                    <td style="height: 40px;" hidden>
                                        <input id="txt_advreqno" type="text"  class="form-control" readonly/>
                                    </td>--%>
                                    <td style="height: 40px;">
                                        <label>
                                            Advance Request Date</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_advreqdate" type="date"  class="form-control" />
                                    </td>
                                    <td style="width: 5px;">
                                    </td>
                                    <td style="height: 40px;">
                                        <label>
                                            Financial Year</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_financeyear" type="text"  class="form-control" readonly></input>
                                        <input id="finyr_id" type="hidden"></input>
                                    </td>
                                </tr>
                        <tr>
                            <td>
                                <label>
                                   Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_name" class="form-control" onchange="employeenamechange();"></input>
                            </td>
                            <td >
                            <input id="txt_nameid" type="hidden" class="form-control" name="hiddenempid" />
                             </td>
                             <td style="width: 5px;">
                            <label>
                                   Designation</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_designation" class="form-control" type="text" />
                                </td>
                           
                        </tr>
                        <tr>
                             <td style="width: 5px;">
                            <label>
                                   Previous Adv. Pending Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_prvadvpndamount" class="form-control" type="text" />
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                  Particulars</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_particulars" class="form-control" type="text"  type="text" />
                                
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                  Advance Request Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_advreqamount" class="form-control" type="text"  type="text" onkeypress="return isNumber(event)" />
                                
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                  Work Order/PO Number</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_workponumber" class="form-control" type="text"  type="text" onkeypress="return isNumber(event)" />
                                
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                  Adv. Amount Recommended</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_advamountrecomnd" class="form-control" type="text"  type="text" onkeypress="return isNumber(event)" />
                                
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                  Pay Order for</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_payorder" class="form-control" type="text"  type="text" />
                                
                            </td>
                            </tr>
                            </table>
                            <table align="center">
                            <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_cashadvance_requisition();" />
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="forclearall();" />
                                    </td>
                                    </tr>
                                <tr hidden>
                                    <td>
                                        <label id="req_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_reason">
                            </div>
                        </div>
                    </div>
                    </div>
                </div>
        </section>
</asp:Content>