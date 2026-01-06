<%@ Page Title="Department Leave Details"
    Language="C#"
    MasterPageFile="~/EmployeeMaster.Master"
    AutoEventWireup="true"
    CodeBehind="LeaveDetailsForEmployee.aspx.cs"
    Inherits="hrms_web_application.LeaveDetailsForEmployee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="card">
    <div class="card-header">
        <h5>Department Leave Details</h5>
    </div>

    <div class="card-body">

        <asp:GridView ID="GridView1" runat="server"
            AutoGenerateColumns="False"
            CssClass="table table-bordered table-striped"
            DataSourceID="SqlDataSource1"
            AllowPaging="True">

            <Columns>
                <asp:BoundField DataField="DepartmentName" HeaderText="Department" />
                <asp:BoundField DataField="LeaveType" HeaderText="Leave Type" />
                <asp:BoundField DataField="LeavesCount" HeaderText="Leaves Count" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>

        </asp:GridView>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:Pulse360DB %>"
            SelectCommand="FeatchDeptLeavesDetails"
            SelectCommandType="StoredProcedure">
        </asp:SqlDataSource>

    </div>
</div>

</asp:Content>
