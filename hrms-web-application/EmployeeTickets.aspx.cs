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
                LoadMyTickets();
        }

        protected void btnRaiseTicket_Click(object sender, EventArgs e)
        {
            if (txtTitle.Text.Trim() == "")
            {
                Alert("Ticket Title is required");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            // (Attachment save – optional, future ready)
            if (fuAttachment.HasFile)
            {
                string folder = Server.MapPath("~/TicketAttachments/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = Guid.NewGuid() + "_" + fuAttachment.FileName;
                fuAttachment.SaveAs(folder + fileName);
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("sp_Employee_RaiseTicket", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TicketTitle", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@CreatedBy", userId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtTitle.Text = "";
            LoadMyTickets();
            Alert("Ticket raised successfully");
        }

        private void LoadMyTickets()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("sp_Employee_GetMyTickets", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", userId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTickets.DataSource = dt;
                gvTickets.DataBind();
            }
        }

        protected void gvTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewTicket")
            {
                int ticketId = Convert.ToInt32(e.CommandArgument);
                LoadTicketReplies(ticketId);

                ClientScript.RegisterStartupScript(
                    this.GetType(),
                    "popup",
                    "$('#ticketModal').modal('show');",
                    true);
            }
        }

        private void LoadTicketReplies(int ticketId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("sp_Employee_GetTicketReplies", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TicketId", ticketId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptReplies.DataSource = dt;
                rptReplies.DataBind();
            }
        }

        private void Alert(string msg)
        {
            ClientScript.RegisterStartupScript(
                this.GetType(),
                "alert",
                $"alert('{msg}');",
                true);
        }
    }
}