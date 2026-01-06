using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;


namespace hrms_web_application.Employee.Leave
{
    public partial class LeaveDetails : System.Web.UI.Page
    {
        string str = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteLeave")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);

                int departmentId = Convert.ToInt32(GridView1.DataKeys[rowIndex]["DepartmentId"]);
                int leaveTypeId = Convert.ToInt32(GridView1.DataKeys[rowIndex]["LeaveTypeId"]);

                using (SqlConnection con = new SqlConnection(str))
                {
                    SqlCommand cmd = new SqlCommand("DeleteDeptLeave", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                    cmd.Parameters.AddWithValue("@LeaveTypeId", leaveTypeId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                GridView1.DataBind(); 
            }
        }
    }
}