using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace hrms_web_application
{
    public partial class EmployeeDashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager
                            .ConnectionStrings["Pulse360DB"]
                            .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (Convert.ToInt32(Session["RoleId"]) != 10)
            {
                Response.Redirect("AdminDashboard.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

           

            if (!IsPostBack)
            {
                LoadEmployeeProfile();
                LoadAttendanceSummary();
                LoadLeaveSummary();
                LoadAttendanceData();   // ✅ ADD THIS
                LoadProjects();
                LoadTasks();
              
            }

        }

        private void LoadProjects()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetActiveProjectsByUser", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;

                    da.SelectCommand.Parameters.AddWithValue(
                        "@UserId",
                        Convert.ToInt32(Session["UserId"])
                    );

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptProjects.DataSource = dt;
                    rptProjects.DataBind();
                }
            }
        }






        private void LoadEmployeeProfile()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("GetEmployeeProfileByUserId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue(
                        "@UserId",
                        Convert.ToInt32(Session["UserId"])
                    );

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblEmployeeName.Text =
                                $"{dr["FirstName"]} {dr["LastName"]}";

                            lblEmail.Text = dr["Email"].ToString();
                            lblPhone.Text = dr["PhoneNumber"].ToString();

                            lblDepartment.Text = dr["DepartmentName"].ToString();
                            lblDesignation.Text = dr["DesignationName"].ToString();

                            lblJoinDate.Text = dr["DateOfJoining"] == DBNull.Value
                                ? "-"
                                : Convert.ToDateTime(dr["DateOfJoining"])
                                    .ToString("dd MMM yyyy");

                            string profilePic = dr["ProfilePicture"].ToString();
                            imgProfile.ImageUrl = string.IsNullOrWhiteSpace(profilePic)
                                ? "/assets/img/profiles/default.png"
                                : profilePic;
                        }
                    }
                }
            }
        }



        private void LoadAttendanceSummary()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("GetAttendanceSummaryByUser", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue(
                        "@UserId",
                        Convert.ToInt32(Session["UserId"])
                    );

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblTodayHours.Text = dr["TodayHours"] + " hrs";
                            lblTodayHoursValue.Text = dr["TodayHours"].ToString();
                            lblProductionHours.Text = dr["Production"].ToString();

                            lblPunchInTime.Text = dr["LastCheckIn"] == DBNull.Value
                                ? "Not Checked In"
                                : Convert.ToDateTime(dr["LastCheckIn"])
                                    .ToString("hh:mm tt");

                            lblCurrentPunchTime.Text =
                                DateTime.Now.ToString("hh:mm tt, dd MMM yyyy");
                        }
                    }
                }
            }
        }


        private void LoadLeaveSummary()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("GetLeaveSummaryByUser", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue(
                        "@UserId",
                        Convert.ToInt32(Session["UserId"])
                    );

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblTotalLeaves.Text = dr["TotalLeaves"].ToString();
                            lblTakenLeaves.Text = dr["TakenLeaves"].ToString();
                        }
                    }
                }
            }
        }



        private void LoadTasks()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetTasksByUserProjects", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue(
                        "@UserId",
                        Convert.ToInt32(Session["UserId"])
                    );

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptTasks.DataSource = dt;
                    rptTasks.DataBind();
                }
            }
        }




        private void LoadAttendanceData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DateTime today = DateTime.Today;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("GetTodayAttendanceByUser", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Date", today);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            Session["AttendanceStatus"] =
                                dr["Status"]?.ToString() ?? "Not Marked";

                            Session["CheckIn"] = dr["CheckIn"] == DBNull.Value
                                ? "Not Checked In"
                                : Convert.ToDateTime(dr["CheckIn"])
                                    .ToString("hh:mm tt");

                            Session["WorkingHours"] = dr["WorkingHours"].ToString();
                            Session["BreakHours"] = dr["BreakHours"].ToString();
                            Session["Overtime"] = dr["OvertimeHours"].ToString();
                            Session["Production"] = dr["ProductionHours"].ToString();
                        }
                        else
                        {
                            // No attendance for today
                            Session["AttendanceStatus"] = "Not Marked";
                            Session["CheckIn"] = "Not Checked In";
                            Session["WorkingHours"] = "0";
                            Session["BreakHours"] = "0";
                            Session["Overtime"] = "0";
                            Session["Production"] = "0";
                        }
                    }
                }
            }
        }

    }
}
