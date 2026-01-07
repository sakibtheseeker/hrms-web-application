<%@ Page Title="Add Project"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="AddProject.aspx.cs"
    Inherits="hrms_web_application.AddProject" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .dropdown-menu {
        max-height: 220px;
        overflow-y: auto;
        width: 100%;
    }
</style>

<div class="container mt-4">
<div class="card p-4">

    <h3 class="mb-4">Add Project</h3>

    <!-- Project Name -->
    <div class="mb-3">
        <label class="form-label">Project Name</label>
        <asp:TextBox ID="txtProjectName" runat="server" CssClass="form-control" />
    </div>

    <!-- Client Name -->
    <div class="mb-3">
        <label class="form-label">Client Name</label>
        <asp:TextBox ID="txtClientName" runat="server" CssClass="form-control" />
    </div>

    <!-- Description -->
    <div class="mb-3">
        <label class="form-label">Description</label>
        <asp:TextBox ID="txtDescription" runat="server"
            TextMode="MultiLine" Rows="4"
            CssClass="form-control" />
    </div>

    <!-- Start Date -->
    <div class="mb-3">
        <label class="form-label">Start Date</label>
        <asp:TextBox ID="txtStartDate" runat="server"
            TextMode="Date" CssClass="form-control" />
    </div>

    <!-- End Date -->
    <div class="mb-3">
        <label class="form-label">End Date</label>
        <asp:TextBox ID="txtEndDate" runat="server"
            TextMode="Date" CssClass="form-control" />
    </div>

    <!-- Priority -->
    <div class="mb-3">
        <label class="form-label">Priority</label>
        <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select">
            <asp:ListItem Text="Select Priority" Value="" />
            <asp:ListItem Text="High" />
            <asp:ListItem Text="Medium" />
            <asp:ListItem Text="Low" />
        </asp:DropDownList>
    </div>

    <!-- Project Value -->
    <div class="mb-3">
        <label class="form-label">Project Value</label>
        <asp:TextBox ID="txtProjectValue" runat="server" CssClass="form-control" />
    </div>

    <!-- Price Type -->
    <div class="mb-3">
        <label class="form-label">Price Type</label>
        <asp:DropDownList ID="ddlPriceType" runat="server" CssClass="form-select" />
    </div>

    <!-- Status -->
    <div class="mb-3">
        <label class="form-label">Status</label>
        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
            <asp:ListItem Text="Select Status" Value="" />
            <asp:ListItem Text="Active" />
            <asp:ListItem Text="Inactive" />
        </asp:DropDownList>
    </div>

    <!-- Team Members -->
    <div class="mb-3">
        <label class="form-label">Team Members</label>

        <div class="dropdown">
            <button type="button"
                class="btn btn-outline-secondary dropdown-toggle w-100"
                data-bs-toggle="dropdown">
                Select Team Members
            </button>

            <div class="dropdown-menu p-2">
                <asp:CheckBoxList ID="chkUsers"
                    runat="server"
                    CssClass="form-check">
                </asp:CheckBoxList>
            </div>
        </div>
    </div>

    <!-- Project Manager -->
    <div class="mb-3">
        <label class="form-label">Project Manager</label>
        <asp:DropDownList ID="ddlManager" runat="server" CssClass="form-select" />
    </div>

    <!-- Project Logo -->
    <div class="mb-3">
        <label class="form-label">Upload Project Logo</label>
        <asp:FileUpload ID="fuLogo" runat="server" CssClass="form-control" />
    </div>

    <!-- Upload File -->
    <div class="mb-3">
        <label class="form-label">Upload File</label>
        <asp:FileUpload ID="fuFile" runat="server" CssClass="form-control" />
    </div>

    <!-- Save Button -->
    <div class="text-end mt-4">
        <asp:Button ID="btnSave" runat="server"
            Text="Save"
            CssClass="btn btn-primary"
            OnClick="btnSave_Click" />
    </div>

</div>
</div>

</asp:Content>
