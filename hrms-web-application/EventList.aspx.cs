using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class EventList : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEventTypes();

                LoadEvents();
            }
        }

        private void LoadEventTypes()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand("SP_GetEventTypesForDropdown", con);

                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                ddlEventType.DataSource = reader;
                ddlEventType.DataTextField = "Name";  
                ddlEventType.DataValueField = "Id";   
                ddlEventType.DataBind();

                reader.Close();
                con.Close();

                ddlEventType.Items.Insert(0, new ListItem("-- Select Event Type --", "0"));
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading event types: " + ex.Message, "danger");
            }
        }

        
        private void LoadEvents()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand("SP_GetAllEvents", con);

                cmd.CommandType = CommandType.StoredProcedure;

                string searchText = txtSearch.Text.Trim();

                cmd.Parameters.AddWithValue("@SearchText",
                    string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                da.Fill(dt);

                gvEvents.DataSource = dt;

                gvEvents.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue);

                gvEvents.DataBind();

                UpdateInfoLabel(dt.Rows.Count);

                UpdatePagination();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading events: " + ex.Message, "danger");
            }
        }

        private void UpdateInfoLabel(int totalRecords)
        {
            if (totalRecords == 0)
            {
                lblInfo.Text = "Showing 0 to 0 of 0 entries";
                return;
            }

            int pageSize = gvEvents.PageSize;
            int currentPage = gvEvents.PageIndex;

            int startRecord = (currentPage * pageSize) + 1;
            int endRecord = Math.Min((currentPage + 1) * pageSize, totalRecords);

            lblInfo.Text = string.Format("Showing {0} to {1} of {2} entries",
                startRecord, endRecord, totalRecords);
        }

        private void UpdatePagination()
        {
            lblCurrentPage.Text = (gvEvents.PageIndex + 1).ToString();

            btnPrevious.Enabled = gvEvents.PageIndex > 0;

            btnNext.Enabled = gvEvents.PageIndex < gvEvents.PageCount - 1;

            if (!btnPrevious.Enabled)
            {
                btnPrevious.CssClass = "page-link disabled";
            }
            else
            {
                btnPrevious.CssClass = "page-link";
            }

            if (!btnNext.Enabled)
            {
                btnNext.CssClass = "page-link disabled";
            }
            else
            {
                btnNext.CssClass = "page-link";
            }
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvEvents.PageIndex = 0;

            LoadEvents();
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            gvEvents.PageIndex = 0;

            LoadEvents();
        }

        protected void gvEvents_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvEvents.PageIndex = e.NewPageIndex;

            LoadEvents();
        }

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            if (gvEvents.PageIndex > 0)
            {
                gvEvents.PageIndex--;

                LoadEvents();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (gvEvents.PageIndex < gvEvents.PageCount - 1)
            {
                gvEvents.PageIndex++;

                LoadEvents();
            }
        }

        protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int eventId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditEvent")
            {
                LoadEventForEdit(eventId);
            }
            else if (e.CommandName == "DeleteEvent")
            {
                DeleteEvent(eventId);
            }
        }

       
        private void LoadEventForEdit(int eventId)
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand("SP_GetEventById", con);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", eventId);

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hfEventId.Value = reader["Id"].ToString();

                    txtTitle.Text = reader["Title"].ToString();

                    string dateValue = reader["Date"].ToString();
                    DateTime parsedDate;
                    if (DateTime.TryParse(dateValue, out parsedDate))
                    {
                        txtDate.Text = parsedDate.ToString("yyyy-MM-dd");
                    }

                    ddlEventType.SelectedValue = reader["EventTypeId"].ToString();

                    lblModalTitle.Text = "Edit Event";

                    string script = @"
                        <script type='text/javascript'>
                            window.onload = function() {
                                var modal = new bootstrap.Modal(document.getElementById('eventModal'));
                                modal.show();
                            };
                        </script>";

                    ClientScript.RegisterStartupScript(this.GetType(), "ShowEditModal", script);
                }

                reader.Close();
                con.Close();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        protected void btnSaveEvent_Click(object sender, EventArgs e)
        {
            if (hfEventId.Value == "0")
            {
                AddEvent();
            }
            else
            {
                UpdateEvent();
            }
        }

        
        private void AddEvent()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand("SP_AddEvent", con);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Date", txtDate.Text.Trim());
                cmd.Parameters.AddWithValue("@EventTypeId", ddlEventType.SelectedValue);

                con.Open();

                int result = Convert.ToInt32(cmd.ExecuteScalar());

                con.Close();

                if (result == 1)
                {
                    ShowMessage("Event added successfully!", "success");

                    ClearForm();

                    LoadEvents();
                }
                else
                {
                    ShowMessage("Failed to add event", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        
        private void UpdateEvent()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand("SP_UpdateEvent", con);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", hfEventId.Value);
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Date", txtDate.Text.Trim());
                cmd.Parameters.AddWithValue("@EventTypeId", ddlEventType.SelectedValue);

                
                con.Open();

                int result = Convert.ToInt32(cmd.ExecuteScalar());

                con.Close();

                if (result == 1)
                {
                    ShowMessage("Event updated successfully!", "success");

                    ClearForm();

                    LoadEvents();
                }
                else
                {
                    ShowMessage("Failed to update event", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        
        private void DeleteEvent(int eventId)
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand("SP_DeleteEvent", con);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Id", eventId);

               
                con.Open();

                int result = Convert.ToInt32(cmd.ExecuteScalar());

                con.Close();

                if (result == 1)
                {
                    ShowMessage("Event deleted successfully!", "success");

                    LoadEvents();
                }
                else
                {
                    ShowMessage("Failed to delete event.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        protected void gvEvents_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onmouseover"] = "this.style.backgroundColor='#f8f9fa'";
                e.Row.Attributes["onmouseout"] = "this.style.backgroundColor=''";
            }
        }

        private void ClearForm()
        {
            txtTitle.Text = string.Empty;

            txtDate.Text = string.Empty;

            ddlEventType.SelectedIndex = 0;

            hfEventId.Value = "0";

            lblModalTitle.Text = "Add Event";
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