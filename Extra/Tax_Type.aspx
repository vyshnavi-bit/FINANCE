<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Tax_Type.aspx.cs" Inherits="Tax_Type" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            get_tax_type_details();
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
        function save_tax_type_details() {
            var taxtype = document.getElementById('txt_ptype').value;
            if (taxtype == "") {
                alert("Please Enter tax Type");
                return false;
            }
            var desc = document.getElementById('txt_des').value;
            var btn_val = document.getElementById('btn_save').value;
            var sno = document.getElementById('lbl_sno').value; 
            var data = { 'op': 'save_tax_type_details', 'taxtype': taxtype, 'description': desc, 'btn_val': btn_val,'sno':sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_tax_type_details();
                        clear_tax_type_Details();
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


        function get_tax_type_details() {
            var data = { 'op': 'get_tax_type_details' };
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
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">TAX_TYPE</th><th scope="col">DESCRIPTION</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="TAX_TYPE"  class="2">' + msg[i].TAX_TYPE + '</td>';
                results += '<td data-title="DESCRIPTION" class="3">' + msg[i].DESCRIPTION + '</td>';
                //results += '<td data-title="GL_CODE" class="4">' + msg[i].GL_CODE + '</td>';
                //results += '<td data-title="GROUP_CD" class="5">' + msg[i].GROUP_CD + '</td>';
                results += '<td style="display:none" data-title="GROUP_CD" class="5">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</tr></table></div>';
            $("#div_tax_type").html(results);
        }
        function getme(thisid) {
            var TAX_TYPE = $(thisid).parent().parent().children('.2').html();
            var DESCRIPTION = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.5').html();

            document.getElementById('txt_ptype').value = TAX_TYPE;
            document.getElementById('txt_des').value = DESCRIPTION;
            document.getElementById('lbl_sno').value = sno;

            document.getElementById('btn_save').value = "Modify";
            $("#fillform").show();
            $('#showlogs').hide();
        }

        function clear_tax_type_Details() {
            document.getElementById('txt_ptype').value = "";
            document.getElementById('txt_des').value = "";
            document.getElementById('btn_save').value = "Save";
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Tax Type
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Tax type</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Tax Type
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
                                            Tax Type</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_ptype" type="text" maxlength="45" class="form-control" placeholder="Enter Tax Type" /><label
                                            id="Label1" class="errormessage">* Please Enter Tax Type
                                        </label>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Decription</label>
                                    </td>
                                    <td>
                                        <textarea id="txt_des" class="form-control" cols="20" rows="4"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_tax_type_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_tax_type_Details();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_tax_type">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

