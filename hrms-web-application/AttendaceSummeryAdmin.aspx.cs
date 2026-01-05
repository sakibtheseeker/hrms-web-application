using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application.Admin.Attendance
{
    public partial class AttendaceSummeryAdmin : Page
    {


        string cs = ConfigurationManager.ConnectionStrings["dbconn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboard();
                LoadAttendance();
            }
        }

        // 🔹 DASHBOARD
        private void LoadDashboard()
        {
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("sp_AdminAttendanceDashboard", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblTotalEmployees.Text = dr["TotalEmployees"].ToString();
                    lblPresent.Text = dr["Present"].ToString();
                    lblLate.Text = dr["LateLogin"].ToString();
                    lblAbsent.Text = dr["Absent"].ToString();
                }
            }
        }

        // Row Editing
        protected void gvAttendance_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvAttendance.EditIndex = e.NewEditIndex;
            LoadAttendance();
        }

        // Row Canceling Edit
        protected void gvAttendance_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvAttendance.EditIndex = -1;
            LoadAttendance();
        }

        // Row Updating
        protected void gvAttendance_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int attendanceId = Convert.ToInt32(gvAttendance.DataKeys[e.RowIndex].Value);

            GridViewRow row = gvAttendance.Rows[e.RowIndex];

            string status = ((TextBox)row.Cells[3].Controls[0]).Text;
            string checkIn = ((TextBox)row.Cells[4].Controls[0]).Text;
            string checkOut = ((TextBox)row.Cells[5].Controls[0]).Text;
            string breakHours = ((TextBox)row.Cells[6].Controls[0]).Text;
            string late = ((TextBox)row.Cells[7].Controls[0]).Text;
            string productionHours = ((TextBox)row.Cells[8].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(@"UPDATE Attendance 
        SET Status=@Status, CheckIn=@CheckIn, CheckOut=@CheckOut, 
            BreakHours=@BreakHours, Late=@Late, ProductionHours=@ProductionHours 
        WHERE AttendanceId=@AttendanceId", con))
            {
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@CheckIn", checkIn);
                cmd.Parameters.AddWithValue("@CheckOut", checkOut);
                cmd.Parameters.AddWithValue("@BreakHours", breakHours);
                cmd.Parameters.AddWithValue("@Late", late);
                cmd.Parameters.AddWithValue("@ProductionHours", productionHours);
                cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvAttendance.EditIndex = -1;
            LoadAttendance();
        }


        // 🔹 TABLE
        private void LoadAttendance()
        {
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlDataAdapter da = new SqlDataAdapter("sp_GetAdminAttendance", con))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvAttendance.DataSource = dt;
                gvAttendance.DataBind();
            }
        }

        // 🔹 EXPORT EXCEL
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Attendance.xls");
            Response.ContentType = "application/vnd.ms-excel";

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);
            gvAttendance.RenderControl(hw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for GridView export
        }
    }
}
