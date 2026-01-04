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
    public partial class PaySlipReports : System.Web.UI.Page
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
                // Load totals
                LoadTotalPayroll();
                LoadTotalDeductions();
                LoadNetPay();
                LoadTotalEarnings();

                // Load Payslip report default
                LoadPayslipReport(null, null, "DESC", null);
            }
        }

        // ================== MAIN REPORT ==================
        private void LoadPayslipReport(string startMonth, string endMonth, string sortOrder, string searchText)
        {
            SqlCommand cmd = new SqlCommand("sp_GetPayslipReportByMonthRange", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            // Parameters
            cmd.Parameters.Add("@StartMonth", SqlDbType.VarChar).Value = string.IsNullOrEmpty(startMonth) ? (object)DBNull.Value : startMonth;
            cmd.Parameters.Add("@EndMonth", SqlDbType.VarChar).Value = string.IsNullOrEmpty(endMonth) ? (object)DBNull.Value : endMonth;
            cmd.Parameters.Add("@SearchText", SqlDbType.VarChar).Value = string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText;
            cmd.Parameters.Add("@SortOrder", SqlDbType.VarChar).Value = string.IsNullOrEmpty(sortOrder) ? "DESC" : sortOrder.ToUpper();

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvPayslip.DataSource = dt;
            gvPayslip.DataBind();
        }

        // ================== TOTALS ==================
        private void LoadTotalPayroll()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalPayroll", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label1.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadTotalDeductions()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalDeductions", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label2.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadNetPay()
        {
            SqlCommand cmd = new SqlCommand("sp_GetNetPay", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label3.Text = cmd.ExecuteScalar().ToString();
        }

        private void LoadTotalEarnings()
        {
            SqlCommand cmd = new SqlCommand("sp_GetTotalEarnings", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            Label4.Text = cmd.ExecuteScalar().ToString();
        }

        // ================== FILTER EVENTS ==================
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string[] months = DropDownList1.SelectedValue.Split(',');
            string startMonth = months.Length > 0 ? months[0] : null;
            string endMonth = months.Length > 1 ? months[months.Length - 1] : startMonth;

            LoadPayslipReport(startMonth, endMonth, DropDownList2.SelectedValue, TextBox1.Text.Trim());
        }

        protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
        {
            string[] months = DropDownList1.SelectedValue.Split(',');
            string startMonth = months.Length > 0 ? months[0] : null;
            string endMonth = months.Length > 1 ? months[months.Length - 1] : startMonth;

            LoadPayslipReport(startMonth, endMonth, DropDownList2.SelectedValue, TextBox1.Text.Trim());
        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {
            string[] months = DropDownList1.SelectedValue.Split(',');
            string startMonth = months.Length > 0 ? months[0] : null;
            string endMonth = months.Length > 1 ? months[months.Length - 1] : startMonth;

            LoadPayslipReport(startMonth, endMonth, DropDownList2.SelectedValue, TextBox1.Text.Trim());
        }

        // ================== CLEANUP ==================
        protected void Page_Unload(object sender, EventArgs e)
        {
            if (conn != null && conn.State == ConnectionState.Open)
                conn.Close();
        }
    }
}
