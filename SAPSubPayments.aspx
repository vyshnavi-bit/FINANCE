<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SAPSubPayments.aspx.cs" Inherits="SAPSubPayments" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script language="javascript" type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        function OrderValidate() {
            var fromDate = document.getElementById('<%=txtFromdate.ClientID %>').value;
            if (fromDate == "") {
                alert("Select Date");
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        $(function () {
            window.history.forward(1);
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
            SAP SubPayments<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">SAP Reports</a></li>
            <li><a href="#">SAP SubPayments</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>SAP SubPayments Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                           <td>
                           <label>
                            AccountNo
                            </label>
                            </td>
                            <td>
                                    <td>
                                        <asp:Panel ID="Panel1" runat="server">
                                            <asp:DropDownList ID="ddlaccountno" runat="server" CssClass="form-control" >
                                            </asp:DropDownList>
                                        </asp:Panel>
                                    </td>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="width:5px;"></td>
                                <td>
                           <label>
                          Branch Name
                            </label>
                            </td>
                    <td>
                        <asp:DropDownList ID="ddlbranchname" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </td>
                                <td>
                                <label>
                        From Date
                        </label>
                    </td>
                                <td>
                                    <asp:TextBox ID="txtFromdate" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                                    <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                        TargetControlID="txtFromdate" Format="dd-MM-yyyy HH:mm">
                                    </asp:CalendarExtender>
                                </td>
                                <td style="width: 5px;">
                                </td>
                               <%-- <td>
                                <label>
                        To Date
                        </label>
                    </td>
                   
                                <td>
                                    <asp:TextBox ID="txtTodate" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                                    <asp:CalendarExtender ID="todate_CalendarExtender1" runat="server" Enabled="True"
                                        TargetControlID="txtTodate" Format="dd-MM-yyyy HH:mm">
                                    </asp:CalendarExtender>
                                </td>--%>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <asp:Button ID="btnGET" Text="Get" runat="server" OnClientClick="OrderValidate();" OnClick="btnGet_Click"
                                        CssClass="btn btn-primary" />
                                </td>

                            </tr>
                        </table>
                        </br>
                        </br>
                        <div id="div_subpaymentname">
                        </div>
                        <asp:Panel ID="pnlHide" runat="server" Visible="false">
                            <div id="divPrint">
                                <div style="width: 100%;">
                                    <div style="width: 11%; float: left;">
                                        <img src="http://www.vyshnavi.co.in/Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px"
                                            height="72px" />
                                    </div>
                                    <div style="left: 0%; text-align: center;">
                                        <br />
                                        <div style="width: 100%;">
                                            <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="26px" ForeColor="#0252aa"
                                                Text=""></asp:Label><br />
                                            <div>
                                            </div>
                                        </div>
                                        <div align="center">
                                            <span style="font-size: 18px; text-decoration: underline; color: #0252aa;">SAP SubPayments</span>
                                        </div>
                                        <div align="center">
                                            <table style="width: 50%;">
                                                <tr>
                                                    <%--<td>
                                                        Name:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblpayto" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>--%>
                                                    <td>
                                                       Branch Name:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblbranch" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                    <td>
                                                        FromDate:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lbl_selfromdate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                  <%--  <td>
                                                        ToDate:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lbl_selftodate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>--%>
                                                </tr>
                                            </table>
                                        </div>
                                        <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                            GridLines="Both" Font-Bold="true">
                                            <EditRowStyle BackColor="#999999" />
                                            <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                            <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                Font-Names="Raavi" Font-Size="Small" />
                                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                            <RowStyle BackColor="#ffffff" ForeColor="#333333" />
                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                            <br />
                            <br />
                             <button type="button" class="btn btn-primary" style="margin-right: 5px;" onclick="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print </button>
                          <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/exporttoxl_utility.ashx">Export to XL</asp:HyperLink>
                        <br />
                         <asp:Button ID="BtnSave" Text="Save" runat="server" CssClass="btn btn-success" OnClick="BtnSave_Click"/>
                          </asp:Panel>
                          <br />
                        <asp:Label ID="lbl_msg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <br />
            </div>
        </div>
    </section>
</asp:Content>

