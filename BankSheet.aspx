<%@ Page Title="" EnableEventValidation="false" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="BankSheet.aspx.cs" Inherits="banksheetdetails" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        $(function () {

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
        function callHandler_nojson_post(d, s, e) {
            $.ajax({
                url: 'DairyFleet.axd',
                type: "POST",
                dataType: "json",
                contentType: false,
                processData: false,
                data: d,
                success: s,
                error: e
            });
        }
        function getFile_doc() {
            document.getElementById("FileUpload1").click();
        }
        function readURL_doc(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                document.getElementById("FileUpload_div").innerHTML = input.files[0].name;
            }
        }
        function upload_bank_Document_Info() {
            var bankid = document.getElementById('<%=ddlaccountno.ClientID%>').value;
            var doe = document.getElementById('<%=txtFromdate.ClientID%>').value;
            var Data = new FormData();
            Data.append("op", "save_bank_Document_Info");
            Data.append("bankid", bankid);
            Data.append("doe", doe);
            var fileUpload = $("#FileUpload1").get(0);
            var files = fileUpload.files;
            for (var i = 0; i < files.length; i++) {
                Data.append(files[i].name, files[i]);
            }
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    getbank_Uploaded_Documents();
                }
            };
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler_nojson_post(Data, s, e);
        }

        function getbank_Uploaded_Documents() {
            $("#divpic").css("display", "block");
            var bankid = document.getElementById('<%=ddlaccountno.ClientID%>').value;
            var doe = document.getElementById('<%=txtFromdate.ClientID%>').value;
            var data = { 'op': 'getbank_Uploaded_Documents', 'bankid': bankid, 'doe': doe };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_Uploaded_Documents(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_Uploaded_Documents(msg) {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Document</th><th scope="col">Download</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k + '</td>';
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var path2 = msg[i].path;
                var path1 = path2.split('.');
                var img_url = msg[i].ftplocation + msg[i].path + '?v=' + rndmnum;
                if (path1[1] == "pdf") {
                    if (img_url != "") {
                        results += '<td data-title="brandstatus" class="2"><iframe src=' + img_url + ' style="width:400px; height:400px;" frameborder="0"></iframe><img src=' + img_url + '  style="cursor:pointer;height:400px;width:400px;border-radius: 5px;display:none;"/></td>';
                    }
                    else {
                        results += '<td data-title="brandstatus" class="2"><img src="Images/FA.png"  style="cursor:pointer;height:400px;width:400px;border-radius: 5px;"/></td>';
                    }
                }
                results += '<th scope="row" class="1" ><a  target="_blank" href=' + img_url + '><i class="fa fa-download" aria-hidden="true"></i> Download</a></th>';
                results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                results += '</tr>';
                k++;
            }
            results += '</table></div>';
            $("#div_documents_table").html(results);
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%-- <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="3600">
    </asp:ToolkitScriptManager>--%>
    <div>
        <asp:UpdateProgress ID="updateProgress1" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                    right: 0; left: 0; z-index: 9999; background-color: #FFFFFF; opacity: 0.7;">
                    <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="thumbnails/loading.gif"
                        Style="padding: 10px; position: absolute; top: 40%; left: 40%; z-index: 99999;" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </div>
    <section class="content-header">
        <h1>
            Bank Sheet<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Bank Sheet</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Bank Sheet Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlaccountno" runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </td>
                                <td style="width:5px;"></td>
                                <td>
                                    <asp:TextBox ID="txtFromdate" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                                    <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                        TargetControlID="txtFromdate" Format="dd-MM-yyyy HH:mm">
                                    </asp:CalendarExtender>
                                </td>
                                <td style="width:5px;"></td>
                                <td>
                                    <asp:Button ID="btnGenerate" Text="Generate" runat="server" OnClientClick="getbank_Uploaded_Documents();"
                                        CssClass="btn btn-success" OnClick="btnGenerate_Click" />
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <asp:Panel ID="pnlHide" runat="server" Visible="false">
                            <div id="divPrint">
                                <div style="width: 100%;">
                                    <div style="width: 11%; float: left;">
                                         <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                                    </div>
                                    <div style="left: 0%; text-align: center;">
                                        <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="26px" ForeColor="#0252aa"
                                            Text=""></asp:Label>
                                        <br />
                                    </div>
                                    <div style="width: 100%;">
                                        <span style="font-size: 18px; font-weight: bold; padding-left: 37%; text-decoration: underline;
                                            color: #0252aa;">Bank Sheet</span><br />
                                        <div>
                                            <div style="width: 40%; float: left; padding-left: 7%;">
                                                <asp:Label ID="lblbank" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </div>
                                            <span style="font-weight: bold;">Date: </span>
                                            <asp:Label ID="lbl_fromDate" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <br />
                                <div style=" padding-right: 45px;">
                                    <span style="font-weight: bold; font-size: 16px;">Opp Bal: </span>
                                    <asp:Label ID="lblOppBal" runat="server" ForeColor="Red" Font-Bold="true" Font-Size="18px"
                                        Text=""></asp:Label>
                                </div>
                                <div style="width: 100%;">
                                
                                    <div style="width: 49%; float: left;">
                                        <asp:GridView ID="grdcollections" runat="server" ForeColor="White" Width="100%" GridLines="Both"
                                            Font-Size="12px">
                                            <EditRowStyle BackColor="#999999" />
                                            <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                            <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                Font-Names="Raavi" />
                                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                            <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                            <AlternatingRowStyle HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                                        </asp:GridView>
                                    </div>
                                    <div style="width:10px; float: left;"></div>
                                    <div style="width: 49%; float: left;">
                                        <asp:GridView ID="grdpayments" runat="server" ForeColor="White" Width="100%" GridLines="Both"
                                            Font-Size="12px">
                                            <EditRowStyle BackColor="#999999" />
                                            <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                            <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                Font-Names="Raavi" />
                                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                            <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                            <AlternatingRowStyle HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                                        </asp:GridView>
                                    </div>
                                </div>
                                <br />
                                <div style=" padding-right: 45px;">
                                 <span style="font-weight: bold; font-size: 16px;">Clo Bal :</span><asp:Label ID="lblclosingbal" runat="server" ForeColor="Red" Font-Bold="true" Font-Size="18px" Text=""></asp:Label> 
                                  <asp:Label ID="lblhidden" runat="server" ForeColor="Red" Text=""></asp:Label>
                                </div>
                                <br />
                                <br />
                                <table style="width: 100%;">
                                    <tr>
                                        <td style="width: 20%;">
                                            <span style="font-weight: bold; font-size: 14px;">Manager Signature</span>
                                        </td>
                                        <td style="width: 20%;">
                                            <span style="font-weight: bold; font-size: 14px;">Finance</span>
                                        </td>
                                        <td style="width: 30%;">
                                            <span style="font-weight: bold; font-size: 14px;">Prepared By:</span>
                                            <asp:Label ID="lblpreparedby" runat="server" Font-Size="Large" ForeColor="Red" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <br />
                              <button type="button" class="btn btn-primary" style="margin-right: 5px;" onclick="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print </button>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <br />
                   <asp:UpdatePanel ID="UpdatePanel3" runat="server">
        <ContentTemplate>
            <asp:Panel ID="pnlfoter" runat="server" Visible="false">
            <asp:Button ID="BtnSave" Text="Save" runat="server" CssClass="btn btn-primary" OnClick="BtnSave_Click"
                OnClientClick="Validate();"  />
            <br />
            <br />
            </asp:Panel>
            <asp:Label ID="lblbankmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>

          
            
            <div id="divpic" class="pictureArea1" style="display:none;">
                 <div class="col-sm-4" style="width:19% !important;">
                                    <table class="table table-bordered table-striped">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div id="FileUpload_div" class="img_btn" onclick="getFile_doc()" style="height: 50px;
                                                        width: 100%">
                                                        Choose Document To Upload
                                                    </div>
                                                    <div style="height: 0px; width: 0px; overflow: hidden;">
                                                        <input id="FileUpload1" type="file" name="files[]" onchange="readURL_doc(this);" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="col-sm-4" style="width:16% !important;">
                                    <input id="btn_upload_document" type="button" class="btn btn-primary" name="submit"
                                        value="UPLOAD" onclick="upload_bank_Document_Info();" style="width: 120px;
                                        margin-top: 25px;" />
                                </div>
                                <div class="col-sm-4" style="width:55% !important;">
                                   <div id="div_documents_table"> </div>
                                </div>
                    
                    </div>

               
            </div>
        </div>
    </section>
</asp:Content>
