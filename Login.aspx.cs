using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Text.RegularExpressions;
public partial class Login : System.Web.UI.Page
{
    SqlCommand cmd;
    VehicleDBMgr vdm;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            vdm = new VehicleDBMgr();
            faLogin();
            lbl_validation.Text = "";
        }
    }
    
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new VehicleDBMgr();
            String UserName = txtUserName.Text, PassWord = txtPassword.Text;
            lbl_username.Text = UserName;
            lbl_passwords.Text = PassWord;
            cmd = new SqlCommand("SELECT sno, name, username, passward, branchid, doe, createdby, leveltype,loginstatus FROM  employe_login WHERE (username = @UN) AND (passward = @Pwd)");
            cmd.Parameters.Add("@UN", UserName);
            cmd.Parameters.Add("@Pwd", PassWord);
            DataTable dtemp = vdm.SelectQuery(cmd).Tables[0];
            if (dtemp.Rows.Count > 0)
            {
                //string loginstatus = dtemp.Rows[0]["loginstatus"].ToString();
                //if (loginstatus == "True")
                //{
                    lbl_validation.Text = "Already Some one Login With This User Name";
                   // this.AlertBoxMessage.InnerText = "Already Some one Login With This User Name";
                   // this.AlertBox.Visible = true;
                //}
                //else
                //{
                    Session["TitleName"] = "SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD";
                    Session["Address"] = "R.S.No:381/2,Punabaka village Post,Pellakuru Mandal,Nellore District -524129., ANDRAPRADESH (State).Phone: 9440622077, Fax: 044 – 26177799.";
                    Session["TinNo"] = "37921042267";
                    Session["UserSno"] = dtemp.Rows[0]["Sno"].ToString();
                    Session["EmpName"] = dtemp.Rows[0]["name"].ToString();
                    Session["UserName"] = dtemp.Rows[0]["username"].ToString();
                    Session["passward"] = dtemp.Rows[0]["passward"].ToString();
                    Session["branch"] = "svds";
                    Session["branchname"] = "svds";
                    Session["FA_branchid"] = dtemp.Rows[0]["branchid"].ToString();
                    Session["LevelType"] = dtemp.Rows[0]["leveltype"].ToString();
                    Response.Cookies["userInfo"]["userName"] = Session["UserName"].ToString();
                    Response.Cookies["userInfo"]["UserSno"] = Session["UserSno"].ToString();
                    Response.Cookies["userInfo"]["branch"] = Session["branch"].ToString();
                    Response.Cookies["userInfo"]["lastVisit"] = DateTime.Now.ToString();
                    Response.Cookies["userInfo"].Expires = DateTime.Now.AddDays(1);
                    HttpCookie aCookie = new HttpCookie("userInfo");
                    aCookie.Values["userName"] = Session["UserName"].ToString();
                    aCookie.Values["lastVisit"] = DateTime.Now.ToString();
                    aCookie.Expires = DateTime.Now.AddDays(1);
                    Response.Cookies.Add(aCookie);
                    //get ip address and device type
                    string ipaddress;
                    ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                    if (ipaddress == "" || ipaddress == null)
                    {
                        ipaddress = Request.ServerVariables["REMOTE_ADDR"];
                    }
                    DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
                    HttpBrowserCapabilities browser = Request.Browser;
                    string devicetype = "";
                    string userAgent = Request.ServerVariables["HTTP_USER_AGENT"];
                    Regex OS = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                    Regex device = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                    string device_info = string.Empty;
                    if (OS.IsMatch(userAgent))
                    {
                        device_info = OS.Match(userAgent).Groups[0].Value;
                    }
                    if (device.IsMatch(userAgent.Substring(0, 4)))
                    {
                        device_info += device.Match(userAgent).Groups[0].Value;
                    }
                    if (!string.IsNullOrEmpty(device_info))
                    {
                        devicetype = device_info;
                        string[] words = devicetype.Split(')');
                        devicetype = words[0].ToString();
                    }
                    else
                    {
                        devicetype = "Desktop";
                    }

                    cmd = new SqlCommand("INSERT INTO logininfo(userid, username, logintime, ipaddress, devicetype) values (@userid, @UserName, @logintime, @ipaddress, @device)");
                    cmd.Parameters.Add("@userid", dtemp.Rows[0]["Sno"].ToString());
                    cmd.Parameters.Add("@UserName", dtemp.Rows[0]["name"].ToString());
                    cmd.Parameters.Add("@logintime", ServerDateCurrentdate);
                    cmd.Parameters.Add("@ipaddress", ipaddress);
                    cmd.Parameters.Add("@device", devicetype);
                    //cmd.Parameters.Add("@otp", otp);
                    vdm.insert(cmd);

                    cmd = new SqlCommand("update employe_login set loginstatus=@log where sno=@sno ");
                    cmd.Parameters.Add("@log", "1");
                    cmd.Parameters.Add("@sno", Session["UserSno"]);
                    vdm.Update(cmd);

                    Response.Redirect("BankMasterDetails.aspx", false);
                    //string SalesType = dtemp.Rows[0]["SalesType"].ToString();
                //}
            }
            else
            {
                lbl_validation.Text = "Invalid username and password";
            }
        }
        catch (Exception ex)
        {
            lbl_validation.Text = ex.Message;
        }
    }
    protected void sessionsclick_click(object sender, EventArgs e)
    {
        try
        {
            string username = lbl_username.Text.ToString();
            string password = lbl_passwords.Text.ToString();
            cmd = new SqlCommand("update employe_login set loginstatus=@log where username=@username and passward=@passward");
            cmd.Parameters.Add("@log", "0");
            cmd.Parameters.Add("@username", username);
            cmd.Parameters.Add("@passward", password);
            vdm.Update(cmd);
            DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT sno FROM employe_login where username=@username and passward=@passward");
            cmd.Parameters.Add("@username", username);
            cmd.Parameters.Add("@passward", password);
            DataTable dtEMP = vdm.SelectQuery(cmd).Tables[0];
            if (dtEMP.Rows.Count > 0)
            {
                string empid = dtEMP.Rows[0]["sno"].ToString();
                cmd = new SqlCommand("Select max(sno) as transno from logininfo where userid=@userid");
                cmd.Parameters.Add("@userid", empid);
                DataTable dttime = vdm.SelectQuery(cmd).Tables[0];
                if (dttime.Rows.Count > 0)
                {
                    string transno = dttime.Rows[0]["transno"].ToString();
                    cmd = new SqlCommand("UPDATE logininfo set logouttime=@logouttime where sno=@sno");
                    cmd.Parameters.Add("@logouttime", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", transno);
                    vdm.Update(cmd);
                }
            }
            this.AlertBox.Visible = false;
        }
        catch
        {
        }
    }
    protected void sessionsclick_Close(object sender, EventArgs e)
    {
        this.AlertBox.Visible = false;
        Response.Redirect("login.aspx");
    }


    private void faLogin()
    {
        try
        {
            string firstname = Request.QueryString["username"];
            string lastname = Request.QueryString["pwd"];
            txtUserName.Text = firstname;
            txtPassword.Text = lastname;
            if (txtUserName.Text.Trim() == "" || txtPassword.Text.Trim() == "")
            {
              
            }
            String UserName = txtUserName.Text, PassWord = txtPassword.Text;
            lbl_username.Text = UserName;
            lbl_passwords.Text = PassWord;
            cmd = new SqlCommand("SELECT sno, name, username, passward, branchid, doe, createdby, leveltype,loginstatus FROM  employe_login WHERE (username = @UN) AND (passward = @Pwd)");
            cmd.Parameters.Add("@UN", UserName);
            cmd.Parameters.Add("@Pwd", PassWord);
            DataTable dtemp = vdm.SelectQuery(cmd).Tables[0];
            if (dtemp.Rows.Count > 0)
            {
                //string loginstatus = dtemp.Rows[0]["loginstatus"].ToString();
                //if (loginstatus == "True")
                //{
               // lbl_validation.Text = "Already Some one Login With This User Name";
                // this.AlertBoxMessage.InnerText = "Already Some one Login With This User Name";
                // this.AlertBox.Visible = true;
                //}
                //else
                //{
                Session["TitleName"] = "SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD";
                Session["Address"] = "R.S.No:381/2,Punabaka village Post,Pellakuru Mandal,Nellore District -524129., ANDRAPRADESH (State).Phone: 9440622077, Fax: 044 – 26177799.";
                Session["TinNo"] = "37921042267";
                Session["UserSno"] = dtemp.Rows[0]["Sno"].ToString();
                Session["EmpName"] = dtemp.Rows[0]["name"].ToString();
                Session["UserName"] = dtemp.Rows[0]["username"].ToString();
                Session["passward"] = dtemp.Rows[0]["passward"].ToString();
                Session["branch"] = "svds";
                Session["branchname"] = "svds";
                Session["FA_branchid"] = dtemp.Rows[0]["branchid"].ToString();
                Session["LevelType"] = dtemp.Rows[0]["leveltype"].ToString();
                Response.Cookies["userInfo"]["userName"] = Session["UserName"].ToString();
                Response.Cookies["userInfo"]["UserSno"] = Session["UserSno"].ToString();
                Response.Cookies["userInfo"]["branch"] = Session["branch"].ToString();
                Response.Cookies["userInfo"]["lastVisit"] = DateTime.Now.ToString();
                Response.Cookies["userInfo"].Expires = DateTime.Now.AddDays(1);
                HttpCookie aCookie = new HttpCookie("userInfo");
                aCookie.Values["userName"] = Session["UserName"].ToString();
                aCookie.Values["lastVisit"] = DateTime.Now.ToString();
                aCookie.Expires = DateTime.Now.AddDays(1);
                Response.Cookies.Add(aCookie);
                //get ip address and device type
                string ipaddress;
                ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (ipaddress == "" || ipaddress == null)
                {
                    ipaddress = Request.ServerVariables["REMOTE_ADDR"];
                }
                DateTime ServerDateCurrentdate = VehicleDBMgr.GetTime(vdm.conn);
                HttpBrowserCapabilities browser = Request.Browser;
                string devicetype = "";
                string userAgent = Request.ServerVariables["HTTP_USER_AGENT"];
                Regex OS = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                Regex device = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                string device_info = string.Empty;
                if (OS.IsMatch(userAgent))
                {
                    device_info = OS.Match(userAgent).Groups[0].Value;
                }
                if (device.IsMatch(userAgent.Substring(0, 4)))
                {
                    device_info += device.Match(userAgent).Groups[0].Value;
                }
                if (!string.IsNullOrEmpty(device_info))
                {
                    devicetype = device_info;
                    string[] words = devicetype.Split(')');
                    devicetype = words[0].ToString();
                }
                else
                {
                    devicetype = "Desktop";
                }

                cmd = new SqlCommand("INSERT INTO logininfo(userid, username, logintime, ipaddress, devicetype) values (@userid, @UserName, @logintime, @ipaddress, @device)");
                cmd.Parameters.Add("@userid", dtemp.Rows[0]["Sno"].ToString());
                cmd.Parameters.Add("@UserName", dtemp.Rows[0]["name"].ToString());
                cmd.Parameters.Add("@logintime", ServerDateCurrentdate);
                cmd.Parameters.Add("@ipaddress", ipaddress);
                cmd.Parameters.Add("@device", devicetype);
                //cmd.Parameters.Add("@otp", otp);
                vdm.insert(cmd);

                cmd = new SqlCommand("update employe_login set loginstatus=@log where sno=@sno ");
                cmd.Parameters.Add("@log", "1");
                cmd.Parameters.Add("@sno", Session["UserSno"]);
                vdm.Update(cmd);

                Response.Redirect("BankMasterDetails.aspx", false);
                //string SalesType = dtemp.Rows[0]["SalesType"].ToString();
                //}
            }
            else
            {
                lbl_validation.Text = "Invalid username and password";
            }
        }
        catch (Exception ex)
        {
            lbl_validation.Text = ex.Message;
        }
    }
}