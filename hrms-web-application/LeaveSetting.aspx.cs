using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application.Admin.Attendance.Leave
{
    public partial class LeaveSetting : System.Web.UI.Page
    {
        SqlConnection conn = new SqlConnection(
            ConfigurationManager.ConnectionStrings["dbconn"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLeaveTypes();
            }
        }

        private void LoadLeaveTypes()
        {
            SqlDataAdapter da = new SqlDataAdapter(
                "SELECT LeaveTypeId, LeaveType, status FROM MasterLeaveTypes", conn);

            DataTable dt = new DataTable();
            da.Fill(dt);

            rptLeaveTypes.DataSource = dt;
            rptLeaveTypes.DataBind();
        }

        // 🔥 THIS METHOD MUST EXIST
        protected void StatusChanged(object sender, EventArgs e)
        {
            RadioButton rb = (RadioButton)sender;
            RepeaterItem item = (RepeaterItem)rb.NamingContainer;

            HiddenField hfId =
                (HiddenField)item.FindControl("hfLeaveTypeId");

            int leaveTypeId = Convert.ToInt32(hfId.Value);
            string newStatus = rb.ID == "rbActive"
                ? "Active"
                : "Inactive";

            try
            {
                SqlCommand cmd = new SqlCommand("UpdateStatus", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@LeaveTypeId", leaveTypeId);
                cmd.Parameters.AddWithValue("@status", newStatus);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                lblSuccess.Text = "Status changed to " + newStatus;
                lblSuccess.Visible = true;
                lblError.Visible = false;

                LoadLeaveTypes();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
                lblSuccess.Visible = false;
            }
        }
    }
}
