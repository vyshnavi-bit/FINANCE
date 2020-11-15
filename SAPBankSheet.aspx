<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SAPBankSheet.aspx.cs" Inherits="SAPBankSheet" %>

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
            SAP Bank Sheet<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">SAP Bank Sheet</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>SAP Bank Sheet Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                          <%--  <td>
                                    <asp:DropDownList ID="ddlsapimport" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="1">Main Head of Account</asp:ListItem>
                                    <asp:ListItem Value="2">Sub Head of Account</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="width:5px;"></td>--%>
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
                                    <asp:Button ID="btnGenerate" Text="Generate" runat="server" OnClientClick="OrderValidate();"
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
                                            color: #0252aa;">SAP Bank Sheet</span><br />
                                        <div>
                                            <div style="width: 40%; float: left; padding-left: 7%;">
                                                <asp:Label ID="lblbank" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            </div>
                                            <span style="font-weight: bold;">Date: </span>
                                            <asp:Label ID="lbl_fromDate" runat="server" ForeColor="Red" Text=""></asp:Label>
                                            <%--<span style="font-weight: bold;">Closed Date: </span>
                                            <asp:Label ID="lbl_ClosingDate" runat="server" ForeColor="Red" Text=""></asp:Label>--%>
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
            </div>
        </div>
    </section>
</asp:Content>

