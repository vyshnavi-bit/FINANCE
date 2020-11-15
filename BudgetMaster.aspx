<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
CodeFile="BudgetMaster.aspx.cs" Inherits="BudgetMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

<script type="text/javascript">
    $(function ()
    {
        $("#divbudget").css("display", "block");
        get_budget_details();
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
    function showbudgetdetails()
    {
        $("#divbudget").css("display", "block");
        $("#costcenter").css("display", "none");
    }
    function showcostdetails()
    {
        $("#divbudget").css("display", "none");
        $("#costcenter").css("display", "block");
        get_costcenter_details();
    }
    //Budget Master
    function save_budget_code()
    {
        var budgetcode = document.getElementById('txt_budget').value;
        if (budgetcode == "") {
            alert("Enter Budget Code ");
            return false;

        }
        var budgetdesc = document.getElementById('txt_budgetdesc').value;
        if (budgetdesc == "") {
            alert("Enter Budget Description");
            return false;
        }
        var sno = document.getElementById('budget_sno').value;
        var btnval = document.getElementById('save_budget').value;
        var data = { 'op': 'save_budget_code', 'budgetcode': budgetcode, 'budgetdesc': budgetdesc, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                     get_budget_details();
                     clearbudget();
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

    function clearbudget()
    {
        document.getElementById('txt_budget').value = "";
        document.getElementById('txt_budgetdesc').value = "";
        document.getElementById('save_budget').value = "Save";
    }
    function get_budget_details()
    {
        var data = { 'op': 'get_budget_details' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillbudgetdetails(msg);

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
    function fillbudgetdetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Budget Code</th><th scope="col">Budget Description</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getbudget(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td  class="1" >' + msg[i].budgetcode + '</td>';
            results += '<td data-title="code" class="2">' + msg[i].budgetdesc + '</td>';
            results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_budget").html(results);
    }
    function getbudget(thisid)
    {
        var budgetcode = $(thisid).parent().parent().children('.1').html();
        var budgetdesc = $(thisid).parent().parent().children('.2').html();
        var sno = $(thisid).parent().parent().children('.3').html();

        document.getElementById('txt_budget').value = budgetcode;
        document.getElementById('txt_budgetdesc').value = budgetdesc;
        document.getElementById('save_budget').value = "Modify";
        document.getElementById('budget_sno').value = sno;
    }
    //CostCenter Master
    function save_cost_center()
    {
        var costcentercode = document.getElementById('txt_costcode').value;
        if (costcentercode == "") {
            alert("Enter Cost Center Code ");
            return false;

        }
        var costcenterdesc = document.getElementById('txt_ccdesc').value;
        if (costcenterdesc == "") {
            alert("Enter Cost center description ");
            return false;
        }
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_cost_center', 'costcentercode': costcentercode, 'costcenterdesc': costcenterdesc, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_costcenter_details();
                    clear_all();
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
    function clear_all()
    {
        document.getElementById('txt_costcode').value = "";
        document.getElementById('txt_ccdesc').value = "";
        document.getElementById('btn_save').value = "Save";
    }
    function get_costcenter_details()
    {
        var data = { 'op': 'get_costcenter_details' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillcostcenterdetails(msg);

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
    function fillcostcenterdetails(msg)
    {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">CostCenter Code</th><th scope="col">CostCenter Description</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td class="1" >' + msg[i].costcentercode + '</td>';
            results += '<td data-title="code" class="2">' + msg[i].costcenterdescr + '</td>';
            results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_costcenter").html(results);
    }
    function getme(thisid)
    {
        var costcentercode = $(thisid).parent().parent().children('.1').html();
        var costcenterdescr = $(thisid).parent().parent().children('.2').html();
        var sno = $(thisid).parent().parent().children('.3').html();

        document.getElementById('txt_costcode').value = costcentercode;
        document.getElementById('txt_ccdesc').value = costcenterdescr;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('lbl_sno').value = sno;
    }
  </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <section class="content-header">
        <h1>
           Budget Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#"> Budget Master</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showbudgetdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Budget Master</a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showcostdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Cost Center Master</a></li>
                </ul>
            </div>
                <div id="divbudget" style="display:none">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i> Budget Master
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id='budgetform'>
                            <table align="center" style="width: 60%;">
                          <tr>
                                    <td style="height: 40px;">
                                        <label>
                                          Budget Code</label>
                                    </td>
                                    <td>
                                        <input id="txt_budget"  type="text" class="form-control" placeholder= "Enter Budget Code"/>
                                    </td>
                                    </tr>
                                    <tr>
                                    <td style="height: 40px;">
                                        <label>
                                          Budget Description</label>
                                    </td>
                                    <td>
                                         <input id="txt_budgetdesc"  type="text" class="form-control"  placeholder= "Enter Description"/>
                                    </td>
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="save_budget" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_budget_code();">
                                        <input id="clear_budget" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clearbudget();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="budget_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_budget">
                            </div>
                        </div>
                    </div>
                    </div>
                    <div id="costcenter" style="display:none">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i> Cost Center
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id='fillform'>
                            <table align="center" style="width: 60%;">
                          <tr>
                                    <td style="height: 40px;">
                                        <label>
                                          CostCenter Code</label>
                                    </td>
                                    <td>
                                        <input id="txt_costcode"  type="text" class="form-control" placeholder= "Enter CostCenter Code"/>
                                    </td>
                                    </tr>
                                    <tr>
                                    <td style="height: 40px;">
                                        <label>
                                          CostCenter Description</label>
                                    </td>
                                    <td>
                                         <input id="txt_ccdesc"  type="text" class="form-control" placeholder= "Enter Description"/>
                                    </td>
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_cost_center();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_all();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_costcenter">
                            </div>
                        </div>
                    </div>
                    </div>
                    </div>
        </section>
</asp:Content>
