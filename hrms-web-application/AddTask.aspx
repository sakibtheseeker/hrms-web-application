<%@ Page Title="Add Task"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="AddTask.aspx.cs"
    Inherits="hrms_web_application.AddTask" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<!-- REQUIRED for PageMethods -->
<asp:ScriptManager ID="ScriptManager1"
    runat="server"
    EnablePageMethods="true" />

<div class="container mt-4">
    <div class="card p-4">

        <h4 class="mb-4">Add New Task</h4>

        <!-- Title -->
        <div class="mb-3">
            <label class="form-label">Title</label>
            <asp:TextBox ID="txtTitle" runat="server"
                CssClass="form-control" />
        </div>

        <!-- Deadline + Project -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Due Date</label>
                <asp:TextBox ID="txtDeadline" runat="server"
                    CssClass="form-control"
                    TextMode="Date" />
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Select Project</label>
                <asp:DropDownList ID="ddlProject" runat="server"
                    CssClass="form-select"
                    onchange="loadMembers()" />
            </div>
        </div>

        <!-- Team Members -->
        <div class="mb-3">
            <label class="form-label">Team Members</label>

            <div class="dropdown">
                <button type="button"
                    class="btn btn-outline-secondary dropdown-toggle"
                    id="btnMembers"
                    data-bs-toggle="dropdown">
                    Select Team Members
                </button>

                <ul class="dropdown-menu p-2" id="membersList"></ul>
            </div>
        </div>

        <!-- Status + Priority -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server"
                    CssClass="form-select">
                    <asp:ListItem Text="Select" Value="" />
                    <asp:ListItem Text="Pending" />
                    <asp:ListItem Text="Inprogress" />
                    <asp:ListItem Text="Completed" />
                    <asp:ListItem Text="Onhold" />
                </asp:DropDownList>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Priority</label>
                <asp:DropDownList ID="ddlPriority" runat="server"
                    CssClass="form-select">
                    <asp:ListItem Text="Select" Value="" />
                    <asp:ListItem Text="High" />
                    <asp:ListItem Text="Medium" />
                    <asp:ListItem Text="Low" />
                </asp:DropDownList>
            </div>
        </div>

        <!-- Description -->
        <div class="mb-3">
            <label class="form-label">Description</label>
            <asp:TextBox ID="txtDescription" runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                Rows="4" />
        </div>

        <!-- File -->
        <div class="mb-3">
            <label class="form-label">Upload Attachment</label>
            <asp:FileUpload ID="fuFile" runat="server"
                CssClass="form-control" />
        </div>

        <!-- Message -->
        <asp:Label ID="lblMsg" runat="server"
            CssClass="text-danger" />

        <!-- Save -->
        <div class="text-end">
            <asp:Button ID="btnSave" runat="server"
                Text="Add Task"
                CssClass="btn btn-primary"
                OnClick="btnSave_Click" />
        </div>

    </div>
</div>

<!-- PAGE-SPECIFIC SCRIPT -->
<script>
    function loadMembers() {
        var projectId =
            document.getElementById('<%= ddlProject.ClientID %>').value;

        if (!projectId) {
            document.getElementById('membersList').innerHTML = '';
            return;
        }

        PageMethods.GetProjectMembers(
            projectId,
            function (result) {
                var html = "";

                if (result.length === 0) {
                    html = "<li class='dropdown-item text-muted'>No members found</li>";
                } else {
                    for (var i = 0; i < result.length; i++) {
                        html += `
<li class="dropdown-item">
    <input type="checkbox"
           class="form-check-input member-checkbox"
           name="MemberIds"
           value="${result[i].UserId}"
           data-name="${result[i].FullName}" />
    <label class="form-check-label ms-2">${result[i].FullName}</label>
</li>`;
                    }
                }

                document.getElementById('membersList').innerHTML = html;
            },
            function () {
                alert("Error loading team members");
            }
        );
    }

    // keep dropdown open
    document.addEventListener('click', function (e) {
        if (e.target.closest('.dropdown-menu')) {
            e.stopPropagation();
        }
    });

    // update selected names
    document.addEventListener('change', function (e) {
        if (e.target.classList.contains('member-checkbox')) {
            var selected = [];
            document.querySelectorAll('.member-checkbox:checked')
                .forEach(cb => selected.push(cb.dataset.name));

            document.getElementById('btnMembers').innerText =
                selected.length > 0
                    ? selected.join(', ') + " (Selected)"
                    : "Select Team Members";
        }
    });
</script>

</asp:Content>
