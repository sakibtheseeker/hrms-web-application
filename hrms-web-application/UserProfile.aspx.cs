using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class UserProfile : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            
            int profileUserId;

            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            int loggedInUserId = Convert.ToInt32(Session["UserId"]);
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    profileUserId = Convert.ToInt32(Request.QueryString["id"]);
                }
                else
                {
                    profileUserId = loggedInUserId; // employee opening own profile
                }

                // 🔒 Security: employee can view ONLY self
                int roleId = Convert.ToInt32(Session["RoleId"]);
                if (roleId != 3 && profileUserId != loggedInUserId)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                hdnUserId.Value = profileUserId.ToString();

                LoadProfile(profileUserId);
                LoadBankDetails(profileUserId);
                LoadEducation(profileUserId);
                LoadFamilyDetails(profileUserId);
                LoadExperience(profileUserId); 
                
            }
        }

        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (Session["RoleId"] == null)
                return;

            int roleId = Convert.ToInt32(Session["RoleId"]);

            // 1 = Admin, 2 = HR, 3 = Employee
            if (roleId == 3)
            {
                this.MasterPageFile = "~/EmployeeMaster.master";
            }
            else
            {
                this.MasterPageFile = "~/AdminMaster.master";
            }
        }


        protected void btnSaveBank_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(hdnUserId.Value);

            string bankName = txtAddBankName.Text.Trim();
            string accountNo = txtAddAccountNo.Text.Trim();
            string ifsc = txtAddIFSC.Text.Trim();
            string branch = txtAddBranch.Text.Trim();

            if (bankName == "" || accountNo == "" || ifsc == "" || branch == "")
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(),
                    "alert",
                    "alert('All bank fields are required');",
                    true
                );
                return;
            }

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("AddEmployeeBankDetails", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@BankName", bankName);
                    cmd.Parameters.AddWithValue("@AccountNumber", accountNo);
                    cmd.Parameters.AddWithValue("@IFSCCode", ifsc);
                    cmd.Parameters.AddWithValue("@BranchName", branch);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Reload bank list
            LoadBankDetails(userId);

            // Clear fields
            txtAddBankName.Text = "";
            txtAddAccountNo.Text = "";
            txtAddIFSC.Text = "";
            txtAddBranch.Text = "";

            ScriptManager.RegisterStartupScript(
                this, GetType(),
                "success",
                "$('#addBankDetailsModal').modal('hide'); alert('Bank details saved');",
                true
            );
        }

        protected void btnSaveEducation_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(hdnUserId.Value);

            string university = txtAddUniversity.Text.Trim();
            string course = txtAddCourse.Text.Trim();

            if (university == "" || course == "")
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(),
                    "alert",
                    "alert('University and Course are required');",
                    true
                );
                return;
            }

            DateTime startDate, endDate;
            DateTime.TryParse(txtAddEduStart.Text, out startDate);
            DateTime.TryParse(txtAddEduEnd.Text, out endDate);

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("AddEducationDetails", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@EducationType", course);
                    cmd.Parameters.AddWithValue("@UniversityName", university);
                    cmd.Parameters.AddWithValue(
                        "@StartDate",
                        startDate == DateTime.MinValue ? (object)DBNull.Value : startDate
                    );
                    cmd.Parameters.AddWithValue(
                        "@EndDate",
                        endDate == DateTime.MinValue ? (object)DBNull.Value : endDate
                    );
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Reload education list
            LoadEducation(userId);

            // Clear inputs
            txtAddUniversity.Text = "";
            txtAddCourse.Text = "";
            txtAddEduStart.Text = "";
            txtAddEduEnd.Text = "";

            ScriptManager.RegisterStartupScript(
                this, GetType(),
                "eduSaved",
                "$('#addEducationDetailsModal').modal('hide'); alert('Education added successfully');",
                true
            );
        }


        protected void btnSaveExperience_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(hdnUserId.Value);

            DateTime fromDate;
            DateTime toDate;

            DateTime.TryParse(txtAddExpFrom.Text, out fromDate);

            // ✅ If currently working → set ToDate = FromDate (or DateTime.Now)
            if (chkCurrentJob.Checked || string.IsNullOrWhiteSpace(txtAddExpTo.Text))
            {
                toDate = fromDate; // or DateTime.Now
            }
            else
            {
                DateTime.TryParse(txtAddExpTo.Text, out toDate);
            }

            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AddExperienceDetails", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CompanyName", txtAddCompany.Text.Trim());
                    cmd.Parameters.AddWithValue("@DesignationName", txtAddDesignation.Text.Trim());
                    cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    cmd.Parameters.AddWithValue("@ToDate", toDate);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LoadExperience(userId);

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "expSaved",
                "$('#addExperienceDetailsModal').modal('hide');",
                true
            );
        }


        protected void btnSaveFamily_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(hdnUserId.Value);

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("AddEmployeeFamilyDetails", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Name", txtAddFamilyName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Relation", txtAddRelation.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtAddFamilyPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    if (DateTime.TryParse(txtAddFamilyDOB.Text, out DateTime dob))
                        cmd.Parameters.AddWithValue("@DateOfBirth", dob);
                    else
                        cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LoadFamilyDetails();

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "familySaved",
                "$('#addFamilyDetailsModal').modal('hide'); alert('Family member added');",
                true
            );
        }


        private void LoadFamilyDetails()
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetFamilyDetailsByUser", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue(
                        "@UserId",
                        Convert.ToInt32(hdnUserId.Value)
                    );

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptFamilyDetails.DataSource = dt;
                    rptFamilyDetails.DataBind();
                }
            }
        }


        private void LoadProfile(int userId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetUserProfileById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            // 🔹 Top profile section
                            lblUserId.Text = dr["UserId"].ToString();
                            lblFullName.Text = dr["FirstName"] + " " + dr["LastName"];
                            lblEmail.Text = dr["Email"].ToString();
                            lblPhone.Text = dr["PhoneNumber"].ToString();
                            lblGender.Text = dr["Gender"]?.ToString();
                            lblAddress.Text = dr["Address"]?.ToString();

                            lblDepartment.Text = dr["DepartmentName"]?.ToString();
                            lblDesignation.Text = dr["DesignationName"]?.ToString();
                            lblReportManager.Text = dr["ReportingManager"]?.ToString();

                            lblDOJ.Text = dr["DateOfJoining"] == DBNull.Value
                                ? "-"
                                : Convert.ToDateTime(dr["DateOfJoining"])
                                    .ToString("dd MMM yyyy");

                            lblDOB.Text = dr["DateOfBirth"] == DBNull.Value
                                ? "-"
                                : Convert.ToDateTime(dr["DateOfBirth"])
                                    .ToString("dd MMM yyyy");

                            lblAbout.Text = dr["Address"]?.ToString();

                            // 🔹 Profile Image
                            if (dr["ProfilePicture"] != DBNull.Value &&
                                !string.IsNullOrEmpty(dr["ProfilePicture"].ToString()))
                            {
                                imgProfile.ImageUrl = dr["ProfilePicture"].ToString();
                                imgEditProfile.ImageUrl = dr["ProfilePicture"].ToString();
                            }
                            else
                            {
                                imgProfile.ImageUrl = "/assets/img/profiles/default.png";
                                imgEditProfile.ImageUrl = "/assets/img/profiles/default.png";
                            }

                            // 🔹 Hidden field for edits
                            hdnUserId.Value = dr["UserId"].ToString();

                            // 🔹 Edit modal prefill
                            txtFirstName.Text = dr["FirstName"].ToString();
                            txtLastName.Text = dr["LastName"].ToString();
                            txtEmail.Text = dr["Email"].ToString();
                            txtPhone.Text = dr["PhoneNumber"].ToString();
                            txtAddress.Text = dr["Address"]?.ToString();
                            txtDOB.Text = dr["DateOfBirth"] == DBNull.Value
                                ? ""
                                : Convert.ToDateTime(dr["DateOfBirth"])
                                    .ToString("dd/MM/yyyy");
                            txtAbout.Text = dr["Address"]?.ToString();
                        }
                    }
                }
            }
        }

        private void LoadExperience(int userId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetExperienceByUser", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@UserId", userId);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptExperience.DataSource = dt;
                    rptExperience.DataBind();
                }
            }
        }


        private void LoadFamilyDetails(int userId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetFamilyDetailsByUserId", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@UserId", userId);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptFamilyDetails.DataSource = dt;
                    rptFamilyDetails.DataBind();
                }
            }
        }


        private void LoadBankDetails(int userId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetBankDetailsByUserId", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@UserId", userId);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptBankDetails.DataSource = dt;
                    rptBankDetails.DataBind();
                }
            }
        }


        private void LoadEducation(int userId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("GetEducationDetailsByUserId", con))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@UserId", userId);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptEducation.DataSource = dt;
                    rptEducation.DataBind();
                }
            }
        }


        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(hdnUserId.Value);

            string profileImagePath = null;

            // 🔹 Handle Profile Image Upload
            if (fuProfilePicture.HasFile)
            {
                // 1️⃣ Get extension safely
                string ext = System.IO.Path.GetExtension(fuProfilePicture.FileName).ToLower();

                // 2️⃣ Allow only images (VERY IMPORTANT)
                string[] allowedExt = { ".jpg", ".jpeg", ".png" };
                if (!allowedExt.Contains(ext))
                {
                    ScriptManager.RegisterStartupScript(
                        this, GetType(),
                        "imgErr",
                        "alert('Only JPG, JPEG, PNG images are allowed');",
                        true);
                    return;
                }

                // 3️⃣ Standardized filename
                string fileName = $"user_{userId}{ext}";

                // 4️⃣ Web + Physical path
                string relativePath = "/Content/uploads/" + fileName;
                string physicalPath = Server.MapPath("~" + relativePath);

                // 5️⃣ Ensure folder exists
                string folderPath = Server.MapPath("~/Content/uploads/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                // 6️⃣ Overwrite old image safely
                fuProfilePicture.SaveAs(physicalPath);

                // 7️⃣ Save clean path to DB
                profileImagePath = relativePath;
            }


            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("UpdateUserProfile", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@PhoneNumber", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@DateOfBirth", DateTime.Parse(txtDOB.Text));
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@AboutEmployee", txtAbout.Text.Trim());

                    // ✅ Always send parameter
                    cmd.Parameters.AddWithValue(
                        "@ProfilePicture",
                        string.IsNullOrEmpty(profileImagePath)
                            ? (object)DBNull.Value
                            : profileImagePath
                    );


                    if (profileImagePath != null)
                    {
                        cmd.Parameters.AddWithValue("@ProfilePicture", profileImagePath);
                    }

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // ✅ Reload data
                LoadUserProfile();

                // ✅ Show success modal
                ScriptManager.RegisterStartupScript(this, GetType(),
                    "success", "$('#success_modal').modal('show');", true);
            }
        }

        private void LoadUserProfile()
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetUserProfileBasicById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue(
                        "@UserId",
                        Convert.ToInt32(hdnUserId.Value)
                    );

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblFullName.Text = dr["FirstName"] + " " + dr["LastName"];
                            lblEmail.Text = dr["Email"].ToString();
                            lblPhone.Text = dr["PhoneNumber"].ToString();
                            lblGender.Text = dr["Gender"]?.ToString();
                            lblDOB.Text = dr["DateOfBirth"]?.ToString();
                            lblAddress.Text = dr["Address"]?.ToString();
                            lblAbout.Text = dr["AboutEmployee"]?.ToString();

                            txtFirstName.Text = dr["FirstName"].ToString();
                            txtLastName.Text = dr["LastName"].ToString();
                            txtEmail.Text = dr["Email"].ToString();
                            txtPhone.Text = dr["PhoneNumber"].ToString();
                            txtAbout.Text = dr["AboutEmployee"]?.ToString();

                            if (dr["ProfilePicture"] != DBNull.Value &&
                                !string.IsNullOrWhiteSpace(dr["ProfilePicture"].ToString()))
                            {
                                string imgPath = dr["ProfilePicture"].ToString().Trim();

                                // normalize path
                                if (!imgPath.StartsWith("/"))
                                    imgPath = "/" + imgPath;

                                imgProfile.ImageUrl = ResolveUrl(imgPath);
                                imgEditProfile.ImageUrl = ResolveUrl(imgPath);
                            }
                            else
                            {
                                imgProfile.ImageUrl = ResolveUrl("/assets/img/profiles/default.png");
                                imgEditProfile.ImageUrl = ResolveUrl("/assets/img/profiles/default.png");
                            }
                        }
                    }
                }
            }
        }

    }
}
