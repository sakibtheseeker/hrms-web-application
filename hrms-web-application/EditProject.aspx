<%@ Page Title="Edit Project"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="EditProject.aspx.cs"
    Inherits="hrms_web_application.EditProject" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<asp:HiddenField ID="hfProjectId" runat="server" />
<asp:HiddenField ID="hfOldLogoPath" runat="server" />
<asp:HiddenField ID="hfOldFilePath" runat="server" />

<div class="container mt-4">
<div class="card p-4">

<h3 class="mb-3">Edit Project</h3>

<label class="form-label">Project Name</label>
<asp:TextBox ID="txtProjectName" runat="server" CssClass="form-control mb-2" />

<label class="form-label">Client Name</label>
<asp:TextBox ID="txtClientName" runat="server" CssClass="form-control mb-2" />

<label class="form-label">Description</label>
<asp:TextBox ID="txtDescription" runat="server"
    TextMode="MultiLine" Rows="3"
    CssClass="form-control mb-2" />

<label class="form-label">Start Date</label>
<asp:TextBox ID="txtStartDate" runat="server"
    TextMode="Date" CssClass="form-control mb-2" />

<label class="form-label">End Date</label>
<asp:TextBox ID="txtEndDate" runat="server"
    TextMode="Date" CssClass="form-control mb-2" />

<label class="form-label">Priority</label>
<asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select mb-2">
    <asp:ListItem Value="">Select Priority</asp:ListItem>
    <asp:ListItem>High</asp:ListItem>
    <asp:ListItem>Medium</asp:ListItem>
    <asp:ListItem>Low</asp:ListItem>
</asp:DropDownList>

<label class="form-label">Project Value</label>
<asp:TextBox ID="txtProjectValue" runat="server" CssClass="form-control mb-2" />

<label class="form-label">Status</label>
<asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select mb-3">
    <asp:ListItem Value="">Select Status</asp:ListItem>
    <asp:ListItem>Active</asp:ListItem>
    <asp:ListItem>Inactive</asp:ListItem>
</asp:DropDownList>

<!-- TEAM MEMBERS -->
<label class="form-label">Team Members</label>
<div class="dropdown mb-3">
    <button type="button"
        class="btn btn-outline-secondary dropdown-toggle w-100"
        id="dropdownMenuButton"
        data-bs-toggle="dropdown">
        Select Team Members
    </button>

    <ul class="dropdown-menu w-100 p-2">
        <asp:Repeater ID="rptUsers" runat="server">
            <ItemTemplate>
                <li class="dropdown-item">
                    <input type="checkbox"
                           class="team-checkbox"
                           value="<%# Eval("UserId") %>"
                           <%# Convert.ToBoolean(Eval("IsSelected")) ? "checked" : "" %> />
                    <label class="ms-2"><%# Eval("FirstName") %></label>
                </li>
            </ItemTemplate>
        </asp:Repeater>
    </ul>
</div>

<label class="form-label">Project Manager</label>
<asp:DropDownList ID="ddlManager" runat="server" CssClass="form-select mb-3" />

<label class="form-label">Logo (Optional)</label>
<asp:FileUpload ID="fuLogo" runat="server" CssClass="form-control mb-2" />

<label class="form-label">File (Optional)</label>
<asp:FileUpload ID="fuFile" runat="server" CssClass="form-control mb-3" />

<asp:Button ID="btnUpdate" runat="server"
    Text="Save Changes"
    CssClass="btn btn-primary"
    OnClick="btnUpdate_Click" />

</div>
</div>

<!-- PAGE-SPECIFIC SCRIPT -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const btn = document.getElementById('dropdownMenuButton');
        const boxes = document.querySelectorAll('.team-checkbox');

        function updateText() {
            const names = [];
            boxes.forEach(b => {
                if (b.checked) {
                    names.push(b.nextElementSibling.innerText);
                }
            });
            btn.textContent = names.length
                ? names.join(', ') + ' (Selected)'
                : 'Select Team Members';
        }

        boxes.forEach(b => b.addEventListener('change', updateText));
        updateText();
    });
</script>

</asp:Content>
