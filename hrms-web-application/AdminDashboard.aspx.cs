using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace hrms_web_application
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserId"] == null || Session["RoleId"] == null)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            int roleId = Convert.ToInt32(Session["RoleId"]);

            // 🔐 Only employees allowed here
            // ✅ ADMIN ROLE = 3
            if (roleId != 3)
            {
                Response.Redirect("~/EmployeeDashboard.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
            
                LoadSummaryCards();
                LoadEmployeeStatus();
                LoadAttendanceOverview();
                LoadEmployeesList();
                LoadTaskStatistics(); 
                LoadProjects();
            }
        }
        private void LoadProjects()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetActiveProjects", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptProjects.DataSource = dt;
                    rptProjects.DataBind();
                }
            }
        }



        protected string GetPriorityBadge(object priorityObj)
        {
            if (priorityObj == null)
                return "badge bg-secondary";

            string priority = priorityObj.ToString().ToLower();

            switch (priority)
            {
                case "high":
                    return "badge bg-danger";
                case "medium":
                    return "badge bg-warning text-dark";
                case "low":
                    return "badge bg-success";
                default:
                    return "badge bg-secondary";
            }
        }

        private void LoadBirthdays()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // 🎂 TODAY
                SqlDataAdapter daToday = new SqlDataAdapter(@"
            SELECT 
                FirstName + ' ' + LastName AS FullName,
                ProfilePicture,
                'Employee' AS Designation
            FROM [User]
            WHERE CAST(DateOfBirth AS DATE) = CAST(GETDATE() AS DATE)
        ", con);

                DataTable dtToday = new DataTable();
                daToday.Fill(dtToday);

                rptTodayBirthdays.DataSource = dtToday;
                rptTodayBirthdays.DataBind();

                pnlNoBirthdays.Visible = dtToday.Rows.Count == 0;

                // 🎂 TOMORROW
                SqlDataAdapter daTomorrow = new SqlDataAdapter(@"
            SELECT 
                FirstName + ' ' + LastName AS FullName,
                ProfilePicture,
                'Employee' AS Designation
            FROM [User]
            WHERE CAST(DateOfBirth AS DATE) = CAST(DATEADD(DAY,1,GETDATE()) AS DATE)
        ", con);

                DataTable dtTomorrow = new DataTable();
                daTomorrow.Fill(dtTomorrow);

                rptTomorrowBirthdays.DataSource = dtTomorrow;
                rptTomorrowBirthdays.DataBind();
            }
        }

        private void LoadTaskStatistics()
        {
            // TEMP / safe values (replace with DB later)
            litCompletedPercent.Text = "45";
            litOnHoldPercent.Text = "20";
            litInProgressPercent.Text = "25";
            litPendingPercent.Text = "10";
        }


        // ==============================
        // DASHBOARD SUMMARY CARDS
        // ==============================
        private void LoadSummaryCards()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("GetDashboardSummary", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litPresentRatio.Text = dr["PresentCount"].ToString();
                            litProjectStatusRatio.Text = dr["ProjectCount"].ToString();
                            litClientStatusRatio.Text = dr["ClientCount"].ToString();
                            litTotalTasks.Text = dr["TaskCount"].ToString();

                            // Static / future value
                            litTotalEarnings.Text = "₹0";
                        }
                    }
                }
            }
        }


        // ==============================
        // EMPLOYEE STATUS SECTION
        // ==============================
        private void LoadEmployeeStatus()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("GetEmployeeStatusSummary", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RoleId", 10); // Employee role

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litTotalCounts.Text = dr["TotalEmployees"].ToString();
                        }
                    }
                }
            }

            // Dummy / placeholder values (safe)
            litTotalProductionHours.Text = "1200";
            litTotalOvertimeHours.Text = "300";
            litTotalBreakHours.Text = "150";
            litTotalWorkingHours.Text = "1800";

            litTotalProductionHoursp.Text = "40";
            litTotalOvertimeHoursp.Text = "20";
            litTotalBreakHoursp.Text = "10";
            litTotalWorkingHoursp.Text = "60";
        }


        // ==============================
        // ATTENDANCE OVERVIEW
        // ==============================
        private void LoadAttendanceOverview()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("GetTodayAttendanceOverview", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            int total = Convert.ToInt32(dr["Total"]);
                            int present = Convert.ToInt32(dr["Present"]);
                            int halfDay = Convert.ToInt32(dr["HalfDay"]);
                            int absent = Convert.ToInt32(dr["Absent"]);

                            litTotalCount.Text = total.ToString();

                            litPresentPercentage.Text =
                                total == 0 ? "0" : ((present * 100) / total).ToString();

                            litHalfDayPercentage.Text =
                                total == 0 ? "0" : ((halfDay * 100) / total).ToString();

                            litAbsentPercentage.Text =
                                total == 0 ? "0" : ((absent * 100) / total).ToString();
                        }
                    }
                }
            }
        }


        // ==============================
        // EMPLOYEES LIST (REPEATER)
        // ==============================
        private void LoadEmployeesList()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetEmployeesForDashboard", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@RoleId", 10); // Employee role

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptUsers.DataSource = dt;
                    rptUsers.DataBind();
                }
            }
        }

    }
}
