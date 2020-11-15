<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TDS_Acknowledgement_Entry.aspx.cs" Inherits="TDS_Acknowledgement_Entry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            get_fin_yr_det();
            get_glgroup_details();
            get_tds_acknowledge_details();
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txt_date').val(yyyy + '-' + mm + '-' + dd);
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

        function get_fin_yr_det() {
            var data = { 'op': 'get_financial_year' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_fin_yr_det(msg);
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
        function fill_fin_yr_det(msg) {
            var data = document.getElementById('slct_finyr');
            var length = data.options.length;
            document.getElementById('slct_finyr').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT YEAR";
            opt.value = 0;
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "displaynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].year != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].year;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function get_glgroup_details() {
            var data = { 'op': 'get_glgroup_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillglgroup(msg);
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
        function fillglgroup(msg) {
            var data = document.getElementById('slct_glcode');
            var length = data.options.length;
            document.getElementById('slct_glcode').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT CODE";
            opt.value = 0;
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "displaynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].groupcode != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].groupcode;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function compareDates(date, fromdate) {
            var date = document.getElementById('txt_date').value;
            var expireydate = document.getElementById('txt_from_date').value;
            var dt1 = parseInt(date.substring(8, 10), 10);
            var mon1 = parseInt(date.substring(5, 7), 10);
            var yr1 = parseInt(date.substring(0, 4), 10);
            var dt2 = parseInt(expireydate.substring(8, 10), 10);
            var mon2 = parseInt(expireydate.substring(5, 7), 10);
            var yr2 = parseInt(expireydate.substring(0, 4), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);
            if (date2 < date1) {
                alert("Enter Correct date");
                document.getElementById('txt_from_date').value = "";
                return false;
            }
            else {
            }

        }
        function compareDates2(date, todate) {
            var date = document.getElementById('txt_date').value;
            var expireydate = document.getElementById('txt_to_date').value;
            var dt1 = parseInt(date.substring(8, 10), 10);
            var mon1 = parseInt(date.substring(5, 7), 10);
            var yr1 = parseInt(date.substring(0, 4), 10);
            var dt2 = parseInt(expireydate.substring(8, 10), 10);
            var mon2 = parseInt(expireydate.substring(5, 7), 10);
            var yr2 = parseInt(expireydate.substring(0, 4), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);

            if (date2 < date1) {
                alert("Enter Correct date");
                document.getElementById('txt_to_date').value = "";
                return false;
            }
            else {
            }

        }
        function compareDates3(date, ackn_date) {
            var date = document.getElementById('txt_date').value;
            var expireydate = document.getElementById('txt_ackn_date').value;
            var dt1 = parseInt(date.substring(8, 10), 10);
            var mon1 = parseInt(date.substring(5, 7), 10);
            var yr1 = parseInt(date.substring(0, 4), 10);
            var dt2 = parseInt(expireydate.substring(8, 10), 10);
            var mon2 = parseInt(expireydate.substring(5, 7), 10);
            var yr2 = parseInt(expireydate.substring(0, 4), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);

            if (date2 < date1) {
                alert("Enter Correct date");
                document.getElementById('txt_ackn_date').value = "";
                return false;
            }
            else {
            }
        }
        function save_tds_acknowledge_details() {
            var fin_year = document.getElementById('slct_finyr').value;
            if (fin_year == "") {
                alert("Please select financial year");
                return false;
            }
            var from_date = document.getElementById('txt_from_date').value;
            if (from_date == "") {
                alert("Please select from date");
                return false;
            }
            var to_date = document.getElementById('txt_to_date').value;
            if (to_date == "") {
                alert("Please select to date");
                return false;
            }
            var glcode = document.getElementById('slct_glcode').value;
            if (glcode == "") {
                alert("Please select GL code");
                return false;
            }
            var type = document.getElementById('slct_type').value;
            if (type == "") {
                alert("Please select the type");
                return false;
            }
            var qtr_no = document.getElementById('txt_qtr_no').value;
            if (qtr_no < 1 || qtr_no > 4) {
                alert("Please enter qtr_no value between 1 to 4 only");
                return false;
            }
            var ackn_no = document.getElementById('txt_ackn_no').value;
            if (ackn_no == "") {
                alert("Please enter acknowledgement number");
                return false;
            }
            var ackn_date = document.getElementById('txt_ackn_date').value; 
            if (ackn_date == "") {
                alert("Please select acknowledgement date");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btn_save = document.getElementById('btn_save').value;
            var data = { 'op': 'save_tds_acknowledge_details', 'sno': sno, 'fin_year': fin_year, 'from_date': from_date, 'to_date': to_date, 'glcode': glcode, 'type': type, 'qtr_no': qtr_no, 'ackn_no': ackn_no, 'ackn_date': ackn_date, 'btn_save': btn_save };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_tds_acknowledge_details();
                        clear_tds_acknowledge_Details();
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
        function get_tds_acknowledge_details() {
            var data = { 'op': 'get_tds_acknowledge_details' };
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
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">Financial Year</th><th scope="col">From Date</th><th scope="col">To Date</th><th scope="col">GL Code</th><th scope="col">Type</th><th scope="col">QTR No.</th><th scope="col">Acknowledgement No</th><th scope="col">Acknowledgement Date</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="Financial Year"  class="2">' + msg[i].fin_year + '</td>';
                results += '<td style="display:none" data-title=""  class="11">' + msg[i].fin_year1 + '</td>';
                results += '<td data-title="From Date" class="3">' + msg[i].from_date + '</td>';
                results += '<td data-title="To Date" class="4">' + msg[i].to_date + '</td>';
                results += '<td data-title="GL Code" class="5">' + msg[i].glcode + '</td>';
                results += '<td style="display:none" data-title=""  class="12">' + msg[i].glcode1 + '</td>';
                results += '<td data-title="Type" class="6">' + msg[i].type + '</td>';
                results += '<td data-title="QTR No." class="7">' + msg[i].qtr_no + '</td>';
                results += '<td data-title="Acknowledgement No" class="8">' + msg[i].ackn_no + '</td>';
                results += '<td data-title="Acknowledgement Date" class="9">' + msg[i].ackn_date + '</td>';
                results += '<td style="display:none" data-title="" class="10">' + msg[i].sno + '</td>';
            }
            results += '</table></div>';
            $("#div_tds_ackn_type").html(results);
        }
        function getme(thisid) {
            var fin_year = $(thisid).parent().parent().children('.2').html();
            var fin_year1 = $(thisid).parent().parent().children('.11').html();
            var from_date = $(thisid).parent().parent().children('.3').html();
            var to_date = $(thisid).parent().parent().children('.4').html();
            var glcode = $(thisid).parent().parent().children('.5').html();
            var glcode1 = $(thisid).parent().parent().children('.12').html();
            var type = $(thisid).parent().parent().children('.6').html();
            var qtr_no = $(thisid).parent().parent().children('.7').html();
            var ackn_no = $(thisid).parent().parent().children('.8').html();
            var ackn_date = $(thisid).parent().parent().children('.9').html();
            var sno = $(thisid).parent().parent().children('.10').html();

            document.getElementById('slct_finyr').value = fin_year1;
            document.getElementById('txt_from_date').value = from_date;
            document.getElementById('txt_to_date').value = to_date;
            document.getElementById('slct_glcode').value = glcode1;
            document.getElementById('slct_type').value = type;
            document.getElementById('txt_qtr_no').value = qtr_no;
            document.getElementById('txt_ackn_no').value = ackn_no;
            document.getElementById('txt_ackn_date').value = ackn_date;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            $("#fillform").show();
            $('#showlogs').hide();
        }

        function clear_tds_acknowledge_Details() {
            document.getElementById('slct_finyr').selectedIndex = 0;
            document.getElementById('txt_from_date').value = "";
            document.getElementById('slct_glcode').selectedIndex = 0;
            document.getElementById('txt_to_date').value = "";
            document.getElementById('slct_type').selectedIndex = 0;
            document.getElementById('txt_qtr_no').value = "";
            document.getElementById('txt_ackn_no').value = "";
            document.getElementById('txt_ackn_date').value = "";
            document.getElementById('btn_save').value = "Save";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            TDS Acknowledgement
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">TDS Acknowledgement</a></li>
        </ol>
    </section>
        <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>TDS Acknowledgement
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
                                            Financial Year</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <%--<input id="txt_ptype" type="text" maxlength="45" class="form-control" placeholder="Enter Party Type" /><label
                                            id="Label1" class="errormessage">* Please Enter Party
                                        </label>--%>
                                        <select id="slct_finyr">
                                        <option value="Select year">Select year</option>
                                        </select>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            From Date</label>
                                    </td>
                                    <td>
                                        <input id="txt_from_date" class="form-control" type="date" name="from_date" onblur="compareDates();"/>
                                    </td>
                                    <td style="height: 40px;">
                                        <label>
                                            To Date</label>
                                    </td>
                                    <td>
                                        <input id="txt_to_date" class="form-control" type="date" name="to_date" onblur="compareDates2();"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            GL Code</label>
                                    </td>
                                    <td>
                                        <select id="slct_glcode">
                                        <option value="Select code">Select code</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Type</label>
                                    </td>
                                    <td>
                                        <select id="slct_type">
                                        <option value="Select type">Select type</option>
                                            <option value="1">26Q</option>
                                            <option value="2">24Q</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Qtr No.</label>
                                    </td>
                                    <td>
                                        <input id="txt_qtr_no" class="form-control" placeholder="Enter QTR No" type="text" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Acknowledgement No.</label>
                                    </td>
                                    <td>
                                        <input id="txt_ackn_no" class="form-control" placeholder="Enter Acknowledgement No" type="text" />
                                    </td>
                                    <td style="height: 40px;">
                                        <label>
                                            Acknowledgement Date</label>
                                    </td>
                                    <td>
                                        <input id="txt_ackn_date" class="form-control" type="date" onblur="compareDates3();"/>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                            <td>
                            
                                <label>
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" type="date" class="form-control"  />
                                
                            </td>
                            </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_tds_acknowledge_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_tds_acknowledge_Details();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_tds_ackn_type">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
</asp:Content>

