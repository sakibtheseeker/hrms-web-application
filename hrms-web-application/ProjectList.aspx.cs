using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace hrms_web_application
{
    public partial class ProjectList : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["deleteId"] != null)
                {
                    string projectId = Request.QueryString["deleteId"];
                    DeleteProject(projectId);
                }

                ddlStatus.SelectedValue = "All";
                ddlSort.SelectedValue = "Desc";

                LoadProjects();
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadProjects();
        }

        void LoadProjects()
        {
            SqlCommand cmd = new SqlCommand(
                "sp_AllProjects_GetList_FilterSort", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@SortBy", ddlSort.SelectedValue);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            dt.Columns.Add("PriorityText");
            dt.Columns.Add("StatusClass");
            dt.Columns.Add("MembersHtml");

            foreach (DataRow row in dt.Rows)
            {
                int projectId = Convert.ToInt32(row["ProjectId"]);

                string priority = row["Priority"].ToString();
                row["PriorityText"] =
                    priority == "High" ? "text-danger" :
                    priority == "Medium" ? "text-warning" :
                    "text-success";

                row["StatusClass"] =
                    row["Status"].ToString() == "Active"
                    ? "bg-success"
                    : "bg-danger";

                row["MembersHtml"] = GetProjectMembers(projectId);
            }

            rptProjects.DataSource = dt;
            rptProjects.DataBind();
        }

        string GetProjectMembers(int projectId)
        {
            string html = "";
            int count = 0;

            SqlCommand cmd = new SqlCommand(
                "sp_ProjectsUser_GetMembers_ByProjectId", con);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ProjectId", projectId);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                if (count < 3)
                {
                    html += "<img src='/" + dr["ProfilePicture"] +
                            "' class='rounded-circle me-1' width='35' height='35' />";
                }
                count++;
            }

            dr.Close();
            con.Close();

            if (count > 3)
            {
                html += "<span class='badge bg-primary'>+" + (count - 3) + "</span>";
            }

            return html;
        }

        protected void DeleteProject(string projectId)
        {
            SqlCommand cmd = new SqlCommand("sp_SoftDeleteProject", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ProjectId", projectId);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            LoadProjects();
        }

        protected void btnAddProject_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddProject.aspx");
        }
    }
}
