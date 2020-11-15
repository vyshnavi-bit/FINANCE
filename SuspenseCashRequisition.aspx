<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="SuspenseCashRequisition.aspx.cs" Inherits="SuspenseCashRequisition" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script type="text/javascript">
    $(function ()
    {
        get_designation_details();
        //get_controltype_details();
        get_dept_details();
        get_suspensecash_requisition();
       // get_budget_details();
       // get_costcenter_details();
       // get_bankaccount_details();
        get_employee_details();
        get_financial_year();
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
    function get_employee_details()
    {
        var data = { 'op': 'get_employee_details' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillempdetails(msg);
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
    function fillempdetails(msg)
    {
        var data = document.getElementById('slct_empcode');
        var length = data.options.length;
        document.getElementById('slct_empcode').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select Employee";
        opt.value = "Select Employee";
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
//    function get_bankaccount_details()
//    {
//        var data = { 'op': 'get_bankaccount_details' };
//        var s = function (msg)
//        {
//            if (msg) {
//                if (msg.length > 0) {
//                    filldetails(msg);
//                }
//            }
//            else {
//            }
//        };
//        var e = function (x, h, e)
//        {
//        };
//        callHandler(data, s, e);
//    }
//    function filldetails(msg)
//    {
//        var data = document.getElementById('txt_accode');
//        var length = data.options.length;
//        document.getElementById('txt_accode').options.length = null;
//        var opt = document.createElement('option');
//        opt.innerHTML = "Select Account No";
//        opt.value = "Select Account No";
//        opt.setAttribute("selected", "selected");
//        opt.setAttribute("disabled", "disabled");
//        opt.setAttribute("class", "dispalynone");
//        data.appendChild(opt);
//        for (var i = 0; i < msg.length; i++) {
//            if (msg[i].AccountNumber != null) {
//                var option = document.createElement('option');
//                option.innerHTML = msg[i].AccountNumber;
//                option.value = msg[i].sno;
//                data.appendChild(option);
//            }
//        }
//    }
    function get_designation_details()
    {
        var data = { 'op': 'get_designation_details' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    filldesigdetails(msg);
                    desigarray = msg;
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
    function filldesigdetails(msg)
    {
        var data = document.getElementById('slct_desig');
        var length = data.options.length;
        document.getElementById('slct_desig').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select Designation";
        opt.value = "Select Designation";
        opt.setAttribute("selected", "selected");
        opt.setAttribute("disabled", "disabled");
        opt.setAttribute("class", "dispalynone");
        data.appendChild(opt);
        for (var i = 0; i < msg.length; i++) {
            if (msg[i].designation != null) {
                var option = document.createElement('option');
                option.innerHTML = msg[i].designation;
                option.value = msg[i].sno;
                data.appendChild(option);
            }
        }
    }
//    function get_budget_details()
//    {
//        var data = { 'op': 'get_budget_details' };
//        var s = function (msg)
//        {
//            if (msg) {
//                if (msg.length > 0) {
//                    fillbudgetdetails(msg);
//                }
//            }
//            else {
//            }
//        };
//        var e = function (x, h, e)
//        {
//        };
//        callHandler(data, s, e);
//    }
//    function fillbudgetdetails(msg)
//    {
//        var data = document.getElementById('slct_budgetcode');
//        var length = data.options.length;
//        document.getElementById('slct_budgetcode').options.length = null;
//        var opt = document.createElement('option');
//        opt.innerHTML = "Select BudgetCode";
//        opt.value = "Select BudgetCode";
//        opt.setAttribute("selected", "selected");
//        opt.setAttribute("disabled", "disabled");
//        opt.setAttribute("class", "dispalynone");
//        data.appendChild(opt);
//        for (var i = 0; i < msg.length; i++) {
//            if (msg[i].budgetcode != null) {
//                var option = document.createElement('option');
//                option.innerHTML = msg[i].budgetcode;
//                option.value = msg[i].sno;
//                data.appendChild(option);
//            }
//        }
//    }
//    function get_costcenter_details()
//    {
//        var data = { 'op': 'get_costcenter_details' };
//        var s = function (msg)
//        {
//            if (msg) {
//                if (msg.length > 0) {
//                    fillcostcenterdetails(msg);
//                }
//            }
//            else {
//            }
//        };
//        var e = function (x, h, e)
//        {
//        };
//        callHandler(data, s, e);
//    }
//    function fillcostcenterdetails(msg)
//    {
//        var data = document.getElementById('slct_cc');
//        var length = data.options.length;
//        document.getElementById('slct_cc').options.length = null;
//        var opt = document.createElement('option');
//        opt.innerHTML = "Select CostCode";
//        opt.value = "Select CostCode";
//        opt.setAttribute("selected", "selected");
//        opt.setAttribute("disabled", "disabled");
//        opt.setAttribute("class", "dispalynone");
//        data.appendChild(opt);
//        for (var i = 0; i < msg.length; i++) {
//            if (msg[i].costcentercode != null) {
//                var option = document.createElement('option');
//                option.innerHTML = msg[i].costcentercode;
//                option.value = msg[i].sno;
//                data.appendChild(option);
//            }
//        }
//    }
//    function get_controltype_details()
//    {
//        var data = { 'op': 'get_control_types' };
//        var s = function (msg)
//        {
//            if (msg) {
//                if (msg.length > 0) {
//                    fillcontroltypedetails(msg);
//                }
//            }
//            else {
//            }
//        };
//        var e = function (x, h, e)
//        {
//        };
//        callHandler(data, s, e);
//    }
//    function fillcontroltypedetails(msg)
//    {
//        var data = document.getElementById('slct_ctype');
//        var length = data.options.length;
//        document.getElementById('slct_ctype').options.length = null;
//        var opt = document.createElement('option');
//        opt.innerHTML = "Select controltype";
//        opt.value = "Select controltype";
//        opt.setAttribute("selected", "selected");
//        opt.setAttribute("disabled", "disabled");
//        opt.setAttribute("class", "dispalynone");
//        data.appendChild(opt);
//        for (var i = 0; i < msg.length; i++) {
//            if (msg[i].controltype != null) {
//                var option = document.createElement('option');
//                option.innerHTML = msg[i].controltype;
//                option.value = msg[i].sno;
//                data.appendChild(option);
//            }
//        }
//    }
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
        callHandler(data, s, e);
    }
    function filldeptdetails(msg) {
        var data = document.getElementById('txt_deptcode');
        var length = data.options.length;
        document.getElementById('txt_deptcode').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select Dept Code";
        opt.value = "Select Dept Code";
        opt.setAttribute("selected", "selected");
        opt.setAttribute("disabled", "disabled");
        opt.setAttribute("class", "dispalynone");
        data.appendChild(opt);
        for (var i = 0; i < msg.length; i++) {
            if (msg[i].DepartmentCode != null) {
                var option = document.createElement('option');
                option.innerHTML = msg[i].DepartmentCode;
                option.value = msg[i].sno;
                data.appendChild(option);
            }
        }
    }
    var cash = [];
    function get_available_amount()
    {
        var data = { 'op': 'get_suspensenorms_entry' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    cash = msg;
                    get_amount();
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
    function get_amount()
    {
        var desig = document.getElementById('slct_desig').value;
        for (var i = 0; i < cash.length; i++) {
            if (desig == cash[i].sno) {
                document.getElementById('avail_amt').value = cash[i].suspenseamount;
            }
        }
    }
    function get_financial_year()
    {
        var data = { 'op': 'get_financial_year' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillfinyeardetails(msg);

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
    function fillfinyeardetails(msg)
    {

        for (var i = 0; i < msg.length; i++) {
            if (msg[i].currentyear == "true") {
                document.getElementById('txt_finyr').value = msg[i].year;
            }
        }
    }
    function save_cash_requisition()
    {
        var reqno = document.getElementById('txt_reqno').value;
        if (reqno == "") {
            alert("Enter Requisition Number");
            return false;

        }
        var reqdate = document.getElementById('dt_reqdate').value;
        if (reqdate == "") {
            alert("Enter Requisition Date");
            return false;

        }
        var finyear = document.getElementById('txt_finyr').value;
//        var controltype = document.getElementById('slct_ctype').value;
//        if (controltype == "") {
//            alert("Select Control Type");
//            return false;

//        }
//        var controldesc = document.getElementById('txt_descr').value;

//        if (controldesc == "") {
//            alert("Enter Control Type Description");
//            return false;

//        }
//        var Accountcode = document.getElementById('txt_accode').value;
//        if (Accountcode == "") {
//            alert("Select Account Code");
//            return false;

//        }
//        var acdesc = document.getElementById('txt_acdesc').value;
//        if (acdesc == "") {
//            alert("Enter Account Description");
//            return false;

//        }
        var designation = document.getElementById('slct_desig').value;
        if (designation == "") {
            alert("Select designation");
            return false;

        }
        var Employeecode = document.getElementById('slct_empcode').value;
        if (Employeecode == "") {
            alert("Select Employee code");
            return false;

        }
        var availamount = document.getElementById('avail_amt').value;
        if (availamount == "") {
            alert("Enter Available Amount");
            return false;

        }
        var deptcode = document.getElementById('txt_deptcode').value;
        if (deptcode == "") {
            alert("Select Department Code");
            return false;

        }
//        var costcenter = document.getElementById('slct_cc').value;
//        if (costcenter == "") {
//            alert("Select Cost Center Code");
//            return false;

//        }
//        var Costdesc = document.getElementById('txt_costdesc').value;
//        if (Costdesc == "") {
//            alert("Enter Cost Description");
//            return false;

//        }
//        var budgetcode = document.getElementById('slct_budgetcode').value;
//        if (budgetcode == "") {
//            alert("Select Budget Code");
//            return false;

//        }
//        var budgetdesc = document.getElementById('txt_budgetdesc').value;
//        if (budgetdesc == "") {
//            alert("Enter Budget Description");
//            return false;

//        }
        var reqamount = document.getElementById('txt_reqamt').value;
        if (reqamount == "") {
            alert("Enter Requisition Amount");
            return false;

        }
        var particulars = document.getElementById('txt_part').value;
        if (particulars == "") {
            alert("Enter particulars");
            return false;

        }
//        var reasoncode = document.getElementById('txt_reasoncode').value;
//        if (reasoncode == "") {
//            alert("Enter Reason Code");
//            return false;

//        }
//        var reasondesc = document.getElementById('txt_reasondesc').value;
//        if (reasondesc == "") {
//            alert("Enter Reason Description");
//            return false;

//        }
        var sno = document.getElementById('txtsno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_cash_requisition', 'reqno': reqno, 'reqdate': reqdate, 'finyear': finyear, 'designation':designation,'Employeecode':Employeecode,'availamount':availamount,'deptcode':deptcode,'reqamount':reqamount,'particulars':particulars,'btnVal': btnval, 'sno': sno };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                     get_suspensecash_requisition();
                    clearcash();
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
    function clearcash()
    {
        //document.getElementById('slct_ctype').selectedIndex = 0;
        document.getElementById('txt_reqno').value = "";
        document.getElementById('slct_desig').selectedIndex = 0;
        document.getElementById('dt_reqdate').value = "";
        document.getElementById('txt_finyr').value = "";
       // document.getElementById('txt_descr').value = "";
       // document.getElementById('txt_accode').selectedIndex = 0;
       // document.getElementById('txt_acdesc').value = "";
        document.getElementById('avail_amt').value = "";
       // document.getElementById('txt_costdesc').value = "";
      //  document.getElementById('txt_budgetdesc').value = "";
        document.getElementById('txt_part').value = "";
        //document.getElementById('txt_reasoncode').value = "";
        //document.getElementById('txt_reasondesc').value = "";
        document.getElementById('slct_empcode').selectedIndex = 0;
        document.getElementById('txt_deptcode').value = "";
       // document.getElementById('slct_cc').selectedIndex = 0;
       // document.getElementById('slct_budgetcode').selectedIndex = 0;
        document.getElementById('txt_reqamt').value = "";
        document.getElementById('btn_save').value = "Save";
        get_financial_year();
    }
    function get_suspensecash_requisition() {
        var data = { 'op': 'get_suspensecash_requisition' };
        var s = function (msg)
        {
            if (msg) {
                if (msg.length > 0) {
                    fillcashdetails(msg);
                   

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
    function fillcashdetails(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Reqno</th><th scope="col">ReqDate</th><th scope="col">Financialyear</th><th scope="col">Designation</th><th scope="col">Empcode</th><th scope="col">AvailableAmount</th><th scope="col">DeptCode</th><th scope="col">ReqAmount</th><th scope="col">Particulars</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].reqno + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].reqdate + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].finyear + '</td>';
            results += '<td data-title="code" class="8">' + msg[i].designation + '</td>';
            results += '<td data-title="code" class="10">' + msg[i].empcode + '</td>';
            results += '<td data-title="code" class="12">' + msg[i].availamount + '</td>';
            results += '<td data-title="code" class="13">' + msg[i].deptcode + '</td>';
            results += '<td data-title="code" class="19">' + msg[i].reqamount + '</td>';
            results += '<td data-title="code" class="20">' + msg[i].particulars + '</td>';
            results += '<td style="display:none" class="24">' + msg[i].deptid + '</td>';
            results += '<td style="display:none" class="25">' + msg[i].desigid + '</td>';
            results += '<td style="display:none" class="31">' + msg[i].empid + '</td>';
            results += '<td style="display:none" class="23">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_suspensecash").html(results);
    }
    function getme(thisid) {
        var reqno = $(thisid).parent().parent().children('.1').html();
        var reqdate = $(thisid).parent().parent().children('.2').html();
        var finyear = $(thisid).parent().parent().children('.3').html();
     //   var controltype = $(thisid).parent().parent().children('.28').html();
      //  var description = $(thisid).parent().parent().children('.5').html();
     //   var accountcode = $(thisid).parent().parent().children('.26').html();
     //   var acdescription = $(thisid).parent().parent().children('.7').html();
        var designation = $(thisid).parent().parent().children('.25').html();
        var empcode = $(thisid).parent().parent().children('.31').html();
        var availamount = $(thisid).parent().parent().children('.12').html();
        var deptcode = $(thisid).parent().parent().children('.24').html();
      //  var costcenter = $(thisid).parent().parent().children('.30').html();
      //  var costdesc = $(thisid).parent().parent().children('.16').html();
      //  var budgetcode = $(thisid).parent().parent().children('.27').html();
      //  var budgetdesc = $(thisid).parent().parent().children('.18').html();
        var reqamount = $(thisid).parent().parent().children('.19').html();
        var particulars = $(thisid).parent().parent().children('.20').html();
      //  var reasoncode = $(thisid).parent().parent().children('.21').html();
       // var reasondesc = $(thisid).parent().parent().children('.29').html();
        var sno = $(thisid).parent().parent().children('.23').html();

       
        document.getElementById('txt_reqno').value = reqno;
        document.getElementById('dt_reqdate').value = reqdate;
        document.getElementById('txt_finyr').value = finyear;
       // document.getElementById('slct_ctype').value = controltype;
       // document.getElementById('txt_descr').value = description;
        //document.getElementById('txt_accode').selectedIndex = accountcode;
        //document.getElementById('txt_acdesc').value = acdescription;
        document.getElementById('slct_desig').selectedIndex = designation;
        document.getElementById('avail_amt').value = availamount;
       // document.getElementById('txt_costdesc').value = costdesc;
       // document.getElementById('txt_budgetdesc').value = budgetdesc;
        document.getElementById('txt_part').value = particulars;
       // document.getElementById('txt_reasoncode').value = reasoncode;
       // document.getElementById('txt_reasondesc').value = reasondesc;
        document.getElementById('slct_empcode').value = empcode;
        document.getElementById('txt_deptcode').selectedIndex = deptcode;
        //document.getElementById('slct_cc').selectedIndex = costcenter;
       // document.getElementById('slct_budgetcode').selectedIndex = budgetcode;
        document.getElementById('txt_reqamt').value = reqamount;
        document.getElementById('btn_save').value = "Modify";
        document.getElementById('txtsno').value = sno;
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Suspense Cash Requisition
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Transactions</a></li>
            <li><a href="#">Cash Requisition</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Suspense Cash Requisition
                </h3>
            </div>
            <div class="box-body">
                <div id="divscr">
                </div>
                <div id='fillform'>
                    <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Requisition No</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_reqno" class="form-control" placeholder="Enter Requisition No"  type="text" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Requisition Date
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="dt_reqdate" class="form-control" type="date" />
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Financial year
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_finyr" class="form-control" type="text" />
                            </td>
                        </tr>
                     <%--   <tr>
                            <td>
                                <label>
                                    Control Type</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_ctype" class="form-control" type="text">
                                </select>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Description</label>
                            </td>
                            <td>
                                <textarea rows="2" cols="10" id="txt_descr" class="form-control" maxlength="1000"
                                    placeholder="Enter Description"></textarea>
                            </td>
                        </tr>--%>
                       <%-- <tr>
                            <td>
                                <label>
                                    Account Code</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_accode" class="form-control"></select>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Description</label>
                            </td>
                            <td>
                                <textarea rows="2" cols="10" id="txt_acdesc" class="form-control" maxlength="1000"
                                    placeholder="Enter Description"></textarea>
                            </td>
                        </tr>--%>
                        <tr>
                            <td>
                                <label>
                                    Designation
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_desig" class="form-control" onchange="get_available_amount()">
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Employee code
                                </label>
                            </td>
                            <td>
                                <select id="slct_empcode" class="form-control">
                                </select>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Available Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="avail_amt" placeholder="Enter Available Amount" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Department Code
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <select id="txt_deptcode" class="form-control"></select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                       <%-- <tr>
                            <td>
                                <label>
                                    Cost center</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_cc" class="form-control" type="text">
                                </select>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Description</label>
                            </td>
                            <td>
                                <textarea rows="2" cols="10" id="txt_costdesc" class="form-control" maxlength="1000"
                                    placeholder="Enter Description"></textarea>
                            </td>
                        </tr>--%>
                      <%--  <tr>
                            <td>
                                <label>
                                    Budget Code</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_budgetcode" class="form-control" type="text">
                                </select>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Description</label>
                            </td>
                            <td>
                                <textarea rows="2" cols="10" id="txt_budgetdesc" class="form-control" maxlength="1000"
                                    placeholder="Enter Description"></textarea>
                            </td>
                        </tr>--%>
                        <tr>
                            <td>
                                <label>
                                    Req. Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_reqamt" placeholder="Enter Requisition Amount" class="form-control" type="text" />
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Particulars</label>
                            </td>
                            <td>
                                <textarea rows="2" cols="20" id="txt_part" class="form-control" maxlength="2000"
                                    placeholder="Enter Particulars"></textarea>
                            </td>
                        </tr>
                        <%--<tr>
                            <td>
                                <label>
                                    Reason</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_reasoncode" placeholder="Enter Reason" class="form-control" type="text">
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td>
                                <label>
                                    Particulars</label>
                            </td>
                            <td>
                                <textarea rows="2" cols="10" id="txt_reasondesc" class="form-control" maxlength="1000"
                                    placeholder="Enter Particulars"></textarea>
                            </td>
                        </tr>--%>
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
                                    onclick="save_cash_requisition()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Clear'
                                    onclick="clearcash()" />
                            </td>
                        </tr>
                    </table>
                    <div id="">
                    </div>
                </div>
            </div>
            <div id="div_suspensecash">
            </div>
        </div>
    </section>
</asp:Content>
