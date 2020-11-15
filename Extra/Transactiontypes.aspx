<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Transactiontypes.aspx.cs" Inherits="Transactiontypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function ()
    {
        get_transaction_type();
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
    function save_transaction_type()
    {
        var transactiontype = document.getElementById('txt_tstype').value;
        if (transactiontype == "") {
            alert("Enter Transaction type ");
            return false;

        }
        var shortdescription = document.getElementById('txt_desc').value;
        if (shortdescription == "") {
            alert("Enter  short description");
            return false;
        }
        var system = document.getElementById('slct_sys').value;
        if (system == "") {
            alert("Enter  system");
            return false;
        }
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_transaction_type', 'transactiontype': transactiontype, 'shortdescription': shortdescription, 'system': system,'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_transaction_type();
                    clear_transaction_type();
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
   
    function get_transaction_type()
    {
        var data = { 'op': 'get_transaction_type' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    filltransdetails(msg);

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
        function filltransdetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">TransactionType</th><th scope="col">ShortDescription</th><th scope="col">System</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].transactiontype + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].shortdescription + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].system + '</td>';
            results += '<td  style="display:none" data-title="code" class="5">' + msg[i].system1 + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_transact").html(results);
    }
    function getme(thisid)
    {
        var transactiontype = $(thisid).parent().parent().children('.1').html();
        var shortdescription = $(thisid).parent().parent().children('.2').html();
        var system = $(thisid).parent().parent().children('.5').html();
        var sno = $(thisid).parent().parent().children('.4').html();
        document.getElementById('txt_tstype').value = transactiontype;
        document.getElementById('slct_sys').value = system;
        document.getElementById('txt_desc').value = shortdescription;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('lbl_sno').value = sno;
    }
    function clear_transaction_type() {
        document.getElementById('txt_tstype').value = "";
        document.getElementById('slct_sys').selectedIndex = "";
        document.getElementById('txt_desc').value = "";
        document.getElementById('btn_save').value = "Save";
    }
     
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <section class="content-header">
        <h1>
            Transaction types
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Transaction types</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Transaction types
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_tnsct">
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
                                            Transaction type</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_tstype" type="text" maxlength="45" class="form-control" placeholder="Enter transaction type" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Short Description</label>
                                    </td>
                                    <td>
                                        <textarea rows="3" cols="20" id="txt_desc" class="form-control" maxlength="2000"
                                    placeholder="Enter Description"></textarea>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Manual/System</label>
                                    </td>
                                    <td>
                                        <select id="slct_sys"  type="text">
                                        <option value="M">Manual</option>
                                         <option value="S">System</option>
                                         </select>
                                    </td>
                                </tr>
                                <tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_transaction_type();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                                            onclick="clear_transaction_type();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_transact">
                            </div>
                        </div>
                    </div>
        </section>


</asp:Content>

