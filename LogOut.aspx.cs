using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class LogOut : System.Web.UI.Page
{
    VehicleDBMgr vdm = new VehicleDBMgr();
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["UserSno"] != null)
        {
            string sno = Session["UserSno"].ToString();
            //cmd = new SqlCommand("update employe_details set loginflag=@log where sno=@sno");
            //cmd.Parameters.Add("@log", "0");
            //cmd.Parameters.Add("@sno", sno);
            //vdm.Update(cmd);

            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            cmd = new SqlCommand("Select max(sno) as transno from logininfo where userid=@userid AND username=@UserName");
            cmd.Parameters.Add("@userid", Session["UserSno"]);
            cmd.Parameters.Add("@UserName", Session["EmpName"]);
            DataTable dttime = vdm.SelectQuery(cmd).Tables[0];
            if (dttime.Rows.Count > 0)
            {
                string transno = dttime.Rows[0]["transno"].ToString();
                cmd = new SqlCommand("UPDATE logininfo set logouttime=@logouttime where sno=@sno");
                cmd.Parameters.Add("@logouttime", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", transno);
                vdm.Update(cmd);
            }
            cmd = new SqlCommand("update employe_login set loginstatus=@log WHERE sno=@empsno");
            cmd.Parameters.Add("@log", "0");
            cmd.Parameters.Add("@empsno", Session["UserSno"]);
            vdm.Update(cmd);
        }
        else
        {
            cmd = new SqlCommand("update employe_login set loginstatus=@log");
            cmd.Parameters.Add("@log", "0");
            vdm.Update(cmd);
        }


        ExpireAllCookies();
        Session.Clear();
        Session.RemoveAll();
        Session.Abandon();
        Session["UserName"] = null;
        Session["userdata_sno"] = null;
        Session["Owner"] = null;
        Session["LevelType"] = null;
        Session["Plant"] = null;
        Session["SalesOffice"] = null;
        Session["Distributors"] = null;
        Session["getcategorynames"] = null;
        Session["getsalesofficenames"] = null;
        Session["getbranchcategorynames"] = null;
        Session["getproductsnames"] = null;
        Session["getsubregionsnames"] = null;
        Session["getsalesofficenames"] = null;
        Session["getbranchnames"] = null;
        Session["getrates_categorynames"] = null;
        Session["getrates_productsnames"]=null;
        Session["getrates_subregion_subregionsnames"]=null;
        Session["getrates_subregions_categorynames"]=null;
        Session["getrates_subregions_productsnames"]=null; 
        Session["getrates_routes_subregionsnames"]=null;
        Session["getrates_routes_categorynames"]=null;
        Session["getrates_routes_productsnames"] =null;
        Session["getrates_routes_routename"] = null;
        Session["Branches"] = null;
        Session["PlantSno"] = null;
        Session["SalesoffSno"] = null;
        Session["branchSno"] = null;
        Response.Redirect("login.aspx");
    }

    private void ExpireAllCookies()
    {
        if (HttpContext.Current != null)
        {
            int cookieCount = HttpContext.Current.Request.Cookies.Count;
            for (var i = 0; i < cookieCount; i++)
            {
                var cookie = HttpContext.Current.Request.Cookies[i];
                if (cookie != null)
                {
                    var cookieName = cookie.Name;
                    var expiredCookie = new HttpCookie(cookieName) { Expires = DateTime.Now.AddDays(-1) };
                    HttpContext.Current.Response.Cookies.Add(expiredCookie); // overwrite it
                }
            }

            // clear cookies server side
            HttpContext.Current.Request.Cookies.Clear();
        }
    }
}