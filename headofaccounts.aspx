<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="headofaccounts.aspx.cs" Inherits="headofaccounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_primary_group();
            get_groupledger();
            get_SubHeadofAccount_details();
            get_subgroupledger();
            $("#divhoc").css("display", "block");
            get_headofaccount_details();
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
        function CallHandlerUsingJson(d, s, e)
        {
            d = JSON.stringify(d);
            d = encodeURIComponent(d);
            $.ajax({
                type: "GET",
                url: " DairyFleet.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function showhocdetails()
        {
            $("#divhoc").css("display", "block");
            $("#subhoc").css("display", "none");
        }
        function showsubhocdetails()
        {
            $("#divhoc").css("display", "none");
            $("#subhoc").css("display", "block");
            get_headofaccount_subdetails();
            get_SubHeadofAccount_details();
        }
        function saveheadofaccountsDetails() {
            var AccountName = document.getElementById('txt_acc').value;
            if (AccountName == "") {
                alert("Enter AccountNumber ");
                return false;
            }
            var Accountcode = document.getElementById('account_code').value;
            var Limit = document.getElementById('txt_Limit').value;
            if (Accountcode == "") {
                alert("Enter Accountcode ");
                return false;
            }
            var primarygroup = document.getElementById('slct_pgroup').value;
            var groupledger = document.getElementById('ddl_gledger').value;
            var subgroupledger = document.getElementById('sub_ledger').value;
            var btnval = document.getElementById('btn_save').value;
            var sno = document.getElementById('lbl_sno').value;
            var data = { 'op': 'saveheadofaccountsDetails','primarygroup':primarygroup, 'groupledger':groupledger,'subgroupledger':subgroupledger,'AccountName': AccountName, 'Accountcode':Accountcode,'Limit': Limit, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        clearall();
                        get_headofaccount_details();
                        $('#fillform').css('display', 'none');
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
        function get_headofaccount_details() {
            var data = { 'op': 'get_headofaccount_details' };
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
              var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
              results += '<thead><tr><th scope="col"></th><th scope="col">Account Name</th><th scope="col">Account Code</th><th scope="col">Limit</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="gethoc(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].AccountName + '</th>';
                results += '<th scope="row" class="2" style="text-align:center;">' + msg[i].accountcode + '</th>';
                results += '<td data-title="code" class="3">' + msg[i].Limit + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].primarygroupid + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].groupledgerid + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].subgroupledger + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
        }
        function gethoc(thisid)
        {
            var AccountName = $(thisid).parent().parent().children('.1').html();
            var accountcode = $(thisid).parent().parent().children('.2').html();
            var Limit = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.4').html();
            var primarygroupid = $(thisid).parent().parent().children('.5').html();
            var groupledgerid = $(thisid).parent().parent().children('.6').html();
            var subgroupledger = $(thisid).parent().parent().children('.7').html();
            document.getElementById('txt_acc').value = AccountName;
            document.getElementById('account_code').value = accountcode;
            document.getElementById('txt_Limit').value = Limit;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;

            document.getElementById('slct_pgroup').value = primarygroupid;
            document.getElementById('ddl_gledger').value = groupledgerid;
            document.getElementById('sub_ledger').value = subgroupledger;
        }
        function clearall()
        {
            document.getElementById('txt_acc').value = "";
            document.getElementById('txt_Limit').value = "";
            document.getElementById('slct_pgroup').selectedIndex = 0;
            document.getElementById('ddl_gledger').selectedIndex = 0;
            document.getElementById('sub_ledger').selectedIndex = 0;
            document.getElementById('account_code').value = "";
            document.getElementById('lbl_sno').innerHTML = 0;
            document.getElementById('btn_save').value = "SAVE";
        }
        var nnamearr = [];
        function get_primary_group()
        {
            var data = { 'op': 'get_primary_group_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        fillgroupdetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e)
            {
            };
            callHandler(data, s, e);
        }
        function fillgroupdetails(msg)
        {
            var data = document.getElementById('slct_pgroup');
            var length = data.options.length;
            document.getElementById('slct_pgroup').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Group Code";
            opt.value = "Select Group Code";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Shortdescription;
                    option.value = msg[i].sno;
                    data.appendChild(option);
            }
        }
        function get_groupledger() {
           // var pgroup = document.getElementById('slct_pgroup').value;
            var data = { 'op': 'get_primarywise_groupledger' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillgroupledger(msg);
                    }
                    else {
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
        function fillgroupledger(msg)
        {
            var data = document.getElementById('ddl_gledger');
            var length = data.options.length;
            document.getElementById('ddl_gledger').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Group Ledger";
            opt.value = "Select Group Ledger";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].groupledgercode;
                    option.value = msg[i].sno;
                    data.appendChild(option);
            }
        }
        function get_subgroupledger()
        {
            //var glcode = document.getElementById('ddl_gledger').value;
            var data = { 'op': 'get_subgroup_ledgercode'};
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsubgroupledger(msg);
                    }
                    else {
                        $('#subglrow').hide();
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
        function fillsubgroupledger(msg)
        {
            var data = document.getElementById('sub_ledger');
            var length = data.options.length;
            document.getElementById('sub_ledger').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Group Ledger";
            opt.value = "Select Group Ledger";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].subgroupcode != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].subgroupcode;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function save_SubHeadofAccount_click()
        {
            var HeadOfAccount = document.getElementById("ddlheadaccounts").value;
            if (HeadOfAccount == "") {
                alert("Enter Head Of Accounts");
                return false;
            }
            var headid = document.getElementById("txt_head").value;
            var SubHeadofAccount = document.getElementById("txtsubaccount").value;
            if (SubHeadofAccount == "") {
                alert("Enter SubAccount");
                return false;
            }
            var btnval = document.getElementById("btn_subhoc").value;
            var SNo = document.getElementById("txtsno").value;
            var rows = $("#tableCashFormdetails tr:gt(0)");
            var paymententry = new Array();
            $(rows).each(function (i, obj)
            {
                paymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), SubHeadofAccount: $(this).find('#txtsubaccount').text() });
            });
            var Data = { 'op': 'save_SubHeadofAccount_click', 'btnval': btnval, 'HeadOfAccount': HeadOfAccount, 'SubHeadofAccount': SubHeadofAccount, 'headid': headid, 'SNo': SNo, 'paymententry': paymententry };
            var s = function (msg)
            {
                if (msg) {
                    alert(msg);
                    get_SubHeadofAccount_details();
                    Collectionform = [];
                    $('#divsubHeadAcount').setTemplateURL('subheadofaccount.htm');
                    $('#divsubHeadAcount').processTemplate(Collectionform);
                    $("#divsubHeadAcount").css("display", "none");
                    forclearall();
                }
            }
            var e = function (x, h, e)
            {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
        }

        var AccountNameDetails = [];
        function get_headofaccount_subdetails()
        {
            var data = { 'op': 'get_headofaccount_details' };
            var s = function (msg)
            {
                if (msg) {
                    AccountNameDetails = msg;
                    var AccountNameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var AccountName = msg[i].AccountName;
                        AccountNameList.push(AccountName);
                    }
                    $('#ddlheadaccounts').autocomplete({
                        source: AccountNameList,
                        change: AccountNamechange,
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
        function AccountNamechange()
        {
            var AccountName = document.getElementById('ddlheadaccounts').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_head').value = AccountNameDetails[i].sno;
                }
            }
        }
        function forclearall()
        {
            document.getElementById('txtsubaccount').value = "";
            document.getElementById('ddlheadaccounts').value = "";
            document.getElementById('btn_subhoc').value = "Save";
            Collectionform = [];
            $('#divsubHeadAcount').setTemplateURL('subheadofaccount.htm');
            $('#divsubHeadAcount').processTemplate(Collectionform);
            $("#divsubHeadAcount").css("display", "none");
        }
        var Collectionform = [];
        function BtnAddClick()
        {
            $("#divsubHeadAcount").css("display", "block");
            var HeadSno = document.getElementById("txt_head").value;
            var HeadOfAccount = document.getElementById("ddlheadaccounts").value;
            var Checkexist = false;
            $('.AccountClass').each(function (i, obj)
            {
                var IName = $(this).text();
                if (IName == HeadOfAccount) {
                    alert("Account Already Added");
                    Checkexist = true;
                }
            });
            if (Checkexist == true) {
                return;
            }
            var SubHeadofAccount = document.getElementById("txtsubaccount").value;
            if (SubHeadofAccount == "") {
                alert("Enter SubHeadofAccount");
                return false;
            }
            else {
                Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, SubHeadofAccount: SubHeadofAccount });
                var results = '<div  style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
                results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">SubHeadofAccount</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < Collectionform.length; i++) {
                    results += '<tr><td></td>';
                    results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
                    results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].SubHeadofAccount + '</b></span></td>';
                    results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                    results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
                    results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
                }
                results += '</table></div>';
                $("#divsubHeadAcount").html(results);

            }
        }
        function RowDeletingClick(Account)
        {
            Collectionform = [];
            var HeadOfAccount = "";
            var HeadSno = "";
            var Account = $(Account).closest("tr").find("#txtAccount").text();
            var SubHeadofAccount = "";
            var rows = $("#tableCashFormdetails tr:gt(0)");
            $(rows).each(function (i, obj)
            {
                if ($(this).find('#txtsubaccount').text() != "") {
                    HeadOfAccount = $(this).find('#txtAccount').text();
                    HeadSno = $(this).find('#HeadSno').val();
                    SubHeadofAccount = $(this).find('#txtsubaccount').text();
                    if (Account == HeadOfAccount) {
                    }
                    else {
                        Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, SubHeadofAccount: SubHeadofAccount });
                    }
                }
            });
            var results = '<div  style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">SubHeadofAccount</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < Collectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].SubHeadofAccount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#divsubHeadAcount").html(results);
        }

        var Collectionform = [];
        function get_SubHeadofAccount_details()
        {
            var data = { 'op': 'get_SubHeadofAccount_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        fillheadofaccountdetails(msg);
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
        function fillheadofaccountdetails(msg)
        {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">HeadOfAccount</th><th scope="col">SubHeadofAccount</th><th scope="col">Date</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getcoln(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].HeadOfAccount + '</th>';
                results += '<td class="2">' + msg[i].SubHeadofAccount + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].headid + '</td>';
                results += '<td class="5">' + msg[i].doe + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].SNo + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_data").html(results);
        }
        function getcoln(thisid)
        {
            var SNo = $(thisid).parent().parent().children('.6').html();
            var headid = $(thisid).parent().parent().children('.3').html();
            var headname = $(thisid).parent().parent().children('.1').html();
            var SubHeadofAccount = $(thisid).parent().parent().children('.2').html();
            document.getElementById('txtsno').value = SNo;
            document.getElementById('ddlheadaccounts').value = headname;
            document.getElementById('txt_head').value = headid;
            document.getElementById('txtsubaccount').value = SubHeadofAccount;
            document.getElementById('btn_subhoc').value = "Modify";
            $("#btn_add").css("display", "none");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="content-header">
        <h1>
            Head Of Accounts Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Head Of Accounts</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showhocdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Head of Accounts</a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showsubhocdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Sub Head of Accounts</a></li>
                </ul>
            </div>
             <div id="divhoc" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Head of Accounts
                    </h3>
                </div>
            <div class="box-body">
                <table align="center">
                    <tr >
                        <td>
                          <label>Primary Group</label>
                        </td>
                        <td style="height: 40px;">
                            <select  id="slct_pgroup" class="form-control"></select>
                        </td>
                    </tr>
                    <tr id="glrow">
                        <td>
                          <label>Group Ledger</label>
                        </td>
                        <td style="height: 40px;">
                          <select  id="ddl_gledger" class="form-control"></select>
                        </td>
                    </tr>
                    <tr id="subglrow">
                        <td>
                          <label>SubGroup Ledger</label>
                        </td>
                        <td style="height: 40px;">
                            <select  id="sub_ledger" class="form-control" ></select>
                        </td>
                    </tr>
                    <tr >
                        <td>
                          <label>AccountName</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" id="txt_acc" class="form-control" placeholder="Enter AccountName" />
                        </td>
                        <td>
                          <label>AccountCode</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" id="account_code" class="form-control" placeholder="Enter AccountCode" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>   Limit</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" id="txt_Limit" class="form-control" placeholder="Enter Limit" />
                        </td>
                    </tr>
                      <tr style="display:none;"><td>
                            <label id="lbl_sno"></label>
                            </td>
                            </tr>
                    <tr>
                        <td>
                        </td>
                        <td style="height: 40px;">
                            <input type="button" id="btn_save" value="Save" class="btn btn-success" Onclick="saveheadofaccountsDetails()"/>
                             <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                        onclick="clearall()" />
                        </td>
                    </tr>
                </table>
                <div id="divHeadAcount" style="height:500px;overflow:auto;">
                </div>
            </div>
        </div>
        <div id="subhoc" style="display:none">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Sub Head Of Accounts
                </h3>
            </div>
            <div>
                <div id="div_Payment">
                </div>
                <div id='fillform'>
                    <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Head of Account
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="ddlheadaccounts" type="text" class="form-control" placeholder="Enter head of accounts" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Sub Account Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtsubaccount" class="form-control" type="text" placeholder="Enter Sub Account"/>
                            </td>
                            &nbsp&nbsp&nbsp
                            <td style="padding-left: 5px;">
                                <input id="btn_add" type="button" onclick="BtnAddClick();" class="btn btn-primary"
                                    name="Add" value='Add' />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div id="divsubHeadAcount">
                                </div>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="txtsno">
                                </label>
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="txt_head">
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_subhoc" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_SubHeadofAccount_click()" />
                                <input id='btn_clear' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
                <div id="div_data">
                </div>
            </div>
        </div>
            </div>
    </section>
</asp:Content>

