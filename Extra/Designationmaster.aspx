<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Designationmaster.aspx.cs" Inherits="Designationmaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript">
     $(function ()
     {
         get_designation_details();
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
        function save_designation_details()
        {

            var DesignationCode = document.getElementById('txt_code').value;
            if (DesignationCode == "") {
                alert("Select DesignationCode ");
                return false;

            }
            var Designation = document.getElementById('txt_desig').value;
            if (Designation == "") {
                alert("Enter Designation ");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_designation_details', 'DesignationCode': DesignationCode, 'Designation': Designation, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_designation_details();
                        clear_desig();
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
        function clear_desig()
        {
            document.getElementById('txt_desig').value= "";
           document.getElementById('txt_code').value = "";
            document.getElementById('btn_save').value = "Save";
        }
        function get_designation_details()
        {
            var data = { 'op': 'get_designation_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldesigdetails(msg);

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
        function filldesigdetails(msg)
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Designation</th><th scope="col">Designation Code</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].designation + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].desigcode + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_designation").html(results);
        }
        function getme(thisid)
        {
            var designation = $(thisid).parent().parent().children('.1').html();
            var desigcode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();

            document.getElementById('txt_desig').value = designation;
            document.getElementById('txt_code').value = desigcode;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }
     
        </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Designation Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Employee Master</a></li>
        </ol>
    </section>
<section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Designation Master
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
                                            Designation</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_desig" type="text"  class="form-control" placeholder="Enter Designation" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Designation Code</label>
                                    </td>
                                    <td>
                                      <input id="txt_code" type="text"  class="form-control" placeholder="Enter Designation code" />
                                       
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_designation_details();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                                            onclick="clear_desig();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_designation">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

