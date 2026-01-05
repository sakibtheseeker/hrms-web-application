using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;


namespace hrms_web_application
{
    public partial class EmployeeAttendance : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["dbconn"].ConnectionString;
        public string ChartLabels { get; set; } = "[]";
        public string ChartValues { get; set; } = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            Session["UserId"] = 36;

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadAttendanceButton();
                LoadAttendanceList();
                LoadDashboardMetrics();
                LoadAttendanceChart();
            }
        }

      

        void LoadUserInfo()
        {
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("GetUserById", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                con.Open();
                var dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblUserName.Text = dr["FirstName"] + " " + dr["LastName"];
                    lblEmail.Text = dr["Email"].ToString();
                }
            }
        }

        void LoadAttendanceButton()
        {
            timesheetBtn.Enabled = false;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("GetTodayAttendance", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (!dr.Read())
                {
                    btnAttendance.Text = "Check-In";
                    return;
                }

                if (dr["LunchIn"] == DBNull.Value)
                    btnAttendance.Text = "Lunch-In";
                else if (dr["LunchOut"] == DBNull.Value)
                    btnAttendance.Text = "Lunch-Out";
                else if (dr["CheckOut"] == DBNull.Value)
                    btnAttendance.Text = "Check-Out";
                else
                {
                    btnAttendance.Text = "Attendance Marked";
                    btnAttendance.Enabled = false;
                    timesheetBtn.Enabled = true;
                }
            }
        }

        void LoadAttendanceList()
        {
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("GetAttendanceList", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvAttendance.DataSource = dt;
                gvAttendance.DataBind();
            }
        }

        protected void btnAttendance_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("MarkAttendance", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadAttendanceButton();
            LoadAttendanceList();
        }

        protected void Timesheet_Click(object sender, EventArgs e)
        {
            Response.Redirect("TimesheetEmployee.aspx");
        }

        void LoadDashboardMetrics()
        {
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("GetDashboardMetrics", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // Hours → Minutes
                    lblTodayHours.Text = (Convert.ToDecimal(dr["TodayHours"]) * 60).ToString("0") + " min";
                    lblWeekHours.Text = (Convert.ToDecimal(dr["WeekHours"]) * 60).ToString("0") + " min";
                    lblMonthHours.Text = (Convert.ToDecimal(dr["MonthHours"]) * 60).ToString("0") + " min";
                    lblOvertime.Text = (Convert.ToDecimal(dr["OvertimeHours"]) * 60).ToString("0") + " min";
                }
            }
        }
        void LoadAttendanceChart()
        {
            List<string> dates = new List<string>();
            List<int> minutes = new List<int>();

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("GetAttendanceList", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    dates.Add(
                        Convert.ToDateTime(dr["Date"]).ToString("dd MMM")
                    );

                    minutes.Add(
                        Convert.ToInt32(
                            Convert.ToDecimal(dr["ProductionHours"]) * 60
                        )
                    );
                }
            }

            JavaScriptSerializer js = new JavaScriptSerializer();

            hfChartLabels.Value = js.Serialize(dates);
            hfChartValues.Value = js.Serialize(minutes);
        }




    }

}

