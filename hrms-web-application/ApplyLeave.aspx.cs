using hrms_web_application.Admin.Attendance.Leave;
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
    public partial class ApplyLeave : System.Web.UI.Page
    {


        string str = ConfigurationManager.ConnectionStrings["dbconn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["userId"] = 36; // temporary, replace with login
            }
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            LabelError.Text = "";
            LabelSuccess.Visible = false;

            int userId = Convert.ToInt32(Session["userId"]);
            int leaveTypeId = Convert.ToInt32(ddlLeaveType.SelectedValue);

            if (!DateTime.TryParse(txtStartDate.Text, out DateTime startDate) ||
                !DateTime.TryParse(txtEndDate.Text, out DateTime endDate))
            {
                LabelError.Text = "Please select valid dates";
                ShowModal();
                return;
            }

            using (SqlConnection conn = new SqlConnection(str))
            using (SqlCommand cmd = new SqlCommand("ApplyLeave", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@LeaveTypeId", leaveTypeId);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@EndDate", endDate);
                cmd.Parameters.AddWithValue("@Reason", txtReason.Text.Trim());

                conn.Open();
                string result = cmd.ExecuteScalar()?.ToString() ?? "Leave Applied Successfully";

                if (result.StartsWith("ERROR"))
                {
                    LabelError.Text = result;
                    ShowModal(); // modal stays open if error
                }
                else
                {
                    LabelSuccess.Text = result;
                    LabelSuccess.Visible = true;

                    // Refresh data
                    rptLeaves.DataBind();
                    GridView1.DataBind();

                    // Clear form
                    txtStartDate.Text = "";
                    txtEndDate.Text = "";
                    txtReason.Text = "";

                    // Close modal automatically
                    ScriptManager.RegisterStartupScript(
                        this,
                        GetType(),
                        "closeModal",
                        "var myModal = bootstrap.Modal.getInstance(document.getElementById('applyLeaveModal')); if(myModal){ myModal.hide(); }",
                        true
                    );
                }
            }
        }

        private void ShowModal()
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "showModal",
                "var myModal = new bootstrap.Modal(document.getElementById('applyLeaveModal')); myModal.show();",
                true
            );
        }

        protected void close(object sender, EventArgs e)
        {
            Response.Redirect("ApplyLeave.aspx");
        }
    }
}