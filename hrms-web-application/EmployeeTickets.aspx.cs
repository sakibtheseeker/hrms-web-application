using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Data;

using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class EmployeeTickets : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMyTickets();
            }
        }

        // ================= Raise Ticket =================
        protected void btnRaiseTicket_Click(object sender, EventArgs e)
        {
            // -------- MINIMUM VALIDATIONS --------
            if (txtTitle.Text.Trim() == "")
            {
                ShowAlert("Ticket title is required");
                return;
            }

            if (txtSubject.Text.Trim() == "")
            {
                ShowAlert("Subject is required");
                return;
            }

            if (txtDescription.Text.Trim() == "")
            {
                ShowAlert("Description is required");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            // -------- Attachment Handling --------
            string filePath = "";
            if (fuAttachment.HasFile)
            {
                string folderPath = Server.MapPath("~/TicketAttachments/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string fileName = Guid.NewGuid() + "_" + fuAttachment.FileName;
                filePath = "~/TicketAttachments/" + fileName;
                fuAttachment.SaveAs(Server.MapPath(filePath));
            }

            // -------- Insert Ticket --------
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Tickets
                    (TicketTitle, EventCategory, Subject, AssignedBy, AssignedTo,
                     TicketDescription, Priority, Status, Visibility, CreatedAt)
                    VALUES
                    (@Title, @Category, @Subject, NULL, NULL,
                     @Description, @Priority, 'Open', 'Private', GETDATE())", con);

                cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Subject", txtSubject.Text.Trim());
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            LoadMyTickets();
            ShowAlert("Ticket raised successfully");
        }

        // ================= Load Employee Tickets =================
        private void LoadMyTickets()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT TicketId, TicketTitle, Subject, Status
                    FROM Tickets
                    WHERE CreatedBy = @UserId
                    ORDER BY CreatedAt DESC", con);

                da.SelectCommand.Parameters.AddWithValue("@UserId", userId);
                DataTable dt = new DataTable();

                da.Fill(dt);

                gvTickets.DataSource = dt;
                gvTickets.DataBind();
            }
        }

        // ================= Helpers =================
        private void ClearForm()
        {
            txtTitle.Text = "";
            txtSubject.Text = "";
            txtDescription.Text = "";
            ddlCategory.SelectedIndex = 0;
            ddlPriority.SelectedIndex = 0;
        }

        private void ShowAlert(string msg)
        {
            ClientScript.RegisterStartupScript(this.GetType(),
                "alert", $"alert('{msg}');", true);
        }
    }
}