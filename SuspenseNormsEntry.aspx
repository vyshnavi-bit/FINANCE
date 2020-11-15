<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SuspenseNormsEntry.aspx.cs" Inherits="ImprestNormsEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function ()
    {
        get_designation_details();
        get_suspensenorms_entry();
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
    function save_norms_entry()
    {
        var Designation = document.getElementById('txt_desigcode_sno').value;
        if (Designation == "") {
            alert("Enter Designation");
            return false;

        }
        var Fromdate = document.getElementById('dt_frmdt').value;
        if (Fromdate == "") {
            alert("Enter From Date");
            return false;

        }
        var Todate = document.getElementById('dt_todt').value;
        if (Todate == "") {
            alert("Enter To Date");
            return false;

        }
        var suspenseamount = document.getElementById('txt_spamt').value;
        if (suspenseamount == "") {
            alert("Enter Suspense Amount");
            return false;

        }
        var daystosettle = document.getElementById('txt_dts').value;
        if (daystosettle == "") {
            alert("Enter days to settle");
            return false;

        }
        var particulars = document.getElementById('txt_partic').value;
        if (particulars == "") {
            alert("Enter particulars");
            return false;

        }
        var suspensesettled = document.getElementById('ddl_susp').value;
        if (suspensesettled == "") {
            alert("Select suspense settled");
            return false;

        }
        var sno = document.getElementById('txtsno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_norms_entry', 'Designation': Designation, 'Fromdate': Fromdate, 'Todate': Todate, 'suspenseamount': suspenseamount, 'daystosettle': daystosettle, 'particulars': particulars, 'suspensesettled': suspensesettled, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_suspensenorms_entry();
                    clearnorms();
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
    function clearnorms()
    {
        document.getElementById('txt_desigcode').value = "";
        document.getElementById('txt_desigcode_sno').value = "";
        document.getElementById('txt_desig').value = "";
        document.getElementById('ddl_susp').selectedIndex = 0;
        document.getElementById('dt_frmdt').value = "";
        document.getElementById('txt_partic').value = "";
        document.getElementById('dt_todt').value = "";
        document.getElementById('txt_spamt').value = "";
        document.getElementById('txt_dts').value = "";
        document.getElementById('btn_save').value = "Save";
    }
    var desigarr = [];
    function get_designation_details() {
        var data = { 'op': 'get_designation_details' };
        var s = function (msg) {
            if (msg) {
                desigarr = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var designation = msg[i].designation;
                    empnameList.push(designation);
                }
                $('#txt_desigcode').autocomplete({
                    source: empnameList,
                    change: get_designame,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function get_designame() {
        var designation = document.getElementById('txt_desigcode').value;
        for (var i = 0; i < desigarr.length; i++) {
            if (designation == desigarr[i].designation) {
                document.getElementById('txt_desigcode_sno').value = desigarr[i].sno;
                document.getElementById('txt_desig').value = desigarr[i].desigcode;
            }
        }
    }

    function get_suspensenorms_entry()
    {
        var data = { 'op': 'get_suspensenorms_entry' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillsuspensenorms(msg);

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
    function fillsuspensenorms(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Designation</th><th scope="col">FromDate</th><th scope="col">ToDate</th><th scope="col">SuspenseAmount</th><th scope="col">DaystoSettle</th><th scope="col">Particulars</th><th scope="col">SuspenseSettled</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].designame + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].fromdate + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].todate + '</td>';
            results += '<td data-title="code" class="4">' + msg[i].suspenseamount + '</td>';
            results += '<td data-title="code" class="5">' + msg[i].daystosettle + '</td>';
            results += '<td data-title="code" class="6">' + msg[i].particulars + '</td>';
            results += '<td data-title="code" style="display:none" class="7">' + msg[i].suspensesettled + '</td>';
            results += '<td data-title="code" class="11">' + msg[i].suspense + '</td>';
            results += '<td style="display:none" data-title="code" class="9">' + msg[i].designation + '</td>';
            results += '<td style="display:none" data-title="code" class="10">' + msg[i].desigid + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_normsdata").html(results);
    }
    function getme(thisid)
    {
        var desigid = $(thisid).parent().parent().children('.10').html();
        var designation = $(thisid).parent().parent().children('.1').html();
        var fromdate = $(thisid).parent().parent().children('.2').html();
        var todate = $(thisid).parent().parent().children('.3').html();
        var suspenseamount = $(thisid).parent().parent().children('.4').html();
        var daystosettle = $(thisid).parent().parent().children('.5').html();
        var particulars = $(thisid).parent().parent().children('.6').html();
        var suspensesettled = $(thisid).parent().parent().children('.7').html();
        var sno = $(thisid).parent().parent().children('.8').html();
        var designame = $(thisid).parent().parent().children('.9').html();

        document.getElementById('txt_desigcode').value = designation;
        document.getElementById('txt_desigcode_sno').value = desigid;
        document.getElementById('txt_desig').value = designame;
        document.getElementById('dt_frmdt').value = fromdate;
        document.getElementById('dt_todt').value = todate;
        document.getElementById('txt_spamt').value = suspenseamount;
        document.getElementById('txt_dts').value = daystosettle;
        document.getElementById('txt_partic').value = particulars;
        document.getElementById('ddl_susp').value = suspensesettled;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('txtsno').value = sno;
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
           Suspense Norms<small>Entry</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transactions</a></li>
            <li><a href="#"> Suspense Norms</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Suspense Norms
                </h3>
            </div>
            <div class="box-body">
                <div id="div_imp">
                </div>
                <div id='fillform'>
                    <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Designation</label>
                            </td>
                            <td style="height: 40px;">
                                <%--<select id="slct_desigcode" class="form-control" onchange="get_designame()">
                                </select>--%>
                                <input type="text" id="txt_desigcode" class="form-control" placeholder="Enter Designation" onchange="get_designame()" />
                                <input type="text" id="txt_desigcode_sno" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_desig" readonly class="form-control" placeholder="Designation Code" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    From Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="dt_frmdt" class="form-control" type="date" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    To Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="dt_todt" class="form-control" type="date" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Suspense Amount
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_spamt" type="text" class="form-control" placeholder="Enter Suspense Amount" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Days to Settle
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_dts" class="form-control" type="text" placeholder="Enter No.of days" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Particulars
                                </label>
                            </td>
                            <td>
                                <textarea rows="2" cols="10" id="txt_partic" class="form-control" maxlength="1000"
                                    placeholder="Enter Particulars"></textarea>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Suspense Settled</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddl_susp" class="form-control">
                                    <option value="Y">Yes</option>
                                    <option value="N">NO</option>
                                </select>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="txtsno">
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_norms_entry()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="clearnorms()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
            </div>
            <div id="div_normsdata">
            </div>
        </div>
    </section>
</asp:Content>
