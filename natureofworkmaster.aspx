<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="natureofworkmaster.aspx.cs" Inherits="natureofworkmaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        $("#natureofwork").css("display", "block");
        get_group_ledger();
        get_natureof_work();
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
    function shownaturedetails()
    {
        $("#natureofwork").css("display", "block");
        $("#reason").css("display", "none");
    }
    function showreasondetails()
    {
        $("#natureofwork").css("display", "none");
        $("#reason").css("display", "block");
        get_reason_details();
        get_dept_details();
    }
    var branchname = [];
    function get_group_ledger() {
        var data = { 'op': 'get_group_ledger' };
        var s = function (msg) {
            if (msg) {
                branchname = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].groupshortdesc;
                    empnameList.push(empname);
                }
                $('#txt_glcode').autocomplete({
                    source: empnameList,
                    change: Getbranchname,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function Getbranchname() {
        var empname = document.getElementById('txt_glcode').value;
        for (var i = 0; i < branchname.length; i++) {
            if (empname == branchname[i].groupshortdesc) {
                document.getElementById('txt_glid').value = branchname[i].sno;
                document.getElementById('txt_glname').value = branchname[i].groupcode;
            }
        }
    }
        function save_natureof_work(){
            var shortdesc = document.getElementById('txt_shortdesc').value;
            var longdesc = document.getElementById('txt_longdesc').value;
            var glcode = document.getElementById('txt_glcode').value;
            var glid = document.getElementById('txt_glid').value;
            var glname = document.getElementById('txt_glname').value;   
            var sno = document.getElementById('lbl_sno').value;  
            var btnsave = document.getElementById('btn_save').value;
            if (shortdesc == "") {
                alert("Enter  shortdesc");
                return false;
            }
            if (longdesc == "") {
                alert("Enter  longdesc");
                return false;
            }
            if (glcode == "" || glid == "" || glname == "") {
                alert("Enter  gl code");
                return false;
            }
            var data = { 'op': 'save_natureof_work', 'shortdesc': shortdesc, 'longdesc': longdesc, 'glcode': glcode, 'btnsave': btnsave, 'sno': sno, 'glid': glid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_natureof_work();
                        $('#div_DeptData').show();
                        $('#fillform').show();
                        $('#showlogs').css('display', 'block');
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
            document.getElementById('txt_shortdesc').value = "";
            document.getElementById('txt_longdesc').value = "";
            document.getElementById('txt_glcode').value = "";
            document.getElementById('txt_glid').value = "";
            document.getElementById('txt_glname').value = "";
            document.getElementById('btn_save').value = "save";
        }
        function get_natureof_work() {
            var data = { 'op': 'get_natureof_work' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillnaturedetails(msg);
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
        function fillnaturedetails(msg)
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">shortdescription</th><th scope="col">longdescription</th><th scope="col">glcode</th><th scope="col">groupshortdesc</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getnature(this)" name="submit" class="btn btn-primary" value="Edit" /></td>'; 
                results += '<th  class="1" >' + msg[i].shortdescription + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].longdescription + '</td>';
                results += '<td  style="display:none" data-title="code" class="4">' + msg[i].glcode + '</td>';
                results += '<td data-title="code" class="7">' + msg[i].glid + '</td>';
                results += '<td  class="5">' + msg[i].groupshortdesc + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_natureofwork").html(results);
        }
        function getnature(thisid)
        {
            var shortdescription = $(thisid).parent().parent().children('.1').html();
            var longdescription = $(thisid).parent().parent().children('.2').html();
            var glcode = $(thisid).parent().parent().children('.4').html();
            var groupshortdesc = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.6').html();
            var glid = $(thisid).parent().parent().children('.7').html();

            document.getElementById('txt_shortdesc').value = shortdescription;
            document.getElementById('txt_longdesc').value = longdescription;
            document.getElementById('txt_glcode').value = groupshortdesc;
            document.getElementById('txt_glid').value = glcode;
            document.getElementById('txt_glname').value = glid; 
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }
        //Reason Master
        function save_reason_click()
        {
            var reasoncode = document.getElementById('txt_rscode').value;
            if (reasoncode == "" || reason == "") {
                alert("Enter Reason Code ");
                return false;

            }
            var reason = document.getElementById('txt_reason').value;
            var Department = document.getElementById('txt_depcode').value;
            var deptname = document.getElementById('ddldept').value;
            var section = document.getElementById('ddlsection').value;
            if (Department == "" || deptname == "") {
                alert("Enter Department Code ");
                return false;

            }
            if (section == "") {
                alert("Enter Section");
                return false;

            }
            var sno = document.getElementById('reason_sno').value;
            var btnval = document.getElementById('save_reason').value;
            var data = { 'op': 'save_reason_click', 'reasoncode': reasoncode, 'reason': reason, 'Department': Department, 'section': section, 'btnVal': btnval, 'sno': sno };
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
            document.getElementById('save_reason').value = "Save";
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
            document.getElementById('save_reason').value = "Modify";
            document.getElementById('reason_sno').value = sno;
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
            Nature of Work
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#"> Nature of Work</a></li>
        </ol>
    </section>
<section class="content">
            <div class="box box-info">
             <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="shownaturedetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Nature of Work Master </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showreasondetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Reason Master</a></li>
                </ul>
            </div>
            <div id="natureofwork" style="display:none">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Nature Of Work
                    </h3>
                </div>
                    <div id='fillform'>
                        <table align="center" style="width: 60%;">
                        <tr>
                            <td>
                                <label>
                                   Short Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_shortdesc" type="text" name="CCName" placeholder="Enter Short Description" class="form-control" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                   Long Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_longdesc" type="text" name="CCName" placeholder="Enter Long Description" class="form-control" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                            
                                <label>
                                    GL Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_glcode" class="form-control" onchange="Getbranchname(this);" placeholder="Enter GL Code"/>
                                <input id="txt_glid" class="form-control"  style="display:none;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_glname" class="form-control" type="text"  readonly/>
                                </td>
                            </tr>
                         <tr style="display:none;"><td>
                            <label id="lbl_sno"></label>
                            </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" style="height: 40px;">
                                    <input id="btn_save" type="button" class="btn btn-success" name="submit" value='save'
                                        onclick="save_natureof_work()" />
                                    <input id='btn_close' type="button" class="btn btn-danger" name="Clear" value='Clear'
                                        onclick="forclearall()" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="div_natureofwork"></div>
                    </div>
                    <div id ="reason" style="display:none">
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
                                <input id="ddldeptname" class="form-control" type="text"  readonly/>
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
                                        <input id="save_reason" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_reason_click();">
                                        <input id="close_reason" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_reason();">
                                    </td>
                                    </tr>
                                <tr hidden>
                                    <td>
                                        <label id="reason_sno">
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



