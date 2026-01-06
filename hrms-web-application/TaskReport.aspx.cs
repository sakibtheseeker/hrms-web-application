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
    public partial class TaskReport : System.Web.UI.Page
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
                LoadTotalTasks();
                LoadCompletedTasks();
                LoadOnHoldTasks();
                LoadOverdueTasks();
                LoadTaskGrid(); // initial grid load
            }
        }

        // ================== LOAD GRID ==================
        private void LoadTaskGrid(string sortBy = null, string searchText = null, string priority = null, string status = null)
        {
            SqlCommand cmd;

            if (!string.IsNullOrEmpty(searchText))
            {
                cmd = new SqlCommand("SearchTasks", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SearchText", searchText);
            }
            else if (!string.IsNullOrEmpty(sortBy))
            {
                cmd = new SqlCommand("SortTasks", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SortBy", sortBy);
            }
            else if (!string.IsNullOrEmpty(priority))
            {
                cmd = new SqlCommand("GetTasksByPriority", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Priority", priority);
            }
            else if (!string.IsNullOrEmpty(status))
            {
                cmd = new SqlCommand("GetTasksByStatus", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Status", status);
            }
            else
            {
                cmd = new SqlCommand("GetAllTasks", conn);
                cmd.CommandType = CommandType.StoredProcedure;
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvTaskTable.DataSource = dt;
            gvTaskTable.DataBind();
        }

        // ================== TOTALS ==================
        private void LoadTotalTasks()
        {
            SqlCommand cmd = new SqlCommand("GetTotalTasks", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblTotalTasks.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadCompletedTasks()
        {
            SqlCommand cmd = new SqlCommand("GetCompletedTasks", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblCompletedTasks.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadOnHoldTasks()
        {
            SqlCommand cmd = new SqlCommand("GetOnHoldTasks", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblOnHoldTasks.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadOverdueTasks()
        {
            SqlCommand cmd = new SqlCommand("GetOverdueTasks", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            lblOverdueTasks.Text = cmd.ExecuteScalar().ToString();
        }

        // ================== EVENTS ==================
        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTaskGrid(ddlSortBy.SelectedValue, txtSearch.Text.Trim(), ddlPrioritySort.SelectedValue, ddlStatusFilter.SelectedValue);
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadTaskGrid(ddlSortBy.SelectedValue, txtSearch.Text.Trim(), ddlPrioritySort.SelectedValue, ddlStatusFilter.SelectedValue);
        }

        protected void ddlPrioritySort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTaskGrid(ddlSortBy.SelectedValue, txtSearch.Text.Trim(), ddlPrioritySort.SelectedValue, ddlStatusFilter.SelectedValue);
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTaskGrid(ddlSortBy.SelectedValue, txtSearch.Text.Trim(), ddlPrioritySort.SelectedValue, ddlStatusFilter.SelectedValue);
        }

        // ================== BADGES ==================
        protected string GetPriorityBadge(object priorityObj)
        {
            if (priorityObj == null) return "badge badge-secondary";

            switch (priorityObj.ToString())
            {
                case "High": return "badge badge-danger-transparent";
                case "Medium": return "badge badge-warning-transparent";
                case "Low": return "badge badge-success-transparent";
                default: return "badge badge-secondary";
            }
        }

        protected string GetStatusBadge(object statusObj)
        {
            if (statusObj == null) return "badge badge-secondary d-inline-flex align-items-center badge-xs";

            switch (statusObj.ToString())
            {
                case "Completed": return "badge badge-success d-inline-flex align-items-center badge-xs";
                case "Inprogress":
                case "In Progress": return "badge badge-primary d-inline-flex align-items-center badge-xs";
                case "On Hold": return "badge badge-warning d-inline-flex align-items-center badge-xs";
                case "Overdue": return "badge badge-danger d-inline-flex align-items-center badge-xs";
                default: return "badge badge-secondary d-inline-flex align-items-center badge-xs";
            }
        }

        // ================== CLEANUP ==================
        protected void Page_Unload(object sender, EventArgs e)
        {
            if (conn != null && conn.State == System.Data.ConnectionState.Open)
                conn.Close();
        }
    }
}
