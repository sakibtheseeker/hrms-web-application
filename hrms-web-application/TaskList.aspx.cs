using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class TaskList : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["Priority"] = "All";
                ViewState["DueDate"] = null;
                LoadData();
            }
        }

        protected void FilterByPriority(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            btnAll.CssClass = "nav-link";
            btnHigh.CssClass = "nav-link";
            btnMedium.CssClass = "nav-link";
            btnLow.CssClass = "nav-link";

            btn.CssClass = "nav-link active";

            ViewState["Priority"] = btn.CommandArgument;
            LoadData();
        }

        protected void FilterByDate(object sender, EventArgs e)
        {
            ViewState["DueDate"] = string.IsNullOrEmpty(txtDueDateFilter.Text)
                ? null
                : (object)Convert.ToDateTime(txtDueDateFilter.Text);

            LoadData();
        }

        private void LoadData()
        {
            List<ProjectTaskVM> data = GetProjectSummary();

            rptProjects.DataSource = data;
            rptProjects.DataBind();

            rptTaskDetails.DataSource = data;
            rptTaskDetails.DataBind();
        }

        private List<ProjectTaskVM> GetProjectSummary()
        {
            List<ProjectTaskVM> list = new List<ProjectTaskVM>();

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Task_ProjectSummary", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Priority", ViewState["Priority"]);
                cmd.Parameters.AddWithValue("@DueDate",
                    ViewState["DueDate"] == null ? DBNull.Value : ViewState["DueDate"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    int total = Convert.ToInt32(dr["TotalTasks"]);
                    int completed = Convert.ToInt32(dr["CompletedTasks"]);
                    decimal percent = Convert.ToDecimal(dr["CompletionPercentage"]);

                    DateTime deadline = Convert.ToDateTime(dr["Deadline"]);

                    list.Add(new ProjectTaskVM
                    {
                        ProjectId = Convert.ToInt32(dr["ProjectId"]),
                        ProjectName = dr["ProjectName"].ToString(),
                        LogoPath = dr["LogoPath"].ToString(),
                        Deadline = deadline,
                        Value = Convert.ToDecimal(dr["Value"]),
                        TotalTasks = total,
                        CompletedTasks = completed,
                        Percentage = Math.Round(percent, 0),
                        CompletionPercentage = Math.Round(percent, 0),
                        TotalHours = CalculateProjectHours(DateTime.Now, deadline)
                    });
                }
            }
            return list;
        }

        private int CalculateProjectHours(DateTime start, DateTime end)
        {
            if (end < start) return 0;
            return (int)(end - start).TotalHours;
        }
    }

    public class ProjectTaskVM
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string LogoPath { get; set; }
        public DateTime Deadline { get; set; }
        public decimal Value { get; set; }
        public int TotalTasks { get; set; }
        public int CompletedTasks { get; set; }
        public decimal Percentage { get; set; }
        public decimal CompletionPercentage { get; set; }
        public int TotalHours { get; set; }
    }
}
