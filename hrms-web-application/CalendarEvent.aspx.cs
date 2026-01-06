using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class CalendarEvent : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        private DateTime CurrentDate
        {
            get
            {
                if (ViewState["CurrentDate"] != null)
                    return (DateTime)ViewState["CurrentDate"];
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
                LoadCalendar();
                LoadUpcomingEvents();
            }
        }

        private void LoadCalendar()
        {
            EventCalendar.VisibleDate = CurrentDate;

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
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT e.Title, et.Color 
                                   FROM Events e 
                                   INNER JOIN EventTypes et ON e.EventTypeId = et.Id 
                                   WHERE CONVERT(date, e.Date) = @Date 
                                   AND e.Status = 'Active'
                                   ORDER BY e.Title";

                    SqlCommand cmd = new SqlCommand(query, con);
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
                            title.Length > 10 ? title.Substring(0, 10) + "..." : title
                        );

                        cell.Controls.Add(new LiteralControl(eventHtml));
                    }

                    reader.Close();
                    con.Close();
                }
            }
            catch (Exception)
            {
            }
        }

        private void LoadUpcomingEvents()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 10 
                                   e.Title, 
                                   e.Date,
                                   CONVERT(varchar, CAST(e.Date AS date), 106) as FormattedDate,
                                   et.Name as EventTypeName, 
                                   et.Color 
                                   FROM Events e 
                                   INNER JOIN EventTypes et ON e.EventTypeId = et.Id 
                                   WHERE e.Status = 'Active' 
                                   AND CAST(e.Date AS date) >= CAST(GETDATE() AS date)
                                   ORDER BY CAST(e.Date AS date)";

                    SqlDataAdapter da = new SqlDataAdapter(query, con);
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
            }
            catch (Exception)
            {
                lblNoEvents.Visible = true;
                lblNoEvents.Text = "Unable to load events";
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
    }
}