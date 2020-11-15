<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Monthmaster.aspx.cs" Inherits="Monthmaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function ()
    {
        get_month_master();
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
    function save_month_master()
    {
        var monthno = document.getElementById('txt_monthno').value;
        if (monthno == "") {
            alert("Enter monthno ");
            return false;
        }
        var monthname = document.getElementById('txt_month').value;
        if (monthname == "") {
            alert("Select month name ");
            return false;
        }
        var sequenceno = document.getElementById('txt_seqno').value;
        if (sequenceno == "") {
            alert("Select  sequence no");
            return false;
        }
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_month_master', 'monthno': monthno, 'monthname': monthname, 'sequenceno': sequenceno, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_month_master();
                    clear_month();
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
    function clear_month()
    {
        document.getElementById('txt_monthno').value = "";
        document.getElementById('txt_month').value = "";
        document.getElementById('txt_seqno').value = "";
        document.getElementById('btn_save').value = "Save";
    }
    function get_month_master()
    {
        var data = { 'op': 'get_month_master' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillmonthdetails(msg);

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
    function fillmonthdetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">MonthNO</th><th scope="col">MonthName</th><th scope="col">SequenceNo</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td  class="1" >' + msg[i].monthno + '</td>';
            results += '<td data-title="code" class="2">' + msg[i].monthname + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].sequenceno + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_month").html(results);
    }
    function getme(thisid)
    {
        var monthno = $(thisid).parent().parent().children('.1').html();
        var monthname = $(thisid).parent().parent().children('.2').html();
        var sequenceno = $(thisid).parent().parent().children('.3').html();
        var sno = $(thisid).parent().parent().children('.4').html();
        document.getElementById('txt_monthno').value = monthno;
        document.getElementById('txt_month').value = monthname;
        document.getElementById('txt_seqno').value = sequenceno;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('lbl_sno').value = sno;
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Month Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Month Master</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Month Master
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_mnth">
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
                                            Month</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_monthno" type="text"  class="form-control" placeholder="Enter No.of month" onkeypress="return isNumber(event)"/>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                        <input id="txt_month" type="text"  class="form-control" placeholder="Enter Month name" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Sequence No</label>
                                    </td>
                                    <td>
                                          <input id="txt_seqno" type="text"  class="form-control" placeholder="Enter Sequence Number" onkeypress="return isNumber(event)"/>
                                    </td>
                                </tr>
                                <tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_month_master();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                                            onclick="clear_month();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_month">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

