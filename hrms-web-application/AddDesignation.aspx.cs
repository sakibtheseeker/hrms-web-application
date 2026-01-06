using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
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

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        d.DesignationId,
                        d.DepartmentId,
                        dep.Name AS DepartmentName,
                        d.Name,
                        d.NoOfEmployee,
                        d.Status,
                        d.CreatedBy,
                        d.ModifiedBy
                    FROM Designations d
                    INNER JOIN Departments dep ON d.DepartmentId = dep.DepartmentId
                    ORDER BY d.DesignationId DESC", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    list.Add(new DesignationDTO
                    {
                        DesignationId = Convert.ToInt32(dr["DesignationId"]),
                        DepartmentId = Convert.ToInt32(dr["DepartmentId"]),
                        DepartmentName = dr["DepartmentName"].ToString(),
                        Name = dr["Name"].ToString(),
                        NoOfEmployee = dr["NoOfEmployee"] == DBNull.Value ? 0 : Convert.ToInt32(dr["NoOfEmployee"]),
                        Status = dr["Status"].ToString(),
                        CreatedBy = dr["CreatedBy"] == DBNull.Value ? "" : dr["CreatedBy"].ToString(),
                        ModifiedBy = dr["ModifiedBy"] == DBNull.Value ? "" : dr["ModifiedBy"].ToString()
                    });
                }
            }
            return list;
        }

        // ===================== GET DESIGNATION BY ID =====================
        [WebMethod(EnableSession = true)]
        public static DesignationDTO GetDesignationById(int designationId)
        {
            DesignationDTO d = null;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT DesignationId, DepartmentId, Name, Status
                    FROM Designations
                    WHERE DesignationId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", designationId);
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
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
            return d;
        }

        // ===================== ADD DESIGNATION =====================
        [WebMethod(EnableSession = true)]
        public static string AddNewDesignation(int departmentId, string name, string status)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Designations
                        (DepartmentId, Name, Status, NoOfEmployee, CreatedBy, CreatedAt)
                    VALUES
                        (@DepartmentId, @Name, @Status, 0, 'Admin', GETDATE())", con);

                cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                cmd.Parameters.AddWithValue("@Name", name.Trim());
                cmd.Parameters.AddWithValue("@Status", status);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            return "success";
        }

        // ===================== UPDATE DESIGNATION =====================
        [WebMethod(EnableSession = true)]
        public static string UpdateDesignation(int designationId, int departmentId, string name, string status)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE Designations
                    SET DepartmentId = @DepartmentId,
                        Name = @Name,
                        Status = @Status,
                        ModifiedBy = 'Admin',
                        ModifiedAt = GETDATE()
                    WHERE DesignationId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", designationId);
                cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                cmd.Parameters.AddWithValue("@Name", name.Trim());
                cmd.Parameters.AddWithValue("@Status", status);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            return "updated";
        }

        private void LoadDepartments()
        {
            ddlDepartmentAdd.Items.Clear();
            ddlDepartmentEdit.Items.Clear();

            ddlDepartmentAdd.Items.Add(new ListItem("Select Department", ""));
            ddlDepartmentEdit.Items.Add(new ListItem("Select Department", ""));

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT DepartmentId, Name FROM Departments WHERE Status = 'Active' ORDER BY Name",
                    con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    string text = dr["Name"].ToString();
                    string value = dr["DepartmentId"].ToString();

                    ddlDepartmentAdd.Items.Add(new ListItem(text, value));
                    ddlDepartmentEdit.Items.Add(new ListItem(text, value));
                }
            }
        }


        // ===================== TOGGLE STATUS =====================
        [WebMethod(EnableSession = true)]
        public static string ToggleDesignationStatus(int designationId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE Designations
                    SET Status = CASE
                        WHEN Status = 'Active' THEN 'Inactive'
                        ELSE 'Active'
                    END
                    WHERE DesignationId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", designationId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            return "toggled";
        }

        [WebMethod]
        public static string SoftDeleteDesignation(int designationId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            UPDATE Designations
            SET 
                Status = 'Inactive',
                ModifiedBy = 'Admin',
                ModifiedAt = GETDATE()
            WHERE DesignationId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", designationId);
                con.Open();
                cmd.ExecuteNonQuery();
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
