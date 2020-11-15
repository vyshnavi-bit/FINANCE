<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SuspenseBillVoucher.aspx.cs" Inherits="SuspenseBillVoucher" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="Css/VyshnaviStyles.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
        function CallPrint(strid)
        {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        function OrderValidate()
        {
            var fromDate = document.getElementById('<%=txtfromdate.ClientID %>').value;
            if (fromDate == "") {
                alert("Select Date");
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        $(function ()
        {
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
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <section class="content-header">
                <h1>
                     Suspense Bill voucher generation<small>Preview</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
                    <li><a href="#"> Suspense Bill voucher generation </a></li>
                </ol>
            </section>
            <div style="border: 1px solid #d5d5d5; margin-left: 6px; margin-top: 10px; margin-right: 5px;">
                <div>
                    <div runat="server" id="d">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblfromdate" runat="server">From Date:</asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtfromdate" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                                    <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                        TargetControlID="txtfromdate" Format="dd-MM-yyyy HH:mm">
                                    </asp:CalendarExtender>
                                </td>
                                <td>
                                    <asp:Label ID="lbltodate" runat="server">To Date:</asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txttodate" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                                    <asp:CalendarExtender ID="todate_calendarextender" runat="server" Enabled="true"
                                        TargetControlID="txttodate" Format="dd-MM-yyyy HH:mm">
                                    </asp:CalendarExtender>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <asp:Button ID="btn_getdetails" Text="Get" runat="server" CssClass="btn btn-success"
                                        OnClick="btn_getdetails_Click" />
                                </td>
                            </tr>
                        </table>
                        <div id="divdcdata" align="center" style="height: 180px; width: 100%; text-align: center;
                            overflow: auto;">
                            <asp:GridView ID="Gridcdata" runat="server" ForeColor="White" Width="100%" GridLines="Both"
                                Font-Size="Smaller">
                                <EditRowStyle BackColor="#999999" />
                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" Font-Size="13px" HorizontalAlign="Center"
                                    ForeColor="Black" Font-Italic="False" Font-Names="Raavi" />
                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                <AlternatingRowStyle HorizontalAlign="Center" />
                                <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                            </asp:GridView>
                            <asp:Label ID="lbldateValidation" runat="server" Font-Size="20px" ForeColor="Red"
                                Text=""></asp:Label>
                        </div>
                    </div>
                    <div>
                        <table>
                            <tr>
                                <td>
                                    <div>
                                        <table id="tbltrip">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblrefno" runat="server">Reference No:</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtrefno" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                                                </td>
                                                <td style="width: 5px;">
                                                </td>
                                                <td>
                                                    <asp:Button ID="btnGenerate" runat="server" CssClass="btn btn-success" OnClick="btnGenerate_Click"
                                                        Text="Get Voucher" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <asp:Panel ID="pnlHide" runat="server" Visible="false">
                    <div id="divPrint">
                    <div style="width: 100%;">
                        <div style="width: 11%; float: left;">
                            <img src="http://www.vyshnavi.co.in/Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px"
                                height="82px" />
                        </div>
                        <div style="left: 0%; text-align: center;">
                            <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="26px" ForeColor="#0252aa"
                                Text=""></asp:Label>
                            <br />
                        </div>
                        <div style="width: 100%;">
                            <span style="font-size: 18px; font-weight: bold; padding-left: 37%; text-decoration: underline;
                                color: #0252aa;"> Suspense Bill voucher </span>
                            <div>
                            </div>
                        </div>
                    </div>
                    <div style="float: right;">
                                <div style="width: 100%;">
                                    <table style="width: 100%;">
                                        <tr>
                                         <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Transaction NO : </span>
                                                <asp:Label ID="txttxnno" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Transaction Date : </span>
                                                <asp:Label ID="txttranactiondate" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                            </tr>
                                            <tr>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Financial Year : </span>
                                                <asp:Label ID="txtfinacialyear" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                             <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Suspense Req No : </span>
                                                <asp:Label ID="txtsuspreqno" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                           <%-- <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Employee Name : </span>
                                                <asp:Label ID="txtempname" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <%--<td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Suspense Req No : </span>
                                                <asp:Label ID="txtsuspreqno" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>--%>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Suspense Req Date : </span>
                                                <asp:Label ID="txtsuspreqdate" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Req Amount : </span>
                                                <asp:Label ID="txtreqamt" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                        <%--<td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Req Amount : </span>
                                                <asp:Label ID="txtreqamt" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>--%>
                                             <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Section Code : </span>
                                                <asp:Label ID="txtsectioncode" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Particulars : </span>
                                                <asp:Label ID="txtparticulars" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                            <%--<td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Department Code : </span>
                                                <asp:Label ID="txtdepartmentname" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>--%>
                                        </tr>
                                        <tr>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Actual Expenses : </span>
                                                <asp:Label ID="txtactexpenses" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Balance Amount : </span>
                                                <asp:Label ID="txtbalamount" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 28%; padding-left: 10%;">
                                                <span style="font-weight: bold;">Status : </span>
                                                <asp:Label ID="txtstatus" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <asp:GridView ID="grdReports" runat="server" CellPadding="5" CellSpacing="5" CssClass="gridcls"
                                    Font-Size="Small" ForeColor="White" GridLines="Both" Width="100%">
                                    <EditRowStyle BackColor="#999999" />
                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="true" Font-Italic="False" Font-Names="Raavi"
                                        Font-Size="13px" ForeColor="Black" />
                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                </asp:GridView>
                                <br />
                                <table style="width: 100%;">
                                    <tr>
                                        <td style="width: 28%; padding-left: 10%;">
                                            <span style="font-weight: bold; font-size: 12px;">PREPARED BY</span>
                                        </td>
                                        <td style="width: 28%; padding-left: 10%;">
                                            <span style="font-weight: bold; font-size: 12px;">AUTHORISED SIGNATURE</span>
                                        </td>
                                    </tr>
                                </table>
                            <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-success" OnClientClick="javascript:CallPrint('divPrint');"
                                Text="Print" />
                            </div>
                        </asp:Panel>
                        <br />
                        <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>


</asp:Content>

