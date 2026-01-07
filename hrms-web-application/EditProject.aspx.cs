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
    public partial class EditProject : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id = Convert.ToInt32(Request.QueryString["id"]);
                hfProjectId.Value = id.ToString();

                LoadManagers();
                LoadProject(id);
                LoadUsers(id);
            }
        }

        void LoadProject(int id)
        {
            SqlCommand cmd = new SqlCommand("sp_AllProjects_GetById", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ProjectId", id);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                txtProjectName.Text = dr["ProjectName"].ToString();
                txtClientName.Text = dr["ClientName"].ToString();
                txtDescription.Text = dr["Description"].ToString();
                txtStartDate.Text = Convert.ToDateTime(dr["StartDate"]).ToString("yyyy-MM-dd");
                txtEndDate.Text = Convert.ToDateTime(dr["EndDate"]).ToString("yyyy-MM-dd");
                ddlPriority.SelectedValue = dr["Priority"].ToString();
                txtProjectValue.Text = dr["ProjectValue"].ToString();
                ddlStatus.SelectedValue = dr["Status"].ToString();
                ddlManager.SelectedValue = dr["ManagerName"].ToString();

                hfOldLogoPath.Value = dr["LogoPath"].ToString();
                hfOldFilePath.Value = dr["FilePath"].ToString();
            }
            dr.Close();
            con.Close();
        }

        void LoadManagers()
        {
            SqlCommand cmd = new SqlCommand("sp_User_GetManagers", con);
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            ddlManager.DataSource = cmd.ExecuteReader();
            ddlManager.DataTextField = "FirstName";
            ddlManager.DataValueField = "FirstName";
            ddlManager.DataBind();
            con.Close();

            ddlManager.Items.Insert(0, "Select Manager");
        }

        void LoadUsers(int projectId)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("UserId");
            dt.Columns.Add("FirstName");
            dt.Columns.Add("IsSelected", typeof(bool));

            SqlCommand cmd = new SqlCommand("sp_User_GetAllActive", con);
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
                dt.Rows.Add(dr["UserId"], dr["FirstName"], false);
            dr.Close();
            con.Close();

            SqlCommand sel = new SqlCommand("sp_ProjectsUser_GetByProjectId", con);
            sel.CommandType = CommandType.StoredProcedure;
            sel.Parameters.AddWithValue("@ProjectId", projectId);

            con.Open();
            SqlDataReader dr2 = sel.ExecuteReader();
            while (dr2.Read())
            {
                foreach (DataRow r in dt.Rows)
                    if (r["UserId"].ToString() == dr2["UsersUserId"].ToString())
                        r["IsSelected"] = true;
            }
            dr2.Close();
            con.Close();

            rptUsers.DataSource = dt;
            rptUsers.DataBind();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!ValidateForm()) return;

            string logoPath = hfOldLogoPath.Value;
            string filePath = hfOldFilePath.Value;

            if (fuLogo.HasFile)
            {
                logoPath = "Uploads/Logos/" + Guid.NewGuid() + "_" + fuLogo.FileName;
                fuLogo.SaveAs(Server.MapPath("~/" + logoPath));
            }

            if (fuFile.HasFile)
            {
                filePath = "Uploads/Files/" + Guid.NewGuid() + "_" + fuFile.FileName;
                fuFile.SaveAs(Server.MapPath("~/" + filePath));
            }

            SqlCommand cmd = new SqlCommand("sp_AllProjects_Update", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@ProjectId", hfProjectId.Value);
            cmd.Parameters.AddWithValue("@ProjectName", txtProjectName.Text);
            cmd.Parameters.AddWithValue("@ClientName", txtClientName.Text);
            cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
            cmd.Parameters.AddWithValue("@StartDate", txtStartDate.Text);
            cmd.Parameters.AddWithValue("@EndDate", txtEndDate.Text);
            cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);
            cmd.Parameters.AddWithValue("@ProjectValue", txtProjectValue.Text);
            cmd.Parameters.AddWithValue("@PriceType", "INR");
            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@ManagerName", ddlManager.SelectedValue);
            cmd.Parameters.AddWithValue("@LogoPath", logoPath);
            cmd.Parameters.AddWithValue("@FilePath", filePath);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            SqlCommand del = new SqlCommand("sp_ProjectsUser_DeleteByProjectId", con);
            del.CommandType = CommandType.StoredProcedure;
            del.Parameters.AddWithValue("@ProjectId", hfProjectId.Value);
            con.Open();
            del.ExecuteNonQuery();
            con.Close();

            var users = Request.Form.GetValues("Users");
            if (users != null)
            {
                foreach (string u in users)
                {
                    SqlCommand ins = new SqlCommand(
                        "INSERT INTO ProjectsUser VALUES (@P,@U)", con);
                    ins.Parameters.AddWithValue("@P", hfProjectId.Value);
                    ins.Parameters.AddWithValue("@U", u);
                    con.Open();
                    ins.ExecuteNonQuery();
                    con.Close();
                }
            }

            Response.Redirect("ProjectList.aspx");
        }

        bool ValidateForm()
        {
            if (txtProjectName.Text == "") return Alert("Project Name required");
            if (txtClientName.Text == "") return Alert("Client Name required");

            DateTime s, e;
            if (!DateTime.TryParse(txtStartDate.Text, out s) ||
                !DateTime.TryParse(txtEndDate.Text, out e))
                return Alert("Invalid dates");

            if (s > e) return Alert("Start Date cannot be greater than End Date");

            double val;
            if (!double.TryParse(txtProjectValue.Text, out val) || val <= 0)
                return Alert("Invalid Project Value");

            return true;
        }

        bool Alert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(),
                "alert", "alert('" + msg + "');", true);
            return false;
        }
    }
}
