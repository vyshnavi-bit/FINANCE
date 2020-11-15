<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="subheadofaccounts.aspx.cs" Inherits="subheadofaccounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Js/JTemplate.js?v=3004" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_headofaccount_details();
            get_SubHeadofAccount_details();
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
        function CallHandlerUsingJson(d, s, e) {
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
        function save_SubHeadofAccount_click() {
            var HeadOfAccount = document.getElementById("ddlheadaccounts").value;
            var headid = document.getElementById("txt_head").value;
            var SubHeadofAccount = document.getElementById("txtsubaccount").value;
            var btnval = document.getElementById("btn_save").value;
            var SNo = document.getElementById("txtsno").value;
            var rows = $("#tableCashFormdetails tr:gt(0)");
            var paymententry = new Array();
            $(rows).each(function (i, obj) {
                paymententry.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), SubHeadofAccount: $(this).find('#txtsubaccount').text() });
            });
            var Data = { 'op': 'save_SubHeadofAccount_click', 'btnval': btnval, 'HeadOfAccount': HeadOfAccount, 'SubHeadofAccount': SubHeadofAccount, 'headid': headid, 'SNo': SNo, 'paymententry': paymententry };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_SubHeadofAccount_details();
                    Collectionform = [];
                    $('#divHeadAcount').setTemplateURL('subheadofaccount.htm');
                    $('#divHeadAcount').processTemplate(Collectionform);
                    $("#divHeadAcount").css("display", "none");
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
        }

        var AccountNameDetails = [];
        function get_headofaccount_details() {
            var data = { 'op': 'get_headofaccount_details' };
            var s = function (msg) {
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
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function AccountNamechange() {
            var AccountName = document.getElementById('ddlheadaccounts').value;
            for (var i = 0; i < AccountNameDetails.length; i++) {
                if (AccountName == AccountNameDetails[i].AccountName) {
                    document.getElementById('txt_head').value = AccountNameDetails[i].sno;
                }
            }
        }

        function forclearall() {
            document.getElementById('txtsubaccount').value = "";
            document.getElementById('ddlheadaccounts').value = "";
            document.getElementById('btn_save').value = "Save";
            Collectionform = [];
            $('#divHeadAcount').setTemplateURL('subheadofaccount.htm');
            $('#divHeadAcount').processTemplate(Collectionform);
            $("#divHeadAcount").css("display", "none");
        }


        var Collectionform = [];
        function BtnAddClick() {
            $("#divHeadAcount").css("display", "block");
            var HeadSno = document.getElementById("txt_head").value;
            var HeadOfAccount = document.getElementById("ddlheadaccounts").value;
            var Checkexist = false;
            $('.AccountClass').each(function (i, obj) {
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
                $("#divHeadAcount").html(results);

            }
        }

        function RowDeletingClick(Account) {
            Collectionform = [];
            var HeadOfAccount = "";
            var HeadSno = "";
            var Account = $(Account).closest("tr").find("#txtAccount").text();
            var SubHeadofAccount = "";
            var rows = $("#tableCashFormdetails tr:gt(0)");
            $(rows).each(function (i, obj) {
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
            $("#divHeadAcount").html(results);
        }

        var Collectionform = [];
        function get_SubHeadofAccount_details() {
            var data = { 'op': 'get_SubHeadofAccount_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillheadofaccountdetails(msg);
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
        function fillheadofaccountdetails(msg) {
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

        function getcoln(thisid) {
            var SNo = $(thisid).parent().parent().children('.6').html();
            var headid = $(thisid).parent().parent().children('.3').html();
            var headname = $(thisid).parent().parent().children('.1').html();
            var SubHeadofAccount = $(thisid).parent().parent().children('.2').html();
            document.getElementById('txtsno').value = SNo;
            document.getElementById('ddlheadaccounts').value = headname;
            document.getElementById('txt_head').value = headid;
            document.getElementById('txtsubaccount').value = SubHeadofAccount;
            document.getElementById('btn_save').value = "Modify";
            $("#btn_add").css("display", "none");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Head Of Accounts Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Head Of Accounts Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Head Of Accounts Details
                </h3>
            </div>
            <div class="box-body">
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
                                <input id="txtsubaccount" class="form-control" type="text" />
                            </td>
                            &nbsp&nbsp&nbsp
                            <td style="padding-left: 5px;">
                                <input id="btn_add" type="button" onclick="BtnAddClick();" class="btn btn-success"
                                    name="Add" value='Add' />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div id="divHeadAcount">
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
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="save_SubHeadofAccount_click()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
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
    </section>
</asp:Content>
