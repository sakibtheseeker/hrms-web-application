using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace hrms_web_application
{
    public partial class EmployeeList : System.Web.UI.Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int roleId = Convert.ToInt32(Session["RoleId"]);
            if (roleId != 3) // Admin only
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindCounts();
                BindEmployees();
                BindRoles();
                BindDepartments();
                // BindManagers(); // Only when needed (on role change)
            }
        }

        // ===================== STATS =====================
        private void BindCounts()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetUserStatusCounts", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblTotalCount.Text = dr["Total"].ToString();
                            lblActiveCount.Text = dr["ActiveCount"].ToString();
                            lblInactiveCount.Text = dr["InactiveCount"].ToString();
                        }
                    }
                }
            }
        }


        // ===================== BIND EMPLOYEES =====================
        private void BindEmployees()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetEmployeesList", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptEmployeesTable.DataSource = dt;
                    rptEmployeesTable.DataBind();

                    rptEmployeesGrid.DataSource = dt;
                    rptEmployeesGrid.DataBind();
                }
            }
        }


        // ===================== TOGGLE STATUS (Single Method) =====================
        protected void ToggleStatus_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int userId = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("ToggleUserStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            BindCounts();
            BindEmployees();
        }


        [WebMethod]
        [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
        public static void ToggleEmployeeStatus(int userId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("ToggleEmployeeStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }



        // ===================== DROPDOWNS =====================
        private void BindRoles()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetAllRolesForDropdown", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlRole.DataSource = dt;
                    ddlRole.DataTextField = "RoleName";
                    ddlRole.DataValueField = "RoleId";
                    ddlRole.DataBind();
                    ddlRole.Items.Insert(0, new ListItem("-- Select Role --", "0"));
                }
            }
        }


        private void BindDepartments()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetAllDepartmentsForDropdown", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlDepartment.DataSource = dt;
                    ddlDepartment.DataTextField = "Name";
                    ddlDepartment.DataValueField = "DepartmentId";
                    ddlDepartment.DataBind();
                    ddlDepartment.Items.Insert(0, new ListItem("-- Select Department --", "0"));
                }
            }
        }


        private void BindDesignations(int departmentId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetDesignationsByDepartment", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@DeptId", departmentId);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlDesignation.DataSource = dt;
                    ddlDesignation.DataTextField = "Name";
                    ddlDesignation.DataValueField = "DesignationId";
                    ddlDesignation.DataBind();
                    ddlDesignation.Items.Insert(0, new ListItem("-- Select Designation --", "0"));
                }
            }
        }


        private void BindManagers()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetActiveManagers", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlManager.DataSource = dt;
                    ddlManager.DataTextField = "Name";
                    ddlManager.DataValueField = "UserId";
                    ddlManager.DataBind();
                    ddlManager.Items.Insert(0, new ListItem("-- Select Manager --", "0"));
                }
            }
        }


        // ===================== MODAL EVENTS =====================
        protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
        {
            string roleName = ddlRole.SelectedItem.Text.Trim();
            managerContainer.Visible = (roleName == "Employee");

            if (managerContainer.Visible)
                BindManagers();

            upModal.Update();
        }

        protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            int deptId = Convert.ToInt32(ddlDepartment.SelectedValue);
            if (deptId > 0)
                BindDesignations(deptId);
            else
            {
                ddlDesignation.Items.Clear();
                ddlDesignation.Items.Insert(0, new ListItem("-- Select Designation --", "0"));
            }

            upModal.Update();
        }

        // ===================== ADD EMPLOYEE =====================
        protected void btnSaveEmployee_Click(object sender, EventArgs e)
        {
            string imagePath = "~/assets/img/profiles/default.png";

            if (fuProfilePicture.HasFile)
            {
                string ext = System.IO.Path.GetExtension(fuProfilePicture.FileName);
                string fileName = Guid.NewGuid() + ext;
                imagePath = "~/Uploads/ProfilePictures/" + fileName;
                fuProfilePicture.SaveAs(Server.MapPath(imagePath));
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("AddEmployee", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@PasswordHash", txtPassword.Text.Trim()); // TODO: hash
                    cmd.Parameters.AddWithValue("@PhoneNumber", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@RoleId", Convert.ToInt32(ddlRole.SelectedValue));

                    cmd.Parameters.AddWithValue(
                        "@DepartmentId",
                        ddlDepartment.SelectedValue == "0"
                            ? (object)DBNull.Value
                            : Convert.ToInt32(ddlDepartment.SelectedValue)
                    );

                    cmd.Parameters.AddWithValue(
                        "@DesignationtId",
                        ddlDesignation.SelectedValue == "0"
                            ? (object)DBNull.Value
                            : Convert.ToInt32(ddlDesignation.SelectedValue)
                    );

                    cmd.Parameters.AddWithValue(
                        "@ReportingManager",
                        managerContainer.Visible && ddlManager.SelectedValue != "0"
                            ? Convert.ToInt32(ddlManager.SelectedValue)
                            : (object)DBNull.Value
                    );

                    cmd.Parameters.AddWithValue("@DateOfJoining", DateTime.Parse(txtDOJ.Text));
                    cmd.Parameters.AddWithValue("@DateOfBirth", DateTime.Parse(txtDOB.Text));
                    cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@AboutEmployee", txtAbout.Text.Trim());
                    cmd.Parameters.AddWithValue("@ProfilePicture", imagePath);
                    cmd.Parameters.AddWithValue("@Status", ddlStatusAdd.SelectedValue);

                    cmd.Parameters.AddWithValue(
                        "@CreatedBy",
                        Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            BindCounts();
            BindEmployees();

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "closeModal",
                "$('#exampleModal').modal('hide'); alert('Employee added successfully!');",
                true
            );
        }

    }
}