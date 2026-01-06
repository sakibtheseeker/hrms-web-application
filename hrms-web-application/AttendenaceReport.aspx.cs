using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace $safeprojectname$
{
    public partial class AttendenaceReport : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;
        SqlConnection con;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (con == null)
                con = new SqlConnection(conStr);

            if (!IsPostBack)
            {
                LoadTotalWorkingDays();
                LoadTotalLeaves();
                LoadTotalHolidays();
                LoadTotalHalfDays();

                LoadAttendance(null, "DESC");
            }
        }

        // MAIN LOAD METHOD
        private void LoadAttendance(string status, string sortOrder = "DESC", string dateFilter = "")
        {
            SqlCommand cmd = new SqlCommand("sp_GetAttendance", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (status == null)
                cmd.Parameters.Add(new SqlParameter("@Status", DBNull.Value));
            else
                cmd.Parameters.Add(new SqlParameter("@Status", status));

            if (string.IsNullOrEmpty(TextBox1.Text))
                cmd.Parameters.Add(new SqlParameter("@Search", DBNull.Value));
            else
                cmd.Parameters.Add(new SqlParameter("@Search", TextBox1.Text.Trim()));

            if (string.IsNullOrEmpty(dateFilter))
                cmd.Parameters.Add(new SqlParameter("@DateFilter", DBNull.Value));
            else
                cmd.Parameters.Add(new SqlParameter("@DateFilter", dateFilter));

            cmd.Parameters.Add(new SqlParameter("@SortOrder", sortOrder));

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            if (con.State != ConnectionState.Open)
                con.Open();

            da.Fill(dt);
            GridView1.DataSource = dt;
            GridView1.DataBind();

            con.Close();
        }

        // FILTERS
        protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAttendance(DropDownList2.SelectedValue, DropDownList3.SelectedValue);
        }

        protected void DropDownList3_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAttendance(DropDownList2.SelectedValue, DropDownList3.SelectedValue);
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAttendance(DropDownList2.SelectedValue, DropDownList3.SelectedValue, DropDownList1.SelectedValue);
        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {
            LoadAttendance(DropDownList2.SelectedValue, DropDownList3.SelectedValue, DropDownList1.SelectedValue);
        }

        // TOTALS
        private void LoadTotalWorkingDays()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalWorkingDays", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (con.State != ConnectionState.Open)
                con.Open();

            Label1.Text = cmd.ExecuteScalar().ToString();

            con.Close();
        }

        private void LoadTotalLeaves()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalLeaves", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (con.State != ConnectionState.Open)
                con.Open();

            Label2.Text = cmd.ExecuteScalar().ToString();

            con.Close();
        }

        private void LoadTotalHolidays()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalHolidays", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (con.State != ConnectionState.Open)
                con.Open();

            Label3.Text = cmd.ExecuteScalar().ToString();

            con.Close();
        }

        private void LoadTotalHalfDays()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalHalfDays", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (con.State != ConnectionState.Open)
                con.Open();

            Label4.Text = cmd.ExecuteScalar().ToString();

            con.Close();
        }

        protected void Page_Unload(object sender, EventArgs e)
        {
            if (con != null && con.State == ConnectionState.Open)
                con.Close();
        }
    }
}
