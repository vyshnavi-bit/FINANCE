<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
 CodeFile="TransactionSubTypesEntry.aspx.cs" Inherits="TransactionSubTypesEntry" %>

 <asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript">
     $(function () {
         get_transaction_type();
         get_group_ledger();
         get_transsub_type();
         $('#div_DeptData').show();
         $('#fillform').show();

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

        function cleardetails() {
            $("#div_DeptData").show();
            $("#fillform").hide();
          
        }
        function get_transaction_type() {
            var data = { 'op': 'get_transaction_type' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filltrans(msg);

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
        function filltrans(msg) {
            var data = document.getElementById('selct_transtype');
            var length = data.options.length;
            document.getElementById('selct_transtype').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Transaction Type";
            opt.value = "Select Transaction Type";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].transactiontype != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].transactiontype;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        var groupshortdesc = [];
        function get_group_ledger() {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillledger(msg);
                        groupshortdesc = msg;

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
        
        function fillledger(msg) {
            var data = document.getElementById('txt_glcode');
            var length = data.options.length;
            document.getElementById('txt_glcode').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select GL Code";
            opt.value = "Select GL Code";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].groupcode != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].groupcode;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function Getbranchname(txt_glcode) {
            var code = document.getElementById('txt_glcode').value;
            for (var i = 0; i < groupshortdesc.length; i++) {
                if (code == groupshortdesc[i].sno) {
                    document.getElementById('txt_bname').value = groupshortdesc[i].groupshortdesc;
                }
            }
        }
        function save_Transaction_SubTypes() {
            var transtype = document.getElementById('selct_transtype').value;
            if (transtype == "") {
                alert("Enter  trans type");
                return false;
            }
            var subtype = document.getElementById('txt_subtype').value;
            var description = document.getElementById('txt_description').value;
            var glcode = document.getElementById('txt_glcode').value;
            if (glcode == "") {
                alert("Enter  gl code");
                return false;
            }
            var bname = document.getElementById('txt_bname').value;   
            var sno = document.getElementById('lbl_sno').value;  
            var btnsave = document.getElementById('btn_save').value;
            if (subtype == "") {
                alert("Enter  subtype");
                return false;
            }
             if (description == "") {
                alert("Enter  description");
                return false;
            }
            var data = { 'op': 'save_Transaction_SubTypes', 'transtype': transtype, 'subtype': subtype, 'description': description,'glcode': glcode, 'btnsave': btnsave,  'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_transsub_type();
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
            document.getElementById('selct_transtype').selectedIndex = 0;
            document.getElementById('txt_subtype').value = "";
            document.getElementById('txt_description').value = "";
            document.getElementById('txt_glcode').selectedIndex = 0;
            document.getElementById('txt_bname').value = "";
            document.getElementById('btn_save').value = "save";


        }
        function get_transsub_type() {
            var data = { 'op': 'get_transsub_type' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldeptdetails(msg);
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
        function filldeptdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">transactiontype</th><th scope="col">subtype</th><th scope="col">description</th><th scope="col">glcode</th><th scope="col">shortdescription</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th style="display:none" scope="row" class="1" style="text-align:center;">' + msg[i].transactiontype + '</th>';
                results += '<td data-title="code" class="7">' + msg[i].transactionid + '</td>';
                results += '<td data-title="code" class="2">' + msg[i].subtype + '</td>';
                results += '<td data-title="code" class="3">' + msg[i].description + '</td>';
                results += '<td style="display:none" data-title="code" class="4">' + msg[i].glcode + '</td>';
                results += '<td data-title="code" class="8">' + msg[i].glid + '</td>';
                results += '<td data-title="code"   class="6">' + msg[i].short_desc + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_department").html(results);
        }
        function getme(thisid) {
            var transactiontype = $(thisid).parent().parent().children('.1').html();
            var subtype = $(thisid).parent().parent().children('.2').html();
            var description = $(thisid).parent().parent().children('.3').html();
            var glcode = $(thisid).parent().parent().children('.4').html();
            var sno = $(thisid).parent().parent().children('.5').html();
            var short_desc = $(thisid).parent().parent().children('.6').html();

            document.getElementById('selct_transtype').value = transactiontype;
            document.getElementById('txt_subtype').value = subtype;
            document.getElementById('txt_description').value = description;
            document.getElementById('txt_glcode').value = glcode;
            document.getElementById('txt_bname').value = short_desc;
            
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }

 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content">
            <div class="box box-info">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Transaction Sub Type Details
                    </h3>
                </div>
                 <div id="div_DeptData">
                    </div>
                    <div id='fillform'>
                        <table align="center" style="width: 60%;">
                        <tr>
                            <td>
                                <label>
                                    Transaction Type</label>
                            </td>
                            <td>
                                <select id="selct_transtype" class="form-control">
                                    <option selected disabled value="Select state">Select Transaction Type</option>
                                </select>
                            </td>
                        </tr>
                        
                            <tr>
                            <td>
                                <label>
                                    Sub Type</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_subtype" type="text" name="CCName" placeholder="Enter Sub Type" class="form-control" />
                            </td>
                            </tr>
                             <tr>
                            <td>
                                <label>
                                    Description</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_description" type="text" name="CCName" placeholder="Enter Sub Type" class="form-control" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    GL Code</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_glcode" class="form-control" onchange="Getbranchname(this);" >
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_bname" class="form-control" type="text"  readonly/>
                                </td>
                        </tr>
                         <tr style="display:none;"><td>
                            <label id="lbl_sno"></label>
                            </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" style="height: 40px;">
                                    <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='save'
                                        onclick="save_Transaction_SubTypes()" />
                                    <input id='btn_close' type="button" class="btn btn-danger" name="Clear" value='Clear'
                                        onclick="forclearall()" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="div_department"></div>
        </section>
</asp:Content>

