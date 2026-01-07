using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class AddEvent : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        private DateTime CurrentDate
        {
            get
            {
                if (ViewState["CurrentDate"] != null)
                {
                    return (DateTime)ViewState["CurrentDate"];
                }
                return DateTime.Now;
            }
            set
            {
                ViewState["CurrentDate"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CurrentDate = DateTime.Now;
                LoadEventTypes();
                LoadCalendar();
                LoadUpcomingEvents();
            }
        }

        private void LoadEventTypes()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("sp_GetEventTypes", con);
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
                ShowAlert("Error loading event types: " + ex.Message, "error");
            }
        }

        private void LoadCalendar()
        {
            EventCalendar.VisibleDate = CurrentDate;
            EventCalendar.SelectedDate = CurrentDate;
            lblCurrentMonth.Text = CurrentDate.ToString("MMMM yyyy");
        }

        protected void EventCalendar_DayRender(object sender, DayRenderEventArgs e)
        {
            if (e.Day.IsOtherMonth)
            {
                e.Cell.CssClass = "calendar-other-month";
                e.Cell.Style["background-color"] = "#f8f9fa";
            }
            else if (e.Day.IsToday)
            {
                e.Cell.CssClass = "calendar-today";
                e.Cell.Style["background-color"] = "#fff9e6";
            }
            else
            {
                e.Cell.CssClass = "calendar-day";
            }

            if (e.Cell.Controls.Count > 0 && e.Cell.Controls[0] is LiteralControl)
            {
                LiteralControl dayLink = (LiteralControl)e.Cell.Controls[0];
                dayLink.Text = "<strong>" + e.Day.DayNumberText + "</strong>";
            }

            LoadEventsForDate(e.Day.Date, e.Cell);
        }

        private void LoadEventsForDate(DateTime date, TableCell cell)
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("sp_GetEventsByDate", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Date", date.Date);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string title = reader["Title"].ToString();
                    string color = reader["Color"].ToString();

                    string eventHtml = string.Format(
                        "<div class='event-badge' style='background-color: {0}' title='{1}'>{2}</div>",
                        color,
                        title,
                        title.Length > 12 ? title.Substring(0, 12) + "..." : title
                    );

                    cell.Controls.Add(new LiteralControl(eventHtml));
                }

                reader.Close();
                con.Close();
            }
            catch (Exception)
            {
            }
        }

        private void LoadUpcomingEvents()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlDataAdapter da = new SqlDataAdapter("sp_GetUpcomingEvents", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;

                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptUpcomingEvents.DataSource = dt;
                    rptUpcomingEvents.DataBind();
                    lblNoEvents.Visible = false;
                }
                else
                {
                    lblNoEvents.Visible = true;
                }
            }
            catch (Exception)
            {
                lblNoEvents.Visible = true;
                lblNoEvents.Text = "No upcoming events";
            }
        }

        protected void btnPrevMonth_Click(object sender, EventArgs e)
        {
            CurrentDate = CurrentDate.AddMonths(-1);
            LoadCalendar();
        }

        protected void btnNextMonth_Click(object sender, EventArgs e)
        {
            CurrentDate = CurrentDate.AddMonths(1);
            LoadCalendar();
        }

        protected void btnToday_Click(object sender, EventArgs e)
        {
            CurrentDate = DateTime.Now;
            LoadCalendar();
        }

        protected void EventCalendar_SelectionChanged(object sender, EventArgs e)
        {
            txtDate.Text = EventCalendar.SelectedDate.ToString("yyyy-MM-dd");

            string script = @"
                <script type='text/javascript'>
                    window.onload = function() {
                        var modal = new bootstrap.Modal(document.getElementById('eventModal'));
                        modal.show();
                    };
                </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", script);
        }

        protected void btnSaveEvent_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtTitle.Text))
            {
                ShowAlert("Please enter event title", "error");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtDate.Text))
            {
                ShowAlert("Please select event date", "error");
                return;
            }

            if (ddlEventType.SelectedValue == "0")
            {
                ShowAlert("Please select event type", "error");
                return;
            }

            SaveEvent();
        }

        private void SaveEvent()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                SqlCommand cmd = new SqlCommand("sp_InsertEvent", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Date", txtDate.Text.Trim());
                cmd.Parameters.AddWithValue("@EventTypeId", ddlEventType.SelectedValue);
                cmd.Parameters.AddWithValue("@Status", "Active");

                con.Open();
                int result = cmd.ExecuteNonQuery();
                con.Close();

                if (result > 0)
                {
                    ShowAlert("Event added successfully!", "success");
                    ClearForm();
                    LoadCalendar();
                    LoadUpcomingEvents();
                }
                else
                {
                    ShowAlert("Failed to add event", "error");
                }
            }
            catch (SqlException sqlEx)
            {
                ShowAlert("Database error: " + sqlEx.Message, "error");
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message, "error");
            }
        }

        private void ClearForm()
        {
            txtTitle.Text = string.Empty;
            txtDate.Text = string.Empty;
            ddlEventType.SelectedIndex = 0;
            hfEventId.Value = "0";
        }

        private void ShowAlert(string message, string type)
        {
            string icon = type == "success" ? "success" : "error";
            string title = type == "success" ? "Success!" : "Error!";

            string script = string.Format(@"
                <script type='text/javascript'>
                    Swal.fire({{
                        icon: '{0}',
                        title: '{1}',
                        text: '{2}',
                        confirmButtonText: 'OK'
                    }}).then(function() {{
                        {3}
                    }});
                </script>",
                icon,
                title,
                message.Replace("'", "\\'"),
                type == "success" ? "window.location.reload();" : ""
            );

            ClientScript.RegisterStartupScript(this.GetType(), "ShowAlert", script);
        }
    }
}
