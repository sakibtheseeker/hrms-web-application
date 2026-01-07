using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class AddTask : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProjects();
            }
        }

        
        void LoadProjects()
        {
            SqlCommand cmd = new SqlCommand("sp_Task_GetProjects", con);
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            ddlProject.DataSource = cmd.ExecuteReader();
            ddlProject.DataTextField = "ProjectName";
            ddlProject.DataValueField = "ProjectId";
            ddlProject.DataBind();
            con.Close();

            ddlProject.Items.Insert(0,
                new System.Web.UI.WebControls.ListItem("Select Project", ""));
        }

        
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (txtTitle.Text == "" ||
                ddlProject.SelectedValue == "" ||
                ddlStatus.SelectedValue == "" ||
                ddlPriority.SelectedValue == "")
            {
                lblMsg.Text = "Please fill all required fields.";
                return;
            }

            string filePath = "";

            if (fuFile.HasFile)
            {
                string uploadFolder = Server.MapPath("~/Uploads/Tasks/");

                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                string fileName = Guid.NewGuid().ToString() +
                                  Path.GetExtension(fuFile.FileName);

                string fullPath = Path.Combine(uploadFolder, fileName);

                fuFile.SaveAs(fullPath);

                filePath = "Uploads/Tasks/" + fileName;
            }

            SqlCommand cmd = new SqlCommand("sp_Task_Insert", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@ProjectId", ddlProject.SelectedValue);
            cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
            cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);
            cmd.Parameters.AddWithValue("@FilePath", filePath);
            cmd.Parameters.AddWithValue("@Deadline", txtDeadline.Text);

            con.Open();
            int taskId = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();

            string[] memberIds = Request.Form.GetValues("MemberIds");

            if (memberIds != null)
            {
                foreach (string userId in memberIds)
                {
                    SqlCommand mcmd = new SqlCommand("sp_TaskMember_Insert", con);
                    mcmd.CommandType = CommandType.StoredProcedure;
                    mcmd.Parameters.AddWithValue("@TaskId", taskId);
                    mcmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    mcmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            Response.Redirect("TaskList.aspx");
        }

        
        [WebMethod]
        public static List<MemberVM> GetProjectMembers(int projectId)
        {
            List<MemberVM> list = new List<MemberVM>();
            string conStr = ConfigurationManager.ConnectionStrings["dbconn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Task_GetProjectMembers", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ProjectId", projectId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    list.Add(new MemberVM
                    {
                        UserId = Convert.ToInt32(dr["UserId"]),
                        FullName = dr["FullName"].ToString()
                    });
                }
            }

            return list;
        }
    }

    
    public class MemberVM
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
    }
}