using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application.Admin.Attendance.Leave
{
    public partial class AllocateLeaveDeptWise : Page
    {
        SqlConnection conn;
        string str = ConfigurationManager.ConnectionStrings["dbconn"].ConnectionString.ToString();
        protected void Page_Load(object sender, EventArgs e)
        {
            conn=new SqlConnection(str);
            conn.Open();
        }
        protected void Btn_click(object sender, EventArgs e)
        {
            try
            {
                string deptid = DropDownList1.SelectedValue;
                string leaveid = ddlLeaveType.SelectedValue;
                int num = int.Parse(txtLeavesCount.Text);

                string query = $"exec AddAlloctedLevesDetWise {deptid},{leaveid},{num}";

                SqlCommand cmd = new SqlCommand(query, conn);
                int row = cmd.ExecuteNonQuery();

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


    }
}
