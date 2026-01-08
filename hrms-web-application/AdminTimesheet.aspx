<%@ Page Title="Admin Timesheet Management"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="AdminTimesheet.aspx.cs"
    Inherits="hrms_web_application.Admin.AdminTimesheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="content">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Admin Timesheet Management</h2>

        <div class="dropdown">
            <button class="btn btn-white dropdown-toggle" data-bs-toggle="dropdown">
                Export
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li>
                    <asp:LinkButton ID="btnExportPdf" runat="server"
                        CssClass="dropdown-item"
                        OnClick="btnExportPdf_Click">
                        Export as PDF
                    </asp:LinkButton>
                </li>
                <li>
                    <asp:LinkButton ID="btnExportExcel" runat="server"
                        CssClass="dropdown-item"
                        OnClick="btnExportExcel_Click">
                        Export as Excel
                    </asp:LinkButton>
                </li>
            </ul>
        </div>
    </div>

    <div class="mb-3">
        <asp:Button ID="btnApprove" runat="server"
            Text="Approve Selected"
            CssClass="btn btn-success me-2"
            OnClick="btnApprove_Click" />

        <asp:Button ID="btnReject" runat="server"
            Text="Reject Selected"
            CssClass="btn btn-danger"
            OnClick="btnReject_Click" />
    </div>

    <asp:GridView ID="gvTimesheet" runat="server"
        CssClass="table table-hover"
        AutoGenerateColumns="false"
        AllowPaging="true"
        PageSize="5"
        DataKeyNames="TimesheetId"
        OnPageIndexChanging="gvTimesheet_PageIndexChanging">

        <Columns>

            <asp:TemplateField>
                <HeaderTemplate>
                    <input type="checkbox" onclick="toggleAll(this)" />
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="chkRow" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="EmployeeName" HeaderText="Employee" />
            <asp:BoundField DataField="ProjectName" HeaderText="Project" />
            <asp:BoundField DataField="WorkHours" HeaderText="Hours" />

            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class='badge <%# GetStatusClass(Eval("Status").ToString()) %>'>
                        <%# Eval("Status") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>

</div>

<script>
    function toggleAll(src) {
        document.querySelectorAll("input[id*='chkRow']")
            .forEach(x => x.checked = src.checked);
    }
</script>

</asp:Content>
