<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="DATE.aspx.cs" Inherits="DATE" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        function getdates() {
            var dt = new Date();
            document.getElementById('dt_today').innerHTML = [dt.getDate(), dt.getMonth(), dt.getFullYear()].join('/');

        }
    </script>
<%--<script>
 $(function () {
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
//                 $('#dt_today').val(dd + '-' + mm + '-' + yyyy);
                var tod = dd + '/' + mm + '/' + yyyy;
                document.getElementById("dt_today").value = tod;
            });
</script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<body onload="getdates();">
<div>
<label id="dt_today"/>
</div>
</body>
</asp:Content>

