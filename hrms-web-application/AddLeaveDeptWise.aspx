<%@ Page Title="Allocate Leave Deptwise" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="AddLeaveDeptWise.aspx.cs" Inherits="hrms_web_application.Admin.Attendance.Leave.AllocateLeaveDeptWise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Alerts -->
    <asp:PlaceHolder ID="phAlerts" runat="server"></asp:PlaceHolder>

    <div class="card p-4">
        <asp:Panel runat="server" ID="pnlForm">
            <h3 class="text-start mb-4">Allocate Leave Deptwise</h3>

            <div class="mb-3">
    <label for="ddlDepartment">Select Department</label>
    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control"
        DataSourceID="SqlDataSource1" DataTextField="Name" DataValueField="DepartmentId">
    </asp:DropDownList>  
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbconn %>" 
        SelectCommand="SELECT [DepartmentId], [Name] FROM [Departments] WHERE ([Status] = @Status)">
        <SelectParameters>
            <asp:Parameter DefaultValue="Active" Name="Status" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</div>

<div class="mb-3">
    <label for="ddlLeaveType">Select Leave Type</label>
    <asp:DropDownList ID="ddlLeaveType" runat="server" CssClass="form-control"
        DataSourceID="SqlDataSource2" DataTextField="LeaveType" DataValueField="LeaveTypeId">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbconn %>" 
        SelectCommand="SELECT [LeaveTypeId], [LeaveType] FROM [MasterLeaveTypes] WHERE ([status] = @status)">
        <SelectParameters>
            <asp:Parameter DefaultValue="Active" Name="status" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</div>

            <div class="mb-3">
                <label for="txtLeavesCount">Number of Leaves Allocated</label>
                <asp:TextBox ID="txtLeavesCount" runat="server" CssClass="form-control" TextMode="Number" />
            </div>
            <asp:Button ID="Button1" runat="server" CssClass="btn btn-primary" Text="Allocate Leave" OnClick="Btn_click" />
        </asp:Panel>
    </div>

</asp:Content>
