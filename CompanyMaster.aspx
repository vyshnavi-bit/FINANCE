<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CompanyMaster.aspx.cs" Inherits="CompanyMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function ()
        {
            $("#divcompany").css("display", "block");
            get_CompanyMaster_details();
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
                error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
            $.ajax({
                type: "GET",
                url: "DairyFleet.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function showcompanydetails()
        {
            $("#divcompany").css("display", "block");
            $("#divbranch").css("display", "none");
        }
        function showbranchdetails()
        {
            $("#divcompany").css("display", "none");
            $("#divbranch").css("display", "block");
            get_bank_details();
            get_Company_details();
            get_Branch_details();
        }
        function save_CompanyMaster_click() {
            var CompanyName = document.getElementById('txt_CompanyName').value;
            var Add = document.getElementById('txt_CompanyAdd').value;
            var PhoneNo = document.getElementById('txt_PhoneNo').value;
            var mailId = document.getElementById('txt_CompanyMailId').value;
            var TINNo = document.getElementById('txt_TINNo').value;
            if (CompanyName == "") {
                alert("Enter CompanyName");
                return false;
            }
            if (Add == "") {
                alert("Enter Add");
                return false;
            }
            if ((PhoneNo == "") || (PhoneNo.length != 10)) {

                alert("PhoneNo should not be Empty and it Should be of 10 digits");
                PhoneNo.focus();
                return false;
            }
            var CompanyCode = document.getElementById('lbl_CompanyCode').value;
            var btnSave = document.getElementById('save_company').value;
            var data = { 'op': 'saveCompanyMasterdetails', 'CompanyName': CompanyName, 'Add': Add, 'PhoneNo': PhoneNo, 'btnVal': btnSave, 'CompanyCode': CompanyCode, 'mailId': mailId, 'TINNo': TINNo };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        canceldetails();
                        get_CompanyMaster_details();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            callHandler(data, s, e);
        }
        function get_CompanyMaster_details() {
            var data = { 'op': 'get_CompanyMaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompdetails(msg);
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
        function fillcompdetails(msg)
        {
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">CompanyName</th><th scope="col">Address</th><th scope="col">PhoneNo</th><th scope="col">MailId</th><th scope="col">TINNo</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getcompany(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="CompanyName"  class="2">' + msg[i].CompanyName + '</td>';
                results += '<td data-title="Add" class="3">' + msg[i].Add + '</td>';
                results += '<td data-title="PhoneNo" class="4">' + msg[i].PhoneNo + '</td>';
                results += '<td data-title="mailId" class="5">' + msg[i].mailId + '</td>';
                results += '<td data-title="TINNo" class="6">' + msg[i].TINNo + '</td>';
                results += '<td data-title="CompanyCode" style="display:none" class="8">' + msg[i].CompanyCode + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_comanydata").html(results);
        }
        function getcompany(thisid)
        {
            var CompanyName = $(thisid).parent().parent().children('.2').html();
            var Add = $(thisid).parent().parent().children('.3').html();
            var PhoneNo = $(thisid).parent().parent().children('.4').html();
            var mailId = $(thisid).parent().parent().children('.5').html();
            var TINNo = $(thisid).parent().parent().children('.6').html();
            var CompanyCode = $(thisid).parent().parent().children('.8').html();
            document.getElementById('txt_CompanyName').value = CompanyName;
            document.getElementById('txt_CompanyAdd').value = Add;
            document.getElementById('txt_PhoneNo').value = PhoneNo;
            document.getElementById('txt_CompanyMailId').value = mailId;
            document.getElementById('txt_TINNo').value = TINNo;
            document.getElementById('lbl_CompanyCode').value = CompanyCode;
            document.getElementById('save_company').value = "Modify";
//            $("#fillform").show();
//            $('#showlogs').hide();
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function canceldetails() {
            var CompanyName = document.getElementById('txt_CompanyName').value = "";
            var Add = document.getElementById('txt_CompanyAdd').value = "";
            var PhoneNo = document.getElementById('txt_PhoneNo').value = "";
            var mailId = document.getElementById('txt_CompanyMailId').value = "";
            var TINNo = document.getElementById('txt_TINNo').value = "";
            document.getElementById('btn_save').value = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }
        function checkEmail() {
            var email = document.getElementById('txt_CompanyMailId').value;
            var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (!filter.test(email.value)) {
                alert('Please provide a valid email address');
                email.focus;
                document.getElementById('txt_CompanyMailId').value
                return false;
            }
        }
        //Branch Master
        function get_Company_details()
        {
            var data = { 'op': 'get_CompanyMaster_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompany(msg);
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
        function fillcompany(msg)
        {
            var data = document.getElementById('selct_Cmpny');
            var length = data.options.length;
            document.getElementById('selct_Cmpny').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Company";
            opt.value = "Select Company";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].CompanyName != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].CompanyName;
                    option.value = msg[i].CompanyCode;
                    data.appendChild(option);
                }
            }
        }
        function get_bank_details()
        {
            var data = { 'op': 'get_bank_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {

                        fillddlbank(msg);

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
        function fillddlbank(msg)
        {
            var data = document.getElementById('txt_bankname');
            var length = data.options.length;
            document.getElementById('txt_bankname').options.length = null;
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
        function saveBranchDetails()
        {
            var CompanyName = document.getElementById('selct_Cmpny').value;
            if (CompanyName == "") {
                alert("Select Company Name");
                return false;
            }
            var branchname = document.getElementById('txtBrcName').value;
            var statename = document.getElementById('txtStatename').value;
            var Phone = document.getElementById('txtPhnNO').value;
            var emailid = document.getElementById('txtMail').value;
            var address = document.getElementById('txtAdrs').value;
            var branchtype = document.getElementById('slct_Type').value;
            var branchid = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;
            var code = document.getElementById('txt_code').value;
            //var bankcode = document.getElementById('txt_bankcode').value;
            var bankname = document.getElementById('txt_bankname').value;
            var pin = document.getElementById('txt_pin').value;
            var fax = document.getElementById('txt_fax').value;
            //var gl = document.getElementById('txt_gl').value;
            //var desc = document.getElementById('txt_desc').value;
            if (branchname == "") {
                alert("Select Branch Name");
                return false;
            }
            if (statename == "") {
                alert("Select State Name");
                return false;
            }
            if (emailid == "") {
                alert("Enter Section emailid");
                return false;
            }
            if (code == "") {
                alert("Enter Code");
                return false;
            }
            var data = { 'op': 'saveBranchDetails', 'code': code, 'CompanyName': CompanyName, 'branchname': branchname, 'branchid': branchid, 'statename': statename, 'Phone': Phone, 'emailid': emailid, 'address': address, 'branchtype': branchtype, 'bankname': bankname, 'pin': pin, 'fax': fax, 'btnVal': btnval };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_Branch_details();
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
        function forclearall()
        {
            document.getElementById('txtBrcName').value = "";
            document.getElementById('selct_Cmpny').selectedIndex = 0;
            document.getElementById('txtStatename').selectedIndex = 0;
            document.getElementById('slct_Type').selectedIndex = 0;
            document.getElementById('txtPhnNO').value = "";
            document.getElementById('txtMail').value = "";
            document.getElementById('txtAdrs').value = "";
            document.getElementById('txt_code').value = "";
            document.getElementById('btn_save').value = "Save";
            get_Branch_details();
        }
        function get_Branch_details()
        {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
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

        function filldetails(msg)
        {
            var k = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">Sno</th></th><th scope="col">BranchName</th><th scope="col">Statename</th><th scope="col">EmaiId</th><th scope="col">Code</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].branchname + '</th>';
                results += '<td data-title="brandstatus" style="display:none"class="2">' + msg[i].branchid + '</td>';
                results += '<td data-title="brandstatus" class="3">' + msg[i].statename + '</td>';
                results += '<td data-title="brandstatus"style="display:none" class="4">' + msg[i].Phone + '</td>';
                results += '<td data-title="brandstatus" class="5">' + msg[i].emailid + '</td>';
                results += '<td data-title="brandstatus" class="13">' + msg[i].code + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="7">' + msg[i].fromdate + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="8">' + msg[i].todate + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="9">' + msg[i].nightallowance + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="10">' + msg[i].branchtype + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="11">' + msg[i].CompanyName + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="12">' + msg[i].company_code + '</td>';
                //results += '<td data-title="brandstatus"  style="display:none" class="14">' + msg[i].bankcode + '</td>';
                //results += '<td data-title="brandstatus"  style="display:none" class="15">' + msg[i].bankname + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="16">' + msg[i].pincode + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="17">' + msg[i].fax + '</td>';
                //results += '<td data-title="brandstatus"  style="display:none" class="18">' + msg[i].gl + '</td>';
                //results += '<td data-title="brandstatus"  style="display:none" class="19">' + msg[i].desc + '</td>';
                results += '<td data-title="brandstatus" style="display:none"class="6">' + msg[i].address + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_CategoryData").html(results);
        }

        function getme(thisid)
        {
            var branchname = $(thisid).parent().parent().children('.1').html();
            var branchid = $(thisid).parent().parent().children('.2').html();
            var statename = $(thisid).parent().parent().children('.3').html();
            var Phone = $(thisid).parent().parent().children('.4').html();
            var emailid = $(thisid).parent().parent().children('.5').html();
            var address = $(thisid).parent().parent().children('.6').html();
            var branchtype = $(thisid).parent().parent().children('.10').html();
            var CompanyName = $(thisid).parent().parent().children('.11').html();
            var company_code = $(thisid).parent().parent().children('.12').html();
            var code = $(thisid).parent().parent().children('.13').html();
            //var bankcode = $(thisid).parent().parent().children('.14').html();
            var bankid = $(thisid).parent().parent().children('.15').html();
            var pincode = $(thisid).parent().parent().children('.16').html();
            var fax = $(thisid).parent().parent().children('.17').html();
            //var gl = $(thisid).parent().parent().children('.18').html();
            //var desc = $(thisid).parent().parent().children('.19').html();

            document.getElementById('txtBrcName').value = branchname;
            document.getElementById('slct_Type').value = branchtype;
            document.getElementById('txtStatename').value = statename;
            document.getElementById('txtPhnNO').value = Phone;
            document.getElementById('txtMail').value = emailid;
            document.getElementById('txtAdrs').value = address;
            document.getElementById('selct_Cmpny').value = company_code;
            document.getElementById('lbl_sno').value = branchid;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('txt_code').value = code;
            //document.getElementById('txt_bankcode').value = bankcode;
            document.getElementById('txt_bankname').value = bankid;
            document.getElementById('txt_pin').value = pincode;
            document.getElementById('txt_fax').value = fax;
            //document.getElementById('txt_gl').value = gl;
            //document.getElementById('txt_desc').value = desc;
        }
        function validateEmail(email)
        {
            var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
            if (reg.test(email)) {
                return true;
            }
            else {
                return false;
            }
        }
        function ValidateAlpha(evt)
        {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }

        function isNumber(evt)
        {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<section class="content-header">
        <h1>
           Company Master<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Company Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
        <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showcompanydetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Company Master </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showbranchdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Branch Master</a></li>
                </ul>
                </div>
                <div id="divcompany" style="display:none">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Company Master
                </h3>
            </div>
            <div class="box-body">
                <table align="center" style="width: 60%;">
                 <tr>
                        <td>
                            <label>
                               Company Name</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form-control" id="txt_CompanyName" placeholder="Enter Company Name"
                               style="margin: 0px; height: 35px; width: 312px;" />
                        </td>
                    </tr>
                     <tr>
                        <td>
                            <label>
                                Address</label>
                        </td>
                        <td style="height: 40px;">
                            <textarea type="text" class="form-control" id="txt_CompanyAdd" placeholder="Enter Address"
                                 style="margin: 0px; height: 47px; width: 312px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                Phone No</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form-control" id="txt_PhoneNo" placeholder="Enter Phone No"
                                onkeypress="return isNumber(event)" style="margin: 0px; height: 35px; width: 312px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                Mail Id</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form-control" id="txt_CompanyMailId" placeholder="Enter Mail Id"
                                onchange="javascript:checkEmail();" style="margin: 0px; height: 35px; width: 312px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                TIN No</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form-control" id="txt_TINNo" placeholder="Enter TIN No"
                                onkeypress="return isNumber(event)" style="margin: 0px; height: 35px; width: 312px;" />
                        </td>
                    </tr>
                </table>
                <table align="center">
                    <tr>
                        <td>
                            <input type="button" class="btn btn-success" id="save_company" value="Save" onclick="save_CompanyMaster_click();" />
                            <input type="button" class="btn btn-danger" id="close_id" value="Clear" onclick="canceldetails()" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td>
                            <label id="lbl_CompanyCode">
                            </label>
                        </td>
                    </tr>
                </table>
                <div id="div_comanydata">
                </div>
            </div>
            </div>
            <div id="divbranch" style="display:none">
             <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Branch Master
                </h3>
            </div>
            <div class="box-body">
                <div id='fillform'>
                    <table align="center">
                    <tr>
                    <td>
                      <label>
                              Bank Name</label>
                          </td>
                          <td>
                                
                                <select id="txt_bankname" type="text" name="CMobileNumber" placeholder="Bank Name" class="form-control">
                                    </select>
                          </td>
                    </tr>
                        <tr>
                            <td>
                                <label>
                                    Company Name</label>
                            </td>
                            <td>
                                <select id="selct_Cmpny" class="form-control">
                                    <option selected disabled value="Select state">Select company</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    BranchName</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtBrcName" type="text" name="CustomerFName" placeholder="Enter Name"
                                    class="form-control" onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <label>
                                    State Name</label>
                            </td>
                            <td>
                                <select id="txtStatename" class="form-control">
                                    <option selected disabled value="Select state">Select state</option>
                                    <option id="Option1">AndraPrdesh</option>
                                    <option id="Option2">Tamilnadu</option>
                                    <option id="Option3">karnataka</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Phone NO</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtPhnNO" type="text" name="CCName" placeholder="Enter PhoneNumber" class="form-control"
                                    onkeypress="return isNumber(event)" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <label>
                                    E_Mail</label>
                            </td>
                            <td>
                                <input id="txtMail" type="text" name="CMobileNumber" placeholder="Enter Email" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Branch Type</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_Type" class="form-control">
                                    <option selected disabled value="Select state">Select Branch Type</option>
                                    <option id="Option4">SalesOffice</option>
                                    <option id="Option5">CC</option>
                                    <option id="Option6">Plant</option>
                                </select>
                            </td>
                             <td style="width: 6px;">
                            </td>
                            <td>
                                <label>
                                    Code</label>
                            </td>
                            <td>
                                <input id="txt_code" type="text" name="CMobileNumber" placeholder="Enter Code" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Pin</label>
                            </td>
                            <td>
                                <input id="txt_pin" type="text" name="CMobileNumber" placeholder="Enter Pin" class="form-control" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td >
                                <label>
                                    Fax</label>
                            </td>
                            <td>
                                <input id="txt_fax" type="text" name="CMobileNumber" placeholder="Enter Fax" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Address</label>
                            </td>
                            <td>
                                <textarea id="txtAdrs" type="text" name="CMobileNumber" placeholder="Enter Address" class="form-control"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-success" name="submit" value='Save'
                                    onclick="saveBranchDetails()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="forclearall()" />
                            </td>
                        </tr>
                    </table>
                </div>
                   <div id="div_CategoryData">
                </div>
            </div>
            
            </div>
        </div>
    </section>
</asp:Content>
