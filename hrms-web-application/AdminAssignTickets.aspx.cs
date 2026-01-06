using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class AdminAssignTickets : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOpenTickets();
                LoadDepartments();
            }
        }

        // ================= OPEN TICKETS =================
        private void LoadOpenTickets()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlDataAdapter da = new SqlDataAdapter(
                        @"SELECT TicketId, TicketTitle, Status
                          FROM Tickets
                          WHERE Status = 'Open'
                          ORDER BY TicketId DESC", con);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvTickets.DataSource = dt;
                    gvTickets.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading tickets: " + ex.Message);
            }
        }

        // ================= LOAD DEPARTMENTS =================
        private void LoadDepartments()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlDataAdapter da = new SqlDataAdapter(
                        @"SELECT DepartmentId, Name
                          FROM Departments
                          WHERE Status = 'Active'", con);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlDepartment.DataSource = dt;
                    ddlDepartment.DataTextField = "Name";
                    ddlDepartment.DataValueField = "DepartmentId";
                    ddlDepartment.DataBind();

                    ddlDepartment.Items.Insert(0,
                        new ListItem("-- Select Department --", ""));
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading departments: " + ex.Message);
            }
        }

        // ================= DEPARTMENT → DESIGNATION =================
        protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlDesignation.Items.Clear();
            ddlEmployee.Items.Clear();
            ddlEmployee.Items.Insert(0, new ListItem("-- Select Employee --", ""));

            if (ddlDepartment.SelectedValue == "")
            {
                ddlDesignation.Items.Insert(0, new ListItem("-- Select Designation --", ""));
                ShowModal();
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlDataAdapter da = new SqlDataAdapter(
                        @"SELECT DesignationId, Name
                          FROM Designations
                          WHERE DepartmentId = @DepartmentId
                            AND Status = 'Active'", con);

                    da.SelectCommand.Parameters.AddWithValue(
                        "@DepartmentId", ddlDepartment.SelectedValue);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlDesignation.DataSource = dt;
                    ddlDesignation.DataTextField = "Name";
                    ddlDesignation.DataValueField = "DesignationId";
                    ddlDesignation.DataBind();

                    ddlDesignation.Items.Insert(0,
                        new ListItem("-- Select Designation --", ""));
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading designations: " + ex.Message);
            }

            ShowModal();
        }

        // ================= DESIGNATION → EMPLOYEE =================
        protected void ddlDesignation_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlEmployee.Items.Clear();

            if (ddlDesignation.SelectedValue == "")
            {
                ddlEmployee.Items.Insert(0, new ListItem("-- Select Employee --", ""));
                ShowModal();
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlDataAdapter da = new SqlDataAdapter(
                        @"SELECT UserId, FullName
                          FROM [User]
                          WHERE DepartmentId = @DepartmentId
                            AND DesignationId = @DesignationId
                            AND Role = 'Employee'", con);

                    da.SelectCommand.Parameters.AddWithValue(
                        "@DepartmentId", ddlDepartment.SelectedValue);

                    da.SelectCommand.Parameters.AddWithValue(
                        "@DesignationId", ddlDesignation.SelectedValue);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlEmployee.DataSource = dt;
                    ddlEmployee.DataTextField = "FullName";
                    ddlEmployee.DataValueField = "UserId";
                    ddlEmployee.DataBind();

                    ddlEmployee.Items.Insert(0,
                        new ListItem("-- Select Employee --", ""));
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading employees: " + ex.Message);
            }

            ShowModal();
        }

        // ================= OPEN MODAL =================
        protected void gvTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AssignTicket")
            {
                hfTicketId.Value = e.CommandArgument.ToString();

                // Reset dropdowns
                ddlDepartment.SelectedIndex = 0;
                ddlDesignation.Items.Clear();
                ddlDesignation.Items.Insert(0, new ListItem("-- Select Designation --", ""));
                ddlEmployee.Items.Clear();
                ddlEmployee.Items.Insert(0, new ListItem("-- Select Employee --", ""));

                ShowModal();
            }
        }

        // ================= FINAL ASSIGN =================
        protected void btnAssign_Click(object sender, EventArgs e)
        {
            if (ddlDepartment.SelectedValue == "" ||
                ddlDesignation.SelectedValue == "" ||
                ddlEmployee.SelectedValue == "")
            {
                ShowAlert("Please select Department, Designation and Employee");
                ShowModal();
                return;
            }

            try
            {
                int ticketId = Convert.ToInt32(hfTicketId.Value);
                int assignedTo = Convert.ToInt32(ddlEmployee.SelectedValue);
                int adminId = Convert.ToInt32(Session["UserId"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Tickets
                          SET AssignedTo = @AssignedTo,
                              AssignedBy = @AdminId,
                              Status = 'Assigned'
                          WHERE TicketId = @TicketId", con);

                    cmd.Parameters.AddWithValue("@AssignedTo", assignedTo);
                    cmd.Parameters.AddWithValue("@AdminId", adminId);
                    cmd.Parameters.AddWithValue("@TicketId", ticketId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadOpenTickets();
                ShowAlert("Ticket assigned successfully");
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message);
                ShowModal();
            }
        }

        // ================= SHOW MODAL HELPER =================
        private void ShowModal()
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showModal",
                "$('#assignModal').modal('show');", true);
        }

        // ================= ALERT =================
        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"alert('{msg.Replace("'", "\\'")}');", true);
        }
    }
}