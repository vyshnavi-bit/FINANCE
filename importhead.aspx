<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="importhead.aspx.cs" Inherits="importhead" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
            Head of acount Master<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Head of acount Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>IMPORT Head of acount Details
                </h3>
            </div>
            <div>
              <span style="color:Red; font-size:20px;"> Note : Please give the ledger code is different from every ledger name </span>
            </div>
            <div class="box-body">
             <table align="center">
                        <tr>
                            <td>
                                <label>
                                   
                                </label>
                            </td>
                            <td>
                            <asp:FileUpload ID="FileUploadToServer" runat="server" Style="height: 25px; width:100px; font-size: 16px;" />&nbsp;&nbsp;
                           
                            </td>
                            <td style="width:2%;">
                            
                            </td>
                             <td style="width: 5px;">
                              <asp:Button ID="Button1" Text="Import" runat="server" CssClass="btn btn-primary" OnClick="btn_import_click"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div>
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                            <ContentTemplate>
                                <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                    GridLines="Both" Font-Bold="true" Font-Size="Smaller">
                                    <EditRowStyle BackColor="#999999" />
                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                        Font-Names="Raavi" />
                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                                </asp:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        </div>
                            </td>
                        </tr>
                      
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                            <asp:Button ID="btn_save" runat="server" class="btn btn-success" Text="Save" OnClick="save_head_click" />
                            </td>
                        </tr>
                    </table>
                <table style="width: 100%;">
                    <tr>
                        <td style="float: left; width: 20%;">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                               </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                        <td style="float: right;">
                         <%--   <asp:Button ID="Button3" Text="Export To Excel" runat="server" CssClass="btn btn-primary"
                                OnClick="btn_Export_Click" />--%>
                        </td>
                         <td style="width:5px;">
                        </td>
                       
                    </tr>
                </table>
                
                <asp:UpdatePanel ID="upd" runat="server">
                    <ContentTemplate>
                        
                        <br />
                        <asp:Button ID="btnPrint" CssClass="btn btn-primary" Text="Print" OnClientClick="javascript:CallPrint('divPrint');"
                            runat="Server" />
                        <asp:Label ID="lblmsg" runat="server" ForeColor="Red" Text="" Font-Size="20px"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>


        
    </section>
</asp:Content>

