<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Party_Master.aspx.cs" Inherits="Party_Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function ()
        {
            $("#divparty").css("display", "block");
            get_party_details();
            get_party_master();
            get_glgroup_details();
            //get_tax1_details();
            //GetFixedrows();
            emptytable2 = [];
            get_group_ledger();
            get_party_type_details();
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
        function isFloat(evt) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            else {
                var parts = evt.srcElement.value.split('.');
                if (parts.length > 1 && charCode == 46)
                    return false;
                return true;
            }
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        var gldetails = [];
        function get_group_ledger()
        {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg)
            {
                if (msg) {
                    gldetails = msg;
                    var glList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var glname = msg[i].groupshortdesc;
                        glList.push(glname);
                    }
                    $('#slct_glcode').autocomplete({
                        source: glList,
                        change: getglid,
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
        function getglid()
        {
            var glecode = document.getElementById('slct_glcode').value;
            for (var i = 0; i < gldetails.length; i++) {
                if (glecode == gldetails[i].groupshortdesc) {
                    document.getElementById('txt_glid').value = gldetails[i].sno;
                    document.getElementById('txt_glcode').value = gldetails[i].groupcode;
                }
            }
        }
        function save_party_type_details()
        {
            var ptype = document.getElementById('txt_ptype').value;
            if (ptype == "") {
                alert("Please Enter Party Type");
                return false;
            }
            var desc = document.getElementById('txt_des').value;
            var glcodeid = document.getElementById('txt_glid').value;
            var glcodeType = document.getElementById('slct_glcode').value;
            if (desc == "") {
                alert("Enter  description");
                return false;
            }
            if (glcodeType == "") {
                alert("Enter  gl code Type");
                return false;
            }
            var glcode = document.getElementById('txt_glcode').value;
            if (glcode == "") {
                alert("Enter  gl code");
                return false;
            }
            var btn_val = document.getElementById('btn_save').value;
            var data = { 'op': 'save_party_type_details', 'partytype': ptype, 'description': desc, 'glcodeid': glcodeid, 'glcode': glcode, 'btn_val': btn_val };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_party_type_details();
                        clear_party_type_Details();
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


        function get_party_type_details()
        {
            var data = { 'op': 'get_party_type_details' };
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
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"><th scope="col">PARTY_TP</th><th scope="col">SHORT_DESC</th><th scope="col">GL_CODE</th><th scope="col">GROUP_CD</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getparty(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="PARTY_TP"  class="2">' + msg[i].PARTY_TP + '</td>';
                results += '<td data-title="SHORT_DESC" class="3">' + msg[i].SHORT_DESC + '</td>';
                results += '<td data-title="groupcode"  class="6">' + msg[i].groupcode + '</td>';
                results += '<td data-title="groupdesc" class="7">' + msg[i].groupdesc + '</td>';
                results += '<td  style="display:none" data-title="GL_CODE" class="4">' + msg[i].GL_CODE + '</td>';
                results += '<td style="display:none" data-title="GROUP_CD" class="5">' + msg[i].GROUP_CD + '</td>';
            }
            results += '</table></div>';
            $("#div_party_type").html(results);
        }
        function getparty(thisid)
        {
            var PARTY_TP = $(thisid).parent().parent().children('.2').html();
            var glid = $(thisid).parent().parent().children('.4').html();
            var gldesc = $(thisid).parent().parent().children('.7').html();
            var SHORT_DESC = $(thisid).parent().parent().children('.3').html();
            var GL_CODE = $(thisid).parent().parent().children('.6').html();
            var GROUP_CD = $(thisid).parent().parent().children('.5').html();

            document.getElementById('txt_ptype').value = PARTY_TP;
            document.getElementById('txt_des').value = SHORT_DESC;
            document.getElementById('slct_glcode').value = gldesc;
            document.getElementById('txt_glcode').value = GL_CODE;
            document.getElementById('txt_glid').value = glid;
            document.getElementById('btn_save').value = "Modify";
        }
        function clear_party_type_Details()
        {
            document.getElementById('txt_ptype').value = "";
            document.getElementById('txt_des').value = "";
            document.getElementById('slct_glcode').value = "";
            document.getElementById('txt_glcode').value = "";
            document.getElementById('btn_save').value = "Save";
        }
        var branchname = [];
        function get_glgroup_details() {
            var data = { 'op': 'get_group_ledger' };
            var s = function (msg) {
                if (msg) {
                    branchname = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].groupshortdesc;
                        empnameList.push(empname);
                    }
                    $('#txt_gl_group_desc').autocomplete({
                        source: empnameList,
                        change: Getgroupcode1,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getgroupcode1() {
            var empname = document.getElementById('txt_gl_group_desc').value;
            for (var i = 0; i < branchname.length; i++) {
                if (empname == branchname[i].groupshortdesc) {
                    document.getElementById('txt_gl_id').value = branchname[i].sno;
                    document.getElementById('txt_gl_group').value = branchname[i].groupcode;
                }
            }
        }

        var partyname = [];
        function get_party_details() {
            var data = { 'op': 'get_party_type_details' };
            var s = function (msg) {
                if (msg) {
                    partyname = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].PARTY_TP;
                        empnameList.push(empname);
                    }
                    $('#txt_party_tp').autocomplete({
                        source: empnameList,
                        change: Getgroupcode,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getgroupcode() {
            var empname = document.getElementById('txt_party_tp').value;
            for (var i = 0; i < partyname.length; i++) {
                if (empname == partyname[i].PARTY_TP) {
                    document.getElementById('txt_party_tp_sno').value = partyname[i].sno;
                    //document.getElementById('txt_gl_group').value = partyname[i].groupcode;
                }
            }
        }

        //function get_party_details() {
        //    var data = { 'op': 'get_party_type_details' };
        //    var s = function (msg) {
        //        if (msg) {
        //            if (msg.length > 0) {
        //                fillpartytypedetails(msg);
        //            }
        //        }
        //        else {
        //        }
        //    };
        //    var e = function (x, h, e) {
        //    };
        //    $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        //    callHandler(data, s, e);
        //}
        //function fillpartytypedetails(msg) {
        //    //var data = document.getElementById('slct_party_tp');
        //    //var length = data.options.length;
        //    //document.getElementById('slct_party_tp').options.length = null;
        //    //var opt = document.createElement('option');
        //    //opt.innerHTML = "SELECT CODE";
        //    //opt.value = "SELECT CODE";
        //    //opt.setAttribute("selected", "selected");
        //    //opt.setAttribute("disabled", "disabled");
        //    //opt.setAttribute("class", "displaynone");
        //    //data.appendChild(opt);
        //    //for (var i = 0; i < msg.length; i++) {
        //    //    if (msg[i].PARTY_TP != null) {
        //    //        var option = document.createElement('option');
        //    //        option.innerHTML = msg[i].PARTY_TP;
        //    //        option.value = msg[i].sno;
        //    //        data.appendChild(option);
        //    //    }
        //    //}
        //    var partyList = [];
        //    for (var i = 0; i < msg.length; i++) {
        //        var productname = msg[i].PARTY_TP;
        //        partyList.push(productname);
        //    }

        //    $('#txt_gl_group_desc').autocomplete({
        //        source: partyList,
        //        change: partydet,
        //        autoFocus: true
        //    });
        //}

        //var emptytable1 = [];
        //function partydet() {
        //    var productname = $(this).val();
        //    var checkflag = true;
        //    if (emptytable1.indexOf(productname) == -1) {
        //        for (var i = 0; i < filldescrption.length; i++) {
        //            if (productname == filldescrption[i].groupshortdesc) {
        //                $(this).closest('tr').find('#txt_glid').val(filldescrption[i].sno);
        //                //$(this).closest('tr').find('#txt_gl_group').val(filldescrption[i].groupcode);
        //                emptytable.push(productname);
        //            }
        //        }
        //    }
        //}

        $(document).click(function () {
            //$('#tabledetails').on('change', '.clscode2', calTotal2)
        });
        //var filldescrption = [];
        //function get_glgroup_details() {
        //    var data = { 'op': 'get_group_ledger' };
        //    var s = function (msg) {
        //        if (msg) {
        //            if (msg.length > 0) {
        //                filldata(msg);
        //                filldescrption = msg;
        //            }
        //            else {
        //            }
        //        }
        //        else {
        //        }
        //    };
        //    var e = function (x, h, e) {
        //    }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        //    callHandler(data, s, e);
        //}
        //function filldata(msg) {
        //    var compiledList = [];
        //    for (var i = 0; i < msg.length; i++) {
        //        var productname = msg[i].groupshortdesc;
        //        compiledList.push(productname);
        //    }

        //    $('#txt_gl_group_desc').autocomplete({
        //        source: compiledList,
        //        change: calTotal2,
        //        autoFocus: true
        //    });
        //}
        //var emptytable = [];
        //function calTotal2() {
        //    var productname = $(this).val();
        //    var checkflag = true;
        //    if (emptytable.indexOf(productname) == -1) {
        //        for (var i = 0; i < filldescrption.length; i++) {
        //            if (productname == filldescrption[i].groupshortdesc) {
        //                $(this).closest('tr').find('#txt_glid').val(filldescrption[i].sno);
        //                $(this).closest('tr').find('#txt_gl_group').val(filldescrption[i].groupcode);
        //                emptytable.push(productname);
        //            }
        //        }
        //    }
        //}
        //function GetFixedrows() {
        //    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
        //    results += '<thead><tr><th scope="col">Sno</th><th scope="col">GL Code</th><th scope="col">Description</th></tr></thead></tbody>';
        //    for (var i = 1; i < 3; i++) {
        //        results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
        //        results += '<td ><input id="slct_gl_code" class="clscode2"  placeholder="Enter GL Code" style="width:140px;" /></td>';
        //        results += '<td ><input id="txt_desc" type="text" class="clsDescription"  style="width:400px;"/></td>';
        //        results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
        //        results += '<td ><input id="txt_glid" type="hidden" class="clsDescription" /></td>';
        //        results += '<td ><input id="txt_sno" type="hidden" /></td></tr>';
        //    }
        //    results += '</table></div>';
        //    $("#div_insert_row").html(results);
        //}
        //var DataTable;
        //function insertrow() {
        //    DataTable = [];
        //    get_glgroup_details();
        //    var txtsno = 0;
        //    gl_code = 0;
        //    desc = 0;
        //    var rows = $("#tabledetails tr:gt(0)");
        //    var rowsno = 1;
        //    $(rows).each(function (i, obj) {
        //        txtsno = rowsno;
        //        gl_code = $(this).find('#slct_gl_code').val();
        //        desc = $(this).find('#txt_desc').val();
        //        DataTable.push({ Sno: txtsno, gl_code: gl_code, desc: desc});
        //        rowsno++;

        //    });
        //    gl_code = 0;
        //    desc = 0;
        //    sno = 0;
        //    var Sno = parseInt(txtsno) + 1;
        //    DataTable.push({ Sno: Sno, gl_code: gl_code, desc: desc});
        //    var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
        //    results += '<thead><tr><th scope="col">Sno</th><th scope="col">GL Code</th><th scope="col">Description</th></tr></thead></tbody>';
        //    for (var i = 0; i < DataTable.length; i++) {
        //        results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
        //        results += '<td ><input id="slct_gl_code"  class="clscode2"  style="width:140px;" placeholder="Enter GL Code"  value="' + DataTable[i].gl_code + '"/></td>';
        //        results += '<td ><input id="txt_desc" type="text" class="clsDescription" style="width:400px;" value="' + DataTable[i].desc + '"/></td>';
        //        results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
        //        results += '<td data-title="From"><input class="form-control" type="hidden" class="clsDescription" id="txt_glid"  name="" value="' + DataTable[i].glid + '" ></input></td>';
        //        results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="" value="' + DataTable[i].sno + '" ></input></td></tr>';
        //        //results += '<td style="display:none" class="4">' + i + '</td></tr>';
        //    }
        //    results += '</table></div>';
        //    $("#div_insert_row").html(results);
        //}
        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
        var replaceHtmlEntites = (function () {
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();
        function save_party_master() {
            //var DataTable = [];
            //var count = 0;
            //var rows = $("#tabledetails tr:gt(0)");
            //var rowsno = 1;
            //$(rows).each(function (i, obj) {
            //    gl_code = $(this).find('#slct_gl_code').val();
            //    desc = $(this).find('#txt_desc').val();
            //    sno = $(this).find('#txt_sno').val();
            //    glid = $(this).find('#txt_glid').val();
            //    var abc = { gl_code: gl_code, desc: desc, sno: sno, glid: glid };
            //    if (desc == "" || desc == "0") { // || desc == "undefined"
            //    }
            //    else {
            //        var abc = { gl_code: gl_code, desc: desc, sno: sno, glid: glid };
            //        DataTable.push(abc);
            //    }
            //});

            var party_tp1 = document.getElementById('txt_party_tp').value;
            if (party_tp1 == "") {
                alert("Please enter party type");
                return false;
            }
            var party_tp = document.getElementById('txt_party_tp_sno').value;
            if (party_tp == "") {
                alert("Please enter party type");
                return false;
            }
            var party_code = document.getElementById('txt_party_code').value;
            if (party_code == "") {
                alert("Please enter party code");
                return false;
            }
            var party_name = document.getElementById('txt_party_name').value;
            if (party_name == "") {
                alert("Please enter party name");
                return false; 
            } 
            var gl_group = document.getElementById('txt_gl_group').value;
            var gl_id = document.getElementById('txt_gl_id').value;
            if (gl_id == "") {
                alert("Please enter group ledger code");
                return false;
            }
            if (gl_group == "") {
                alert("Please enter group ledger code");
                return false;
            }
            var gl_group_desc = document.getElementById('txt_gl_group_desc').value;
            if (gl_group_desc == "") {
                alert("Please enter group ledger desc");
                return false;
            }
            var address = document.getElementById('txt_addr').value;
            if (address == "") {
                alert("Please enter address");
                return false;
            }
            var state = document.getElementById('txt_state').value;
            if (state == "") {
                alert("Please enter state");
                return false;
            }
            var pin = document.getElementById('txt_pin').value;
            if (pin == "") {
                alert("Please enter pin number");
                return false;
            }
            var phone = document.getElementById('txt_phone').value;
            if (phone == "") {
                alert("Please enter mobile number");
                return false;
            }
            var fax = document.getElementById('txt_fax').value;
            if (fax == "") {
                alert("Please select Party type");
                return false;
            }
            var mail = document.getElementById('txt_mail').value;
            if (mail == "") {
                alert("Please select party code");
                return false;
            }
            var tin = document.getElementById('txt_tin').value;
            if (tin == "") {
                alert("Please enter tin number");
                return false;
            }
            var pan = document.getElementById('txt_pan').value;
            if (pan == "") {
                alert("Please enter pan number");
                return false;
            }
            var cst = document.getElementById('txt_cst').value;
            if (cst == "") {
                alert("Please enter cst number");
                return false;
            }
            var status = document.getElementById('slct_status').value;
            if (status == "") {
                alert("Please select the status");
                return false;
            }
            var btn_save = document.getElementById('btn_subparty_save').value; 
            var sno = document.getElementById('lbl_partysno').value; 

            var data = { 'op': 'save_party_master', 'sno': sno, 'gl_id': gl_id, 'gl_group_desc': gl_group_desc, 'party_tp': party_tp, 'party_code': party_code, 'party_name': party_name, 'gl_group': gl_group, 'gl_group_desc': gl_group_desc, 'address': address, 'state': state, 'pin': pin, 'phone': phone, 'fax': fax, 'mail': mail, 'tin': tin, 'pan': pan, 'cst': cst, 'status': status, 'DataTable': DataTable, 'btn_save': btn_save };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        clear_party_master();
                        get_glgroup_details();
                        get_party_master();

                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };

            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(data, s, e);
        }
        function get_party_master() {
            var data = { 'op': 'get_party_master' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_creditnote_tbl1(msg);

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
        function fill_creditnote_tbl1(msg) {
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Party Type</th><th scope="col">Party Code</th><th scope="col">Party Name</th><th scope="col">GL Group Code</th><th scope="col">Description</th><th scope="col">Address</th><th scope="col">State</th><th scope="col">PIN</th><th scope="col">Phone No</th><th scope="col">Fax</th><th scope="col">Mail</th><th scope="col">TIN No</th><th scope="col">PAN No</th><th scope="col">CST No</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="update1(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td data-title="Party Type" class="1" >' + msg[i].party_tp + '</td>';
                results += '<td style="display:none;" class="14" >' + msg[i].party_tp_sno + '</td>';
                results += '<td data-title="Party Code" class="11">' + msg[i].party_code + '</td>';
                results += '<td data-title="Party Name" class="2">' + msg[i].party_name + '</td>';
                //results += '<td data-title="Branch Name" class="13">' + msg[i].branch_name + '</td>';
                results += '<td data-title="GL Group Code" class="3">' + msg[i].gl_group + '</td>';
                results += '<td style="display:none;" class="15">' + msg[i].gl_id + '</td>';
                results += '<td data-title="Description" class="4">' + msg[i].gl_group_desc + '</td>';
                results += '<td data-title="Address" class="5">' + msg[i].address + '</td>';
                results += '<td data-title="State" class="16">' + msg[i].state + '</td>';
                results += '<td data-title="PIN" class="6">' + msg[i].pin + '</td>';
                results += '<td data-title="TIN No" class="17">' + msg[i].tin + '</td>';
                results += '<td data-title="PAN No" class="18">' + msg[i].pan + '</td>';
                results += '<td data-title="CST No" class="19">' + msg[i].cst + '</td>';
                results += '<td data-title="Phone No" class="7">' + msg[i].phone + '</td>';
                results += '<td data-title="Fax" class="12">' + msg[i].fax + '</td>';
                results += '<td data-title="Mail" class="8">' + msg[i].mail + '</td>';
                results += '<td data-title="Status" class="9">' + msg[i].status + '</td>';
                results += '<td style="display:none;" data-title="sno" class="10">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_party_master").html(results);
        }
        function update1(thisid) {
            var party_tp = $(thisid).parent().parent().children('.1').html();
            var party_tp_sno = $(thisid).parent().parent().children('.14').html();
            var party_code = $(thisid).parent().parent().children('.11').html();
            var party_name = $(thisid).parent().parent().children('.2').html();
            var gl_group = $(thisid).parent().parent().children('.3').html();
            var gl_id = $(thisid).parent().parent().children('.15').html();
            var gl_group_desc = $(thisid).parent().parent().children('.4').html();
            var address = $(thisid).parent().parent().children('.5').html(); //.toString[mm / dd / yyyy]
            var state = $(thisid).parent().parent().children('.16').html();
            var pin = $(thisid).parent().parent().children('.6').html();
            var tin = $(thisid).parent().parent().children('.17').html();
            var pan = $(thisid).parent().parent().children('.18').html();
            var cst = $(thisid).parent().parent().children('.19').html();
            var phone = $(thisid).parent().parent().children('.7').html();
            var fax = $(thisid).parent().parent().children('.12').html();
            var mail = $(thisid).parent().parent().children('.8').html();
            var statuscode = $(thisid).parent().parent().children('.9').html();
            if (statuscode == "InActive") {

                var status = "I";
            }
            else {
                var status = "A";
            }
            var sno = $(thisid).parent().parent().children('.10').html();

            document.getElementById('txt_party_tp').value = party_tp;
            document.getElementById('txt_party_tp_sno').value = party_tp_sno;
            document.getElementById('txt_party_code').value = party_code;
            document.getElementById('txt_party_name').value = party_name;
            document.getElementById('txt_gl_group').value = gl_group;
            document.getElementById('txt_gl_id').value = gl_id;
            document.getElementById('txt_gl_group_desc').value = gl_group_desc;
            document.getElementById('txt_addr').value = address;
            document.getElementById('txt_state').value = state;
            document.getElementById('txt_pin').value = pin;
            document.getElementById('txt_tin').value = tin;
            document.getElementById('txt_pan').value = pan;
            document.getElementById('txt_cst').value = cst;
            document.getElementById('txt_phone').value = phone;
            document.getElementById('txt_fax').value = fax;
            document.getElementById('txt_mail').value = mail;
            document.getElementById('slct_status').value = status;
            document.getElementById('lbl_partysno').value = sno;
            document.getElementById('btn_subparty_save').value = "Modify";
            //var data = { 'op': 'get_party_glcode', 'refno': sno };
            //var s = function (msg) {
            //    if (msg) {
            //        if (msg.length > 0) {
            //            fill_invoice_det(msg);
            //            get_glgroup_details();

            //        }
            //    }
            //    else {
            //    }
            //};
            //var e = function (x, h, e) {
            //};
            //$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            //callHandler(data, s, e);
        }

        //function fill_invoice_det(msg) {
        //    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
        //    results += '<thead><tr><th scope="col">Sno</th><th scope="col">GL Code</th><th scope="col">Description</th></tr></thead></tbody>';
        //    for (var k = 0; k < msg.length; k++) {
        //        results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + (k + 1) + '</td>';
        //        results += '<td ><input id="slct_gl_code" class="clscode2" value="' + msg[k].desc + '" style="width:140px;"/></td>';
        //        results += '<td ><input id="txt_desc" type="text"  class="clsDescription" value="' + msg[k].gl_code + '" style="width:400px;"/></td>';
        //        results += '<td data-title="Remove"><span><input type="button" value="Remove"  onclick="removerow(this)" style="cursor:pointer"/></span></td>';
        //        results += '<td ><input  type="hidden" id="txt_glid"  class="form-control" value="' + msg[k].glid + '" class="form-control" /></td>';
        //        results += '<td ><input  type="hidden" id="txt_sno"  class="form-control" value="' + msg[k].sno + '" class="form-control" /></td></tr>';
        //        //results += '<td style="display:block;" id="txt_sno"  value="' + msg[k].sno + '" class="form-control"  style="width:90px;"/></td></tr>';
        //    }
        //    results += '</table></div>';
        //    $("#div_insert_row").html(results);
        //}
        function clear_party_master() {
            document.getElementById('txt_party_code').value = "";
            document.getElementById('txt_party_tp').value = "";
            document.getElementById('txt_party_tp_sno').value = "";
            document.getElementById('txt_party_name').value = "";
            document.getElementById('txt_gl_group').value = "";
            document.getElementById('txt_gl_id').value = "";
            document.getElementById('txt_gl_group_desc').value = "";
            document.getElementById('txt_addr').value = "";
            document.getElementById('txt_state').selectedIndex = 0;
            document.getElementById('txt_pin').value = "";
            document.getElementById('txt_tin').value = "";
            document.getElementById('txt_pan').value = "";
            document.getElementById('txt_cst').value = "";
            document.getElementById('txt_phone').value = "";
            document.getElementById('txt_fax').value = "";
            document.getElementById('txt_mail').value = "";
            document.getElementById('slct_status').selectedIndex = 0;
            document.getElementById('btn_subparty_save').value = "Save";
            get_glgroup_details();
            //GetFixedrows();
        }
        function showpartydetails()
        {
            $("#divparty").css("display", "block");
            $("#divpartytype").css("display", "none");
        }
        function showpartysubdetails()
        {
            $("#divparty").css("display", "none");
            $("#divpartytype").css("display", "block");
            get_party_details();
            get_party_master();
            get_glgroup_details();
            get_tax1_details();
            //GetFixedrows();
            emptytable2 = [];
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="content-header">
        <h1>
            Party Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Party Master</a></li>
        </ol>
    </section>
        <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showpartydetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Party Type </a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showpartysubdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Party Master</a></li>
                </ul>
            </div>
            <div id="divparty" style="display: none;">
            <div>
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Party Type
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_part">
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
                                            Party Type</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_ptype" type="text" maxlength="45" class="form-control" placeholder="Enter Party Type" /><label
                                            id="Label1" class="errormessage">* Please Enter Party
                                        </label>
                                        
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Description</label>
                                    </td>
                                    <td>
                                        <textarea id="txt_des" class="form-control" cols="20" rows="4" placeholder= "Enter Description"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                <td>
                                    <label>
                                        GL Code</label>
                                    <span style="color: red;">*</span>
                                </td>
                                <td >
                                    <input id="slct_glcode" class="form-control" placeholder= "Enter GLCode"></input>
                                    <input id="txt_glid" type="hidden"></input>
                                </td>
                                    <td style="width:5px">
                                    </td>
                                <td style="height: 40px;">
                                    <input id="txt_glcode" class="form-control" type="text" name="glcode" />
                                </td>
                            </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_party_type_details();">
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_party_type_Details();">
                                    </td>
                                </tr>
                                <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_party_type">
                            </div>
                        </div>
                    </div>
                    </div>
                </div>
            <div id="divpartytype" style="display: none;">
                <div>
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>PARTY MASTER
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_pttype">
                        </div>
                        <div id='subfillform'>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Party Type</label>
                                    </td>
                                    <td style="height: 40px;">
                                        <%--<select id="slct_party_tp" class="form-control">
                                        <option value="Select type">Select type</option>
                                        </select>--%>
                                        <input type="text" id="txt_party_tp" class="form-control" placeholder="Enter Party Type" name="party_type" />
                                        <input type="text" id="txt_party_tp_sno" style="display:none" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Party Code</label>
                                    </td>
                                    <td>
                                        <input id="txt_party_code" class="form-control" type="text" placeholder="Enter Party Code" name="party_code"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Party Name
                                        </label>
                                    </td>
                                    <td>
                                        <input id="txt_party_name" class="form-control" type="text" placeholder="Enter Party Name" name="party_name"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Under Group Ledger
                                        </label>
                                    </td>
                                    <td>
                                        <input id="txt_gl_group_desc" onclick="Getgroupcode();" class="form-control" placeholder="Enter Group Ledger"/>
                                        <input id="txt_gl_id" class="form-control" type="text" style="display: none;" />
                                    </td>
                                    <td>
                                        <input id="txt_gl_group" class="form-control" type="text" name="gl_group" placeholder="Group Ledger Code" readonly="readonly"/>
                                    </td>
                                </tr>
                            </table>
                           <%-- <table>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Address Details :</label>
                                    </td>
                                </tr>
                            </table>--%>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Address</label>
                                    </td>
                                    <td>
                                        <textarea id="txt_addr" class="form-control" placeholder="Enter Address" cols="20" rows="4"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            State</label>
                                    </td>
                                    <td>
                                        <select id="txt_state" class="form-control">
                                            <option value="">SELECT STATE</option>
                                            <option value="ANDHRA PRADESH">ANDHRA PRADESH</option>
                                            <option value="TAMILNADU">TAMILNADU</option>
                                            <option value="KARNATAKA">KARNATAKA</option>
                                            <option value="KERALA">KERALA</option>
                                            <option value="MADHYA PRADESH">MADHYA PRADESH</option>
                                            <option value="MAHARASHTRA">MAHARASHTRA</option>
                                            <option value="ORISSA">ORISSA</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            PIN</label>
                                    </td>
                                    <td>
                                        <input id="txt_pin" class="form-control" placeholder="Enter Pin Code" onkeypress="return isNumber(event)" type="text" />
                                    </td>
                                </tr>
                            <tr>
                            <td>
                                <label>
                                    Phone No.</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_phone" type="text" placeholder="Enter Phone No" onkeypress="return isNumber(event)" class="form-control"  />
                                
                            </td>
                            </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            FAX</label>
                                    </td>
                                    <td>
                                        <input id="txt_fax" class="form-control" placeholder="Enter Fax" type="text" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Email ID</label>
                                    </td>
                                    <td>
                                        <input id="txt_mail" class="form-control" placeholder="Enter Email ID" type="text" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Tin No</label>
                                    </td>
                                    <td>
                                        <input id="txt_tin" class="form-control" placeholder="Enter Tin No" type="text" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            PAN No</label>
                                    </td>
                                    <td>
                                        <input id="txt_pan" class="form-control" placeholder="Enter PAN No" type="text" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            CST No</label>
                                    </td>
                                    <td>
                                        <input id="txt_cst" class="form-control" placeholder="Enter CST No" type="text" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            STATUS</label>
                                    </td>
                                    <td>
                                        <select id="slct_status">
                                            <option value="Select type">Select type</option>
                                            <option value="A">ACTIVE</option>
                                            <option value="I">INACTIVE</option>
                                        </select>
                                    </td>
                                </tr>
                                </table>
                            <%--<div>
                            <table>
                                 <tr>
                                    <td>
                                    <label>
                                        GL Codes : </label>
                                </td>
                                </tr>
                            </table>
                            <div id="div_insert_row">
                            </div>
                            <table align="center" style="width: 60%;">
                                 <tr>
                                    <td></td>
                                    <td align="center" style="height: 40px;">
                                        <input id="btn_insert" type="button" class="btn btn-primary" name="submit" value="INSERT ROW"
                                            onclick="insertrow();">
                                        </td>
                                </tr>
                            </table>
                            
                        </div>--%>
                            <table align="center">
                            <tr hidden>
                                <td>
                                    <label id="lbl_partysno">
                                    </label>
                                </td>
                            </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="btn_subparty_save" type="button" class="btn btn-success" name="submit" value="Save"
                                            onclick="save_party_master();">
                                        <input id="btn_subparty_clear" type="button" class="btn btn-danger" name="submit" value="Clear"
                                            onclick="clear_party_master();">
                                    </td>
                                </tr>
                                <%--<tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>--%>
                            </table>
                            <div id="div_party_master">
                            </div>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
        </section>
</asp:Content>

