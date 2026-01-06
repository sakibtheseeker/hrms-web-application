using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace hrms_web_application.Admin
{
    public partial class AdminApproveLeave : System.Web.UI.Page
    {
        string conStr =
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadLeaves();
        }

        void LoadLeaves()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand("sp_AdminLeaveList", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvLeaves.DataSource = dt;
                gvLeaves.DataBind();
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            UpdateLeaveStatus("Approved");
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            UpdateLeaveStatus("Rejected");
        }

        void UpdateLeaveStatus(string status)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                foreach (GridViewRow row in gvLeaves.Rows)
                {
                    CheckBox chk = (CheckBox)row.FindControl("chkRow");

                    if (chk != null && chk.Checked)
                    {
                        int leaveId =
                            Convert.ToInt32(gvLeaves.DataKeys[row.RowIndex].Value);

                        SqlCommand cmd =
                            new SqlCommand("sp_AdminUpdateLeaveStatus", con);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@LeaveRequestId", leaveId);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@AdminName", "Admin");

                        cmd.ExecuteNonQuery();
                    }
                }
            }

            LoadLeaves();
        }

        protected void gvLeaves_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvLeaves.PageIndex = e.NewPageIndex;
            LoadLeaves();
        }

        protected string GetStatusClass(string status)
        {
            if (status == "Approved") return "bg-success";
            if (status == "Rejected") return "bg-danger";
            return "bg-warning";
        }

        protected void gvLeaves_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl = (Label)e.Row.FindControl("lblStatus");

                if (lbl != null)
                {
                    if (lbl.Text == "Approved")
                        lbl.CssClass = "badge bg-success";
                    else if (lbl.Text == "Rejected")
                        lbl.CssClass = "badge bg-danger";
                    else
                        lbl.CssClass = "badge bg-warning";
                }
            }
        }

    }
}
