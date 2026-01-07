using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class AddMasterEvent : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEventTypes();
                SetDefaultColor();
            }
        }

        private void SetDefaultColor()
        {
            if (string.IsNullOrEmpty(txtColor.Text))
            {
                txtColor.Text = "#563d7c";
            }
        }

        private void LoadEventTypes()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("SP_GetAllEventTypes", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvEventTypes.DataSource = dt;
                gvEventTypes.DataBind();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading event types: " + ex.Message, "danger");
            }
        }

        protected void btnAddEventType_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEventTypeName.Text))
            {
                ShowMessage("Please enter event type name", "danger");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtColor.Text))
            {
                ShowMessage("Please select a color", "danger");
                return;
            }

            if (!txtColor.Text.StartsWith("#") || txtColor.Text.Length != 7)
            {
                ShowMessage("Please enter valid color format (e.g., #563d7c)", "danger");
                return;
            }

            AddEventType();
        }

        private void AddEventType()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("SP_AddEventType", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Name", txtEventTypeName.Text.Trim());
                cmd.Parameters.AddWithValue("@Color", txtColor.Text.Trim().ToUpper());

                con.Open();
                int result = Convert.ToInt32(cmd.ExecuteScalar());
                con.Close();

                if (result == 1)
                {
                    ShowMessage("Event type added successfully!", "success");
                    ClearForm();
                    LoadEventTypes();
                }
                else if (result == -1)
                {
                    ShowMessage("Event type with this name already exists!", "warning");
                }
                else
                {
                    ShowMessage("Failed to add event type. Please try again.", "danger");
                }
            }
            catch (SqlException sqlEx)
            {
                ShowMessage("Database error: " + sqlEx.Message, "danger");
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        protected void gvEventTypes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int eventTypeId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditEventType")
            {
                LoadEventTypeForEdit(eventTypeId);
            }
            else if (e.CommandName == "DeleteEventType")
            {
                DeleteEventType(eventTypeId);
            }
        }

        private void LoadEventTypeForEdit(int eventTypeId)
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("SP_GetEventTypeById", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", eventTypeId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string id = reader["Id"].ToString();
                    string name = reader["Name"].ToString();
                    string color = reader["Color"].ToString();

                    reader.Close();
                    con.Close();

                    string script = string.Format(@"
                        <script type='text/javascript'>
                            window.onload = function() {{
                                openEditModal('{0}', '{1}', '{2}');
                            }};
                        </script>",
                        id,
                        name.Replace("'", "\\'"),
                        color
                    );

                    ClientScript.RegisterStartupScript(this.GetType(), "OpenEditModal", script);
                }
                else
                {
                    con.Close();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        protected void btnUpdateEventType_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEditEventTypeName.Text))
            {
                ShowMessage("Please enter event type name", "danger");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtEditColor.Text))
            {
                ShowMessage("Please select a color", "danger");
                return;
            }

            if (!txtEditColor.Text.StartsWith("#") || txtEditColor.Text.Length != 7)
            {
                ShowMessage("Please enter valid color format (e.g., #563d7c)", "danger");
                return;
            }

            UpdateEventTypeFromModal();
        }

        private void UpdateEventTypeFromModal()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("SP_UpdateEventType", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", hfEditEventTypeId.Value);
                cmd.Parameters.AddWithValue("@Name", txtEditEventTypeName.Text.Trim());
                cmd.Parameters.AddWithValue("@Color", txtEditColor.Text.Trim().ToUpper());

                con.Open();
                int result = Convert.ToInt32(cmd.ExecuteScalar());
                con.Close();

                if (result == 1)
                {
                    ShowMessage("Event type updated successfully!", "success");
                    LoadEventTypes();
                }
                else if (result == -1)
                {
                    ShowMessage("Event type with this name already exists!", "warning");
                }
                else
                {
                    ShowMessage("Failed to update event type.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        private void DeleteEventType(int eventTypeId)
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("SP_DeleteEventType", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", eventTypeId);

                con.Open();
                int result = Convert.ToInt32(cmd.ExecuteScalar());
                con.Close();

                if (result == 1)
                {
                    ShowMessage("Event type deleted successfully!", "success");
                    LoadEventTypes();
                }
                else if (result < 0)
                {
                    int eventCount = Math.Abs(result);
                    ShowMessage("Cannot delete this event type. It is being used by " + eventCount + " event(s).", "warning");
                }
                else
                {
                    ShowMessage("Failed to delete event type.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            txtEventTypeName.Text = string.Empty;
            txtColor.Text = "#563d7c";
            hfEventTypeId.Value = "0";
            btnAddEventType.Text = "Add Event Type";
            btnCancel.Visible = false;
        }

        protected void gvEventTypes_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onmouseover"] = "this.style.backgroundColor='#f8f9fa'";
                e.Row.Attributes["onmouseout"] = "this.style.backgroundColor=''";

                LinkButton btnDelete = (LinkButton)e.Row.FindControl("btnDelete");
                if (btnDelete != null)
                {
                    btnDelete.OnClientClick = "return confirm('Are you sure you want to delete this event type?');";
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-" + type + " alert-dismissible fade show mb-3";

            string script = @"
                setTimeout(function() {
                    var alert = document.querySelector('.alert');
                    if (alert) {
                        var bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                }, 5000);
            ";

            ClientScript.RegisterStartupScript(this.GetType(), "hideAlert", script, true);
        }
    }
}
