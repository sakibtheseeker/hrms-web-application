using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace hrms_web_application
{
    public partial class DailyReports : System.Web.UI.Page
    {
        private readonly string conStr = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSummaryCounts();
                LoadCompletedTasks();
                LoadPendingTasks();
                LoadAllAttendance(); // default grid load
            }
        }

        // ==================== GRID LOAD METHODS ====================

        private void LoadAllAttendance()
        {
            DataTable dt = GetAttendance_All();
            gvDailyReport.DataSource = dt;
            gvDailyReport.DataBind();
        }

        private void LoadAttendanceByStatus(string status)
        {
            DataTable dt = GetAttendance_ByStatus(status);
            gvDailyReport.DataSource = dt;
            gvDailyReport.DataBind();
        }

        private void LoadAttendanceBySearch(string searchText)
        {
            DataTable dt = GetAttendance_Search(searchText);
            gvDailyReport.DataSource = dt;
            gvDailyReport.DataBind();
        }

        private void LoadAttendanceSorted(string sortOrder)
        {
            DataTable dt = GetAttendance_Sorted(sortOrder);
            gvDailyReport.DataSource = dt;
            gvDailyReport.DataBind();
        }

        // ==================== DATABASE METHODS ====================

        private DataTable GetAttendance_All()
        {
            DataTable dt = new DataTable();
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetDailyAttendance_All", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 60; // 60 seconds timeout

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            return dt;
        }

        private DataTable GetAttendance_ByStatus(string status)
        {
            DataTable dt = new DataTable();
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetDailyAttendance_ByStatus", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 60;

            // beginner-friendly parameter
            cmd.Parameters.Add("@Status", SqlDbType.VarChar).Value = status;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            return dt;
        }

        private DataTable GetAttendance_Search(string searchText)
        {
            DataTable dt = new DataTable();
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetDailyAttendance_Search", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 60;

            cmd.Parameters.Add("@SearchText", SqlDbType.VarChar).Value = searchText;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            return dt;
        }

        private DataTable GetAttendance_Sorted(string sortOrder)
        {
            DataTable dt = new DataTable();
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetDailyAttendance_Sorted", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 60;

            cmd.Parameters.Add("@SortOrder", SqlDbType.VarChar).Value = sortOrder;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            return dt;
        }

        // ==================== SUMMARY CARDS ====================

        private void LoadSummaryCounts()
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetSummaryCounts", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 60;

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                Label1.Text = dr["TotalPresent"].ToString();    // Total Present
                Label2.Text = dr["TotalAbsent"].ToString();     // Total Absent
            }
            dr.Close();
            con.Close();
        }

        private void LoadCompletedTasks()
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetCompletedTasks1", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 60;

            con.Open();
            Label3.Text = cmd.ExecuteScalar().ToString();      // Completed Tasks
            con.Close();
        }

        private void LoadPendingTasks()
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetPendingTasks", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 60;

            con.Open();
            Label4.Text = cmd.ExecuteScalar().ToString();      // Pending Tasks
            con.Close();
        }

        // ==================== EVENT HANDLERS ====================

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string status = DropDownList1.SelectedValue;
            if (string.IsNullOrEmpty(status)) status = null;

            LoadAttendanceByStatus(status);
        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {
            LoadAttendanceBySearch(TextBox1.Text.Trim());
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            LoadAttendanceSorted("ASC");
        }

        protected void LinkButton2_Click(object sender, EventArgs e)
        {
            LoadAttendanceSorted("DESC");
        }

        // ==================== BADGE HELPER ====================
        protected string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Present":
                    return "badge badge-soft-success d-inline-flex align-items-center badge-xs";
                case "Absent":
                    return "badge badge-soft-danger d-inline-flex align-items-center badge-xs";
                default:
                    return "badge badge-soft-warning d-inline-flex align-items-center badge-xs";
            }
        }
    }
}
