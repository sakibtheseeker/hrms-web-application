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
                using (SqlCommand cmd = new SqlCommand("GetUserStatisticsSummary", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litTotal.Text = dr["Total"].ToString();
                            litActive.Text = dr["ActiveCount"].ToString();
                            litInactive.Text = dr["InactiveCount"].ToString();
                            litNewJoiners.Text = dr["NewJoiners"].ToString();
                        }
                    }
                }
            }
        }


        /* ========================= LOAD EMPLOYEES ========================= */
        private void LoadEmployees()
        {
            List<EmployeeDTO> list = new List<EmployeeDTO>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetActiveEmployeesWithDesignation", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            list.Add(new EmployeeDTO
                            {
                                UserId = Convert.ToInt32(dr["UserId"]),
                                FirstName = dr["FirstName"].ToString(),
                                LastName = dr["LastName"].ToString(),
                                ProfilePicture = dr["ProfilePicture"].ToString(),
                                DesignationId = Convert.ToInt32(dr["DesignationId"]),
                                DesignationName = dr["DesignationName"].ToString(),

                                // 🔹 TEMPORARY DASHBOARD VALUES
                                TotalProjects = 0,
                                CompletedTasks = 0,
                                InProgressTasks = 0,
                                Productivity = 0
                            });
                        }
                    }
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
                using (SqlCommand cmd = new SqlCommand("GetActiveDesignationsForDropdown", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            ddlDesignationFilter.Items.Add(
                                new ListItem(
                                    dr["Name"].ToString(),
                                    dr["DesignationId"].ToString()
                                )
                            );
                        }
                    }
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
                using (SqlCommand cmd = new SqlCommand("GetActiveRolesForDropdown", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            string text = dr["RoleName"].ToString();
                            string value = dr["RoleId"].ToString();

                            ddlRoleAdd.Items.Add(new ListItem(text, value));
                            ddlRoleEdit.Items.Add(new ListItem(text, value));
                        }
                    }
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
                using (SqlCommand cmd = new SqlCommand("GetActiveDepartmentsForDropdown", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            string text = dr["Name"].ToString();
                            string value = dr["DepartmentId"].ToString();

                            ddlDepartmentAdd.Items.Add(new ListItem(text, value));
                            ddlDepartmentEdit.Items.Add(new ListItem(text, value));
                        }
                    }
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
                using (SqlCommand cmd = new SqlCommand("GetActiveManagersForDropdown", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            string name = dr["Name"].ToString();
                            string id = dr["UserId"].ToString();

                            ddlManagerAdd.Items.Add(new ListItem(name, id));
                            ddlManagerEdit.Items.Add(new ListItem(name, id));
                        }
                    }
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
