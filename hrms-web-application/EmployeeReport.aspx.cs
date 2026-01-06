using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Reflection.Emit;

namespace $safeprojectname$
{
    public partial class EmployeeReport : System.Web.UI.Page
    {
        private string conStr = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTotalEmployees();
                LoadActiveEmployees();
                LoadInactiveEmployees();
                LoadNewEmployees();
                LoadAllEmployees();
            }
        }

        // ========== GRID LOAD METHODS ==========
        private void LoadAllEmployees()
        {
            DataTable dt = GetEmployeesFromDB_All();
            gvEmployeeReport.DataSource = dt;
            gvEmployeeReport.DataBind();
        }

        private void LoadEmployeesByStatus(string status)
        {
            DataTable dt = GetEmployeesFromDB_ByStatus(status);
            gvEmployeeReport.DataSource = dt;
            gvEmployeeReport.DataBind();
        }

        private void LoadEmployeesBySearch(string searchText)
        {
            DataTable dt = GetEmployeesFromDB_Search(searchText);
            gvEmployeeReport.DataSource = dt;
            gvEmployeeReport.DataBind();
        }

        private void LoadEmployeesSorted(string sortOrder)
        {
            DataTable dt = GetEmployeesFromDB_Sorted(sortOrder);
            gvEmployeeReport.DataSource = dt;
            gvEmployeeReport.DataBind();
        }

        // ========== DATABASE METHODS ==========
        private DataTable GetEmployeesFromDB_All()
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetAllEmployees", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 120; // 2 minutes timeout
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        private DataTable GetEmployeesFromDB_ByStatus(string status)
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetEmployeesByStatus", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 120;

            SqlParameter param = new SqlParameter();
            param.ParameterName = "@Status";
            param.Value = string.IsNullOrEmpty(status) ? DBNull.Value : (object)status;
            cmd.Parameters.Add(param);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        private DataTable GetEmployeesFromDB_Search(string searchText)
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("SearchEmployees", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 120;

            SqlParameter param = new SqlParameter();
            param.ParameterName = "@SearchText";
            param.Value = string.IsNullOrEmpty(searchText) ? DBNull.Value : (object)searchText;
            cmd.Parameters.Add(param);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        private DataTable GetEmployeesFromDB_Sorted(string sortOrder)
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand("GetEmployeesSorted", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 120;

            SqlParameter param = new SqlParameter();
            param.ParameterName = "@SortOrder";
            param.Value = string.IsNullOrEmpty(sortOrder) ? "DESC" : sortOrder;
            cmd.Parameters.Add(param);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        // ========== SUMMARY CARDS ==========
        private void LoadTotalEmployees()
        {
            Label1.Text = ExecuteScalarSP("GetTotalEmployees").ToString();
        }

        private void LoadActiveEmployees()
        {
            Label2.Text = ExecuteScalarSP("GetActiveEmployees").ToString();
        }

        private void LoadInactiveEmployees()
        {
            Label4.Text = ExecuteScalarSP("GetInactiveEmployees").ToString();
        }

        private void LoadNewEmployees()
        {
            Label3.Text = ExecuteScalarSP("GetNewEmployees").ToString();
        }

        private object ExecuteScalarSP(string spName)
        {
            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand(spName, con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 120; // set timeout

            con.Open();
            object result = cmd.ExecuteScalar();
            con.Close();
            return result;
        }

        // ========== FILTER EVENTS ==========
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadEmployeesByStatus(DropDownList1.SelectedValue);
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            LoadEmployeesSorted("ASC");
        }

        protected void LinkButton2_Click(object sender, EventArgs e)
        {
            LoadEmployeesSorted("DESC");
        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {
            LoadEmployeesBySearch(TextBox1.Text.Trim());
        }

        // ========== STATUS BADGE HELPER ==========
        protected string GetStatusBadge(string status)
        {
            if (status == "Active")
                return "badge badge-success d-inline-flex align-items-center badge-xs";
            else if (status == "Inactive")
                return "badge badge-danger d-inline-flex align-items-center badge-xs";
            else
                return "badge badge-secondary d-inline-flex align-items-center badge-xs";
        }
    }
}
