using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace $safeprojectname$
{
    public partial class LeaveReport : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;
        SqlConnection conn;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (conn == null)
            {
                conn = new SqlConnection(conStr);
                conn.Open();
            }

            if (!IsPostBack)
            {
                LoadTotalLeaves();
                LoadTotalApproved();
                LoadTotalRejected();
                LoadTotalPending();
                LoadLeaveReport();
            }
        }

        // ================= MAIN REPORT =================
        private void LoadLeaveReport()
        {
            string status = DropDownList1.SelectedValue;       // Status filter
            string sortOrder = DropDownList2.SelectedValue;    // Sort order
            string dateFilter = DropDownList3.SelectedValue;   // Date filter
            string search = TextBox1.Text.Trim();              // Search text

            string spName = "";
            SqlParameter param = null;

            if (!string.IsNullOrEmpty(status) && status != "All")
            {
                spName = "sp_GetLeaveReportByStatus";
                param = new SqlParameter("@Status", status);
            }
            else if (!string.IsNullOrEmpty(search))
            {
                spName = "sp_GetLeaveReportBySearch";
                param = new SqlParameter("@Search", search);
            }
            else if (!string.IsNullOrEmpty(dateFilter) && dateFilter != "All")
            {
                spName = "sp_GetLeaveReportByDate";
                param = new SqlParameter("@DateFilter", dateFilter);
            }
            else
            {
                spName = sortOrder == "ASC"
                    ? "sp_GetLeaveReportSortedASC"
                    : "sp_GetLeaveReportSortedDESC";
            }

            SqlCommand cmd = new SqlCommand(spName, conn);
            cmd.CommandType = CommandType.StoredProcedure;

            if (param != null)
                cmd.Parameters.Add(param);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        // ================= TOTALS =================
        private void LoadTotalLeaves()
        {
            SqlCommand cmd = new SqlCommand("GetTotalLeaves", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label1.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadTotalApproved()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalApprovedLeaves", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label2.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadTotalRejected()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalRejectedLeaves", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label3.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadTotalPending()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalPendingLeaves", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label4.Text = cmd.ExecuteScalar().ToString();
        }

        // ================= FILTER EVENTS =================
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLeaveReport();
        }

        protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLeaveReport();
        }

        protected void DropDownList3_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLeaveReport();
        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {
            LoadLeaveReport();
        }

        // ================= CLEANUP =================
        protected void Page_Unload(object sender, EventArgs e)
        {
            if (conn != null && conn.State == ConnectionState.Open)
                conn.Close();
        }
    }
}
