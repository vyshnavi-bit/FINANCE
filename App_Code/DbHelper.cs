using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Data.SqlClient;
using System.IO;

/// <summary>
/// Summary description for DbHelper
/// </summary>
public class DbHelper
{
    public string connectionstring = string.Empty;
    DataSet ds = new DataSet();
    SqlDataAdapter dr = new SqlDataAdapter();
    SqlConnection con; 
    public DbHelper()
    {
    }
    public SqlConnection GetConnection()
    {
        con = new SqlConnection(getconnectionstring());
        if (con.State == ConnectionState.Closed)
        con.Open();
        return con;
    }

    public SqlConnection GetConnectionSAP()
    {
        con = new SqlConnection(getconnectionstringSAP());
        if (con.State == ConnectionState.Closed)
            con.Open();
        return con;
    }
    public DataSet GetDataset(string cmdstr)
    {

        SqlConnection con = GetConnection();
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = con;
        DataSet ds = new DataSet();
        SqlDataAdapter da = new SqlDataAdapter(cmdstr, con);
        da.Fill(ds);
        return ds;
    }

    public DataTable GetDatatable(string cmdstr)
    {

        SqlConnection con = GetConnection();
        SqlCommand cmd = new SqlCommand();
        cmd.CommandTimeout = 300000;
        cmd.Connection = con;
        DataTable dt = new DataTable();
        SqlDataAdapter da = new SqlDataAdapter(cmdstr, con);
        da.Fill(dt);
        return dt;

    }

    public SqlDataReader GetDatareader(string cmdstr)
    {

        SqlConnection con = GetConnection();
        SqlCommand cmd = new SqlCommand();
        SqlDataReader dr;
        cmd.Connection = con;
        cmd.CommandText = cmdstr;
        dr = cmd.ExecuteReader(); 
         return dr;

                           }
    public void ExecuteNonquorey(string cmdstr)
    {
        using (SqlConnection con = GetConnection())
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = cmdstr;
            cmd.Connection = con;
            cmd.ExecuteNonQuery();
        }
    }
    public int ExecuteScalarint(string cmdstr)
    {
        using (SqlConnection con = GetConnection())
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = cmdstr;
            cmd.Connection = con;
            int max = Convert.ToInt32(cmd.ExecuteScalar());
            return max;
        }
    }

    public double ExecuteScalardouble(string cmdstr)
    {
        using (SqlConnection con = GetConnection())
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = cmdstr;
            cmd.Connection = con;
            double max = Convert.ToInt64(cmd.ExecuteScalar());
            return max;
        }
    }
    public string ExecuteScalarstr(string cmdstr)
    {
        using (SqlConnection con = GetConnection())
        {
            string retstr;
            retstr = string.Empty;
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = cmdstr;
            cmd.Connection = con;
            object value = cmd.ExecuteScalar();
            if (value != null)
                retstr = value.ToString();
            return retstr;
        }
    }
    private string getconnectionstring()
    {
        string str = System.Configuration.ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ConnectionString;
        return str;
     }

    private string getconnectionstringSAP()
    {
        string str = System.Configuration.ConfigurationManager.ConnectionStrings["AMPSConnectionStringSAP"].ConnectionString;
        return str;
    }
    public void closeconnection()
    {
        con.Close();
    }
    //// Common code

    public int GetPlantMilktype(string pcode)
    {
        try
        {
            int Resultval = 0;
            string str = string.Empty;
            str = "Select milktype from  plant_master where plant_code='" + pcode + "'";
            Resultval = ExecuteScalarint(str);
            return Resultval;
        }
        catch (Exception ex)
        {
            return 0;
        }
    }

}

