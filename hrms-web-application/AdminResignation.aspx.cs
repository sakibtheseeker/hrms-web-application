using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace Solution360
{
    public partial class AdminResignation : Page
    {
        static string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
                LoadResignations();
            }
        }

        void LoadUsers()
        {
            ddlUser.DataSource = GetData("GetAllEmployees");
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "UserId";
            ddlUser.DataBind();
        }

        void LoadResignations()
        {
            gvResignation.DataSource = GetData("GetAllResignations");
            gvResignation.DataBind();
        }

        DataTable GetData(string proc)
        {
            SqlDataAdapter da = new SqlDataAdapter(proc, cs);
            da.SelectCommand.CommandType = CommandType.StoredProcedure;
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int id = string.IsNullOrEmpty(hfResignationId.Value)
                        ? 0
                        : Convert.ToInt32(hfResignationId.Value);

            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("SaveResignation", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@UserId", ddlUser.SelectedValue);
            cmd.Parameters.AddWithValue("@NoticeDate", txtNoticeDate.Text);
            cmd.Parameters.AddWithValue("@ResignDate", txtResignDate.Text);
            cmd.Parameters.AddWithValue("@Reason", txtReason.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            hfResignationId.Value = "";
            LoadResignations();
        }

        protected void gvResignation_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvResignation.PageIndex = e.NewPageIndex;
            LoadResignations();
        }

        // ===== AJAX =====

        [WebMethod]
        public static object GetResignation(int id)
        {
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetResignationById", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            dr.Read();

            var data = new
            {
                ResignationId = id,
                UserId = dr["UserId"].ToString(),
                NoticeDate = Convert.ToDateTime(dr["NoticeDate"]).ToString("yyyy-MM-dd"),
                ResignDate = Convert.ToDateTime(dr["ResignDate"]).ToString("yyyy-MM-dd"),
                Reason = dr["Reason"].ToString()
            };

            con.Close();
            return data;
        }

        [WebMethod]
        public static void DeleteResignationAjax(int id)
        {
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("DeleteResignation", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}