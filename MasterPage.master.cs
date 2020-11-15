using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    string UserName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserName"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else
        {
            UserName = Session["EmpName"].ToString();
            if (!this.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    lblMessage.Text = UserName;
                    lblmyname.Text = UserName;
                    lblName.Text = UserName;
                    lblRole.Text = Session["leveltype"].ToString();
                }
            }
        }
    }
}
