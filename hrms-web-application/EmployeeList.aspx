
<%@ Page Title="Employee List" Language="C#" MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true" CodeBehind="EmployeeList.aspx.cs" Inherits="hrms_web_application.EmployeeList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .cursor-pointer {
            cursor: pointer;
        }
    </style>
    <div class="content">
        <!-- Page Header -->
        <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
            <div class="my-auto mb-2">
                <h2 class="mb-1">Employee List</h2>
            </div>
            <div class="d-flex my-xl-auto right-content align-items-center flex-wrap gap-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                    <i class="ti ti-plus me-1"></i>Add Employee
                </button>
                <div class="btn-group ms-3" role="group">
                    <button type="button" id="btnListView" class="btn btn-outline-secondary active">
                        <i class="ti ti-list"></i> List
                    </button>
                    <button type="button" id="btnGridView" class="btn btn-outline-secondary">
                        <i class="ti ti-layout-grid"></i> Grid
                    </button>
                </div>
            </div>
        </div>

        <!-- Stats Card -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center overflow-hidden">
                            <div>
                                <span class="avatar avatar-lg bg-dark rounded-circle"><i class="ti ti-users"></i></span>
                            </div>
                            <div class="ms-2 overflow-hidden">
                                <p><strong>Total Active:</strong> <asp:Label ID="lblActiveCount" runat="server"></asp:Label></p>
                                <p><strong>Inactive:</strong> <asp:Label ID="lblInactiveCount" runat="server"></asp:Label></p>
                                <p><strong>Total Members:</strong> <asp:Label ID="lblTotalCount" runat="server"></asp:Label></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- List View with DataTables -->
        <div id="listView">
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="employeeTable" class="table table-hover table-bordered" style="width:100%">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Profile</th>
                                    <th>First Name</th>
                                    <th>Last Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Role</th>
                                    <th>Department</th>
                                    <th>Designation</th>
                                    <th>Manager</th>
                                    <th>DOJ</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptEmployeesTable" runat="server" >
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("UserId") %></td>
                                            <td>
                                                <img src='<%# String.IsNullOrEmpty(Eval("ProfilePicture").ToString()) ? "~/assets/img/users/default.jpg" : Eval("ProfilePicture") %>'
                                                     class="avatar avatar-sm rounded-circle" alt="Profile" />
                                            </td>
                                            <td><%# Eval("FirstName") %></td>
                                            <td><%# Eval("LastName") %></td>
                                            <td><%# Eval("Email") %></td>
                                            <td><%# Eval("PhoneNumber") %></td>
                                            <td><%# Eval("RoleName") %></td>
                                            <td><%# Eval("DepartmentName") %></td>
                                            <td><%# Eval("DesignationName") %></td>
                                            <td><%# Eval("ReportingManagerName") %></td>
                                            <td><%# Eval("DateOfJoining", "{0:dd MMM yyyy}") %></td>
                                            <td>
                                               <span class="badge toggle-status cursor-pointer
                                                    <%# Eval("Status").ToString() == "Active" ? "bg-success" : "bg-danger" %>"
                                                    data-id="<%# Eval("UserId") %>"
                                                    title="Click to change status">
                                                    <%# Eval("Status") %>
                                                </span>

                                            </td>
                                            <td>
                                                <a href='UserProfile.aspx?id=<%# Eval("UserId") %>' 
                                                   class="btn btn-sm btn-info me-1">
                                                   <i class="ti ti-eye"></i>
                                                </a>

                                               <button type="button"
                                                class="btn btn-sm toggle-status 
                                                <%# Eval("Status").ToString() == "Active" ? "btn-danger" : "btn-success" %>"
                                                data-id="<%# Eval("UserId") %>">
                                                <i class="ti ti-trash"></i>
                                            </button>





                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Grid View -->
        <div id="gridView" class="row g-4" style="display: none;">
            <asp:Repeater ID="rptEmployeesGrid" runat="server">
                <ItemTemplate>
                    <div class="col-xl-3 col-lg-4 col-md-6">
                        <div class="card employee-card h-100 shadow-sm border-0">
                            <div class="card-body text-center p-4">
                                <div class="avatar avatar-xl mb-3 mx-auto">
                                    <img src='<%# String.IsNullOrEmpty(Eval("ProfilePicture").ToString()) ? "~/assets/img/users/default.jpg" : Eval("ProfilePicture") %>'
                                         class="rounded-circle w-100 h-100" alt="Profile" />
                                </div>
                                <h5><%# Eval("FirstName") %> <%# Eval("LastName") %></h5>
                                <p class="text-muted small"><%# Eval("DesignationName") %></p>
                                <p class="text-muted small"><%# Eval("DepartmentName") %></p>
                                <span class="badge <%# Eval("Status").ToString() == "Active" ? "bg-success" : "bg-danger" %> mb-3">
                                    <%# Eval("Status") %>
                                </span>
                                <div class="d-flex justify-content-center gap-2">
                                    <a href='UserProfile.aspx?id=<%# Eval("UserId") %>' class="btn btn-sm btn-info">
                                        <i class="ti ti-eye"></i> View
                                    </a>
                                 <button type="button"
                                class="btn btn-sm toggle-status <%# Eval("Status").ToString() == "Active" ? "btn-danger" : "btn-success" %>"
                                data-id="<%# Eval("UserId") %>"
                                title="<%# Eval("Status").ToString() == "Active" ? "Deactivate Employee" : "Activate Employee" %>">

                                <i class="ti <%# Eval("Status").ToString() == "Active"
                                    ? "ti-trash"
                                    : "ti-rotate-clockwise" %>"></i>
                            </button>


                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- Add Employee Modal with UpdatePanel -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Add New Employee</h4>
                    <span class="ms-3">Employee ID: <asp:Label ID="lblNewEmpId" runat="server" Text="EMP-0024"></asp:Label></span>
                    <button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal"><i class="ti ti-x"></i></button>
                </div>

                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label>Profile Image</label>
                                    <asp:FileUpload ID="fuProfilePicture" CssClass="form-control" runat="server" />
                                </div>
                                <div class="col-md-6"><div class="mb-3"><label>First Name <span class="text-danger">*</span></label><asp:TextBox ID="txtFirstName" CssClass="form-control" runat="server" /></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Last Name</label><asp:TextBox ID="txtLastName" CssClass="form-control" runat="server" /></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Email <span class="text-danger">*</span></label><asp:TextBox ID="txtEmail" CssClass="form-control" runat="server" TextMode="Email" /></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Joining Date <span class="text-danger">*</span></label><asp:TextBox ID="txtDOJ" CssClass="form-control datetimepicker" runat="server" /></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Date of Birth <span class="text-danger">*</span></label><asp:TextBox ID="txtDOB" CssClass="form-control datetimepicker" runat="server" /></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Password <span class="text-danger">*</span></label><asp:TextBox ID="txtPassword" CssClass="form-control" TextMode="Password" runat="server" /></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Phone Number <span class="text-danger">*</span></label><asp:TextBox ID="txtPhone" CssClass="form-control" runat="server" /></div></div>

                                <div class="col-md-6"><div class="mb-3"><label>Role</label><asp:DropDownList ID="ddlRole" CssClass="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRole_SelectedIndexChanged"></asp:DropDownList></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Department</label><asp:DropDownList ID="ddlDepartment" CssClass="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged"></asp:DropDownList></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Designation</label><asp:DropDownList ID="ddlDesignation" CssClass="form-control" runat="server"></asp:DropDownList></div></div>

                                <div class="col-md-6" id="managerContainer" runat="server" visible="false">
                                    <div class="mb-3">
                                        <label>Reporting Manager</label>
                                        <asp:DropDownList ID="ddlManager" CssClass="form-control" runat="server"></asp:DropDownList>
                                        <asp:HiddenField ID="hdnManagerName" runat="server" />
                                    </div>
                                </div>

                                <div class="col-md-6"><div class="mb-3"><label>Status</label><asp:DropDownList ID="ddlStatusAdd" CssClass="form-control" runat="server"><asp:ListItem>Active</asp:ListItem><asp:ListItem>Inactive</asp:ListItem></asp:DropDownList></div></div>
                                <div class="col-md-6"><div class="mb-3"><label>Gender</label><asp:DropDownList ID="ddlGender" CssClass="form-control" runat="server"><asp:ListItem>Male</asp:ListItem><asp:ListItem>Female</asp:ListItem></asp:DropDownList></div></div>

                                <div class="col-md-12"><div class="mb-3"><label>Address <span class="text-danger">*</span></label><asp:TextBox ID="txtAddress" CssClass="form-control" TextMode="MultiLine" Rows="3" runat="server" /></div></div>
                                <div class="col-md-12"><div class="mb-3"><label>About</label><asp:TextBox ID="txtAbout" CssClass="form-control" TextMode="MultiLine" Rows="3" runat="server" /></div></div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-light border me-2" data-bs-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnSaveEmployee" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveEmployee_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlDepartment" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="ddlRole" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="btnSaveEmployee" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <!-- DataTables Scripts -->
    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.bootstrap5.min.css" />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.print.min.js"></script>
    <script>
        $(document).on("click", ".toggle-status", function () {

            if (!confirm("Change employee status?")) return;

            var userId = $(this).data("id");
            var btn = $(this);

            $.ajax({
                type: "POST",
                url: "EmployeeList.aspx/ToggleEmployeeStatus",
                data: JSON.stringify({ userId: userId }),
                contentType: "application/json; charset=utf-8",
                success: function () {

                    // Find badge in same row/card
                    var badge = btn.closest("tr").find(".badge");
                    if (badge.length === 0) {
                        badge = btn.closest(".employee-card").find(".badge");
                    }

                    // Determine current state
                    var isActive = badge.text().trim() === "Active";

                    // Toggle badge
                    badge.text(isActive ? "Inactive" : "Active")
                        .removeClass("bg-success bg-danger")
                        .addClass(isActive ? "bg-danger" : "bg-success");

                    // Toggle button color
                    btn.removeClass("btn-success btn-danger")
                        .addClass(isActive ? "btn-success" : "btn-danger");

                    // Toggle icon
                    btn.find("i")
                        .removeClass("ti-trash ti-rotate-clockwise")
                        .addClass(isActive ? "ti-rotate-clockwise" : "ti-trash");
                }
,
                error: function () {
                    alert("Failed to update status");
                }
            });
        });
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            var table = $('#employeeTable').DataTable({
                dom: 'Bfrtip',
                buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                pageLength: 10,
                order: [[2, 'asc']]
            });

            // Toggle Views
            $("#btnListView").click(function () {
                $("#listView").show();
                $("#gridView").hide();
                $(this).addClass("active");
                $("#btnGridView").removeClass("active");
                table.columns.adjust();
            });

            $("#btnGridView").click(function () {
                $("#listView").hide();
                $("#gridView").show();
                $(this).addClass("active");
                $("#btnListView").removeClass("active");
            });

            // Keep modal open after async postback
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                $('#exampleModal').modal('show');
            });
        });
    </script>
</asp:Content>