using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace hrms_web_application
{
    public partial class AddDesignation : System.Web.UI.Page
    {
        private static readonly string cs =
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDepartments();
            }
        }

        // ===================== FETCH DESIGNATIONS =====================
        [WebMethod(EnableSession = true)]
        [System.Web.Script.Services.ScriptMethod(
            ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
        public static List<DesignationDTO> GetDesignations()
        {
            List<DesignationDTO> list = new List<DesignationDTO>();

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetAllDesignations", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            list.Add(new DesignationDTO
                            {
                                DesignationId = Convert.ToInt32(dr["DesignationId"]),
                                DepartmentId = Convert.ToInt32(dr["DepartmentId"]),
                                DepartmentName = dr["DepartmentName"].ToString(),
                                Name = dr["Name"].ToString(),
                                NoOfEmployee = Convert.ToInt32(dr["NoOfEmployee"]),
                                Status = dr["Status"].ToString(),
                                CreatedBy = dr["CreatedBy"].ToString(),
                                ModifiedBy = dr["ModifiedBy"].ToString()
                            });
                        }
                    }
                }
            }

            return list;
        }


        // ===================== GET DESIGNATION BY ID =====================
        [WebMethod(EnableSession = true)]
        public static DesignationDTO GetDesignationById(int designationId)
        {
            DesignationDTO d = null;

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetDesignationById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DesignationId", designationId);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            d = new DesignationDTO
                            {
                                DesignationId = Convert.ToInt32(dr["DesignationId"]),
                                DepartmentId = Convert.ToInt32(dr["DepartmentId"]),
                                Name = dr["Name"].ToString(),
                                Status = dr["Status"].ToString()
                            };
                        }
                    }
                }
            }

            return d;
        }


        // ===================== ADD DESIGNATION =====================
        [WebMethod(EnableSession = true)]
        public static string AddNewDesignation(int departmentId, string name, string status)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("AddNewDesignation", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                    cmd.Parameters.AddWithValue("@Name", name.Trim());
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue(
                        "@CreatedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "success";
        }


        // ===================== UPDATE DESIGNATION =====================
        [WebMethod(EnableSession = true)]
        public static string UpdateDesignation(int designationId, int departmentId, string name, string status)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("UpdateDesignation", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@DesignationId", designationId);
                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                    cmd.Parameters.AddWithValue("@Name", name.Trim());
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue(
                        "@ModifiedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "updated";
        }


        private void LoadDepartments()
        {
            ddlDepartmentAdd.Items.Clear();
            ddlDepartmentEdit.Items.Clear();

            ddlDepartmentAdd.Items.Add(new ListItem("Select Department", ""));
            ddlDepartmentEdit.Items.Add(new ListItem("Select Department", ""));

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetActiveDepartmentsForDropdown", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            string text = dr["Name"].ToString();
                            string value = dr["DepartmentId"].ToString();

                            ddlDepartmentAdd.Items.Add(new ListItem(text, value));
                            ddlDepartmentEdit.Items.Add(new ListItem(text, value));
                        }
                    }
                }
            }
        }



        // ===================== TOGGLE STATUS =====================
        [WebMethod(EnableSession = true)]
        public static string ToggleDesignationStatus(int designationId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("ToggleDesignationStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@DesignationId", designationId);
                    cmd.Parameters.AddWithValue(
                        "@ModifiedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "toggled";
        }


        [WebMethod]
        public static string SoftDeleteDesignation(int designationId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("SoftDeleteDesignation", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@DesignationId", designationId);
                    cmd.Parameters.AddWithValue(
                        "@ModifiedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "inactive";
        }


        // ===================== DTO =====================
        public class DesignationDTO
        {
            public int DesignationId { get; set; }
            public int DepartmentId { get; set; }
            public string DepartmentName { get; set; }
            public string Name { get; set; }
            public int NoOfEmployee { get; set; }
            public string Status { get; set; }
            public string CreatedBy { get; set; }
            public string ModifiedBy { get; set; }
        }
    }
}
