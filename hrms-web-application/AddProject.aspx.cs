using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class AddProject : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(
           ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPriceTypes();
                LoadUsers();      // Team Members
                LoadManagers();   // Only Managers (via SP)
            }
        }

        // -------------------------------
        // LOAD PRICE TYPES
        // -------------------------------
        void LoadPriceTypes()
        {
            ddlPriceType.Items.Clear();
            ddlPriceType.Items.Add("Select Currency Type");
            ddlPriceType.Items.Add("$");
            ddlPriceType.Items.Add("₹");
            ddlPriceType.Items.Add("€");
        }

        // -------------------------------
        // LOAD TEAM MEMBERS (ALL ACTIVE USERS)
        // -------------------------------
        void LoadUsers()
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT UserId, FirstName FROM [User] WHERE Status='Active'", con);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            chkUsers.DataSource = dr;
            chkUsers.DataTextField = "FirstName";
            chkUsers.DataValueField = "UserId";
            chkUsers.DataBind();

            dr.Close();
            con.Close();
        }

        // -------------------------------
        // LOAD MANAGERS (USING STORED PROCEDURE)
        // -------------------------------
        void LoadManagers()
        {
            SqlCommand cmd = new SqlCommand(
                "sp_User_GetManagers", con);

            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            ddlManager.DataSource = dr;
            ddlManager.DataTextField = "FirstName";
            ddlManager.DataValueField = "FirstName";
            // ManagerName column stores name, not ID

            ddlManager.DataBind();

            dr.Close();
            con.Close();

            ddlManager.Items.Insert(0, "Select Project Manager");
        }

        // -------------------------------
        // SAVE BUTTON CLICK
        // -------------------------------
        protected void btnSave_Click(object sender, EventArgs e)
        {
            // 🔴 STEP 1: VALIDATE FORM
            if (!ValidateForm())
            {
                return; // Stop execution if validation fails
            }

            // 🔴 STEP 2: SAVE FILES
            string logoPath = SaveFile(fuLogo);
            string filePath = SaveFile(fuFile);

            // 🔴 STEP 3: INSERT PROJECT (STORED PROCEDURE)
            SqlCommand cmd = new SqlCommand(
                "sp_AllProjects_Insert", con);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@ProjectName", txtProjectName.Text.Trim());
            cmd.Parameters.AddWithValue("@ClientName", txtClientName.Text.Trim());
            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
            cmd.Parameters.AddWithValue("@StartDate", txtStartDate.Text);
            cmd.Parameters.AddWithValue("@EndDate", txtEndDate.Text);
            cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);
            cmd.Parameters.AddWithValue("@ProjectValue", txtProjectValue.Text);
            cmd.Parameters.AddWithValue("@PriceType", ddlPriceType.SelectedValue);
            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@ManagerName", ddlManager.SelectedValue);
            cmd.Parameters.AddWithValue("@LogoPath", logoPath);
            cmd.Parameters.AddWithValue("@FilePath", filePath);

            con.Open();
            int projectId = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();

            // 🔴 STEP 4: SAVE TEAM MEMBERS
            SaveTeamMembers(projectId);

            // 🔴 STEP 5: REDIRECT
            Response.Redirect("ProjectList.aspx");
        }

        // -------------------------------
        // VALIDATIONS (REQUIRED, DATE, NUMERIC)
        // -------------------------------
        bool ValidateForm()
        {
            // Required fields
            if (txtProjectName.Text.Trim() == "")
            {
                ShowAlert("Project Name is required");
                return false;
            }

            if (txtClientName.Text.Trim() == "")
            {
                ShowAlert("Client Name is required");
                return false;
            }

            if (txtDescription.Text.Trim() == "")
            {
                ShowAlert("Description is required");
                return false;
            }

            if (txtStartDate.Text == "")
            {
                ShowAlert("Start Date is required");
                return false;
            }

            if (txtEndDate.Text == "")
            {
                ShowAlert("End Date is required");
                return false;
            }

            if (ddlPriority.SelectedValue == "")
            {
                ShowAlert("Please select Priority");
                return false;
            }

            if (ddlPriceType.SelectedIndex == 0)
            {
                ShowAlert("Please select Price Type");
                return false;
            }

            if (ddlStatus.SelectedValue == "")
            {
                ShowAlert("Please select Status");
                return false;
            }

            if (ddlManager.SelectedIndex == 0)
            {
                ShowAlert("Please select Project Manager");
                return false;
            }

            // Date validation
            DateTime startDate = Convert.ToDateTime(txtStartDate.Text);
            DateTime endDate = Convert.ToDateTime(txtEndDate.Text);

            if (startDate > endDate)
            {
                ShowAlert("Start Date cannot be greater than End Date");
                return false;
            }

            // Numeric validation
            double projectValue;
            if (!double.TryParse(txtProjectValue.Text, out projectValue))
            {
                ShowAlert("Project Value must be numeric");
                return false;
            }

            if (projectValue <= 0)
            {
                ShowAlert("Project Value must be greater than 0");
                return false;
            }

            return true; // All validations passed
        }

        // -------------------------------
        // ALERT MESSAGE
        // -------------------------------
        void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                "alert",
                "alert('" + message + "');",
                true);
        }

        // -------------------------------
        // SAVE TEAM MEMBERS
        // -------------------------------
        void SaveTeamMembers(int projectId)
        {
            foreach (ListItem item in chkUsers.Items)
            {
                if (item.Selected)
                {
                    SqlCommand cmd = new SqlCommand(
                        "INSERT INTO ProjectsUser (ProjectsProjectId, UsersUserId) VALUES (@PId, @UId)", con);

                    cmd.Parameters.AddWithValue("@PId", projectId);
                    cmd.Parameters.AddWithValue("@UId", item.Value);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        // -------------------------------
        // FILE UPLOAD
        // -------------------------------
        string SaveFile(FileUpload fu)
        {
            if (fu.HasFile)
            {
                string folderPath = Server.MapPath("~/Uploads/");

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string fileName = Guid.NewGuid() + "_" + fu.FileName;
                string fullPath = folderPath + fileName;

                fu.SaveAs(fullPath);

                return "Uploads/" + fileName;
            }

            return "";
        }
    }
}