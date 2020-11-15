<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Finance.aspx.cs" Inherits="Finance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        $("#divbank").css("display", "block");
        get_financial_year();
        get_month_master();
        clear_month();
        clear_all();
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
        function showbrfdrdetails() {
            $("#divbank").css("display", "block");
            $("#divmonth").css("display", "none");
            $('#showlogs').css('display', 'none');
            $('#div_SectionData1').show();
            $('#div_inwardtable1').show();
        }
        function showbankdetails() {
            $("#divbank").css("display", "none");
            $("#divmonth").css("display", "block");
            $('#showlogs2').css('display', 'block');
            $('#div_SectionData2').show();
            $('#div_inwardtable2').show();
            get_month_master();
            clear_all();
            clear_month();

        }
        function save_financial_year() {
            var currentyear = "";
            var Acclosed = "";
            var startdate = document.getElementById('dt_start').value;
            if (startdate == "") {
                alert("Enter startdate ");
                return false;

            }
            var Enddate = document.getElementById('dt_end').value;
            if (Enddate == "") {
                alert("Enter End date ");
                return false;

            }
            var year = document.getElementById('dt_year').value;
            if (document.getElementById('chk_cyear').checked == true) {
                currentyear = document.getElementById('chk_cyear').checked;
            }
            if (document.getElementById('chk_acclosed').checked == true) {
                Acclosed = document.getElementById('chk_acclosed').checked;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_financial_year', 'startdate': startdate, 'Enddate': Enddate, 'year': year, 'currentyear': currentyear, 'Acclosed': Acclosed, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_financial_year();
                        clear_all();
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
        function getyear() {
            var startdate2 = document.getElementById('dt_start').value;
            var Enddate2 = document.getElementById('dt_end').value;
            var startyr = startdate2.substring(2, 4);
            var endyr = Enddate2.substring(2, 4);
            document.getElementById("dt_year").value = "" + startyr + "-" + endyr;
        }
        function clear_all() {
            document.getElementById('dt_start').value = "";
            document.getElementById('dt_end').value = "";
            document.getElementById('dt_year').value = "";
            document.getElementById('chk_cyear').checked = "";
            document.getElementById('chk_acclosed').checked = "";
            document.getElementById('btn_save').value = "Save";
        }
        function get_financial_year() {
            var data = { 'op': 'get_financial_year' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillfinyeardetails(msg);

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
        function fillfinyeardetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">StartDate</th><th scope="col">Enddate</th><th scope="col">year</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1">' + msg[i].startdate + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].Enddate + '</td>';
                results += '<td data-title="code" class="3">' + msg[i].year + '</td>';
                results += '<td style="display:none"  data-title="code" class="5">' + msg[i].currentyear + '</td>';
                results += '<td style="display:none" data-title="code" class="6">' + msg[i].acclosed + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable1").html(results);
        }
        function getme(thisid) {

            $("#divbank").css("display", "block");
            $("#divmonth").css("display", "none");
            $('#div_SectionData1').show();
            $('#newrow1').css('display', 'none');
            var startdate = $(thisid).parent().parent().children('.1').html();
            var Enddate = $(thisid).parent().parent().children('.2').html();
            var year = $(thisid).parent().parent().children('.3').html();
            var currentyear = $(thisid).parent().parent().children('.5').html();
            var acclosed = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.4').html();

            document.getElementById('dt_start').value = startdate;
            document.getElementById('dt_end').value = Enddate;
            document.getElementById('dt_year').value = year;
            document.getElementById('chk_cyear').checked = currentyear;
            document.getElementById('chk_acclosed').checked = acclosed;
            document.getElementById('btn_save').value = "Modify";
            document.getElementById('lbl_sno').value = sno;
        }
        function save_month_master() {
            var monthno = document.getElementById('txt_monthno').value;
            if (monthno == "") {
                alert("Enter monthno ");
                return false;
            }
            var monthname = document.getElementById('txt_month').value;
            if (monthname == "") {
                alert("Enter Name of the Month");
                return false;
            }
            var sequenceno = document.getElementById('txt_seqno').value;
            if (sequenceno == "") {
                alert("Enter Sequence Number");
                return false;
            }
            var sno = document.getElementById('lbl_sno2').value;
            var btnval = document.getElementById('btn_savemonth').value;
            var data = { 'op': 'save_month_master', 'monthno': monthno, 'monthname': monthname, 'sequenceno': sequenceno, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_month_master();
                        clear_month();
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
        function clear_month() {
            document.getElementById('txt_monthno').value = "";
            document.getElementById('txt_month').value = "";
            document.getElementById('txt_seqno').value = "";
            document.getElementById('btn_savemonth').value = "Save";
        }
        function get_month_master() {
            var data = { 'op': 'get_month_master' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillmonthdetails(msg);

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
        function fillmonthdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">MonthNo</th><th scope="col">MonthName</th><th scope="col">SequenceNo</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme1(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1">' + msg[i].monthno + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].monthname + '</td>';
                results += '<td data-title="code" class="3">' + msg[i].sequenceno + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_inwardtable2").html(results);
        }
        function getme1(thisid) {

            $("#divbank").css("display", "none");
            $("#divmonth").css("display", "block");
            $('#div_SectionData2').show();
            $('#newrow2').css('display', 'none');

            var monthno = $(thisid).parent().parent().children('.1').html();
            var monthname = $(thisid).parent().parent().children('.2').html();
            var sequenceno = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.4').html();
            document.getElementById('txt_monthno').value = monthno;
            document.getElementById('txt_month').value = monthname;
            document.getElementById('txt_seqno').value = sequenceno;
            document.getElementById('btn_savemonth').value = "Modify";
            document.getElementById('lbl_sno2').value = sno;
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Financial Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#"> Financial Master</a></li>
        </ol>
    </section>
     <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showbrfdrdetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Financial Year Details </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showbankdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Financial Month Details </a></li>
                </ul>
            </div>
            <div id="divbank" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Financial Year Details
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
                                    <td style="height: 40px;">
                                        <label>
                                            Start Date</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="dt_start" type="date"  class="form-control"  />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           End Date</label>
                                    </td>
                                    <td>
                                        <input id="dt_end" type="date"  class="form-control" onchange="getyear();"  />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           year</label>
                                    </td>
                                    <td>
                                        <input id="dt_year" class="form-control" readonly />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Current Year</label>
                                    </td>
                                    <td>
                                        <input id="chk_cyear" name="check" type="checkbox" value="C" />
                                    </td>
                                    <td style="height: 40px;">
                                        <label>
                                           A/C Closed</label>
                                    </td>
                                    <td>
                                        <input id="chk_acclosed" name="check" type="checkbox" value="A"  />
                                    </td>
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_financial_year();">
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
                            </div>
                    <div class="box-body">
                                        <div id="div_inwardtable1">
                                        </div>
                                    </div>
                                </div>
                        </div>
                <div id="divmonth" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Financial Month Details 
                        </h3>
                    </div>
                    <div>
                     <div id='showlogs2' style="display: none;">
                    <table align="center" style="width: 60%;">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Month</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_monthno" type="text"  class="form-control" placeholder="Enter No.of month" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                        <input id="txt_month" type="text"  class="form-control" placeholder="Enter Month name" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Sequence No</label>
                                    </td>
                                    <td>
                                          <input id="txt_seqno" type="text"  class="form-control" placeholder="Enter Sequence Number" />
                                    </td>
                                </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_savemonth" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_month_master();">
                                        <input id="btn_clrmonth" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_month();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno2">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            </div>
                            <div>
                    <div id="div_inwardtable2">
                    </div>
                </div>
            </div>
            </div>
              </div>
    </section>
</asp:Content>

