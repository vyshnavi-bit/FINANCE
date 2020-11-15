<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="GL_ Location_Groups.aspx.cs" Inherits="GL__Location_Groups" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_glgroup_details();
        forclearall();
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
        function savegroupdetailes() {
            var groupcode = document.getElementById('txt_groupcode').value;
            var shortdes = document.getElementById('txt_shortdes').value;
            var longdesc = document.getElementById('txt_longdesc').value;
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;
            
            if (groupcode == "") {
                alert("Enter  groupcode");
                return false;
            }
            if (shortdes == "") {
                alert("Enter Short Desc");
                return false;
            }
//            if (longdesc == "") {
//                alert("Enter Long Desc");
//                return false;
//            }
            var data = { 'op': 'savegroupdetailes', 'groupcode': groupcode, 'shortdes': shortdes, 'longdesc': longdesc, 'sno' : sno ,  'btnVal': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_glgroup_details();
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
            document.getElementById('txt_groupcode').value = "";
            document.getElementById('txt_shortdes').value = "";
            document.getElementById('txt_longdesc').value = "";
            document.getElementById('btn_save').value = "Save";
        }
        function get_glgroup_details() {
            var data = { 'op': 'get_glgroup_details' };
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
        }
        function filldetails(msg) {
            var k = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Groupcode</th><th scope="col">shortdes</th><th scope="col">Longdesc</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td style="display:none">' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].groupcode + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].shortdes + '</td>';
                   results += '<td data-title="brandstatus" class="3">' + msg[i].longdesc + '</td>';
                   results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
               }
            results += '</table></div>';
            $("#div_CategoryData").html(results);
        }
        function getme(thisid) {
            var groupcode = $(thisid).parent().parent().children('.1').html();
            var shortdes = $(thisid).parent().parent().children('.2').html();
            var longdesc = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.4').html();

            document.getElementById('txt_groupcode').value = groupcode;
            document.getElementById('txt_shortdes').value = shortdes;
            document.getElementById('txt_longdesc').value = longdesc;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            GL Location Groups
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">GL Location Groups</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>GL Location Groups
                </h3>
            </div>
            <div class="box-body">
                <div id='fillform'>
                    <table align="center">
                    <tr>
                            <td>
                                <label>
                                    Group Code</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_groupcode" type="text" name="CCName" placeholder="Enter Group Code" class="form-control"
                                     />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Short Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_shortdes" type="text" name="CCName" placeholder="Enter Short Description" class="form-control"
                                    />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    Long Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_longdesc" type="text" name="CCName" placeholder="Enter Long Description" class="form-control"
                                     />
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
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="savegroupdetailes()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
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

