using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace hrms_web_application.Employee.Attendance
{
    public partial class Timesheet : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            Session["UserId"] = 36;

            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                load_projects();
                load_timesheets();
            }
        }

        void load_projects()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("getActiveProjects", con);
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();
                ddlProject.DataSource = cmd.ExecuteReader();
                ddlProject.DataTextField = "ProjectName";
                ddlProject.DataValueField = "ProjectId";
                ddlProject.DataBind();
            }

            ddlProject.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Project", ""));
        }

        void load_timesheets()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("GetEmployeeTimesheetDetails", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@userid", Session["UserId"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTimesheet.DataSource = dt;
                gvTimesheet.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("inserttimesheet", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@userid", Session["UserId"]);
                cmd.Parameters.AddWithValue("@projectid", ddlProject.SelectedValue);
                cmd.Parameters.AddWithValue("@date", txtDate.Text);
                cmd.Parameters.AddWithValue("@workhours", txtHours.Text);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            ddlProject.SelectedIndex = 0;
            txtDate.Text = "";
            txtHours.Text = "";

            load_timesheets();
            Response.Redirect(Request.RawUrl);

        }
    }
}
