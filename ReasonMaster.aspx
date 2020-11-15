<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="ReasonMaster.aspx.cs" Inherits="ReasonMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function ()
    {
        get_reason_details();
        get_dept_details();

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
    function save_reason_click()
    {
        var reasoncode = document.getElementById('txt_rscode').value;
        if (reasoncode == "") {
            alert("Enter Reason Code ");
            return false;

        }
        var reason = document.getElementById('txt_reason').value;
        if (reason == "") {
            alert("Enter Reason");
            return false;

        }
        var Department = document.getElementById('txt_depcode').value;
        if (Department == "") {
            alert("Enter Department Code ");
            return false;

        }
        var deptname = document.getElementById('ddldept').value;
        var section = document.getElementById('ddlsection').value;
        if (section == "") {
            alert("Select section");
            return false;

        }
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_reason_click', 'reasoncode': reasoncode, 'reason': reason, 'Department': Department,'section':section, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_reason_details();
                    clear_reason();
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
    function clear_reason()
    {
        document.getElementById('txt_rscode').value = "";
        document.getElementById('txt_reason').value = "";
        document.getElementById('ddldept').value = "";
        document.getElementById('ddlsection').selectedIndex = 0;
        document.getElementById('txt_depcode').value = "";
        document.getElementById('ddldeptname').value = "";
        document.getElementById('btn_save').value = "Save";
    }
    function get_reason_details()
    {
        var data = { 'op': 'get_reason_details' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillreasondetails(msg);

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
    function fillreasondetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">ReasonCode</th><th scope="col">Reason</th><th scope="col">Department</th><th scope="col">Section</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td  class="1" >' + msg[i].rcode + '</td>';
            results += '<td data-title="code" class="2">' + msg[i].reason + '</td>';
            results += '<td data-title="code" class="6">' + msg[i].department + '</td>';
            results += '<td style="display:none" data-title="code" class="3">' + msg[i].deptid + '</td>';
            results += '<td data-title="code" class="5">' + msg[i].section + '</td>';
            results += '<td data-title="code" style="display:none" class="7">' + msg[i].section1 + '</td>';
            results += '<td  style="display:none" data-title="code" class="6">' + msg[i].deptname + '</td>';
            results += '<td  style="display:none" data-title="code" class="8">' + msg[i].departmentcode + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_reason").html(results);
    }
    function getme(thisid)
    {
        var rcode = $(thisid).parent().parent().children('.1').html();
        var reason = $(thisid).parent().parent().children('.2').html();
        var dept = $(thisid).parent().parent().children('.6').html();
        var section = $(thisid).parent().parent().children('.7').html();
        var deptname = $(thisid).parent().parent().children('.3').html();
        var departmentcode = $(thisid).parent().parent().children('.8').html();
        var sno = $(thisid).parent().parent().children('.4').html();

        document.getElementById('txt_rscode').value = rcode;
        document.getElementById('txt_reason').value = reason;
        document.getElementById('ddldept').value = dept;
        document.getElementById('ddlsection').value = section;
        document.getElementById('ddlsection').value = section;
        document.getElementById('ddldeptname').value = departmentcode;
        document.getElementById('txt_depcode').value = deptname;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('lbl_sno').value = sno;
    }
    var deptdetails = [];
    function get_dept_details()
    {
        var data = { 'op': 'get_dept_details' };
        var s = function (msg)
        {
            if (msg) {
                deptdetails = msg;
                var deptnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var depname = msg[i].DepartmentName;
                    deptnameList.push(depname);
                }
                $('#ddldept').autocomplete({
                    source: deptnameList,
                    change: getdeptid
                });
            }
        }
        var e = function (x, h, e)
        {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function getdeptid()
    {
        var deptname = document.getElementById('ddldept').value;
        for (var i = 0; i < deptdetails.length; i++) {
            if (deptname == deptdetails[i].DepartmentName) {
                document.getElementById('txt_depcode').value = deptdetails[i].sno;
                document.getElementById('ddldeptname').value = deptdetails[i].DepartmentCode;
            }
        }

    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Reason Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Reason Master</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Reason Master
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_rsn">
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
                                            Reason Code</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_rscode" type="text"  class="form-control" placeholder="Enter  Reason Code" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Reason </label>
                                    </td>
                                    <td>
                                        <textarea rows="3" cols="20" id="txt_reason" class="form-control" maxlength="2000"
                                    placeholder="Enter Reason"></textarea>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                            <td>
                                <label>
                                   Department</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddldept" class="form-control" onchange="Getdeptname();" placeholder="Enter Department"/>
                            <input type="hidden" id="txt_depcode"></input>

                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="ddldeptname" class="form-control" type="text"  placeholder="Department Code" readonly/>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Section</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlsection" class="form-control" >
                                <option value="A">accounts</option>
                                <option value="I">IT</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>

                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_reason_click();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_reason();">
                                    </td>
                                    </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
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

