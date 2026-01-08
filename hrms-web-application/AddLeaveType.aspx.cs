using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application.Admin.Attendance.Leave
{
    public partial class AddLeaveType : System.Web.UI.Page
    {
        SqlConnection conn;
        string str = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            conn = new SqlConnection(str);
            conn.Open();

            if (!IsPostBack)
            {
                BindGrid(); // Load initial data on first page load
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            try
            {
                string leaveType = TextBox1.Text;
                string query = $"Exec AddLeaveType '{leaveType}'";

                SqlCommand cmd = new SqlCommand(query, conn);
                int row = cmd.ExecuteNonQuery();

                GridView1.DataBind();

                if (row > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "alert('Leave Type added successfully'); window.location='AddLeaveType.aspx';", true);
                }

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    $"alert('Exception {ex.Message}'); window.location='AddLeaveType.aspx';", true);
            }
        }

        private void BindGrid()
        {
            using (SqlCommand cmd = new SqlCommand("SELECT LeaveTypeId, LeaveType, status FROM MasterLeaveTypes", conn))
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "DeleteLeave")
                {
                    int leaveTypeId = Convert.ToInt32(e.CommandArgument);

                    using (SqlConnection connDel = new SqlConnection(str))
                    {
                        using (SqlCommand cmd = new SqlCommand("DeleteLeaveType", connDel))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@LeaveTypeId", leaveTypeId);

                            connDel.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    BindGrid(); // Rebind after delete
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    $"alert('Exception {ex.Message}'); window.location='AddLeaveType.aspx';", true);
            }
        }

        protected void txtSearchLeave_TextChanged(object sender, EventArgs e)
        {
            string searchText = txtSearchLeave.Text.Trim();
            string query = "EXEC FindByLeaveType @LeaveType, @staus";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@LeaveType", searchText);
                cmd.Parameters.AddWithValue("@staus", searchText);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

       

    }
}
