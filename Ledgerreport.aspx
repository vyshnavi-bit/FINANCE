<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Ledgerreport.aspx.cs" Inherits="Ledgerreport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
    </style>
    <script language="javascript" type="text/javascript">

        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }

        $(function () {
            get_headofaccount_details();
        });

        var AccountNameDetails = [];
        function get_headofaccount_details() {
            var data = { 'op': 'get_headofaccount_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata(msg);
                        AccountNameDetails = msg;
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var AccountNameList = [];
        function filldata(msg) {
            //var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var AccountName = msg[i].AccountName;
                AccountNameList.push(AccountName);
            }
            $("#<%=TextBox1.ClientID%>").autocomplete({
                source: AccountNameList,
                autoFocus: true
            });
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
            Ledger Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Ledger Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Ledger Report Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                             <td>
                                    <td>
                                        <asp:DropDownList ID="ddlbranchname" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </td>
                                </td>
                               <td style="width: 150PX;">
                                        <asp:Label ID="Label1" runat="server" Text="Label">Ledger Name</asp:Label>&nbsp;
                                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </td>
                                    <td style="width: 6px;">
                                    </td>
                                     <td>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                            <asp:ListItem>ALL</asp:ListItem>
                            <asp:ListItem>Raised</asp:ListItem>
                            <asp:ListItem>Approved</asp:ListItem>
                            <asp:ListItem>Rejected</asp:ListItem>
                            <asp:ListItem>Paid</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                  
                    <td>
                     <asp:Label ID="Label2" runat="server" Text="Label"> From Date</asp:Label>&nbsp;
                        <asp:TextBox ID="txtFromdate" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                        <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                            TargetControlID="txtFromdate" Format="dd-MM-yyyy HH:mm">
                        </asp:CalendarExtender>
                    </td>
                    
                    <td>
                     <asp:Label ID="Label3" runat="server" Text="Label"> To Date</asp:Label>&nbsp;
                        <asp:TextBox ID="txtTodate" runat="server" Width="205px" CssClass="form-control"></asp:TextBox>
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="True" TargetControlID="txtTodate"
                            Format="dd-MM-yyyy HH:mm">
                        </asp:CalendarExtender>
                    </td>
                     <td style="width: 6px;">
                                    </td>
                                     <td style="padding-top: 16PX;">
                                        <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-success"
                                            OnClick="btn_Generate_Click" /><br />
                                    </td>
                                <td style="width: 50px">
                                </td>
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
                                            color: #0252aa;">Ledger Report</span><br />
                                        <div>
                                            <div style="width: 40%; float: left; padding-left: 7%;">
                                                <asp:Label ID="lblbank" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </div>
                                            <span style="font-weight: bold;">LedgerName: </span>
                                            <asp:Label ID="lbl_ledger" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            <td style="width:5px;"></td>
                                        </div>

                                    </div>
                                </div>
                                <br />
                                
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
                                     <div style="width:10px; float: left;"></div>
                                      <div style="width: 49%; float: left;">
                                     <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="EU_DataTable"
                                    GridLines="Both" Font-Bold="true">
                                    <EditRowStyle BackColor="#999999" />
                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                        Font-Names="Raavi" Font-Size="Small" />
                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                </asp:GridView>
                                </div>
                                </div>
                                <br />
                               
                                <br />
                                <br />
                                <table style="width: 100%;">
                                    <tr>
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
           
            <br />
            <br />
            </asp:Panel>
            <asp:Label ID="lblbankmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
            </div>
        </div>
    </section>
</asp:Content>
