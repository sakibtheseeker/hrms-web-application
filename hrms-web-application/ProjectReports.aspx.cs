using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class ProjectReports : System.Web.UI.Page
    {
        private readonly string conStr = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;
        private SqlConnection conn;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (conn == null)
            {
                conn = new SqlConnection(conStr);
                conn.Open();
            }

            if (!IsPostBack)
            {
                LoadTotalProjects();
                LoadCompletedProjects();
                LoadPendingProjects();
                LoadNewProjects();
                LoadProjectGrid(); // Initial grid load
            }
        }

        // ================== LOAD GRID USING SPs ==================
        private void LoadProjectGrid()
        {
            SqlCommand cmd = null;

            string searchText = txtSearch.Text.Trim();
            string sortBy = ddlSortBy.SelectedValue;
            string priority = ddlPrioritySort.SelectedValue;
            string status = ddlStatusFilter.SelectedValue;

            // Determine which SP to call
            if (!string.IsNullOrEmpty(searchText))
            {
                cmd = new SqlCommand("SearchProjects", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SearchText", searchText);
            }
            else if (!string.IsNullOrEmpty(sortBy))
            {
                cmd = new SqlCommand("SortProjects", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SortBy", sortBy);
            }
            else if (!string.IsNullOrEmpty(priority) || !string.IsNullOrEmpty(status))
            {
                cmd = new SqlCommand("FilterProjects", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Priority", string.IsNullOrEmpty(priority) ? (object)DBNull.Value : priority);
                cmd.Parameters.AddWithValue("@Status", string.IsNullOrEmpty(status) ? (object)DBNull.Value : status);
            }
            else
            {
                // Default: all projects
                cmd = new SqlCommand("GetAllProjects", conn);
                cmd.CommandType = CommandType.StoredProcedure;
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvProjectReport.DataSource = dt;
            gvProjectReport.DataBind();
        }

        // ================== TOTAL LABELS USING SPs ==================
        private void LoadTotalProjects()
        {
            SqlCommand cmd = new SqlCommand("GetTotalProjects", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblTotalProjects.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
        }

        private void LoadCompletedProjects()
        {
            SqlCommand cmd = new SqlCommand("GetCompletedProjects", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblCompletedProjects.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
        }

        private void LoadPendingProjects()
        {
            SqlCommand cmd = new SqlCommand("GetPendingProjects", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblPendingProjects.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
        }

        private void LoadNewProjects()
        {
            SqlCommand cmd = new SqlCommand("GetNewProjects", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblNewProjects.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
        }

        // ================== EVENTS ==================
        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProjectGrid();
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadProjectGrid();
        }

        protected void ddlPrioritySort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProjectGrid();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProjectGrid();
        }

        // ================== CLEANUP ==================
        protected void Page_Unload(object sender, EventArgs e)
        {
            if (conn != null && conn.State == System.Data.ConnectionState.Open)
                conn.Close();
        }
    }
}

     