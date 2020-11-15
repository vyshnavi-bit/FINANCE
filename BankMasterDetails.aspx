<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="BankMasterDetails.aspx.cs" Inherits="BankMasterDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#divbank").css("display", "block");
            get_bank_details();
            get_bankifsc_details();
            get_ifsc_details();
            get_branch_details();
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
        function showbankdetails() {
            $("#divbank").css("display", "block");
            $("#divifsc").css("display", "none");
            $("#divBankacc").css("display", "none");
        }
        function showifscdetails() {
            get_bankifsc_details();
            $("#divifsc").css("display", "block");
            $("#divbank").css("display", "none");
            $("#divBankacc").css("display", "none");
        }
        function showBankAccountNodetails() {
            get_bankaccount_details();
            $("#divifsc").css("display", "none");
            $("#divbank").css("display", "none");
            $("#divBankacc").css("display", "block");
        }
        //bankmaster
        function save_bank_click() {
            var BankName = document.getElementById('txt_Bankname').value;
            var bankcode = document.getElementById('txt_bankcode').value;
            var status = document.getElementById('slct_bankstatus').value;
            var cashbookcode = document.getElementById('txt_cashbookcode').value;
            if (BankName == "") {
                alert("Enter BankName ");
                return false;
            }
            if (bankcode == "") {
                alert("Enter Bank Code ");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            //var status = document.getElementById('ddlstatus').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_bank_click', 'BankName': BankName, 'bankcode': bankcode, 'status': status, 'cashbookcode' : cashbookcode, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_bank_details();
                        $('#div_bankData').show();
                        $('#divbank').show();
                        clearbankdetails();
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
        function clearbankdetails() {
            document.getElementById('txt_Bankname').value = "";
            document.getElementById('txt_bankcode').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_save').value = "Save";
            document.getElementById('slct_bankstatus').selectedIndex = 0;
            document.getElementById('txt_cashbookcode').selectedIndex = 0;
        }
        function get_bank_details() {
            var data = { 'op': 'get_bank_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbank(msg);
                        fillddlbank(msg);
                        fillddlacbank(msg);
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
        function fillbank(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">BankName</th><th scope="col">Code</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].name + '</th>';
                results += '<th scope="row" class="2" style="text-align:center;">' + msg[i].code + '</th>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#divbanks").html(results);
        }
        function getme(thisid) {
            var BankName = $(thisid).parent().parent().children('.1').html();
            var code = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            document.getElementById('txt_Bankname').value = BankName;
            document.getElementById('txt_bankcode').value = code;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            $('#div_bankData').show();
            $('#divbank').show();
        }
        function fillddlbank(msg) {
            var data = document.getElementById('selct_BankName');
            var length = data.options.length;
            document.getElementById('selct_BankName').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select BankName";
            opt.value = "Select BankName";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].name != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].name;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function fillddlacbank(msg) {
            var data = document.getElementById('selct_acBankName');
            var length = data.options.length;
            document.getElementById('selct_acBankName').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select BankName";
            opt.value = "Select BankName";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].name != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].name;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function save_BankIfsc_Details() {
            var BankName = document.getElementById('selct_BankName').value;
            var BranchName = document.getElementById('txt_Branchname').value;
            var IFSCCode = document.getElementById('txt_IfscCode').value;
            var status = document.getElementById('slct_ifscstatus').value;
            if (BankName == "") {
                alert("Enter BankName ");
                return false;
            }
            if (BranchName == "") {
                alert("Enter BranchName ");
                return false;
            }
            if (IFSCCode == "") {
                alert("Enter IFSCCode ");
                return false;
            }
            var sno = document.getElementById('lbl_ifscsno').value;
            var btnval = document.getElementById('btnifscsave').value;
            var data = { 'op': 'save_BankIfsc_Details', 'BankName': BankName, 'BranchName': BranchName, 'IFSCCode': IFSCCode, 'status': status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_bankifsc_details();
                        clearifscdetails();
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
            document.getElementById('selct_BankName').value = "";
            document.getElementById('txt_Branchname').value = "";
            document.getElementById('txt_IfscCode').value = "";
            document.getElementById('slct_ifscstatus').selectedIndex = 0;
            document.getElementById('lbl_ifscsno').value = "";
            document.getElementById('btnifscsave').value = "Save";
        }
        function get_bankifsc_details() {
            var data = { 'op': 'get_bankifsc_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillifscdetails(msg);
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
        function fillifscdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Bank Name</th><th scope="col">BranchName</th><th scope="col">IFSCCode</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getifsc(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].bankname + '</th>';
                results += '<td class="2">' + msg[i].branchname + '</td>';
                results += '<td  class="3">' + msg[i].Ifsccode + '</td>';
                results += '<td  style="display:none" class="4">' + msg[i].bank_id + '</td>';
                results += '<td  style="display:none" class="5">' + msg[i].status + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_BankIfscdata").html(results);
        }
        function getifsc(thisid) {
            var bankid = $(thisid).parent().parent().children('.4').html();
            var status = $(thisid).parent().parent().children('.5').html();
            var ifsccode = $(thisid).parent().parent().children('.3').html();
            var branchname = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.6').html();
            document.getElementById('selct_BankName').value = bankid;
            document.getElementById('txt_IfscCode').value = ifsccode;
            document.getElementById('txt_Branchname').value = branchname;
            document.getElementById('slct_ifscstatus').value = status;
            document.getElementById('lbl_ifscsno').value = sno;
            document.getElementById('btnifscsave').value = "Modify";
        }

        function get_ifsc_details() {
            var data = { 'op': 'get_bankifsc_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbankifscdetails(msg);
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
        function fillbankifscdetails(msg) {
            var data = document.getElementById('slct_acIfscCode');
            var length = data.options.length;
            document.getElementById('slct_acIfscCode').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select IFSC";
            opt.value = "Select IFSC";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Ifsccode != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Ifsccode;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function get_branch_details() {
            var data = { 'op': 'get_bankifsc_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillifscbranch(msg);
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
        function fillifscbranch(msg) {
            var data = document.getElementById('slct_acbranchname');
            var length = data.options.length;
            document.getElementById('slct_acbranchname').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch";
            opt.value = "Select Branch";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function clearifscdetails() {
            document.getElementById('txt_IfscCode').value = "";
            document.getElementById('txt_Branchname').value = "";
            document.getElementById('btnifscsave').value = "Save";
        }
        //bankaccount master
        function save_BankAccount_Details() {
            var BankName = document.getElementById('selct_acBankName').value;
            var BranchName = document.getElementById('slct_acbranchname').value;
            var IFSCCode = document.getElementById('slct_acIfscCode').value;
            var AccountNumber = document.getElementById('txt_accno').value;
            var Accounttype = document.getElementById('selct_acctype').value;
            var Status = document.getElementById('ddlstatus').value;
            var ledgercode = document.getElementById('txt_ledgercode').value;
            var ledgername = document.getElementById('txt_ledgername').value;
            var barcnhledgercode = document.getElementById('txt_barcnhledgercode').value;
            var branchledgername = document.getElementById('txt_branchledgername').value;
            if (BankName == "") {
                alert("Enter BankName ");
                return false;
            }
            if (BranchName == "") {
                alert("Enter BranchName ");
                return false;

            }
            if (IFSCCode == "") {
                alert("Enter IFSCCode ");
                return false;

            }
            if (AccountNumber == "") {
                alert("Enter AccountNumber ");
                return false;

            }
            if (Accounttype == "") {
                alert("Enter Accounttype ");
                return false;

            }
            if (Status == "") {
                alert("Enter Status ");
                return false;

            }
            var sno = document.getElementById('lbl_acsno').value;
            var btnval = document.getElementById('btnaccountsave').value;
            var data = { 'op': 'save_BankAccount_Details','ledgercode':ledgercode,'ledgername':ledgername,'barcnhledgercode':barcnhledgercode,'branchledgername':branchledgername, 'BankName': BankName, 'BranchName': BranchName, 'IFSCCode': IFSCCode, 'AccountNumber': AccountNumber, 'Accounttype': Accounttype, 'Status': Status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_bankaccount_details();
                        clearbankaccountdetails();
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
        function ddlbankchange() {
            var bankid = document.getElementById('selct_acBankName').value;
            var data = { 'op': 'get_bankwiseifsc_details', 'bankid': bankid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbankifscdetails(msg);
                        fillifscbranch(msg);
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
        function ddlifscchange() {
            var ifscid = document.getElementById('slct_acIfscCode').value;
            var branchid = document.getElementById('slct_acbranchname').value;
            if (branchid == "Select Branch") {
                var data = { 'op': 'get_ifscwisebranch_details', 'ifscid': ifscid };
                var s = function (msg) {
                    if (msg) {
                        if (msg.length > 0) {
                            fillifscbranch(msg);
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
        }
        function ddlbranchchange() {
            var branchid = document.getElementById('slct_acbranchname').value;
            var ifscid = document.getElementById('slct_acIfscCode').value;
            if (ifscid == "Select IFSC") {
                var data = { 'op': 'get_branchwiseifsc_details', 'branchid': branchid };
                var s = function (msg) {
                    if (msg) {
                        if (msg.length > 0) {
                            fillbranchifsc(msg);
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
        }
        function fillbranchifsc(msg) {
            var data = document.getElementById('slct_acIfscCode');
            var length = data.options.length;
            document.getElementById('slct_acIfscCode').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Ifsccode";
            opt.value = "Select Ifsccode";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Ifsccode != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Ifsccode;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function get_bankaccount_details() {
            var data = { 'op': 'get_bankaccount_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbankaccountdetails(msg);

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
        function fillbankaccountdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">BankName</th><th scope="col">Branch</th><th scope="col">IFSCCode</th><th scope="col">Account Number</th><th scope="col">Account type</th><th scope="col">Ledger Code</th><th scope="col">Ledger Name</th><th scope="col">Branch ledger Code</th><th scope="col">Branch ledger </th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getbankacc(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].bankname + '</th>';
                results += '<td class="2">' + msg[i].branchcode + '</td>';
                results += '<td  class="3">' + msg[i].Ifsccode + '</td>';
                results += '<td  class="4">' + msg[i].AccountNumber + '</td>';
                results += '<td class="6">' + msg[i].Accounttype + '</td>';
                results += '<td class="10">' + msg[i].ledgercode + '</td>';
                results += '<td class="11">' + msg[i].ledgername + '</td>';
                results += '<td class="12">' + msg[i].barcnhledgercode + '</td>';
                results += '<td class="13">' + msg[i].branchledgername + '</td>';
                results += '<td  style="display:none" class="7">' + msg[i].bankid + '</td>';
                results += '<td  style="display:none" class="8">' + msg[i].ifscid + '</td>';
                results += '<td  style="display:none" class="9">' + msg[i].branchid + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Bankaccdata").html(results);
        }
        function getbankacc(thisid) {
            var bankid = $(thisid).parent().parent().children('.7').html();
            var ifscid = $(thisid).parent().parent().children('.8').html();
            var branchid = $(thisid).parent().parent().children('.9').html();
            var BranchName = $(thisid).parent().parent().children('.2').html();
            var AccountNumber = $(thisid).parent().parent().children('.4').html();
            var Accounttype = $(thisid).parent().parent().children('.6').html();
            var ledgercode = $(thisid).parent().parent().children('.10').html();
            var ledgername = $(thisid).parent().parent().children('.11').html();
            var barcnhledgercode = $(thisid).parent().parent().children('.12').html();
            var branchledgername = $(thisid).parent().parent().children('.13').html();
            var sno = $(thisid).parent().parent().children('.5').html();
            document.getElementById('selct_acBankName').selectedIndex = bankid;
            document.getElementById('slct_acbranchname').selectedIndex = branchid;
            document.getElementById('slct_acIfscCode').selectedIndex = ifscid;
            document.getElementById('txt_accno').value = AccountNumber;
            document.getElementById('selct_acctype').value = Accounttype;
            document.getElementById('txt_ledgercode').value = ledgercode;
            document.getElementById('txt_ledgername').value = ledgername;
            document.getElementById('txt_barcnhledgercode').value = barcnhledgercode;
            document.getElementById('txt_branchledgername').value = branchledgername;
            document.getElementById('lbl_acsno').value = sno;
            document.getElementById('btnaccountsave').value = "Modify";
            $("#div_Bankaccdata").show();
            $("#divBankacc").show();

        }
        function clearbankaccountdetails() {
            document.getElementById('selct_acBankName').selectedIndex = 0;
            document.getElementById('slct_acbranchname').selectedIndex = 0;
            document.getElementById('slct_acIfscCode').selectedIndex = 0;
            document.getElementById('txt_accno').value = "";
            document.getElementById('txt_ledgercode').value = "";
            document.getElementById('txt_ledgername').value = "";
            document.getElementById('txt_barcnhledgercode').value = "";
            document.getElementById('txt_branchledgername').value = "";
            document.getElementById('selct_acctype').selectedIndex = 0;
            document.getElementById('btnaccountsave').value = "Save";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            BankMasterDetails
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">BankMasterDetails</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showbankdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;BankMaster</a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showifscdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;IFSCMaster</a></li>
                    <li id="id_tab_documents1" class=""><a data-toggle="tab" href="#" onclick="showBankAccountNodetails()">
                        <i class="fa-street-view"></i>&nbsp;&nbsp;BankAccountMaster</a></li>
                </ul>
            </div>
            <div id="divbank" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Bank Master
                    </h3>
                </div>
                <div class="box-body">
                    <div id='fillform'>
                        <table align="center" style="width: 60%;">
                            <tr>
                                <th>
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    Bank Name
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txt_Bankname" placeholder="Enter  Bank Name" />
                                </td>
                            </tr>
                            <tr style="height: 5px;">
                            </tr>
                            <tr>
                                <td>
                                    Code
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txt_bankcode" placeholder="Enter  Bank code" />
                                </td>
                            </tr>
                            <tr style="height: 5px;">
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Status</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td style="height: 40px;">
                                    <select id="slct_bankstatus">
                                        <option value="1">Active</option>
                                        <option value="0">InActive</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Cash Book Code</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td style="height: 40px;">
                                    <select id="txt_cashbookcode">
                                        <option value="Y">Yes</option>
                                        <option value="N">No</option>
                                    </select>
                                </td>
                            </tr>
                            <tr hidden>
                                <label id="lbl_sno">
                                </label>
                            </tr>
                            <tr>
                                <td colspan="6" align="center" style="height: 40px;">
                                    <input id="btn_save" type="button" class="btn btn-success" name="submit" value='save'
                                        onclick="save_bank_click()" />
                                    <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                        onclick="clearbankdetails()" />
                                </td>
                            </tr>
                        </table>
                        <div id="div_bankData">
                        </div>
                    </div>
                </div>
                <div id="divbanks">
                </div>
            </div>
            <div id="divifsc" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>IFSC Master
                        </h3>
                    </div>
                     <div>
                    <div>
                        <table id="tbl_bankmaster" align="center">
                            <tr>
                                <td style="height: 40px;">
                                    Bank Name
                                </td>
                                <td>
                                    <select id="selct_BankName" class="form-control">
                                        <option selected disabled value="0">Select Bank Name</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    IFSC Code
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txt_IfscCode" placeholder="Enter  IFSC Code" />
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Branch Name
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txt_Branchname" placeholder="Enter  Branch Name" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Status</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td style="height: 40px;">
                                    <select id="slct_ifscstatus">
                                        <option value="1">Active</option>
                                        <option value="0">InActive</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <input id="btnifscsave" type="button" class="btn btn-success" name="submit" value="Save"
                                        onclick="save_BankIfsc_Details();">
                                    <input id="btnclose" type="button" class="btn btn-danger" name="submit" value="Clear"
                                        onclick="forclearall();">
                                </td>
                            </tr>
                            <tr hidden>
                                <td>
                                    <label id="lbl_ifscsno">
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div>
                        <div id="div_BankIfscdata">
                        </div>
                    </div>
                </div>
            </div>
        <div id="divBankacc" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Bank Account Master
                    </h3>
                </div>
                <div>
                <div>
                    <table id="tbl_leavemanagement" align="center">
                        <tr>
                            <td style="height: 40px;">
                                Bank Name
                            </td>
                            <td>
                                <select id="selct_acBankName" class="form-control" onchange="ddlbankchange();">
                                    <option selected disabled value="0">Select Bank Name</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                IFSC Code
                            </td>
                            <td>
                                <select id="slct_acIfscCode" class="form-control" onchange="ddlifscchange();">
                                    <option selected disabled value="0">Select ifsc code</option>
                                </select>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Branch Name
                            </td>
                            <td>
                                <select id="slct_acbranchname" class="form-control" onchange="ddlbranchchange();">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                AccountNumber
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txt_accno" placeholder="Enter AccountNumber" />
                            </td>
                            <td>
                            </td>
                        </tr>
                           <tr>
                            <td style="height: 40px;">
                                Ledger Code
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txt_ledgercode" placeholder="Enter Ledger Code" />
                            </td>
                            <td>
                            </td>
                             <tr>
                            <td style="height: 40px;">
                                Ledger Name
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txt_ledgername" placeholder="Enter Ledger Name" />
                            </td>
                        </tr>
                         <tr>
                            <td style="height: 40px;">
                              Branch Ledger Code
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txt_barcnhledgercode" placeholder="Enter Branch Ledger Code" />
                            </td>
                            <td>
                            </td>
                             <tr>
                            <td style="height: 40px;">
                                Branch Ledger Name
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txt_branchledgername" placeholder="Enter Branch Ledger Name" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                Accounttype
                            </td>
                            <td>
                                <select id="selct_acctype" class="form-control">
                                    <option selected disabled value="0">Select Accounttype</option>
                                    <option value="currentaccount">currentaccount</option>
                                    <option value="ODaccount">ODaccount</option>
                                </select>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Status</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlstatus">
                                    <option value="1">Active</option>
                                    <option value="0">InActive</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;align:center"">
                                <input id="btnaccountsave" type="button" class="btn btn-success" name="submit" value="Save"
                                    onclick="save_BankAccount_Details();">
                                <input id="btn_close1" type="button" class="btn btn-danger" name="submit" value="Clear"
                                    onclick="clearbankaccountdetails();">
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="lbl_acsno">
                                </label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div>
                    <div id="div_Bankaccdata">
                    </div>
                </div>
            </div>
        </div>
        </div>
    </section>
</asp:Content>
