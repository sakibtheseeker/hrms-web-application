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
                SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        COUNT(*) AS Total,
                        SUM(CASE WHEN Status='Active' THEN 1 ELSE 0 END) AS ActiveCount,
                        SUM(CASE WHEN Status='Inactive' THEN 1 ELSE 0 END) AS InactiveCount
                    FROM [User]
                    WHERE RoleId != 1", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblTotalCount.Text = dr["Total"].ToString();
                    lblActiveCount.Text = dr["ActiveCount"].ToString();
                    lblInactiveCount.Text = dr["InactiveCount"].ToString();
                }
            }
        }

        // ===================== BIND EMPLOYEES =====================
        private void BindEmployees()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT
                        u.UserId,
                        u.FirstName,
                        u.LastName,
                        u.Email,
                        u.PhoneNumber,
                        u.ProfilePicture,
                        u.DateOfJoining,
                        u.Status,
                        r.RoleName,
                        d.Name AS DepartmentName,
                        des.Name AS DesignationName,
                        ISNULL(mgr.FirstName + ' ' + mgr.LastName, 'N/A') AS ReportingManagerName
                    FROM [User] u
                    LEFT JOIN Role r ON u.RoleId = r.RoleId
                    LEFT JOIN Departments d ON u.DepartmentId = d.DepartmentId
                    LEFT JOIN Designations des ON u.DesignationtId = des.DesignationId
                    LEFT JOIN [User] mgr ON u.ReportingManager = mgr.UserId
                    WHERE u.RoleId != 3  -- Exclude Admin
                    ORDER BY u.FirstName ASC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptEmployeesTable.DataSource = dt;
                rptEmployeesTable.DataBind();

                rptEmployeesGrid.DataSource = dt;
                rptEmployeesGrid.DataBind();
            }
        }

        // ===================== TOGGLE STATUS (Single Method) =====================
        protected void ToggleStatus_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int userId = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            UPDATE [User]
            SET Status = CASE WHEN Status = 'Active' THEN 'Inactive' ELSE 'Active' END
            WHERE UserId = @UserId", con);

                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            BindCounts();
            BindEmployees();
        }

        [WebMethod]
        [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
        public static void ToggleEmployeeStatus(int userId)
        {
            string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            UPDATE [User]
            SET Status = CASE 
                WHEN Status = 'Active' THEN 'Inactive'
                ELSE 'Active'
            END
            WHERE UserId = @UserId", con);

                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }


        // ===================== DROPDOWNS =====================
        private void BindRoles()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT RoleId, RoleName FROM Role", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlRole.DataSource = dt;
                ddlRole.DataTextField = "RoleName";
                ddlRole.DataValueField = "RoleId";
                ddlRole.DataBind();
                ddlRole.Items.Insert(0, new ListItem("-- Select Role --", "0"));
            }
        }

        private void BindDepartments()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT DepartmentId, Name FROM Departments", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlDepartment.DataSource = dt;
                ddlDepartment.DataTextField = "Name";
                ddlDepartment.DataValueField = "DepartmentId";
                ddlDepartment.DataBind();
                ddlDepartment.Items.Insert(0, new ListItem("-- Select Department --", "0"));
            }
        }

        private void BindDesignations(int departmentId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT DesignationId, Name FROM Designations WHERE DepartmentId = @DeptId", con);
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

        private void BindManagers()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT UserId, FirstName + ' ' + LastName AS Name
                    FROM [User]
                    WHERE Status = 'Active' AND RoleId = (SELECT RoleId FROM Role WHERE RoleName = 'Employee')", con);

                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlManager.DataSource = dt;
                ddlManager.DataTextField = "Name";
                ddlManager.DataValueField = "UserId";
                ddlManager.DataBind();
                ddlManager.Items.Insert(0, new ListItem("-- Select Manager --", "0"));
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
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO [User] 
                    (FirstName, LastName, Email, PasswordHash, PhoneNumber, RoleId, DepartmentId, 
                     DesignationtId, ReportingManager, DateOfJoining, DateOfBirth, Gender, 
                     Address, AboutEmployee, Status, ProfilePicture)
                    VALUES 
                    (@FirstName, @LastName, @Email, @Password, @Phone, @RoleId, @DeptId, 
                     @DesigId, @ManagerId, @DOJ, @DOB, @Gender, @Address, @About, @Status, @Profile)", con);

                cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim()); // TODO: Hash this!
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@RoleId", ddlRole.SelectedValue);
                cmd.Parameters.AddWithValue("@DeptId", ddlDepartment.SelectedValue == "0" ? (object)DBNull.Value : ddlDepartment.SelectedValue);
                cmd.Parameters.AddWithValue("@DesigId", ddlDesignation.SelectedValue == "0" ? (object)DBNull.Value : ddlDesignation.SelectedValue);
                cmd.Parameters.AddWithValue("@ManagerId",
                    managerContainer.Visible && ddlManager.SelectedValue != "0"
                    ? ddlManager.SelectedValue
                    : (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@DOJ", DateTime.Parse(txtDOJ.Text));
                cmd.Parameters.AddWithValue("@DOB", DateTime.Parse(txtDOB.Text));
                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@About", txtAbout.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddlStatusAdd.SelectedValue);
                cmd.Parameters.AddWithValue("@Profile", imagePath);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            BindCounts();
            BindEmployees();

            ScriptManager.RegisterStartupScript(this, GetType(), "closeModal",
                "$('#exampleModal').modal('hide'); alert('Employee added successfully!');", true);
        }
    }
}