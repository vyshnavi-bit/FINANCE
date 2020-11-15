<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="images/FA.png" type="image/x-icon" title="FA" />
    <meta name="author" content="">
    <title>Vyshnavi Dairy</title>
    <!-- Bootstrap Core CSS -->
    <link href="Css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <!-- MetisMenu CSS -->
    <link href="Css/metisMenu.min.css" rel="stylesheet" type="text/css" />
    <!-- Custom CSS -->
    <link href="Css/sb-admin-2.css" rel="stylesheet" type="text/css" />
    <!-- Custom Fonts -->
    <link href="Css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
        body
        {
            background: url(Images/fa.jpg) no-repeat fixed;
            margin: 0px;
            -webkit-background-size: cover;
            -moz-background-size: cover;
            -o-background-size: cover;
            background-size: cover;
        }
        
        .alertBox
            {
                position: absolute;
                top: 122px;
                left: 50%;
                width: 500px;
                margin-left: -250px;
                background-color: #fff;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                padding: 20px 101px;
                text-align:center;
            }
    </style>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            Please Sign In</h3>
                    </div>
                    <div class="panel-body">
                        <form id="form1" runat="server">
                        <fieldset>
                            <div class="form-group">
                                <asp:TextBox name="txtUserName" type="text" ID="txtUserName" CssClass="form-control"
                                    runat="server" placeholder="Enter UserName" />
                            </div>
                            <div class="form-group">
                                <asp:TextBox name="txtPassword" TextMode="password" runat="server" CssClass="form-control"
                                    placeholder="Enter Password" ID="txtPassword" />
                            </div>
                            <!-- Change this to a button or input when using this as a form -->
                            <asp:Button ID="btnLogin" Text="Login" runat="server" CssClass="btn btn-lg btn-success btn-block"
                                OnClick="btnLogin_Click" />
                        </fieldset>
                        <p>
                            <asp:Label ID="lbl_validation" ForeColor="Red" runat="server" Text=""></asp:Label></p>
                            <asp:Label ID="lbl_passwords" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lbl_username" runat="server" Visible="false"></asp:Label>

                            <!-- Alert message -->
                <div runat="server" id="AlertBox" class="alertBox" Visible="false">
                <div runat="server" id="AlertBoxMessage" style="padding-left: 0%;color: black;"  ></div>
                    <asp:Label Text="" runat="server" ID="lbl_validations" ForeColor="Blue" Font-Bold="true" Font-Size="18px" style="padding-top: 3%;" ></asp:Label>
                    <div  style="padding-left: 12%;padding-top: 12%;">
                    <table>
                    <tr>
                    <td >
                <asp:Panel ID="Panel1" runat="server" >
                    <asp:Button ID="btn_logoutsession" Text="Kill All Sessions" runat="server" OnClick="sessionsclick_click"   />
                  </asp:Panel>
                  </td>
                  <td>
                   <asp:Panel ID="Panel2" runat="server" >
                    <asp:Button ID="Button1" Text="Close" runat="server" OnClick="sessionsclick_Close"  />
                </asp:Panel>
                </td></tr></table>
                    </div>
                </div>

                        </form>
                          
                    </div>
                   
                </div>
            </div>
        </div>
    </div>
    <!-- jQuery -->
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <!-- Metis Menu Plugin JavaScript -->
    <script src="js/metisMenu.min.js" type="text/javascript"></script>
    <!-- Custom Theme JavaScript -->
    <script src="js/sb-admin-2.js" type="text/javascript"></script>
</body>
</html>
