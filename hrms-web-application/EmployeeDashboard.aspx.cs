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
                Response.Redirect("Employee.aspx");
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
                SqlDataAdapter da = new SqlDataAdapter(@"
            SELECT 
                p.ProjectId,
                p.ProjectName,
                p.ClientName,
                p.ManagerName,
                p.StartDate,
                p.EndDate,
                p.Priority,
                p.Status,
                p.LogoPath
            FROM AllProjects p
            INNER JOIN ProjectsUser pu
                ON p.ProjectId = pu.ProjectsProjectId
            WHERE pu.UsersUserId = @UserId
              AND p.Status = 'Active'
        ", con);

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



        

        private void LoadEmployeeProfile()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                            SELECT 
                    u.FirstName,
                    u.LastName,
                    u.Email,
                    u.PhoneNumber,
                    u.DateOfJoining,
                    u.ProfilePicture,        -- ✅ ADD THIS
                    d.Name AS DepartmentName,
                    des.Name AS DesignationName
                FROM [User] u
                LEFT JOIN Departments d 
                    ON u.DepartmentId = d.DepartmentId
                LEFT JOIN Designations des 
                    ON u.DesignationtId = des.DesignationId
                WHERE u.UserId = @UserId", con);

                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblEmployeeName.Text =
                        $"{dr["FirstName"]} {dr["LastName"]}";

                    lblEmail.Text = dr["Email"]?.ToString();
                    lblPhone.Text = dr["PhoneNumber"]?.ToString();

                    lblDepartment.Text = dr["DepartmentName"]?.ToString();
                    lblDesignation.Text = dr["DesignationName"]?.ToString();

                    lblJoinDate.Text = dr["DateOfJoining"] == DBNull.Value
                        ? "-"
                        : Convert.ToDateTime(dr["DateOfJoining"])
                            .ToString("dd MMM yyyy");

                    if (dr["ProfilePicture"] != DBNull.Value &&
                    !string.IsNullOrWhiteSpace(dr["ProfilePicture"].ToString()))
                    {
                        imgProfile.ImageUrl = dr["ProfilePicture"].ToString();
                    }
                    else
                    {
                        imgProfile.ImageUrl = "/assets/img/profiles/default.png";
                    }

                }
            }
        }


        private void LoadAttendanceSummary()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT 
                SUM(CASE WHEN Date = CAST(GETDATE() AS DATE) THEN WorkingHours ELSE 0 END) TodayHours,
                SUM(CASE WHEN Date >= DATEADD(DAY,-7,GETDATE()) THEN WorkingHours ELSE 0 END) WeekHours,
                SUM(CASE WHEN MONTH(Date)=MONTH(GETDATE()) THEN WorkingHours ELSE 0 END) MonthHours,
                SUM(OvertimeHours) Overtime,
                MAX(CheckIn) LastCheckIn,
                SUM(ProductionHours) Production
            FROM Attendance
            WHERE UserId = @UserId", con);

                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblTodayHours.Text = dr["TodayHours"] + " hrs";
                    lblTodayHoursValue.Text = dr["TodayHours"].ToString();
                    lblProductionHours.Text = dr["Production"] + "";
                    lblPunchInTime.Text = dr["LastCheckIn"] == DBNull.Value
                        ? "Not Checked In"
                        : Convert.ToDateTime(dr["LastCheckIn"]).ToString("hh:mm tt");

                    lblCurrentPunchTime.Text = DateTime.Now.ToString("hh:mm tt, dd MMM yyyy");
                }
            }
        }

        private void LoadLeaveSummary()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT 
                ISNULL(SUM(TotalLeaves), 0) AS TotalLeaves,
                ISNULL(SUM(UsedLeaves), 0) AS TakenLeaves
            FROM [LeaveBalances]
            WHERE UserId = @UserId
        ", con);

                cmd.Parameters.AddWithValue("@UserId", Convert.ToInt32(Session["UserId"]));

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblTotalLeaves.Text = dr["TotalLeaves"].ToString();
                    lblTakenLeaves.Text = dr["TakenLeaves"].ToString();
                }
            }
        }


        private void LoadTasks()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(@"
            SELECT 
                Title,
                Status,
                Priority,
                Deadline
            FROM Task
            WHERE Projectid IN (
                SELECT Projectid 
                FROM ProjectsUser 
                WHERE UsersUserId = @UserId
            )
        ", con);

                da.SelectCommand.Parameters.AddWithValue(
                    "@UserId", Convert.ToInt32(Session["UserId"])
                );

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptTasks.DataSource = dt;
                rptTasks.DataBind();
            }
        }



        private void LoadAttendanceData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DateTime today = DateTime.Today;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 1
                        Status,
                        CheckIn,
                        ISNULL(WorkingHours, 0) AS WorkingHours,
                        ISNULL(BreakHours, 0) AS BreakHours,
                        ISNULL(OvertimeHours, 0) AS OvertimeHours,
                        ISNULL(ProductionHours, 0) AS ProductionHours
                    FROM Attendance
                    WHERE UserId = @UserId
                      AND CAST([Date] AS DATE) = @Date
                    ORDER BY [Date] DESC
                ", con);

                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@Date", today);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["AttendanceStatus"] = dr["Status"]?.ToString() ?? "Not Marked";

                    Session["CheckIn"] = dr["CheckIn"] == DBNull.Value
                        ? "Not Checked In"
                        : Convert.ToDateTime(dr["CheckIn"]).ToString("hh:mm tt");

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
