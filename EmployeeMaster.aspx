<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="EmployeeMaster.aspx.cs" Inherits="EmployeeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
 <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function ()
        {
            $("#div_Account").css("display", "block");
            get_Dep_Details();
            get_emp_details();
            get_Branch_details();
        });
        function showempdetails()
        {
            $("#div_Account").css("display", "block");
            $("#divdesig").css("display", "none");
            $("#divdept").css("display", "none");
            get_emp_details();
            get_Dep_Details();
        }
        function showdesigdetails()
        {
            $("#divdesig").css("display", "block");
            $("#div_Account").css("display", "none");
           // $("fillform2").css("display", "block");
            $("#divdept").css("display", "none");
            get_designation_details();
        }
        function showdeptdetails(){
            $("#divdesig").css("display", "none");
            $("#div_Account").css("display", "none");
            $("#divdept").css("display", "block");
            get_dept_details();
       }
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

        //Employee Master
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
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
        function fillbranch(msg) {
            var data = document.getElementById('selct_branch');
            var length = data.options.length;
            document.getElementById('selct_branch').options.length = null;
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
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }
        function save_employee_details() {
            var name = document.getElementById('txt_emp').value;
            if (name == "") {
                alert("Enter Employee name ");
                return false;

            }
            var deptid = document.getElementById('txt_depcode').value;
            var DepartmentCode = document.getElementById('selct_code').value; 
            if (DepartmentCode == "") {
                alert("Select DepartmentCode ");
                return false;

            }
            var leveltype = document.getElementById('txtlevel').value;
            var branchname = document.getElementById('selct_branch').value;
            var username = document.getElementById('txt_user').value;
            var passward = document.getElementById('txt_pwd').value;
            if (passward == "") {
                alert("Enter password ");
                return false;
            }
            var sno = document.getElementById('lbl_empsno').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_employee_details', 'name': name,'deptid':deptid, 'DepartmentCode': DepartmentCode,'branchname':branchname,'leveltype':leveltype, 'username': username, 'passward': passward, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_emp_details();
                        clear_employee_Details();
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
        function clear_employee_Details() {
            document.getElementById('txt_emp').value = "";
            document.getElementById('selct_code').value = "";
            document.getElementById('txt_user').value = "";
            document.getElementById('txt_pwd').value = "";
            document.getElementById('txtlevel').value = "";
            document.getElementById('selct_branch').selectedIndex = 0;
            document.getElementById('btn_save').value = "Save";
        }
        var deptdetails = [];
        function get_Dep_Details()
        {
            var data = { 'op': 'get_dept_details' };
            var s = function (msg)
            {
                if (msg) {
                    deptdetails = msg;
                    var deptnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var depname = msg[i].DepartmentName;
                        deptnameList.push(depname);
                    }
                    $('#selct_code').autocomplete({
                        source: deptnameList,
                        change: getdeptid
                    });
                }
            }
            var e = function (x, h, e)
            {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function getdeptid(){
        var deptname = document.getElementById('selct_code').value;
        for (var i = 0; i < deptdetails.length; i++) {
            if (deptname == deptdetails[i].DepartmentName) {
                document.getElementById('txt_depcode').value = deptdetails[i].sno;
            }
        }

        }
        function get_emp_details(thisid) {
            var data = { 'op': 'get_employee_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillempdetails(msg);

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
        function fillempdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Name</th><th scope="col">DepartmentCode</th><th scope="col">Branch</th><th scope="col">LevelType</th><th scope="col">Username</th><th scope="col">Password</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getemp(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1">' + msg[i].name + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].deptname + '</td>';
                results += '<td data-title="code" class="7">' + msg[i].branchname + '</td>';
                results += '<td data-title="code" class="8">' + msg[i].leveltype + '</td>';
                results += '<td data-title="code" class="3">' + msg[i].username + '</td>';
                results += '<td data-title="code" class="4">' + msg[i].passward + '</td>';
                results += '<td style="display:none" data-title="code" class="5">' + msg[i].deptid + '</td>';
                results += '<td style="display:none" data-title="code" class="9">' + msg[i].branchid + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_employee").html(results);
        }
        function getemp(thisid) {
            var name = $(thisid).parent().parent().children('.1').html();
            var deptname = $(thisid).parent().parent().children('.2').html();
            var deptid = $(thisid).parent().parent().children('.5').html();
            var username = $(thisid).parent().parent().children('.3').html();
            var passward = $(thisid).parent().parent().children('.4').html();
            var leveltype = $(thisid).parent().parent().children('.8').html();
            var branchname = $(thisid).parent().parent().children('.9').html();
            var sno = $(thisid).parent().parent().children('.6').html();
            document.getElementById('txt_emp').value = name;
            document.getElementById('selct_code').value = deptname;
            document.getElementById('txt_depcode').value = deptid;
            document.getElementById('txt_user').value = username;
            document.getElementById('txt_pwd').value = passward;
            document.getElementById('selct_branch').value = branchname;
            document.getElementById('txtlevel').value = leveltype;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_empsno').value = sno;
        }

        //Designation Master
        function save_designation_details()
        {
            var DesignationCode = document.getElementById('txt_code').value;
            if (DesignationCode == "") {
                alert("Select DesignationCode ");
                return false;

            }
            var Designation = document.getElementById('txt_desig').value;
            if (Designation == "") {
                alert("Enter Designation ");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_savedesig').value;
            var data = { 'op': 'save_designation_details', 'DesignationCode': DesignationCode, 'Designation': Designation, 'btnVal': btnval, 'sno': sno };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_designation_details();
                        clear_desig();
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
        function clear_desig()
        {
            document.getElementById('txt_desig').value = "";
            document.getElementById('txt_code').value = "";
            document.getElementById('btn_savedesig').value = "Save";
        }
        function get_designation_details()
        {
            var data = { 'op': 'get_designation_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldesigdetails(msg);

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
        function filldesigdetails(msg)
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Designation</th><th scope="col">Designation Code</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1">' + msg[i].designation + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].desigcode + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_designation").html(results);
        }
        function getme(thisid)
        {
            var designation = $(thisid).parent().parent().children('.1').html();
            var desigcode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();

            document.getElementById('txt_desig').value = designation;
            document.getElementById('txt_code').value = desigcode;
            document.getElementById('btn_savedesig').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }

        //Department Master
        function save_Department_Details()
        {
            var DepartmentName = document.getElementById('txt_DName').value;
            if (DepartmentName == "") {
                alert("Enter Department Name ");
                return false;

            }
            var DepartmentCode = document.getElementById('txt_dcode').value;
            if (DepartmentCode == "") {
                alert("Enter Department Code ");
                return false;
            }
            var btnval = document.getElementById('dept_save').value;
            var sno = document.getElementById('lbl_deptsno').value;
            var data = { 'op': 'save_Department_Details', 'DepartmentName': DepartmentName, 'DepartmentCode': DepartmentCode, 'btnVal': btnval, 'sno': sno };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_dept_details();
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
            document.getElementById('txt_DName').value = "";
            document.getElementById('txt_dcode').value = "";
            document.getElementById('lbl_deptsno').value = "";
            document.getElementById('dept_save').value = "Save";
        }
        function get_dept_details()
        {
            var data = { 'op': 'get_dept_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filldeptdetails(msg);
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
        function filldeptdetails(msg)
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">DepartmentName</th><th scope="col">DepartmentCode</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getdept(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1">' + msg[i].DepartmentName + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].DepartmentCode + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_department").html(results);
        }
        function getdept(thisid)
        {
            var DepartmentName = $(thisid).parent().parent().children('.1').html();
            var DepartmentCode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            document.getElementById('txt_DName').value = DepartmentName;
            document.getElementById('txt_dcode').value = DepartmentCode;
            document.getElementById('dept_save').value = "Modify";
            document.getElementById('lbl_deptsno').value = sno;
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Employee Master</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showempdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Employee Master </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showdesigdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Designation Master</a></li>
                         <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showdeptdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Department Master</a></li>
                </ul>
                </div>
                <div id="div_Account" style="display:none">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Master
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
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
                                            Name</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_emp" type="text" maxlength="45" class="form-control" placeholder="Enter Employeename" /><label
                                            id="Label1" class="errormessage">* Please Enter Employee name
                                        <input id="txt_empid" type="hidden"></input>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            DepartmentCode</label>
                                    </td>
                                    <td>
                                        <input id="selct_code" class="form-control" placeholder="Enter Department"> </input>
                                       <input id="txt_depcode" type="hidden"></input>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                <td>
                                <label>
                                    LevelType</label>
                            </td>
                            <td>
                                <select id="txtlevel" class="form-control">
                                    <option>Admin</option>
                                    <option>SuperAdmin</option>
                                    <option>User</option>
                                </select>
                            </td>
                                </tr>
                                <tr>
                                <td>
                                <label>
                                    Branch Name</label>
                                    </td>
                                <td>
                                <select id="selct_branch" class="form-control"> </select>
                                </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Username</label>
                                    </td>
                                    <td>
                                        <input id="txt_user" class="form-control" type="text" name="Username" placeholder="Enter Username"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td >
                                        <label>
                                            Password</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_pwd" type="text" maxlength="45" class="form-control" placeholder="Enter Password" /><label
                                            id="lbl_code_error_msg" class="errormessage">* Please Enter Password</label>
                                    </td>
                                   
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_employee_details();">
                                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_employee_Details();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_empsno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_employee">
                            </div>
                        </div>
                    </div>
                    </div>
                    <div id="divdesig" style="display:none">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Designation Master
                        </h3>
                    </div>
                     <div>
                        <div id='fillform2'>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Designation</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_desig" type="text"  class="form-control" placeholder="Enter Designation" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Designation Code</label>
                                    </td>
                                    <td>
                                      <input id="txt_code" type="text"  class="form-control" placeholder="Enter Designation code" />
                                       
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_savedesig" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_designation_details();">
                                        <input id="btn_closedesig" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_desig();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_designation">
                            </div>
                        </div>
                    </div>
                    </div>
                     <div id="divdept" style="display:none">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Department Master
                    </h3>
                </div>
                    <div id="fillformdept">
                        <table align="center" style="width: 60%;">
                            <tr>
                                <th>
                                </th>
                            </tr>
                            <tr>
                                <td >
                                <label> DepartmentName</label> <span style="color: red;">*</span>
                                </td>
                                <td  style="height: 40px;">
                                    <input id="txt_DName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Dept Name" /><label id="lbl_code_error_msg" class="errormessage">* Please
                                            Enter Name</label>
                                </td>
                            </tr>
                            <tr>
                                 <td >
                                <label> DepartmentCode</label> <span style="color: red;">*</span>
                                </td>
                                <td  style="height: 40px;">
                                    <input id="txt_dcode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Dept code" /><label id="Label1" class="errormessage">* Please
                                            Enter Name</label>
                                </td>
                            </tr>
                            <tr style="display:none;"><td>
                            <label id="lbl_deptsno"></label>
                            </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" style="height: 40px;">
                                    <input id="dept_save" type="button" class="btn btn-success" name="submit" value='save'
                                        onclick="save_Department_Details()" />
                                    <input id='dept_close' type="button" class="btn btn-danger" name="Clear" value='Clear'
                                        onclick="forclearall()" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="div_department"></div>
                    </div>
                     </div>
        </section>
</asp:Content>
