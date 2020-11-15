using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

using MySql.Data.MySqlClient;
using System.Data;
using System.Data.SqlClient;
public partial class ChangePassWord : System.Web.UI.Page
{
   SqlCommand cmd;
   static string UserName = "";
   static VehicleDBMgr vdm;
   protected void Page_Load(object sender, EventArgs e)
   {
   }
    protected void btnSubmitt_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["UserSno"] != null)
            {
                lblError.Text = "";
                UserName = Session["UserSno"].ToString();
                vdm = new VehicleDBMgr();
                cmd = new SqlCommand("SELECT Password FROM employe_login WHERE sno = @Sno");
                cmd.Parameters.Add("@Sno", UserName);
                DataTable dt = vdm.SelectQuery(cmd).Tables[0];//"ManageData", "UserName", new string[] { "UserName=@UserName" }, new string[] { UserName }, new string[] { "" }).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    if (txtNewPassWord.Text == txtConformPassWord.Text)
                    {
                        txtNewPassWord.Text = txtConformPassWord.Text;
                        cmd = new SqlCommand("Update employe_login set passward=@Password where sno=@Sno ");
                        cmd.Parameters.Add("@Sno", UserName);
                        cmd.Parameters.Add("@Password", txtNewPassWord.Text.Trim());
                        vdm.Update(cmd);
                        lblMessage.Text = "Your Password has been Changed successfully";
                        Response.Redirect("Login.aspx", false);
                    }
                    else
                    {
                        lblError.Text = "Conform password not match";
                    }
                }
                else
                {
                    lblError.Text = "Entered username is incorrect";
                }
            }
            else
            {
                Response.Redirect("Login.aspx", false);
            }
        }
        catch (Exception ex)
        {
            lblError.Text = "Password Changed Failed";
        }
    }
}