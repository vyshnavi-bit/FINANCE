<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Party_Type.aspx.cs" Inherits="Party_Type" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_group_ledger();
            get_party_type_details();
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
                        var glname = msg[i].groupshortdesc;
                        glList.push(glname);
                    }
                    $('#slct_glcode').autocomplete({
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
            var glecode = document.getElementById('slct_glcode').value;
            for (var i = 0; i < gldetails.length; i++) {
                if (glecode == gldetails[i].groupshortdesc) {
                    document.getElementById('txt_glid').value = gldetails[i].sno;
                    document.getElementById('txt_glcode').value = gldetails[i].groupcode;
                }
            }
        }
        function save_party_type_details()
        {
            var ptype = document.getElementById('txt_ptype').value;
            if (ptype == "")
            {
                alert("Please Enter Party Type");
                return false;
            }
            var desc = document.getElementById('txt_des').value;
            var glcodeid = document.getElementById('txt_glid').value;
            var glcodeType = document.getElementById('slct_glcode').value;
            if (desc == "") {
                alert("Enter  description");
                return false;
            }
            if (glcodeType == "") {
                alert("Enter  gl code Type");
                return false;
            }
            var glcode = document.getElementById('txt_glcode').value;
            if (glcode == "") {
                alert("Enter  gl code");
                return false;
            }
            var btn_val = document.getElementById('btn_save').value;
            var data = { 'op': 'save_party_type_details', 'partytype': ptype, 'description': desc, 'glcodeid': glcodeid, 'glcode': glcode, 'btn_val': btn_val };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_party_type_details();
                        clear_party_type_Details();
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


        function get_party_type_details() {
            var data = { 'op': 'get_party_type_details' };
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
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">PARTY_TP</th><th scope="col">SHORT_DESC</th><th scope="col">GL_CODE</th><th scope="col">GROUP_CD</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getparty(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="PARTY_TP"  class="2">' + msg[i].PARTY_TP + '</td>';
                results += '<td data-title="SHORT_DESC" class="3">' + msg[i].SHORT_DESC + '</td>';
                results += '<td data-title="groupcode"  class="6">' + msg[i].groupcode + '</td>';
                results += '<td data-title="groupdesc" class="7">' + msg[i].groupdesc + '</td>';
                results += '<td  style="display:none" data-title="GL_CODE" class="4">' + msg[i].GL_CODE + '</td>';
                results += '<td style="display:none" data-title="GROUP_CD" class="5">' + msg[i].GROUP_CD + '</td>';
            }
            results += '</table></div>';
            $("#div_party_type").html(results);
        }
        function getparty(thisid)
        {
            var PARTY_TP = $(thisid).parent().parent().children('.2').html();
            var glid = $(thisid).parent().parent().children('.4').html();
            var gldesc = $(thisid).parent().parent().children('.7').html();
            var SHORT_DESC = $(thisid).parent().parent().children('.3').html();
            var GL_CODE = $(thisid).parent().parent().children('.6').html();
            var GROUP_CD = $(thisid).parent().parent().children('.5').html();
            
            document.getElementById('txt_ptype').value = PARTY_TP;
            document.getElementById('txt_des').value = SHORT_DESC;
            document.getElementById('slct_glcode').value = gldesc;
            document.getElementById('txt_glcode').value = GL_CODE;
            document.getElementById('txt_glid').value = glid;
            document.getElementById('btn_save').value = "Modify";
            $("#fillform").show();
            $('#showlogs').hide();
        }
        function clear_party_type_Details() {
            document.getElementById('txt_ptype').value = "";
            document.getElementById('txt_des').value = "";
            document.getElementById('slct_glcode').value = "";
            document.getElementById('txt_glcode').value = "";
            document.getElementById('btn_save').value = "Save";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Party Type
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Party type</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Party Type
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
                                            Party Type</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_ptype" type="text" maxlength="45" class="form-control" placeholder="Enter Party Type" /><label
                                            id="Label1" class="errormessage">* Please Enter Party
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
                                        <%--<input id="txt_des" class="form-control" type="text" name="Username" />--%>
                                        <textarea id="txt_des" class="form-control" cols="20" rows="4"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                <td>
                                    <label>
                                        GL Code :</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td >

                                    <input id="slct_glcode" class="form-control"></input>
                                    <input id="txt_glid" type="hidden"></input>
                                </td>
                                    <td style="width:5px">

                                    </td>
                                <td style="height: 40px;">
                                    <input id="txt_glcode" class="form-control" type="text" name="glcode" />
                                </td>
                            </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_party_type_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_party_type_Details();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_party_type">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

