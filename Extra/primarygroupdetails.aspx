<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="primarygroupdetails.aspx.cs" Inherits="primarygroupdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

<script type="text/javascript">
    $(function ()
    {
        get_primary_group();
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
    function save_primarygroup_details()
    {
        var Groupcode = document.getElementById('txt_gcode').value;
        if (Groupcode == "") {
            alert("Enter Group code ");
            return false;
        }
        var Shortdescription = document.getElementById('txt_desc').value;
        var Longdescription = document.getElementById('txt_longdesc').value;
        var GLtype = document.getElementById('slct_sys').value;
        var Tradingac = get_radio_value();
        var profitloss = get_profit_value();
        var Balancesheet = get_balance_value();
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_primarygroup_details', 'Groupcode': Groupcode, 'Shortdescription': Shortdescription, 'Longdescription': Longdescription, 'GLtype': GLtype, 'Tradingac': Tradingac, 'profitloss': profitloss, 'Balancesheet': Balancesheet, 'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_primary_group();
                    clear_groups();
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
     function get_radio_value() {
         var inputs = document.getElementsByName("selected");
         for (var i = 0; i < inputs.length; i++) {
             if (inputs[i].checked) {
                 return inputs[i].value;
             }
         }
     }
     function get_profit_value()
     {
         var inputs = document.getElementsByName("profit");
         for (var i = 0; i < inputs.length; i++) {
             if (inputs[i].checked) {
                 return inputs[i].value;
             }
         }
     }
     function get_balance_value()
     {
         var inputs = document.getElementsByName("balance");
         for (var i = 0; i < inputs.length; i++) {
             if (inputs[i].checked) {
                 return inputs[i].value;
             }
         }
     }

     function get_primary_group()
     {
         var data = { 'op': 'get_primary_group' };
         var s = function (msg)
         {
             if (msg) {
                 if (msg.length > 0) {
                     fillprimarygroup(msg);

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
     function fillprimarygroup(msg)
     {
         var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
         results += '<thead><tr><th scope="col"></th><th scope="col">GroupCode</th><th scope="col">ShortDescription</th><th scope="col">Longdescription</th><th scope="col">GLtype</th><th scope="col">Tradingac</th><th scope="col">profitloss</th><th scope="col">Balancesheet</th></tr></thead></tbody>';
         for (var i = 0; i < msg.length; i++) {
             results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
             results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].Groupcode + '</th>';
             results += '<td data-title="code" class="2">' + msg[i].Shortdescription + '</td>';
             results += '<td data-title="code" class="3">' + msg[i].Longdescription + '</td>';
             results += '<td data-title="code" class="4">' + msg[i].GLtype + '</td>';
             results += '<td style="display:none" data-title="code" class="9">' + msg[i].GLtype1 + '</td>';
             results += '<td  data-title="code" class="9">' + msg[i].Tradingac + '</td>';
             results += '<td style="display:none" data-title="code" class="5">' + msg[i].Tradingac1 + '</td>';
             results += '<td  data-title="code" class="10">' + msg[i].profitloss + '</td>';
             results += '<td style="display:none" data-title="code" class="6">' + msg[i].profitloss1 + '</td>';
             results += '<td  data-title="code" class="11">' + msg[i].Balancesheet + '</td>';
             results += '<td style="display:none" data-title="code" class="7">' + msg[i].Balancesheet1 + '</td>';
             results += '<td style="display:none" class="8">' + msg[i].sno + '</td></tr>';
         }
         results += '</table></div>';
         $("#div_primarygroup").html(results);
     }
     function getme(thisid) {
         var Groupcode = $(thisid).parent().parent().children('.1').html();
         var Shortdescription = $(thisid).parent().parent().children('.2').html();
         var Longdescription = $(thisid).parent().parent().children('.3').html();
         var GLtype = $(thisid).parent().parent().children('.9').html();
         var Tradingac = $(thisid).parent().parent().children('.5').html();
         var profitloss = $(thisid).parent().parent().children('.6').html();
         var Balancesheet = $(thisid).parent().parent().children('.7').html();
         var sno = $(thisid).parent().parent().children('.8').html();

         document.getElementById('txt_gcode').value = Groupcode;
         document.getElementById('txt_desc').value = Shortdescription;
         document.getElementById('txt_longdesc').value = Longdescription;
         document.getElementById('slct_sys').value = GLtype;
         if (Tradingac == "C") {
             document.getElementById('rdolst_0').checked = true;
         }
         if (Tradingac == "D") {
             document.getElementById('rdolst_1').checked = true;
         }
         if (Tradingac == "N") {
             document.getElementById('rdolst_2').checked = true;
         }
         if (profitloss == "C") {
             document.getElementById('plradio1').checked = true;
         }
         if (profitloss == "D") {
             document.getElementById('plradio2').checked = true;
         }
         if (profitloss == "N") {
             document.getElementById('plradio3').checked = true;
         }
         if (Balancesheet == "C") {
             document.getElementById('bsradio1').checked = true;
         }
         if (Balancesheet == "D") {
             document.getElementById('bsradio2').checked = true;
         }
         if (Balancesheet == "N") {
             document.getElementById('bsradio3').checked = true;
         }
         document.getElementById('btn_save').value = "Modify";
         document.getElementById('lbl_sno').value = sno;
     }
     function clear_groups() {
         document.getElementById('txt_gcode').value = "";
         document.getElementById('slct_sys').selectedIndex = 0;
         document.getElementById('txt_desc').value = "";
         document.getElementById('txt_longdesc').value = "";
         document.getElementById('btn_save').value = "Save";
         document.getElementById('rdolst_0').checked = false;
         document.getElementById('rdolst_1').checked = false;
         document.getElementById('rdolst_2').checked = false;
         document.getElementById('plradio1').checked = false;
         document.getElementById('plradio2').checked = false;
         document.getElementById('plradio3').checked = false;
         document.getElementById('bsradio1').checked = false;
         document.getElementById('bsradio2').checked = false;
         document.getElementById('bsradio3').checked = false;
     }
     
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <section class="content-header">
        <h1>
           Primary Group Details
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Primary Group</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Primary Group
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
                                           Group Code</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_gcode" type="text" class="form-control" placeholder="Enter Group code" />
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
                                        <textarea rows="2" cols="10" id="txt_desc" class="form-control" maxlength="1000"
                                    placeholder="Enter Description"></textarea>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                  <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Long Description</label>
                                    </td>
                                    <td>
                                        <textarea rows="3" cols="20" id="txt_longdesc" class="form-control" maxlength="2000"
                                    placeholder="Enter Description"></textarea>
                                    </td>
                                    <td>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            GL Type</label>
                                    </td>
                                    <td>
                                        <select id="slct_sys"  type="text" >
                                            <option value="A">Assets</option>
                                            <option value="L">Liability</option>
                                            <option value="I">Income</option>
                                            <option value="E">Expenditure</option>
                                         </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Trading Account Grouping</label>
                                            </td>
                                            <td>
                                                <input id="rdolst_0" type="radio" name="selected" value="C" checked="checked" />
                                                Credit
                                                <input id="rdolst_1" type="radio" name="selected" value="D" />
                                                Debit
                                                <input id="rdolst_2" type="radio" name="selected" value="N" />
                                                None
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Profit/Loss Grouping</label>
                                            </td>
                                            <td>
                                                <input id="plradio1" type="radio" name="profit" value="C" checked="checked" />
                                                Credit
                                                <input id="plradio2" type="radio" name="profit" value="D" />
                                                Debit
                                                <input id="plradio3" type="radio" name="profit" value="N" />
                                                None
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Balance Sheet Grouping</label>
                                            </td>
                                            <td>
                                                <input id="bsradio1" type="radio" name="balance" value="C" checked="checked" />
                                                Credit
                                                <input id="bsradio2" type="radio" name="balance" value="D" />
                                                Debit
                                                <input id="bsradio3" type="radio" name="balance" value="N" />
                                                None
                                    </td>
                                </tr>
                                </table>
                                <table>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_primarygroup_details();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                                            onclick="clear_groups();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_primarygroup">
                            </div>
                        </div>
                    </div>
        </section>





</asp:Content>

