<%@ Page Title="Department Leave Details"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="LeaveDetailsForAdmin.aspx.cs"
    Inherits="hrms_web_application.Employee.Leave.LeaveDetails" %>

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
    DataKeyNames="DepartmentId,LeaveTypeId"
    OnRowCommand="GridView1_RowCommand" AllowPaging="True">

    <Columns>
        <asp:BoundField DataField="DepartmentName" HeaderText="Department" />
        <asp:BoundField DataField="LeaveType" HeaderText="Leave Type" />
        <asp:BoundField DataField="LeavesCount" HeaderText="Leaves Count" />
        <asp:BoundField DataField="Status" HeaderText="Status" />

        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
                <asp:LinkButton ID="lnkDelete"
                    runat="server"
                    CommandName="DeleteLeave"
                    CommandArgument='<%# Container.DataItemIndex %>'
                    OnClientClick="return confirm('Are you sure you want to delete?');">
                    <i class="fa fa-trash text-danger"></i>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:dbconn %>"
            SelectCommand="FeatchDeptLeavesDetails"
            SelectCommandType="StoredProcedure">
        </asp:SqlDataSource>

    </div>
</div>

    </asp:Content>