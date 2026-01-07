using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class EmployeeGrid : System.Web.UI.Page
    {
        private readonly string cs =
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStats();
                LoadDesignationFilter();
                LoadDropdowns();
                LoadEmployees();
            }
        }

        /* ========================= DASHBOARD STATS ========================= */
        private void LoadStats()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        COUNT(*) AS Total,
                        SUM(CASE WHEN Status = 'Active' THEN 1 ELSE 0 END) AS ActiveCount,
                        SUM(CASE WHEN Status = 'Inactive' THEN 1 ELSE 0 END) AS InactiveCount,
                        SUM(CASE WHEN DateOfJoining >= DATEADD(DAY,-30,GETDATE()) THEN 1 ELSE 0 END) AS NewJoiners
                    FROM [User]", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    litTotal.Text = dr["Total"].ToString();
                    litActive.Text = dr["ActiveCount"].ToString();
                    litInactive.Text = dr["InactiveCount"].ToString();
                    litNewJoiners.Text = dr["NewJoiners"].ToString();
                }
            }
        }

        /* ========================= LOAD EMPLOYEES ========================= */
        private void LoadEmployees()
        {
            List<EmployeeDTO> list = new List<EmployeeDTO>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT 
                u.UserId,
                u.FirstName,
                u.LastName,
                u.ProfilePicture,
                u.DesignationtId AS DesignationId,
                des.Name AS DesignationName
            FROM [User] u
            LEFT JOIN Designations des 
                ON u.DesignationtId = des.DesignationId
            WHERE u.Status = 'Active'
            ORDER BY u.UserId DESC
        ", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    list.Add(new EmployeeDTO
                    {
                        UserId = Convert.ToInt32(dr["UserId"]),
                        FirstName = dr["FirstName"].ToString(),
                        LastName = dr["LastName"].ToString(),
                        ProfilePicture = dr["ProfilePicture"] == DBNull.Value
                                            ? "/assets/img/profiles/default-avatar.jpg"
                                            : dr["ProfilePicture"].ToString(),
                        DesignationId = dr["DesignationId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["DesignationId"]),
                        DesignationName = dr["DesignationName"]?.ToString(),

                        // 🔹 TEMPORARY DASHBOARD VALUES
                        TotalProjects = 0,
                        CompletedTasks = 0,
                        InProgressTasks = 0,
                        Productivity = 0
                    });
                }
            }

            rptEmployees.DataSource = list;
            rptEmployees.DataBind();
        }



        /* ========================= FILTER DROPDOWN ========================= */
        private void LoadDesignationFilter()
        {
            ddlDesignationFilter.Items.Clear();
            ddlDesignationFilter.Items.Add(new ListItem("Select Designation", "0"));

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT DesignationId, Name FROM Designations WHERE Status='Active'", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ddlDesignationFilter.Items.Add(
                        new ListItem(dr["Name"].ToString(), dr["DesignationId"].ToString()));
                }
            }
        }

        /* ========================= ADD / EDIT DROPDOWNS ========================= */
        private void LoadDropdowns()
        {
            LoadRoles();
            LoadDepartments();
            LoadDesignations();
            LoadManagers();
        }

        private void LoadRoles()
        {
            ddlRoleAdd.Items.Clear();
            ddlRoleEdit.Items.Clear();

            ddlRoleAdd.Items.Add(new ListItem("-- Select Role --", ""));
            ddlRoleEdit.Items.Add(new ListItem("-- Select Role --", ""));

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT RoleId, RoleName FROM Role WHERE Status='Active'", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ddlRoleAdd.Items.Add(new ListItem(dr["RoleName"].ToString(), dr["RoleId"].ToString()));
                    ddlRoleEdit.Items.Add(new ListItem(dr["RoleName"].ToString(), dr["RoleId"].ToString()));
                }
            }
        }

        private void LoadDepartments()
        {
            ddlDepartmentAdd.Items.Clear();
            ddlDepartmentEdit.Items.Clear();

            ddlDepartmentAdd.Items.Add(new ListItem("-- Select Department --", ""));
            ddlDepartmentEdit.Items.Add(new ListItem("-- Select Department --", ""));

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT DepartmentId, Name FROM Departments WHERE Status='Active'", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ddlDepartmentAdd.Items.Add(new ListItem(dr["Name"].ToString(), dr["DepartmentId"].ToString()));
                    ddlDepartmentEdit.Items.Add(new ListItem(dr["Name"].ToString(), dr["DepartmentId"].ToString()));
                }
            }
        }

        private void LoadDesignations()
        {
            ddlDesignationAdd.Items.Clear();
            ddlDesignationEdit.Items.Clear();

            ddlDesignationAdd.Items.Add(new ListItem("-- Select Designation --", ""));
            ddlDesignationEdit.Items.Add(new ListItem("-- Select Designation --", ""));

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT DesignationId, Name FROM Designations WHERE Status='Active'", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ddlDesignationAdd.Items.Add(new ListItem(dr["Name"].ToString(), dr["DesignationId"].ToString()));
                    ddlDesignationEdit.Items.Add(new ListItem(dr["Name"].ToString(), dr["DesignationId"].ToString()));
                }
            }
        }

        private void LoadManagers()
        {
            ddlManagerAdd.Items.Clear();
            ddlManagerEdit.Items.Clear();

            ddlManagerAdd.Items.Add(new ListItem("-- Select Manager --", ""));
            ddlManagerEdit.Items.Add(new ListItem("-- Select Manager --", ""));

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT DISTINCT
                m.UserId,
                m.FirstName + ' ' + m.LastName AS Name
            FROM [User] m
            INNER JOIN [User] e
                ON e.ReportingManager = m.UserId
            WHERE m.Status = 'Active'
            ORDER BY Name
        ", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    string name = dr["Name"].ToString();
                    string id = dr["UserId"].ToString();

                    ddlManagerAdd.Items.Add(new ListItem(name, id));
                    ddlManagerEdit.Items.Add(new ListItem(name, id));
                }
            }
        }


        /* ========================= DTO ========================= */
        public class EmployeeDTO
        {
            public int UserId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string ProfilePicture { get; set; }

            public int DesignationId { get; set; }
            public string DesignationName { get; set; }

            // Dashboard fields (computed later)
            public int TotalProjects { get; set; }
            public int CompletedTasks { get; set; }
            public int InProgressTasks { get; set; }
            public int Productivity { get; set; }
        }

    }
}
