<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="controltypes.aspx.cs" Inherits="controltypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_control_types();
        get_primary_group();
        get_Dep_Details();
        get_group_ledger();
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
        var primarygrp = [];
        function get_primary_group()
        {
            var data = { 'op': 'get_primary_group' };
            var s = function (msg)
            {
                if (msg) {
                    primarygrp = msg;
                    var primarylist = [];
                    for (var i = 0; i < msg.length; i++) {
                        var primarygroup = msg[i].Shortdescription;
                        primarylist.push(primarygroup);
                    }
                    $('#selct_groupcode').autocomplete({
                        source: primarylist,
                        change:getgrid,
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
         function getgrid(){
        var grcode = document.getElementById('selct_groupcode').value;
        for (var i = 0; i < primarygrp.length; i++) {
            if (grcode == primarygrp[i].Shortdescription) {
                document.getElementById('txt_grid').value = primarygrp[i].sno;
            }
        }

        }
        var deptdetails = [];
        function get_Dep_Details()
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
                    $('#selct_departmentcode').autocomplete({
                        source: deptnameList,
                        change:getdeptid,
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
        function getdeptid(){
        var deptname = document.getElementById('selct_departmentcode').value;
        for (var i = 0; i < deptdetails.length; i++) {
            if (deptname == deptdetails[i].DepartmentName) {
                document.getElementById('txt_depcode').value = deptdetails[i].sno;
            }
        }
        }
        var gldetails = [];
        function get_group_ledger()
        {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg)
            {
                if (msg) {
                    gldetails = msg;
                    var glList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var glname = msg[i].groupcode;
                        glList.push(glname);
                    }
                    $('#selct_glcode').autocomplete({
                        source: glList,
                        change: getglid,
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
        function getglid()
        {
            var glecode = document.getElementById('selct_glcode').value;
            for (var i = 0; i < gldetails.length; i++) {
                if (glecode == gldetails[i].groupcode) {
                    document.getElementById('txt_glid').value = gldetails[i].sno;
                }
            }
        }
        function savecontroltypes() {
            var controltype = document.getElementById('txt_controltype').value;
            var description = document.getElementById('txt_description').value;
            var groupcode = document.getElementById('selct_groupcode').value;
            var grid= document.getElementById('txt_grid').value;
            var glcode = document.getElementById('selct_glcode').value;
            var glid= document.getElementById('txt_glid').value;
            var departmentcode = document.getElementById('selct_departmentcode').value;
            var depid = document.getElementById('txt_depcode').value;
            var name = document.getElementById('txt_name').value;
            var sno = document.getElementById('lbl_sno').value;
            var btnVal = document.getElementById('btn_save').value;
            
            if (controltype == "") {
                alert("Enter  controltype");
                return false;
            }
            if (description == "") {
                alert("Enter  description");
                return false;
            }
            if (glcode == "") {
                alert("Enter  glcode");
                return false;
            }
            if (name == "") {
                alert("Enter  name");
                return false;
            }
            var data = { 'op': 'save_control_types', 'controltype': controltype, 'description': description, 'grid': grid, 'glid': glid, 'depid': depid, 'name': name, 'btnVal': btnVal, 'sno': sno };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_control_types();
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
            document.getElementById('txt_controltype').value = "";
            document.getElementById('txt_description').value = "";
            document.getElementById('selct_groupcode').value = "";
            document.getElementById('selct_glcode').value = "";
            document.getElementById('selct_departmentcode').value = "";
            document.getElementById('txt_name').value = "";
            document.getElementById('btn_save').value = "Save";
            
        }
        function get_control_types() {
            var data = { 'op': 'get_control_types' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcontroltypes(msg);

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
        function fillcontroltypes(msg) {
            var k = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">Sno</th></th><th scope="col">ControlType</th><th scope="col">Description</th><th scope="col">GroupCode</th><th scope="col">GLCode</th><th scope="col">Department</th><th scope="col">Name</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].controltype + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].description + '</td>';
                results += '<td  data-title="brandstatus" class="3">' + msg[i].groupcode + '</td>';
                results += '<td style = "display: none" data-title="brandstatus" class="8">' + msg[i].groupid + '</td>';
                results += '<td data-title="brandstatus" class="4">' + msg[i].glcode + '</td>';
                results += '<td style = "display: none"  data-title="brandstatus" class="9">' + msg[i].glid + '</td>';
                results += '<td style = "display: none" data-title="brandstatus" class="5">' + msg[i].deptcode + '</td>';
                results += '<td data-title="brandstatus" class="10">' + msg[i].DepartmentCode + '</td>';
                results += '<td data-title="brandstatus" class="6">' + msg[i].name + '</td>';
                results += '<td style = "display: none" data-title="brandstatus" class="7">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_CategoryData").html(results);
        }
        function getme(thisid) {
            var controltype = $(thisid).parent().parent().children('.1').html();
            var description = $(thisid).parent().parent().children('.2').html();
            var groupcode = $(thisid).parent().parent().children('.3').html();
            var grid = $(thisid).parent().parent().children('.8').html();
            var glcode = $(thisid).parent().parent().children('.4').html();
            var glid = $(thisid).parent().parent().children('.9').html();
            var deptcode = $(thisid).parent().parent().children('.10').html();
            var depid = $(thisid).parent().parent().children('.5').html();
            var name = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.7').html();

            document.getElementById('txt_controltype').value = controltype;
            document.getElementById('txt_description').value = description;
            document.getElementById('selct_groupcode').value = groupcode;
            document.getElementById('txt_grid').value = grid;
            document.getElementById('selct_glcode').value = glcode;
            document.getElementById('txt_glid').value = glid;
            document.getElementById('selct_departmentcode').value = deptcode;
            document.getElementById('txt_depcode').value = depid;
            document.getElementById('txt_name').value = name;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Control Types
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Control Types</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Control Types
                </h3>
            </div>
            <div class="box-body">
                <div id='fillform'>
                    <table align="center">
                    <tr>
                            <td>
                                <label>
                                    Control Type</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_controltype" type="text" name="CCName" placeholder="Enter Control Type" class="form-control" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_description" type="text" name="CCName" placeholder="Enter Description" class="form-control" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Group Code</label>
                            </td>
                            <td>
                                <input id="selct_groupcode" class="form-control" placeholder="Enter Group Code">
                                </input>
                                  <input id="txt_grid" type="hidden"></input>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    GL Code</label>
                            </td>
                            <td>
                                <input id="selct_glcode" class="form-control" placeholder="Enter GL Code">
                                </input>
                                  <input id="txt_glid" type="hidden"></input>
                            </td>
                        </tr>
                              <tr>
                            <td>
                                <label>
                                    Department</label>
                            </td>
                            <td>
                                <input id="selct_departmentcode" class="form-control" placeholder="Enter Department"> </input>
                                <input id="txt_depcode" type="hidden"></input>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_name" type="text" name="CCName" placeholder="Enter Name" class="form-control" />
                            </td>
                            </tr>
                            <tr style="display: none;">
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                            <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save' onclick="savecontroltypes()"/>
                                    
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear' onclick="forclearall()"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
             <div id="div_CategoryData">
                </div>
        </div>
    </section>
</asp:Content>

