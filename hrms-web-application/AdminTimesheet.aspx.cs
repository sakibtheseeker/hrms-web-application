using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace hrms_web_application.Admin
{
    public partial class AdminTimesheet : System.Web.UI.Page
    {
        string conStr =
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadTimesheets();
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            UpdateSelectedStatus("Approved");
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            UpdateSelectedStatus("Rejected");
        }

        void UpdateSelectedStatus(string status)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                foreach (GridViewRow row in gvTimesheet.Rows)
                {
                    CheckBox chk = (CheckBox)row.FindControl("chkRow");

                    if (chk != null && chk.Checked)
                    {
                        int timesheetId =
                            Convert.ToInt32(gvTimesheet.DataKeys[row.RowIndex].Value);

                        SqlCommand cmd =
                            new SqlCommand("sp_UpdateTimesheetStatus", con);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@TimesheetId", timesheetId);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            LoadTimesheets();
        }

        void LoadTimesheets()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd =
                    new SqlCommand("sp_AdminTimesheetList", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTimesheet.DataSource = dt;
                gvTimesheet.DataBind();
            }
        }

        protected void gvTimesheet_PageIndexChanging(
            object sender, GridViewPageEventArgs e)
        {
            gvTimesheet.PageIndex = e.NewPageIndex;
            LoadTimesheets();
        }

        protected string GetStatusClass(string status)
        {
            if (status == "Approved") return "bg-success";
            if (status == "Rejected") return "bg-danger";
            return "bg-warning";
        }

        protected void btnExportPdf_Click(object sender, EventArgs e) { }
        protected void btnExportExcel_Click(object sender, EventArgs e) { }
    }
}
