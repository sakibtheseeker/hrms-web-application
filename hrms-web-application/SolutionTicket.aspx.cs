using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class SolutionTicket : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAssignedTickets();
            }
        }

        // ================= LOAD ASSIGNED TICKETS =================
        private void LoadAssignedTickets()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT TicketId, TicketTitle, Status
                      FROM Tickets
                      WHERE AssignedTo = @UserId
                        AND Status IN ('Assigned','Open')
                      ORDER BY TicketId DESC", con);

                da.SelectCommand.Parameters.AddWithValue("@UserId", userId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvAssignedTickets.DataSource = dt;
                gvAssignedTickets.DataBind();
            }
        }

        // ================= VIEW / SOLVE =================
        protected void gvAssignedTickets_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewTicket")
            {
                int ticketId = Convert.ToInt32(e.CommandArgument);
                hfTicketId.Value = ticketId.ToString();

                LoadReplies(ticketId);

                ClientScript.RegisterStartupScript(
                    this.GetType(),
                    "openModal",
                    "$('#solutionModal').modal('show');",
                    true);
            }
        }

        // ================= LOAD REPLIES =================
        private void LoadReplies(int ticketId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT ReplyMessage, RepliedBy, RepliedAt
                      FROM TicketReplies
                      WHERE TicketId = @TicketId
                      ORDER BY RepliedAt ASC", con);

                da.SelectCommand.Parameters.AddWithValue("@TicketId", ticketId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptReplies.DataSource = dt;
                rptReplies.DataBind();
            }
        }

        // ================= SUBMIT SOLUTION =================
        protected void btnSubmitSolution_Click(object sender, EventArgs e)
        {
            if (txtSolution.Text.Trim() == "")
            {
                ShowAlert("Please enter solution");
                return;
            }

            int ticketId = Convert.ToInt32(hfTicketId.Value);
            string repliedBy = Session["UserName"].ToString(); // employee name

            if (fuSolutionAttachment.HasFile)
            {
                string folder = Server.MapPath("~/TicketAttachments/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = Guid.NewGuid() + "_" + fuSolutionAttachment.FileName;
                fuSolutionAttachment.SaveAs(folder + fileName);
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO TicketReplies
                      (TicketId, ReplyMessage, RepliedBy, RepliedAt)
                      VALUES
                      (@TicketId, @Message, @RepliedBy, GETDATE())", con);

                cmd.Parameters.AddWithValue("@TicketId", ticketId);
                cmd.Parameters.AddWithValue("@Message", txtSolution.Text.Trim());
                cmd.Parameters.AddWithValue("@RepliedBy", repliedBy);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtSolution.Text = "";
            LoadReplies(ticketId);
            ShowAlert("Solution submitted successfully");
        }

        // ================= CLOSE TICKET =================
        protected void btnCloseTicket_Click(object sender, EventArgs e)
        {
            int ticketId = Convert.ToInt32(hfTicketId.Value);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    @"UPDATE Tickets
                      SET Status = 'Closed'
                      WHERE TicketId = @TicketId", con);

                cmd.Parameters.AddWithValue("@TicketId", ticketId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadAssignedTickets();
            ShowAlert("Ticket closed successfully");
        }

        // ================= ALERT =================
        private void ShowAlert(string msg)
        {
            ClientScript.RegisterStartupScript(
                this.GetType(),
                "alert",
                $"alert('{msg}');",
                true);
        }
    }
}